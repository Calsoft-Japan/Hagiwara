codeunit 50020 "ORE Collect Message"
{
    // CS060 Leon 2023/10/18 - One Renesas EDI
    // CS060 Shawn 2024/02/21 - ORDCHG: Action Type logic changed.
    //                          INVRPT: Set value of ORE Customer Name.
    //                          SLSRPT: Exclude Undo Shipment and Return receipt data.
    // CS060 Shawn 2024/03/09 - changed datamapping and fields according CRs.
    // CS060 Shawn 2024/03/30 - Change datasource and filter date of SLSRPT.
    // CS060 Shawn 2024/06/18 - Get Description, Cost of BOM compoent if Item is Assembled.
    // CS073 Shawn 2024/08/10 - Set "ORE Reverse Routing Address" for each Message.
    // CS060 Shawn 2024/10/02 - CR30. SLSRPT: Original Document No., Original Document Line No.
    // CS089 Naoto 2024/12/22 - One Renesas EDI Modification
    // CS097 Shawn 2025/03/05 - SLSRPT: Use ORE Post Code, etc.
    // CS103 Naoto 2025/04/15 - Change Length of ORE Reverse Routing Address
    // 


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
        //NoSeriesMgt: Codeunit NoSeriesManagement; //BC Upgrade
        PurchaseLine: Record "Purchase Line";
        Item: Record "Item";
        Vendor: Record "Vendor";
        OREMessageHistory: Record "ORE Message History";
        PurchaseHeader: Record "Purchase Header";
        Text001: Label 'No data to read';

    procedure "Collect Message_ORDERS"()
    var
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series";
        VendorNo: Code[20];
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History";
        CheckDataCode: Boolean;
        TempCheckHistory: Record Location temporary;
        Customer: Record "Customer";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.GET;
        VendorNo := '';
        HistoryEntry := 0;
        HistoryMessageStatus := HistoryMessageStatus::Ready;
        TempCheckHistory.RESET;
        TempCheckHistory.DELETEALL;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("ORE Message Status", PurchaseLine."ORE Message Status"::"Ready to Collect");
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        IF PurchaseLine.FIND('-') THEN BEGIN
            REPEAT
                Vendor.RESET;
                Vendor.GET(PurchaseLine."Buy-from Vendor No.");
                CheckDataCode := CheckData('ORDERS', Vendor."ORE Reverse Routing Address", PurchaseLine."Line No.", PurchaseLine."No.", PurchaseLine."Document No.");
                IF NOT CheckDataCode THEN BEGIN
                    IF VendorNo <> PurchaseLine."Buy-from Vendor No." THEN BEGIN
                        VendorNo := PurchaseLine."Buy-from Vendor No.";
                        TempCheckHistory.RESET;
                        TempCheckHistory.SETRANGE(Name, Vendor."ORE Reverse Routing Address");
                        IF TempCheckHistory.FIND('-') THEN BEGIN
                            EVALUATE(HistoryEntry, TempCheckHistory.Code);
                            HistoryMessageStatus := OREMessageHistory."Message Status"::Ready;
                        END
                        ELSE BEGIN
                            OREMessageHistory.INIT;
                            OREMessageHistory."Entry No." := 0;
                            OREMessageHistory.VALIDATE("Message Name", 'ORDERS');
                            OREMessageHistory."Reverse Routing Address" := Vendor."ORE Reverse Routing Address";
                            OREMessageHistory."Reverse Routing Address (SD)" := Vendor."ORE Reverse Routing Address SD"; //CS073

                            //NoSeriesMgt.InitSeries('OREMHRNO', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                            OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNO');
                            OREMessageHistory.INSERT(TRUE);
                            HistoryEntry := OREMessageHistory."Entry No.";
                            HistoryMessageStatus := OREMessageHistory."Message Status";

                            TempCheckHistory.INIT;
                            TempCheckHistory.Code := FORMAT(OREMessageHistory."Entry No.");
                            TempCheckHistory.Name := OREMessageHistory."Reverse Routing Address";
                            TempCheckHistory.INSERT(TRUE);

                        END;
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
                    //Customer.GET(Item."Customer No."); //CS060 Shawn
                    Customer.GET(Item."OEM No."); //CS060 Shawn
                    OREMessageCollectionORDERS."Customer No." := Item."Customer No.";
                    OREMessageCollectionORDERS."Requested Receipt Date" := PurchaseLine."Requested Receipt Date_1";
                    OREMessageCollectionORDERS."ORE Customer Name" := Customer."ORE Customer Name";
                    OREMessageCollectionORDERS."ORE Line No." := PurchaseLine."ORE Line No.";
                    //CS073 Shawn Begin
                    OREMessageCollectionORDERS."ORE Reverse Routing Address" :=
                      GetRevRoutingAddr(
                        PurchaseLine."No.",
                        PurchaseLine."Order Date",
                        Vendor."ORE Reverse Routing Address",
                        Vendor."ORE Reverse Routing Address SD");
                    //CS073 Shawn End
                    OREMessageCollectionORDERS.INSERT(TRUE);

                    PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::Collected;
                    PurchaseLine.MODIFY;
                END;

            UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    procedure "Collect Message_ORDCHG"()
    var
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series";
        OREMessageCollectionORDCHG: Record "ORE Message Collection ORDCHG";
        OrdchgNo: Integer;
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";
        VendorNo: Code[20];
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History";
        CheckDataCode: Boolean;
        TempCheckHistory: Record "Location" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.GET;
        VendorNo := '';
        HistoryEntry := 0;
        HistoryMessageStatus := HistoryMessageStatus::Ready;
        TempCheckHistory.RESET;
        TempCheckHistory.DELETEALL;
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("ORE Change Status", PurchaseLine."ORE Change Status"::Changed);
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        //PurchaseLine.SETRANGE("Document No.",'P016382');
        IF PurchaseLine.FIND('-') THEN BEGIN
            REPEAT
                IF Item.GET(PurchaseLine."No.") THEN BEGIN
                    IF Item."One Renesas EDI" THEN BEGIN
                        Vendor.RESET;
                        Vendor.GET(PurchaseLine."Buy-from Vendor No.");
                        CheckDataCode := CheckData('ORDCHG', Vendor."ORE Reverse Routing Address", PurchaseLine."Line No.", PurchaseLine."No.", PurchaseLine."Document No.");
                        IF NOT CheckDataCode THEN BEGIN
                            IF VendorNo <> PurchaseLine."Buy-from Vendor No." THEN BEGIN
                                VendorNo := PurchaseLine."Buy-from Vendor No.";
                                TempCheckHistory.RESET;
                                TempCheckHistory.SETRANGE(Name, Vendor."ORE Reverse Routing Address");
                                IF TempCheckHistory.FIND('-') THEN BEGIN
                                    EVALUATE(HistoryEntry, TempCheckHistory.Code);
                                    HistoryMessageStatus := OREMessageHistory."Message Status"::Ready;
                                END
                                ELSE BEGIN
                                    OREMessageHistory.INIT;
                                    OREMessageHistory."Entry No." := 0;
                                    OREMessageHistory.VALIDATE("Message Name", 'ORDCHG');
                                    OREMessageHistory."Reverse Routing Address" := Vendor."ORE Reverse Routing Address";
                                    OREMessageHistory."Reverse Routing Address (SD)" := Vendor."ORE Reverse Routing Address SD"; //CS073

                                    //NoSeriesMgt.InitSeries('OREMHRNO', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNO');
                                    OREMessageHistory.INSERT(TRUE);
                                    HistoryEntry := OREMessageHistory."Entry No.";
                                    HistoryMessageStatus := OREMessageHistory."Message Status";

                                    TempCheckHistory.INIT;
                                    TempCheckHistory.Code := FORMAT(OREMessageHistory."Entry No.");
                                    TempCheckHistory.Name := OREMessageHistory."Reverse Routing Address";
                                    TempCheckHistory.INSERT(TRUE);
                                END;
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

                            //CS060 Shawn Begin
                            /*
                                          IF NOT OREMessageCollectionORDERS.ISEMPTY THEN
                                            OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Changed
                                          ELSE
                                            OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Added;
                            */

                            IF OREMessageCollectionORDERS.ISEMPTY THEN
                                OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Added
                            ELSE IF PurchaseLine.Quantity = 0 THEN
                                OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Deleted
                            ELSE
                                OREMessageCollectionORDCHG."Action Type" := OREMessageCollectionORDCHG."Action Type"::Changed;
                            //CS060 Shawn End

                            OREMessageCollectionORDCHG."Order No." := PurchaseHeader."No.";
                            OREMessageCollectionORDCHG."Order Date" := PurchaseHeader."Order Date";
                            OREMessageCollectionORDCHG."Ship-to Code" := PurchaseHeader."Location Code";
                            OREMessageCollectionORDCHG."Line No." := PurchaseLine."Line No.";
                            OREMessageCollectionORDCHG."Item No." := PurchaseLine."No.";
                            OREMessageCollectionORDCHG.Description := PurchaseLine.Description;
                            OREMessageCollectionORDCHG.Quantity := PurchaseLine.Quantity;
                            OREMessageCollectionORDCHG."ORE Line No." := PurchaseLine."ORE Line No.";

                            OREMessageCollectionORDCHG."Requested Receipt Date" := PurchaseLine."Requested Receipt Date_1";
                            //CS073 Shawn Begin
                            OREMessageCollectionORDCHG."ORE Reverse Routing Address" :=
                              GetRevRoutingAddr(
                                PurchaseLine."No.",
                                PurchaseLine."Order Date",
                                Vendor."ORE Reverse Routing Address",
                                Vendor."ORE Reverse Routing Address SD");
                            //CS073 Shawn End
                            OREMessageCollectionORDCHG.INSERT(TRUE);

                            PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Collected;
                            PurchaseLine.MODIFY;
                        END;
                    END;
                END;
            UNTIL PurchaseLine.NEXT = 0;
        END;

    end;

    procedure "Collect Message_INVRPT"()
    var
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series";
        OREMessageCollectionINVRPT: Record "ORE Message Collection INVRPT";
        ValueEntry: Record "Value Entry";
        Quantity: Decimal;
        "CostAmount(Actual)": Decimal;
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History";
        CheckDataCode: Boolean;
        GeneralLedgerSetup: Record "General Ledger Setup";
        Customer: Record "Customer";
        BOM1stItemNo: Code[20];
        l_recItem: Record "Item";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;
        Item.RESET;
        Item.SETRANGE("One Renesas EDI", TRUE);
        IF Item.FIND('-') THEN BEGIN
            REPEAT
                IF HistoryEntry = 0 THEN BEGIN
                    OREMessageHistory.INIT;
                    OREMessageHistory."Entry No." := 0;
                    OREMessageHistory.VALIDATE("Message Name", 'INVRPT');
                    OREMessageHistory."Report End Date" := GeneralLedgerSetup."INVRPT End Date (Weekly)";
                    OREMessageHistory."Reverse Routing Address" := GeneralLedgerSetup."ORE Reverse Routing Address";
                    OREMessageHistory."Reverse Routing Address (SD)" := GeneralLedgerSetup."ORE Reverse Routing Address SD"; //CS073

                    //NoSeriesMgt.InitSeries('OREMHRNO', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNO');
                    OREMessageHistory.INSERT(TRUE);
                    HistoryEntry := OREMessageHistory."Entry No.";
                    HistoryMessageStatus := OREMessageHistory."Message Status";
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item No.", Item."No.");
                ValueEntry.SETFILTER("Posting Date", '<=%1', GeneralLedgerSetup."INVRPT End Date (Weekly)");
                //ValueEntry.CALCSUMS("Valued Quantity","Cost Amount (Actual)");//CS060 Shawn
                //Quantity:=ValueEntry."Valued Quantity";//CS060 Shawn
                ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)");//CS060 Shawn
                Quantity := ValueEntry."Item Ledger Entry Quantity";//CS060 Shawn
                "CostAmount(Actual)" := ValueEntry."Cost Amount (Actual)";

                //CS060 Shawn Begin
                BOM1stItemNo := '';
                Item.CALCFIELDS("Assembly BOM");
                IF Item."Assembly BOM" THEN BEGIN
                    BOM1stItemNo := GetBOM1stItemNo(Item."No.");
                END;
                //CS060 Shawn End
                OREMessageCollectionINVRPT.INIT;
                OREMessageCollectionINVRPT."Entry No." := 0;
                OREMessageCollectionINVRPT."History Entry No." := HistoryEntry;
                OREMessageCollectionINVRPT."Message Status" := HistoryMessageStatus;
                OREMessageCollectionINVRPT."Item No." := Item."No.";
                //OREMessageCollectionINVRPT.Description := Item.Description;//CS060 Shawn
                OREMessageCollectionINVRPT.Quantity := Quantity;
                OREMessageCollectionINVRPT."Cost Amount (Actual)" := "CostAmount(Actual)";
                //OREMessageCollectionINVRPT."ORE DBC Cost" := GetINTRPT_OREUnitCost(Item."No.", GeneralLedgerSetup."INVRPT End Date (Weekly)"); //CS060 Shawn
                //CS060 Shawn Begin
                IF l_recItem.GET(BOM1stItemNo) THEN BEGIN
                    OREMessageCollectionINVRPT.Description := l_recItem.Description;
                    OREMessageCollectionINVRPT."ORE DBC Cost" := GetINTRPT_OREUnitCost(BOM1stItemNo, GeneralLedgerSetup."INVRPT End Date (Weekly)");
                END ELSE BEGIN
                    OREMessageCollectionINVRPT.Description := Item.Description;
                    OREMessageCollectionINVRPT."ORE DBC Cost" := GetINTRPT_OREUnitCost(Item."No.", GeneralLedgerSetup."INVRPT End Date (Weekly)");
                END;
                //CS060 Shawn End
                //CS060 Shawn Begin
                IF Customer.GET(Item."OEM No.") THEN
                    OREMessageCollectionINVRPT."ORE Customer Name" := Customer."ORE Customer Name";
                OREMessageCollectionINVRPT."Original Item No." := Item."Original Item No.";
                //CS060 Shawn End
                //CS073 Shawn Begin
                OREMessageCollectionINVRPT."ORE Reverse Routing Address" :=
                  GetRevRoutingAddr(
                    Item."No.",
                    GeneralLedgerSetup."INVRPT End Date (Weekly)",
                    GeneralLedgerSetup."ORE Reverse Routing Address",
                    GeneralLedgerSetup."ORE Reverse Routing Address SD");
                //CS073 Shawn End
                OREMessageCollectionINVRPT.INSERT(TRUE);

            UNTIL Item.NEXT = 0;
            GeneralLedgerSetup."INVRPT End Date (Weekly)" := CALCDATE('<CW>', GeneralLedgerSetup."INVRPT End Date (Weekly)" + 7);
            GeneralLedgerSetup.MODIFY(TRUE);
        END;
    end;

    procedure "Collect Message_INVRPT(Monthly)"()
    var
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series";
        OREMessageCollectionINVRPT: Record "ORE Message Collection INVRPT";
        ValueEntry: Record "Value Entry";
        Quantity: Decimal;
        "CostAmount(Actual)": Decimal;
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History";
        GeneralLedgerSetup: Record "General Ledger Setup";
        Customer: Record "Customer";
        BOM1stItemNo: Code[20];
        l_recItem: Record "Item";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;
        Item.RESET;
        Item.SETRANGE("One Renesas EDI", TRUE);
        IF Item.FIND('-') THEN BEGIN
            REPEAT

                IF HistoryEntry = 0 THEN BEGIN
                    OREMessageHistory.INIT;
                    OREMessageHistory."Entry No." := 0;
                    OREMessageHistory.VALIDATE("Message Name", 'INVRPT');
                    OREMessageHistory."Report End Date" := GeneralLedgerSetup."INVRPT End Date (Monthly)";
                    OREMessageHistory."Reverse Routing Address" := GeneralLedgerSetup."ORE Reverse Routing Address";
                    OREMessageHistory."Reverse Routing Address (SD)" := GeneralLedgerSetup."ORE Reverse Routing Address SD"; //CS073

                    //NoSeriesMgt.InitSeries('OREMHRNO', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNO');
                    OREMessageHistory.INSERT(TRUE);
                    HistoryEntry := OREMessageHistory."Entry No.";
                    HistoryMessageStatus := OREMessageHistory."Message Status";
                END;
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item No.", Item."No.");
                ValueEntry.SETFILTER("Posting Date", '<=%1', GeneralLedgerSetup."INVRPT End Date (Monthly)");
                //ValueEntry.CALCSUMS("Valued Quantity","Cost Amount (Actual)");//CS060 Shawn
                //Quantity:=ValueEntry."Valued Quantity";//CS060 Shawn
                ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)");//CS060 Shawn
                Quantity := ValueEntry."Item Ledger Entry Quantity";//CS060 Shawn
                "CostAmount(Actual)" := ValueEntry."Cost Amount (Actual)";

                //CS060 Shawn Begin
                BOM1stItemNo := '';
                Item.CALCFIELDS("Assembly BOM");
                IF Item."Assembly BOM" THEN BEGIN
                    BOM1stItemNo := GetBOM1stItemNo(Item."No.");
                END;
                //CS060 Shawn End
                OREMessageCollectionINVRPT.INIT;
                OREMessageCollectionINVRPT."Entry No." := 0;
                OREMessageCollectionINVRPT."History Entry No." := HistoryEntry;
                OREMessageCollectionINVRPT."Message Status" := HistoryMessageStatus;
                OREMessageCollectionINVRPT."Item No." := Item."No.";
                //OREMessageCollectionINVRPT.Description := Item.Description;
                OREMessageCollectionINVRPT.Quantity := Quantity;
                OREMessageCollectionINVRPT."Cost Amount (Actual)" := "CostAmount(Actual)";
                //OREMessageCollectionINVRPT."ORE DBC Cost" := GetINTRPT_OREUnitCost(Item."No.", GeneralLedgerSetup."INVRPT End Date (Monthly)"); //CS060 Shawn
                //CS060 Shawn Begin
                IF l_recItem.GET(BOM1stItemNo) THEN BEGIN
                    OREMessageCollectionINVRPT.Description := l_recItem.Description;
                    OREMessageCollectionINVRPT."ORE DBC Cost" := GetINTRPT_OREUnitCost(BOM1stItemNo, GeneralLedgerSetup."INVRPT End Date (Monthly)");
                END ELSE BEGIN
                    OREMessageCollectionINVRPT.Description := Item.Description;
                    OREMessageCollectionINVRPT."ORE DBC Cost" := GetINTRPT_OREUnitCost(Item."No.", GeneralLedgerSetup."INVRPT End Date (Monthly)");
                END;
                //CS060 Shawn End
                //CS060 Shawn Begin
                IF Customer.GET(Item."Customer No.") THEN
                    OREMessageCollectionINVRPT."ORE Customer Name" := Customer."ORE Customer Name";
                OREMessageCollectionINVRPT."Original Item No." := Item."Original Item No.";
                //CS060 Shawn End
                //CS073 Shawn Begin
                OREMessageCollectionINVRPT."ORE Reverse Routing Address" :=
                  GetRevRoutingAddr(
                    Item."No.",
                    GeneralLedgerSetup."INVRPT End Date (Monthly)",
                    GeneralLedgerSetup."ORE Reverse Routing Address",
                    GeneralLedgerSetup."ORE Reverse Routing Address SD");
                //CS073 Shawn End
                OREMessageCollectionINVRPT.INSERT(TRUE);

            UNTIL Item.NEXT = 0;

            GeneralLedgerSetup."INVRPT End Date (Monthly)" := CALCDATE('<CM>', GeneralLedgerSetup."INVRPT End Date (Monthly)" + 1);
            GeneralLedgerSetup.MODIFY(TRUE);
        END;
    end;

    procedure "Collect Message_SLSRPT"()
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        //NoSeries: Code[10]; //BC Upgrade
        NoSeries: Codeunit "No. Series";
        OREMessageCollectionSLSRPT: Record "ORE Message Collection SLSRPT";
        SalesShipmentHeader: Record "Sales Shipment Header";
        Customer_OEM: Record "Customer";
        ReturnReceiptLine: Record "Return Receipt Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        HistoryEntry: Integer;
        HistoryMessageStatus: Option Ready,Cancelled,Sent;
        OREMessageHistory1: Record "ORE Message History";
        CheckDataCode: Boolean;
        GeneralLedgerSetup: Record "General Ledger Setup";
        Customer_ORE: Record "Customer";
        l_DataCollected: Boolean;
        BOM1stItemNo: Code[20];
        l_recItem: Record "Item";
    begin
        GeneralLedgerSetup.GET;
        HistoryEntry := 0;
        l_DataCollected := FALSE;
        //CS097 Shawn Begin
        // CheckDataCode := CheckData('SLSRPT','',0,'','');
        // IF NOT CheckDataCode THEN
        // BEGIN
        //  MESSAGE(Text001);
        //  EXIT;
        // END;
        //CS097 Shawn End
        Item.RESET;
        Item.SETRANGE("One Renesas EDI", TRUE);
        IF Item.FIND('-') THEN BEGIN
            REPEAT
                Customer_OEM.GET(Item."OEM No.");

                IF HistoryEntry = 0 THEN BEGIN
                    OREMessageHistory.INIT;
                    OREMessageHistory."Entry No." := 0;
                    OREMessageHistory.VALIDATE("Message Name", 'SLSRPT');
                    OREMessageHistory."Report Start Date" := GeneralLedgerSetup."SLSRPT Start Date";
                    OREMessageHistory."Report End Date" := GeneralLedgerSetup."SLSRPT End Date";
                    OREMessageHistory."Reverse Routing Address" := GeneralLedgerSetup."ORE Reverse Routing Address";
                    OREMessageHistory."Reverse Routing Address (SD)" := GeneralLedgerSetup."ORE Reverse Routing Address SD"; //CS073

                    //NoSeriesMgt.InitSeries('OREMHRNO', '', TODAY, OREMessageHistory."Running No.", NoSeries); //BC Upgrade
                    OREMessageHistory."Running No." := NoSeries.GetNextNo('OREMHRNO');
                    OREMessageHistory.INSERT(TRUE);
                    HistoryEntry := OREMessageHistory."Entry No.";
                    HistoryMessageStatus := OREMessageHistory."Message Status";
                END;
                SalesShipmentLine.RESET;
                SalesShipmentLine.SETRANGE("No.", Item."No.");
                SalesShipmentLine.SETFILTER("Posting Date", '%1..%2', GeneralLedgerSetup."SLSRPT Start Date", GeneralLedgerSetup."SLSRPT End Date"); // CS060 Shawn
                SalesShipmentLine.SETFILTER(Quantity, '>%1', 0); //CS060 Shawn

                IF SalesShipmentLine.FIND('-') THEN BEGIN
                    REPEAT
                        SalesShipmentHeader.GET(SalesShipmentLine."Document No.");
                        Customer_ORE.GET(SalesShipmentHeader."Sell-to Customer No."); //CS060 Shawn
                        IF NOT Customer_ORE."Excluded in ORE Collection" THEN BEGIN
                            OREMessageCollectionSLSRPT.INIT;
                            OREMessageCollectionSLSRPT."Entry No." := 0;
                            OREMessageCollectionSLSRPT."History Entry No." := HistoryEntry;
                            OREMessageCollectionSLSRPT."Message Status" := HistoryMessageStatus;
                            OREMessageCollectionSLSRPT."Transaction Type" := 'Sales Shipment';
                            OREMessageCollectionSLSRPT."Transaction Type Code" := '380';
                            OREMessageCollectionSLSRPT."Transaction No." := SalesShipmentHeader."No.";
                            OREMessageCollectionSLSRPT."Transaction Date" := SalesShipmentHeader."Posting Date";
                            OREMessageCollectionSLSRPT."External Document No." := SalesShipmentHeader."External Document No.";
                            OREMessageCollectionSLSRPT."Sell-to Customer No." := SalesShipmentHeader."Sell-to Customer No.";
                            OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" := Customer_ORE."ORE Customer Name";
                            OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" := Customer_ORE."ORE Address";
                            OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" := Customer_ORE."ORE Address 2";
                            OREMessageCollectionSLSRPT."Sell-to ORE City" := Customer_ORE."ORE City";
                            OREMessageCollectionSLSRPT."Sell-to ORE State/Province" := Customer_ORE."ORE State/Province";
                            OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country"; //CS089
                            OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" := Customer_ORE."Vendor Cust. Code"; //CS089
                                                                                                                        //OREMessageCollectionSLSRPT."Sell-to Post Code" := SalesShipmentHeader."Sell-to Post Code"; //CS097
                            OREMessageCollectionSLSRPT."Sell-to Post Code" := Customer_ORE."ORE Post Code"; //CS097
                            OREMessageCollectionSLSRPT."Sell-to Country/Region Code" := SalesShipmentHeader."Sell-to Country/Region Code";
                            IF SalesShipmentHeader."Currency Code" <> '' THEN
                                OREMessageCollectionSLSRPT."Currency Code" := SalesShipmentHeader."Currency Code"
                            ELSE
                                OREMessageCollectionSLSRPT."Currency Code" := GeneralLedgerSetup."LCY Code";

                            //CS060 Shawn Begin
                            BOM1stItemNo := '';
                            Item.CALCFIELDS("Assembly BOM");
                            IF Item."Assembly BOM" THEN BEGIN
                                BOM1stItemNo := GetBOM1stItemNo(Item."No.");
                            END;
                            //CS060 Shawn End
                            OREMessageCollectionSLSRPT."Line No." := SalesShipmentLine."Line No.";
                            OREMessageCollectionSLSRPT."Item No." := SalesShipmentLine."No.";
                            //OREMessageCollectionSLSRPT.Description := Item.Description;//CS060 Shawn
                            OREMessageCollectionSLSRPT.Quantity := SalesShipmentLine.Quantity;
                            OREMessageCollectionSLSRPT."Unit Price" := SalesShipmentLine."Unit Price";
                            //OREMessageCollectionSLSRPT."ORE Debit Cost" := GetSLSRPT_OREDebitCost(SalesShipmentLine."No.", SalesShipmentLine."Posting Date");//CS060 Shawn
                            //OREMessageCollectionSLSRPT."ORE DBC Cost" := GetSLSRPT_OREDBCCost(SalesShipmentLine."No.", SalesShipmentLine."Posting Date");//CS060 Shawn
                            OREMessageCollectionSLSRPT."OEM No." := Item."OEM No.";
                            OREMessageCollectionSLSRPT."OEM ORE Name" := Customer_OEM."ORE Customer Name";
                            OREMessageCollectionSLSRPT."OEM ORE Address 1" := Customer_OEM."ORE Address";
                            OREMessageCollectionSLSRPT."OEM ORE Address 2" := Customer_OEM."ORE Address 2";
                            OREMessageCollectionSLSRPT."OEM ORE City" := Customer_OEM."ORE City";
                            OREMessageCollectionSLSRPT."OEM ORE State/Province" := Customer_OEM."ORE State/Province";
                            OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country"; //CS089
                            OREMessageCollectionSLSRPT."OEM SCM Code" := Customer_OEM."Vendor Cust. Code"; //CS089
                                                                                                           //OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."Post Code"; //CS097
                            OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."ORE Post Code"; //CS097
                            OREMessageCollectionSLSRPT."OEM Country/Region Code" := Customer_OEM."Country/Region Code";
                            OREMessageCollectionSLSRPT."Sold-to Code" := GeneralLedgerSetup."Sold-to Code";
                            //OREMessageCollectionSLSRPT."Vendor No." := Item."Vendor No.";//CS060 Shawn
                            //OREMessageCollectionSLSRPT."Purchase Currency Code" := GetSLSRPT_PurchCurrCode(SalesShipmentLine."No.", SalesShipmentLine."Posting Date");

                            //CS060 Shawn Begin
                            IF l_recItem.GET(BOM1stItemNo) THEN BEGIN
                                OREMessageCollectionSLSRPT.Description := l_recItem.Description;
                                OREMessageCollectionSLSRPT."ORE Debit Cost" := GetSLSRPT_OREDebitCost(BOM1stItemNo, SalesShipmentLine."Posting Date");
                                OREMessageCollectionSLSRPT."ORE DBC Cost" := GetSLSRPT_OREDBCCost(BOM1stItemNo, SalesShipmentLine."Posting Date");
                                OREMessageCollectionSLSRPT."Vendor No." := l_recItem."Vendor No.";
                                OREMessageCollectionSLSRPT."Purchase Currency Code" := GetSLSRPT_PurchCurrCode(BOM1stItemNo, SalesShipmentLine."Posting Date");
                                //CS089
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := GetSLSRPT_RenesasReportUnitPrice(SalesShipmentLine."No.", SalesShipmentHeader."Sell-to Customer No.", SalesShipmentHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GetSLSRPT_RenesasReportUnitPriceCurrCode(SalesShipmentLine."No.", SalesShipmentHeader."Sell-to Customer No.", SalesShipmentHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Original Item No." := l_recItem."Original Item No.";
                                //CS089

                            END ELSE BEGIN
                                OREMessageCollectionSLSRPT.Description := Item.Description;
                                OREMessageCollectionSLSRPT."ORE Debit Cost" := GetSLSRPT_OREDebitCost(SalesShipmentLine."No.", SalesShipmentLine."Posting Date");
                                OREMessageCollectionSLSRPT."ORE DBC Cost" := GetSLSRPT_OREDBCCost(SalesShipmentLine."No.", SalesShipmentLine."Posting Date");
                                OREMessageCollectionSLSRPT."Vendor No." := Item."Vendor No.";
                                OREMessageCollectionSLSRPT."Purchase Currency Code" := GetSLSRPT_PurchCurrCode(SalesShipmentLine."No.", SalesShipmentLine."Posting Date");
                                //CS089
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := GetSLSRPT_RenesasReportUnitPrice(SalesShipmentLine."No.", SalesShipmentHeader."Sell-to Customer No.", SalesShipmentHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GetSLSRPT_RenesasReportUnitPriceCurrCode(SalesShipmentLine."No.", SalesShipmentHeader."Sell-to Customer No.", SalesShipmentHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Original Item No." := Item."Original Item No.";
                                //CS089
                            END;
                            //CS060 Shawn End
                            //CS097 Shawn Begin
                            IF OREMessageCollectionSLSRPT."Renesas Report Unit Price" = 0 THEN BEGIN
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := OREMessageCollectionSLSRPT."Unit Price";
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := OREMessageCollectionSLSRPT."Currency Code";
                            END;
                            //CS097 Shawn End
                            //CS073 Shawn Begin
                            OREMessageCollectionSLSRPT."ORE Reverse Routing Address" :=
                              GetRevRoutingAddr(
                                SalesShipmentLine."No.",
                                SalesShipmentLine."Posting Date",
                                GeneralLedgerSetup."ORE Reverse Routing Address",
                                GeneralLedgerSetup."ORE Reverse Routing Address SD");
                            //CS073 Shawn End
                            OREMessageCollectionSLSRPT.INSERT(TRUE);
                            IF NOT l_DataCollected THEN
                                l_DataCollected := TRUE;
                        END;
                    UNTIL SalesShipmentLine.NEXT = 0;
                END;

                ReturnReceiptLine.RESET;
                ReturnReceiptLine.SETRANGE("No.", Item."No.");
                ReturnReceiptLine.SETFILTER("Posting Date", '%1..%2', GeneralLedgerSetup."SLSRPT Start Date", GeneralLedgerSetup."SLSRPT End Date");
                ReturnReceiptLine.SETFILTER(Quantity, '>%1', 0); //CS060 Shawn
                IF ReturnReceiptLine.FIND('-') THEN BEGIN
                    REPEAT
                        ReturnReceiptHeader.GET(ReturnReceiptLine."Document No.");
                        Customer_ORE.GET(ReturnReceiptHeader."Sell-to Customer No."); //CS060 Shawn

                        IF NOT Customer_ORE."Excluded in ORE Collection" THEN BEGIN
                            OREMessageCollectionSLSRPT.INIT;
                            OREMessageCollectionSLSRPT."Entry No." := 0;
                            OREMessageCollectionSLSRPT."History Entry No." := HistoryEntry;
                            OREMessageCollectionSLSRPT."Message Status" := HistoryMessageStatus;
                            OREMessageCollectionSLSRPT."Transaction Type" := 'Return Receipt';
                            OREMessageCollectionSLSRPT."Transaction Type Code" := '381';
                            OREMessageCollectionSLSRPT."Transaction No." := ReturnReceiptHeader."No.";
                            OREMessageCollectionSLSRPT."Transaction Date" := ReturnReceiptHeader."Posting Date";
                            OREMessageCollectionSLSRPT."External Document No." := ReturnReceiptHeader."External Document No.";
                            OREMessageCollectionSLSRPT."Sell-to Customer No." := ReturnReceiptHeader."Sell-to Customer No.";
                            OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" := Customer_ORE."ORE Customer Name";
                            OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" := Customer_ORE."ORE Address";
                            OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" := Customer_ORE."ORE Address 2";
                            OREMessageCollectionSLSRPT."Sell-to ORE City" := Customer_ORE."ORE City";
                            OREMessageCollectionSLSRPT."Sell-to ORE State/Province" := Customer_ORE."ORE State/Province";
                            OREMessageCollectionSLSRPT."Sell-to ORE Country" := Customer_ORE."ORE Country"; //CS089
                            OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" := Customer_ORE."Vendor Cust. Code"; //CS089
                                                                                                                        //OREMessageCollectionSLSRPT."Sell-to Post Code" := ReturnReceiptHeader."Sell-to Post Code"; //CS097
                            OREMessageCollectionSLSRPT."Sell-to Post Code" := Customer_ORE."ORE Post Code"; //CS097
                            OREMessageCollectionSLSRPT."Sell-to Country/Region Code" := ReturnReceiptHeader."Sell-to Country/Region Code";
                            IF SalesShipmentHeader."Currency Code" <> '' THEN
                                OREMessageCollectionSLSRPT."Currency Code" := ReturnReceiptHeader."Currency Code"
                            ELSE
                                OREMessageCollectionSLSRPT."Currency Code" := GeneralLedgerSetup."LCY Code";

                            //CS060 Shawn Begin
                            BOM1stItemNo := '';
                            Item.CALCFIELDS("Assembly BOM");
                            IF Item."Assembly BOM" THEN BEGIN
                                BOM1stItemNo := GetBOM1stItemNo(Item."No.");
                            END;
                            //CS060 Shawn End
                            OREMessageCollectionSLSRPT."Line No." := ReturnReceiptLine."Line No.";
                            OREMessageCollectionSLSRPT."Item No." := ReturnReceiptLine."No.";
                            //OREMessageCollectionSLSRPT.Description := Item.Description;//CS060 Shawn
                            OREMessageCollectionSLSRPT.Quantity := ReturnReceiptLine.Quantity;
                            OREMessageCollectionSLSRPT."Unit Price" := ReturnReceiptLine."Unit Price";
                            //OREMessageCollectionSLSRPT."ORE Debit Cost" := GetSLSRPT_OREDebitCost(ReturnReceiptLine."No.", ReturnReceiptLine."Posting Date");//CS060 Shawn
                            //OREMessageCollectionSLSRPT."ORE DBC Cost" := GetSLSRPT_OREDBCCost(ReturnReceiptLine."No.", ReturnReceiptLine."Posting Date");//CS060 Shawn
                            OREMessageCollectionSLSRPT."OEM No." := Item."OEM No.";
                            OREMessageCollectionSLSRPT."OEM ORE Name" := Customer_OEM."ORE Customer Name";
                            OREMessageCollectionSLSRPT."OEM ORE Address 1" := Customer_OEM."ORE Address";
                            OREMessageCollectionSLSRPT."OEM ORE Address 2" := Customer_OEM."ORE Address 2";
                            OREMessageCollectionSLSRPT."OEM ORE City" := Customer_OEM."ORE City";
                            OREMessageCollectionSLSRPT."OEM ORE State/Province" := Customer_OEM."ORE State/Province";
                            OREMessageCollectionSLSRPT."OEM ORE Country" := Customer_OEM."ORE Country"; //CS089
                            OREMessageCollectionSLSRPT."OEM SCM Code" := Customer_OEM."Vendor Cust. Code"; //CS089
                                                                                                           //OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."Post Code"; //CS097
                            OREMessageCollectionSLSRPT."OEM Post Code" := Customer_OEM."ORE Post Code"; //CS097
                            OREMessageCollectionSLSRPT."OEM Country/Region Code" := Customer_OEM."Country/Region Code";
                            OREMessageCollectionSLSRPT."Sold-to Code" := GeneralLedgerSetup."Sold-to Code";
                            //OREMessageCollectionSLSRPT."Vendor No." := Item."Vendor No.";//CS060 Shawn
                            //OREMessageCollectionSLSRPT."Purchase Currency Code" := GetSLSRPT_PurchCurrCode(ReturnReceiptLine."No.", ReturnReceiptLine."Posting Date");
                            //CS060 Shawn Begin
                            IF l_recItem.GET(BOM1stItemNo) THEN BEGIN
                                OREMessageCollectionSLSRPT.Description := l_recItem.Description;
                                OREMessageCollectionSLSRPT."ORE Debit Cost" := GetSLSRPT_OREDebitCost(BOM1stItemNo, ReturnReceiptLine."Posting Date");
                                OREMessageCollectionSLSRPT."ORE DBC Cost" := GetSLSRPT_OREDBCCost(BOM1stItemNo, ReturnReceiptLine."Posting Date");
                                OREMessageCollectionSLSRPT."Vendor No." := l_recItem."Vendor No.";
                                OREMessageCollectionSLSRPT."Purchase Currency Code" := GetSLSRPT_PurchCurrCode(BOM1stItemNo, ReturnReceiptLine."Posting Date");
                                //CS089
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := GetSLSRPT_RenesasReportUnitPrice(ReturnReceiptLine."No.", ReturnReceiptHeader."Sell-to Customer No.", ReturnReceiptHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GetSLSRPT_RenesasReportUnitPriceCurrCode(ReturnReceiptLine."No.", ReturnReceiptHeader."Sell-to Customer No.", ReturnReceiptHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Original Item No." := l_recItem."Original Item No.";
                                //CS089
                            END ELSE BEGIN
                                OREMessageCollectionSLSRPT.Description := Item.Description;
                                OREMessageCollectionSLSRPT."ORE Debit Cost" := GetSLSRPT_OREDebitCost(ReturnReceiptLine."No.", ReturnReceiptLine."Posting Date");
                                OREMessageCollectionSLSRPT."ORE DBC Cost" := GetSLSRPT_OREDBCCost(ReturnReceiptLine."No.", ReturnReceiptLine."Posting Date");
                                OREMessageCollectionSLSRPT."Vendor No." := Item."Vendor No.";
                                OREMessageCollectionSLSRPT."Purchase Currency Code" := GetSLSRPT_PurchCurrCode(ReturnReceiptLine."No.", ReturnReceiptLine."Posting Date");
                                //CS089
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := GetSLSRPT_RenesasReportUnitPrice(ReturnReceiptLine."No.", ReturnReceiptHeader."Sell-to Customer No.", ReturnReceiptHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := GetSLSRPT_RenesasReportUnitPriceCurrCode(ReturnReceiptLine."No.", ReturnReceiptHeader."Sell-to Customer No.", ReturnReceiptHeader."Posting Date");
                                OREMessageCollectionSLSRPT."Original Item No." := Item."Original Item No.";
                                //CS089
                            END;
                            //CS060 Shawn End
                            //CS097 Shawn Begin
                            IF OREMessageCollectionSLSRPT."Renesas Report Unit Price" = 0 THEN BEGIN
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price" := OREMessageCollectionSLSRPT."Unit Price";
                                OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." := OREMessageCollectionSLSRPT."Currency Code";
                            END;
                            //CS097 Shawn End
                            //CS073 Shawn Begin
                            OREMessageCollectionSLSRPT."ORE Reverse Routing Address" :=
                              GetRevRoutingAddr(
                                ReturnReceiptLine."No.",
                                ReturnReceiptLine."Posting Date",
                                GeneralLedgerSetup."ORE Reverse Routing Address",
                                GeneralLedgerSetup."ORE Reverse Routing Address SD");
                            //CS073 Shawn End
                            SetSLSRPT_OrgShipInfo(OREMessageCollectionSLSRPT);//CS060-CR30
                            OREMessageCollectionSLSRPT.INSERT(TRUE);
                            IF NOT l_DataCollected THEN
                                l_DataCollected := TRUE;
                        END;
                    UNTIL ReturnReceiptLine.NEXT = 0;
                END;

            UNTIL Item.NEXT = 0;

            IF GeneralLedgerSetup."DOW to Update Date Filter" + 1 = DATE2DWY(TODAY, 1) THEN BEGIN
                GeneralLedgerSetup."SLSRPT Start Date" := GeneralLedgerSetup."SLSRPT Start Date" + 7;
                GeneralLedgerSetup."SLSRPT End Date" := GeneralLedgerSetup."SLSRPT Start Date" + 6;
                GeneralLedgerSetup.MODIFY;
            END;

            IF NOT l_DataCollected THEN BEGIN
                OREMessageHistory.DELETE;
                MESSAGE(Text001);
                EXIT;
            END;

        END;
    end;

    procedure CheckData(MessageType: Code[10]; ReverseRoutingAddress: Code[40]; LineNo: Integer; ItemNo: Code[20]; OrderNo: Code[20]) IsNew: Boolean
    var
        OldData: Integer;
        NewData: Integer;
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";
        OREMessageCollectionORDCHG: Record "ORE Message Collection ORDCHG";
        ValueEntry: Record "Value Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
        ReturnReceiptLine: Record "Return Receipt Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.GET;
        IsNew := FALSE;
        CASE MessageType OF
            'ORDERS':
                BEGIN
                    OREMessageHistory.RESET;
                    OREMessageHistory.SETRANGE("Reverse Routing Address", ReverseRoutingAddress);
                    OREMessageHistory.SETRANGE("Message Name", 'ORDERS');
                    OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    IF OREMessageHistory.FIND('-') THEN BEGIN
                        REPEAT
                            OREMessageCollectionORDERS.RESET;
                            OREMessageCollectionORDERS.SETRANGE("History Entry No.", OREMessageHistory."Entry No.");
                            OREMessageCollectionORDERS.SETRANGE("Line No.", LineNo);
                            OREMessageCollectionORDERS.SETRANGE("Item No.", ItemNo);
                            OREMessageCollectionORDERS.SETRANGE("Order No.", OrderNo);
                            IF OREMessageCollectionORDERS.FIND('-') THEN
                                IsNew := TRUE;
                            EXIT;
                        UNTIL OREMessageHistory.NEXT = 0;
                    END;
                END;
            'ORDCHG':
                BEGIN
                    OREMessageHistory.RESET;
                    OREMessageHistory.SETRANGE("Reverse Routing Address", ReverseRoutingAddress);
                    OREMessageHistory.SETRANGE("Message Name", 'ORDCHG');
                    OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    IF OREMessageHistory.FIND('-') THEN BEGIN
                        REPEAT
                            OREMessageCollectionORDCHG.RESET;
                            OREMessageCollectionORDCHG.SETRANGE("History Entry No.", OREMessageHistory."Entry No.");
                            OREMessageCollectionORDCHG.SETRANGE("Line No.", LineNo);
                            OREMessageCollectionORDCHG.SETRANGE("Item No.", ItemNo);
                            OREMessageCollectionORDCHG.SETRANGE("Order No.", OrderNo);
                            IF OREMessageCollectionORDCHG.FIND('-') THEN
                                IsNew := TRUE;
                            EXIT;
                        UNTIL OREMessageHistory.NEXT = 0;
                    END;
                END;
            'INVRPTHEAD':
                BEGIN
                    OREMessageHistory.RESET;
                    OREMessageHistory.SETRANGE("Message Name", 'INVRPT');
                    OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    IF OREMessageHistory.FIND('-') THEN BEGIN
                        REPEAT
                            IsNew := TRUE;
                            EXIT;
                        UNTIL OREMessageHistory.NEXT = 0;
                    END;
                END;
            'INVRPT':
                BEGIN
                    Item.RESET;
                    Item.SETRANGE("One Renesas EDI", TRUE);
                    IF Item.FIND('-') THEN BEGIN
                        REPEAT
                            ValueEntry.RESET;
                            ValueEntry.SETRANGE("Item No.", Item."No.");
                            ValueEntry.SETFILTER("Posting Date", '<=%1', GeneralLedgerSetup."INVRPT End Date (Weekly)");
                            IF ValueEntry.FIND('-') THEN
                                IsNew := TRUE;
                            EXIT;
                        UNTIL Item.NEXT = 0;
                    END;
                END;
            'SLSRPTHEAD':
                BEGIN
                    OREMessageHistory.RESET;
                    OREMessageHistory.SETRANGE("Message Name", 'SLSRPT');
                    OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    IF OREMessageHistory.FIND('-') THEN BEGIN
                        REPEAT
                            IsNew := TRUE;
                            EXIT;
                        UNTIL OREMessageHistory.NEXT = 0;
                    END;
                END;
            'SLSRPT':
                BEGIN
                    Item.RESET;
                    Item.SETRANGE("One Renesas EDI", TRUE);
                    IF Item.FIND('-') THEN BEGIN
                        REPEAT
                            SalesShipmentLine.RESET;
                            SalesShipmentLine.SETRANGE("No.", Item."No.");
                            SalesShipmentLine.SETFILTER("Posting Date", '%1..%2', GeneralLedgerSetup."SLSRPT Start Date", GeneralLedgerSetup."SLSRPT End Date"); // CS060 Shawn

                            IF SalesShipmentLine.FIND('-') THEN BEGIN
                                REPEAT
                                    IsNew := TRUE;
                                    EXIT;
                                UNTIL SalesShipmentLine.NEXT = 0;
                            END;
                            ReturnReceiptLine.RESET;
                            ReturnReceiptLine.SETRANGE("No.", Item."No.");
                            ReturnReceiptLine.SETFILTER("Posting Date", '%1..%2', GeneralLedgerSetup."SLSRPT Start Date", GeneralLedgerSetup."SLSRPT End Date"); // CS060 Shawn
                            IF ReturnReceiptLine.FIND('-') THEN BEGIN
                                REPEAT
                                    IsNew := TRUE;
                                    EXIT;
                                UNTIL ReturnReceiptLine.NEXT = 0;
                            END;
                        UNTIL Item.NEXT = 0;
                    END;
                END;
        END;
    end;

    local procedure GetSLSRPT_OREDebitCost(pItemNo: Code[20]; pPostingDate: Date) rCost: Decimal
    var
        l_recPurchPrice: Record "Price List Line";
        l_recItem: Record "Item";
    begin
        rCost := 0;
        l_recItem.GET(pItemNo);

        l_recPurchPrice.RESET;
        l_recPurchPrice.SETCURRENTKEY("Starting Date");
        l_recPurchPrice.ASCENDING(FALSE);
        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase);
        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active);
        l_recPurchPrice.SETRANGE("Asset No.", pItemNo);
        l_recPurchPrice.SETRANGE("Assign-to No.", l_recItem."Vendor No.");
        l_recPurchPrice.SETFILTER("Starting Date", '..%1', pPostingDate);

        IF l_recPurchPrice.FINDFIRST THEN
            rCost := l_recPurchPrice."ORE Debit Cost";

        EXIT(rCost);
    end;

    local procedure GetSLSRPT_OREDBCCost(pItemNo: Code[20]; pPostingDate: Date) rCost: Decimal
    var
        l_recPurchPrice: Record "Price List Line";
        l_recItem: Record "Item";
    begin
        rCost := 0;
        l_recItem.GET(pItemNo);

        l_recPurchPrice.RESET;
        l_recPurchPrice.SETCURRENTKEY("Starting Date");
        l_recPurchPrice.ASCENDING(FALSE);
        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase);
        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active);
        l_recPurchPrice.SETRANGE("Asset No.", pItemNo);
        l_recPurchPrice.SETRANGE("Assign-to No.", l_recItem."Vendor No.");
        l_recPurchPrice.SETFILTER("Starting Date", '..%1', pPostingDate);

        IF l_recPurchPrice.FINDFIRST THEN
            rCost := l_recPurchPrice."Direct Unit Cost";

        EXIT(rCost);
    end;

    local procedure GetSLSRPT_PurchCurrCode(pItemNo: Code[20]; pPostingDate: Date) rCurrCode: Code[10]
    var
        l_recPurchPrice: Record "Price List Line";
        l_recItem: Record "Item";
        l_recGLSetup: Record "General Ledger Setup";
    begin
        rCurrCode := '';
        l_recItem.GET(pItemNo);

        l_recPurchPrice.RESET;
        l_recPurchPrice.SETCURRENTKEY("Starting Date");
        l_recPurchPrice.ASCENDING(FALSE);
        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase);
        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active);
        l_recPurchPrice.SETRANGE("Asset No.", pItemNo);
        l_recPurchPrice.SETRANGE("Assign-to No.", l_recItem."Vendor No.");
        l_recPurchPrice.SETFILTER("Starting Date", '..%1', pPostingDate);

        IF l_recPurchPrice.FINDFIRST THEN
            rCurrCode := l_recPurchPrice."Currency Code";

        IF rCurrCode = '' THEN BEGIN
            l_recGLSetup.GET;
            rCurrCode := l_recGLSetup."LCY Code";
        END;

        EXIT(rCurrCode);
    end;

    local procedure GetINTRPT_OREUnitCost(pItemNo: Code[20]; pPostingDate: Date) rCost: Decimal
    var
        l_recPurchPrice: Record "Price List Line";
        l_recItem: Record "Item";
    begin
        rCost := 0;
        l_recItem.GET(pItemNo);

        l_recPurchPrice.RESET;
        l_recPurchPrice.SETCURRENTKEY("Starting Date");
        l_recPurchPrice.ASCENDING(FALSE);
        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase);
        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active);
        l_recPurchPrice.SETRANGE("Asset No.", pItemNo);
        l_recPurchPrice.SETRANGE("Assign-to No.", l_recItem."Vendor No.");
        l_recPurchPrice.SETFILTER("Starting Date", '..%1', pPostingDate);

        IF l_recPurchPrice.FINDFIRST THEN
            rCost := l_recPurchPrice."Direct Unit Cost";

        EXIT(rCost);
    end;

    local procedure GetBOM1stItemNo(pItemNo: Code[20]) rBOM1stItemNo: Code[20]
    var
        l_recItem: Record "Item";
        l_recBOM: Record "BOM Component";
    begin
        rBOM1stItemNo := '';

        l_recItem.GET(pItemNo);
        l_recItem.CALCFIELDS("Assembly BOM");
        IF l_recItem."Assembly BOM" THEN BEGIN
            l_recBOM.SETRANGE("Parent Item No.", pItemNo);
            IF l_recBOM.FINDFIRST THEN BEGIN
                rBOM1stItemNo := l_recBOM."No.";
            END;
        END;

        EXIT(rBOM1stItemNo);
    end;

    local procedure GetRevRoutingAddr(pItemNo: Code[20]; pStartDate: Date; pRRAddr: Code[40]; pRRAddrSD: Code[40]) rRevRoutingAddr: Code[40]
    var
        l_recPurchPrice: Record "Price List Line";
        l_recItem: Record "Item";
    begin
        rRevRoutingAddr := pRRAddr;
        l_recItem.GET(pItemNo);

        l_recPurchPrice.RESET;
        l_recPurchPrice.SETCURRENTKEY("Starting Date");
        l_recPurchPrice.ASCENDING(FALSE);
        l_recPurchPrice.SetRange("Price Type", l_recPurchPrice."Price Type"::Purchase);
        l_recPurchPrice.SetRange(Status, l_recPurchPrice.Status::Active);
        l_recPurchPrice.SETRANGE("Asset No.", pItemNo);
        l_recPurchPrice.SETRANGE("Assign-to No.", l_recItem."Vendor No.");
        l_recPurchPrice.SETFILTER("Starting Date", '..%1', pStartDate);

        IF (l_recPurchPrice.FINDFIRST) AND (l_recPurchPrice."Ship&Debit Flag") THEN
            rRevRoutingAddr := pRRAddrSD;

        EXIT(rRevRoutingAddr);
    end;

    local procedure SetSLSRPT_OrgShipInfo(var pRecSLSMsg: Record "ORE Message Collection SLSRPT")
    var
        rRecILE: Record "Item Ledger Entry";
        rRecIAE: Record "Item Application Entry";
        rRecSSL: Record "Sales Shipment Line";
        rRecILE2: Record "Item Ledger Entry";
    begin
        rRecILE.SETRANGE("Entry Type", rRecILE."Entry Type"::Sale);
        rRecILE.SETRANGE("Document No.", pRecSLSMsg."Transaction No.");
        rRecILE.SETRANGE("Item No.", pRecSLSMsg."Item No."); //Modified by Naoto
        rRecILE.SETFILTER(Quantity, '>%1', 0);

        IF rRecILE.FINDFIRST THEN BEGIN
            rRecIAE.SETRANGE("Item Ledger Entry No.", rRecILE."Entry No.");
            IF rRecIAE.FINDFIRST THEN BEGIN
                IF rRecILE2.GET(rRecIAE."Outbound Item Entry No.") THEN BEGIN
                    pRecSLSMsg."Original Document No." := rRecILE2."Document No.";

                    rRecSSL.SETRANGE("Document No.", rRecILE2."Document No.");
                    rRecSSL.SETRANGE("Item Shpt. Entry No.", rRecILE2."Entry No.");
                    IF rRecSSL.FINDFIRST THEN BEGIN
                        pRecSLSMsg."Original Document Line No." := rRecSSL."Line No.";
                    END;
                END;
            END;
        END;
    end;

    local procedure GetSLSRPT_RenesasReportUnitPrice(pItemNo: Code[20]; pCustomerNo: Code[20]; pPostingDate: Date) rPrice: Decimal
    var
        l_recSalesPrice: Record "Price List Line";
        l_recItem: Record "Item";
    begin
        //CS089 Add LOCAL Function
        rPrice := 0;
        l_recItem.GET(pItemNo);

        l_recSalesPrice.RESET;
        l_recSalesPrice.SETCURRENTKEY("Starting Date");
        l_recSalesPrice.ASCENDING(FALSE);
        //l_recSalesPrice.SETRANGE("Item No.", pItemNo);
        //l_recSalesPrice.SETRANGE("Sales Code", pCustomerNo);
        l_recSalesPrice.SetRange("Price Type", l_recSalesPrice."Price Type"::Sale);
        l_recSalesPrice.SetRange(Status, l_recSalesPrice.Status::Active);
        l_recSalesPrice.SETRANGE("Asset No.", pItemNo);
        l_recSalesPrice.SETRANGE("Assign-to No.", pCustomerNo);
        l_recSalesPrice.SETFILTER("Starting Date", '<=%1', pPostingDate);

        IF l_recSalesPrice.FINDFIRST THEN
            rPrice := l_recSalesPrice."Renesas Report Unit Price";

        EXIT(rPrice);
    end;

    local procedure GetSLSRPT_RenesasReportUnitPriceCurrCode(pItemNo: Code[20]; pCustomerNo: Code[20]; pPostingDate: Date) rCurrCode: Code[10]
    var
        l_recSalesPrice: Record "Price List Line";
        l_recItem: Record "Item";
        l_recGLSetup: Record "General Ledger Setup";
    begin
        //CS089 Add LOCAL Function
        rCurrCode := '';
        l_recItem.GET(pItemNo);

        l_recSalesPrice.RESET;
        l_recSalesPrice.SETCURRENTKEY("Starting Date");
        l_recSalesPrice.ASCENDING(FALSE);
        //l_recSalesPrice.SETRANGE("Item No.", pItemNo);
        //l_recSalesPrice.SETRANGE("Sales Code", pCustomerNo);
        l_recSalesPrice.SetRange("Price Type", l_recSalesPrice."Price Type"::Sale);
        l_recSalesPrice.SetRange(Status, l_recSalesPrice.Status::Active);
        l_recSalesPrice.SETRANGE("Asset No.", pItemNo);
        l_recSalesPrice.SETRANGE("Assign-to No.", pCustomerNo);
        l_recSalesPrice.SETFILTER("Starting Date", '<=%1', pPostingDate);

        IF l_recSalesPrice.FINDFIRST THEN
            rCurrCode := l_recSalesPrice."Renesas Report Unit Price Cur.";

        IF rCurrCode = '' THEN BEGIN
            l_recGLSetup.GET;
            rCurrCode := l_recGLSetup."LCY Code";
        END;

        EXIT(rCurrCode);
    end;
}

