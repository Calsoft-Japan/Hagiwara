codeunit 50021 "ORE Send Message"
{
    // CS060 Leon 2023/10/18 - One Renesas EDI
    // CS060 Shawn 2024/02/23 - INVRPT: #20 -> Customer Name, #26 -> Item No.
    // CS060 Shawn 2024/03/09 - remove newline chars from Item Description, add fields, etc.
    // CS060 Shawn 2024/03/30 - One Renesas EDI delete fields. (ORE DBC Cost)
    // CS060 Shawn 2024/07/20 - SLSRPT: "External Document No." -> "Transaction No."
    //                                  add "Return Credit Memo".
    // CS060 Shawn 2024/10/02 - CR30. SLSRPT: Original Document No., Original Document Line No.
    // CS089 Naoto 2024/12/22 - One Renesas EDI Modification
    // CS100 Naoto 2025/03/20 - ORE Reverse Routing Address for File Name
    // CS103 Naoto 2025/04/15 - Change Length of ORE Reverse Routing Address


    trigger OnRun()
    begin
    end;

    var
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory: Record "ORE Message History";
        GeneralLedgerSetup: Record "General Ledger Setup";
        myFile: File;
        SaveString: Text;
        CountLine: Integer;
        DetailLine: Integer;
        lineTab: Char;
        lineTab2: Text;
        HistoryEntryNo: Integer;
        RevRoutingAddr: Code[40];
        RevRoutingAddrSD: Code[40];
        FileName: Text[250];
        MessageName: Code[10];
        Const_MN_ORDERS: Label 'ORDERS';
        Const_MN_ORDCHG: Label 'ORDCHG';
        Const_MN_INVRPT: Label 'INVRPT';
        Const_MN_SLSRPT: Label 'SLSRPT';

    procedure DeleteDataInBuffer()
    var
        OREMessageBuffer: Record "ORE Message Collection Buffer";
    begin
        OREMessageBuffer.Reset();
        OREMessageBuffer.SetRange("Message Name", MessageName);
        OREMessageBuffer.DELETEALL;
    end;

    procedure InsertDataInBuffer()
    var
        OREMessageBuffer: Record "ORE Message Collection Buffer";
    begin
        OREMessageBuffer.INIT;
        OREMessageBuffer."ORE Msg Hist Entry No." := HistoryEntryNo;
        OREMessageBuffer."Message Name" := MessageName;
        OREMessageBuffer."Reverse Routing Address" := RevRoutingAddr;
        OREMessageBuffer."Reverse Routing Address (SD)" := RevRoutingAddrSD;
        OREMessageBuffer."File Name" := FileName;
        OREMessageBuffer.INSERT;
        OREMessageBuffer.SetData(SaveString);
        OREMessageBuffer.Modify();
    end;

    procedure "Send Message_ORDERS"()
    var
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        OrderNo: Code[20];
        TempCheckHistory: Record "Location" temporary;
        OREMessageHistory1: Record "ORE Message History";
    begin
        GeneralLedgerSetup.GET;
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        MessageReferenceNumb := 1;
        SaveString := '';
        //CountLine := 2;
        TempCheckHistory.RESET;
        TempCheckHistory.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_ORDERS;
        FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)";

        DeleteDataInBuffer();
        //BC Upgrade

        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'ORDERS');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        IF OREMessageHistory.FIND('-') THEN BEGIN
            REPEAT
                TempCheckHistory.RESET;
                TempCheckHistory.SETRANGE(Name, OREMessageHistory."Reverse Routing Address");
                IF TempCheckHistory.ISEMPTY THEN BEGIN
                    TempCheckHistory.INIT;
                    TempCheckHistory.Code := FORMAT(OREMessageHistory."Entry No.");
                    TempCheckHistory.Name := OREMessageHistory."Reverse Routing Address";
                    TempCheckHistory.INSERT(TRUE);
                    SaveString := 'ORE Country Qualifier' + lineTab2 + 'ORE Reverse Routing Address' + lineTab2 + 'Output Date' + lineTab2 + 'Output Time' + lineTab2 + 'Running No.' + lineTab2 + 'Message Reference No.' + lineTab2 + 'Purchase Order No.' + lineTab2;
                    SaveString := SaveString + 'Order Date' + lineTab2 + 'Ship-to Code' + lineTab2 + 'Currency Code' + lineTab2 + 'LIN.Line No.' + lineTab2 + 'Item No.' + lineTab2 + 'Description' + lineTab2 + 'Quantity' + lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2 + 'End Customer Name' + lineTab2 + 'Unit Cost' + lineTab2 + 'ORE Line No.' + lineTab2 + 'Requested Receipt Date' + lineTab2 + 'Count of LIN Segment' + lineTab2 + 'PO Line No.' + lineTab2;
                    SaveString := SaveString + 'Spare1' + FORMAT(lineTab2) + 'Spare2' + lineTab2 + 'Spare3' + lineTab2 + 'Spare4' + lineTab2 + 'Spare5' + lineTab2 + 'Spare6' + lineTab2 + 'Spare7' + lineTab2 + 'Spare8' + lineTab2 + 'Spare9' + lineTab2 + 'Spare10' + lineTab2;
                    SaveString := SaveString + 'Spare11' + lineTab2 + 'Spare12' + lineTab2 + 'Spare13' + lineTab2 + 'Spare14' + lineTab2 + 'Spare15' + lineTab2 + 'Spare16' + lineTab2 + 'Spare17' + lineTab2 + 'Spare18' + lineTab2 + 'Spare19' + lineTab2 + 'Spare20';
                    CountLine := "Count of LIN Segment"('ORDERS', OREMessageHistory."Reverse Routing Address", 0D);

                    //BC Upgrade
                    HistoryEntryNo := OREMessageHistory."Entry No.";
                    RevRoutingAddr := OREMessageHistory."Reverse Routing Address";
                    RevRoutingAddrSD := OREMessageHistory."Reverse Routing Address (SD)";
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    LineNumber := 1;
                    OREMessageHistory1.RESET;
                    OREMessageHistory1.SETRANGE("Message Name", 'ORDERS');
                    OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    OREMessageHistory1.SETRANGE("Reverse Routing Address", OREMessageHistory."Reverse Routing Address");
                    IF OREMessageHistory1.FIND('-') THEN BEGIN
                        REPEAT

                            OREMessageCollectionORDERS.RESET;
                            OREMessageCollectionORDERS.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                            IF OREMessageCollectionORDERS.FIND('-') THEN BEGIN
                                REPEAT
                                    //BC Upgrade
                                    //IF LineNumber > 1 THEN
                                    //    SaveString := SaveString + FORMAT(lineChar);
                                    //BC Upgrade

                                    //CS073 Shawn Begin
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageHistory1."Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME,8,'<Year4><Month,2><Day,2>') + lineTab2;
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionORDERS."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    //CS073 Shawn End
                                    SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionORDERS."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2 + OREMessageHistory1."Running No." + lineTab2 + FORMAT(MessageReferenceNumb) + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionORDERS."Order No." + lineTab2 + FORMAT(OREMessageCollectionORDERS."Order Date", 8, '<Year4><Month,2><Day,2>') + lineTab2 + OREMessageCollectionORDERS."Ship-to Code" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionORDERS."Currency Code" + lineTab2 + FORMAT(LineNumber) + lineTab2 + OREMessageCollectionORDERS."Item No." + lineTab2;
                                    SaveString := SaveString + RemoveSpecChars(OREMessageCollectionORDERS.Description) + lineTab2 + FORMAT(OREMessageCollectionORDERS.Quantity, 0, 2) + lineTab2 + 'PCE' + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionORDERS."ORE Customer Name" + lineTab2 + FORMAT(OREMessageCollectionORDERS."Direct Unit Cost") + lineTab2 + FORMAT(OREMessageCollectionORDERS."ORE Line No.") + lineTab2;
                                    SaveString := SaveString + FORMAT(OREMessageCollectionORDERS."Requested Receipt Date", 8, '<Year4><Month,2><Day,2>') + lineTab2 + FORMAT(CountLine) + lineTab2 + FORMAT(OREMessageCollectionORDERS."Line No.");

                                    LineNumber := LineNumber + 1;

                                    InsertDataInBuffer(); //BC Upgrade

                                //Status change moved to API.
                                /*
                                PurchaseLine.RESET;
                                PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDERS."Line No.");
                                PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDERS."Order No.");
                                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                IF PurchaseLine.FIND('-') THEN BEGIN
                                    REPEAT
                                        PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::Sent;
                                        PurchaseLine.MODIFY(TRUE);
                                    UNTIL PurchaseLine.NEXT = 0;
                                END;
                                OREMessageCollectionORDERS."Message Status" := OREMessageCollectionORDERS."Message Status"::Sent;
                                OREMessageCollectionORDERS.MODIFY(TRUE);
                                */

                                UNTIL OREMessageCollectionORDERS.NEXT = 0;
                            END;

                        /*
                        OREMessageHistory1."File Sent By" := USERID;
                        OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                        OREMessageHistory1."Message Status" := OREMessageHistory."Message Status"::Sent;
                        OREMessageHistory1.MODIFY(TRUE);
                        */

                        UNTIL OREMessageHistory1.NEXT = 0;

                        //BC Upgrade
                        /*
                        //CS100
                        //FileName := GeneralLedgerSetup."ORE Messaging File Path"+'\ORDERS'+'_'+GeneralLedgerSetup."ORE Country Qualifier" + OREMessageHistory."Reverse Routing Address"+'.csv';
                        FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\ORDERS' + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)" + '.csv';
                        //CS100
                        CreateFile(FileName, SaveString);
                        SaveString := '';
                        */
                        //BC Upgrade
                    END;
                    MessageReferenceNumb := MessageReferenceNumb + 1;
                END;

            UNTIL OREMessageHistory.NEXT = 0;
        END;


    end;

    procedure "Send Message_ORDCHG"()
    var
        OREMessageCollectionORDCHG: Record "ORE Message Collection ORDCHG";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        OrderNo: Code[20];
        TempCheckHistory: Record "Location" temporary;
        OREMessageHistory1: Record "ORE Message History";
    begin
        GeneralLedgerSetup.GET;
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        MessageReferenceNumb := 1;
        SaveString := '';
        TempCheckHistory.RESET;
        TempCheckHistory.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_ORDCHG;
        FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)";

        DeleteDataInBuffer();
        //BC Upgrade

        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'ORDCHG');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        IF OREMessageHistory.FIND('-') THEN BEGIN
            REPEAT
                TempCheckHistory.RESET;
                TempCheckHistory.SETRANGE(Name, OREMessageHistory."Reverse Routing Address");
                IF TempCheckHistory.ISEMPTY THEN BEGIN
                    TempCheckHistory.INIT;
                    TempCheckHistory.Code := FORMAT(OREMessageHistory."Entry No.");
                    TempCheckHistory.Name := OREMessageHistory."Reverse Routing Address";
                    TempCheckHistory.INSERT(TRUE);
                    SaveString := 'ORE Country Qualifier' + lineTab2 + 'ORE Reverse Routing Address' + lineTab2 + 'Output Date' + lineTab2 + 'Output Time' + lineTab2 + 'Running No.' + lineTab2 + 'Message Reference No.' + lineTab2;
                    SaveString := SaveString + 'Purchase Order No.' + lineTab2 + 'Order Date' + lineTab2 + 'Ship-to Code' + lineTab2 + 'Action Type' + lineTab2 + 'Item No.' + lineTab2 + 'Description' + lineTab2 + 'Quantity' + lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2 + 'ORE Line No.' + lineTab2 + 'Requested Receipt Date' + lineTab2 + 'Count of LIN Segment' + lineTab2 + 'PO Line No.' + lineTab2;
                    SaveString := SaveString + 'Spare1' + FORMAT(lineTab2) + 'Spare2' + lineTab2 + 'Spare3' + lineTab2 + 'Spare4' + lineTab2 + 'Spare5' + lineTab2 + 'Spare6' + lineTab2 + 'Spare7' + lineTab2 + 'Spare8' + lineTab2 + 'Spare9' + lineTab2 + 'Spare10' + lineTab2;
                    SaveString := SaveString + 'Spare11' + lineTab2 + 'Spare12' + lineTab2 + 'Spare13' + lineTab2 + 'Spare14' + lineTab2 + 'Spare15' + lineTab2 + 'Spare16' + lineTab2 + 'Spare17' + lineTab2 + 'Spare18' + lineTab2 + 'Spare19' + lineTab2 + 'Spare20';
                    CountLine := "Count of LIN Segment"('ORDCHG', OREMessageHistory."Reverse Routing Address", 0D);

                    //BC Upgrade
                    HistoryEntryNo := OREMessageHistory."Entry No.";
                    RevRoutingAddr := OREMessageHistory."Reverse Routing Address";
                    RevRoutingAddrSD := OREMessageHistory."Reverse Routing Address (SD)";
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    LineNumber := 1;

                    OREMessageHistory1.RESET;
                    OREMessageHistory1.SETRANGE("Message Name", 'ORDCHG');
                    OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    OREMessageHistory1.SETRANGE("Reverse Routing Address", OREMessageHistory."Reverse Routing Address");
                    IF OREMessageHistory1.FIND('-') THEN BEGIN
                        REPEAT
                            OREMessageCollectionORDCHG.RESET;
                            OREMessageCollectionORDCHG.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                            IF OREMessageCollectionORDCHG.FIND('-') THEN BEGIN
                                REPEAT
                                    //BC Upgrade
                                    //IF LineNumber > 1 THEN
                                    //    SaveString := SaveString + FORMAT(lineChar);
                                    //BC Upgrade

                                    //CS073 Shawn Begin
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageHistory1."Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME,8,'<Year4><Month,2><Day,2>') + lineTab2;
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionORDCHG."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    //CS073 Shawn End
                                    SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionORDCHG."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2 + OREMessageHistory1."Running No." + lineTab2 + FORMAT(MessageReferenceNumb) + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionORDCHG."Order No." + lineTab2 + FORMAT(OREMessageCollectionORDCHG."Order Date", 8, '<Year4><Month,2><Day,2>') + lineTab2 + OREMessageCollectionORDCHG."Ship-to Code" + lineTab2;
                                    SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."Action Type" + 1, 0, 2) + lineTab2 + OREMessageCollectionORDCHG."Item No." + lineTab2 + RemoveSpecChars(OREMessageCollectionORDCHG.Description) + lineTab2; //Shawn
                                    SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG.Quantity, 0, 2) + lineTab2 + 'PCE' + lineTab2 + FORMAT(OREMessageCollectionORDCHG."ORE Line No.") + lineTab2;
                                    SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."Requested Receipt Date", 8, '<Year4><Month,2><Day,2>') + lineTab2 + FORMAT(CountLine) + lineTab2 + FORMAT(OREMessageCollectionORDCHG."Line No.");

                                    LineNumber := LineNumber + 1;
                                    InsertDataInBuffer(); //BC Upgrade

                                //Status change moved to API.
                                /*
                                PurchaseLine.RESET;
                                PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDCHG."Line No.");
                                PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDCHG."Order No.");
                                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                IF PurchaseLine.FIND('-') THEN BEGIN
                                    REPEAT
                                        PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Sent;
                                        PurchaseLine.MODIFY(TRUE);
                                    UNTIL PurchaseLine.NEXT = 0;
                                END;
                                OREMessageCollectionORDCHG."Message Status" := OREMessageCollectionORDCHG."Message Status"::Sent;
                                OREMessageCollectionORDCHG.MODIFY(TRUE);
                                */

                                UNTIL OREMessageCollectionORDCHG.NEXT = 0;
                            END;


                        /*
                        OREMessageHistory1."File Sent By" := USERID;
                        OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                        OREMessageHistory1."Message Status" := OREMessageHistory."Message Status"::Sent;
                        OREMessageHistory1.MODIFY(TRUE);
                        */

                        UNTIL OREMessageHistory1.NEXT = 0;

                        //BC Upgrade
                        /*
                        //CS100
                        //FileName := GeneralLedgerSetup."ORE Messaging File Path"+'\ORDCHG'+'_'+GeneralLedgerSetup."ORE Country Qualifier" + OREMessageHistory."Reverse Routing Address" + '.csv';
                        FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\ORDCHG' + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)" + '.csv';
                        //CS100
                        CreateFile(FileName, SaveString);
                        SaveString := '';
                        */
                        //BC Upgrade

                        MessageReferenceNumb := MessageReferenceNumb + 1;
                    END;
                END;
            UNTIL OREMessageHistory.NEXT = 0;
        END;


    end;

    procedure "Send Message_INVRPT"()
    var
        OREMessageCollectionINVRPT: Record "ORE Message Collection INVRPT";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        TempCheckHistory: Record "G/L Account" temporary;
        OREMessageHistory1: Record "ORE Message History";
    begin
        GeneralLedgerSetup.GET;
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        MessageReferenceNumb := 1;
        SaveString := '';
        TempCheckHistory.RESET;
        TempCheckHistory.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_INVRPT;
        FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)";

        DeleteDataInBuffer();
        //BC Upgrade

        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'INVRPT');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        IF OREMessageHistory.FIND('-') THEN BEGIN
            REPEAT
                TempCheckHistory.RESET;
                TempCheckHistory.SETRANGE(Name, OREMessageHistory."Reverse Routing Address");
                TempCheckHistory.SETRANGE("Last Date Modified", OREMessageHistory."Report End Date");
                IF TempCheckHistory.ISEMPTY THEN BEGIN
                    TempCheckHistory.INIT;
                    TempCheckHistory."No." := FORMAT(OREMessageHistory."Entry No.");
                    TempCheckHistory.Name := OREMessageHistory."Reverse Routing Address";
                    TempCheckHistory."Last Date Modified" := OREMessageHistory."Report End Date";
                    TempCheckHistory.INSERT(TRUE);

                    SaveString := 'ORE Country Qualifier' + lineTab2 + 'ORE Reverse Routing Address' + lineTab2 + 'Output Date' + lineTab2 + 'Output Time' + lineTab2 + 'Running No.' + lineTab2 + 'Message Reference No.' + lineTab2 + 'Entry No.' + lineTab2 + 'Report Issue Date' + lineTab2;
                    SaveString := SaveString + 'INVRPT End Date' + lineTab2 + 'Sold-to Code' + lineTab2 + 'Ship-to Code' + lineTab2 + 'Ship-to Name' + lineTab2 + 'Ship-to Address' + lineTab2 + 'Ship-to City' + lineTab2 + 'Ship-to County' + lineTab2 + 'Ship-to Post Code' + lineTab2;
                    SaveString := SaveString + 'Ship-to Country' + lineTab2 + 'Currency Code' + lineTab2 + 'LIN.Line No.' + lineTab2 + 'Customer Name' + lineTab2 + 'Description' + lineTab2 + 'Quantity' + lineTab2; //CS060 Shawn
                    //CS089
                    //SaveString := SaveString + 'Measure Unit Qualifier'+lineTab2+'ORE DBC Cost'+lineTab2+'Count of LIN Segment'+lineTab2;
                    //SaveString := SaveString + 'Item No.'+FORMAT(lineTab2)+'Original Item No.'+lineTab2+'Spare3'+lineTab2+'Spare4'+lineTab2+'Spare5'+lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2 + 'Inventory Unit Cost' + lineTab2 + 'Count of LIN Segment' + lineTab2;
                    SaveString := SaveString + 'Item No.' + FORMAT(lineTab2) + 'Original Item No.' + lineTab2 + 'Ship-to Address2' + lineTab2 + 'Spare4' + lineTab2 + 'Spare5' + lineTab2;
                    //CS089
                    SaveString := SaveString + 'Spare6' + lineTab2 + 'Spare7' + lineTab2 + 'Spare8' + lineTab2 + 'Spare9' + lineTab2 + 'Spare10' + lineTab2;
                    SaveString := SaveString + 'Spare11' + lineTab2 + 'Spare12' + lineTab2 + 'Spare13' + lineTab2 + 'Spare14' + lineTab2 + 'Spare15' + lineTab2 + 'Spare16' + lineTab2 + 'Spare17' + lineTab2 + 'Spare18' + lineTab2 + 'Spare19' + lineTab2 + 'Spare20';
                    CountLine := "Count of LIN Segment"('INVRPT', OREMessageHistory."Reverse Routing Address", OREMessageHistory."Report End Date");

                    //BC Upgrade
                    HistoryEntryNo := OREMessageHistory."Entry No.";
                    RevRoutingAddr := OREMessageHistory."Reverse Routing Address";
                    RevRoutingAddrSD := OREMessageHistory."Reverse Routing Address (SD)";
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    LineNumber := 1;

                    OREMessageHistory1.RESET;
                    OREMessageHistory1.SETRANGE("Message Name", 'INVRPT');
                    OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    OREMessageHistory1.SETRANGE("Report End Date", OREMessageHistory."Report End Date");
                    OREMessageHistory1.SETRANGE("Reverse Routing Address", OREMessageHistory."Reverse Routing Address");
                    IF OREMessageHistory1.FIND('-') THEN BEGIN
                        REPEAT
                            OREMessageCollectionINVRPT.RESET;
                            OREMessageCollectionINVRPT.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                            IF OREMessageCollectionINVRPT.FIND('-') THEN BEGIN
                                REPEAT
                                    //BC Upgrade
                                    //IF LineNumber > 1 THEN
                                    //    SaveString := SaveString + FORMAT(lineChar);
                                    //BC Upgrade

                                    //CS073 Shawn Begin
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageHistory1."Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME,8,'<Year4><Month,2><Day,2>') + lineTab2;
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionINVRPT."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionINVRPT."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    //CS073 Shawn End
                                    SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2 + OREMessageHistory1."Running No." + lineTab2 + FORMAT(MessageReferenceNumb) + lineTab2;
                                    //CS089
                                    //SaveString := SaveString + FORMAT(OREMessageCollectionINVRPT."Entry No.") + lineTab2 + FORMAT(CURRENTDATETIME,8,'<Year4><Month,2><Day,2>') + lineTab2;
                                    SaveString := SaveString + FORMAT(MessageReferenceNumb) + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                                    //CS089
                                    SaveString := SaveString + FORMAT(OREMessageHistory1."Report End Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionINVRPT."Sold-to Code" + lineTab2 + OREMessageCollectionINVRPT."Ship-to Code" + lineTab2 + OREMessageCollectionINVRPT."Ship-to Name" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Address" + lineTab2 + OREMessageCollectionINVRPT."Ship-to City" + lineTab2 + OREMessageCollectionINVRPT."Ship-to County" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Post Code" + lineTab2 + OREMessageCollectionINVRPT."Ship-to Country" + lineTab2 + 'USD' + lineTab2;
                                    SaveString := SaveString + FORMAT(LineNumber) + lineTab2 + OREMessageCollectionINVRPT."ORE Customer Name" + lineTab2 + RemoveSpecChars(OREMessageCollectionINVRPT.Description) + lineTab2; //CS060 Shawn
                                    SaveString := SaveString + FORMAT(OREMessageCollectionINVRPT.Quantity, 0, 2) + lineTab2 + 'PCE' + lineTab2 + FORMAT(OREMessageCollectionINVRPT."ORE DBC Cost") + lineTab2;
                                    //CS089
                                    //SaveString := SaveString + FORMAT(CountLine) + lineTab2 + OREMessageCollectionINVRPT."Item No." + lineTab2 + OREMessageCollectionINVRPT."Original Item No."; //CS060 Shawn
                                    SaveString := SaveString + FORMAT(CountLine) + lineTab2 + OREMessageCollectionINVRPT."Item No." + lineTab2 + OREMessageCollectionINVRPT."Original Item No." + lineTab2 + OREMessageCollectionINVRPT."Ship-to Address2";
                                    //CS089

                                    LineNumber := LineNumber + 1;
                                    InsertDataInBuffer(); //BC Upgrade

                                //Status change moved to API.
                                /*
                                OREMessageCollectionINVRPT."Message Status" := OREMessageCollectionINVRPT."Message Status"::Sent;
                                OREMessageCollectionINVRPT.MODIFY(TRUE);
                                */

                                UNTIL OREMessageCollectionINVRPT.NEXT = 0;
                            END;

                        /*
                        OREMessageHistory1."File Sent By" := USERID;
                        OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                        OREMessageHistory1."Message Status" := OREMessageHistory."Message Status"::Sent;
                        OREMessageHistory1.MODIFY(TRUE);
                        */

                        UNTIL OREMessageHistory1.NEXT = 0;

                        //BC Upgrade
                        /*
                        //CS100
                        //FileName := GeneralLedgerSetup."ORE Messaging File Path"+'\INVRPT'+'_'+GeneralLedgerSetup."ORE Country Qualifier" + OREMessageHistory."Reverse Routing Address" +'.csv'; // CS060 Shawn
                        FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\INVRPT' + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)" + '.csv';
                        //CS100
                        //FileName := FileName + FORMAT(OREMessageHistory."Report End Date",8,'<Year4><Month,2><Day,2>') +'.csv'; //CS060 Shawn
                        CreateFile(FileName, SaveString);
                        SaveString := '';
                        */
                        //BC Upgrade

                        MessageReferenceNumb := MessageReferenceNumb + 1;
                    END;
                END;
            UNTIL OREMessageHistory.NEXT = 0;
        END;

    end;

    procedure "Send Message_SLSRPT"()
    var
        OREMessageCollectionSLSRPT: Record "ORE Message Collection SLSRPT";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        CustomerNo: Code[20];
        CurrencyCode: Code[10];
        TempCheckHistory: Record "Location" temporary;
        OREMessageHistory1: Record "ORE Message History";
    begin
        GeneralLedgerSetup.GET;
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        MessageReferenceNumb := 1;
        SaveString := '';

        TempCheckHistory.RESET;
        TempCheckHistory.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_SLSRPT;
        FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)";

        DeleteDataInBuffer();
        //BC Upgrade

        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'SLSRPT');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        IF OREMessageHistory.FIND('-') THEN BEGIN
            REPEAT
                TempCheckHistory.RESET;
                TempCheckHistory.SETRANGE(Name, OREMessageHistory."Reverse Routing Address");
                IF TempCheckHistory.ISEMPTY THEN BEGIN
                    SaveString := 'ORE Country Qualifier' + lineTab2 + 'ORE Reverse Routing Address' + lineTab2 + 'Output Date' + lineTab2 + 'Output Time' + lineTab2 + 'Running No.' + lineTab2 + 'Message Reference No.' + lineTab2 + 'Entry No.' + lineTab2;
                    SaveString := SaveString + 'Report Start Date' + lineTab2 + 'Report End Date' + lineTab2 + 'Report Issue Date' + lineTab2;
                    //CS089
                    //SaveString := SaveString + 'Sell to Customer No.'+lineTab2+'Currency Code'+lineTab2+'Transaction Type Code'+lineTab2+'Sell to Customer ORE Name'+lineTab2+'Sell to Customer ORE Address1'+lineTab2;
                    SaveString := SaveString + 'Sell to Customer No.' + lineTab2 + 'Sales Currency Code' + lineTab2 + 'Document Type Code' + lineTab2 + 'Sell to Customer ORE Name' + lineTab2 + 'Sell to Customer ORE Address1' + lineTab2;
                    //CS089
                    SaveString := SaveString + 'Sell to Customer ORE Address2' + lineTab2 + 'Sell to ORE City' + lineTab2 + 'Sell to ORE State/Province' + lineTab2;
                    //CS089
                    //SaveString := SaveString + 'Sell to Post Code'+lineTab2+'Sell to Country/Region Code'+lineTab2+'Description'+lineTab2+'Item No.'+lineTab2+'Quantity'+lineTab2+'Unit Price'+lineTab2+'ORE Debit Cost'+lineTab2+'ORE DBC Cost'+lineTab2;
                    //SaveString := SaveString + 'Transaction No.'+lineTab2+'Sales Ship Doc. Line. No.'+lineTab2+'Measure Unit Qualifier'+lineTab2;
                    //SaveString := SaveString + 'Transaction Start Date'+lineTab2+'OEM No.'+lineTab2+'OEM ORE Name'+lineTab2+'OEM ORE Address1'+lineTab2+'OEM ORE Address2'+lineTab2+'OEM ORE City'+lineTab2+'OEM ORE State/Province'+lineTab2;
                    //SaveString := SaveString + 'OEM Post Code' +lineTab2+ 'OEM Country/Region Code'+lineTab2+'Count of LIN Segment'+lineTab2;
                    //SaveString := SaveString + 'Sold-to Code'+FORMAT(lineTab2)+'Vendor No.'+lineTab2+'Purchase Currency Code'+lineTab2+'Return Credit Memo'+lineTab2+'Spare5'+lineTab2;
                    //SaveString := SaveString + 'Spare6'+lineTab2+'Spare7'+lineTab2+'Spare8'+lineTab2+'Spare9'+lineTab2+'Spare10'+lineTab2;
                    SaveString := SaveString + 'Sell to Post Code' + lineTab2 + 'Sell to ORE Country' + lineTab2 + 'Description' + lineTab2 + 'Item No.' + lineTab2 + 'Quantity' + lineTab2 + 'Unit Price' + lineTab2 + 'Unit Cost' + lineTab2 + 'ORE DBC Cost' + lineTab2;
                    SaveString := SaveString + 'External Document No.' + lineTab2 + 'Sales Ship Doc. Line. No.' + lineTab2 + 'Measure Unit Qualifier' + lineTab2;
                    SaveString := SaveString + 'Posting Date' + lineTab2 + 'OEM No.' + lineTab2 + 'OEM ORE Name' + lineTab2 + 'OEM ORE Address1' + lineTab2 + 'OEM ORE Address2' + lineTab2 + 'OEM ORE City' + lineTab2 + 'OEM ORE State/Province' + lineTab2;
                    SaveString := SaveString + 'OEM Post Code' + lineTab2 + 'OEM ORE Country' + lineTab2 + 'Count of LIN Segment' + lineTab2;
                    SaveString := SaveString + 'Sold-to Code' + FORMAT(lineTab2) + 'Vendor No.' + lineTab2 + 'Purchase Currency Code' + lineTab2 + 'Return Credit Memo' + lineTab2 + 'Renesas Report Unit Price' + lineTab2;
                    SaveString := SaveString + 'Renesas Report Unit Price Currency' + lineTab2 + 'Sell to Customer SCM Code' + lineTab2 + 'OEM SCM Code' + lineTab2 + 'Original Item No.' + lineTab2 + 'Spare10' + lineTab2;
                    //CS089
                    SaveString := SaveString + 'Spare11' + lineTab2 + 'Spare12' + lineTab2 + 'Spare13' + lineTab2 + 'Spare14' + lineTab2 + 'Spare15' + lineTab2 + 'Spare16' + lineTab2 + 'Spare17' + lineTab2 + 'Spare18' + lineTab2 + 'Spare19' + lineTab2 + 'Spare20';
                    CountLine := "Count of LIN Segment"('SLSRPT', OREMessageHistory."Reverse Routing Address", 0D);

                    //BC Upgrade
                    HistoryEntryNo := OREMessageHistory."Entry No.";
                    RevRoutingAddr := OREMessageHistory."Reverse Routing Address";
                    RevRoutingAddrSD := OREMessageHistory."Reverse Routing Address (SD)";
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    LineNumber := 1;

                    OREMessageHistory1.RESET;
                    OREMessageHistory1.SETRANGE("Message Name", 'SLSRPT');
                    OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
                    OREMessageHistory1.SETRANGE("Reverse Routing Address", OREMessageHistory."Reverse Routing Address");
                    IF OREMessageHistory1.FIND('-') THEN BEGIN
                        REPEAT
                            OREMessageCollectionSLSRPT.RESET;
                            OREMessageCollectionSLSRPT.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                            IF OREMessageCollectionSLSRPT.FIND('-') THEN BEGIN
                                REPEAT
                                    // BC Upgrade
                                    //IF LineNumber > 1 THEN
                                    //    SaveString := SaveString + FORMAT(lineChar);
                                    // BC Upgrade

                                    //CS073 Shawn Begin
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageHistory1."Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME,8,'<Year4><Month,2><Day,2>') + lineTab2;
                                    //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionSLSRPT."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2 + OREMessageCollectionSLSRPT."ORE Reverse Routing Address" + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //BC Upgrade
                                    //CS073 Shawn End
                                    SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2 + OREMessageHistory1."Running No." + lineTab2 + FORMAT(MessageReferenceNumb) + lineTab2;
                                    SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Entry No.") + lineTab2 + FORMAT(OREMessageHistory1."Report Start Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                                    SaveString := SaveString + FORMAT(OREMessageHistory1."Report End Date", 8, '<Year4><Month,2><Day,2>') + lineTab2 + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Customer No." + lineTab2 + OREMessageCollectionSLSRPT."Currency Code" + lineTab2 + OREMessageCollectionSLSRPT."Transaction Type Code" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" + lineTab2 + OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to ORE City" + lineTab2 + OREMessageCollectionSLSRPT."Sell-to ORE State/Province" + lineTab2 + OREMessageCollectionSLSRPT."Sell-to Post Code" + lineTab2;
                                    //CS089
                                    //SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Country/Region Code" + lineTab2 + RemoveSpecChars(OREMessageCollectionSLSRPT.Description) + lineTab2 + OREMessageCollectionSLSRPT."Item No." + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to ORE Country" + lineTab2 + RemoveSpecChars(OREMessageCollectionSLSRPT.Description) + lineTab2 + OREMessageCollectionSLSRPT."Item No." + lineTab2;
                                    //CS089
                                    SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT.Quantity, 0, 2) + lineTab2 + FORMAT(OREMessageCollectionSLSRPT."Unit Price") + lineTab2 + FORMAT(OREMessageCollectionSLSRPT."ORE Debit Cost") + lineTab2;
                                    SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."ORE DBC Cost") + lineTab2 + OREMessageCollectionSLSRPT."External Document No." + lineTab2;
                                    //CS060-CR30 Shawn Begin
                                    //SaveString := SaveString + OREMessageCollectionSLSRPT."Transaction No." + '/' +FORMAT(OREMessageCollectionSLSRPT."Line No.")  + lineTab2 + 'PCE' + lineTab2;
                                    IF OREMessageCollectionSLSRPT."Transaction Type Code" = '380' THEN BEGIN
                                        SaveString := SaveString + OREMessageCollectionSLSRPT."Transaction No." + '/' + FORMAT(OREMessageCollectionSLSRPT."Line No.") + lineTab2;
                                    END ELSE BEGIN
                                        SaveString := SaveString + OREMessageCollectionSLSRPT."Original Document No." + '/' + FORMAT(OREMessageCollectionSLSRPT."Original Document Line No.") + lineTab2;
                                    END;
                                    SaveString := SaveString + 'PCE' + lineTab2;
                                    //CS060-CR30 Shawn End
                                    SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Transaction Date", 8, '<Year4><Month,2><Day,2>') + lineTab2 + OREMessageCollectionSLSRPT."OEM No." + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE Name" + lineTab2 + OREMessageCollectionSLSRPT."OEM ORE Address 1" + lineTab2 + OREMessageCollectionSLSRPT."OEM ORE Address 2" + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE City" + lineTab2 + OREMessageCollectionSLSRPT."OEM ORE State/Province" + lineTab2 + OREMessageCollectionSLSRPT."OEM Post Code" + lineTab2;
                                    //CS089
                                    //SaveString := SaveString + OREMessageCollectionSLSRPT."OEM Country/Region Code" + lineTab2 + FORMAT(CountLine) + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE Country" + lineTab2 + FORMAT(CountLine) + lineTab2;
                                    //CS089
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sold-to Code" + lineTab2 + OREMessageCollectionSLSRPT."Vendor No." + lineTab2 + OREMessageCollectionSLSRPT."Purchase Currency Code" + lineTab2;
                                    //Return Credit Memo
                                    IF OREMessageCollectionSLSRPT."Transaction Type Code" = '381' THEN BEGIN
                                        SaveString := SaveString + OREMessageCollectionSLSRPT."Transaction No." + '/' + FORMAT(OREMessageCollectionSLSRPT."Line No.") + lineTab2;
                                    END ELSE BEGIN
                                        // other data, leave it blank.
                                        //CS089
                                        SaveString := SaveString + lineTab2;
                                    END;

                                    //CS089
                                    SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Renesas Report Unit Price") + lineTab2 + OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." + lineTab2;
                                    SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" + lineTab2 + OREMessageCollectionSLSRPT."OEM SCM Code" + lineTab2 + OREMessageCollectionSLSRPT."Original Item No." + lineTab2;
                                    //CS089

                                    LineNumber := LineNumber + 1;
                                    InsertDataInBuffer(); //BC Upgrade

                                //Status change moved to API.
                                /*
                                OREMessageCollectionSLSRPT."Message Status" := OREMessageCollectionSLSRPT."Message Status"::Sent;
                                OREMessageCollectionSLSRPT.MODIFY(TRUE);
                                */

                                UNTIL OREMessageCollectionSLSRPT.NEXT = 0;

                                /*
                                OREMessageHistory1."File Sent By" := USERID;
                                OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                                OREMessageHistory1."Message Status" := OREMessageHistory."Message Status"::Sent;
                                OREMessageHistory1.MODIFY(TRUE);
                                */

                            END;
                        UNTIL OREMessageHistory1.NEXT = 0;

                        //BC Upgrade
                        /*
                        //CS100
                        //FileName := GeneralLedgerSetup."ORE Messaging File Path"+'\SLSRPT'+'_'+GeneralLedgerSetup."ORE Country Qualifier" + OREMessageHistory."Reverse Routing Address" + '.csv';
                        FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\SLSRPT' + '_' + GeneralLedgerSetup."ORE Country Qualifier" + GeneralLedgerSetup."ORE Rev. Rte. Add.(File Name)" + '.csv';
                        //CS100
                        CreateFile(FileName, SaveString);
                        SaveString := '';
                        */
                        //BC Upgrade

                        MessageReferenceNumb := MessageReferenceNumb + 1;
                    END;
                END;
            UNTIL OREMessageHistory.NEXT = 0;
        END;


    end;

    procedure "Send Message_ALL"()
    begin
        "Send Message_ORDERS"();
        "Send Message_ORDCHG"();
        "Send Message_INVRPT"();
        "Send Message_SLSRPT"();
    end;

    local procedure "Count of LIN Segment"(MessageType: Code[10]; ReverseRoutingAddress: Code[40]; ReportEndDate: Date) CountLine: Integer
    var
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";
        OREMessageHistory: Record "ORE Message History";
        OREMessageCollectionORDCHG: Record "ORE Message Collection ORDCHG";
        OREMessageCollectionSLSRPT: Record "ORE Message Collection SLSRPT";
        OREMessageCollectionINVRPT: Record "ORE Message Collection INVRPT";
    begin
        CountLine := 0;
        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", MessageType);
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        IF ReportEndDate <> 0D THEN
            OREMessageHistory.SETRANGE("Report End Date", ReportEndDate);
        OREMessageHistory.SETRANGE("Reverse Routing Address", ReverseRoutingAddress);
        IF OREMessageHistory.FIND('-') THEN BEGIN
            REPEAT
                CASE MessageType OF
                    'ORDERS':
                        BEGIN
                            OREMessageCollectionORDERS.RESET;
                            OREMessageCollectionORDERS.SETRANGE("History Entry No.", OREMessageHistory."Entry No.");
                            CountLine := CountLine + OREMessageCollectionORDERS.COUNT();
                        END;
                    'ORDCHG':
                        BEGIN
                            OREMessageCollectionORDCHG.RESET;
                            OREMessageCollectionORDCHG.SETRANGE("History Entry No.", OREMessageHistory."Entry No.");
                            CountLine := CountLine + OREMessageCollectionORDCHG.COUNT();
                        END;
                    'INVRPT':
                        BEGIN
                            OREMessageCollectionINVRPT.RESET;
                            OREMessageCollectionINVRPT.SETRANGE("History Entry No.", OREMessageHistory."Entry No.");
                            CountLine := CountLine + OREMessageCollectionINVRPT.COUNT();
                        END;
                    'SLSRPT':
                        BEGIN
                            OREMessageCollectionSLSRPT.RESET;
                            OREMessageCollectionSLSRPT.SETRANGE("History Entry No.", OREMessageHistory."Entry No.");
                            CountLine := CountLine + OREMessageCollectionSLSRPT.COUNT();
                        END;
                END;
            UNTIL OREMessageHistory.NEXT = 0;
        END;
    end;

    local procedure RemoveSpecChars(parStr: Text) resStr: Text
    var
        lineChr: Char;
        lineChar: Text;
        lineChr2: Char;
    begin

        lineChr := 10;
        lineChr2 := 13;
        lineChar := FORMAT(lineChr2) + FORMAT(lineChr);
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);

        resStr := DELCHR(DELCHR(parStr, '=', lineChar), '=', lineTab2);
    end;
}

