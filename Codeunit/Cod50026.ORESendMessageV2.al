codeunit 50026 "ORE Send Message V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2


    trigger OnRun()
    begin
    end;

    var
        myFile: File;
        SaveString: Text;
        lineChr: Char;
        lineChar: Text;
        lineChr2: Char;
        lineChar2: Text[10];
        lineTab: Char;
        lineTab2: Text;
        HistoryEntryNo: Integer; //BC Upgrade
        RevRoutingAddr: Code[40]; //BC Upgrade
        RevRoutingAddrSD: Code[40]; //BC Upgrade
        FileName: Text[250]; //BC Upgrade
        MessageName: Code[10]; //BC Upgrade
        Const_MN_ORDERS: Label 'ORDERS'; //BC Upgrade
        Const_MN_ORDCHG: Label 'ORDCHG'; //BC Upgrade
        Const_MN_INVRPT: Label 'INVRPT'; //BC Upgrade
        Const_MN_SLSRPT: Label 'SLSRPT'; //BC Upgrade

    //BC Upgrade
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
        //OREMessageBuffer.SetData(SaveString); //BC Upgrade
        OREMessageBuffer.SetData(RemoveSpecChars2(SaveString, '=', ':''+')); //BC Upgrade
        OREMessageBuffer.Modify();
    end;
    //BC Upgrade

    procedure "Send Message_ORDERS"()
    var
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory: Record "ORE Message History V2";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempMsgOutputKeys: Record "ORE Msg Collection ORDERS V2" temporary;
        OREMsgFinder: Record "ORE Msg Collection ORDERS V2";
        OREMessageCollectionORDERS: Record "ORE Msg Collection ORDERS V2";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        CountLine: Integer;
    begin
        GeneralLedgerSetup.GET;
        lineChr := 10;
        lineChr2 := 13;
        lineChar := FORMAT(lineChr2) + FORMAT(lineChr);
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        MessageReferenceNumb := 1;
        SaveString := '';
        TempMsgOutputKeys.RESET;
        TempMsgOutputKeys.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_ORDERS;

        DeleteDataInBuffer();
        //BC Upgrade

        OREMsgFinder.RESET;
        OREMsgFinder.SETRANGE("Message Name", MessageName);
        OREMsgFinder.SETRANGE("Message Status", OREMsgFinder."Message Status"::Ready);
        IF OREMsgFinder.FINDSET THEN
            REPEAT

                TempMsgOutputKeys.RESET;
                TempMsgOutputKeys.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");
                //TempMsgOutputKeys.SETRANGE("Sold-to Code",OREMsgFinder."Sold-to Code");
                //TempMsgOutputKeys.SETRANGE("Ship-to Code",OREMsgFinder."Ship-to Code");
                IF TempMsgOutputKeys.ISEMPTY THEN BEGIN
                    TempMsgOutputKeys.INIT;
                    TempMsgOutputKeys."Entry No." := OREMsgFinder."Entry No.";
                    TempMsgOutputKeys."Reverse Routing Address" := OREMsgFinder."Reverse Routing Address";
                    //TempMsgOutputKeys."Sold-to Code" := OREMsgFinder."Sold-to Code";
                    //TempMsgOutputKeys."Ship-to Code" := OREMsgFinder."Ship-to Code";
                    TempMsgOutputKeys.INSERT();

                    FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + '_' + OREMsgFinder."Reverse Routing Address"; //BC Upgrade

                    //header line
                    SaveString := 'ORE Country Qualifier' + lineTab2;
                    SaveString := SaveString + 'ORE Reverse Routing Address' + lineTab2;
                    SaveString := SaveString + 'Output Date' + lineTab2;
                    SaveString := SaveString + 'Output Time' + lineTab2;
                    SaveString := SaveString + 'Running No.' + lineTab2;
                    SaveString := SaveString + 'Message Reference No.' + lineTab2;
                    SaveString := SaveString + 'Purchase Order No.' + lineTab2;
                    SaveString := SaveString + 'Order Date' + lineTab2;
                    SaveString := SaveString + 'Ship-to Code' + lineTab2;
                    SaveString := SaveString + 'Currency Code' + lineTab2;
                    SaveString := SaveString + 'LIN.Line No.' + lineTab2;
                    SaveString := SaveString + 'ORE CPN' + lineTab2;
                    SaveString := SaveString + 'Description' + lineTab2;
                    SaveString := SaveString + 'Quantity' + lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2;
                    SaveString := SaveString + 'End Customer Name' + lineTab2;
                    SaveString := SaveString + 'Unit Cost' + lineTab2;
                    SaveString := SaveString + 'ORE Line No.' + lineTab2;
                    SaveString := SaveString + 'Requested Receipt Date' + lineTab2;
                    SaveString := SaveString + 'Count of LIN Segment' + lineTab2;
                    SaveString := SaveString + 'PO Line No.' + lineTab2;
                    SaveString := SaveString + 'Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'Ship&Debit Flag' + lineTab2;
                    SaveString := SaveString + 'RRA NULL Flag' + lineTab2;
                    SaveString := SaveString + 'Renesas Category Code' + lineTab2;
                    SaveString := SaveString + 'Report Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'Spare6' + lineTab2;
                    SaveString := SaveString + 'Spare7' + lineTab2;
                    SaveString := SaveString + 'Spare8' + lineTab2;
                    SaveString := SaveString + 'Spare9' + lineTab2;
                    SaveString := SaveString + 'Spare10' + lineTab2;
                    SaveString := SaveString + 'Spare11' + lineTab2;
                    SaveString := SaveString + 'Spare12' + lineTab2;
                    SaveString := SaveString + 'Spare13' + lineTab2;
                    SaveString := SaveString + 'Spare14' + lineTab2;
                    SaveString := SaveString + 'Spare15' + lineTab2;
                    SaveString := SaveString + 'Spare16' + lineTab2;
                    SaveString := SaveString + 'Spare17' + lineTab2;
                    SaveString := SaveString + 'Spare18' + lineTab2;
                    SaveString := SaveString + 'Spare19' + lineTab2;
                    SaveString := SaveString + 'Spare20' + lineTab2;
                    SaveString := SaveString + FORMAT(lineChar);
                    LineNumber := 1;

                    //detail line
                    OREMessageCollectionORDERS.RESET;
                    OREMessageCollectionORDERS.SETRANGE("Message Name", MessageName);
                    OREMessageCollectionORDERS.SETRANGE("Message Status", OREMessageCollectionORDERS."Message Status"::Ready);
                    OREMessageCollectionORDERS.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");
                    //OREMessageCollectionORDERS.SETRANGE("Sold-to Code",OREMsgFinder."Sold-to Code");
                    //OREMessageCollectionORDERS.SETRANGE("Ship-to Code",OREMsgFinder."Ship-to Code");

                    CountLine := OREMessageCollectionORDERS.COUNT;

                    //BC Upgrade
                    HistoryEntryNo := OREMsgFinder."History Entry No.";
                    RevRoutingAddr := OREMsgFinder."Reverse Routing Address";
                    RevRoutingAddrSD := '';
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    IF OREMessageCollectionORDERS.FINDSET THEN
                        REPEAT

                            //BC Upgrade
                            //IF LineNumber > 1 THEN
                            //    SaveString := SaveString + FORMAT(lineChar);
                            //BC Upgrade

                            OREMessageHistory.GET(OREMessageCollectionORDERS."History Entry No.");

                            //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := SaveString + OREMessageCollectionORDERS."Reverse Routing Address" + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2;
                            SaveString := SaveString + OREMessageHistory."Running No." + lineTab2;
                            SaveString := SaveString + FORMAT(MessageReferenceNumb) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."Order No." + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDERS."Order Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."Ship-to Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."Currency Code" + lineTab2;
                            SaveString := SaveString + FORMAT(LineNumber) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."ORE CPN" + lineTab2;
                            SaveString := SaveString + RemoveSpecChars(OREMessageCollectionORDERS.Description) + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDERS.Quantity, 0, 2) + lineTab2;
                            SaveString := SaveString + 'PCE' + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."ORE Customer Name" + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDERS."Direct Unit Cost") + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDERS."ORE Line No.") + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDERS."Requested Receipt Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CountLine) + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDERS."Line No.") + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."Sold-to Code" + lineTab2;
                            IF OREMessageCollectionORDERS."Ship&Debit Flag" THEN BEGIN
                                SaveString := SaveString + 'TRUE' + lineTab2;
                            END ELSE BEGIN
                                SaveString := SaveString + 'FALSE' + lineTab2;
                            END;
                            SaveString := SaveString + OREMessageCollectionORDERS."RRA NULL Flag" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."Renesas Category Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDERS."Report Sold-to Code" + lineTab2;

                            LineNumber := LineNumber + 1;

                            InsertDataInBuffer(); //BC Upgrade


                        //BC Upgrade
                        //Status change moved to API.
                        /*
                        IF PurchaseLine.GET(
                            PurchaseLine."Document Type"::Order,
                            OREMessageCollectionORDERS."Order No.",
                            OREMessageCollectionORDERS."Line No.") THEN BEGIN

                            PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::Sent;
                            PurchaseLine.MODIFY(TRUE);
                        END;

                        OREMessageCollectionORDERS."Message Status" := OREMessageCollectionORDERS."Message Status"::Sent;
                        OREMessageCollectionORDERS.MODIFY(TRUE); 
                        */

                        UNTIL OREMessageCollectionORDERS.NEXT = 0;


                    //BC Upgrade
                    /*
                    FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\';
                    FileName := FileName + 'ORDERS' + '_' + GeneralLedgerSetup."ORE Country Qualifier";
                    FileName := FileName + '_' + OREMsgFinder."Reverse Routing Address";
                    //FileName := FileName + '_' + OREMsgFinder."Sold-to Code";
                    //FileName := FileName + '_' + OREMsgFinder."Ship-to Code";
                    FileName := FileName + '.csv';
                    SaveString := RemoveSpecChars2(SaveString, '=', ':''+');
                    CreateFile(FileName, SaveString);
                    SaveString := '';
                    */

                    MessageReferenceNumb := MessageReferenceNumb + 1;

                END; //IF TempMsgOutputKeys.ISEMPTY
            UNTIL OREMsgFinder.NEXT = 0;


        //BC Upgrade
        //Status change moved to API.
        /*
        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'ORDERS');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        OREMessageHistory.MODIFYALL("File Sent By", USERID);
        OREMessageHistory.MODIFYALL("File Sent On", CURRENTDATETIME);
        OREMessageHistory.MODIFYALL("Message Status", OREMessageHistory."Message Status"::Sent);
        */
    end;


    procedure "Send Message_ORDCHG"()
    var
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory: Record "ORE Message History V2";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempMsgOutputKeys: Record "ORE Msg Collection ORDCHG V2" temporary;
        OREMsgFinder: Record "ORE Msg Collection ORDCHG V2";
        OREMessageCollectionORDCHG: Record "ORE Msg Collection ORDCHG V2";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        CountLine: Integer;
    begin
        GeneralLedgerSetup.GET;
        lineChr := 10;
        lineChr2 := 13;
        lineChar := FORMAT(lineChr2) + FORMAT(lineChr);
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        MessageReferenceNumb := 1;
        SaveString := '';
        TempMsgOutputKeys.RESET;
        TempMsgOutputKeys.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_ORDCHG;

        DeleteDataInBuffer();
        //BC Upgrade

        OREMsgFinder.RESET;
        OREMsgFinder.SETRANGE("Message Name", MessageName);
        OREMsgFinder.SETRANGE("Message Status", OREMsgFinder."Message Status"::Ready);
        IF OREMsgFinder.FINDSET THEN
            REPEAT

                TempMsgOutputKeys.RESET;
                TempMsgOutputKeys.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");
                //TempMsgOutputKeys.SETRANGE("Sold-to Code",OREMsgFinder."Sold-to Code");
                //TempMsgOutputKeys.SETRANGE("Ship-to Code",OREMsgFinder."Ship-to Code");
                IF TempMsgOutputKeys.ISEMPTY THEN BEGIN
                    TempMsgOutputKeys.INIT;
                    TempMsgOutputKeys."Entry No." := OREMsgFinder."Entry No.";
                    TempMsgOutputKeys."Reverse Routing Address" := OREMsgFinder."Reverse Routing Address";
                    //TempMsgOutputKeys."Sold-to Code" := OREMsgFinder."Sold-to Code";
                    //TempMsgOutputKeys."Ship-to Code" := OREMsgFinder."Ship-to Code";
                    TempMsgOutputKeys.INSERT();

                    FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + '_' + OREMsgFinder."Reverse Routing Address"; //BC Upgrade

                    //header line
                    SaveString := 'ORE Country Qualifier' + lineTab2;
                    SaveString := SaveString + 'ORE Reverse Routing Address' + lineTab2;
                    SaveString := SaveString + 'Output Date' + lineTab2;
                    SaveString := SaveString + 'Output Time' + lineTab2;
                    SaveString := SaveString + 'Running No.' + lineTab2;
                    SaveString := SaveString + 'Message Reference No.' + lineTab2;
                    SaveString := SaveString + 'Purchase Order No.' + lineTab2;
                    SaveString := SaveString + 'Order Date' + lineTab2;
                    SaveString := SaveString + 'Ship-to Code' + lineTab2;
                    SaveString := SaveString + 'Action Type' + lineTab2;
                    SaveString := SaveString + 'ORE CPN' + lineTab2;
                    SaveString := SaveString + 'Description' + lineTab2;
                    SaveString := SaveString + 'Quantity' + lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2;
                    SaveString := SaveString + 'ORE Line No.' + lineTab2;
                    SaveString := SaveString + 'Requested Receipt Date' + lineTab2;
                    SaveString := SaveString + 'Count of LIN Segment' + lineTab2;
                    SaveString := SaveString + 'PO Line No.' + lineTab2;
                    SaveString := SaveString + 'Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'Ship&Debit Flag' + lineTab2;
                    SaveString := SaveString + 'RRA NULL Flag' + lineTab2;
                    SaveString := SaveString + 'Renesas Category Code' + lineTab2;
                    SaveString := SaveString + 'Report Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'Spare6' + lineTab2;
                    SaveString := SaveString + 'Spare7' + lineTab2;
                    SaveString := SaveString + 'Spare8' + lineTab2;
                    SaveString := SaveString + 'Spare9' + lineTab2;
                    SaveString := SaveString + 'Spare10' + lineTab2;
                    SaveString := SaveString + 'Spare11' + lineTab2;
                    SaveString := SaveString + 'Spare12' + lineTab2;
                    SaveString := SaveString + 'Spare13' + lineTab2;
                    SaveString := SaveString + 'Spare14' + lineTab2;
                    SaveString := SaveString + 'Spare15' + lineTab2;
                    SaveString := SaveString + 'Spare16' + lineTab2;
                    SaveString := SaveString + 'Spare17' + lineTab2;
                    SaveString := SaveString + 'Spare18' + lineTab2;
                    SaveString := SaveString + 'Spare19' + lineTab2;
                    SaveString := SaveString + 'Spare20' + lineTab2;
                    SaveString := SaveString + FORMAT(lineChar);
                    LineNumber := 1;

                    //detail line
                    OREMessageCollectionORDCHG.RESET;
                    OREMessageCollectionORDCHG.SETRANGE("Message Name", MessageName);
                    OREMessageCollectionORDCHG.SETRANGE("Message Status", OREMessageCollectionORDCHG."Message Status"::Ready);
                    OREMessageCollectionORDCHG.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");
                    //OREMessageCollectionORDCHG.SETRANGE("Sold-to Code",OREMsgFinder."Sold-to Code");
                    //OREMessageCollectionORDCHG.SETRANGE("Ship-to Code",OREMsgFinder."Ship-to Code");

                    CountLine := OREMessageCollectionORDCHG.COUNT;

                    //BC Upgrade
                    HistoryEntryNo := OREMsgFinder."History Entry No.";
                    RevRoutingAddr := OREMsgFinder."Reverse Routing Address";
                    RevRoutingAddrSD := '';
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    IF OREMessageCollectionORDCHG.FINDSET THEN
                        REPEAT

                            //BC Upgrade
                            //IF LineNumber > 1 THEN
                            //    SaveString := SaveString + FORMAT(lineChar);
                            //BC Upgrade

                            OREMessageHistory.GET(OREMessageCollectionORDCHG."History Entry No.");

                            //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := SaveString + OREMessageCollectionORDCHG."Reverse Routing Address" + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2;
                            SaveString := SaveString + OREMessageHistory."Running No." + lineTab2;
                            SaveString := SaveString + FORMAT(MessageReferenceNumb) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDCHG."Order No." + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."Order Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDCHG."Ship-to Code" + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."Action Type" + 1, 0, 2) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDCHG."ORE CPN" + lineTab2;
                            SaveString := SaveString + RemoveSpecChars(OREMessageCollectionORDCHG.Description) + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG.Quantity, 0, 2) + lineTab2;
                            SaveString := SaveString + 'PCE' + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."ORE Line No.") + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."Requested Receipt Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CountLine) + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionORDCHG."Line No.") + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDCHG."Sold-to Code" + lineTab2;
                            IF OREMessageCollectionORDCHG."Ship&Debit Flag" THEN BEGIN
                                SaveString := SaveString + 'TRUE' + lineTab2;
                            END ELSE BEGIN
                                SaveString := SaveString + 'FALSE' + lineTab2;
                            END;
                            SaveString := SaveString + OREMessageCollectionORDCHG."RRA NULL Flag" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDCHG."Renesas Category Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionORDCHG."Report Sold-to Code" + lineTab2;

                            IF PurchaseLine.GET(
                              PurchaseLine."Document Type"::Order,
                              OREMessageCollectionORDCHG."Order No.",
                              OREMessageCollectionORDCHG."Line No.") THEN BEGIN

                                PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Sent;
                                PurchaseLine.MODIFY(TRUE);
                            END;
                            LineNumber := LineNumber + 1;

                            InsertDataInBuffer(); //BC Upgrade

                        //BC Upgrade
                        //Status change moved to API.
                        /*
                            OREMessageCollectionORDCHG."Message Status" := OREMessageCollectionORDCHG."Message Status"::Sent;
                            OREMessageCollectionORDCHG.MODIFY(TRUE);
                        */

                        UNTIL OREMessageCollectionORDCHG.NEXT = 0;

                    //BC Upgrade
                    /*
                    FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\';
                    FileName := FileName + 'ORDCHG' + '_' + GeneralLedgerSetup."ORE Country Qualifier";
                    FileName := FileName + '_' + OREMsgFinder."Reverse Routing Address";
                    //FileName := FileName + '_' + OREMsgFinder."Sold-to Code";
                    //FileName := FileName + '_' + OREMsgFinder."Ship-to Code";
                    FileName := FileName + '.csv';
                    SaveString := RemoveSpecChars2(SaveString, '=', ':''+');
                    CreateFile(FileName, SaveString);
                    SaveString := '';
                    */

                    MessageReferenceNumb := MessageReferenceNumb + 1;

                END; //IF TempMsgOutputKeys.ISEMPTY
            UNTIL OREMsgFinder.NEXT = 0;


        //BC Upgrade
        //Status change moved to API.
        /*
        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'ORDCHG');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        OREMessageHistory.MODIFYALL("File Sent By", USERID);
        OREMessageHistory.MODIFYALL("File Sent On", CURRENTDATETIME);
        OREMessageHistory.MODIFYALL("Message Status", OREMessageHistory."Message Status"::Sent);
        */
    end;


    procedure "Send Message_INVRPT"()
    var
        OREMessageHistory: Record "ORE Message History V2";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempMsgOutputKeys: Record "ORE Msg Collection INVRPT V2" temporary;
        OREMsgFinder: Record "ORE Msg Collection INVRPT V2";
        OREMessageCollectionINVRPT: Record "ORE Msg Collection INVRPT V2";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        CountLine: Integer;
    begin
        GeneralLedgerSetup.GET;
        lineChr := 10;
        lineChr2 := 13;
        lineChar := FORMAT(lineChr2) + FORMAT(lineChr);
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        SaveString := '';
        TempMsgOutputKeys.RESET;
        TempMsgOutputKeys.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_INVRPT;

        DeleteDataInBuffer();
        //BC Upgrade

        OREMsgFinder.RESET;
        OREMsgFinder.SETRANGE("Message Name", MessageName);
        OREMsgFinder.SETRANGE("Message Status", OREMsgFinder."Message Status"::Ready);
        IF OREMsgFinder.FINDSET THEN
            REPEAT

                TempMsgOutputKeys.RESET;
                TempMsgOutputKeys.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");
                IF TempMsgOutputKeys.ISEMPTY THEN BEGIN
                    TempMsgOutputKeys.INIT;
                    TempMsgOutputKeys."Entry No." := OREMsgFinder."Entry No.";
                    TempMsgOutputKeys."Reverse Routing Address" := OREMsgFinder."Reverse Routing Address";
                    TempMsgOutputKeys.INSERT();

                    FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + '_' + OREMsgFinder."Reverse Routing Address"; //BC Upgrade

                    //header line
                    SaveString := 'ORE Country Qualifier' + lineTab2;
                    SaveString := SaveString + 'ORE Reverse Routing Address' + lineTab2;
                    SaveString := SaveString + 'Output Date' + lineTab2;
                    SaveString := SaveString + 'Output Time' + lineTab2;
                    SaveString := SaveString + 'Running No.' + lineTab2;
                    SaveString := SaveString + 'Message Reference No.' + lineTab2;
                    SaveString := SaveString + 'Entry No.' + lineTab2;
                    SaveString := SaveString + 'Report Issue Date' + lineTab2;
                    SaveString := SaveString + 'INVRPT End Date' + lineTab2;
                    SaveString := SaveString + 'Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'Ship-to Code' + lineTab2;
                    SaveString := SaveString + 'Ship-to Name' + lineTab2;
                    SaveString := SaveString + 'Ship-to Address' + lineTab2;
                    SaveString := SaveString + 'Ship-to City' + lineTab2;
                    SaveString := SaveString + 'Ship-to County' + lineTab2;
                    SaveString := SaveString + 'Ship-to Post Code' + lineTab2;
                    SaveString := SaveString + 'Ship-to Country' + lineTab2;
                    SaveString := SaveString + 'Currency Code' + lineTab2;
                    SaveString := SaveString + 'LIN.Line No.' + lineTab2;
                    SaveString := SaveString + 'Customer Name' + lineTab2;
                    SaveString := SaveString + 'Description' + lineTab2;
                    SaveString := SaveString + 'Quantity' + lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2;
                    SaveString := SaveString + 'Inventory Unit Cost' + lineTab2;
                    SaveString := SaveString + 'Count of LIN Segment' + lineTab2;
                    SaveString := SaveString + 'Item No.' + lineTab2;
                    SaveString := SaveString + 'Original Item No.' + lineTab2;
                    SaveString := SaveString + 'Ship-to Address2' + lineTab2;
                    SaveString := SaveString + 'RRA NULL Flag' + lineTab2;
                    SaveString := SaveString + 'Renesas Category' + lineTab2;
                    SaveString := SaveString + 'Ship&Debit Flag' + lineTab2;
                    SaveString := SaveString + 'Report Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'ORE CPN' + lineTab2;
                    SaveString := SaveString + 'Spare9' + lineTab2;
                    SaveString := SaveString + 'Spare10' + lineTab2;
                    SaveString := SaveString + 'Spare11' + lineTab2;
                    SaveString := SaveString + 'Spare12' + lineTab2;
                    SaveString := SaveString + 'Spare13' + lineTab2;
                    SaveString := SaveString + 'Spare14' + lineTab2;
                    SaveString := SaveString + 'Spare15' + lineTab2;
                    SaveString := SaveString + 'Spare16' + lineTab2;
                    SaveString := SaveString + 'Spare17' + lineTab2;
                    SaveString := SaveString + 'Spare18' + lineTab2;
                    SaveString := SaveString + 'Spare19' + lineTab2;
                    SaveString := SaveString + 'Spare20' + lineTab2;
                    SaveString := SaveString + FORMAT(lineChar);
                    LineNumber := 1;

                    //detail line
                    OREMessageCollectionINVRPT.RESET;
                    OREMessageCollectionINVRPT.SETRANGE("Message Name", MessageName);
                    OREMessageCollectionINVRPT.SETRANGE("Message Status", OREMessageCollectionINVRPT."Message Status"::Ready);
                    OREMessageCollectionINVRPT.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");

                    CountLine := OREMessageCollectionINVRPT.COUNT;

                    //BC Upgrade
                    HistoryEntryNo := OREMsgFinder."History Entry No.";
                    RevRoutingAddr := OREMsgFinder."Reverse Routing Address";
                    RevRoutingAddrSD := '';
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    IF OREMessageCollectionINVRPT.FINDSET THEN
                        REPEAT

                            //BC Upgrade
                            //IF LineNumber > 1 THEN
                            //    SaveString := SaveString + FORMAT(lineChar);
                            //BC Upgrade

                            OREMessageHistory.GET(OREMessageCollectionINVRPT."History Entry No.");

                            //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := SaveString + OREMessageCollectionINVRPT."Reverse Routing Address" + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2;
                            SaveString := SaveString + OREMessageHistory."Running No." + lineTab2;
                            SaveString := SaveString + '1' + lineTab2; //Message Reference No.
                            SaveString := SaveString + '1' + lineTab2; //Entry No.
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2; //Report Issue Date
                            SaveString := SaveString + FORMAT(OREMessageHistory."Report End Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Sold-to Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Name" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Address" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to City" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to County" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Post Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Country" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Currency Code" + lineTab2;
                            SaveString := SaveString + FORMAT(LineNumber) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."ORE Customer Name" + lineTab2;
                            SaveString := SaveString + RemoveSpecChars(OREMessageCollectionINVRPT.Description) + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionINVRPT.Quantity, 0, 2) + lineTab2;
                            SaveString := SaveString + 'PCE' + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionINVRPT."Inventory Unit Cost") + lineTab2;
                            SaveString := SaveString + FORMAT(CountLine) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Item No." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Original Item No." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Ship-to Address2" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."RRA NULL Flag" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Renesas Category" + lineTab2;
                            IF OREMessageCollectionINVRPT."Ship&Debit Flag" THEN BEGIN
                                SaveString := SaveString + 'TRUE' + lineTab2;
                            END ELSE BEGIN
                                SaveString := SaveString + 'FALSE' + lineTab2;
                            END;
                            SaveString := SaveString + OREMessageCollectionINVRPT."Report Sold-to Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionINVRPT."ORE CPN" + lineTab2;

                            LineNumber := LineNumber + 1;

                            InsertDataInBuffer(); //BC Upgrade

                        //BC Upgrade
                        //Status change moved to API.
                        /*
                            OREMessageCollectionINVRPT."Message Status" := OREMessageCollectionINVRPT."Message Status"::Sent;
                            OREMessageCollectionINVRPT.MODIFY(TRUE);
                        */

                        UNTIL OREMessageCollectionINVRPT.NEXT = 0;

                    //BC Upgrade
                    /*
                    FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\';
                    FileName := FileName + 'INVRPT' + '_' + GeneralLedgerSetup."ORE Country Qualifier";
                    FileName := FileName + '_' + OREMsgFinder."Reverse Routing Address" + '.csv';
                    SaveString := RemoveSpecChars2(SaveString, '=', ':''+');
                    CreateFile(FileName, SaveString);
                    SaveString := '';
                    */

                END; //IF TempMsgOutputKeys.ISEMPTY
            UNTIL OREMsgFinder.NEXT = 0;


        //BC Upgrade
        //Status change moved to API.
        /*
        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'INVRPT');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        OREMessageHistory.MODIFYALL("File Sent By", USERID);
        OREMessageHistory.MODIFYALL("File Sent On", CURRENTDATETIME);
        OREMessageHistory.MODIFYALL("Message Status", OREMessageHistory."Message Status"::Sent);
        */
    end;


    procedure "Send Message_SLSRPT"()
    var
        OREMessageHistory: Record "ORE Message History V2";
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempMsgOutputKeys: Record "ORE Msg Collection SLSRPT V2" temporary;
        OREMsgFinder: Record "ORE Msg Collection SLSRPT V2";
        OREMessageCollectionSLSRPT: Record "ORE Msg Collection SLSRPT V2";

        MessageReferenceNumb: Integer;
        LineNumber: Integer;
        CountLine: Integer;
    begin
        GeneralLedgerSetup.GET;
        lineChr := 10;
        lineChr2 := 13;
        lineChar := FORMAT(lineChr2) + FORMAT(lineChr);
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);
        SaveString := '';
        TempMsgOutputKeys.RESET;
        TempMsgOutputKeys.DELETEALL;

        //BC Upgrade
        MessageName := Const_MN_SLSRPT;

        DeleteDataInBuffer();
        //BC Upgrade

        OREMsgFinder.RESET;
        OREMsgFinder.SETRANGE("Message Name", MessageName);
        OREMsgFinder.SETRANGE("Message Status", OREMsgFinder."Message Status"::Ready);
        IF OREMsgFinder.FINDSET THEN
            REPEAT

                TempMsgOutputKeys.RESET;
                TempMsgOutputKeys.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");
                IF TempMsgOutputKeys.ISEMPTY THEN BEGIN
                    TempMsgOutputKeys.INIT;
                    TempMsgOutputKeys."Entry No." := OREMsgFinder."Entry No.";
                    TempMsgOutputKeys."Reverse Routing Address" := OREMsgFinder."Reverse Routing Address";
                    TempMsgOutputKeys.INSERT();

                    FileName := MessageName + '_' + GeneralLedgerSetup."ORE Country Qualifier" + '_' + OREMsgFinder."Reverse Routing Address"; //BC Upgrade

                    //header line
                    SaveString := 'ORE Country Qualifier' + lineTab2;
                    SaveString := SaveString + 'ORE Reverse Routing Address' + lineTab2;
                    SaveString := SaveString + 'Output Date' + lineTab2;
                    SaveString := SaveString + 'Output Time' + lineTab2;
                    SaveString := SaveString + 'Running No.' + lineTab2;
                    SaveString := SaveString + 'Message Reference No.' + lineTab2;
                    SaveString := SaveString + 'Entry No.' + lineTab2;
                    SaveString := SaveString + 'Report Start Date' + lineTab2;
                    SaveString := SaveString + 'Report End Date' + lineTab2;
                    SaveString := SaveString + 'Report Issue Date' + lineTab2;
                    SaveString := SaveString + 'Sell to Customer No.' + lineTab2;
                    SaveString := SaveString + 'Sales Currency Code' + lineTab2;
                    SaveString := SaveString + 'Document Type Code' + lineTab2;
                    SaveString := SaveString + 'Sell to ORE Customer Name' + lineTab2;
                    SaveString := SaveString + 'Sell to ORE Customer Address1' + lineTab2;
                    SaveString := SaveString + 'Sell to ORE Customer Address2' + lineTab2;
                    SaveString := SaveString + 'Sell to ORE City' + lineTab2;
                    SaveString := SaveString + 'Sell to ORE State/Province' + lineTab2;
                    SaveString := SaveString + 'Sell to Post Code' + lineTab2;
                    SaveString := SaveString + 'Sell to ORE Country' + lineTab2;
                    SaveString := SaveString + 'Description' + lineTab2;
                    SaveString := SaveString + 'Item No.' + lineTab2;
                    SaveString := SaveString + 'Quantity' + lineTab2;
                    SaveString := SaveString + 'Unit Price' + lineTab2;
                    SaveString := SaveString + 'Unit Cost' + lineTab2;
                    SaveString := SaveString + 'ORE DBC Cost' + lineTab2;
                    SaveString := SaveString + 'External Document No.' + lineTab2;
                    SaveString := SaveString + 'Sales Ship Doc. Line. No.' + lineTab2;
                    SaveString := SaveString + 'Measure Unit Qualifier' + lineTab2;
                    SaveString := SaveString + 'Posting Date' + lineTab2;
                    SaveString := SaveString + 'OEM No.' + lineTab2;
                    SaveString := SaveString + 'OEM ORE Name' + lineTab2;
                    SaveString := SaveString + 'OEM ORE Address1' + lineTab2;
                    SaveString := SaveString + 'OEM ORE Address2' + lineTab2;
                    SaveString := SaveString + 'OEM ORE City' + lineTab2;
                    SaveString := SaveString + 'OEM ORE State/Province' + lineTab2;
                    SaveString := SaveString + 'OEM Post Code' + lineTab2;
                    SaveString := SaveString + 'OEM ORE Country' + lineTab2;
                    SaveString := SaveString + 'Count of LIN Segment' + lineTab2;
                    SaveString := SaveString + 'Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'Vendor No.' + lineTab2;
                    SaveString := SaveString + 'Purchase Currency Code' + lineTab2;
                    SaveString := SaveString + 'Return Credit Memo' + lineTab2;
                    SaveString := SaveString + 'Renesas Report Unit Price' + lineTab2;
                    SaveString := SaveString + 'Renesas Report Unit Price Currency' + lineTab2;
                    SaveString := SaveString + 'Sell to Customer SCM Code' + lineTab2;
                    SaveString := SaveString + 'OEM SCM Code' + lineTab2;
                    SaveString := SaveString + 'Original Item No.' + lineTab2;
                    SaveString := SaveString + 'RRA NULL Flag' + lineTab2;
                    SaveString := SaveString + 'Renesas Category' + lineTab2;
                    SaveString := SaveString + 'Ship&Debit Flag' + lineTab2;
                    SaveString := SaveString + 'Report Sold-to Code' + lineTab2;
                    SaveString := SaveString + 'ORE CPN' + lineTab2;
                    SaveString := SaveString + 'Spare15' + lineTab2;
                    SaveString := SaveString + 'Spare16' + lineTab2;
                    SaveString := SaveString + 'Spare17' + lineTab2;
                    SaveString := SaveString + 'Spare18' + lineTab2;
                    SaveString := SaveString + 'Spare19' + lineTab2;
                    SaveString := SaveString + 'Spare20' + lineTab2;
                    SaveString := SaveString + FORMAT(lineChar);
                    LineNumber := 1;

                    //detail line
                    OREMessageCollectionSLSRPT.RESET;
                    OREMessageCollectionSLSRPT.SETRANGE("Message Name", MessageName);
                    OREMessageCollectionSLSRPT.SETRANGE("Message Status", OREMessageCollectionSLSRPT."Message Status"::Ready);
                    OREMessageCollectionSLSRPT.SETRANGE("Reverse Routing Address", OREMsgFinder."Reverse Routing Address");

                    CountLine := OREMessageCollectionSLSRPT.COUNT;

                    //BC Upgrade
                    HistoryEntryNo := OREMsgFinder."History Entry No.";
                    RevRoutingAddr := OREMsgFinder."Reverse Routing Address";
                    RevRoutingAddrSD := '';
                    InsertDataInBuffer(); //File Header
                    //BC Upgrade

                    IF OREMessageCollectionSLSRPT.FINDSET THEN
                        REPEAT

                            //BC Upgrade
                            //IF LineNumber > 1 THEN
                            //    SaveString := SaveString + FORMAT(lineChar);
                            //BC Upgrade

                            OREMessageHistory.GET(OREMessageCollectionSLSRPT."History Entry No.");

                            //SaveString := SaveString + GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := GeneralLedgerSetup."ORE Country Qualifier" + lineTab2; //BC Upgrade
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Reverse Routing Address" + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 4, '<Hour,2><Minutes,2>') + lineTab2;
                            SaveString := SaveString + OREMessageHistory."Running No." + lineTab2;
                            SaveString := SaveString + '1' + lineTab2; //Message Reference No.
                            SaveString := SaveString + FORMAT(OREMessageHistory."Entry No.") + lineTab2; //Entry No.
                            SaveString := SaveString + FORMAT(OREMessageHistory."Report Start Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageHistory."Report End Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + FORMAT(CURRENTDATETIME, 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Customer No." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Currency Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Transaction Type Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Customer ORE Name" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 1" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Cust. ORE Address 2" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to ORE City" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to ORE State/Province" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Post Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to ORE Country" + lineTab2;
                            SaveString := SaveString + RemoveSpecChars(OREMessageCollectionSLSRPT.Description) + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Item No." + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT.Quantity, 0, 2) + lineTab2;

                            SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Unit Price") + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Inventory Unit Cost") + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."ORE DBC Cost") + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."External Document No." + lineTab2;
                            IF OREMessageCollectionSLSRPT."Transaction Type Code" = '380' THEN BEGIN
                                SaveString := SaveString + OREMessageCollectionSLSRPT."Document No." + '/'
                                               + FORMAT(OREMessageCollectionSLSRPT."Line No.") + '/'
                                               + FORMAT(OREMessageCollectionSLSRPT."Sub Line No.") + lineTab2;
                            END ELSE BEGIN
                                SaveString := SaveString + OREMessageCollectionSLSRPT."Original Document No." + '/'
                                               + FORMAT(OREMessageCollectionSLSRPT."Original Document Line No.") + '/'
                                               + FORMAT(OREMessageCollectionSLSRPT."Sub Line No.") + lineTab2;
                            END;

                            SaveString := SaveString + 'PCE' + lineTab2;
                            SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Transaction Date", 8, '<Year4><Month,2><Day,2>') + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM No." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE Name" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE Address 1" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE Address 2" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE City" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE State/Province" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM Post Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM ORE Country" + lineTab2;
                            SaveString := SaveString + FORMAT(CountLine) + lineTab2;

                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sold-to Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Vendor No." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Purchase Currency Code" + lineTab2;
                            IF OREMessageCollectionSLSRPT."Transaction Type Code" = '380' THEN BEGIN
                                SaveString := SaveString + '' + lineTab2;
                            END ELSE BEGIN
                                SaveString := SaveString + OREMessageCollectionSLSRPT."Document No." + '/'
                                               + FORMAT(OREMessageCollectionSLSRPT."Line No.") + '/'
                                               + FORMAT(OREMessageCollectionSLSRPT."Sub Line No.") + lineTab2;
                            END;
                            SaveString := SaveString + FORMAT(OREMessageCollectionSLSRPT."Renesas Report Unit Price") + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Renesas Report Unit Price Cur." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Sell-to Customer SCM Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."OEM SCM Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Original Item No." + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."RRA NULL Flag" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Renesas Category" + lineTab2;
                            IF OREMessageCollectionSLSRPT."Ship&Debit Flag" THEN BEGIN
                                SaveString := SaveString + 'TRUE' + lineTab2;
                            END ELSE BEGIN
                                SaveString := SaveString + 'FALSE' + lineTab2;
                            END;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."Report Sold-to Code" + lineTab2;
                            SaveString := SaveString + OREMessageCollectionSLSRPT."ORE CPN" + lineTab2;

                            LineNumber := LineNumber + 1;

                            InsertDataInBuffer(); //BC Upgrade

                        //BC Upgrade
                        //Status change moved to API.
                        /*
                            OREMessageCollectionSLSRPT."Message Status" := OREMessageCollectionSLSRPT."Message Status"::Sent;
                            OREMessageCollectionSLSRPT.MODIFY(TRUE);
                        */

                        UNTIL OREMessageCollectionSLSRPT.NEXT = 0;

                    //BC Upgrade
                    /*
                    FileName := GeneralLedgerSetup."ORE Messaging File Path" + '\';
                    FileName := FileName + 'SLSRPT' + '_' + GeneralLedgerSetup."ORE Country Qualifier";
                    FileName := FileName + '_' + OREMsgFinder."Reverse Routing Address" + '.csv';
                    SaveString := RemoveSpecChars2(SaveString, '=', ':''+');
                    CreateFile(FileName, SaveString);
                    SaveString := '';
                    */

                END; //IF TempMsgOutputKeys.ISEMPTY
            UNTIL OREMsgFinder.NEXT = 0;


        //BC Upgrade
        //Status change moved to API.
        /*
        OREMessageHistory.RESET;
        OREMessageHistory.SETRANGE("Message Name", 'SLSRPT');
        OREMessageHistory.SETRANGE("Message Status", OREMessageHistory."Message Status"::Ready);
        OREMessageHistory.MODIFYALL("File Sent By", USERID);
        OREMessageHistory.MODIFYALL("File Sent On", CURRENTDATETIME);
        OREMessageHistory.MODIFYALL("Message Status", OREMessageHistory."Message Status"::Sent);
        */
    end;


    procedure "Send Message_ALL"()
    begin
        "Send Message_ORDERS"();
        "Send Message_ORDCHG"();
        "Send Message_INVRPT"();
        "Send Message_SLSRPT"();
    end;

    //BC Upgrade
    /*
    local procedure CreateFile( SaveString: Text)
    begin
        IF SaveString <> '' THEN BEGIN

            IF NOT EXISTS(FileName) THEN BEGIN
                myFile.CREATE(FileName);
                myFile.CLOSE;
            END
            ELSE BEGIN
                ERASE(FileName);
                myFile.CREATE(FileName);
                myFile.CLOSE;
            END;

            myFile.WRITEMODE(TRUE);
            myFile.TEXTMODE(TRUE);
            myFile.OPEN(FileName, TEXTENCODING::UTF8);
            myFile.SEEK(myFile.LEN);
            myFile.WRITE(SaveString);
            myFile.CLOSE;
        END;
    end;
    */

    local procedure RemoveSpecChars(parStr: Text) resStr: Text
    begin

        lineChr := 10;
        lineChr2 := 13;
        lineChar := FORMAT(lineChr2) + FORMAT(lineChr);
        lineTab := 9;
        lineTab2 := FORMAT(lineTab);

        resStr := DELCHR(DELCHR(parStr, '=', lineChar), '=', lineTab2);
    end;

    local procedure RemoveSpecChars2(parStr: Text; parWhere: Text; parWhich: Text) resStr: Text
    begin

        resStr := DELCHR(parStr, parWhere, parWhich); //CS108
    end;
}

