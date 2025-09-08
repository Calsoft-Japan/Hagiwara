report 50023 "Collect Message"
{
    // Modification:
    // 1. SH 04 Nov 2012 - Insert algorithm to validate PSI process job sequence
    // v20201112. Kenya. FDD001 - Add Value Price of PSI Interface.
    // CS017 Kenya 2021/06/10 - Duplicate in Partial Delivery
    //CS101 Shawn 2025/04/05 - Modification of PSI JD Logic
    //CS106 Shawn 2025/05/09 - Adjust CurrencyCode by CompanyInfo. (PSI JD Logic only.)
    //CS109 NieRM 2025/06/19 - Adjust CurrencyCode by CompanyInfo. (PSI All.)

    Permissions = TableData 110 = rimd,
                  TableData 111 = rimd,
                  TableData 120 = rimd,
                  TableData 121 = rimd;
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(guide1; '')
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Do Not Collect Same Message Twice Before Sending !';
                    }
                    field(guide2; '')
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = '=== RUN INIT POST SHIPMENT COLLECT FLAG BEFORE COLLECT JC PSI DATA ===';
                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }
                    field(g_optRetrieveType; g_optRetrieveType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Retrieve Type';

                        trigger OnValidate()
                        begin
                            Navigate_Ctrls();
                        end;
                    }
                    group(ByDaily)
                    {
                        Caption = 'Daily';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        Visible = RequestOptionsPageByDailyVISIBLE;
                        field(dt_ByDate; dt_ByDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Date';
                        }
                    }
                    group(ByMonthly)
                    {
                        Caption = 'Monthly';
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        Visible = RequestOptionsPageByMonthlyVISIBLE;
                        field(g_datStartDate; g_datStartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'From';
                        }
                        field(g_datEndDate; g_datEndDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'To';
                        }
                    }
                    group(Messages)
                    {
                        group(Collect)
                        {
                            Caption = 'Collect';
                            field(chk_JA; bln_MessageID[1])
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Sales Booking Data (JA)';
                                Editable = RequestOptionsPagechk_JAEDITABLE;
                            }
                            field(chk_JB; bln_MessageID[2])
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Sales Shipment Data (JB)';
                                Editable = RequestOptionsPagechk_JBEDITABLE;
                            }
                            field(chk_JC; bln_MessageID[3])
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Renesas SO Backlog Data (JC)';
                                Editable = RequestOptionsPagechk_JCEDITABLE;
                            }
                            field(chk_JD; bln_MessageID[4])
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Inventory Data (JD)';
                                Editable = RequestOptionsPagechk_JDEDITABLE;
                            }
                            field(chk_JJ; bln_MessageID[5])
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Purchasing (Incoming) Data (JJ)';
                                Editable = RequestOptionsPagechk_JJEDITABLE;
                            }
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            GRec_GLSetup.GET;

            //====Start v20201112.
            IF (GRec_GLSetup."Daily PSI Data Collection" >= '1') AND
                (GRec_GLSetup."Monthly PSI Data Collection" = '0') THEN BEGIN
                MESSAGE('Please collect Monthly PSI Data only');
                g_optRetrieveType := g_optRetrieveType::Monthly;
            END;

            IF (GRec_GLSetup."Daily PSI Data Collection" >= '1') AND
                (GRec_GLSetup."Monthly PSI Data Collection" >= '1') THEN BEGIN
                ERROR('Both Daily and Monthly Message Collection already completed');
                EXIT;
            END;
            //====End v20201112.

            IF (GRec_GLSetup."Monthly PSI Data Collection" = '0') AND
                (GRec_GLSetup."Daily PSI Data Collection" = '0') THEN BEGIN
                MESSAGE('Please collect Daily PSI Data first');
                g_optRetrieveType := g_optRetrieveType::Daily;
            END;

            Navigate_Ctrls();

            //g_optRetrieveType := g_optRetrieveType::Daily;
            //Navigate_Ctrls();
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        dt_ByDate := TODAY;
        //g_datStartDate := DMY2DATE(1,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3));//sanjeev
        // //sh g_datEndDate := cdu_Messaging.Get_EndDate();

        //Sanjeev/03.04.2019/BEGIN
        intMonth := (DATE2DMY(TODAY, 2) - 1);
        intYear := DATE2DMY(TODAY, 3);
        IF intMonth = 0 THEN BEGIN
            intMonth := 12;
            intYear := (DATE2DMY(TODAY, 3) - 1);
        END;
        g_datStartDate := DMY2DATE(1, intMonth, intYear);
        //g_datStartDate := DMY2DATE(1,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3));
        //Sanjeev/03.04.2019/END

        g_datStartDate2 := DMY2DATE(1, DATE2DMY(TODAY, 2), DATE2DMY(TODAY, 3) - 1);  //CS017

        g_datEndDate := dt_ByDate;

        //SH 20120723 Start

        g_Daily := 0;
        g_Monthly := 0;
        s_CollectPSI := FALSE;

        GRec_GLSetup.GET;

        IF (GRec_GLSetup."PSI Job Status" = '0') OR
           (GRec_GLSetup."PSI Job Status" = '3')
           THEN
            ERROR('You have not run PSI Initialization Job yet');

        //V20201112. Change the condition to >= '1".
        IF (GRec_GLSetup."Daily PSI Data Collection" >= '1') AND
           (GRec_GLSetup."Monthly PSI Data Collection" >= '1')
           THEN
            ERROR('PSI Data Collection already completed');

        //SH END
    end;

    trigger OnPostReport()
    begin
        //Siak 20140807
        IF NOT s_CollectPSI THEN BEGIN
            MESSAGE('No PSI Data to Collect');
            EXIT;
        END;

        //Siak End

        //SH 20120723 Start
        IF g_optRetrieveType = g_optRetrieveType::Daily THEN BEGIN
            GRec_GLSetup."PSI Job Status" := '2';
            GRec_GLSetup."Daily PSI Data Collection" := '1';
            //Start v20201112.
            IF g_SalesPriceError_Daily = TRUE THEN BEGIN
                GRec_GLSetup."Daily PSI Data Collection" := '2';
            END;
            //End v20201112.
        END ELSE BEGIN
            GRec_GLSetup."PSI Job Status" := '2';
            GRec_GLSetup."Monthly PSI Data Collection" := '1';
            //Start v20201112.
            IF g_SalesPriceError_Monthly = TRUE THEN BEGIN
                GRec_GLSetup."Monthly PSI Data Collection" := '2';
            END;
            //End v20201112.
        END;
        GRec_GLSetup.MODIFY;
        //SH END

        cdu_PrepareMessage.Process_Message(true);

        IF g_optRetrieveType = g_optRetrieveType::Daily THEN BEGIN
            IF g_Daily = 0 THEN BEGIN
                MESSAGE(MSG_009);
            END ELSE BEGIN
                MESSAGE(MSG_007);
            END;
        END;


        IF g_optRetrieveType = g_optRetrieveType::Monthly THEN BEGIN
            IF g_Monthly = 0 THEN BEGIN
                MESSAGE(MSG_009);
            END ELSE BEGIN
                MESSAGE(MSG_008);
            END;
        END;
    end;

    trigger OnPreReport()
    begin

        //sh start 27122010
        //sh To insert blank Control record for JA, JB, JC, JD, AND JJ messages if not found

        //MESSAGE(MSG_003,'Sales Booking Data (JA)');
        CollectData_JZ_Blank(CONST_JA, 1);

        //MESSAGE(MSG_003,'Sales Shipment Data (JB)');
        CollectData_JZ_Blank(CONST_JB, 2);

        //MESSAGE(MSG_003,'Sales Order Backlog Data (JC)');
        CollectData_JZ_Blank(CONST_JC, 3);

        //MESSAGE(MSG_003,'Inventory Data (JD)');
        CollectData_JZ_Blank(CONST_JD, 4);

        //MESSAGE(MSG_003,'Purchasing (Incoming) Data (JJ)');
        CollectData_JZ_Blank(CONST_JJ, 5);
        //sh End

        GRec_GLSetup.GET;

        IF g_optRetrieveType = g_optRetrieveType::Monthly THEN BEGIN
            IF GRec_GLSetup."Daily PSI Data Collection" = '0' THEN BEGIN
                ERROR('Sorry, you must collect Daily PSI Data first');
                EXIT;
            END;
        END;

        IF g_optRetrieveType = g_optRetrieveType::Daily THEN BEGIN
            IF GRec_GLSetup."Daily PSI Data Collection" >= '1' THEN BEGIN  //v20201112
                ERROR('Sorry, you cannot collect Daily PSI Data twice');
                EXIT;
            END;
        END;

        IF g_optRetrieveType = g_optRetrieveType::Monthly THEN BEGIN
            IF GRec_GLSetup."Monthly PSI Data Collection" = '1' THEN BEGIN
                ERROR('Sorry, you cannot collect Monthly PSI Data twice');
                EXIT;
            END;
        END;

        IF g_optRetrieveType = g_optRetrieveType::Daily THEN BEGIN
            IF dt_ByDate = 0D THEN ERROR(TEXT_001);
        END
        ELSE IF g_optRetrieveType = g_optRetrieveType::Monthly THEN BEGIN
            IF (g_datStartDate = 0D) OR (g_datEndDate = 0D) THEN ERROR(TEXT_002);
        END;


        window.OPEN(TEXT_003);

        //IF (bln_MessageID[3]) AND (RequestOptionsPage.chk_JC.ENABLED) THEN BEGIN
        //  IF CollectData_JC_Purch() THEN
        //    MESSAGE(MSG_001,'Sales Order Backlog Data (JC)');
        //  CollectData_JZ(CONST_JC,3);
        //END;

        IF (bln_MessageID[3]) AND (RequestOptionsPagechk_JCEDITABLE) THEN BEGIN
            IF CollectData_JC() THEN
                //    MESSAGE(MSG_001,'Sales Order Backlog Data (JC)');
                CollectData_JZ(CONST_JC, 3);
        END;

        IF (bln_MessageID[4]) AND (RequestOptionsPagechk_JDEDITABLE) THEN BEGIN
            IF CollectData_JD() THEN
                //    MESSAGE(MSG_001,'Inventory Data (JD)');
                CollectData_JZ(CONST_JD, 4);
        END;

        IF (bln_MessageID[1]) AND (RequestOptionsPagechk_JAEDITABLE) THEN BEGIN
            IF CollectData_JA() THEN
                //    MESSAGE(MSG_001,'Sales Booking Data (JA)');
                CollectData_JZ(CONST_JA, 1);
        END;

        IF (bln_MessageID[2]) AND (RequestOptionsPagechk_JBEDITABLE) THEN BEGIN
            IF CollectData_JB() THEN
                //    MESSAGE(MSG_001,'Sales Shipment Data (JB)');
                CollectData_JZ(CONST_JB, 2);
        END;

        IF (bln_MessageID[5]) AND (RequestOptionsPagechk_JJEDITABLE) THEN BEGIN
            IF CollectData_JJ() THEN
                //    MESSAGE(MSG_001,'Purchasing (Incoming) Data (JJ)');
                CollectData_JZ(CONST_JJ, 5);
        END;

        window.CLOSE;
    end;

    var
        cdu_PrepareMessage: Codeunit "PSI Prepare Message";
        GRec_GLSetup: Record "General Ledger Setup";
        dt_ByDate: Date;
        window: Dialog;
        g_optRetrieveType: Option Daily,Monthly;
        g_datStartDate: Date;
        g_datEndDate: Date;
        bln_MessageID: array[5] of Boolean;
        rec_MessageCollection: Record "Message Collection";
        rec_SalesHdr: Record "Sales Header";
        rec_SalesLine: Record "Sales Line";
        rec_PurchHdr: Record "Purchase Header";
        rec_PurchLine: Record "Purchase Line";
        rec_MsgSetup: Record "Message Setup";
        bln_GroupBy: array[5] of Boolean;
        rec_Item: Record Item;
        rec_SalesShipmentHdr: Record "Sales Shipment Header";
        rec_SalesShipmentLine: Record "Sales Shipment Line";
        rec_PurchRcptHdr: Record "Purch. Rcpt. Header";
        rec_Customer: Record Customer;
        rec_PurchRcptLine: Record "Purch. Rcpt. Line";
        rec_MsgControl: Record "Message Control";
        rec_Cust: Record Customer;
        cdu_SalesPost: Codeunit "Sales-Post";
        cdu_PurchPost: Codeunit "Purch.-Post";
        "//>": Integer;
        int_RecordNumber: array[5] of Integer;
        cod_PosNegClass_Quantity: array[5] of Code[1];
        dec_AmountQuantity: array[5] of Decimal;
        cod_PosNegClass_Price: array[5] of Code[1];
        dec_AmountPrice: array[5] of Decimal;
        dt_StaticsDate: array[5] of Date;
        dt_OrderBacklogDate: array[5] of Date;
        txt_Preliminaries: array[5] of Text[191];
        "//<": Integer;
        dt_OrderDate: Date;
        g_DocNo_Len: Integer;
        g_ItemNo_Len: Integer;
        dec_UnitCost: Decimal;
        dec_AdvShpQty: Decimal;
        dec_InvAmt: Decimal;
        dec_UpToTodayShipQty: Decimal;
        dec_UpToTodayRecQty: Decimal;
        dt_EndDay: Date;
        dec_TotShipQty: Decimal;
        dec_TotRecQty: Decimal;
        g_AdvShpQty: Decimal;
        g_Daily: Integer;
        g_Monthly: Integer;
        TEXT_001: Label 'Date must not be left bank';
        TEXT_003: Label 'Collecting Message(s)...\\Message ID.   #1########\\Document No.   #2#########\\Item No.   #3#########';
        TEXT_002: Label 'Start Date And End Date must not be left bank';
        CONST_JA: Label 'JA';
        CONST_JB: Label 'JB';
        CONST_JC: Label 'JC';
        CONST_JD: Label 'JD';
        CONST_JJ: Label 'JJ';
        CONST_JZ: Label 'JZ';
        CONST_Class: Label '+';
        CONST_InvClass: Label 'RE';
        MSG_001: Label '''%1 '' has been collected successfully!';
        MSG_002: Label '''%1 '' Blank Control Record already exist!';
        MSG_003: Label '''%1 '' Inserting blank Control Record in progress!';
        MSG_004: Label '''%1'' has advance shipment quantity  in rv_AdvShpQty -->  ''%2 ''';
        MSG_005: Label '''%1'' has advance shipment quantity in  dec_AdvShpQty -->  ''%2 ''';
        MSG_006: Label '''%1'' has advance shipment quantity in  Advance Shipment Qty -->  ''%2 ''';
        MSG_007: Label 'Daily PSI Data Collection Completed!l ';
        MSG_008: Label 'Monthly PSI Data Collection Completed!';
        MSG_009: Label 'There is no PSI Data to Collect!';

        RequestOptionsPageByMonthlyVISIBLE: Boolean;

        RequestOptionsPageByDailyVISIBLE: Boolean;

        RequestOptionsPagechk_JAEDITABLE: Boolean;

        RequestOptionsPagechk_JBEDITABLE: Boolean;

        RequestOptionsPagechk_JCEDITABLE: Boolean;

        RequestOptionsPagechk_JDEDITABLE: Boolean;

        RequestOptionsPagechk_JJEDITABLE: Boolean;

        RequestOptionsPagechk_JAENABLED: Boolean;

        RequestOptionsPagechk_JBENABLED: Boolean;

        RequestOptionsPagechk_JCENABLED: Boolean;

        RequestOptionsPagechk_JDENABLED: Boolean;

        RequestOptionsPagechk_JJENABLED: Boolean;
        s_CollectPSI: Boolean;
        intMonth: Integer;
        intYear: Integer;
        g_SalesPriceError_Daily: Boolean;
        g_SalesPriceError_Monthly: Boolean;
        g_datStartDate2: Date;

    procedure Navigate_Ctrls()
    begin
        RequestOptionsPageByMonthlyVISIBLE := FALSE;
        RequestOptionsPageByDailyVISIBLE := FALSE;

        RequestOptionsPageByMonthlyVISIBLE := (g_optRetrieveType = g_optRetrieveType::Monthly);
        RequestOptionsPageByDailyVISIBLE := (g_optRetrieveType = g_optRetrieveType::Daily);

        CLEAR(bln_MessageID);
        CLEAR(bln_GroupBy);

        rec_MsgSetup.RESET;
        rec_MsgSetup.SETCURRENTKEY(ID);
        rec_MsgSetup.SETFILTER(ID, '<>%1', rec_MsgSetup.ID::" ");
        IF rec_MsgSetup.FINDSET THEN
            REPEAT
                CASE rec_MsgSetup.ID OF
                    rec_MsgSetup.ID::JA:
                        BEGIN
                            RequestOptionsPagechk_JAEDITABLE := (rec_MsgSetup.Cycle = g_optRetrieveType);
                            bln_MessageID[1] := RequestOptionsPagechk_JAEDITABLE;
                            bln_GroupBy[1] := (rec_MsgSetup.Combine AND bln_MessageID[1]);
                        END;
                    rec_MsgSetup.ID::JB:
                        BEGIN
                            RequestOptionsPagechk_JBEDITABLE := (rec_MsgSetup.Cycle = g_optRetrieveType);
                            bln_MessageID[2] := RequestOptionsPagechk_JBEDITABLE;
                            bln_GroupBy[2] := (rec_MsgSetup.Combine AND bln_MessageID[2]);
                        END;
                    rec_MsgSetup.ID::JC:
                        BEGIN
                            RequestOptionsPagechk_JCEDITABLE := (rec_MsgSetup.Cycle = g_optRetrieveType);
                            bln_MessageID[3] := RequestOptionsPagechk_JCEDITABLE;
                            bln_GroupBy[3] := (rec_MsgSetup.Combine AND bln_MessageID[3]);
                        END;
                    rec_MsgSetup.ID::JD:
                        BEGIN
                            RequestOptionsPagechk_JDEDITABLE := (rec_MsgSetup.Cycle = g_optRetrieveType);
                            bln_MessageID[4] := RequestOptionsPagechk_JDEDITABLE;
                            bln_GroupBy[4] := (rec_MsgSetup.Combine AND bln_MessageID[4]);
                        END;
                    rec_MsgSetup.ID::JJ:
                        BEGIN
                            RequestOptionsPagechk_JJEDITABLE := (rec_MsgSetup.Cycle = g_optRetrieveType);
                            bln_MessageID[5] := RequestOptionsPagechk_JJEDITABLE;
                            bln_GroupBy[5] := (rec_MsgSetup.Combine AND bln_MessageID[5]);
                        END;
                END;
            UNTIL rec_MsgSetup.NEXT = 0;
    end;

    procedure CollectData_JA() DataExist: Boolean
    begin
        //
        DataExist := FALSE;
        rec_SalesHdr.RESET;
        rec_SalesHdr.SETRANGE("Document Type", rec_SalesHdr."Document Type"::Order); //Quote--> Order
        IF g_optRetrieveType = g_optRetrieveType::Daily THEN
            rec_SalesHdr.SETFILTER("Order Date", '..%1', dt_ByDate)
        ELSE IF g_optRetrieveType = g_optRetrieveType::Monthly THEN
            rec_SalesHdr.SETRANGE("Order Date", g_datStartDate, g_datEndDate);
        /*
        //sh rec_SalesHdr.SETFILTER("Message Status(Booking)",'=%1|%2',
            rec_SalesHdr.SETFILTER("Message Status(Booking)",'=%1|%2|%3',
            rec_SalesHdr."Message Status(Booking)"::"Ready to Collect",rec_SalesHdr."Message Status(Booking)"::Revise,
        //sh start
            rec_SalesHdr."Message Status(Booking)"::Sent);
        //sh end
        */

        rec_SalesHdr.SETFILTER("Item Supplier Source", '=%1', rec_SalesHdr."Item Supplier Source"::Renesas);

        rec_SalesHdr.SETFILTER("Message Collected On(Booking)", '<>%1', TODAY);

        IF rec_SalesHdr.FINDSET THEN
            REPEAT
                rec_SalesLine.RESET;
                rec_SalesLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.", Quantity);
                rec_SalesLine.SETRANGE("Document Type", rec_SalesHdr."Document Type");
                rec_SalesLine.SETRANGE("Document No.", rec_SalesHdr."No.");
                rec_SalesLine.SETFILTER(Type, '=%1', rec_SalesLine.Type::Item);
                rec_SalesLine.SETFILTER("No.", '<>%1', '');
                //Siak Hui 05/09/2011
                //rec_SalesLine.SETFILTER(Quantity,'<>%1',0);
                rec_SalesLine.SETFILTER("Item Supplier Source", '=%1', rec_SalesLine."Item Supplier Source"::Renesas);
                //Siak Hui 20110426
                rec_SalesLine.SETFILTER("Message Status", '=%1', rec_SalesLine."Message Status"::"Ready to Collect");
                //Siak Hui 20110426 - END
                rec_SalesLine.SETFILTER(Blocked, '=%1', FALSE);
                IF rec_SalesLine.FINDSET THEN
                    REPEAT
                        window.UPDATE(1, CONST_JA);
                        window.UPDATE(2, rec_SalesLine."Document No.");
                        window.UPDATE(3, rec_SalesLine."No.");
                        //Siak 20140807
                        s_CollectPSI := TRUE;
                        //Siak End
                        WITH rec_MessageCollection DO BEGIN
                            INIT;
                            "Entry No." := Get_LastEntryNo(0) + 1;
                            "File ID" := CONST_JA;
                            "Department Gr Code" := '';                 //Not in use
                                                                        //sh 21112011 - Start
                                                                        //"SCM Customer Code" := rec_SalesHdr."Vendor Cust. Code";
                                                                        //"SCM Customer Code" := rec_SalesHdr."Final Customer No.";
                                                                        //sh 21112011 - End
                                                                        //Siak - Start 06022012
                                                                        //IF   rec_Customer.GET(rec_SalesHdr."OEM No.") THEN BEGIN
                                                                        //     "SCM Customer Code" := rec_Customer."Vendor Cust. Code";
                                                                        //END ELSE BEGIN
                                                                        //           "SCM Customer Code" := rec_SalesHdr."Vendor Cust. Code";
                                                                        //     IF   rec_Customer.GET(rec_SalesHdr."Sell-to Customer No.") THEN BEGIN
                                                                        //          "SCM Customer Code" := rec_Customer."Vendor Cust. Code";
                                                                        //     END;
                                                                        //END;
                            "SCM Customer Code" := Get_SCMCustCode(rec_SalesLine."No.");
                            //Siak - End
                            "End User Code" := '';                      //Not in use
                            "Purpose Code" := '';                       //Not in use
                            "Supplier Code" := '';                      //Not in use
                                                                        //
                                                                        //sh 26032011 Start
                                                                        //"Parts Number" :=  rec_SalesLine."Parts No.";
                            "Parts Number" := Get_PartsNo(rec_SalesLine."No.");
                            //sh 26032011 End
                            //sh 21112011 Start
                            "Item Description" := Get_ItemDes(rec_SalesLine."No.");
                            //sh 21112011 End
                            //
                            "Item No." := rec_SalesLine."No.";
                            "Order Entry Date" := rec_SalesHdr."Order Date";
                            //sh    "Demand Date" := rec_SalesLine."Requested Delivery Date";
                            "Demand Date" := rec_SalesLine."Shipment Date";
                            //Siak Hui - 02112011 Start
                            "Order No" := FORMAT(COPYSTR(rec_SalesLine."Customer Order No.", 1, 20));
                            //Siak Hui - 201213
                            //      "Booking No." := rec_SalesLine."Booking No.";
                            IF rec_SalesLine."Original Booking No." <> '' THEN
                                "Booking No." := rec_SalesLine."Original Booking No."
                            ELSE
                                "Booking No." := rec_SalesLine."Booking No.";
                            //Siak Hui - 02112011 End
                            "Pos/Neg Class" := CONST_Class;
                            Quantity := rec_SalesLine.Quantity;
                            //sh 20110426
                            "SO Document Category" := 'A';
                            "SCM Process Code" := '01';
                            //      "Agent Internal Key" := '';                           //Not in used
                            g_DocNo_Len := STRLEN(rec_SalesLine."Document No.");
                            g_ItemNo_Len := STRLEN(rec_SalesLine."No.");
                            "Agent Internal Key" := PADSTR(rec_SalesLine."Document No.", g_DocNo_Len) + ' / '
                                                  + PADSTR(rec_SalesLine."No.", g_ItemNo_Len);
                            "Update Date" := rec_SalesLine."Update Date";
                            "Update Time" := rec_SalesLine."Update Time";
                            //sh 20110426 - END
                            "Currency Code" := Get_CurrCode_BC(rec_SalesHdr."Currency Code");
                            "Sales Price" := 0;                         //Not in use
                            "Sales Amount" := 0;                        //Not in use
                            "SOLDTO Customer" := '';                    //Not in use
                            "SOLDTO Customer2" := '';                   //Not in use
                            Comment := '';                              //Not in use
                            Preliminaries := '';

                            //>> additional info
                            "Message Status" := "Message Status"::Ready;
                            "Source Document No." := rec_SalesLine."Document No.";
                            "Source Document Line No." := rec_SalesLine."Line No.";
                            "Collected By" := USERID;
                            "Collected On" := TODAY;
                            //
                            //sh 20110426
                            rec_SalesLine."Message Status" := rec_SalesLine."Message Status"::Collected;
                            //Sh 05 Nov 2012
                            IF rec_SalesLine."JA Collection Date" = 0D THEN
                                rec_SalesLine."JA Collection Date" := TODAY;
                            rec_SalesLine.MODIFY;
                            //sh 20110426 - END
                            //
                            //<<
                            INSERT;
                            g_Monthly := g_Monthly + 1;
                            DataExist := TRUE;
                            Collect_ControlMaster(1, rec_SalesLine.Quantity, 0)
                        END;

                        //>> need to modify below fields under SH
                        rec_SalesHdr."Message Collected By(Booking)" := USERID;
                        // IF   rec_SalesHdr."Message Collected On(Booking)" = 0D THEN //so that Re-Collect can work
                        rec_SalesHdr."Message Collected On(Booking)" := TODAY;
                        rec_SalesHdr."Message Status(Booking)" := rec_SalesHdr."Message Status(Booking)"::Collected;
                        rec_SalesHdr.MODIFY;
                    //<<

                    UNTIL rec_SalesLine.NEXT = 0;

            UNTIL rec_SalesHdr.NEXT = 0;

        EXIT(DataExist);

    end;

    procedure CollectData_JB() DataExist: Boolean
    var
        l_MAV: Record "Markup & Added Value";
        l_SalesPrice: Decimal;
        l_GRec_GLSetup: Record "General Ledger Setup";
    begin
        //
        DataExist := FALSE;
        rec_SalesShipmentHdr.RESET;
        IF g_optRetrieveType = g_optRetrieveType::Daily THEN
            rec_SalesShipmentHdr.SETFILTER("Posting Date", '..%1', dt_ByDate)
        ELSE IF g_optRetrieveType = g_optRetrieveType::Monthly THEN
            rec_SalesShipmentHdr.SETRANGE("Posting Date", g_datStartDate, g_datEndDate);

        /*No need condition can be collect as many time as possible
        rec_SalesShipmentHdr.SETFILTER("Message Status(Shipment)",'=%1|%2',
             rec_SalesShipmentHdr."Message Status(Shipment)"::"Ready to Collect",
        //SH Start
              rec_SalesShipmentHdr."Message Status(Shipment)"::Sent);
        //sh End
        */

        //sh rec_SalesShipmentHdr.SETRANGE("Message Collected By(Shipment)",'');
        //sh rec_SalesShipmentHdr.SETRANGE("Message Collected On(Shipment)",0D);
        rec_SalesShipmentHdr.SETFILTER("Item Supplier Source", '=%1', rec_SalesShipmentHdr."Item Supplier Source"::Renesas);

        //sh start
        rec_SalesShipmentHdr.SETFILTER("Message Collected On(Shipment)", '<>%1', TODAY);
        //sh end

        //sh Start..01/03/2011
        //IF rec_SalesShipmentHdr.FINDSET THEN BEGIN
        //IF rec_SalesHdr.GET(rec_SalesHdr."Document Type" = rec_SalesHdr."Document Type"::Order, rec_SalesShipmentHdr."Order No.") THEN
        //        dt_OrderDate := rec_SalesHdr."Order Date"
        //   ELSE dt_OrderDate := rec_SalesShipmentHdr."Document Date";
        //END;
        //sh End

        IF rec_SalesShipmentHdr.FINDSET THEN
            REPEAT
                rec_SalesShipmentLine.RESET;
                rec_SalesShipmentLine.SETRANGE("Document No.", rec_SalesShipmentHdr."No.");
                rec_SalesShipmentLine.SETFILTER(Type, '=%1', rec_SalesShipmentLine.Type::Item);
                rec_SalesShipmentLine.SETFILTER("No.", '<>%1', '');
                //  rec_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
                rec_SalesShipmentLine.SETFILTER(Correction, '<>%1', TRUE);
                rec_SalesShipmentLine.SETFILTER("Item Supplier Source", '=%1', rec_SalesShipmentLine."Item Supplier Source"::Renesas);
                //Siak Hui 20110426
                rec_SalesShipmentLine.SETFILTER("Message Status", '=%1', rec_SalesShipmentLine."Message Status"::"Ready to Collect");
                //Siak Hui 20110426 - END

                //  IF   rec_SalesHdr.GET(rec_SalesHdr."Document Type" = rec_SalesHdr."Document Type"::Order, rec_SalesShipmentHdr."Order No.")
                //  THEN BEGIN
                //       dt_OrderDate := rec_SalesHdr."Order Date"
                //  END ELSE BEGIN
                //       dt_OrderDate := rec_SalesShipmentHdr."Document Date";
                //  END;

                IF rec_SalesShipmentLine.FINDSET THEN
                    REPEAT
                        window.UPDATE(1, CONST_JB);
                        window.UPDATE(2, rec_SalesShipmentLine."Document No.");
                        window.UPDATE(3, rec_SalesShipmentLine."No.");
                        //Siak 20140807
                        s_CollectPSI := TRUE;
                        //Siak End
                        WITH rec_MessageCollection DO BEGIN
                            INIT;
                            "Entry No." := Get_LastEntryNo(0) + 1;
                            "File ID" := CONST_JB;
                            "Department Gr Code" := '';                 //Not in use
                                                                        //sh 21112011 - Start
                                                                        //"SCM Customer Code" := rec_SalesShipmentHdr."Vendor Cust. Code";
                                                                        //"SCM Customer Code" := rec_SalesShipmentHdr."Final Customer No.";
                                                                        //sh 21112011 - End
                                                                        //Siak - Start 06022012
                                                                        //      IF   rec_Customer.GET(rec_SalesShipmentHdr."OEM No.") THEN BEGIN
                                                                        //           "SCM Customer Code" := rec_Customer."Vendor Cust. Code";
                                                                        //      END ELSE BEGIN
                                                                        //           IF   rec_Customer.GET(rec_SalesShipmentHdr."Sell-to Customer No.") THEN BEGIN
                                                                        //                "SCM Customer Code" := rec_Customer."Vendor Cust. Code";
                                                                        //           END;
                                                                        //      END;
                            "SCM Customer Code" := Get_SCMCustCode(rec_SalesShipmentLine."No.");
                            //Siak - End
                            "End User Code" := '';                      //Not in use
                            "Purpose Code" := '';                       //Not in use
                            "Supplier Code" := '';                      //Not in use
                                                                        //
                                                                        //sh 26032011 Start
                                                                        //To retrieve from Item Master to ensure it is latest
                                                                        //      "Parts Number" := rec_SalesShipmentLine."Parts No.";
                            "Parts Number" := Get_PartsNo(rec_SalesShipmentLine."No.");
                            //sh 26032011 End
                            //sh 21112011 Start
                            "Item Description" := Get_ItemDes(rec_SalesShipmentLine."No.");
                            //sh 21112011 End
                            //
                            "Item No." := rec_SalesShipmentLine."No.";
                            //sh    "Order Entry Date" := rec_SalesShipmentHdr."Document Date";
                            //sh    "Order Entry Date" := dt_OrderDate;
                            "Order Entry Date" := rec_SalesShipmentHdr."Order Date";
                            //sh    "Demand Date" := rec_SalesShipmentLine."Requested Delivery Date";
                            "Demand Date" := rec_SalesShipmentLine."Shipment Date";
                            //sh    "Sales Day" :=  rec_SalesShipmentLine."Shipment Date";
                            //sh    IF   rec_SalesShipmentHdr."Posting Date" = rec_SalesShipmentLine."Shipment Date" THEN
                            //sh         "Sales Day" := rec_SalesShipmentHdr."Posting Date"
                            //sh    ELSE "Sales Day" := rec_SalesShipmentLine."Requested Delivery Date";

                            //sh - Start 23082011
                            //sh      "Sales Day" := rec_SalesShipmentHdr."Posting Date";
                            IF rec_SalesShipmentLine."Save Posting Date" <> 0D THEN BEGIN
                                "Sales Day" := rec_SalesShipmentLine."Save Posting Date";
                            END ELSE BEGIN
                                "Sales Day" := rec_SalesShipmentHdr."Posting Date";
                            END;
                            //sh - End
                            //Siak Hui - 02112011 Start
                            "Order No" := FORMAT(COPYSTR(rec_SalesShipmentLine."Customer Order No.", 1, 20));
                            //      "Booking No." := rec_SalesShipmentLine."Booking No.";
                            IF rec_SalesShipmentLine."Original Booking No." <> '' THEN
                                "Booking No." := rec_SalesShipmentLine."Original Booking No."
                            ELSE
                                "Booking No." := rec_SalesShipmentLine."Booking No.";
                            //Siak Hui - 02112011 End
                            "Pos/Neg Class" := CONST_Class;
                            Quantity := rec_SalesShipmentLine.Quantity;
                            //sh 20110426
                            "Update Date" := rec_SalesShipmentLine."Update Date";
                            "Update Time" := rec_SalesShipmentLine."Update Time";
                            "SO Document Category" := 'A';
                            "SCM Process Code" := '01';
                            //      "Agent Internal Key" := '';                           //Not in used
                            g_DocNo_Len := STRLEN(rec_SalesShipmentLine."Document No.");
                            g_ItemNo_Len := STRLEN(rec_SalesShipmentLine."No.");
                            "Agent Internal Key" := PADSTR(rec_SalesShipmentLine."Document No.", g_DocNo_Len) + ' / '
                                                  + PADSTR(rec_SalesShipmentLine."No.", g_ItemNo_Len);
                            //sh 20110426 - END

                            //Now use Sanjeev Begin 12/03/2020
                            "Currency Code" := Get_CurrCode_BC(rec_SalesShipmentHdr."Currency Code");    //Not in use
                                                                                                         //"Sales Price" := rec_SalesShipmentLine."Unit Price";  //v20201112.
                                                                                                         //"Sales Price" := 0;                         //Not in use
                                                                                                         //Now use Sanjeev END 12/03/2020

                            "Sales Amount" := 0;                        //Not in use
                            "SOLDTO Customer" := '';                    //Not in use
                            "SOLDTO Customer2" := '';                   //Not in use
                            Comment := '';                              //Not in use
                            "Sequence Number" := PADSTR('', 3 - STRLEN(FORMAT(rec_SalesShipmentLine."Shipment Seq. No.")), '0')
                                                  + FORMAT(rec_SalesShipmentLine."Shipment Seq. No."); //required to get based on Recipt
                            Preliminaries := '';

                            "Message Status" := "Message Status"::Ready;
                            "Source Document No." := rec_SalesShipmentLine."Document No.";
                            "Source Document Line No." := rec_SalesShipmentLine."Line No.";
                            "Collected By" := USERID;
                            "Collected On" := TODAY;

                            //====Start v20201112.
                            rec_MessageCollection."Unit Price" := rec_SalesShipmentLine."Unit Price";

                            l_MAV.RESET;
                            l_MAV.SETRANGE("Item No.", rec_SalesShipmentLine."No.");
                            l_MAV.SETFILTER("Starting Date", '<=' + FORMAT(WORKDATE));
                            l_MAV.SETCURRENTKEY("Starting Date");
                            l_MAV.SETASCENDING("Starting Date", FALSE);
                            IF l_MAV.FINDFIRST THEN BEGIN
                                rec_MessageCollection."Added Value" := l_MAV."Added Value";
                                rec_MessageCollection."Markup %" := l_MAV."Markup %";
                                rec_MessageCollection."Sales Price" := rec_SalesShipmentLine."Unit Price" / (1 + l_MAV."Markup %" / 100) - l_MAV."Added Value";
                            END
                            ELSE BEGIN
                                rec_MessageCollection."Added Value" := 0;
                                rec_MessageCollection."Markup %" := 0;
                                rec_MessageCollection."Sales Price" := rec_SalesShipmentLine."Unit Price";
                            END;

                            IF rec_MessageCollection."Sales Price" < 0 THEN BEGIN
                                g_SalesPriceError_Monthly := TRUE;
                            END;
                            //====End v20201112.

                            //sh 20110426
                            rec_SalesShipmentLine."Message Status" := rec_SalesShipmentLine."Message Status"::Collected;
                            //Sh 05 Nov 2012
                            rec_SalesShipmentLine."Shipment Collection Date" := TODAY;
                            rec_SalesShipmentLine.MODIFY;
                            //sh 20110426 - END
                            IF rec_SalesShipmentLine.Quantity = 0 THEN BEGIN
                                IF rec_SalesShipmentLine.Insertion THEN BEGIN
                                    INSERT;
                                    g_Monthly := g_Monthly + 1;
                                    DataExist := TRUE;
                                    Collect_ControlMaster(2, rec_SalesShipmentLine.Quantity, 0);
                                END;
                            END;
                            IF rec_SalesShipmentLine.Quantity <> 0 THEN BEGIN
                                INSERT;
                                g_Monthly := g_Monthly + 1;
                                DataExist := TRUE;
                                Collect_ControlMaster(2, rec_SalesShipmentLine.Quantity, 0);
                            END;
                            //        g_Monthly := g_Monthly + 1;
                            //        DataExist := TRUE;
                            //        Collect_ControlMaster(2,rec_SalesShipmentLine.Quantity,0);
                        END;
                    UNTIL rec_SalesShipmentLine.NEXT = 0;

                //>>
                IF rec_SalesShipmentLine.Quantity = 0 THEN BEGIN
                    IF rec_SalesShipmentLine.Insertion THEN BEGIN
                        //cdu_SalesPost.Update_ShipmentHdr(rec_SalesShipmentHdr."No.", TRUE); // Changed during BC Upgrade.
                        Update_ShipmentHdr(rec_SalesShipmentHdr."No.", TRUE);
                    END ELSE BEGIN
                    END;
                END;
                IF rec_SalesShipmentLine.Quantity <> 0 THEN BEGIN
                    //cdu_SalesPost.Update_ShipmentHdr(rec_SalesShipmentHdr."No.", TRUE); // Changed during BC Upgrade.
                    Update_ShipmentHdr(rec_SalesShipmentHdr."No.", TRUE);
                END;
            //<<

            //>> need to modify below fields under SH
            //sh  IF rec_SalesHdr."Message Status(Booking)" = rec_SalesHdr."Message Status(Booking)"::"Ready to Collect" THEN BEGIN
            //    rec_SalesHdr."Message Collected By(Backlog)" := USERID;
            //    IF   rec_SalesHdr."Message Collected On(Backlog)" = 0D THEN //so that Re-Collect can work
            //         rec_SalesHdr."Message Collected On(Backlog)" := TODAY;
            ////sh  END;
            //    rec_SalesHdr."Message Status(Backlog)" := rec_SalesHdr."Message Status(Backlog)"::Collected;
            //    rec_SalesHdr.MODIFY;
            //    //<<

            UNTIL rec_SalesShipmentHdr.NEXT = 0;

        EXIT(DataExist);

    end;

    procedure CollectData_JC() DataExist: Boolean
    var
        l_MAV: Record "Markup & Added Value";
        l_SalesPrice: Decimal;
        l_GRec_GLSetup: Record "General Ledger Setup";
    begin
        //
        DataExist := FALSE;

        rec_SalesLine.RESET;
        //rec_SalesLine.SETRANGE("Document Type",rec_SalesHdr."Document Type");
        //rec_SalesLine.SETRANGE("Document No.",rec_SalesHdr."No.");
        rec_SalesLine.SETFILTER("Document Type", '=%1', rec_SalesLine."Document Type"::Order);
        rec_SalesLine.SETFILTER(Type, '=%1', rec_SalesLine.Type::Item);
        rec_SalesLine.SETFILTER("No.", '<>%1', '');
        rec_SalesLine.SETFILTER("Outstanding Quantity (Actual)", '<>%1', 0);
        rec_SalesLine.SETFILTER("Item Supplier Source", '=%1', rec_SalesLine."Item Supplier Source"::Renesas);
        rec_SalesLine.SETFILTER("JC Collection Date", '<>%1', TODAY);
        rec_SalesLine.SETFILTER(Blocked, '=%1', FALSE);
        IF rec_SalesLine.FINDSET THEN
            REPEAT
                window.UPDATE(1, CONST_JC);
                window.UPDATE(2, rec_SalesLine."Document No.");
                window.UPDATE(3, rec_SalesLine."No.");
                //Siak 20140807
                s_CollectPSI := TRUE;
                //Siak End
                WITH rec_MessageCollection DO BEGIN
                    INIT;
                    "Entry No." := Get_LastEntryNo(0) + 1;
                    "File ID" := CONST_JC;
                    "Department Gr Code" := '';               //Not in use
                    rec_SalesHdr.GET(rec_SalesLine."Document Type", rec_SalesLine."Document No.");
                    //Siak - Start 06022012
                    //IF  rec_Customer.GET(rec_SalesHdr."OEM No.") THEN BEGIN
                    //    "SCM Customer Code" := rec_Customer."Vendor Cust. Code";
                    //END ELSE BEGIN
                    //     IF   rec_Customer.GET(rec_SalesHdr."Sell-to Customer No.") THEN BEGIN
                    //         "SCM Customer Code" := rec_Customer."Vendor Cust. Code";
                    //     END;
                    //END;
                    "SCM Customer Code" := Get_SCMCustCode(rec_SalesLine."No.");
                    //Siak - End
                    "End User Code" := '';                    //Not in use
                    "Purpose Code" := '';                     //Not in use
                    "Supplier Code" := '';                    //Not in use
                    "Parts Number" := Get_PartsNo(rec_SalesLine."No.");
                    "Item Description" := Get_ItemDes(rec_SalesLine."No.");
                    "Item No." := rec_SalesLine."No.";
                    "Order Entry Date" := rec_SalesHdr."Order Date";
                    "Demand Date" := rec_SalesLine."Shipment Date";
                    "Order No" := FORMAT(COPYSTR(rec_SalesLine."Customer Order No.", 1, 20));
                    //      "Booking No." := rec_SalesLine."Booking No.";
                    IF rec_SalesLine."Original Booking No." <> '' THEN
                        "Booking No." := rec_SalesLine."Original Booking No."
                    ELSE
                        "Booking No." := rec_SalesLine."Booking No.";
                    "Pos/Neg Class" := CONST_Class;
                    Quantity := rec_SalesLine."Outstanding Quantity (Actual)";
                    "Update Date" := rec_SalesLine."Update Date";
                    "Update Time" := rec_SalesLine."Update Time";
                    "SO Document Category" := 'A';
                    "SCM Process Code" := '01';
                    g_DocNo_Len := STRLEN(rec_SalesLine."Document No.");
                    g_ItemNo_Len := STRLEN(rec_SalesLine."No.");
                    "Agent Internal Key" := PADSTR(rec_SalesLine."Document No.", g_DocNo_Len) + ' / '
                                          + PADSTR(rec_SalesLine."No.", g_ItemNo_Len);

                    //Now use Sanjeev Begin 12/03/2020
                    "Currency Code" := Get_CurrCode_BC(rec_SalesHdr."Currency Code");
                    // "Sales Price" := rec_SalesLine."Unit Price";  //v20201112.
                    // "Sales Price" := 0;                       //Not in use
                    //Now use Sanjeev END 12/03/2020

                    "Sales Amount" := 0;                      //Not in use
                    "Backlog Collection Day" := TODAY;
                    "Allocated Inv. Class" := '';
                    "SOLDTO Customer" := '';                  //Not in use
                    "SOLDTO Customer2" := '';                 //Not in use
                    Comment := '';                            //Not in use
                    Preliminaries := '';
                    "Message Status" := "Message Status"::Ready;
                    "Source Document No." := rec_SalesLine."Document No.";
                    "Source Document Line No." := rec_SalesLine."Line No.";
                    "Collected By" := USERID;
                    "Collected On" := TODAY;

                    //====Start v20201112.
                    rec_MessageCollection."Unit Price" := rec_SalesLine."Unit Price";

                    l_MAV.RESET;
                    l_MAV.SETRANGE("Item No.", rec_SalesLine."No.");
                    l_MAV.SETFILTER("Starting Date", '<=' + FORMAT(WORKDATE));
                    l_MAV.SETCURRENTKEY("Starting Date");
                    l_MAV.SETASCENDING("Starting Date", FALSE);
                    IF l_MAV.FINDFIRST THEN BEGIN
                        rec_MessageCollection."Added Value" := l_MAV."Added Value";
                        rec_MessageCollection."Markup %" := l_MAV."Markup %";
                        rec_MessageCollection."Sales Price" := rec_SalesLine."Unit Price" / (1 + l_MAV."Markup %" / 100) - l_MAV."Added Value";
                    END
                    ELSE BEGIN
                        rec_MessageCollection."Added Value" := 0;
                        rec_MessageCollection."Markup %" := 0;
                        rec_MessageCollection."Sales Price" := rec_SalesLine."Unit Price";
                    END;

                    IF rec_MessageCollection."Sales Price" < 0 THEN BEGIN
                        g_SalesPriceError_Daily := TRUE;
                    END;
                    //====End v20201112.

                    //sh 20121116
                    rec_SalesLine."Message Status (JC)" := rec_SalesLine."Message Status (JC)"::Collected;
                    //Sh 05 Nov 2012
                    rec_SalesLine."JC Collection Date" := TODAY;
                    rec_SalesLine.MODIFY;
                    //        IF  Quantity > 0 THEN BEGIN
                    INSERT;
                    g_Daily := g_Daily + 1;
                    DataExist := TRUE;
                    Collect_ControlMaster(3, rec_SalesLine."Outstanding Quantity (Actual)", 0)
                    //        END;
                END;

                //>> need to modify below fields under SH
                rec_SalesHdr."Message Collected By(Backlog)" := USERID;
                //  IF   rec_SalesHdr."Message Collected On(Backlog)" = 0D THEN //so that Re-Collect can work
                rec_SalesHdr."Message Collected On(Backlog)" := TODAY;
                //sh  END;
                rec_SalesHdr."Message Status(Backlog)" := rec_SalesHdr."Message Status(Backlog)"::Collected;
                rec_SalesHdr.MODIFY;
            //<<

            UNTIL rec_SalesLine.NEXT = 0;

        EXIT(DataExist);
    end;

    procedure CollectData_JC_Purch() DataExist: Boolean
    begin
        //
        DataExist := FALSE;
        rec_PurchHdr.RESET;
        rec_PurchHdr.SETRANGE("Document Type", rec_PurchHdr."Document Type"::Order);

        IF g_optRetrieveType = g_optRetrieveType::Daily THEN
            rec_PurchHdr.SETFILTER("Order Date", '..%1', dt_ByDate)
        ELSE IF g_optRetrieveType = g_optRetrieveType::Monthly THEN
            rec_PurchHdr.SETRANGE("Order Date", g_datStartDate, g_datEndDate);

        rec_PurchHdr.SETFILTER("Item Supplier Source", '=%1', rec_PurchHdr."Item Supplier Source"::Renesas);

        rec_PurchHdr.SETFILTER("Message Collected On(Backlog)", '<>%1', TODAY);

        IF rec_PurchHdr.FINDSET THEN
            REPEAT
                rec_PurchLine.RESET;
                rec_PurchLine.SETRANGE("Document Type", rec_PurchHdr."Document Type");
                rec_PurchLine.SETRANGE("Document No.", rec_PurchHdr."No.");
                rec_PurchLine.SETFILTER(Type, '=%1', rec_PurchLine.Type::Item);
                rec_PurchLine.SETFILTER("No.", '<>%1', '');
                rec_PurchLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
                rec_PurchLine.SETFILTER("Item Supplier Source", '=%1', rec_PurchLine."Item Supplier Source"::Renesas);
                IF rec_PurchLine.FINDSET THEN
                    REPEAT
                        window.UPDATE(1, CONST_JC);
                        window.UPDATE(2, rec_PurchLine."Document No.");
                        window.UPDATE(3, rec_PurchLine."No.");
                        WITH rec_MessageCollection DO BEGIN
                            INIT;
                            "Entry No." := Get_LastEntryNo(0) + 1;
                            "File ID" := CONST_JC;
                            "Department Gr Code" := '';                //Not in use
                            "SCM Customer Code" := rec_PurchHdr."Vendor Cust. Code";
                            "End User Code" := '';                    //Not in use
                            "Purpose Code" := '';                     //Not in use
                            "Supplier Code" := '';                    //Not in use
                            "Parts Number" := rec_PurchLine."Parts No.";
                            "Item No." := rec_PurchLine."No.";
                            //sh    "Order Entry Date" := rec_PurchHdr."Posting Date";
                            "Order Entry Date" := rec_PurchHdr."Order Date";
                            "Demand Date" := rec_PurchLine."Requested Receipt Date";
                            "Order No" := FORMAT(COPYSTR(rec_PurchLine."CO No.", 1, 20));
                            "Pos/Neg Class" := CONST_Class;
                            Quantity := rec_PurchLine."Outstanding Quantity";
                            "Currency Code" := Get_CurrCode_BC(rec_PurchHdr."Currency Code");
                            "Sales Price" := 0;                       //Not in use
                            "Sales Amount" := 0;                      //Not in use
                            "Backlog Collection Day" := TODAY;
                            //sh    "Allocated Inv. Class" := 0;
                            "Allocated Inv. Class" := '';
                            "SOLDTO Customer" := '';                  //Not in use
                            "SOLDTO Customer2" := '';                 //Not in use
                            Comment := '';                            //Not in use
                            Preliminaries := '';
                            "Message Status" := "Message Status"::Ready;
                            "Source Document No." := rec_PurchLine."Document No.";
                            "Source Document Line No." := rec_PurchLine."Line No.";
                            "Collected By" := USERID;
                            "Collected On" := TODAY;
                            INSERT;
                            DataExist := TRUE;
                            Collect_ControlMaster(3, rec_PurchLine."Outstanding Quantity", 0)
                        END;
                    UNTIL rec_PurchLine.NEXT = 0;

                //>> need to modify below fields under SH
                //sh    IF rec_PurchHdr."Message Status(Backlog)" = rec_PurchHdr."Message Status(Backlog)"::"Ready to Collect" THEN BEGIN
                rec_PurchHdr."Message Collected By(Backlog)" := USERID;
                rec_PurchHdr."Message Collected On(Backlog)" := TODAY;
                rec_PurchHdr."Message Status(Backlog)" := rec_PurchHdr."Message Status(Backlog)"::Collected;
                //sh    END;
                rec_PurchHdr.MODIFY;
                //<<
                rec_PurchHdr.SETFILTER("Order Date", '..%1', dt_ByDate);
            UNTIL rec_PurchHdr.NEXT = 0;

        EXIT(DataExist);
    end;

    procedure CollectData_JD() DataExist: Boolean
    var
        dec_InvPrice: Decimal;
        RecPurchasePrice: Record "Price List Line";
    begin
        //
        DataExist := FALSE;
        rec_Item.RESET;
        rec_Item.SETRANGE("No.");
        rec_Item.SETFILTER("Item Supplier Source", '=%1', rec_Item."Item Supplier Source"::Renesas);
        rec_Item.SETFILTER("Message Collected On", '<>%1', TODAY);
        rec_Item.SETFILTER("Date Filter", '..%1', TODAY);
        rec_Item.SETFILTER(Blocked, '=%1', FALSE);
        IF rec_Item.FINDSET THEN
            REPEAT
                //Siak 20140807
                s_CollectPSI := TRUE;
                //Siak End
                WITH rec_MessageCollection DO BEGIN
                    window.UPDATE(1, CONST_JD);
                    window.UPDATE(2, '');
                    window.UPDATE(3, rec_Item."No.");
                    INIT;
                    "Entry No." := Get_LastEntryNo(0) + 1;
                    "File ID" := CONST_JD;
                    "Department Gr Code" := '';         //Not in use
                    "Warehouse Code" := '';             //Not in use
                    "SCM Customer Code" := Get_SCMCustCode(rec_Item."No.");
                    "End User Code" := '';              //Not in use
                    "Purpose Code" := '';               //Not in use
                    "Supplier Code" := '';              //Not in use
                    "Parts Number" := rec_Item."Parts No.";
                    //sh 21112011 Start
                    "Item Description" := rec_Item.Description;
                    //sh 21112011 End
                    "Item No." := rec_Item."No.";
                    "Inventory Class" := CONST_InvClass;
                    "Pos/Neg Class" := CONST_Class;
                    //sh 20111021
                    rec_Item.SETRANGE("Date Filter", 0D, TODAY);
                    //sh 20111102 - Not to include advance shipment or receipt in Inventory
                    //      rec_Item.CALCFIELDS(Inventory,"Cost Amount (Actual)");
                    //      Quantity := rec_Item.Inventory;
                    rec_Item.CALCFIELDS("Net Change", "Cost Amount (Actual)", "Cost Amount (Expected)", "Cost Posted to G/L", Hold);//sanjeev 010719
                    EVALUATE("Cost Amount (Expected)", FORMAT(rec_Item."Cost Amount (Expected)", 0, '<Precision,4><Standard Format,1>'));
                    EVALUATE("Cost Posted to G/L", FORMAT(rec_Item."Cost Posted to G/L", 0, '<Precision,4><Standard Format,1>'));
                    EVALUATE("Cost Amount (Actual)", FORMAT(rec_Item."Cost Amount (Actual)", 0, '<Precision,4><Standard Format,1>'));
                    //      "Cost Amount (Actual)" := rec_Item."Cost Amount (Actual)";
                    //      "Cost Posted to G/L" := rec_Item."Cost Posted to G/L";
                    //      "Cost Amount (Expected)" := rec_Item."Cost Amount (Expected)";
                    dec_InvAmt := "Cost Posted to G/L" + "Cost Amount (Expected)";
                    //      EVALUATE("Computed Inventory Amount",FORMAT(dec_InvAmt,0,'<Precision,4><Standard Format,1>'));
                    Quantity := rec_Item."Net Change" - rec_Item.Hold;//sanjeev 010719
                    IF Quantity > 0 THEN BEGIN
                        "Cost Amount (Expected)" := rec_Item."Cost Amount (Expected)";
                        dec_UnitCost := ("Cost Amount (Expected)" + "Cost Posted to G/L") / Quantity;
                        EVALUATE("Unit Cost", FORMAT(dec_UnitCost, 0, '<Precision,4><Standard Format,1>'));
                        "Computed Inventory Amount" := Quantity * "Unit Cost";
                    END
                    ELSE BEGIN
                        "Unit Cost" := 0;
                    END;
                    //sh 20111021 END

                    //sh 20111108 Start
                    rec_Item.SETRANGE("Date Filter", 0D, TODAY);
                    rec_Item.CALCFIELDS("Inventory Shipped", "Inventory Receipt");
                    dec_UpToTodayShipQty := rec_Item."Inventory Shipped";
                    dec_UpToTodayRecQty := rec_Item."Inventory Receipt";
                    dt_EndDay := 99991231D;
                    rec_Item.SETRANGE("Date Filter", 0D, dt_EndDay);
                    rec_Item.CALCFIELDS("Inventory Shipped", "Inventory Receipt");
                    dec_TotShipQty := rec_Item."Inventory Shipped";
                    dec_TotRecQty := rec_Item."Inventory Receipt";
                    "Advance Shipped Qty" := (dec_TotShipQty - dec_UpToTodayShipQty) * -1;
                    "Advance Receipt Qty" := dec_TotRecQty - dec_UpToTodayRecQty;
                    //Sh 20111108 END

                    //sh 20110427
                    IF rec_Item."Update Date" = 0D THEN BEGIN
                        "Update Date" := rec_Item."Last Date Modified";
                        "Update Time" := rec_Item."Last Time Modified";
                    END
                    ELSE BEGIN
                        "Update Date" := rec_Item."Update Date";
                        "Update Time" := rec_Item."Update Time";
                    END;
                    //sh20110427 END

                    //CS109 Begin
                    "Currency Code" := Get_CurrCode_BC('');
                    /*
                    //CS106 Begin
                    //"Currency Code" := Get_CurrCode('');
                    "Currency Code" := Get_CurrCode_JD();
                    //CS106 End
                    */
                    //CS109 End

                    //      EVALUATE("Purchase Price",FORMAT(rec_PurchRcptLine."Unit Cost",0,'<Precision,3><Standard Format,1>'));
                    CLEAR(dec_InvPrice);
                    //      IF rec_Item.Inventory <> 0 THEN
                    //         dec_InvPrice := rec_Item."Cost Amount (Actual)" / rec_Item.Inventory;
                    //EVALUATE("Inventory Price",FORMAT(dec_InvPrice,0,'<Precision,3><Standard Format,1>'));
                    EVALUATE("Inventory Price", FORMAT(rec_Item."Unit Cost", 0, '<Precision,4><Standard Format,1>'));
                    //      "Inventory Amount" := (rec_Item.Inventory * "Inventory Price");
                    IF Quantity = 0 THEN
                        "Inventory Price" := 0;
                    "Inventory Amount" := (Quantity * "Inventory Price");
                    //Siak Hui - 09052011 (Invntory Confirmation Date = Collection Date)
                    //      "Inventory Confirmation Date" := 0D;   //Not in use
                    "Inventory Confirmation Date" := TODAY;
                    g_ItemNo_Len := STRLEN(rec_Item."No.");
                    "Agent Internal Key" := PADSTR(rec_Item."No.", g_ItemNo_Len);
                    //Siak Hui - END
                    Comment := '';                      //Not in use
                    Preliminaries := '';

                    //CS101 Begin
                    RecPurchasePrice.RESET();
                    RecPurchasePrice.SETCURRENTKEY("Starting Date");
                    RecPurchasePrice.ASCENDING(FALSE);
                    RecPurchasePrice.SetRange("Price Type", RecPurchasePrice."Price Type"::Purchase);
                    RecPurchasePrice.SetRange(Status, RecPurchasePrice.Status::Active);
                    RecPurchasePrice.SETRANGE("Asset No.", rec_Item."No.");
                    RecPurchasePrice.SETFILTER("Starting Date", '<=%1', TODAY);
                    IF RecPurchasePrice.FINDFIRST() THEN BEGIN
                        rec_MessageCollection."PC. Currency Code" := RecPurchasePrice."PC. Currency Code";
                        rec_MessageCollection."PC. Unit Cost" := RecPurchasePrice."PC. Direct Unit Cost";
                    END;
                    "PC. Inventory Amount" := Quantity * "PC. Unit Cost";
                    //CS101 End

                    "Message Status" := "Message Status"::Ready;
                    "Source Document No." := 'ITEM';
                    "Source Document Line No." := 0;
                    "Collected By" := USERID;
                    "Collected On" := TODAY;
                    INSERT;
                    g_Daily := g_Daily + 1;

                    DataExist := TRUE;
                    //Collect_ControlMaster(4,Quantity,"Inventory Amount"); //CS101

                    //>>
                    //sh 20110428 - START
                    rec_Item."Message Collected On" := TODAY;
                    rec_Item."Message Collected By" := USERID;
                    "Agent Internal Key" := '';                           //Not in used
                    rec_Item.MODIFY;
                    //sh 20110428 - END

                    //CS101 Begin
                    IF (NOT GRec_GLSetup."Exclude Zero Balance (JD)") OR (Quantity <> 0) THEN BEGIN
                        IF (GRec_GLSetup."Get Purch. Price (JD)") AND ("PC. Currency Code" <> '') AND ("PC. Unit Cost" > 0) THEN BEGIN
                            Collect_ControlMaster(4, Quantity, "PC. Inventory Amount");
                        END ELSE BEGIN
                            Collect_ControlMaster(4, Quantity, "Inventory Amount");
                        END;
                    END;
                    //CS101 End
                END;
            UNTIL rec_Item.NEXT = 0;

        EXIT(DataExist);
    end;

    procedure CollectData_JJ() DataExist: Boolean
    var
        recMsgCollection: Record "Message Collection";
    begin
        //
        DataExist := FALSE;
        rec_PurchRcptHdr.RESET;
        IF g_optRetrieveType = g_optRetrieveType::Daily THEN
            rec_PurchRcptHdr.SETFILTER("Posting Date", '..%1', dt_ByDate)
        ELSE IF g_optRetrieveType = g_optRetrieveType::Monthly THEN
            rec_PurchRcptHdr.SETRANGE("Posting Date", g_datStartDate, g_datEndDate);
        //rec_PurchRcptHdr.SETRANGE("Posting Date",g_datStartDate,dt_ByDate);

        /*No need condition can be collect as many time as possible
        rec_PurchRcptHdr.SETFILTER("Message Status(Incoming)",'=%1|%2',
              rec_PurchRcptHdr."Message Status(Incoming)"::"Ready to Collect",
        //sh start
              rec_PurchRcptHdr."Message Status(Incoming)"::Sent);
        //sh End
        */

        rec_PurchRcptHdr.SETFILTER("Item Supplier Source", '=%1', rec_PurchRcptHdr."Item Supplier Source"::Renesas);

        //sh rec_PurchRcptHdr.SETRANGE("Message Collected By(Incoming)",'');
        //sh rec_PurchRcptHdr.SETRANGE("Message Collected On(Incoming)",0D);

        rec_PurchRcptHdr.SETFILTER("Message Collected On(Incoming)", '<>%1', TODAY);

        IF rec_PurchRcptHdr.FINDSET THEN
            REPEAT
                rec_PurchRcptLine.RESET;
                rec_PurchRcptLine.SETRANGE("Document No.", rec_PurchRcptHdr."No.");
                rec_PurchRcptLine.SETFILTER(Type, '=%1', rec_PurchRcptLine.Type::Item);
                rec_PurchRcptLine.SETFILTER("No.", '<>%1', '');
                //  rec_PurchRcptLine.SETFILTER(Quantity,'<>%1',0);
                rec_PurchRcptLine.SETFILTER(Correction, '<>%1', TRUE);
                rec_PurchRcptLine.SETFILTER("Item Supplier Source", '=%1', rec_PurchRcptLine."Item Supplier Source"::Renesas);
                //Siak Hui 20110426
                rec_PurchRcptLine.SETFILTER("Message Status", '=%1', rec_PurchRcptLine."Message Status"::"Ready to Collect");
                //Siak Hui 20110426 - END
                IF rec_PurchRcptLine.FINDSET THEN
                    REPEAT
                        //Siak 20140807
                        s_CollectPSI := TRUE;
                        //Siak End
                        window.UPDATE(1, CONST_JJ);
                        window.UPDATE(2, rec_PurchRcptLine."Document No.");
                        window.UPDATE(3, rec_PurchRcptLine."No.");
                        WITH rec_MessageCollection DO BEGIN
                            INIT;
                            "Entry No." := Get_LastEntryNo(0) + 1;
                            "File ID" := CONST_JJ;
                            "Department Gr Code" := '';                 //Not in use
                            "Warehouse Code" := '';                 //Not in use
                            "SCM Customer Code" := Get_SCMCustCode(rec_PurchRcptLine."No.");
                            ;
                            "End User Code" := '';                      //Not in use
                            "Purpose Code" := '';                       //Not in use
                            "Supplier Code" := '';                      //Not in use
                                                                        //sh 26032011 Start
                                                                        //To retrieve Parts No. from Item Master to ensure it is latest
                                                                        //      "Parts Number" := rec_PurchRcptLine."Parts No.";
                            "Parts Number" := Get_PartsNo(rec_PurchRcptLine."No.");
                            //sh 26032011 End
                            //sh 21112011 Start
                            "Item Description" := Get_ItemDes(rec_PurchRcptLine."No.");
                            //sh 21112011 End
                            "Item No." := rec_PurchRcptLine."No.";
                            "CO No" := rec_PurchRcptLine."CO No.";

                            //CS017 Begin
                            recMsgCollection.RESET;
                            recMsgCollection.SETRANGE(recMsgCollection."File ID", 'JJ');
                            recMsgCollection.SETRANGE(recMsgCollection."Collected On", g_datStartDate2, TODAY);
                            recMsgCollection.SETRANGE(recMsgCollection."CO No", rec_PurchRcptLine."CO No.");
                            recMsgCollection.SETCURRENTKEY("Partial Delivery");
                            recMsgCollection.SETASCENDING("Partial Delivery", FALSE);
                            IF recMsgCollection.FINDFIRST THEN
                                "Partial Delivery" := INCSTR(recMsgCollection."Partial Delivery")
                            ELSE
                                "Partial Delivery" := '001';
                            //"Partial Delivery" := PADSTR('',3 - STRLEN(FORMAT(rec_PurchRcptLine."Receipt Seq. No.")),'0')
                            //                      + FORMAT(rec_PurchRcptLine."Receipt Seq. No."); //required to get based on Recipt
                            //CS017 End

                            "Pos/Neg Class" := CONST_Class;
                            Quantity := rec_PurchRcptLine.Quantity;
                            //
                            //sh 20110426 - START
                            "Update Date" := rec_PurchRcptLine."Update Date";
                            "Update Time" := rec_PurchRcptLine."Update Time";
                            //sh    "Agent Internal Key" := '';                           //Not in used
                            g_DocNo_Len := STRLEN(rec_PurchRcptLine."Document No.");
                            g_ItemNo_Len := STRLEN(rec_PurchRcptLine."No.");
                            "Agent Internal Key" := PADSTR(rec_PurchRcptLine."Document No.", g_DocNo_Len) + ' / '
                                                  + PADSTR(rec_PurchRcptLine."No.", g_ItemNo_Len);
                            //sh 20110426 - END
                            //
                            "Currency Code" := Get_CurrCode_BC(rec_PurchRcptHdr."Currency Code");
                            //EVALUATE("Purchase Price",FORMAT(rec_PurchRcptLine."Unit Cost",0,'<Precision,3><Standard Format,1>'));
                            EVALUATE("Purchase Price", FORMAT(rec_PurchRcptLine."Unit Cost", 0, '<Precision,4><Standard Format,1>'));
                            "Purchase Amount" := (rec_PurchRcptLine.Quantity * "Purchase Price");
                            //Siak Hui - Start
                            //     IF rec_PurchRcptHdr."Save Posting Date" <> 0D THEN BEGIN
                            //        "Purchase Day" := rec_PurchRcptHdr."Save Posting Date";
                            //     END ELSE BEGIN
                            //        "Purchase Day" := rec_PurchRcptHdr."Posting Date";
                            //     END;
                            //Siak Hui - END
                            //Siak Hui - Start
                            IF rec_PurchRcptLine."Save Posting Date" <> 0D THEN BEGIN
                                "Purchase Day" := rec_PurchRcptLine."Save Posting Date";
                            END ELSE BEGIN
                                "Purchase Day" := rec_PurchRcptHdr."Posting Date";
                            END;
                            "Demand Date" := rec_PurchRcptLine."Expected Receipt Date";
                            //Siak Hui - END
                            Preliminaries := '';
                            "Message Status" := "Message Status"::Ready;
                            "Source Document No." := rec_PurchRcptLine."Document No.";
                            "Source Document Line No." := rec_PurchRcptLine."Line No.";
                            "Collected By" := USERID;
                            "Collected On" := TODAY;
                            //sh 20110426
                            rec_PurchRcptLine."Message Status" := rec_PurchRcptLine."Message Status"::Collected;
                            rec_PurchRcptLine."Receipt Collection Date" := TODAY;
                            rec_PurchRcptLine.MODIFY;
                            //sh 20110426 -
                            IF rec_PurchRcptLine.Quantity = 0 THEN BEGIN
                                IF rec_PurchRcptLine.Insertion THEN BEGIN
                                    INSERT;
                                    g_Monthly := g_Monthly + 1;
                                    DataExist := TRUE;
                                    Collect_ControlMaster(5, Quantity, "Purchase Amount");
                                END;
                            END;
                            IF rec_PurchRcptLine.Quantity <> 0 THEN BEGIN
                                INSERT;
                                g_Monthly := g_Monthly + 1;
                                DataExist := TRUE;
                                Collect_ControlMaster(5, Quantity, "Purchase Amount");
                            END;

                            //      INSERT;
                            //      g_Monthly := g_Monthly + 1;
                            //      DataExist := TRUE;
                            //      Collect_ControlMaster(5,Quantity,"Purchase Amount");
                        END;
                    UNTIL rec_PurchRcptLine.NEXT = 0;

                //>>
                //  cdu_PurchPost.Update_PurchRcptHdr(rec_PurchRcptHdr."No.",TRUE);
                IF rec_PurchRcptLine.Quantity = 0 THEN BEGIN
                    IF rec_PurchRcptLine.Insertion THEN BEGIN
                        //cdu_PurchPost.Update_PurchRcptHdr(rec_PurchRcptHdr."No.", TRUE); // Changed during BC Upgrade.
                        Update_PurchRcptHdr(rec_PurchRcptHdr."No.", TRUE);
                    END ELSE BEGIN
                    END;
                END;
                IF rec_PurchRcptLine.Quantity <> 0 THEN BEGIN
                    //cdu_PurchPost.Update_PurchRcptHdr(rec_PurchRcptHdr."No.", TRUE); // Changed during BC Upgrade.
                    Update_PurchRcptHdr(rec_PurchRcptHdr."No.", TRUE);
                END;

            //<<

            UNTIL rec_PurchRcptHdr.NEXT = 0;

        EXIT(DataExist);

    end;

    procedure Collect_ControlMaster(pInt_Array: Integer; pdec_AmtQty: Decimal; pdec_AmtPrice: Decimal)
    begin
        int_RecordNumber[pInt_Array] := int_RecordNumber[pInt_Array] + 1;
        cod_PosNegClass_Quantity[pInt_Array] := '+';
        dec_AmountQuantity[pInt_Array] := dec_AmountQuantity[pInt_Array] + pdec_AmtQty;
        cod_PosNegClass_Price[pInt_Array] := '+';
        dec_AmountPrice[pInt_Array] := dec_AmountPrice[pInt_Array] + pdec_AmtPrice;
        IF g_optRetrieveType = g_optRetrieveType::Daily THEN
            dt_StaticsDate[pInt_Array] := dt_ByDate
        ELSE IF g_optRetrieveType = g_optRetrieveType::Monthly THEN
            dt_StaticsDate[pInt_Array] := g_datEndDate;
        dt_OrderBacklogDate[pInt_Array] := 0D;
        txt_Preliminaries[pInt_Array] := txt_Preliminaries[pInt_Array] + rec_MessageCollection.Preliminaries;
    end;

    procedure CollectData_JZ(pMsg_ID: Code[2]; pint_Array: Integer)
    begin
        //
        WITH rec_MsgControl DO BEGIN
            RESET;
            SETRANGE("File ID", CONST_JZ);
            SETRANGE("Detail File ID", pMsg_ID);
            SETRANGE("Message Status", "Message Status"::Ready);
            IF FINDSET THEN BEGIN
                "Record Number" := "Record Number" + int_RecordNumber[pint_Array];
                "Amount Quantity" := "Amount Quantity" + dec_AmountQuantity[pint_Array];
                "Amount Price" := "Amount Price" + dec_AmountPrice[pint_Array];
                MODIFY;
            END
            ELSE BEGIN
                INIT;
                "Entry No." := Get_LastEntryNo(1) + 1;
                "File ID" := CONST_JZ;
                "Detail File ID" := pMsg_ID;
                "Record Number" := int_RecordNumber[pint_Array];
                "Pos/Neg Class (Quantity)" := cod_PosNegClass_Quantity[pint_Array];
                "Amount Quantity" := dec_AmountQuantity[pint_Array];
                "Pos/Neg Class (Price)" := cod_PosNegClass_Price[pint_Array];
                "Amount Price" := dec_AmountPrice[pint_Array];
                "Statics Date" := dt_StaticsDate[pint_Array];
                "Order Backlog Date" := dt_OrderBacklogDate[pint_Array];
                Preliminaries := txt_Preliminaries[pint_Array];
                "Message Status" := "Message Status"::Ready;
                "Collected By" := USERID;
                "Collected On" := TODAY;
                INSERT;
            END;
        END;
    end;

    procedure Get_LastEntryNo(pint_Option: Integer) LastEntryNo: Integer
    var
        rec_MsgCollection: Record "Message Collection";
        rec_MsgCtrl: Record "Message Control";
    begin
        IF pint_Option = 0 THEN BEGIN
            rec_MsgCollection.RESET;
            rec_MsgCollection.SETRANGE("Entry No.");
            IF rec_MsgCollection.FINDLAST THEN
                LastEntryNo := rec_MsgCollection."Entry No.";
            EXIT(LastEntryNo);
        END;

        IF pint_Option = 1 THEN BEGIN
            rec_MsgCtrl.RESET;
            rec_MsgCtrl.SETRANGE("Entry No.");
            IF rec_MsgCtrl.FINDLAST THEN
                LastEntryNo := rec_MsgCtrl."Entry No.";
            EXIT(LastEntryNo);
        END;
    end;

    procedure Get_CurrCode_BC(pcod_Curr: Code[10]) CurrCode: Code[10]
    var
    begin
        IF pcod_Curr = '' THEN
            CurrCode := GRec_GLSetup."LCY Code"
        ELSE
            CurrCode := pcod_Curr;
    end;

    procedure Get_CurrCode(pcod_Curr: Code[10]) CurrCode: Code[10]
    var
        rec_CompInfo: Record "Company Information";
    begin
        //CS109 Begin
        rec_CompInfo.GET();

        CASE rec_CompInfo."Country/Region Code" OF
            'R.P.CHINA':
                BEGIN
                    IF pcod_Curr = '' THEN
                        CurrCode := 'CNY'
                    ELSE
                        CurrCode := pcod_Curr;
                END;
            'HK':
                BEGIN
                    IF pcod_Curr = '' THEN
                        CurrCode := GRec_GLSetup."LCY Code"
                    ELSE
                        CurrCode := pcod_Curr;
                END;
            ELSE BEGIN
                CurrCode := GRec_GLSetup."LCY Code";
            END;
        END;

        IF pcod_Curr = '' THEN
            CurrCode := GRec_GLSetup."LCY Code"
        ELSE
            CurrCode := pcod_Curr;
    end;

    procedure Get_SCMCustCode(pcod_ItemNo: Code[20]) SCMCustCode: Code[20]
    begin

        //Siak 06022012
        //IF rec_Item.GET(pcod_ItemNo) THEN BEGIN
        //   IF rec_Cust.GET(rec_Item."Customer No.") THEN SCMCustCode := rec_Cust."Vendor Cust. Code";
        //END;

        IF rec_Item.GET(pcod_ItemNo) THEN BEGIN
            IF rec_Cust.GET(rec_Item."OEM No.") THEN BEGIN
                SCMCustCode := rec_Cust."Vendor Cust. Code";
            END ELSE BEGIN
                IF rec_Cust.GET(rec_Item."Customer No.") THEN BEGIN
                    SCMCustCode := rec_Cust."Vendor Cust. Code";
                END;
            END;
        END;
        EXIT(SCMCustCode);
    end;

    procedure CollectData_JZ_Blank(pMsg_ID_Blank: Code[2]; pint_Array_Blank: Integer)
    begin
        //
        WITH rec_MsgControl DO BEGIN
            RESET;
            SETRANGE("File ID", CONST_JZ);
            SETRANGE("Detail File ID", pMsg_ID_Blank);
            SETRANGE("Message Status", "Message Status"::Ready);
            IF FINDSET THEN BEGIN
                //     MESSAGE(MSG_002,pMsg_ID_Blank);
            END
            ELSE BEGIN
                //      MESSAGE(MSG_003,pMsg_ID_Blank);
                INIT;
                "Entry No." := Get_LastEntryNo(1) + 1;
                "File ID" := CONST_JZ;
                "Detail File ID" := pMsg_ID_Blank;
                "Record Number" := 0;
                "Pos/Neg Class (Quantity)" := '+';
                "Amount Quantity" := 0;
                "Pos/Neg Class (Price)" := '+';
                "Amount Price" := 0;
                "Statics Date" := 0D;
                "Order Backlog Date" := 0D;
                Preliminaries := '';
                "Message Status" := "Message Status"::Ready;
                "Collected By" := USERID;
                //sh    "Collected On" := TODAY;
                "Collected On" := dt_ByDate;
                INSERT;
            END;
        END;
    end;

    procedure Get_PartsNo(p_ItemNo: Code[20]) ItemPartsNo: Code[40]
    begin
        IF rec_Item.GET(p_ItemNo) THEN BEGIN
            ItemPartsNo := rec_Item."Parts No.";
        END;
        EXIT(ItemPartsNo);
    end;

    procedure Get_AdvShptQty("p_ItemNo.": Code[10]; "p_SONo.": Code[10]; "p_DocLineNo.": Integer; p_PostingDate: Date) rv_AdvShpQty: Decimal
    begin

        dec_AdvShpQty := 0;
        rec_SalesShipmentLine.SETFILTER("Order No.", "p_SONo.");
        rec_SalesShipmentLine.SETFILTER("No.", '=%1', "p_ItemNo.");
        //rec_SalesShipmentLine.SETFILTER("Line No.",'=%1',"p_DocLineNo.");
        //rec_SalesShipmentLine.SETFILTER("Posting Date",'>%1',p_PostingDate);


        IF NOT rec_SalesShipmentLine.FIND('-') THEN BEGIN
            //  MESSAGE('No Advance Shipment Data to Process');
            EXIT;
        END;

        //REPEAT
        //IF  rec_SalesShipmentLine."Posting Date" > p_PostingDate THEN BEGIN
        //    MESSAGE(MSG_004, "p_ItemNo.", rec_SalesShipmentLine.Quantity);
        //    rv_AdvShpQty := rv_AdvShpQty + rec_SalesShipmentLine.Quantity;
        //    dec_AdvShpQty := dec_AdvShpQty + rec_SalesShipmentLine.Quantity;
        //END ELSE BEGIN
        //  MESSAGE('There is No Advance Shipment Data to Process');
        //  rv_AdvShpQty := 0;
        //END;
        //UNTIL rec_SalesShipmentLine.NEXT = 0;

        REPEAT
            IF rec_SalesShipmentLine."Post Shipment Collect Flag" = 0 THEN BEGIN
                IF rec_SalesShipmentLine."Posting Date" > p_PostingDate THEN BEGIN
                    rv_AdvShpQty := rv_AdvShpQty + rec_SalesShipmentLine.Quantity;
                    dec_AdvShpQty := dec_AdvShpQty + rec_SalesShipmentLine.Quantity;
                    rec_SalesShipmentLine."Post Shipment Collect Flag" := 1;
                    rec_SalesShipmentLine.MODIFY;
                END ELSE BEGIN
                END;
            END;
        UNTIL rec_SalesShipmentLine.NEXT = 0;

        EXIT(rv_AdvShpQty);
    end;

    procedure Get_ItemDes(p_ItemNumber: Code[20]) ItemDes: Text[40]
    begin
        IF rec_Item.GET(p_ItemNumber) THEN BEGIN
            ItemDes := rec_Item.Description;
        END;
        EXIT(ItemDes);
    end;

    procedure Update_ShipmentHdr(pcod_No: Code[20]; pbln_Collect: Boolean)
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        IF SalesShptHeader.GET(pcod_No) THEN BEGIN
            IF pbln_Collect THEN BEGIN
                SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::Collected;
                SalesShptHeader."Message Collected By(Shipment)" := USERID;
                //      SalesShptHeader."Message Collected On(Shipment)" := TODAY;
                IF SalesShptHeader."Message Collected On(Shipment)" = 0D THEN //Re-Collect
                    SalesShptHeader."Message Collected On(Shipment)" := TODAY;
                SalesShptHeader.MODIFY;
            END
            ELSE BEGIN
                IF SalesShptHeader."Message Status(Shipment)" = SalesShptHeader."Message Status(Shipment)"::Collected THEN BEGIN
                    SalesShptHeader.VALIDATE("Message Status(Shipment)", SalesShptHeader."Message Status(Shipment)"::Sent);
                    SalesShptHeader.MODIFY;
                END;
            END;
        END
    end;

    procedure Update_PurchRcptHdr(pcod_No: Code[20]; pbln_Collect: Boolean)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        IF PurchRcptHeader.GET(pcod_No) THEN BEGIN
            IF pbln_Collect THEN BEGIN
                PurchRcptHeader."Message Status(Incoming)" := PurchRcptHeader."Message Status(Incoming)"::Collected;
                PurchRcptHeader."Message Collected By(Incoming)" := USERID;
                //PurchRcptHeader."Message Collected On(Incoming)" := TODAY;
                IF PurchRcptHeader."Message Collected On(Incoming)" = 0D THEN    //Re-Collect
                    PurchRcptHeader."Message Collected On(Incoming)" := TODAY;
                PurchRcptHeader.MODIFY;
            END
            ELSE BEGIN
                IF PurchRcptHeader."Message Status(Incoming)" = PurchRcptHeader."Message Status(Incoming)"::Collected THEN BEGIN
                    PurchRcptHeader.VALIDATE("Message Status(Incoming)", PurchRcptHeader."Message Status(Incoming)"::Sent);
                    PurchRcptHeader.MODIFY;
                END;
            END;
        END;
    end;

}

