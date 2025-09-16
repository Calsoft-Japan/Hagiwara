codeunit 50016 "Inventory Trace Management"
{
    //Important! TODO!
    //"Item Description" is a standard field for latest BC,
    //but currently, the runtime version is not latest of BC, so this field can't be refenced.
    //all the references of this field should be comment out last.

    Permissions = TableData "Item Ledger Entry" = rimd;

    trigger OnRun()
    begin
        BatchCreateInvTraceEntry();
    end;

    var
        GRecInventorySetup: Record "Inventory Setup";
        GRecGeneralLedgerSetup: Record "General Ledger Setup";
        GQty_sumITE: Decimal;
        GCnt_newITE: Integer;

    procedure BatchCreateInvTraceEntry()
    var
        RecItemLedgerEntry: Record "Item Ledger Entry";
    begin
        GRecInventorySetup.GET();
        IF NOT GRecInventorySetup."Enable Inventory Trace" THEN
            EXIT;

        IF GRecInventorySetup."ITE Start Date" = 0D THEN
            EXIT;

        GRecGeneralLedgerSetup.GET();
        CLEAR(GCnt_newITE);

        RecItemLedgerEntry.RESET();
        RecItemLedgerEntry.SETCURRENTKEY("Posting Date");
        RecItemLedgerEntry.SETFILTER("Item No.", GRecInventorySetup."ITE Item No. Filter");
        RecItemLedgerEntry.SETFILTER("Manufacturer Code", GRecInventorySetup."ITE Manufacturer Code Filter");
        RecItemLedgerEntry.SETRANGE("ITE Collected", FALSE);
        RecItemLedgerEntry.SETFILTER("Posting Date", '%1..', GRecInventorySetup."ITE Start Date");
        IF GRecInventorySetup."ITE End Date" <> 0D THEN
            RecItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', GRecInventorySetup."ITE Start Date", GRecInventorySetup."ITE End Date");

        IF RecItemLedgerEntry.FINDSET() THEN
            REPEAT
                GQty_sumITE := 0;
                InsertInventoryTraceEntry(RecItemLedgerEntry);
            UNTIL RecItemLedgerEntry.NEXT() = 0;

        RecItemLedgerEntry.MODIFYALL("ITE Collected", TRUE);

        //BG019
        //OptmPatternD();
        //BG019
    end;

    procedure InsertInventoryTraceEntry(RecItemLedgerEntry: Record "Item Ledger Entry")
    var
        RecItemApplicationEntry: Record "Item Application Entry";
        RecInventoryTraceEntry: Record "Inventory Trace Entry";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecItem: Record "Item";
        RecCustomer: Record "Customer";
        RecPurchasePrice: Record "Price List Line";
        RecVendor: Record "Vendor";
        RecPurchRcptHeader: Record "Purch. Rcpt. Header";
        RecSalesShipmentHeader: Record "Sales Shipment Header";
        RecSalesShipmentLine: Record "Sales Shipment Line";
        RecReturnReceiptLine: Record "Return Receipt Line";
        RecReturnReceiptHeader: Record "Return Receipt Header";
        TempInventoryTraceEntry: Record "Inventory Trace Entry";
        TempItemLedgerEntry: Record "Item Ledger Entry";
        TempItemApplicationEntry: Record "Item Application Entry";
        ItemLedgerEntryNo: Integer;
        DocumentNo: Integer;
        QtyApply: Decimal;
        QtyApplied: Decimal;
        IsBreak: Boolean;
        IsSpecPtn: Code[10];
        SpecPtnCount: Integer;
        SpecPtnQtySum: Decimal;
        SpecPtnIAENo: Text;
        SpecPtnPurchPO: Text;
        SpecPtnPurchPOCount: Integer;
        SpecPtnITE_TempRec: Record "Inventory Trace Entry" temporary;
        SpecPtnITE_PO_TempRec: Record "Inventory Trace Entry" temporary;
        SpecPtn_RemainQty: Decimal;
        SpecPtn_SalesRtnRcpt_Count: Integer;
        SpecPtn_ITE_Count: Integer;
        SpecPtn_SalesQty: Decimal;
        Qty_PtnD: Decimal;
    begin
        ItemLedgerEntryNo := RecItemLedgerEntry."Entry No.";

        //IsSpecPtn possible code:
        //B: Pattern B.
        //C: Special C.
        IsSpecPtn := '';

        //Pattern: B
        SpecPtnCount := 0;
        SpecPtnQtySum := 0;
        SpecPtnIAENo := '';
        SpecPtn_ITE_Count := 0;
        SpecPtnITE_PO_TempRec.RESET();
        SpecPtnITE_PO_TempRec.DELETEALL();
        SpecPtnITE_TempRec.RESET();
        SpecPtnITE_TempRec.DELETEALL();

        RecItemApplicationEntry.RESET();
        RecItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
        IF RecItemApplicationEntry.FINDFIRST() THEN BEGIN
            IF RecItemApplicationEntry."Outbound Item Entry No." > RecItemApplicationEntry."Inbound Item Entry No." THEN BEGIN
                IsSpecPtn := 'B';
            END;
        END;

        IF IsSpecPtn = 'B' THEN BEGIN

            //B Step1: FIFO.
            TempInventoryTraceEntry.RESET();
            //TempInventoryTraceEntry.SETCURRENTKEY("Posting Date","Purch. Item No.","Document Type","Entry Type");
            TempInventoryTraceEntry.SETCURRENTKEY("Posting Date", "Item No");
            TempInventoryTraceEntry.SETRANGE("Calc. Rem. Qty.", TRUE);
            TempInventoryTraceEntry.SETFILTER("Remaining Quantity", '>%1', 0);
            IF RecItemLedgerEntry."Applies-to Entry" <> 0 THEN BEGIN
                //In case that Item Ledger Entry. Applies-to Entry is not 0
                TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", RecItemLedgerEntry."Applies-to Entry");

                IF TempInventoryTraceEntry.FINDSET() THEN
                    REPEAT
                        SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                        SpecPtnITE_TempRec.INSERT();
                    UNTIL TempInventoryTraceEntry.NEXT() = 0;

            END ELSE IF RecItemLedgerEntry."Document Type" <> RecItemLedgerEntry."Document Type"::"Transfer Receipt" THEN BEGIN
                //In case that Item Ledger Entry. Applies-to Entry is 0 AND Document Type is NOT Transfer Receipt
                //TempInventoryTraceEntry.SETRANGE("Purch. Item No.", RecItemLedgerEntry."Item No.");
                TempInventoryTraceEntry.SETFILTER("Item No", RecItemLedgerEntry."Item No.");
                TempInventoryTraceEntry.SETFILTER("Posting Date", '..%1', RecItemLedgerEntry."Posting Date");
                TempInventoryTraceEntry.SETRANGE("Location Code", RecItemLedgerEntry."Location Code");
                //TempInventoryTraceEntry.SETRANGE(Pattern, 'A1');
                TempInventoryTraceEntry.SETRANGE("Calc. Rem. Qty.", TRUE);


                IF TempInventoryTraceEntry.FINDSET() THEN
                    REPEAT
                        SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                        SpecPtnITE_TempRec.INSERT();

                        TempInventoryTraceEntry.CALCFIELDS("Remaining Quantity");
                        SpecPtnQtySum := SpecPtnQtySum + TempInventoryTraceEntry."Remaining Quantity";
                    //BG018
                    //UNTIL (TempInventoryTraceEntry.NEXT() = 0) OR (SpecPtnQtySum > ABS(RecItemLedgerEntry.Quantity));
                    UNTIL TempInventoryTraceEntry.NEXT() = 0
                //BG018

            END ELSE BEGIN
                //In case that Item Ledger Entry. Applies-to Entry is 0 AND Document Type is Transfer Receipt

                RecItemApplicationEntry.RESET();
                RecItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
                IF RecItemApplicationEntry.FINDSET THEN
                    REPEAT
                        TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", RecItemApplicationEntry."Inbound Item Entry No.");

                        IF TempInventoryTraceEntry.FINDSET() THEN
                            REPEAT
                                SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                                SpecPtnITE_TempRec.INSERT();
                            UNTIL TempInventoryTraceEntry.NEXT() = 0;

                    UNTIL RecItemApplicationEntry.NEXT = 0;

            END;

            //Create ITE based on ILE Quantity and Inbound ITE with Remaining Qty.
            IsBreak := FALSE;
            QtyApplied := 0;
            QtyApply := RecItemLedgerEntry.Quantity;

            SpecPtnITE_TempRec.RESET();
            SpecPtnITE_TempRec.SETCURRENTKEY("Posting Date");
            IF SpecPtnITE_TempRec.FINDSET() THEN
                REPEAT
                    SpecPtnITE_TempRec.CALCFIELDS("Remaining Quantity");
                    //SpecPtn_RemainQty := SpecPtnITE_TempRec."Remaining Quantity";
                    IF SpecPtnITE_TempRec.Quantity < SpecPtnITE_TempRec."Remaining Quantity" THEN BEGIN
                        SpecPtn_RemainQty := SpecPtnITE_TempRec.Quantity;
                    END ELSE BEGIN
                        SpecPtn_RemainQty := SpecPtnITE_TempRec."Remaining Quantity";
                    END;
                    IF SpecPtn_RemainQty > 0 THEN BEGIN

                        RecInventoryTraceEntry.RESET();
                        RecInventoryTraceEntry.INIT();
                        RecInventoryTraceEntry."Entry No." := 0;
                        RecInventoryTraceEntry."Item Application Entry No." := 9999999;
                        RecInventoryTraceEntry."Item Ledger Entry No." := ItemLedgerEntryNo;

                        RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                        RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                        RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";
                        RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                        RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                        //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO

                        IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                            RecItem.GET(RecInventoryTraceEntry."Item No");
                        END;

                        RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                        RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                        RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                        RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";

                        IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                            RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                        END;
                        RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;

                        RecPurchasePrice.RESET();
                        RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                        RecPurchasePrice.SETCURRENTKEY("Starting Date");
                        RecPurchasePrice.ASCENDING(FALSE);
                        RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                        IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                            RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                        END;


                        IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Posted Assembly" THEN BEGIN
                            RecInventoryTraceEntry."Ship&Debit Flag" := SpecPtnITE_TempRec."Ship&Debit Flag";
                            RecInventoryTraceEntry."New Ship&Debit Flag" := SpecPtnITE_TempRec."New Ship&Debit Flag";
                        END;

                        IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                            RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                        END;
                        RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                        IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                            RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                        END;
                        RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                        RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                        RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";
                        RecInventoryTraceEntry."Incoming Item Ledger Entry No." := SpecPtnITE_TempRec."Incoming Item Ledger Entry No.";
                        RecInventoryTraceEntry."Purchase Order No." := SpecPtnITE_TempRec."Purchase Order No.";
                        RecInventoryTraceEntry."Purch. Item No." := SpecPtnITE_TempRec."Purch. Item No.";
                        RecInventoryTraceEntry."Purch. Item Vendor No." := SpecPtnITE_TempRec."Purch. Item Vendor No.";
                        RecInventoryTraceEntry."Purch. Item Vendor Name" := SpecPtnITE_TempRec."Purch. Item Vendor Name";
                        RecInventoryTraceEntry."Purch. Item Manufacturer Code" := SpecPtnITE_TempRec."Purch. Item Manufacturer Code";
                        RecInventoryTraceEntry."Purch. Hagiwara Group" := SpecPtnITE_TempRec."Purch. Hagiwara Group";
                        RecInventoryTraceEntry."Cost Currency" := SpecPtnITE_TempRec."Cost Currency";
                        RecInventoryTraceEntry."Direct Unit Cost" := SpecPtnITE_TempRec."Direct Unit Cost";
                        RecInventoryTraceEntry."New Cost Currency" := SpecPtnITE_TempRec."New Cost Currency";
                        RecInventoryTraceEntry."New Direct Unit Cost" := SpecPtnITE_TempRec."New Direct Unit Cost";
                        RecInventoryTraceEntry."PC. Cost Currency" := SpecPtnITE_TempRec."PC. Cost Currency";
                        RecInventoryTraceEntry."PC. Direct Unit Cost" := SpecPtnITE_TempRec."PC. Direct Unit Cost";
                        RecInventoryTraceEntry."PC. Entry No." := SpecPtnITE_TempRec."PC. Entry No."; //T20250508.0050
                        RecInventoryTraceEntry."New PC. Cost Currency" := SpecPtnITE_TempRec."New PC. Cost Currency";
                        RecInventoryTraceEntry."New PC. Direct Unit Cost" := SpecPtnITE_TempRec."New PC. Direct Unit Cost";

                        RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";

                        IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
                            RecSalesShipmentLine.RESET();
                            RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                            IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                                RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
                                RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
                                RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
                            END;

                            IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
                            END;
                        END;

                        IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                            RecReturnReceiptLine.RESET();
                            RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                            IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
                                RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
                            END;

                            IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
                            END;
                        END;

                        IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
                            RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code";
                        END;

                        IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                            RecInventoryTraceEntry."Original Document No." := SpecPtnITE_TempRec."Original Document No.";
                            RecInventoryTraceEntry."Original Document Line No." := SpecPtnITE_TempRec."Original Document Line No.";
                        END;

                        //sign of B.
                        //QtyApply(ILE/IAE): <0
                        //QtyApplied(ITE): >0
                        IF ABS(QtyApplied + SpecPtn_RemainQty) < ABS(QtyApply) THEN BEGIN
                            RecInventoryTraceEntry.Quantity := SpecPtn_RemainQty * -1;
                        END ELSE BEGIN
                            RecInventoryTraceEntry.Quantity := QtyApply + QtyApplied;
                            IsBreak := TRUE;
                        END;
                        QtyApplied := QtyApplied + RecInventoryTraceEntry.Quantity * -1;

                        RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price" * -1;
                        RecInventoryTraceEntry.Note := COPYSTR(SpecPtnIAENo, 1, 250);
                        RecInventoryTraceEntry.Pattern := 'B';
                        ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                        RecInventoryTraceEntry.INSERT();
                    END; //SpecPtn_RemainQty > 0

                UNTIL (SpecPtnITE_TempRec.NEXT() = 0) OR IsBreak;

            //  //B Step2: use recent PO.
            //  IF ABS(QtyApplied) < ABS(QtyApply) THEN BEGIN
            //    IsBreak:=FALSE;
            //    SpecPtnITE_TempRec.RESET();
            //    SpecPtnITE_TempRec.DELETEALL();
            //
            //    //part1: Purchase Receipt
            //    TempInventoryTraceEntry.RESET();
            //    TempInventoryTraceEntry.SETCURRENTKEY("Posting Date","Item No");
            //    TempInventoryTraceEntry.SETFILTER("Posting Date", '<%1', RecItemLedgerEntry."Posting Date");
            //    TempInventoryTraceEntry.SETFILTER("Item No", RecItemLedgerEntry."Item No.");
            //    TempInventoryTraceEntry.SETRANGE("Calc. Rem. Qty.",TRUE);
            //
            //    IF TempInventoryTraceEntry.FINDSET() THEN
            //      REPEAT
            //        SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
            //        SpecPtnITE_TempRec.INSERT();
            //      UNTIL TempInventoryTraceEntry.NEXT() = 0;
            //
            //    SpecPtnITE_TempRec.RESET();
            //    SpecPtnITE_TempRec.ASCENDING(FALSE);
            //    SpecPtnITE_TempRec.SETCURRENTKEY("Posting Date");
            //    IF SpecPtnITE_TempRec.FINDSET() THEN
            //      REPEAT
            //        SpecPtn_RemainQty := SpecPtnITE_TempRec.Quantity;
            //        IF SpecPtn_RemainQty > 0 THEN BEGIN
            //
            //          RecInventoryTraceEntry.RESET();
            //          RecInventoryTraceEntry.INIT();
            //          RecInventoryTraceEntry."Entry No." := 0;
            //          RecInventoryTraceEntry."Item Application Entry No." := 9999999;
            //          RecInventoryTraceEntry."Item Ledger Entry No." := ItemLedgerEntryNo;
            //
            //          RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
            //          RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
            //          RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";
            //          RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
            //          RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
            //          RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description";
            //
            //          IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
            //            RecItem.GET(RecInventoryTraceEntry."Item No");
            //          END;
            //          RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
            //          RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
            //          RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
            //          RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";
            //
            //          IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
            //            RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
            //          END;
            //          RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;
            //
            //          RecPurchasePrice.RESET();
            //          RecPurchasePrice.SETRANGE("Asset No.",RecInventoryTraceEntry."Item No");
            //          RecPurchasePrice.SETCURRENTKEY("Starting Date");
            //          RecPurchasePrice.ASCENDING(FALSE);
            //          RecPurchasePrice.SETFILTER("Starting Date",'<=%1',RecInventoryTraceEntry."Posting Date");
            //          IF RecPurchasePrice.FINDFIRST() THEN BEGIN
            //            RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
            //            RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
            //          END;
            //
            //          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Posted Assembly" THEN BEGIN
            //            RecInventoryTraceEntry."Ship&Debit Flag" := SpecPtnITE_TempRec."Ship&Debit Flag";
            //            RecInventoryTraceEntry."New Ship&Debit Flag" := SpecPtnITE_TempRec."New Ship&Debit Flag";
            //          END;
            //
            //          IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
            //            RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
            //          END;
            //          RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;
            //
            //          IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
            //            RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
            //          END;
            //          RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
            //          RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";
            //
            //          RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";
            //          RecInventoryTraceEntry."Incoming Item Ledger Entry No." := SpecPtnITE_TempRec."Incoming Item Ledger Entry No.";
            //          RecInventoryTraceEntry."Purchase Order No." := SpecPtnITE_TempRec."Purchase Order No.";
            //          RecInventoryTraceEntry."Purch. Item No." := SpecPtnITE_TempRec."Purch. Item No.";
            //          RecInventoryTraceEntry."Purch. Item Vendor No." := SpecPtnITE_TempRec."Purch. Item Vendor No.";
            //          RecInventoryTraceEntry."Purch. Item Vendor Name" := SpecPtnITE_TempRec."Purch. Item Vendor Name";
            //          RecInventoryTraceEntry."Purch. Item Manufacturer Code" := SpecPtnITE_TempRec."Purch. Item Manufacturer Code";
            //          RecInventoryTraceEntry."Purch. Hagiwara Group" := SpecPtnITE_TempRec."Purch. Hagiwara Group";
            //          RecInventoryTraceEntry."Cost Currency" := SpecPtnITE_TempRec."Cost Currency";
            //          RecInventoryTraceEntry."Direct Unit Cost" := SpecPtnITE_TempRec."Direct Unit Cost";
            //          RecInventoryTraceEntry."New Cost Currency" := SpecPtnITE_TempRec."New Cost Currency";
            //          RecInventoryTraceEntry."New Direct Unit Cost" := SpecPtnITE_TempRec."New Direct Unit Cost";
            //          RecInventoryTraceEntry."PC. Cost Currency" := SpecPtnITE_TempRec."PC. Cost Currency";
            //          RecInventoryTraceEntry."PC. Direct Unit Cost" := SpecPtnITE_TempRec."PC. Direct Unit Cost";
            //          RecInventoryTraceEntry."New PC. Cost Currency" := SpecPtnITE_TempRec."New PC. Cost Currency";
            //          RecInventoryTraceEntry."New PC. Direct Unit Cost" := SpecPtnITE_TempRec."New PC. Direct Unit Cost";
            //
            //          RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";
            //
            //          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
            //            RecSalesShipmentLine.RESET();
            //            RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.",RecInventoryTraceEntry."Item Ledger Entry No.");
            //            IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
            //              RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
            //              RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
            //              RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
            //            END;
            //
            //            IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
            //              RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
            //            END;
            //          END;
            //
            //          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
            //            RecReturnReceiptLine.RESET();
            //            RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.",RecInventoryTraceEntry."Item Ledger Entry No.");
            //            IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
            //              RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
            //            END;
            //
            //            IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
            //              RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
            //            END;
            //          END;
            //
            //          IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
            //            RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code";
            //          END;
            //
            //          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
            //              RecInventoryTraceEntry."Original Document No." := SpecPtnITE_TempRec."Original Document No.";
            //              RecInventoryTraceEntry."Original Document Line No." := SpecPtnITE_TempRec."Original Document Line No.";
            //          END;
            //
            //          //sign of B.
            //          //QtyApply(ILE/IAE): <0
            //          //QtyApplied(ITE): >0
            //          IF ABS(QtyApplied + SpecPtn_RemainQty) < ABS(QtyApply) THEN BEGIN
            //            RecInventoryTraceEntry.Quantity:= SpecPtn_RemainQty * -1;
            //          END ELSE BEGIN
            //            RecInventoryTraceEntry.Quantity:= QtyApply + QtyApplied;
            //            IsBreak := TRUE;
            //          END;
            //          QtyApplied := QtyApplied + RecInventoryTraceEntry.Quantity * -1;
            //
            //          RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price" * -1;
            //          RecInventoryTraceEntry.Note := COPYSTR(SpecPtnIAENo, 1, 250);
            //          RecInventoryTraceEntry.Pattern := 'B';
            //          ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
            //          RecInventoryTraceEntry.INSERT();
            //        END; //SpecPtn_RemainQty > 0
            //
            //      UNTIL (SpecPtnITE_TempRec.NEXT() = 0) OR IsBreak;
            //
            //  END; //B Step2: use recent PO.


        END; // End B.

        //Special pattern: C
        SpecPtn_SalesRtnRcpt_Count := 0;
        SpecPtn_ITE_Count := 0;
        SpecPtnITE_PO_TempRec.RESET();
        SpecPtnITE_PO_TempRec.DELETEALL();
        SpecPtnITE_TempRec.RESET();
        SpecPtnITE_TempRec.DELETEALL();
        IF IsSpecPtn <> 'B' THEN BEGIN

            //"Sales Return Receipt" ILE with same "Outbound Item Entry No." are more than 1 data.
            //And, related ITE are more than 1 data.
            RecItemApplicationEntry.RESET();
            RecItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
            IF RecItemApplicationEntry.FINDSET() THEN
                REPEAT
                    IF (RecItemApplicationEntry."Outbound Item Entry No." > 0)
                      AND (RecItemApplicationEntry."Outbound Item Entry No." < RecItemApplicationEntry."Inbound Item Entry No.") THEN BEGIN
                        TempItemApplicationEntry.RESET();
                        TempItemApplicationEntry.SETRANGE("Outbound Item Entry No.", RecItemApplicationEntry."Outbound Item Entry No.");
                        IF TempItemApplicationEntry.FINDSET() THEN
                            REPEAT
                                // BG015
                                //TempItemLedgerEntry.GET(TempItemApplicationEntry."Inbound Item Entry No.");
                                //IF TempItemLedgerEntry."Document Type" = TempItemLedgerEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                                IF RecItemLedgerEntry."Document Type" = RecItemLedgerEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                                    // BG015
                                    SpecPtn_SalesRtnRcpt_Count := SpecPtn_SalesRtnRcpt_Count + 1;
                                END;
                            UNTIL TempItemApplicationEntry.NEXT() = 0;

                        IF SpecPtn_SalesRtnRcpt_Count > 1 THEN BEGIN
                            TempInventoryTraceEntry.RESET();
                            TempInventoryTraceEntry.SETCURRENTKEY("Item Ledger Entry No.");
                            TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", RecItemApplicationEntry."Outbound Item Entry No.");
                            IF TempInventoryTraceEntry.COUNT() > 1 THEN BEGIN
                                IsSpecPtn := 'C';
                            END;
                        END;
                    END;

                    //Remember Purchase Order No. to Temporary Table.
                    IF IsSpecPtn = 'C' THEN BEGIN
                        TempInventoryTraceEntry.RESET();
                        TempInventoryTraceEntry.SETCURRENTKEY("Item Ledger Entry No.");
                        TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", RecItemApplicationEntry."Outbound Item Entry No.");
                        IF TempInventoryTraceEntry.FINDSET() THEN
                            REPEAT
                                SpecPtnITE_PO_TempRec.RESET();
                                //BG016
                                //Actuall we dont need SpecPtnITE_PO_TempRec Variable any more but keep using avoid any risk.
                                //SpecPtnITE_PO_TempRec.SETRANGE("Purchase Order No.", TempInventoryTraceEntry."Purchase Order No.");
                                SpecPtnITE_PO_TempRec.SETRANGE("Item Ledger Entry No.", TempInventoryTraceEntry."Item Ledger Entry No.");
                                //BG016
                                IF SpecPtnITE_PO_TempRec.ISEMPTY() THEN BEGIN
                                    SpecPtnITE_PO_TempRec.COPY(TempInventoryTraceEntry);
                                    SpecPtnITE_PO_TempRec.INSERT();
                                END;
                            UNTIL TempInventoryTraceEntry.NEXT() = 0;
                    END;

                UNTIL RecItemApplicationEntry.NEXT() = 0;

        END;

        IF IsSpecPtn = 'C' THEN BEGIN

            //Sales Return Receipt should use Sales Shipment ITE which Quantity is not applied yet.
            SpecPtnITE_PO_TempRec.RESET();
            IF SpecPtnITE_PO_TempRec.FINDSET() THEN
                REPEAT
                    TempInventoryTraceEntry.RESET();
                    //BG016
                    //TempInventoryTraceEntry.SETRANGE("Purchase Order No.", SpecPtnITE_PO_TempRec."Purchase Order No.");
                    //TempInventoryTraceEntry.SETRANGE("Document Type", TempInventoryTraceEntry."Document Type"::"Sales Shipment");
                    //TempInventoryTraceEntry.SETRANGE("Entry Type", TempInventoryTraceEntry."Entry Type"::Sale);
                    //TempInventoryTraceEntry.SETRANGE("Purch. Item No.", SpecPtnITE_PO_TempRec."Purch. Item No.");
                    TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", RecItemApplicationEntry."Outbound Item Entry No.");
                    //BG016

                    IF TempInventoryTraceEntry.FINDSET() THEN
                        REPEAT
                            TempInventoryTraceEntry.CALCFIELDS("Sales Quantity");
                            TempInventoryTraceEntry.CALCFIELDS("Sales Returned Quantity");
                            IF ABS(TempInventoryTraceEntry."Sales Quantity" + TempInventoryTraceEntry."Sales Returned Quantity") > 0 THEN BEGIN
                                //BG016
                                //SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                                //SpecPtnITE_TempRec.INSERT();
                                IF NOT SpecPtnITE_TempRec.GET(TempInventoryTraceEntry."Entry No.") THEN BEGIN
                                    SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                                    SpecPtnITE_TempRec.INSERT();
                                END;
                                //BG016
                            END;
                        UNTIL TempInventoryTraceEntry.NEXT() = 0;

                UNTIL SpecPtnITE_PO_TempRec.NEXT() = 0;

            //Only process "Sales Return Receipt" ILE.
            IF RecItemLedgerEntry."Document Type" = RecItemLedgerEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                RecItemApplicationEntry.RESET();
                RecItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
                IF RecItemApplicationEntry.FINDSET() THEN
                    REPEAT
                        IsBreak := FALSE;
                        QtyApplied := 0;
                        QtyApply := RecItemApplicationEntry.Quantity;

                        SpecPtnITE_TempRec.RESET();
                        SpecPtnITE_TempRec.SETCURRENTKEY("Posting Date");
                        IF SpecPtnITE_TempRec.FINDSET() THEN
                            REPEAT
                                RecInventoryTraceEntry.RESET();
                                RecInventoryTraceEntry.INIT();
                                RecInventoryTraceEntry."Entry No." := 0;
                                RecInventoryTraceEntry."Item Application Entry No." := RecItemApplicationEntry."Entry No.";
                                RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";

                                RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                                RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                                RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";
                                RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                                RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                                //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO

                                IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                                    RecItem.GET(RecInventoryTraceEntry."Item No");
                                END;
                                RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                                RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                                RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                                RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";

                                IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                                    RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                                END;
                                RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;

                                RecPurchasePrice.RESET();
                                RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                                RecPurchasePrice.SETCURRENTKEY("Starting Date");
                                RecPurchasePrice.ASCENDING(FALSE);
                                RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                                IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                                    RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                    RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                END;

                                IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                                    RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                                END;
                                RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                                IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                                    RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                                END;
                                RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                                RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                                RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";
                                RecInventoryTraceEntry."Purchase Order No." := SpecPtnITE_TempRec."Purchase Order No.";
                                RecInventoryTraceEntry."Purch. Item No." := SpecPtnITE_TempRec."Purch. Item No.";
                                RecInventoryTraceEntry."Purch. Item Vendor No." := SpecPtnITE_TempRec."Purch. Item Vendor No.";
                                RecInventoryTraceEntry."Purch. Item Vendor Name" := SpecPtnITE_TempRec."Purch. Item Vendor Name";
                                RecInventoryTraceEntry."Purch. Item Manufacturer Code" := SpecPtnITE_TempRec."Purch. Item Manufacturer Code";
                                RecInventoryTraceEntry."Purch. Hagiwara Group" := SpecPtnITE_TempRec."Purch. Hagiwara Group";
                                RecInventoryTraceEntry."Cost Currency" := SpecPtnITE_TempRec."Cost Currency";
                                RecInventoryTraceEntry."Direct Unit Cost" := SpecPtnITE_TempRec."Direct Unit Cost";
                                RecInventoryTraceEntry."New Cost Currency" := SpecPtnITE_TempRec."New Cost Currency";
                                RecInventoryTraceEntry."New Direct Unit Cost" := SpecPtnITE_TempRec."New Direct Unit Cost";
                                RecInventoryTraceEntry."PC. Cost Currency" := SpecPtnITE_TempRec."PC. Cost Currency";
                                RecInventoryTraceEntry."PC. Direct Unit Cost" := SpecPtnITE_TempRec."PC. Direct Unit Cost";
                                RecInventoryTraceEntry."PC. Entry No." := SpecPtnITE_TempRec."PC. Entry No."; //T20250508.0050
                                RecInventoryTraceEntry."New PC. Cost Currency" := SpecPtnITE_TempRec."New PC. Cost Currency";
                                RecInventoryTraceEntry."New PC. Direct Unit Cost" := SpecPtnITE_TempRec."New PC. Direct Unit Cost";

                                RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";

                                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
                                    RecSalesShipmentLine.RESET();
                                    RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                                    IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                                        RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
                                        RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
                                        RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
                                    END;

                                    IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                        RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
                                    END;
                                END;

                                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                                    RecReturnReceiptLine.RESET();
                                    RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                                    IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
                                        RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
                                    END;

                                    IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                        RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
                                    END;
                                END;

                                IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
                                    RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code";
                                END;

                                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                                    TempItemApplicationEntry.RESET();
                                    TempItemApplicationEntry.SETRANGE("Item Ledger Entry No.", RecItemLedgerEntry."Entry No.");
                                    IF TempItemApplicationEntry.FINDFIRST THEN BEGIN
                                        IF TempItemLedgerEntry.GET(TempItemApplicationEntry."Outbound Item Entry No.") THEN BEGIN
                                            RecInventoryTraceEntry."Original Document No." := TempItemLedgerEntry."Document No.";

                                            RecSalesShipmentLine.RESET();
                                            RecSalesShipmentLine.SETRANGE("Document No.", TempItemLedgerEntry."Document No.");
                                            RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", TempItemLedgerEntry."Entry No.");
                                            IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                                                RecInventoryTraceEntry."Original Document Line No." := RecSalesShipmentLine."Line No.";
                                            END;
                                        END;
                                    END;
                                END;

                                //sign of C.
                                //QtyApply(IAE): >0
                                //QtyApplied(ITE): <0
                                SpecPtnITE_TempRec.CALCFIELDS("Sales Quantity");
                                SpecPtnITE_TempRec.CALCFIELDS("Sales Returned Quantity");
                                IF SpecPtnITE_TempRec.Quantity > (SpecPtnITE_TempRec."Sales Quantity" + SpecPtnITE_TempRec."Sales Returned Quantity") THEN BEGIN
                                    SpecPtn_SalesQty := SpecPtnITE_TempRec.Quantity;
                                END ELSE BEGIN
                                    SpecPtn_SalesQty := SpecPtnITE_TempRec."Sales Quantity" + SpecPtnITE_TempRec."Sales Returned Quantity";
                                END;
                                IF ABS(QtyApplied + SpecPtn_SalesQty) < ABS(QtyApply) THEN BEGIN
                                    RecInventoryTraceEntry.Quantity := SpecPtn_SalesQty * -1;
                                END ELSE BEGIN
                                    RecInventoryTraceEntry.Quantity := QtyApply + QtyApplied;
                                    IsBreak := TRUE;
                                END;
                                QtyApplied := QtyApplied + SpecPtn_SalesQty;

                                RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price";
                                RecInventoryTraceEntry."Incoming Item Ledger Entry No." := SpecPtnITE_TempRec."Incoming Item Ledger Entry No.";
                                RecInventoryTraceEntry.Pattern := 'C';
                                ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                                RecInventoryTraceEntry.INSERT();

                            UNTIL (SpecPtnITE_TempRec.NEXT() = 0) OR IsBreak;

                    UNTIL RecItemApplicationEntry.NEXT() = 0;

            END;

        END;

        //Normal Patterns.
        RecItemApplicationEntry.RESET();
        RecItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
        IF RecItemApplicationEntry.FINDSET() THEN
            REPEAT
                IF RecItemApplicationEntry."Outbound Item Entry No." = 0 THEN BEGIN
                    //Pattern A
                    IF RecItemLedgerEntry."Entry Type" <> RecItemLedgerEntry."Entry Type"::"Assembly Output" THEN BEGIN
                        IF NOT IsPatternM(RecItemLedgerEntry, RecItemApplicationEntry) THEN BEGIN
                            //Pattern A1
                            RecInventoryTraceEntry.RESET();
                            RecInventoryTraceEntry.INIT();
                            RecInventoryTraceEntry."Entry No." := 0;
                            RecInventoryTraceEntry."Item Application Entry No." := RecItemApplicationEntry."Entry No.";
                            RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";
                            RecInventoryTraceEntry.Quantity := RecItemApplicationEntry.Quantity;

                            RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                            RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                            RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";

                            RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                            RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                            //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO
                            RecInventoryTraceEntry."Purch. Item No." := RecInventoryTraceEntry."Item No";
                            RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";

                            RecInventoryTraceEntry."Incoming Item Ledger Entry No." := ItemLedgerEntryNo;

                            IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                                RecItem.GET(RecInventoryTraceEntry."Item No");
                            END;
                            RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                            RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                            RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                            RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";
                            RecInventoryTraceEntry."Purch. Item Vendor No." := RecItem."Vendor No.";
                            RecInventoryTraceEntry."Purch. Item Manufacturer Code" := RecItem."Manufacturer Code";

                            IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                                RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                            END;
                            RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;
                            RecInventoryTraceEntry."Purch. Item Vendor Name" := RecVendor.Name;
                            RecInventoryTraceEntry."Purch. Hagiwara Group" := RecVendor."Hagiwara Group";

                            RecPurchasePrice.RESET();
                            RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                            RecPurchasePrice.SETCURRENTKEY("Starting Date");
                            RecPurchasePrice.ASCENDING(FALSE);
                            RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                            IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                                RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                            END;

                            IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                                RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                            END;
                            RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                            IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                                RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                            END;
                            RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                            RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                                RecPurchRcptLine.RESET();
                                RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                                IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                                    RecInventoryTraceEntry."Direct Unit Cost" := RecPurchRcptLine."Direct Unit Cost";
                                END ELSE BEGIN
                                    IF RecItemLedgerEntry.Quantity <> 0 THEN BEGIN
                                        RecItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
                                        RecItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)");
                                        RecInventoryTraceEntry."Direct Unit Cost" := (RecItemLedgerEntry."Cost Amount (Expected)" + RecItemLedgerEntry."Cost Amount (Actual)") / RecItemLedgerEntry.Quantity;
                                    END;
                                END;
                                IF RecPurchRcptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                    RecInventoryTraceEntry."Cost Currency" := RecPurchRcptHeader."Currency Code";
                                END;

                            END ELSE BEGIN
                                IF RecItemLedgerEntry.Quantity <> 0 THEN BEGIN
                                    RecItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
                                    RecItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)");
                                    RecInventoryTraceEntry."Direct Unit Cost" := (RecItemLedgerEntry."Cost Amount (Expected)" + RecItemLedgerEntry."Cost Amount (Actual)") / RecItemLedgerEntry.Quantity;
                                END;
                            END;

                            RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";

                            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                                //BG017
                                //RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Purchase Order No.";
                                RecPurchRcptLine.RESET();
                                RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                                IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                                    RecInventoryTraceEntry."Purchase Order No." := RecPurchRcptLine."Order No.";
                                END;
                                //BG017
                            END ELSE BEGIN
                                RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Document No.";
                            END;

                            IF RecInventoryTraceEntry."Cost Currency" = '' THEN BEGIN
                                RecInventoryTraceEntry."Cost Currency" := GRecGeneralLedgerSetup."LCY Code";
                            END;

                            RecInventoryTraceEntry.Pattern := 'A1';
                            ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                            RecInventoryTraceEntry.INSERT();
                        END; //A1 (Not M)
                    END ELSE BEGIN
                        //Pattern A2
                        IsBreak := FALSE;
                        QtyApplied := 0;
                        QtyApply := RecItemApplicationEntry.Quantity;

                        TempItemLedgerEntry.RESET();
                        TempItemLedgerEntry.SETRANGE("Entry Type", TempItemLedgerEntry."Entry Type"::"Assembly Consumption");
                        TempItemLedgerEntry.SETRANGE("Document No.", RecItemLedgerEntry."Document No.");
                        TempItemLedgerEntry.SETFILTER(Quantity, '<%1', 0);
                        IF TempItemLedgerEntry.FINDFIRST() THEN BEGIN
                            TempInventoryTraceEntry.RESET();
                            TempInventoryTraceEntry.SETCURRENTKEY("Item Ledger Entry No.");
                            TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", TempItemLedgerEntry."Entry No.");
                            IF TempInventoryTraceEntry.FINDSET() THEN
                                REPEAT
                                    RecInventoryTraceEntry.RESET();
                                    RecInventoryTraceEntry.INIT();
                                    RecInventoryTraceEntry."Entry No." := 0;
                                    RecInventoryTraceEntry."Item Application Entry No." := RecItemApplicationEntry."Entry No.";
                                    RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";

                                    RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                                    RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                                    RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";

                                    RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                                    RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                                    //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO

                                    IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                                        RecItem.GET(RecInventoryTraceEntry."Item No");
                                    END;
                                    RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                                    RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                                    RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                                    RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";

                                    IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                                        RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                                    END;
                                    RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;

                                    //T20250508.0050 Begin
                                    //RecInventoryTraceEntry."Ship&Debit Flag" := TempInventoryTraceEntry."Ship&Debit Flag";
                                    //RecInventoryTraceEntry."New Ship&Debit Flag" := TempInventoryTraceEntry."Ship&Debit Flag";

                                    RecPurchasePrice.RESET();
                                    RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                                    RecPurchasePrice.SETCURRENTKEY("Starting Date");
                                    RecPurchasePrice.ASCENDING(FALSE);
                                    RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                                    IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                                        RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                        RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                    END;
                                    //T20250508.0050 End

                                    IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                                        RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                                    END;
                                    RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                                    IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                                        RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                                    END;
                                    RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                                    RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                                    RecInventoryTraceEntry."Purchase Order No." := TempInventoryTraceEntry."Purchase Order No.";
                                    RecInventoryTraceEntry."Purch. Item No." := TempInventoryTraceEntry."Purch. Item No.";
                                    RecInventoryTraceEntry."Purch. Item Vendor No." := TempInventoryTraceEntry."Purch. Item Vendor No.";
                                    RecInventoryTraceEntry."Purch. Item Vendor Name" := TempInventoryTraceEntry."Purch. Item Vendor Name";
                                    RecInventoryTraceEntry."Purch. Item Manufacturer Code" := TempInventoryTraceEntry."Purch. Item Manufacturer Code";
                                    RecInventoryTraceEntry."Purch. Hagiwara Group" := TempInventoryTraceEntry."Purch. Hagiwara Group";
                                    RecInventoryTraceEntry."Cost Currency" := TempInventoryTraceEntry."Cost Currency";
                                    RecInventoryTraceEntry."Direct Unit Cost" := TempInventoryTraceEntry."Direct Unit Cost";
                                    RecInventoryTraceEntry."New Cost Currency" := TempInventoryTraceEntry."New Cost Currency";
                                    RecInventoryTraceEntry."New Direct Unit Cost" := TempInventoryTraceEntry."New Direct Unit Cost";
                                    RecInventoryTraceEntry."PC. Cost Currency" := TempInventoryTraceEntry."PC. Cost Currency";
                                    RecInventoryTraceEntry."PC. Direct Unit Cost" := TempInventoryTraceEntry."PC. Direct Unit Cost";
                                    RecInventoryTraceEntry."PC. Entry No." := TempInventoryTraceEntry."PC. Entry No."; //T20250508.0050
                                    RecInventoryTraceEntry."New PC. Cost Currency" := TempInventoryTraceEntry."New PC. Cost Currency";
                                    RecInventoryTraceEntry."New PC. Direct Unit Cost" := TempInventoryTraceEntry."New PC. Direct Unit Cost";

                                    RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";
                                    RecInventoryTraceEntry."External Document No." := TempItemLedgerEntry."External Document No.";

                                    //sign of A2.
                                    //QtyApply(IAE): >0
                                    //QtyApplied(ITE): <0
                                    IF ABS(QtyApplied + TempInventoryTraceEntry.Quantity) < ABS(QtyApply) THEN BEGIN
                                        RecInventoryTraceEntry.Quantity := TempInventoryTraceEntry.Quantity * -1;
                                    END ELSE BEGIN
                                        RecInventoryTraceEntry.Quantity := QtyApply + QtyApplied;
                                        IsBreak := TRUE;
                                    END;
                                    QtyApplied := QtyApplied + TempInventoryTraceEntry.Quantity;

                                    RecInventoryTraceEntry."Incoming Item Ledger Entry No." := TempInventoryTraceEntry."Incoming Item Ledger Entry No.";
                                    RecInventoryTraceEntry.Pattern := 'A2';
                                    ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                                    RecInventoryTraceEntry.INSERT();
                                UNTIL (TempInventoryTraceEntry.NEXT() = 0) OR IsBreak;

                        END;
                    END;
                END ELSE IF RecItemApplicationEntry."Outbound Item Entry No." > RecItemApplicationEntry."Inbound Item Entry No." THEN BEGIN
                    //Pattern B
                    /* //Merged into Special Logic first.
                    IF IsSpecPtn = '' THEN BEGIN
                      IsBreak:=FALSE;
                      QtyApplied := 0;
                      QtyApply := RecItemApplicationEntry.Quantity;

                      TempInventoryTraceEntry.RESET();
                      TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.",RecItemApplicationEntry."Inbound Item Entry No.");
                      TempInventoryTraceEntry.SETCURRENTKEY("Item Ledger Entry No.","Posting Date");
                      IF TempInventoryTraceEntry.FINDSET() THEN
                        REPEAT
                          RecInventoryTraceEntry.RESET();
                          RecInventoryTraceEntry.INIT();
                          RecInventoryTraceEntry."Entry No." := 0;
                          RecInventoryTraceEntry."Item Application Entry No." := RecItemApplicationEntry."Entry No.";
                          RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";

                          RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                          RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                          RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";
                          RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                          RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                          RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description";

                          RecItem.RESET();
                          IF RecItem.GET(RecInventoryTraceEntry."Item No") THEN BEGIN
                            RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                            RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                            RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                            RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";

                            RecVendor.RESET();
                            IF RecVendor.GET(RecInventoryTraceEntry."Vendor No.") THEN BEGIN
                              RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;
                            END;

                            RecPurchasePrice.RESET();
                            RecPurchasePrice.SETRANGE("Asset No.",RecInventoryTraceEntry."Item No");
                            RecPurchasePrice.SETCURRENTKEY("Starting Date");
                            RecPurchasePrice.ASCENDING(FALSE);
                            RecPurchasePrice.SETFILTER("Starting Date",'<=%1',RecInventoryTraceEntry."Posting Date");
                            IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                              RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                              RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                            END;
                          END;

                          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Posted Assembly" THEN BEGIN
                            RecInventoryTraceEntry."Ship&Debit Flag" := TempInventoryTraceEntry."Ship&Debit Flag";
                            RecInventoryTraceEntry."New Ship&Debit Flag" := TempInventoryTraceEntry."New Ship&Debit Flag"; END;

                          RecCustomer.RESET();
                          IF RecCustomer.GET(RecInventoryTraceEntry."Customer No.") THEN BEGIN
                            RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;
                          END;

                          RecCustomer.RESET();
                          IF RecCustomer.GET(RecInventoryTraceEntry."OEM No.") THEN BEGIN
                            RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                            RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";
                          END;

                          RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";

                          RecInventoryTraceEntry."Purchase Order No." := TempInventoryTraceEntry."Purchase Order No.";
                          RecInventoryTraceEntry."Purch. Item No." := TempInventoryTraceEntry."Purch. Item No.";
                          RecInventoryTraceEntry."Purch. Item Vendor No." := TempInventoryTraceEntry."Purch. Item Vendor No.";
                          RecInventoryTraceEntry."Purch. Item Vendor Name" := TempInventoryTraceEntry."Purch. Item Vendor Name";
                          RecInventoryTraceEntry."Purch. Item Manufacturer Code" := TempInventoryTraceEntry."Purch. Item Manufacturer Code";
                          RecInventoryTraceEntry."Purch. Hagiwara Group" := TempInventoryTraceEntry."Purch. Hagiwara Group";
                          RecInventoryTraceEntry."Cost Currency" := TempInventoryTraceEntry."Cost Currency";
                          RecInventoryTraceEntry."Direct Unit Cost" := TempInventoryTraceEntry."Direct Unit Cost";
                          RecInventoryTraceEntry."New Cost Currency" := TempInventoryTraceEntry."New Cost Currency";
                          RecInventoryTraceEntry."New Direct Unit Cost" := TempInventoryTraceEntry."New Direct Unit Cost";
                          RecInventoryTraceEntry."PC. Cost Currency" := TempInventoryTraceEntry."PC. Cost Currency";
                          RecInventoryTraceEntry."PC. Direct Unit Cost" := TempInventoryTraceEntry."PC. Direct Unit Cost";
                          RecInventoryTraceEntry."New PC. Cost Currency" := TempInventoryTraceEntry."New PC. Cost Currency";
                          RecInventoryTraceEntry."New PC. Direct Unit Cost" := TempInventoryTraceEntry."New PC. Direct Unit Cost";

                          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                            RecPurchRcptLine.RESET();
                            RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.",RecInventoryTraceEntry."Item Ledger Entry No.");
                            IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                              RecInventoryTraceEntry."Document Line No." := RecPurchRcptLine."Line No.";
                            END;
                          END;

                          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
                            RecSalesShipmentLine.RESET();
                            RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.",RecInventoryTraceEntry."Item Ledger Entry No.");
                            IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                              RecInventoryTraceEntry."Document Line No." := RecSalesShipmentLine."Line No.";
                              RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
                              RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
                              RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
                            END;

                            IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                              RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
                            END;
                          END;

                          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                            RecReturnReceiptLine.RESET();
                            RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.",RecInventoryTraceEntry."Item Ledger Entry No.");
                            IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
                              RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
                            END;

                            IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                              RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
                            END;
                          END;

                          IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
                            RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code"; END;

                          IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                              RecInventoryTraceEntry."Original Document No." := TempInventoryTraceEntry."Original Document No.";
                              RecInventoryTraceEntry."Original Document Line No." := TempInventoryTraceEntry."Original Document Line No.";
                            END;

                          IF RecInventoryTraceEntry."Document Line No." = 0 THEN BEGIN
                            RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";
                          END;

                          //sign of B.
                          //QtyApply(IAE): <0
                          //QtyApplied(ITE): >0
                          IF ABS(QtyApplied + TempInventoryTraceEntry.Quantity) < ABS(QtyApply) THEN BEGIN
                            RecInventoryTraceEntry.Quantity:= TempInventoryTraceEntry.Quantity * -1;
                          END ELSE BEGIN
                            RecInventoryTraceEntry.Quantity:= QtyApply + QtyApplied;
                            IsBreak := TRUE;
                          END;
                          QtyApplied := QtyApplied + TempInventoryTraceEntry.Quantity;

                          RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price" * -1;
                          RecInventoryTraceEntry.Pattern := 'B1';
                          ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                          RecInventoryTraceEntry.INSERT();

                        UNTIL (TempInventoryTraceEntry.NEXT() = 0) OR IsBreak;
                    END;
                    */
                END ELSE IF RecItemApplicationEntry."Outbound Item Entry No." < RecItemApplicationEntry."Inbound Item Entry No." THEN BEGIN
                    //Pattern C
                    IF IsSpecPtn = '' THEN BEGIN
                        IsBreak := FALSE;
                        QtyApplied := 0;
                        QtyApply := RecItemApplicationEntry.Quantity;

                        TempInventoryTraceEntry.RESET();
                        TempInventoryTraceEntry.SETCURRENTKEY("Item Ledger Entry No.", "Posting Date");
                        TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", RecItemApplicationEntry."Outbound Item Entry No.");
                        IF TempInventoryTraceEntry.FINDSET() THEN
                            REPEAT
                                RecInventoryTraceEntry.RESET();
                                RecInventoryTraceEntry.INIT();
                                RecInventoryTraceEntry."Entry No." := 0;
                                RecInventoryTraceEntry."Item Application Entry No." := RecItemApplicationEntry."Entry No.";
                                RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";

                                RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                                RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                                RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";
                                RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                                RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                                //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO

                                IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                                    RecItem.GET(RecInventoryTraceEntry."Item No");
                                END;
                                RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                                RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                                RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                                RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";

                                IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                                    RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                                END;
                                RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;

                                RecPurchasePrice.RESET();
                                RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                                RecPurchasePrice.SETCURRENTKEY("Starting Date");
                                RecPurchasePrice.ASCENDING(FALSE);
                                RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                                IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                                    RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                    RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                                END;

                                IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                                    RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                                END;
                                RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                                IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                                    RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                                END;
                                RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                                RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                                RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";
                                RecInventoryTraceEntry."Purchase Order No." := TempInventoryTraceEntry."Purchase Order No.";
                                RecInventoryTraceEntry."Purch. Item No." := TempInventoryTraceEntry."Purch. Item No.";
                                RecInventoryTraceEntry."Purch. Item Vendor No." := TempInventoryTraceEntry."Purch. Item Vendor No.";
                                RecInventoryTraceEntry."Purch. Item Vendor Name" := TempInventoryTraceEntry."Purch. Item Vendor Name";
                                RecInventoryTraceEntry."Purch. Item Manufacturer Code" := TempInventoryTraceEntry."Purch. Item Manufacturer Code";
                                RecInventoryTraceEntry."Purch. Hagiwara Group" := TempInventoryTraceEntry."Purch. Hagiwara Group";
                                RecInventoryTraceEntry."Cost Currency" := TempInventoryTraceEntry."Cost Currency";
                                RecInventoryTraceEntry."Direct Unit Cost" := TempInventoryTraceEntry."Direct Unit Cost";
                                RecInventoryTraceEntry."New Cost Currency" := TempInventoryTraceEntry."New Cost Currency";
                                RecInventoryTraceEntry."New Direct Unit Cost" := TempInventoryTraceEntry."New Direct Unit Cost";
                                RecInventoryTraceEntry."PC. Cost Currency" := TempInventoryTraceEntry."PC. Cost Currency";
                                RecInventoryTraceEntry."PC. Direct Unit Cost" := TempInventoryTraceEntry."PC. Direct Unit Cost";
                                RecInventoryTraceEntry."PC. Entry No." := TempInventoryTraceEntry."PC. Entry No."; //T20250508.0050
                                RecInventoryTraceEntry."New PC. Cost Currency" := TempInventoryTraceEntry."New PC. Cost Currency";
                                RecInventoryTraceEntry."New PC. Direct Unit Cost" := TempInventoryTraceEntry."New PC. Direct Unit Cost";

                                RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";

                                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
                                    RecSalesShipmentLine.RESET();
                                    RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                                    IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                                        RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
                                        RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
                                        RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
                                    END;

                                    IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                        RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
                                    END;
                                END;

                                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                                    RecReturnReceiptLine.RESET();
                                    RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                                    IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
                                        RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
                                    END;

                                    IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                                        RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
                                    END;
                                END;

                                IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
                                    RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code";
                                END;

                                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                                    TempItemApplicationEntry.RESET();
                                    TempItemApplicationEntry.SETRANGE("Item Ledger Entry No.", RecItemLedgerEntry."Entry No.");
                                    IF TempItemApplicationEntry.FINDFIRST THEN BEGIN
                                        IF TempItemLedgerEntry.GET(TempItemApplicationEntry."Outbound Item Entry No.") THEN BEGIN
                                            RecInventoryTraceEntry."Original Document No." := TempItemLedgerEntry."Document No.";

                                            RecSalesShipmentLine.RESET();
                                            RecSalesShipmentLine.SETRANGE("Document No.", TempItemLedgerEntry."Document No.");
                                            RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", TempItemLedgerEntry."Entry No.");
                                            IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                                                RecInventoryTraceEntry."Original Document Line No." := RecSalesShipmentLine."Line No.";
                                            END;
                                        END;
                                    END;
                                END;

                                //sign of C.
                                //QtyApply(IAE): >0
                                //QtyApplied(ITE): <0
                                IF ABS(QtyApplied + TempInventoryTraceEntry.Quantity) < ABS(QtyApply) THEN BEGIN
                                    RecInventoryTraceEntry.Quantity := TempInventoryTraceEntry.Quantity * -1;
                                END ELSE BEGIN
                                    RecInventoryTraceEntry.Quantity := QtyApply + QtyApplied;
                                    IsBreak := TRUE;
                                END;
                                QtyApplied := QtyApplied + TempInventoryTraceEntry.Quantity;

                                RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price";
                                RecInventoryTraceEntry."Incoming Item Ledger Entry No." := TempInventoryTraceEntry."Incoming Item Ledger Entry No.";
                                RecInventoryTraceEntry.Pattern := 'C';
                                ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                                RecInventoryTraceEntry.INSERT();

                            UNTIL (TempInventoryTraceEntry.NEXT() = 0) OR IsBreak;
                    END;
                END; //RecItemApplicationEntry."Outbound Item Entry No." (Pattern A,B,C end)

            UNTIL RecItemApplicationEntry.NEXT() = 0;

        //If no ITE created or Quantity is different in ILE and ITE, it's pattern D.
        TempInventoryTraceEntry.RESET();
        TempInventoryTraceEntry.SETCURRENTKEY("Item Ledger Entry No.");
        TempInventoryTraceEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
        IF TempInventoryTraceEntry.ISEMPTY() THEN BEGIN
            IsSpecPtn := 'D_EMP';
        END ELSE BEGIN
            Qty_PtnD := RecItemLedgerEntry.Quantity - GQty_sumITE;
            IF Qty_PtnD <> 0 THEN BEGIN
                IsSpecPtn := 'D_QTY';
            END;
        END;

        IF IsSpecPtn IN ['D_EMP', 'D_QTY'] THEN BEGIN
            SpecPtnITE_TempRec.RESET();
            SpecPtnITE_TempRec.DELETEALL();

            TempInventoryTraceEntry.RESET();
            TempInventoryTraceEntry.ASCENDING(FALSE);
            TempInventoryTraceEntry.SETCURRENTKEY("Posting Date", "Purch. Item No.", "Document Type", "Entry Type");
            TempInventoryTraceEntry.SETRANGE(Pattern, 'A1');
            TempInventoryTraceEntry.SETFILTER("Posting Date", '<%1', RecItemLedgerEntry."Posting Date");
            TempInventoryTraceEntry.SETRANGE("Item No", RecItemLedgerEntry."Item No.");

            IF TempInventoryTraceEntry.FINDFIRST() THEN BEGIN
                SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                SpecPtnITE_TempRec.INSERT();
            END;
        END;

        IF IsSpecPtn = 'D_EMP' THEN BEGIN
            RecItemApplicationEntry.RESET();
            RecItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
            IF RecItemApplicationEntry.FINDSET() THEN
                REPEAT

                    RecInventoryTraceEntry.RESET();
                    RecInventoryTraceEntry.INIT();
                    RecInventoryTraceEntry."Entry No." := 0;
                    RecInventoryTraceEntry."Item Application Entry No." := RecItemApplicationEntry."Entry No.";
                    RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";
                    RecInventoryTraceEntry.Quantity := RecItemApplicationEntry.Quantity;

                    RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
                    RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
                    RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";

                    RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
                    RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
                    //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO
                    RecInventoryTraceEntry."Purch. Item No." := RecInventoryTraceEntry."Item No";
                    RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";

                    IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                        RecItem.GET(RecInventoryTraceEntry."Item No");
                    END;
                    RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                    RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                    RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                    RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";
                    RecInventoryTraceEntry."Purch. Item Vendor No." := RecItem."Vendor No.";
                    RecInventoryTraceEntry."Purch. Item Manufacturer Code" := RecItem."Manufacturer Code";

                    IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                        RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                    END;
                    RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;
                    RecInventoryTraceEntry."Purch. Item Vendor Name" := RecVendor.Name;
                    RecInventoryTraceEntry."Purch. Hagiwara Group" := RecVendor."Hagiwara Group";

                    RecPurchasePrice.RESET();
                    RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                    RecPurchasePrice.SETCURRENTKEY("Starting Date");
                    RecPurchasePrice.ASCENDING(FALSE);
                    RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                    IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                        RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                        RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                    END;

                    IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                        RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                    END;
                    RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                    IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                        RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                    END;
                    RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                    RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                    IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                        RecPurchRcptLine.RESET();
                        RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                        IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Direct Unit Cost" := RecPurchRcptLine."Direct Unit Cost";
                        END;
                        IF RecPurchRcptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                            RecInventoryTraceEntry."Cost Currency" := RecPurchRcptHeader."Currency Code";
                        END;

                    END ELSE BEGIN
                        IF RecItemLedgerEntry.Quantity <> 0 THEN BEGIN
                            RecItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
                            RecItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)");
                            RecInventoryTraceEntry."Direct Unit Cost" := (RecItemLedgerEntry."Cost Amount (Expected)" + RecItemLedgerEntry."Cost Amount (Actual)") / RecItemLedgerEntry.Quantity;
                        END;
                    END;

                    IF RecInventoryTraceEntry."Cost Currency" = '' THEN BEGIN
                        RecInventoryTraceEntry."Cost Currency" := GRecGeneralLedgerSetup."LCY Code";
                    END;

                    IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
                        RecSalesShipmentLine.RESET();
                        RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                        IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
                            RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
                            RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
                        END;

                        IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                            RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
                        END;
                    END;

                    IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                        RecReturnReceiptLine.RESET();
                        RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                        IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
                        END;

                        IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                            RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
                        END;
                    END;

                    IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
                        RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code";
                    END;

                    IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                        TempItemApplicationEntry.RESET();
                        TempItemApplicationEntry.SETRANGE("Item Ledger Entry No.", RecItemLedgerEntry."Entry No.");
                        IF TempItemApplicationEntry.FINDFIRST THEN BEGIN
                            IF TempItemLedgerEntry.GET(TempItemApplicationEntry."Outbound Item Entry No.") THEN BEGIN
                                RecInventoryTraceEntry."Original Document No." := TempItemLedgerEntry."Document No.";

                                RecSalesShipmentLine.RESET();
                                RecSalesShipmentLine.SETRANGE("Document No.", TempItemLedgerEntry."Document No.");
                                RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", TempItemLedgerEntry."Entry No.");
                                IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                                    RecInventoryTraceEntry."Original Document Line No." := RecSalesShipmentLine."Line No.";
                                END;
                            END;
                        END;
                    END;

                    RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";

                    IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                        //BG017
                        //RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Purchase Order No.";
                        RecPurchRcptLine.RESET();
                        RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                        IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Purchase Order No." := RecPurchRcptLine."Order No.";
                        END;
                        //BG017
                    END ELSE BEGIN
                        RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Document No.";
                    END;

                    //BG019
                    //      IF ((RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale)
                    //          AND (RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment")
                    //        ) OR ((RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::"Negative Adjmt.")
                    //          AND (RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::" ")
                    //        ) THEN BEGIN
                    //
                    //        IF SpecPtnITE_TempRec.FINDFIRST() THEN BEGIN
                    //          RecInventoryTraceEntry."Purchase Order No." := SpecPtnITE_TempRec."Purchase Order No.";
                    //          RecInventoryTraceEntry."Cost Currency" := SpecPtnITE_TempRec."Cost Currency";
                    //          RecInventoryTraceEntry."Direct Unit Cost" := SpecPtnITE_TempRec."Direct Unit Cost";
                    //          RecInventoryTraceEntry."New Cost Currency" := SpecPtnITE_TempRec."New Cost Currency";
                    //          RecInventoryTraceEntry."New Direct Unit Cost" := SpecPtnITE_TempRec."New Direct Unit Cost";
                    //          RecInventoryTraceEntry."PC. Cost Currency" := SpecPtnITE_TempRec."PC. Cost Currency";
                    //          RecInventoryTraceEntry."PC. Direct Unit Cost" := SpecPtnITE_TempRec."PC. Direct Unit Cost";
                    //          RecInventoryTraceEntry."New PC. Cost Currency" := SpecPtnITE_TempRec."New PC. Cost Currency";
                    //          RecInventoryTraceEntry."New PC. Direct Unit Cost" := SpecPtnITE_TempRec."New PC. Direct Unit Cost";
                    //        END;
                    //      END;
                    //BG019

                    RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price" * -1;
                    RecInventoryTraceEntry."Incoming Item Ledger Entry No." := RecItemLedgerEntry."Entry No.";
                    RecInventoryTraceEntry.Pattern := 'D';
                    ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                    RecInventoryTraceEntry.INSERT();

                UNTIL RecItemApplicationEntry.NEXT() = 0;

        END ELSE IF IsSpecPtn = 'D_QTY' THEN BEGIN

            RecInventoryTraceEntry.RESET();
            RecInventoryTraceEntry.INIT();
            RecInventoryTraceEntry."Entry No." := 0;
            RecInventoryTraceEntry."Item Application Entry No." := 9999999;
            RecInventoryTraceEntry."Item Ledger Entry No." := RecItemApplicationEntry."Item Ledger Entry No.";
            RecInventoryTraceEntry.Quantity := Qty_PtnD;

            RecInventoryTraceEntry."Entry Type" := RecItemLedgerEntry."Entry Type";
            RecInventoryTraceEntry."Document Type" := RecItemLedgerEntry."Document Type";
            RecInventoryTraceEntry."Document No." := RecItemLedgerEntry."Document No.";

            RecInventoryTraceEntry."Posting Date" := RecItemLedgerEntry."Posting Date";
            RecInventoryTraceEntry."Item No" := RecItemLedgerEntry."Item No.";
            //RecInventoryTraceEntry."Item Description" := RecItemLedgerEntry."Item Description"; //TODO
            RecInventoryTraceEntry."Purch. Item No." := RecInventoryTraceEntry."Item No";
            RecInventoryTraceEntry."External Document No." := RecItemLedgerEntry."External Document No.";

            IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                RecItem.GET(RecInventoryTraceEntry."Item No");
            END;
            RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
            RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
            RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
            RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";
            RecInventoryTraceEntry."Purch. Item Vendor No." := RecItem."Vendor No.";
            RecInventoryTraceEntry."Purch. Item Manufacturer Code" := RecItem."Manufacturer Code";

            IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
            END;
            RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;
            RecInventoryTraceEntry."Purch. Item Vendor Name" := RecVendor.Name;
            RecInventoryTraceEntry."Purch. Hagiwara Group" := RecVendor."Hagiwara Group";

            RecPurchasePrice.RESET();
            RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
            RecPurchasePrice.SETCURRENTKEY("Starting Date");
            RecPurchasePrice.ASCENDING(FALSE);
            RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
            IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
            END;

            IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
            END;
            RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

            IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
            END;
            RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
            RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                RecPurchRcptLine.RESET();
                RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                    RecInventoryTraceEntry."Direct Unit Cost" := RecPurchRcptLine."Direct Unit Cost";
                END;
                IF RecPurchRcptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                    RecInventoryTraceEntry."Cost Currency" := RecPurchRcptHeader."Currency Code";
                END;

            END ELSE BEGIN
                IF RecItemLedgerEntry.Quantity <> 0 THEN BEGIN
                    RecItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
                    RecItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)");
                    RecInventoryTraceEntry."Direct Unit Cost" := (RecItemLedgerEntry."Cost Amount (Expected)" + RecItemLedgerEntry."Cost Amount (Actual)") / RecItemLedgerEntry.Quantity;
                END;
            END;

            IF RecInventoryTraceEntry."Cost Currency" = '' THEN BEGIN
                RecInventoryTraceEntry."Cost Currency" := GRecGeneralLedgerSetup."LCY Code";
            END;

            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment" THEN BEGIN
                RecSalesShipmentLine.RESET();
                RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                    RecInventoryTraceEntry."Booking No." := RecSalesShipmentLine."Booking No.";
                    RecInventoryTraceEntry."Shipment Seq. No." := RecSalesShipmentLine."Shipment Seq. No.";
                    RecInventoryTraceEntry."Sales Price" := RecSalesShipmentLine."Unit Price";
                END;

                IF RecSalesShipmentHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                    RecInventoryTraceEntry."Sales Currency" := RecSalesShipmentHeader."Currency Code";
                END;
            END;

            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                RecReturnReceiptLine.RESET();
                RecReturnReceiptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                IF RecReturnReceiptLine.FINDFIRST() THEN BEGIN
                    RecInventoryTraceEntry."Sales Price" := RecReturnReceiptLine."Unit Price";
                END;

                IF RecReturnReceiptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                    RecInventoryTraceEntry."Sales Currency" := RecReturnReceiptHeader."Currency Code";
                END;
            END;

            IF (RecInventoryTraceEntry."Sales Currency" = '') AND (RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale) THEN BEGIN
                RecInventoryTraceEntry."Sales Currency" := GRecGeneralLedgerSetup."LCY Code";
            END;

            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Return Receipt" THEN BEGIN
                TempItemApplicationEntry.RESET();
                TempItemApplicationEntry.SETRANGE("Item Ledger Entry No.", RecItemLedgerEntry."Entry No.");
                IF TempItemApplicationEntry.FINDFIRST THEN BEGIN
                    IF TempItemLedgerEntry.GET(TempItemApplicationEntry."Outbound Item Entry No.") THEN BEGIN
                        RecInventoryTraceEntry."Original Document No." := TempItemLedgerEntry."Document No.";

                        RecSalesShipmentLine.RESET();
                        RecSalesShipmentLine.SETRANGE("Document No.", TempItemLedgerEntry."Document No.");
                        RecSalesShipmentLine.SETRANGE("Item Shpt. Entry No.", TempItemLedgerEntry."Entry No.");
                        IF RecSalesShipmentLine.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Original Document Line No." := RecSalesShipmentLine."Line No.";
                        END;
                    END;
                END;
            END;

            RecInventoryTraceEntry."Document Line No." := RecItemLedgerEntry."Document Line No.";

            IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                //BG017
                //RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Purchase Order No.";
                RecPurchRcptLine.RESET();
                RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                    RecInventoryTraceEntry."Purchase Order No." := RecPurchRcptLine."Order No.";
                END;
                //BG017
            END ELSE BEGIN
                RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Document No.";
            END;

            //BG019
            //  IF ((RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale)
            //      AND (RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment")
            //    ) OR ((RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::"Negative Adjmt.")
            //      AND (RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::" ")
            //    ) THEN BEGIN
            //    IF SpecPtnITE_TempRec.FINDFIRST() THEN BEGIN
            //      RecInventoryTraceEntry."Purchase Order No." := SpecPtnITE_TempRec."Purchase Order No.";
            //      RecInventoryTraceEntry."Cost Currency" := SpecPtnITE_TempRec."Cost Currency";
            //      RecInventoryTraceEntry."Direct Unit Cost" := SpecPtnITE_TempRec."Direct Unit Cost";
            //      RecInventoryTraceEntry."New Cost Currency" := SpecPtnITE_TempRec."New Cost Currency";
            //      RecInventoryTraceEntry."New Direct Unit Cost" := SpecPtnITE_TempRec."New Direct Unit Cost";
            //      RecInventoryTraceEntry."PC. Cost Currency" := SpecPtnITE_TempRec."PC. Cost Currency";
            //      RecInventoryTraceEntry."PC. Direct Unit Cost" := SpecPtnITE_TempRec."PC. Direct Unit Cost";
            //      RecInventoryTraceEntry."New PC. Cost Currency" := SpecPtnITE_TempRec."New PC. Cost Currency";
            //      RecInventoryTraceEntry."New PC. Direct Unit Cost" := SpecPtnITE_TempRec."New PC. Direct Unit Cost";
            //    END;
            //  END;
            //BG019

            RecInventoryTraceEntry."Sales Amount" := RecInventoryTraceEntry.Quantity * RecInventoryTraceEntry."Sales Price" * -1;
            RecInventoryTraceEntry."Incoming Item Ledger Entry No." := RecItemLedgerEntry."Entry No.";
            RecInventoryTraceEntry.Pattern := 'D';
            ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
            RecInventoryTraceEntry.INSERT();

        END; //Pattern D end.

        IF GCnt_newITE >= 5000 THEN BEGIN
            COMMIT;
            CLEAR(GCnt_newITE);
        END;

    end;

    local procedure ReadyToInsertInvTraceEntry(var pRecInvTraceEntry: Record "Inventory Trace Entry")
    begin

        WITH pRecInvTraceEntry DO BEGIN

            IF "New PC. Direct Unit Cost" <> 0 THEN BEGIN
                "SLS. Purchase Price" := "New PC. Direct Unit Cost";
                "INV. Purchase Price" := "New PC. Direct Unit Cost";
            END
            ELSE IF "PC. Direct Unit Cost" <> 0 THEN BEGIN
                "SLS. Purchase Price" := "PC. Direct Unit Cost";
                "INV. Purchase Price" := "PC. Direct Unit Cost";
            END
            ELSE IF "New Direct Unit Cost" <> 0 THEN BEGIN
                "SLS. Purchase Price" := "New Direct Unit Cost";
                "INV. Purchase Price" := "New Direct Unit Cost";
            END
            ELSE IF "Direct Unit Cost" <> 0 THEN BEGIN
                "SLS. Purchase Price" := "Direct Unit Cost";
                "INV. Purchase Price" := "Direct Unit Cost";
            END;

            IF "New PC. Cost Currency" <> '' THEN BEGIN
                "SLS. Purchase Currency" := "New PC. Cost Currency";
                "INV. Purchase Currency" := "New PC. Cost Currency";
            END
            ELSE IF "PC. Cost Currency" <> '' THEN BEGIN
                "SLS. Purchase Currency" := "PC. Cost Currency";
                "INV. Purchase Currency" := "PC. Cost Currency";
            END
            ELSE IF "New Cost Currency" <> '' THEN BEGIN
                "SLS. Purchase Currency" := "New Cost Currency";
                "INV. Purchase Currency" := "New Cost Currency";
            END
            ELSE IF "Cost Currency" <> '' THEN BEGIN
                "SLS. Purchase Currency" := "Cost Currency";
                "INV. Purchase Currency" := "Cost Currency";
            END;

            //The following combination of Document Type and Entry Type is considered having Remaining Quantity.
            //BG020
            //IF (("Document Type" = "Document Type"::"Purchase Receipt") AND ("Entry Type" = "Entry Type"::Purchase))
            IF (("Document Type" = "Document Type"::"Purchase Receipt") AND ("Entry Type" = "Entry Type"::Purchase) AND (Quantity > 0))
              //BG020
              OR
               (("Document Type" = "Document Type"::" ") AND ("Entry Type" = "Entry Type"::Purchase))
              OR
              (("Document Type" = "Document Type"::" ") AND ("Entry Type" = "Entry Type"::"Positive Adjmt."))
              OR
              (("Document Type" = "Document Type"::"Transfer Receipt") AND ("Entry Type" = "Entry Type"::Transfer) AND (Quantity > 0))
              OR
              (("Document Type" = "Document Type"::"Transfer Shipment") AND ("Entry Type" = "Entry Type"::Transfer) AND (Quantity > 0))
              OR
              (("Document Type" = "Document Type"::"Posted Assembly") AND ("Entry Type" = "Entry Type"::"Assembly Output"))
              OR
              (("Document Type" = "Document Type"::" ") AND ("Entry Type" = "Entry Type"::Transfer) AND (Quantity > 0))
              OR
              (("Document Type" = "Document Type"::"Sales Return Receipt") AND ("Entry Type" = "Entry Type"::Sale) AND (Quantity > 0))
              THEN BEGIN
                //The flag is used on Inventory Trace Entries Page Object
                "Calc. Rem. Qty." := TRUE;
            END;

            GQty_sumITE := GQty_sumITE + Quantity;
            GCnt_newITE := GCnt_newITE + 1;
        END;
    end;

    local procedure IsPatternM(pRecItemLedgerEntry: Record "Item Ledger Entry"; pRecItemApplicationEntry: Record "Item Application Entry") rtnPtnMProcessed: Boolean
    var
        RecItem: Record "Item";
        RecVendor: Record "Vendor";
        RecHWGroup: Record "Hagiwara Group";
        PC_CompName: Text[30];
        SC_OrgItemNo: Code[20];
        SC_PurchOrderNo: Code[20];
        RecInventoryTraceEntry: Record "Inventory Trace Entry";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecCustomer: Record "Customer";
        RecPurchasePrice: Record "Price List Line";
        RecPurchRcptHeader: Record "Purch. Rcpt. Header";
        RecSalesShipmentHeader: Record "Sales Shipment Header";
        RecSalesShipmentLine: Record "Sales Shipment Line";
        PC_TempInventoryTraceEntry: Record "Inventory Trace Entry";
        DocumentNo: Integer;
        QtyApply: Decimal;
        QtyApplied: Decimal;
        IsBreak: Boolean;
    begin
        rtnPtnMProcessed := FALSE;

        IF NOT GRecInventorySetup."Enable Multicompany Trace" THEN
            EXIT(FALSE);

        IF (pRecItemLedgerEntry."Document Type" = pRecItemLedgerEntry."Document Type"::"Purchase Receipt")
          AND (pRecItemLedgerEntry.Quantity > 0) THEN BEGIN
            IF RecItem.GET(pRecItemLedgerEntry."Item No.") THEN BEGIN
                IF RecVendor.GET(RecItem."Vendor No.") THEN BEGIN
                    IF RecHWGroup.GET(RecVendor."Hagiwara Group") THEN BEGIN
                        PC_CompName := RecHWGroup.Company;
                    END;
                END;
                SC_OrgItemNo := RecItem."Original Item No.";
            END;
        END;

        IF PC_CompName = '' THEN
            EXIT(FALSE);

        //Find ITE from PC Company.
        IF NOT PC_TempInventoryTraceEntry.CHANGECOMPANY(PC_CompName) THEN
            EXIT(FALSE);

        IsBreak := FALSE;
        QtyApplied := 0;
        QtyApply := pRecItemApplicationEntry.Quantity;

        IF pRecItemLedgerEntry."Document Type" = pRecItemLedgerEntry."Document Type"::"Purchase Receipt" THEN BEGIN
            RecPurchRcptLine.RESET();
            RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", pRecItemLedgerEntry."Entry No.");
            IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                SC_PurchOrderNo := RecPurchRcptLine."Order No.";
            END;
        END;
        IF SC_PurchOrderNo = '' THEN BEGIN
            SC_PurchOrderNo := pRecItemLedgerEntry."Document No.";
        END;

        PC_TempInventoryTraceEntry.RESET();
        PC_TempInventoryTraceEntry.SETCURRENTKEY("Posting Date", "Purch. Item No.", "Document Type", "Entry Type");
        PC_TempInventoryTraceEntry.ASCENDING(FALSE);
        PC_TempInventoryTraceEntry.SETFILTER("Posting Date", '..%1', pRecItemLedgerEntry."Posting Date");
        PC_TempInventoryTraceEntry.SETRANGE("Document Type", PC_TempInventoryTraceEntry."Document Type"::"Sales Shipment");
        PC_TempInventoryTraceEntry.SETRANGE("Item No", SC_OrgItemNo);
        PC_TempInventoryTraceEntry.SETRANGE("External Document No.", SC_PurchOrderNo);
        PC_TempInventoryTraceEntry.SETFILTER(Quantity, '<%1', 0);
        IF PC_TempInventoryTraceEntry.FINDSET() THEN
            REPEAT
                RecInventoryTraceEntry.RESET();
                RecInventoryTraceEntry.INIT();
                RecInventoryTraceEntry."Entry No." := 0;
                RecInventoryTraceEntry."Item Application Entry No." := pRecItemApplicationEntry."Entry No.";
                RecInventoryTraceEntry."Item Ledger Entry No." := pRecItemApplicationEntry."Item Ledger Entry No.";

                RecInventoryTraceEntry."Entry Type" := pRecItemLedgerEntry."Entry Type";
                RecInventoryTraceEntry."Document Type" := pRecItemLedgerEntry."Document Type";
                RecInventoryTraceEntry."Document No." := pRecItemLedgerEntry."Document No.";
                RecInventoryTraceEntry."Posting Date" := pRecItemLedgerEntry."Posting Date";
                RecInventoryTraceEntry."Item No" := pRecItemLedgerEntry."Item No.";
                //RecInventoryTraceEntry."Item Description" := pRecItemLedgerEntry."Item Description"; //TODO
                RecInventoryTraceEntry."Purch. Item No." := RecInventoryTraceEntry."Item No";
                RecInventoryTraceEntry."External Document No." := pRecItemLedgerEntry."External Document No.";
                RecInventoryTraceEntry."Incoming Item Ledger Entry No." := pRecItemLedgerEntry."Entry No.";

                IF RecItem."No." <> RecInventoryTraceEntry."Item No" THEN BEGIN
                    RecItem.GET(RecInventoryTraceEntry."Item No");
                END;

                RecInventoryTraceEntry."Customer No." := RecItem."Customer No.";
                RecInventoryTraceEntry."OEM No." := RecItem."OEM No.";
                RecInventoryTraceEntry."Vendor No." := RecItem."Vendor No.";
                RecInventoryTraceEntry."Manufacturer Code" := RecItem."Manufacturer Code";
                RecInventoryTraceEntry."Purch. Item Vendor No." := RecItem."Vendor No.";
                RecInventoryTraceEntry."Purch. Item Manufacturer Code" := RecItem."Manufacturer Code";

                IF RecVendor."No." <> RecInventoryTraceEntry."Vendor No." THEN BEGIN
                    RecVendor.GET(RecInventoryTraceEntry."Vendor No.");
                END;
                RecInventoryTraceEntry."Vendor Name" := RecVendor.Name;
                RecInventoryTraceEntry."Purch. Item Vendor Name" := RecVendor.Name;
                RecInventoryTraceEntry."Purch. Hagiwara Group" := RecVendor."Hagiwara Group";

                RecPurchasePrice.RESET();
                RecPurchasePrice.SETRANGE("Asset No.", RecInventoryTraceEntry."Item No");
                RecPurchasePrice.SETCURRENTKEY("Starting Date");
                RecPurchasePrice.ASCENDING(FALSE);
                RecPurchasePrice.SETFILTER("Starting Date", '<=%1', RecInventoryTraceEntry."Posting Date");
                IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                    RecInventoryTraceEntry."Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                    RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";
                END;

                IF RecCustomer."No." <> RecInventoryTraceEntry."Customer No." THEN BEGIN
                    RecCustomer.GET(RecInventoryTraceEntry."Customer No.");
                END;
                RecInventoryTraceEntry."Customer Name" := RecCustomer.Name;

                IF RecCustomer."No." <> RecInventoryTraceEntry."OEM No." THEN BEGIN
                    RecCustomer.GET(RecInventoryTraceEntry."OEM No.");
                END;
                RecInventoryTraceEntry."OEM Name" := RecCustomer.Name;
                RecInventoryTraceEntry."SCM Customer Code" := RecCustomer."Vendor Cust. Code";

                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                    RecPurchRcptLine.RESET();
                    RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                    IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                        RecInventoryTraceEntry."Direct Unit Cost" := RecPurchRcptLine."Direct Unit Cost";
                    END;
                    IF RecPurchRcptHeader.GET(RecInventoryTraceEntry."Document No.") THEN BEGIN
                        RecInventoryTraceEntry."Cost Currency" := RecPurchRcptHeader."Currency Code";
                    END;

                END;

                RecInventoryTraceEntry."PC. Entry No." := PC_TempInventoryTraceEntry."Entry No.";
                RecInventoryTraceEntry."PC. Cost Currency" := PC_TempInventoryTraceEntry."Cost Currency";
                RecInventoryTraceEntry."PC. Direct Unit Cost" := PC_TempInventoryTraceEntry."Direct Unit Cost";
                RecInventoryTraceEntry."New PC. Cost Currency" := PC_TempInventoryTraceEntry."New PC. Cost Currency";
                RecInventoryTraceEntry."New PC. Direct Unit Cost" := PC_TempInventoryTraceEntry."New PC. Direct Unit Cost";

                IF RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Purchase Receipt" THEN BEGIN
                    //BG017
                    //RecInventoryTraceEntry."Purchase Order No." := RecItemLedgerEntry."Purchase Order No.";
                    RecPurchRcptLine.RESET();
                    RecPurchRcptLine.SETRANGE("Item Rcpt. Entry No.", RecInventoryTraceEntry."Item Ledger Entry No.");
                    IF RecPurchRcptLine.FINDFIRST() THEN BEGIN
                        RecInventoryTraceEntry."Purchase Order No." := RecPurchRcptLine."Order No.";
                    END;
                    //BG017
                END ELSE BEGIN
                    RecInventoryTraceEntry."Purchase Order No." := pRecItemLedgerEntry."Document No.";
                END;

                IF RecInventoryTraceEntry."Cost Currency" = '' THEN BEGIN
                    RecInventoryTraceEntry."Cost Currency" := GRecGeneralLedgerSetup."LCY Code";
                END;

                RecInventoryTraceEntry."Document Line No." := pRecItemLedgerEntry."Document Line No.";

                //sign of M(A).
                //QtyApply(IAE): >0
                //QtyApplied(ITE): <0
                IF ABS(QtyApplied + PC_TempInventoryTraceEntry.Quantity) < ABS(QtyApply) THEN BEGIN
                    RecInventoryTraceEntry.Quantity := PC_TempInventoryTraceEntry.Quantity * -1;
                END ELSE BEGIN
                    RecInventoryTraceEntry.Quantity := QtyApply + QtyApplied;
                    IsBreak := TRUE;
                END;
                QtyApplied := QtyApplied + PC_TempInventoryTraceEntry.Quantity;

                RecInventoryTraceEntry.Pattern := 'M';
                ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                RecInventoryTraceEntry.INSERT();

                rtnPtnMProcessed := TRUE;

            UNTIL (PC_TempInventoryTraceEntry.NEXT() = 0) OR IsBreak;

        EXIT(rtnPtnMProcessed);
    end;

    local procedure OptmPatternD()
    var
        RecInventoryTraceEntry: Record "Inventory Trace Entry";
        TempInventoryTraceEntry: Record "Inventory Trace Entry";
        SpecPtnITE_TempRec: Record "Inventory Trace Entry" temporary;
    begin
        RecInventoryTraceEntry.RESET();
        RecInventoryTraceEntry.SETRANGE(Pattern, 'D');
        IF RecInventoryTraceEntry.FINDSET() THEN
            REPEAT
                IF RecInventoryTraceEntry."Document No." = RecInventoryTraceEntry."Purchase Order No." THEN BEGIN
                    IF ((RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::Sale)
                        AND (RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::"Sales Shipment")
                      ) OR ((RecInventoryTraceEntry."Entry Type" = RecInventoryTraceEntry."Entry Type"::"Negative Adjmt.")
                        AND (RecInventoryTraceEntry."Document Type" = RecInventoryTraceEntry."Document Type"::" ")
                      ) THEN BEGIN

                        SpecPtnITE_TempRec.RESET();
                        SpecPtnITE_TempRec.DELETEALL();

                        TempInventoryTraceEntry.RESET();
                        TempInventoryTraceEntry.SETRANGE(Pattern, 'A1');
                        TempInventoryTraceEntry.SETRANGE("Purch. Item No.", RecInventoryTraceEntry."Purch. Item No.");

                        IF TempInventoryTraceEntry.FINDFIRST() THEN BEGIN
                            SpecPtnITE_TempRec.COPY(TempInventoryTraceEntry);
                            SpecPtnITE_TempRec.INSERT();
                        END;

                        SpecPtnITE_TempRec.RESET();
                        IF SpecPtnITE_TempRec.FINDFIRST() THEN BEGIN
                            RecInventoryTraceEntry."Purchase Order No." := SpecPtnITE_TempRec."Purchase Order No.";
                            RecInventoryTraceEntry."Cost Currency" := SpecPtnITE_TempRec."Cost Currency";
                            RecInventoryTraceEntry."Direct Unit Cost" := SpecPtnITE_TempRec."Direct Unit Cost";
                            RecInventoryTraceEntry."New Cost Currency" := SpecPtnITE_TempRec."New Cost Currency";
                            RecInventoryTraceEntry."New Direct Unit Cost" := SpecPtnITE_TempRec."New Direct Unit Cost";
                            RecInventoryTraceEntry."PC. Cost Currency" := SpecPtnITE_TempRec."PC. Cost Currency";
                            RecInventoryTraceEntry."PC. Direct Unit Cost" := SpecPtnITE_TempRec."PC. Direct Unit Cost";
                            RecInventoryTraceEntry."New PC. Cost Currency" := SpecPtnITE_TempRec."New PC. Cost Currency";
                            RecInventoryTraceEntry."New PC. Direct Unit Cost" := SpecPtnITE_TempRec."New PC. Direct Unit Cost";

                            ReadyToInsertInvTraceEntry(RecInventoryTraceEntry);
                            RecInventoryTraceEntry.MODIFY();
                        END;
                    END;
                END;
            UNTIL RecInventoryTraceEntry.NEXT() = 0;
    end;
}

