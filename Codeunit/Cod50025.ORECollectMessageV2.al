codeunit 50025 "ORE Collect Message V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2


    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
    begin

        //"Collect Message_ORDERS"();
        //"Collect Message_ORDCHG"();
        //"Collect Message_INVRPT"();
        //"Collect Message_INVRPT(Monthly)";
        //"Collect Message_SLSRPT"();
        //MESSAGE('ok');
    end;

    var
        //NoSeriesMgt: Codeunit "396"; //BC Upgrade
        PurchaseLine: Record "Purchase Line";
        Item: Record "Item";
        Vendor: Record "Vendor";
        OREMessageHistory: Record "ORE Message History V2";
        PurchaseHeader: Record "Purchase Header";
        Text001: Label 'No data to read';

    procedure "Collect Message_ORDERS"()
    var
        OREMessageCollectionORDERS: Record "ORE Msg Collection ORDERS V2";
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series"; //BC Upgrade
        VendorNo: Code[20];
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History V2";
        CheckDataCode: Boolean;
        TempCheckHistory: Record Location temporary;
        Customer: Record "Customer";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ORECPN: Record "ORE CPN Setup";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;
        HistoryMessageStatus := HistoryMessageStatus::Ready;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("ORE Message Status", PurchaseLine."ORE Message Status"::"Ready to Collect");
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        IF PurchaseLine.FINDSET THEN
            REPEAT
                //Create history data on first time.
                IF HistoryEntry = 0 THEN BEGIN
                    OREMessageHistory.INIT;
                    OREMessageHistory."Entry No." := 0;
                    OREMessageHistory.VALIDATE("Message Name", 'ORDERS');

                    //NoSeriesMgt.InitSeries('OREMHRNOV2', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNOV2');
                    OREMessageHistory.INSERT(TRUE);
                    HistoryEntry := OREMessageHistory."Entry No.";
                    HistoryMessageStatus := OREMessageHistory."Message Status";
                END;

                PurchaseHeader.RESET;
                PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");
                OREMessageCollectionORDERS.INIT;
                OREMessageCollectionORDERS."Entry No." := 0;
                OREMessageCollectionORDERS."History Entry No." := HistoryEntry;
                OREMessageCollectionORDERS."Message Status" := HistoryMessageStatus;
                OREMessageCollectionORDERS."Order No." := PurchaseHeader."No.";
                OREMessageCollectionORDERS."Order Date" := PurchaseHeader."Order Date";
                OREMessageCollectionORDERS."Ship-to Code" := PurchaseHeader."Location Code";
                IF PurchaseHeader."Currency Code" <> '' THEN
                    OREMessageCollectionORDERS."Currency Code" := PurchaseHeader."Currency Code"
                ELSE
                    OREMessageCollectionORDERS."Currency Code" := GeneralLedgerSetup."LCY Code";
                OREMessageCollectionORDERS."Line No." := PurchaseLine."Line No.";
                OREMessageCollectionORDERS."Item No." := PurchaseLine."No.";
                OREMessageCollectionORDERS.Description := PurchaseLine.Description;
                OREMessageCollectionORDERS.Quantity := PurchaseLine.Quantity;
                OREMessageCollectionORDERS."Direct Unit Cost" := PurchaseLine."Direct Unit Cost";
                Item.RESET;
                Item.GET(PurchaseLine."No.");
                Customer.RESET;
                Customer.GET(Item."OEM No.");
                OREMessageCollectionORDERS."Customer No." := Item."Customer No.";
                OREMessageCollectionORDERS."Requested Receipt Date" := PurchaseLine."Requested Receipt Date_1";
                OREMessageCollectionORDERS."ORE Customer Name" := Customer."ORE Customer Name";
                OREMessageCollectionORDERS."ORE Line No." := PurchaseLine."ORE Line No.";

                OREMessageCollectionORDERS."Ship&Debit Flag" := GetShipDebitFlag(OREMessageCollectionORDERS."Item No.", PurchaseLine."Order Date");
                GetRRAInfo_ORDERS(OREMessageCollectionORDERS);
                IF OREMessageCollectionORDERS."Reverse Routing Address" = '' THEN BEGIN
                    OREMessageCollectionORDERS."RRA NULL Flag" := 'TRUE';
                END;
                OREMessageCollectionORDERS."Renesas Category Code" := Item."Renesas Category Code";

                IF ORECPN.GET(Item."ORE CPN") THEN BEGIN
                    OREMessageCollectionORDERS."ORE CPN" := ORECPN.CPN;
                END;

                OREMessageCollectionORDERS.INSERT(TRUE);

                PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::Collected;
                PurchaseLine.MODIFY;

            UNTIL PurchaseLine.NEXT = 0;
    end;

    procedure "Collect Message_ORDCHG"()
    var
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series"; //BC Upgrade
        OREMessageCollectionORDCHG: Record "ORE Msg Collection ORDCHG V2";
        OrdchgNo: Integer;
        OREMessageCollectionORDERS: Record "ORE Msg Collection ORDERS V2";
        VendorNo: Code[20];
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History V2";
        CheckDataCode: Boolean;
        TempCheckHistory: Record "Location" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        ORECPN: Record "ORE CPN Setup";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;
        HistoryMessageStatus := HistoryMessageStatus::Ready;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("ORE Change Status", PurchaseLine."ORE Change Status"::Changed);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        IF PurchaseLine.FINDSET THEN
            REPEAT
                //Create history data on first time.
                IF HistoryEntry = 0 THEN BEGIN
                    OREMessageHistory.INIT;
                    OREMessageHistory."Entry No." := 0;
                    OREMessageHistory.VALIDATE("Message Name", 'ORDCHG');

                    //NoSeriesMgt.InitSeries('OREMHRNOV2', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNOV2');
                    OREMessageHistory.INSERT(TRUE);
                    HistoryEntry := OREMessageHistory."Entry No.";
                    HistoryMessageStatus := OREMessageHistory."Message Status";
                END;

                PurchaseHeader.RESET;
                PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");

                OREMessageCollectionORDCHG.INIT;
                OREMessageCollectionORDCHG."Entry No." := 0;
                OREMessageCollectionORDCHG."History Entry No." := HistoryEntry;
                OREMessageCollectionORDCHG."Message Status" := HistoryMessageStatus;

                OREMessageCollectionORDERS.RESET;
                OREMessageCollectionORDERS.SETRANGE("Order No.", PurchaseHeader."No.");
                OREMessageCollectionORDERS.SETRANGE("Line No.", PurchaseLine."Line No.");

                IF OREMessageCollectionORDERS.ISEMPTY THEN
                    OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Added
                ELSE IF PurchaseLine.Quantity = 0 THEN
                    OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Deleted
                ELSE
                    OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Changed;

                OREMessageCollectionORDCHG."Order No." := PurchaseHeader."No.";
                OREMessageCollectionORDCHG."Order Date" := PurchaseHeader."Order Date";
                OREMessageCollectionORDCHG."Ship-to Code" := PurchaseHeader."Location Code";

                IF PurchaseHeader."Currency Code" <> '' THEN
                    OREMessageCollectionORDCHG."Currency Code" := PurchaseHeader."Currency Code"
                ELSE
                    OREMessageCollectionORDCHG."Currency Code" := GeneralLedgerSetup."LCY Code";

                OREMessageCollectionORDCHG."Line No." := PurchaseLine."Line No.";
                OREMessageCollectionORDCHG."Item No." := PurchaseLine."No.";
                OREMessageCollectionORDCHG.Description := PurchaseLine.Description;
                OREMessageCollectionORDCHG.Quantity := PurchaseLine.Quantity;
                OREMessageCollectionORDCHG."Requested Receipt Date" := PurchaseLine."Requested Receipt Date_1";
                OREMessageCollectionORDCHG."ORE Line No." := PurchaseLine."ORE Line No.";

                OREMessageCollectionORDCHG."Ship&Debit Flag" := GetShipDebitFlag(OREMessageCollectionORDCHG."Item No.", PurchaseLine."Order Date");
                GetRRAInfo_ORDCHG(OREMessageCollectionORDCHG);
                IF OREMessageCollectionORDCHG."Reverse Routing Address" = '' THEN BEGIN
                    OREMessageCollectionORDCHG."RRA NULL Flag" := 'TRUE';
                END;
                Item.GET(PurchaseLine."No.");
                OREMessageCollectionORDCHG."Renesas Category Code" := Item."Renesas Category Code";

                IF ORECPN.GET(Item."ORE CPN") THEN BEGIN
                    OREMessageCollectionORDCHG."ORE CPN" := ORECPN.CPN;
                END;

                OREMessageCollectionORDCHG.INSERT(TRUE);

                PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Collected;
                PurchaseLine.MODIFY;

            UNTIL PurchaseLine.NEXT = 0;
    end;

    procedure "Collect Message_INVRPT(Weekly)"()
    var
    begin

        "Collect Message_INVRPT"('WEEKLY');
    end;

    procedure "Collect Message_INVRPT(Monthly)"()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.GET;

        //CS115 Shawn Begin
        OREMessageHistory.RESET();
        OREMessageHistory.SETRANGE("Message Name", 'INVRPT');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        IF NOT OREMessageHistory.ISEMPTY THEN BEGIN
            GeneralLedgerSetup."INVRPT End Date (Monthly)" := CALCDATE('<CM>', GeneralLedgerSetup."INVRPT End Date (Monthly)" + 1);
            GeneralLedgerSetup.MODIFY(TRUE);
            EXIT;
        END;
        //CS115 Shawn End

        "Collect Message_INVRPT"('MONTHLY');
    end;

    local procedure "Collect Message_INVRPT"(pWeeklyOrMonthly: Code[10])
    var
        DueDate: Date;
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series"; //BC Upgrade
        OREMessageCollectionINVRPT: Record "ORE Msg Collection INVRPT V2";
        OREMsgINVRPTFinder: Record "ORE Msg Collection INVRPT V2";
        OREMsgINVRPTFinder2: Record "ORE Msg Collection INVRPT V2";
        ITE: Record "Inventory Trace Entry";
        ITEFinder: Record "Inventory Trace Entry";
        RENItemNo: Code[20];
        l_recPurchPrice: Record "Price List Line";
        Quantity: Decimal;
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        GeneralLedgerSetup: Record "General Ledger Setup";
        Customer: Record "Customer";
        l_recRENItem: Record "Item";
        ORECPN: Record "ORE CPN Setup";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;

        IF pWeeklyOrMonthly = 'WEEKLY' THEN BEGIN
            DueDate := GeneralLedgerSetup."INVRPT End Date (Weekly)";
        END ELSE BEGIN
            DueDate := GeneralLedgerSetup."INVRPT End Date (Monthly)";
        END;

        Item.RESET;
        Item.SETRANGE("One Renesas EDI", TRUE);
        IF Item.FIND('-') THEN
            REPEAT
                //Create history data on first time.
                IF HistoryEntry = 0 THEN BEGIN
                    OREMessageHistory.INIT;
                    OREMessageHistory."Entry No." := 0;
                    OREMessageHistory.VALIDATE("Message Name", 'INVRPT');

                    //NoSeriesMgt.InitSeries('OREMHRNOV2', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNOV2');
                    OREMessageHistory."Report End Date" := DueDate;
                    OREMessageHistory.INSERT(TRUE);
                    HistoryEntry := OREMessageHistory."Entry No.";
                    HistoryMessageStatus := OREMessageHistory."Message Status";
                END;

                RENItemNo := GetRENItemNo(Item."No.");
                l_recRENItem.GET(RENItemNo);

                OREMsgINVRPTFinder.RESET;
                OREMsgINVRPTFinder.SETRANGE("History Entry No.", HistoryEntry);
                OREMsgINVRPTFinder.SETRANGE("Item No.", RENItemNo);
                IF OREMsgINVRPTFinder.ISEMPTY THEN BEGIN
                    l_recPurchPrice.RESET;
                    l_recPurchPrice.SETCURRENTKEY("Starting Date");
                    l_recPurchPrice.ASCENDING(FALSE);
                    l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase); //BC Upgrade
                    l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active); //BC Upgrade
                    l_recPurchPrice.SETRANGE("Asset No.", RENItemNo); //BC Upgrade
                    l_recPurchPrice.SETFILTER("Starting Date", '..%1', DueDate);
                    IF l_recPurchPrice.FINDFIRST THEN BEGIN
                        IF l_recPurchPrice."Ship&Debit Flag" THEN BEGIN
                            IF l_recPurchPrice."PC. Direct Unit Cost" = 0 THEN BEGIN
                                //Pattern A
                                ITE.RESET;
                                ITE.SETRANGE("REN. Item No.", RENItemNo);
                                ITE.SETFILTER("Posting Date", '..%1', DueDate);
                                ITE.CALCSUMS(Quantity);
                                Quantity := ITE.Quantity; //Group by REN. Item No.

                                OREMessageCollectionINVRPT.INIT;
                                OREMessageCollectionINVRPT."Entry No." := 0;
                                OREMessageCollectionINVRPT."History Entry No." := HistoryEntry;
                                OREMessageCollectionINVRPT."Message Status" := HistoryMessageStatus;
                                OREMessageCollectionINVRPT."Ship-to Code" := GeneralLedgerSetup."Ship-to Code";
                                OREMessageCollectionINVRPT."Ship-to Name" := GeneralLedgerSetup."Ship-to Name";
                                OREMessageCollectionINVRPT."Ship-to Address" := GeneralLedgerSetup."Ship-to Address";
                                OREMessageCollectionINVRPT."Ship-to Address2" := GeneralLedgerSetup."Ship-to Address2";
                                OREMessageCollectionINVRPT."Ship-to City" := GeneralLedgerSetup."Ship-to City";
                                OREMessageCollectionINVRPT."Ship-to County" := GeneralLedgerSetup."Ship-to County";
                                OREMessageCollectionINVRPT."Ship-to Post Code" := GeneralLedgerSetup."Ship-to Post Code";
                                OREMessageCollectionINVRPT."Ship-to Country" := GeneralLedgerSetup."Ship-to Country/Region Code";
                                OREMessageCollectionINVRPT."Item No." := RENItemNo;
                                OREMessageCollectionINVRPT.Description := GetRENItemDesc(RENItemNo);
                                OREMessageCollectionINVRPT.Quantity := Quantity;
                                OREMessageCollectionINVRPT."Inventory Unit Cost" := l_recPurchPrice."Direct Unit Cost"; //PC

                                IF Customer.GET(l_recRENItem."OEM No.") THEN
                                    OREMessageCollectionINVRPT."ORE Customer Name" := Customer."ORE Customer Name";
                                OREMessageCollectionINVRPT."Original Item No." := l_recRENItem."Original Item No.";

                                OREMessageCollectionINVRPT."Currency Code" := l_recPurchPrice."Currency Code"; //PC
                                IF OREMessageCollectionINVRPT."Currency Code" = '' THEN BEGIN
                                    OREMessageCollectionINVRPT."Currency Code" := GeneralLedgerSetup."LCY Code"; //PC
                                END;
                                OREMessageCollectionINVRPT."Ship&Debit Flag" := l_recPurchPrice."Ship&Debit Flag";
                                OREMessageCollectionINVRPT."Renesas Category" := l_recRENItem."Renesas Category Code";
                                OREMessageCollectionINVRPT."Company Category" := OREMessageCollectionINVRPT."Company Category"::PC; //PC

                                GetRRAInfo_INVRPT(OREMessageCollectionINVRPT);
                                IF OREMessageCollectionINVRPT."Reverse Routing Address" = '' THEN BEGIN
                                    OREMessageCollectionINVRPT."RRA NULL Flag" := 'TRUE';
                                END;

                                IF ORECPN.GET(l_recRENItem."ORE CPN") THEN BEGIN
                                    OREMessageCollectionINVRPT."ORE CPN" := ORECPN.CPN;
                                END;

                                OREMessageCollectionINVRPT.INSERT(TRUE);

                            END ELSE BEGIN
                                //Pattern B
                                ITE.RESET;
                                ITE.SETRANGE("REN. Item No.", RENItemNo);
                                ITE.SETFILTER("Posting Date", '..%1', DueDate);
                                ITE.CALCSUMS(Quantity);
                                Quantity := ITE.Quantity; //Group by REN. Item No.

                                OREMessageCollectionINVRPT.INIT;
                                OREMessageCollectionINVRPT."Entry No." := 0;
                                OREMessageCollectionINVRPT."History Entry No." := HistoryEntry;
                                OREMessageCollectionINVRPT."Message Status" := HistoryMessageStatus;
                                OREMessageCollectionINVRPT."Ship-to Code" := GeneralLedgerSetup."Ship-to Code";
                                OREMessageCollectionINVRPT."Ship-to Name" := GeneralLedgerSetup."Ship-to Name";
                                OREMessageCollectionINVRPT."Ship-to Address" := GeneralLedgerSetup."Ship-to Address";
                                OREMessageCollectionINVRPT."Ship-to Address2" := GeneralLedgerSetup."Ship-to Address2";
                                OREMessageCollectionINVRPT."Ship-to City" := GeneralLedgerSetup."Ship-to City";
                                OREMessageCollectionINVRPT."Ship-to County" := GeneralLedgerSetup."Ship-to County";
                                OREMessageCollectionINVRPT."Ship-to Post Code" := GeneralLedgerSetup."Ship-to Post Code";
                                OREMessageCollectionINVRPT."Ship-to Country" := GeneralLedgerSetup."Ship-to Country/Region Code";
                                OREMessageCollectionINVRPT."Item No." := RENItemNo;
                                OREMessageCollectionINVRPT.Description := GetRENItemDesc(RENItemNo);
                                OREMessageCollectionINVRPT.Quantity := Quantity;
                                OREMessageCollectionINVRPT."Inventory Unit Cost" := l_recPurchPrice."PC. Direct Unit Cost"; //SC

                                IF Customer.GET(l_recRENItem."OEM No.") THEN
                                    OREMessageCollectionINVRPT."ORE Customer Name" := Customer."ORE Customer Name";
                                OREMessageCollectionINVRPT."Original Item No." := l_recRENItem."Original Item No.";

                                OREMessageCollectionINVRPT."Currency Code" := l_recPurchPrice."PC. Currency Code"; //SC
                                IF OREMessageCollectionINVRPT."Currency Code" = '' THEN BEGIN
                                    OREMessageCollectionINVRPT."Currency Code" := GeneralLedgerSetup."LCY Code"; //SC
                                END;
                                OREMessageCollectionINVRPT."Ship&Debit Flag" := l_recPurchPrice."Ship&Debit Flag";
                                OREMessageCollectionINVRPT."Renesas Category" := l_recRENItem."Renesas Category Code";
                                OREMessageCollectionINVRPT."Company Category" := OREMessageCollectionINVRPT."Company Category"::SC; //SC

                                GetRRAInfo_INVRPT(OREMessageCollectionINVRPT);
                                IF OREMessageCollectionINVRPT."Reverse Routing Address" = '' THEN BEGIN
                                    OREMessageCollectionINVRPT."RRA NULL Flag" := 'TRUE';
                                END;

                                IF ORECPN.GET(l_recRENItem."ORE CPN") THEN BEGIN
                                    OREMessageCollectionINVRPT."ORE CPN" := ORECPN.CPN;
                                END;

                                OREMessageCollectionINVRPT.INSERT(TRUE);
                            END;
                        END ELSE BEGIN
                            //Pattern C
                            ITEFinder.RESET;
                            ITEFinder.SETRANGE("REN. Item No.", RENItemNo);
                            ITEFinder.SETFILTER("Posting Date", '..%1', DueDate);
                            IF ITEFinder.FINDSET THEN
                                REPEAT
                                    OREMsgINVRPTFinder2.RESET;
                                    OREMsgINVRPTFinder2.SETRANGE("History Entry No.", HistoryEntry);
                                    OREMsgINVRPTFinder2.SETRANGE("Item No.", RENItemNo);
                                    OREMsgINVRPTFinder2.SETRANGE("Inventory Unit Cost", ITEFinder."INV. Purchase Price");
                                    OREMsgINVRPTFinder2.SETRANGE("Currency Code", ITEFinder."INV. Purchase Currency");
                                    IF OREMsgINVRPTFinder2.ISEMPTY THEN BEGIN

                                        ITE.RESET;
                                        ITE.SETRANGE("REN. Item No.", RENItemNo);
                                        ITE.SETFILTER("Posting Date", '..%1', DueDate);
                                        ITE.SETRANGE("INV. Purchase Price", ITEFinder."INV. Purchase Price");
                                        ITE.SETRANGE("INV. Purchase Currency", ITEFinder."INV. Purchase Currency");
                                        ITE.CALCSUMS(Quantity);
                                        Quantity := ITE.Quantity; //Group by REN. Item No., INV. Purchase Price, INV. Purchase Currency

                                        OREMessageCollectionINVRPT.INIT;
                                        OREMessageCollectionINVRPT."Entry No." := 0;
                                        OREMessageCollectionINVRPT."History Entry No." := HistoryEntry;
                                        OREMessageCollectionINVRPT."Message Status" := HistoryMessageStatus;
                                        OREMessageCollectionINVRPT."Ship-to Code" := GeneralLedgerSetup."Ship-to Code";
                                        OREMessageCollectionINVRPT."Ship-to Name" := GeneralLedgerSetup."Ship-to Name";
                                        OREMessageCollectionINVRPT."Ship-to Address" := GeneralLedgerSetup."Ship-to Address";
                                        OREMessageCollectionINVRPT."Ship-to Address2" := GeneralLedgerSetup."Ship-to Address2";
                                        OREMessageCollectionINVRPT."Ship-to City" := GeneralLedgerSetup."Ship-to City";
                                        OREMessageCollectionINVRPT."Ship-to County" := GeneralLedgerSetup."Ship-to County";
                                        OREMessageCollectionINVRPT."Ship-to Post Code" := GeneralLedgerSetup."Ship-to Post Code";
                                        OREMessageCollectionINVRPT."Ship-to Country" := GeneralLedgerSetup."Ship-to Country/Region Code";
                                        OREMessageCollectionINVRPT."Item No." := RENItemNo;
                                        OREMessageCollectionINVRPT.Description := GetRENItemDesc(RENItemNo);
                                        OREMessageCollectionINVRPT.Quantity := Quantity;
                                        OREMessageCollectionINVRPT."Inventory Unit Cost" := ITEFinder."INV. Purchase Price"; //Non-SD

                                        IF Customer.GET(l_recRENItem."OEM No.") THEN
                                            OREMessageCollectionINVRPT."ORE Customer Name" := Customer."ORE Customer Name";
                                        OREMessageCollectionINVRPT."Original Item No." := l_recRENItem."Original Item No.";

                                        OREMessageCollectionINVRPT."Currency Code" := ITEFinder."INV. Purchase Currency"; //Non-SD
                                        IF OREMessageCollectionINVRPT."Currency Code" = '' THEN BEGIN
                                            OREMessageCollectionINVRPT."Currency Code" := GeneralLedgerSetup."LCY Code"; //Non-SD
                                        END;
                                        OREMessageCollectionINVRPT."Ship&Debit Flag" := l_recPurchPrice."Ship&Debit Flag";
                                        OREMessageCollectionINVRPT."Renesas Category" := l_recRENItem."Renesas Category Code";
                                        OREMessageCollectionINVRPT."Company Category" := OREMessageCollectionINVRPT."Company Category"::" "; //Non-SD

                                        GetRRAInfo_INVRPT(OREMessageCollectionINVRPT);
                                        IF OREMessageCollectionINVRPT."Reverse Routing Address" = '' THEN BEGIN
                                            OREMessageCollectionINVRPT."RRA NULL Flag" := 'TRUE';
                                        END;

                                        IF ORECPN.GET(l_recRENItem."ORE CPN") THEN BEGIN
                                            OREMessageCollectionINVRPT."ORE CPN" := ORECPN.CPN;
                                        END;

                                        OREMessageCollectionINVRPT.INSERT(TRUE);
                                    END;
                                UNTIL ITEFinder.NEXT = 0;

                        END; //l_recPurchPrice."Ship&Debit Flag"
                    END; //IF l_recPurchPrice.FINDFIRST
                END; //IF OREMsgINVRPTFinder.ISEMPTY

            UNTIL Item.NEXT = 0;

        IF pWeeklyOrMonthly = 'WEEKLY' THEN BEGIN
            GeneralLedgerSetup."INVRPT End Date (Weekly)" := CALCDATE('<CW>', DueDate + 7);
        END ELSE BEGIN
            GeneralLedgerSetup."INVRPT End Date (Monthly)" := CALCDATE('<CM>', DueDate + 1);
        END;
        GeneralLedgerSetup.MODIFY(TRUE);
    end;

    procedure "Collect Message_SLSRPT"()
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        ReturnReceiptLine: Record "Return Receipt Line";
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series"; //BC Upgrade
        OREMessageCollectionSLSRPT: Record "ORE Msg Collection SLSRPT V2";
        OREMsgSLSRPTFinder: Record "ORE Msg Collection SLSRPT V2";
        Customer_OEM: Record "Customer";
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        CheckDataCode: Boolean;
        GeneralLedgerSetup: Record "General Ledger Setup";
        Customer_ORE: Record "Customer";
        ITE: Record "Inventory Trace Entry";
        TransTypeCode: Code[10];
        RENItemNo: Code[20];
        l_recPurchPrice: Record "Price List Line";
        Customer: Record "Customer";
        Item: Record "Item";
        l_recRENItem: Record "Item";
        l_recSalesPrice: Record "Price List Line";
        l_recOrgItem: Record "Item";
        QtySign: Integer;
        ORECPN: Record "ORE CPN Setup";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;

        ITE.RESET;
        ITE.SETFILTER("Posting Date", '%1..%2', GeneralLedgerSetup."SLSRPT Start Date", GeneralLedgerSetup."SLSRPT End Date");
        ITE.SETFILTER("Document Type", '%1|%2', ITE."Document Type"::"Sales Shipment", ITE."Document Type"::"Sales Return Receipt");
        IF ITE.FINDSET THEN
            REPEAT

                IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                    TransTypeCode := '380';
                    QtySign := -1;
                END ELSE BEGIN
                    TransTypeCode := '381';
                    QtySign := 1;
                END;

                IF (NOT IsShipOrRcptUndo(TransTypeCode, ITE."Document No.", ITE."Document Line No.")) THEN BEGIN
                    Item.GET(ITE."Item No");
                    Customer.GET(ITE."Customer No.");
                    IF (NOT Customer."Excluded in ORE Collection") AND (Item."One Renesas EDI") THEN BEGIN

                        //Create history data on first time.
                        IF HistoryEntry = 0 THEN BEGIN
                            OREMessageHistory.INIT;
                            OREMessageHistory."Entry No." := 0;
                            OREMessageHistory.VALIDATE("Message Name", 'SLSRPT');

                            //NoSeriesMgt.InitSeries('OREMHRNOV2', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                            OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNOV2');
                            OREMessageHistory."Report Start Date" := GeneralLedgerSetup."SLSRPT Start Date";
                            OREMessageHistory."Report End Date" := GeneralLedgerSetup."SLSRPT End Date";
                            OREMessageHistory.INSERT(TRUE);
                            HistoryEntry := OREMessageHistory."Entry No.";
                            HistoryMessageStatus := OREMessageHistory."Message Status";
                        END;

                        l_recRENItem.GET(ITE."REN. Item No.");

                        l_recPurchPrice.RESET;
                        l_recPurchPrice.SETCURRENTKEY("Starting Date");
                        l_recPurchPrice.ASCENDING(FALSE);
                        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase); //BC Upgrade
                        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active); //BC Upgrade
                        l_recPurchPrice.SETRANGE("Asset No.", ITE."REN. Item No."); //BC Upgrade
                        l_recPurchPrice.SETFILTER("Starting Date", '..%1', ITE."Posting Date");
                        IF l_recPurchPrice.FINDFIRST THEN BEGIN
                            IF l_recPurchPrice."Ship&Debit Flag" THEN BEGIN
                                IF l_recPurchPrice."PC. Direct Unit Cost" = 0 THEN BEGIN
                                    //Pattern A
                                    OREMsgSLSRPTFinder.RESET;
                                    OREMsgSLSRPTFinder.SETRANGE("History Entry No.", HistoryEntry);
                                    IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                        OREMsgSLSRPTFinder.SETRANGE("Transaction Type", 'Sales Shipment');
                                    END ELSE BEGIN
                                        OREMsgSLSRPTFinder.SETRANGE("Transaction Type", 'Return Receipt');
                                    END;
                                    OREMsgSLSRPTFinder.SETRANGE("Document No.", ITE."Document No.");
                                    OREMsgSLSRPTFinder.SETRANGE("Line No.", ITE."Document Line No.");

                                    IF OREMsgSLSRPTFinder.FINDFIRST THEN BEGIN
                                        //Summarize Quantity
                                        OREMessageCollectionSLSRPT.GET(OREMsgSLSRPTFinder."Entry No.");
                                        OREMessageCollectionSLSRPT.Quantity := OREMessageCollectionSLSRPT.Quantity + ITE.Quantity * QtySign;
                                        OREMessageCollectionSLSRPT.MODIFY();
                                    END ELSE BEGIN

                                        OREMessageCollectionSLSRPT.INIT;
                                        OREMessageCollectionSLSRPT."Entry No." := 0;
                                        OREMessageCollectionSLSRPT."History Entry No." := HistoryEntry;
                                        OREMessageCollectionSLSRPT."Message Status" := HistoryMessageStatus;
                                        OREMessageCollectionSLSRPT."Transaction Type Code" := TransTypeCode;
                                        IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                            OREMessageCollectionSLSRPT."Transaction Type" := 'Sales Shipment';
                                        END ELSE BEGIN
                                            OREMessageCollectionSLSRPT."Transaction Type" := 'Return Receipt';
                                        END;
                                        OREMessageCollectionSLSRPT."Document No." := ITE."Document No.";
                                        OREMessageCollectionSLSRPT."Transaction Date" := ITE."Posting Date";
                                        OREMessageCollectionSLSRPT."External Document No." := ITE."External Document No.";
                                        OREMessageCollectionSLSRPT."Sell-to Customer No." := Item."Customer No.";

                                        Customer_ORE.GET(Item."Customer No.");
                                        OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" := Customer_ORE."ORE Customer Name";
                                        OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" := Customer_ORE."ORE Address";
                                        OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" := Customer_ORE."ORE Address 2";
                                        OREMessageCollectionSLSRPT."Sell-to ORE City" := Customer_ORE."ORE City";
                                        OREMessageCollectionSLSRPT."Sell-to ORE State/Province" := Customer_ORE."ORE State/Province";
                                        OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country";
                                        OREMessageCollectionSLSRPT."Sell-to Post Code" := Customer_ORE."ORE Post Code";
                                        OREMessageCollectionSLSRPT."Sell-to Country/Region Code" := Customer_ORE."Country/Region Code";
                                        OREMessageCollectionSLSRPT."Currency Code" := ITE."Sales Currency";
                                        OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country";
                                        OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" := Customer_ORE."Vendor Cust. Code";

                                        OREMessageCollectionSLSRPT."Line No." := ITE."Document Line No.";
                                        OREMessageCollectionSLSRPT."Sub Line No." := 1; //SD always 1.
                                        OREMessageCollectionSLSRPT."Item No." := ITE."REN. Item No.";
                                        OREMessageCollectionSLSRPT.Description := ITE."REN. Item Description";
                                        OREMessageCollectionSLSRPT.Quantity := ITE.Quantity * QtySign;
                                        OREMessageCollectionSLSRPT."Unit Price" := ITE."Sales Price";
                                        OREMessageCollectionSLSRPT."Inventory Unit Cost" := l_recPurchPrice."ORE Debit Cost"; //PC
                                        OREMessageCollectionSLSRPT."ORE DBC Cost" := l_recPurchPrice."Direct Unit Cost"; //PC


                                        OREMessageCollectionSLSRPT."OEM No." := Item."OEM No.";

                                        Customer_OEM.GET(Item."OEM No.");
                                        OREMessageCollectionSLSRPT."OEM ORE Name" := Customer_OEM."ORE Customer Name";
                                        OREMessageCollectionSLSRPT."OEM ORE Address 1" := Customer_OEM."ORE Address";
                                        OREMessageCollectionSLSRPT."OEM ORE Address 2" := Customer_OEM."ORE Address 2";
                                        OREMessageCollectionSLSRPT."OEM ORE City" := Customer_OEM."ORE City";
                                        OREMessageCollectionSLSRPT."OEM ORE State/Province" := Customer_OEM."ORE State/Province";
                                        OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country";
                                        OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."ORE Post Code";
                                        OREMessageCollectionSLSRPT."OEM Country/Region Code" := Customer_OEM."Country/Region Code";
                                        OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country";
                                        OREMessageCollectionSLSRPT."OEM SCM Code" := Customer_OEM."Vendor Cust. Code";

                                        OREMessageCollectionSLSRPT."Vendor No." := l_recRENItem."Vendor No.";

                                        OREMessageCollectionSLSRPT."Purchase Currency Code" := l_recPurchPrice."Currency Code"; //PC
                                        IF OREMessageCollectionSLSRPT."Purchase Currency Code" = '' THEN BEGIN
                                            OREMessageCollectionSLSRPT."Purchase Currency Code" := GeneralLedgerSetup."LCY Code";
                                        END;

                                        OREMessageCollectionSLSRPT."Original Document No." := ITE."Original Document No.";
                                        OREMessageCollectionSLSRPT."Original Document Line No." := ITE."Original Document Line No.";

                                        OREMessageCollectionSLSRPT."Renesas Report Unit Price" := OREMessageCollectionSLSRPT."Unit Price";
                                        OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := OREMessageCollectionSLSRPT."Currency Code";
                                        l_recSalesPrice.SETCURRENTKEY("Starting Date");
                                        l_recSalesPrice.ASCENDING(FALSE);
                                        l_recSalesPrice.SetRange("Price Type", l_recSalesPrice."Price Type"::Sale); //BC Upgrade
                                        l_recSalesPrice.SetRange(Status, l_recSalesPrice.Status::Active); //BC Upgrade
                                        l_recSalesPrice.SETRANGE("Asset No.", ITE."REN. Item No."); //BC Upgrade
                                        IF l_recSalesPrice.FINDFIRST THEN BEGIN
                                            IF l_recSalesPrice."Renesas Report Unit Price" <> 0 THEN BEGIN
                                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := l_recSalesPrice."Renesas Report Unit Price";
                                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := l_recSalesPrice."Renesas Report Unit Price Cur.";
                                            END;
                                        END;
                                        IF OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." = '' THEN BEGIN
                                            OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GeneralLedgerSetup."LCY Code";
                                        END;

                                        IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                            IF SalesShipmentLine.GET(ITE."Document No.", ITE."Document Line No.") THEN BEGIN
                                                l_recOrgItem.GET(SalesShipmentLine."No.");
                                            END;
                                        END ELSE BEGIN
                                            IF ReturnReceiptLine.GET(ITE."Document No.", ITE."Document Line No.") THEN BEGIN
                                                l_recOrgItem.GET(ReturnReceiptLine."No.");
                                            END;
                                        END;
                                        OREMessageCollectionSLSRPT."Original Item No." := l_recOrgItem."Original Item No.";
                                        OREMessageCollectionSLSRPT."Original Document Sub Line No." := 1; //PC

                                        OREMessageCollectionSLSRPT."Ship&Debit Flag" := l_recPurchPrice."Ship&Debit Flag"; //PC
                                        OREMessageCollectionSLSRPT."Renesas Category" := l_recRENItem."Renesas Category Code";
                                        OREMessageCollectionSLSRPT."Company Category" := OREMessageCollectionSLSRPT."Company Category"::PC; //PC
                                        GetRRAInfo_SLSRPT(OREMessageCollectionSLSRPT);
                                        IF OREMessageCollectionSLSRPT."Reverse Routing Address" = '' THEN BEGIN
                                            OREMessageCollectionSLSRPT."RRA NULL Flag" := 'TRUE';
                                        END;

                                        IF ORECPN.GET(l_recRENItem."ORE CPN") THEN BEGIN
                                            OREMessageCollectionSLSRPT."ORE CPN" := ORECPN.CPN;
                                        END;

                                        OREMessageCollectionSLSRPT.INSERT(TRUE);
                                    END;
                                END ELSE BEGIN
                                    //Pattern B
                                    OREMsgSLSRPTFinder.RESET;
                                    OREMsgSLSRPTFinder.SETRANGE("History Entry No.", HistoryEntry);
                                    IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                        OREMsgSLSRPTFinder.SETRANGE("Transaction Type", 'Sales Shipment');
                                    END ELSE BEGIN
                                        OREMsgSLSRPTFinder.SETRANGE("Transaction Type", 'Return Receipt');
                                    END;
                                    OREMsgSLSRPTFinder.SETRANGE("Document No.", ITE."Document No.");
                                    OREMsgSLSRPTFinder.SETRANGE("Line No.", ITE."Document Line No.");

                                    IF OREMsgSLSRPTFinder.FINDFIRST THEN BEGIN
                                        //Summarize Quantity
                                        OREMessageCollectionSLSRPT.GET(OREMsgSLSRPTFinder."Entry No.");
                                        OREMessageCollectionSLSRPT.Quantity := OREMessageCollectionSLSRPT.Quantity + ITE.Quantity * QtySign;
                                        OREMessageCollectionSLSRPT.MODIFY();
                                    END ELSE BEGIN

                                        OREMessageCollectionSLSRPT.INIT;
                                        OREMessageCollectionSLSRPT."Entry No." := 0;
                                        OREMessageCollectionSLSRPT."History Entry No." := HistoryEntry;
                                        OREMessageCollectionSLSRPT."Message Status" := HistoryMessageStatus;
                                        OREMessageCollectionSLSRPT."Transaction Type Code" := TransTypeCode;
                                        IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                            OREMessageCollectionSLSRPT."Transaction Type" := 'Sales Shipment';
                                        END ELSE BEGIN
                                            OREMessageCollectionSLSRPT."Transaction Type" := 'Return Receipt';
                                        END;
                                        OREMessageCollectionSLSRPT."Document No." := ITE."Document No.";
                                        OREMessageCollectionSLSRPT."Transaction Date" := ITE."Posting Date";
                                        OREMessageCollectionSLSRPT."External Document No." := ITE."External Document No.";
                                        OREMessageCollectionSLSRPT."Sell-to Customer No." := Item."Customer No.";

                                        Customer_ORE.GET(Item."Customer No.");
                                        OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" := Customer_ORE."ORE Customer Name";
                                        OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" := Customer_ORE."ORE Address";
                                        OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" := Customer_ORE."ORE Address 2";
                                        OREMessageCollectionSLSRPT."Sell-to ORE City" := Customer_ORE."ORE City";
                                        OREMessageCollectionSLSRPT."Sell-to ORE State/Province" := Customer_ORE."ORE State/Province";
                                        OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country";
                                        OREMessageCollectionSLSRPT."Sell-to Post Code" := Customer_ORE."ORE Post Code";
                                        OREMessageCollectionSLSRPT."Sell-to Country/Region Code" := Customer_ORE."Country/Region Code";
                                        OREMessageCollectionSLSRPT."Currency Code" := ITE."Sales Currency";
                                        OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country";
                                        OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" := Customer_ORE."Vendor Cust. Code";

                                        OREMessageCollectionSLSRPT."Line No." := ITE."Document Line No.";
                                        OREMessageCollectionSLSRPT."Sub Line No." := 1; //SD always 1.
                                        OREMessageCollectionSLSRPT."Item No." := ITE."REN. Item No.";
                                        OREMessageCollectionSLSRPT.Description := ITE."REN. Item Description";
                                        OREMessageCollectionSLSRPT.Quantity := ITE.Quantity * QtySign;
                                        OREMessageCollectionSLSRPT."Unit Price" := ITE."Sales Price";
                                        OREMessageCollectionSLSRPT."Inventory Unit Cost" := l_recPurchPrice."ORE Debit Cost"; //SC
                                        OREMessageCollectionSLSRPT."ORE DBC Cost" := l_recPurchPrice."PC. Direct Unit Cost"; //SC

                                        OREMessageCollectionSLSRPT."OEM No." := Item."OEM No.";

                                        Customer_OEM.GET(Item."OEM No.");
                                        OREMessageCollectionSLSRPT."OEM ORE Name" := Customer_OEM."ORE Customer Name";
                                        OREMessageCollectionSLSRPT."OEM ORE Address 1" := Customer_OEM."ORE Address";
                                        OREMessageCollectionSLSRPT."OEM ORE Address 2" := Customer_OEM."ORE Address 2";
                                        OREMessageCollectionSLSRPT."OEM ORE City" := Customer_OEM."ORE City";
                                        OREMessageCollectionSLSRPT."OEM ORE State/Province" := Customer_OEM."ORE State/Province";
                                        OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country";
                                        OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."ORE Post Code";
                                        OREMessageCollectionSLSRPT."OEM Country/Region Code" := Customer_OEM."Country/Region Code";
                                        OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country";
                                        OREMessageCollectionSLSRPT."OEM SCM Code" := Customer_OEM."Vendor Cust. Code";

                                        OREMessageCollectionSLSRPT."Vendor No." := l_recRENItem."Vendor No.";

                                        OREMessageCollectionSLSRPT."Purchase Currency Code" := l_recPurchPrice."PC. Currency Code"; //SC
                                        IF OREMessageCollectionSLSRPT."Purchase Currency Code" = '' THEN BEGIN
                                            OREMessageCollectionSLSRPT."Purchase Currency Code" := GeneralLedgerSetup."LCY Code";
                                        END;

                                        OREMessageCollectionSLSRPT."Original Document No." := ITE."Original Document No.";
                                        OREMessageCollectionSLSRPT."Original Document Line No." := ITE."Original Document Line No.";

                                        OREMessageCollectionSLSRPT."Renesas Report Unit Price" := OREMessageCollectionSLSRPT."Unit Price";
                                        OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := OREMessageCollectionSLSRPT."Currency Code";
                                        l_recSalesPrice.SETCURRENTKEY("Starting Date");
                                        l_recSalesPrice.ASCENDING(FALSE);
                                        l_recSalesPrice.SetRange("Price Type", l_recSalesPrice."Price Type"::Sale); //BC Upgrade
                                        l_recSalesPrice.SetRange(Status, l_recSalesPrice.Status::Active); //BC Upgrade
                                        l_recSalesPrice.SETRANGE("Asset No.", ITE."REN. Item No."); //BC Upgrade
                                        IF l_recSalesPrice.FINDFIRST THEN BEGIN
                                            IF l_recSalesPrice."Renesas Report Unit Price" <> 0 THEN BEGIN
                                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := l_recSalesPrice."Renesas Report Unit Price";
                                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := l_recSalesPrice."Renesas Report Unit Price Cur.";
                                            END;
                                        END;
                                        IF OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." = '' THEN BEGIN
                                            OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GeneralLedgerSetup."LCY Code";
                                        END;

                                        IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                            IF SalesShipmentLine.GET(ITE."Document No.", ITE."Document Line No.") THEN BEGIN
                                                l_recOrgItem.GET(SalesShipmentLine."No.");
                                            END;
                                        END ELSE BEGIN
                                            IF ReturnReceiptLine.GET(ITE."Document No.", ITE."Document Line No.") THEN BEGIN
                                                l_recOrgItem.GET(ReturnReceiptLine."No.");
                                            END;
                                        END;
                                        OREMessageCollectionSLSRPT."Original Item No." := l_recOrgItem."Original Item No.";
                                        OREMessageCollectionSLSRPT."Original Document Sub Line No." := 1; //SC

                                        OREMessageCollectionSLSRPT."Ship&Debit Flag" := l_recPurchPrice."Ship&Debit Flag"; //SC
                                        OREMessageCollectionSLSRPT."Renesas Category" := l_recRENItem."Renesas Category Code";
                                        OREMessageCollectionSLSRPT."Company Category" := OREMessageCollectionSLSRPT."Company Category"::SC; //SC
                                        GetRRAInfo_SLSRPT(OREMessageCollectionSLSRPT);
                                        IF OREMessageCollectionSLSRPT."Reverse Routing Address" = '' THEN BEGIN
                                            OREMessageCollectionSLSRPT."RRA NULL Flag" := 'TRUE';
                                        END;

                                        IF ORECPN.GET(l_recRENItem."ORE CPN") THEN BEGIN
                                            OREMessageCollectionSLSRPT."ORE CPN" := ORECPN.CPN;
                                        END;

                                        OREMessageCollectionSLSRPT.INSERT(TRUE);
                                    END;
                                END;
                            END ELSE BEGIN
                                //Pattern C

                                OREMessageCollectionSLSRPT.INIT;
                                OREMessageCollectionSLSRPT."Entry No." := 0;
                                OREMessageCollectionSLSRPT."History Entry No." := HistoryEntry;
                                OREMessageCollectionSLSRPT."Message Status" := HistoryMessageStatus;
                                OREMessageCollectionSLSRPT."Transaction Type Code" := TransTypeCode;
                                IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                    OREMessageCollectionSLSRPT."Transaction Type" := 'Sales Shipment';
                                END ELSE BEGIN
                                    OREMessageCollectionSLSRPT."Transaction Type" := 'Return Receipt';
                                END;
                                OREMessageCollectionSLSRPT."Document No." := ITE."Document No.";
                                OREMessageCollectionSLSRPT."Transaction Date" := ITE."Posting Date";
                                OREMessageCollectionSLSRPT."External Document No." := ITE."External Document No.";
                                OREMessageCollectionSLSRPT."Sell-to Customer No." := Item."Customer No.";

                                Customer_ORE.GET(Item."Customer No.");
                                OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" := Customer_ORE."ORE Customer Name";
                                OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" := Customer_ORE."ORE Address";
                                OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" := Customer_ORE."ORE Address 2";
                                OREMessageCollectionSLSRPT."Sell-to ORE City" := Customer_ORE."ORE City";
                                OREMessageCollectionSLSRPT."Sell-to ORE State/Province" := Customer_ORE."ORE State/Province";
                                OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country";
                                OREMessageCollectionSLSRPT."Sell-to Post Code" := Customer_ORE."ORE Post Code";
                                OREMessageCollectionSLSRPT."Sell-to Country/Region Code" := Customer_ORE."Country/Region Code";
                                OREMessageCollectionSLSRPT."Currency Code" := ITE."Sales Currency";
                                OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country";
                                OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" := Customer_ORE."Vendor Cust. Code";

                                OREMessageCollectionSLSRPT."Line No." := ITE."Document Line No.";
                                OREMessageCollectionSLSRPT."Sub Line No." := ITE."Sub Line No."; //Non-SD
                                OREMessageCollectionSLSRPT."Item No." := ITE."REN. Item No.";
                                OREMessageCollectionSLSRPT.Description := ITE."REN. Item Description";
                                OREMessageCollectionSLSRPT.Quantity := ITE.Quantity * QtySign;
                                OREMessageCollectionSLSRPT."Unit Price" := ITE."Sales Price";
                                OREMessageCollectionSLSRPT."Inventory Unit Cost" := ITE."SLS. Purchase Price"; //Non-SD
                                OREMessageCollectionSLSRPT."ORE DBC Cost" := ITE."SLS. Purchase Price"; //Non-SD


                                OREMessageCollectionSLSRPT."OEM No." := Item."OEM No.";

                                Customer_OEM.GET(Item."OEM No.");
                                OREMessageCollectionSLSRPT."OEM ORE Name" := Customer_OEM."ORE Customer Name";
                                OREMessageCollectionSLSRPT."OEM ORE Address 1" := Customer_OEM."ORE Address";
                                OREMessageCollectionSLSRPT."OEM ORE Address 2" := Customer_OEM."ORE Address 2";
                                OREMessageCollectionSLSRPT."OEM ORE City" := Customer_OEM."ORE City";
                                OREMessageCollectionSLSRPT."OEM ORE State/Province" := Customer_OEM."ORE State/Province";
                                OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country";
                                OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."ORE Post Code";
                                OREMessageCollectionSLSRPT."OEM Country/Region Code" := Customer_OEM."Country/Region Code";
                                OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country";
                                OREMessageCollectionSLSRPT."OEM SCM Code" := Customer_OEM."Vendor Cust. Code";

                                OREMessageCollectionSLSRPT."Vendor No." := l_recRENItem."Vendor No.";

                                OREMessageCollectionSLSRPT."Purchase Currency Code" := ITE."SLS. Purchase Currency"; //Non-SD
                                IF OREMessageCollectionSLSRPT."Purchase Currency Code" = '' THEN BEGIN
                                    OREMessageCollectionSLSRPT."Purchase Currency Code" := GeneralLedgerSetup."LCY Code";
                                END;

                                OREMessageCollectionSLSRPT."Original Document No." := ITE."Original Document No.";
                                OREMessageCollectionSLSRPT."Original Document Line No." := ITE."Original Document Line No.";

                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := OREMessageCollectionSLSRPT."Unit Price";
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := OREMessageCollectionSLSRPT."Currency Code";
                                l_recSalesPrice.SETCURRENTKEY("Starting Date");
                                l_recSalesPrice.ASCENDING(FALSE);
                                l_recSalesPrice.SetRange("Price Type", l_recSalesPrice."Price Type"::Sale); //BC Upgrade
                                l_recSalesPrice.SetRange(Status, l_recSalesPrice.Status::Active); //BC Upgrade
                                l_recSalesPrice.SETRANGE("Asset No.", ITE."REN. Item No."); //BC Upgrade
                                IF l_recSalesPrice.FINDFIRST THEN BEGIN
                                    IF l_recSalesPrice."Renesas Report Unit Price" <> 0 THEN BEGIN
                                        OREMessageCollectionSLSRPT."Renesas Report Unit Price" := l_recSalesPrice."Renesas Report Unit Price";
                                        OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := l_recSalesPrice."Renesas Report Unit Price Cur.";
                                    END;
                                END;
                                IF OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." = '' THEN BEGIN
                                    OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GeneralLedgerSetup."LCY Code";
                                END;

                                IF ITE."Document Type" = ITE."Document Type"::"Sales Shipment" THEN BEGIN
                                    IF SalesShipmentLine.GET(ITE."Document No.", ITE."Document Line No.") THEN BEGIN
                                        l_recOrgItem.GET(SalesShipmentLine."No.");
                                    END;
                                END ELSE BEGIN
                                    IF ReturnReceiptLine.GET(ITE."Document No.", ITE."Document Line No.") THEN BEGIN
                                        l_recOrgItem.GET(ReturnReceiptLine."No.");
                                    END;
                                END;
                                OREMessageCollectionSLSRPT."Original Item No." := l_recOrgItem."Original Item No.";
                                OREMessageCollectionSLSRPT."Original Document Sub Line No." := ITE."Original Sub Line No."; //Non-SD

                                OREMessageCollectionSLSRPT."Ship&Debit Flag" := l_recPurchPrice."Ship&Debit Flag"; //Non-SD
                                OREMessageCollectionSLSRPT."Renesas Category" := l_recRENItem."Renesas Category Code";
                                OREMessageCollectionSLSRPT."Company Category" := OREMessageCollectionSLSRPT."Company Category"::" "; //Non-SD
                                GetRRAInfo_SLSRPT(OREMessageCollectionSLSRPT);
                                IF OREMessageCollectionSLSRPT."Reverse Routing Address" = '' THEN BEGIN
                                    OREMessageCollectionSLSRPT."RRA NULL Flag" := 'TRUE';
                                END;

                                IF ORECPN.GET(l_recRENItem."ORE CPN") THEN BEGIN
                                    OREMessageCollectionSLSRPT."ORE CPN" := ORECPN.CPN;
                                END;

                                OREMessageCollectionSLSRPT.INSERT(TRUE);

                            END;
                        END; //IF l_recPurchPrice.FINDFIRST
                    END; //IF (NOT Customer."Excluded in ORE Collection") AND (Item."One Renesas EDI")
                END; //IF (NOT IsShipOrRcptUndo

            UNTIL ITE.NEXT = 0;

        IF GeneralLedgerSetup."DOW to Update Date Filter" + 1 = DATE2DWY(TODAY, 1) THEN BEGIN
            GeneralLedgerSetup."SLSRPT Start Date" := GeneralLedgerSetup."SLSRPT Start Date" + 7;
            GeneralLedgerSetup."SLSRPT End Date" := GeneralLedgerSetup."SLSRPT Start Date" + 6;
            GeneralLedgerSetup.MODIFY;
        END;
    end;

    local procedure GetShipDebitFlag(pItemNo: Code[20]; pDueDate: Date) rtn_Flag: Boolean
    var
        l_recPurchPrice: Record "Price List Line";
        l_recItem: Record "Item";
    begin
        l_recItem.GET(pItemNo);

        l_recPurchPrice.RESET;
        l_recPurchPrice.SETCURRENTKEY("Starting Date");
        l_recPurchPrice.ASCENDING(FALSE);
        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase); //BC Upgrade
        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active); //BC Upgrade
        l_recPurchPrice.SETRANGE("Asset No.", pItemNo); //BC Upgrade
        l_recPurchPrice.SETRANGE("Assign-to No.", l_recItem."Vendor No."); //BC Upgrade
        l_recPurchPrice.SETFILTER("Starting Date", '..%1', pDueDate);

        IF l_recPurchPrice.FINDFIRST THEN
            rtn_Flag := l_recPurchPrice."Ship&Debit Flag";

        EXIT(rtn_Flag);
    end;

    local procedure GetRRAInfo_ORDERS(var pMsg: Record "ORE Msg Collection ORDERS V2")
    var
        l_recItem: Record "Item";
        l_recRRASetup: Record "ORE Rev. Rout. Address Setup";
    begin
        l_recItem.GET(pMsg."Item No.");
        l_recRRASetup.SETRANGE("Ship&Debit Flag", pMsg."Ship&Debit Flag");
        l_recRRASetup.SETRANGE("Renesas Category Code", l_recItem."Renesas Category Code");
        l_recRRASetup.SETRANGE("Currency Code", pMsg."Currency Code");
        IF l_recRRASetup.FINDFIRST THEN BEGIN
            pMsg."Reverse Routing Address" := l_recRRASetup."Order Reverse Routing Address";
            pMsg."Sold-to Code" := l_recRRASetup."Sold-to Code";
            pMsg."Report Sold-to Code" := l_recRRASetup."Report Sold-to Code";
        END;
    end;

    local procedure GetRRAInfo_ORDCHG(var pMsg: Record "ORE Msg Collection ORDCHG V2")
    var
        l_recItem: Record "Item";
        l_recRRASetup: Record "ORE Rev. Rout. Address Setup";
    begin
        l_recItem.GET(pMsg."Item No.");
        l_recRRASetup.SETRANGE("Ship&Debit Flag", pMsg."Ship&Debit Flag");
        l_recRRASetup.SETRANGE("Renesas Category Code", l_recItem."Renesas Category Code");
        l_recRRASetup.SETRANGE("Currency Code", pMsg."Currency Code");
        IF l_recRRASetup.FINDFIRST THEN BEGIN
            pMsg."Reverse Routing Address" := l_recRRASetup."Order Reverse Routing Address";
            pMsg."Sold-to Code" := l_recRRASetup."Sold-to Code";
            pMsg."Report Sold-to Code" := l_recRRASetup."Report Sold-to Code";
        END;
    end;

    local procedure GetRRAInfo_INVRPT(var pMsg: Record "ORE Msg Collection INVRPT V2")
    var
        l_recItem: Record "Item";
        l_recRRASetup: Record "ORE Rev. Rout. Address Setup";
    begin
        l_recItem.GET(pMsg."Item No.");
        l_recRRASetup.SETRANGE("Ship&Debit Flag", pMsg."Ship&Debit Flag");
        l_recRRASetup.SETRANGE("Renesas Category Code", l_recItem."Renesas Category Code");
        l_recRRASetup.SETRANGE("Currency Code", pMsg."Currency Code");
        IF l_recRRASetup.FINDFIRST THEN BEGIN
            pMsg."Reverse Routing Address" := l_recRRASetup."Report Reverse Routing Address";
            pMsg."Sold-to Code" := l_recRRASetup."Sold-to Code";
            pMsg."Report Sold-to Code" := l_recRRASetup."Report Sold-to Code";
        END;
    end;

    local procedure GetRRAInfo_SLSRPT(var pMsg: Record "ORE Msg Collection SLSRPT V2")
    var
        l_recItem: Record "Item";
        l_recRRASetup: Record "ORE Rev. Rout. Address Setup";
    begin
        l_recItem.GET(pMsg."Item No.");
        l_recRRASetup.SETRANGE("Ship&Debit Flag", pMsg."Ship&Debit Flag");
        l_recRRASetup.SETRANGE("Renesas Category Code", l_recItem."Renesas Category Code");
        l_recRRASetup.SETRANGE("Currency Code", pMsg."Renesas Report Unit Price Cur.");
        IF l_recRRASetup.FINDFIRST THEN BEGIN
            pMsg."Reverse Routing Address" := l_recRRASetup."Report Reverse Routing Address";
            pMsg."Sold-to Code" := l_recRRASetup."Sold-to Code";
            pMsg."Report Sold-to Code" := l_recRRASetup."Report Sold-to Code";
        END;
    end;

    local procedure GetRENItemNo(pItemNo: Code[20]) rtnItemNo: Code[20]
    var
        recItem: Record "Item";
        recBom: Record "BOM Component";
    begin
        rtnItemNo := pItemNo;
        IF recItem.GET(pItemNo) THEN BEGIN
            recItem.CALCFIELDS("Assembly BOM");
            IF recItem."Assembly BOM" AND recItem."Written Product" THEN BEGIN
                recBom.SETRANGE("Parent Item No.", pItemNo);
                IF recBom.FINDFIRST THEN BEGIN
                    rtnItemNo := recBom."No.";
                END;
            END;
        END;

        EXIT(rtnItemNo);
    end;

    local procedure GetRENItemDesc(pItemNo: Code[20]): Text[50]
    var
        recItem: Record "Item";
    begin
        IF recItem.GET(pItemNo) THEN BEGIN
            EXIT(recItem.Description);
        END;

        EXIT('');
    end;

    local procedure IsShipOrRcptUndo(pTransTypeCode: Code[10]; pDocNo: Code[20]; pDocLineNo: Integer): Boolean
    var
        l_SalesShipLine: Record "Sales Shipment Line";
        l_RtnRcptLine: Record "Return Receipt Line";
    begin
        IF pTransTypeCode = '380' THEN BEGIN
            IF l_SalesShipLine.GET(pDocNo, pDocLineNo) THEN BEGIN
                EXIT(l_SalesShipLine.Correction);
            END;
        END ELSE BEGIN
            IF l_RtnRcptLine.GET(pDocNo, pDocLineNo) THEN BEGIN
                EXIT(l_RtnRcptLine.Correction);
            END;
        END;

        EXIT(FALSE);
    end;
}

