codeunit 50200 "PSI Prepare Message"
{

    // BC Update Info: update from Send Message Report and Messaging Codeunit, merged onscreen and Job queue objects.

    trigger OnRun()
    begin
    end;

    var
        cod_MessageIDs: Code[50];
        GFle_File: File;
        GTxt_FileName: Text[250];
        GRec_GLSetup: Record "General Ledger Setup";
        GTxt_Text01: Text[1024];
        Gtxt_Text02: Text[1024];
        GTxt_Text03: Text[1024];
        Gtxt_Text04: Text[1024];
        window: Dialog;
        rec_MsgSetup: Record "Message Setup";
        rec_MsgCollection: Record "Message Collection";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        GRec_SalesHdr: Record "Sales Header";
        rec_MsgControl: Record "Message Control";
        gbln_CobmineCtrlMaster: Boolean;
        grec_SalesShipmentHdr: Record "Sales Shipment Header";
        grec_PurchRcptHdr: Record "Purch. Rcpt. Header";
        cdu_SalesPost: Codeunit "Sales-Post";
        cdu_PurchPost: Codeunit "Purch.-Post";
        te: Decimal;
        GRec_PurchHdr: Record "Purchase Header";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        Grec_SalesLine: Record "Sales Line";
        Grec_ShipmentLine: Record "Sales Shipment Line";
        Grec_ReceiptLine: Record "Purch. Rcpt. Line";
        GFle_File_1: File;
        GTxt_FileName_1: Text[250];
        TEXT_001: Label 'Processing Message(s)...\\Message ID. #1#########\\Item No.   #2#########';
        CONST_JA: Label 'JA';
        CONST_JB: Label 'JB';
        CONST_JC: Label 'JC';
        CONST_JD: Label 'JD';
        CONST_JJ: Label 'JJ';
        CONST_JZ: Label 'JZ';
        MSG_001: Label '''%1'' has been sent successfully!';

    procedure Process_Message(bln_CobmineCtrlMaster: Boolean)
    var
    //XMLPortSendMsgBuffer: XMLport "50000";
    begin

        GRec_GLSetup.Get();
        PreCheck();

        gbln_CobmineCtrlMaster := bln_CobmineCtrlMaster;

        //>>Create Files
        rec_MsgSetup.RESET;
        rec_MsgSetup.SETCURRENTKEY(ID);
        rec_MsgSetup.SETFILTER(ID, cod_MessageIDs);
        IF rec_MsgSetup.FINDSET THEN BEGIN
            IF Get_Data(FORMAT(cod_MessageIDs), TRUE) THEN BEGIN

                //CreateFile(CONVERTSTR(cod_MessageIDs,'|','_'));
                DeleteDataInBuffer;

                REPEAT
                    CASE rec_MsgSetup.ID OF
                        rec_MsgSetup.ID::JA:
                            IF Get_Data(CONST_JA, FALSE) THEN; //MESSAGE(MSG_001, CONST_JA + ' ' + rec_MsgSetup.Description);
                        rec_MsgSetup.ID::JB:
                            IF Get_Data(CONST_JB, FALSE) THEN; //MESSAGE(MSG_001, CONST_JB + ' ' + rec_MsgSetup.Description);
                        rec_MsgSetup.ID::JC:
                            IF Get_Data(CONST_JC, FALSE) THEN; //MESSAGE(MSG_001, CONST_JC + ' ' + rec_MsgSetup.Description);
                        rec_MsgSetup.ID::JD:
                            IF Get_Data(CONST_JD, FALSE) THEN; //MESSAGE(MSG_001, CONST_JD + ' ' + rec_MsgSetup.Description);
                        rec_MsgSetup.ID::JJ:
                            IF Get_Data(CONST_JJ, FALSE) THEN; //MESSAGE(MSG_001, CONST_JJ + ' ' + rec_MsgSetup.Description);
                    END;
                UNTIL rec_MsgSetup.NEXT = 0;

                //IF NOT gbln_CobmineCtrlMaster THEN
                //  BEGIN
                //   CloseFile();
                //   Process_JZData();
                //  END
                //ELSE
                //  BEGIN
                //   Process_JZData();
                //   CloseFile();
                //  END;

                Process_JZData();
                //CreateFolder(CONVERTSTR(cod_MessageIDs,'|','_'));
                //CLEAR(XMLPortSendMsgBuffer);
                //XMLPortSendMsgBuffer.FILENAME(GTxt_FileName);
                //XMLPortSendMsgBuffer.RUN;
                //CLEAR(XMLPortSendMsgBuffer);

            END;
        END;
        //<<
    end;

    local procedure PreCheck()
    var
        bln_MessageID: array[5] of Boolean;
        cod_MsgIDs: code[50];
    begin

        IF GRec_GLSetup."Monthly PSI Data Collection" = '2' THEN BEGIN
            ERROR('One or more sale prices are negative in JB');
        END;
        IF GRec_GLSetup."Daily PSI Data Collection" = '2' THEN BEGIN
            ERROR('One or more sale prices are negative in JC');
        END;

        CLEAR(bln_MessageID);
        rec_MsgSetup.RESET;
        rec_MsgSetup.SETCURRENTKEY(ID);
        rec_MsgSetup.SETFILTER(ID, '<>%1', rec_MsgSetup.ID::" ");
        //rec_MsgSetup.SETFILTER(Cycle,'=%1',rec_MsgSetup.Cycle::Daily);
        //Siak Hui for Watanabe San 10112011
        rec_MsgSetup.SETFILTER(Cycle, '=%1|%2', rec_MsgSetup.Cycle::Daily, rec_MsgSetup.Cycle::Monthly);
        IF rec_MsgSetup.FINDSET THEN
            REPEAT
                CASE rec_MsgSetup.ID OF
                    rec_MsgSetup.ID::JA:
                        bln_MessageID[1] := (rec_MsgSetup.Cycle = rec_MsgSetup.Cycle::Monthly);
                    rec_MsgSetup.ID::JB:
                        bln_MessageID[2] := (rec_MsgSetup.Cycle = rec_MsgSetup.Cycle::Monthly);
                    rec_MsgSetup.ID::JC:
                        bln_MessageID[3] := (rec_MsgSetup.Cycle = rec_MsgSetup.Cycle::Daily);
                    rec_MsgSetup.ID::JD:
                        bln_MessageID[4] := (rec_MsgSetup.Cycle = rec_MsgSetup.Cycle::Daily);
                    rec_MsgSetup.ID::JJ:
                        bln_MessageID[5] := (rec_MsgSetup.Cycle = rec_MsgSetup.Cycle::Monthly);
                END;
            UNTIL rec_MsgSetup.NEXT = 0;

        CLEAR(cod_MsgIDs);
        IF bln_MessageID[1] THEN cod_MsgIDs := cod_MsgIDs + '|' + CONST_JA;
        IF bln_MessageID[2] THEN cod_MsgIDs := cod_MsgIDs + '|' + CONST_JB;
        IF bln_MessageID[3] THEN cod_MsgIDs := cod_MsgIDs + '|' + CONST_JC;
        IF bln_MessageID[4] THEN cod_MsgIDs := cod_MsgIDs + '|' + CONST_JD;
        IF bln_MessageID[5] THEN cod_MsgIDs := cod_MsgIDs + '|' + CONST_JJ;

        IF cod_MsgIDs = '' THEN ERROR('There are no Messages selected to process!');

        cod_MessageIDs := COPYSTR(cod_MsgIDs, 2);
    end;

    procedure Get_Data(MsgID: Code[50]; Check_DataOnly: Boolean) DataFound: Boolean
    begin

        if GuiAllowed then
            window.OPEN(TEXT_001);

        DataFound := FALSE;

        WITH rec_MsgCollection DO BEGIN
            RESET;
            // SETFILTER("File ID",MsgID);
            // SETFILTER("Message Status",'=%1',"Message Status"::Ready);
            //15082012 : Ms Angela reported Sending very slow - Insert Collection Date Filfer (Testing Only)
            rec_MsgCollection.SETRANGE("Collected On", TODAY, TODAY);
            SETFILTER("Collected On", '=%1', TODAY);
            SETFILTER("File ID", MsgID);
            SETFILTER("Message Status", '=%1', "Message Status"::Ready);

            IF Check_DataOnly THEN BEGIN
                DataFound := FINDSET;
                //window.CLOSE;
                EXIT(DataFound);
            END;

            IF (FINDSET) AND NOT (Check_DataOnly) THEN
                REPEAT

                    DataFound := TRUE;
                    //window.UPDATE(1,"File ID");

                    CASE MsgID OF
                        CONST_JA:
                            BEGIN
                                Process_JAData();
                                //Siak Hui 20110428
                                //            IF Grec_SalesLine.GET(Grec_SalesLine."Document Type"::Order,"Source Document No.","Source Document Line No.") THEN
                                //               BEGIN
                                //                    Grec_SalesLine.VALIDATE("Message Status",Grec_SalesLine."Message Status"::Sent);
                                //                    Grec_SalesLine.MODIFY;
                                //            END;

                                //Siak Hui 20110428 - END
                                //           IF GRec_SalesHdr.GET(GRec_SalesHdr."Document Type"::Order,"Source Document No.") THEN
                                //               BEGIN
                                //                   IF Grec_SalesLine.Quantity <> 0 THEN BEGIN
                                //                      ReleaseSalesDoc.PerformManualReopen(GRec_SalesHdr);
                                //                      GRec_SalesHdr."Message Status(Booking)" := GRec_SalesHdr."Message Status(Booking)"::Sent;
                                //                      GRec_SalesHdr.MODIFY;
                                //                      ReleaseSalesDoc.PerformManualRelease(GRec_SalesHdr);
                                //                   END ELSE BEGIN
                                //                      GRec_SalesHdr."Message Status(Booking)" := GRec_SalesHdr."Message Status(Booking)"::Sent;
                                //                      GRec_SalesHdr.MODIFY;
                                //                   END;
                                //              END;
                            END;
                        CONST_JB:
                            BEGIN
                                Process_JBData();
                                //Siak Hui 20110428
                                //            IF Grec_ShipmentLine.GET("Source Document No.","Source Document Line No.") THEN
                                //               BEGIN
                                //                    Grec_ShipmentLine.VALIDATE("Message Status",Grec_ShipmentLine."Message Status"::Sent);
                                //                    Grec_ShipmentLine.MODIFY;
                                //               END;
                                //Siak Hui 20110428 - END
                                //            cdu_SalesPost.Update_ShipmentHdr("Source Document No.",FALSE);
                            END;

                        CONST_JC:
                            BEGIN
                                Process_JCData();
                                //
                                //            IF GRec_SalesHdr.GET(GRec_SalesHdr."Document Type"::Order,"Source Document No.") THEN
                                //              BEGIN
                                //                IF Grec_SalesLine.Quantity <> 0 THEN BEGIN
                                //                   ReleaseSalesDoc.PerformManualReopen(GRec_SalesHdr);
                                //                   ReleaseSalesDoc.PerformManualReopen(GRec_SalesHdr);
                                //                   GRec_SalesHdr.VALIDATE("Message Status(Backlog)",GRec_SalesHdr."Message Status(Backlog)"::Sent);
                                //                   GRec_SalesHdr.MODIFY;
                                //                   ReleaseSalesDoc.PerformManualRelease(GRec_SalesHdr);
                                //               END ELSE BEGIN
                                //                   GRec_SalesHdr.VALIDATE("Message Status(Backlog)",GRec_SalesHdr."Message Status(Backlog)"::Sent);
                                //                   GRec_SalesHdr.MODIFY;
                                //                END;
                                //           END;
                            END;

                        CONST_JD:
                            Process_JDData();

                        CONST_JJ:
                            BEGIN
                                Process_JJData();
                                //Siak Hui 20110429
                                //            IF Grec_ReceiptLine.GET("Source Document No.","Source Document Line No.") THEN
                                //               BEGIN
                                //                    Grec_ReceiptLine.VALIDATE("Message Status",Grec_ShipmentLine."Message Status"::Sent);
                                //                    Grec_ReceiptLine.MODIFY;
                                //               END;
                                //Siak Hui 20110429 - END

                                //            cdu_PurchPost.Update_PurchRcptHdr("Source Document No.",FALSE);
                            END;
                    END;

                //>> to update info
                /* Move this update to API page during BC upgrade.
                "Message Status" := "Message Status"::Sent;
                "File Sent By" := USERID;
                "File Sent On" := TODAY;
                MODIFY;
                */
                //<<

                UNTIL NEXT = 0
        END;

        if GuiAllowed then
            window.CLOSE;
    end;

    procedure Process_JAData()
    var
        LTxt_F001: Text[2];
        LTxt_F002: Text[8];
        LTxt_F003: Text[20];
        LTxt_F004: Text[10];
        LTxt_F005: Text[40];
        LTxt_F006: Text[8];
        LTxt_F007: Text[8];
        LTxt_F008: Text[1];
        LTxt_F009: Text[11];
        LTxt_F010: Text[1];
        LTxt_F011: Text[2];
        LTxt_F012: Text[8];
        LTxt_F013: Text[6];
        LTxt_F014: Text[40];
        LTxt_F015: Text[35];
    begin

        CLEAR(LTxt_F001);
        CLEAR(LTxt_F002);
        CLEAR(LTxt_F003);
        CLEAR(LTxt_F004);
        CLEAR(LTxt_F005);
        CLEAR(LTxt_F006);
        CLEAR(LTxt_F007);
        CLEAR(LTxt_F008);
        CLEAR(LTxt_F009);
        CLEAR(LTxt_F010);
        CLEAR(LTxt_F011);
        CLEAR(LTxt_F012);
        CLEAR(LTxt_F013);
        //CLEAR(LTxt_F011); CLEAR(LTxt_F012); CLEAR(LTxt_F013); CLEAR(LTxt_F014); CLEAR(LTxt_F015);
        //CLEAR(LTxt_F016); CLEAR(LTxt_F017); CLEAR(LTxt_F018); CLEAR(LTxt_F019);

        //File ID
        LTxt_F001 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."File ID", '=', ','));

        //Department Grp Code
        //LTxt_F002 := STRSUBSTNO('%1',DELCHR(rec_MsgCollection."Department Gr Code",'=',','));
        //IF rec_MsgCollection."Department Gr Code" = '' THEN LTxt_F002 := STRSUBSTNO('%1',' ');

        //End user Code
        //LTxt_F004 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."End User Code",13),'=',','));
        //IF rec_MsgCollection."End User Code" = '' THEN LTxt_F004 := PADSTR('',13);

        //Purpose Code
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Purpose Code",3),'=',','));
        //IF rec_MsgCollection."Purpose Code" = '' THEN LTxt_F005 := PADSTR('',3);

        //Supplier Code
        //LTxt_F006 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Supplier Code",3),'=',','));
        //IF rec_MsgCollection."Supplier Code" = '' THEN LTxt_F006 := PADSTR('',3);

        //Collection Date
        LTxt_F002 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Collected On", FALSE), '=', ','));
        IF rec_MsgCollection."Collected On" = 0D THEN LTxt_F002 := PADSTR('', 8);

        //Order No
        //LTxt_F003 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Order No",20),'=',','));
        //IF rec_MsgCollection."Order No" = '' THEN LTxt_F003 := PADSTR('',20);

        //Booking No
        LTxt_F003 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Booking No.", 20), '=', ','));
        IF rec_MsgCollection."Booking No." = '' THEN LTxt_F003 := PADSTR('', 20);

        //SCM Customer Code
        LTxt_F004 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Customer Code", 10), '=', ','));
        IF rec_MsgCollection."SCM Customer Code" = '' THEN LTxt_F004 := PADSTR('', 10);

        //Parts Number - sh 21112011
        //window.UPDATE(2,rec_MsgCollection."Parts Number");
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Parts Number",40),'=',','));
        //IF rec_MsgCollection."Parts Number" = '' THEN LTxt_F005 := PADSTR('',40);

        //Parts Number - sh 21112011
        //window.UPDATE(2,rec_MsgCollection."Item Description");
        LTxt_F005 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Item Description", 40), '=', ','));
        IF rec_MsgCollection."Item Description" = '' THEN LTxt_F005 := PADSTR('', 40);

        //Order Entry Date
        LTxt_F006 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Order Entry Date", FALSE), '=', ','));
        IF rec_MsgCollection."Order Entry Date" = 0D THEN LTxt_F006 := PADSTR('', 8);

        //Demand Date
        LTxt_F007 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Demand Date", FALSE), '=', ','));
        IF rec_MsgCollection."Demand Date" = 0D THEN LTxt_F007 := PADSTR('', 8);

        // +/- Class
        LTxt_F008 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Pos/Neg Class", '=', ','));

        //Order Quantity
        LTxt_F009 := STRSUBSTNO('%1', DELCHR(FORMAT(rec_MsgCollection.Quantity, 0, '<Integer,11><Filler,0>'), '=', ','));

        // SO Document Category
        LTxt_F010 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."SO Document Category", '=', ','));

        GTxt_Text01 := STRSUBSTNO('%1%2%3%4%5%6%7%8%9%10',
                              LTxt_F001, LTxt_F002, LTxt_F003, LTxt_F004, LTxt_F005, LTxt_F006, LTxt_F007, LTxt_F008, LTxt_F009, LTxt_F010);

        //SCM Process Code
        LTxt_F011 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Process Code", 2), '=', ','));
        IF rec_MsgCollection."SCM Process Code" = '' THEN LTxt_F011 := PADSTR('', 2);

        //Update Date
        IF rec_MsgCollection."Update Date" = 0D THEN
            LTxt_F012 := PADSTR('', 8)
        ELSE
            LTxt_F012 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Update Date", FALSE), '=', ','));

        //Update Time
        IF rec_MsgCollection."Update Time" = 0T THEN
            LTxt_F013 := PADSTR('', 6)
        ELSE
            LTxt_F013 := STRSUBSTNO('%1', DELCHR(TIME2HHMMSS(rec_MsgCollection."Update Time"), '=', ','));

        //Agent Internal Key
        LTxt_F014 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Agent Internal Key", 40), '=', ','));
        IF rec_MsgCollection."Agent Internal Key" = '' THEN LTxt_F014 := PADSTR('', 40);

        //Currency Code
        //LTxt_F013 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Currency Code",3),'=',','));
        //IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F013 := PADSTR('',3);

        //Sales Price
        //LTxt_F014 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Price",0,'<Integer,12><Filler,0>'),'=',','));

        //Sales Amount
        //LTxt_F015 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Amount",0,'<Integer,15><Filler,0>'),'=',','));

        //SOLD TO Customer
        //LTxt_F016 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."SOLDTO Customer",20),'=',','));
        //IF rec_MsgCollection."SOLDTO Customer" = '' THEN LTxt_F016 := PADSTR('',20);

        //SOLD TO Customer2
        //LTxt_F017 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."SOLDTO Customer2",20),'=',','));
        //IF rec_MsgCollection."SOLDTO Customer2" = '' THEN LTxt_F017 := PADSTR('',20);

        //Comment
        //LTxt_F018 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection.Comment,30),'=',','));
        //IF rec_MsgCollection.Comment = '' THEN LTxt_F018 := PADSTR('',30);

        //Preliminaries
        LTxt_F015 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection.Preliminaries, 35), '=', ','));
        IF rec_MsgCollection.Preliminaries = '' THEN LTxt_F015 := PADSTR('', 35);

        Gtxt_Text02 := STRSUBSTNO('%1%2%3%4%5',
                              LTxt_F011, LTxt_F012, LTxt_F013, LTxt_F014, LTxt_F015);

        //GFle_File.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        //GFle_File_1.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        InsertDataInBuffer(STRSUBSTNO('%1%2', GTxt_Text01, Gtxt_Text02));
    end;

    procedure Process_JBData()
    var
        LTxt_F001: Text[2];
        LTxt_F002: Text[8];
        LTxt_F003: Text[20];
        LTxt_F004A: Text[17];
        LTxt_F004: Text[3];
        LTxt_F005: Text[10];
        LTxt_F006: Text[40];
        LTxt_F007: Text[8];
        LTxt_F008: Text[8];
        LTxt_F009: Text[8];
        LTxt_F010: Text[1];
        LTxt_F011: Text[11];
        LTxt_F012: Text[1];
        LTxt_F013: Text[2];
        LTxt_F014: Text[8];
        LTxt_F015: Text[6];
        LTxt_F016: Text[40];
        LTxt_F017: Text[13];
        LTxt_F018: Text[3];
        LTxt_F019: Text[91];
        SendMsgBuffer: Record "Send Message Buffer";
        NextEntryNo: Integer;
        LTxt_Padstr: Text[50];
    begin

        CLEAR(LTxt_F001);
        CLEAR(LTxt_F002);
        CLEAR(LTxt_F003);
        CLEAR(LTxt_F004);
        CLEAR(LTxt_F005);
        CLEAR(LTxt_F006);
        CLEAR(LTxt_F007);
        CLEAR(LTxt_F008);
        CLEAR(LTxt_F009);
        CLEAR(LTxt_F010);
        CLEAR(LTxt_F011);
        CLEAR(LTxt_F012);
        CLEAR(LTxt_F013);
        CLEAR(LTxt_F014);
        CLEAR(LTxt_F015);
        //CLEAR(LTxt_F016); CLEAR(LTxt_F017);
        CLEAR(LTxt_F016);
        CLEAR(LTxt_F017);
        CLEAR(LTxt_F018);
        CLEAR(LTxt_F019);
        //CLEAR(LTxt_F016); CLEAR(LTxt_F017); CLEAR(LTxt_F018); CLEAR(LTxt_F019); CLEAR(LTxt_F020); CLEAR(LTxt_F021);

        //File ID
        LTxt_F001 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."File ID", '=', ','));

        //Collection Date
        LTxt_F002 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Collected On", FALSE), '=', ','));
        IF rec_MsgCollection."Collected On" = 0D THEN LTxt_F002 := PADSTR('', 8);

        //Order No
        //LTxt_F003 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Order No",20),'=',','));
        //IF rec_MsgCollection."Order No" = '' THEN LTxt_F003 := PADSTR('',20);

        //Booking No
        LTxt_F003 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Booking No.", 20), '=', ','));
        IF rec_MsgCollection."Booking No." = '' THEN LTxt_F003 := PADSTR('', 20);

        //Prefix Seq No.
        LTxt_F004A := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Prefix Seq No.", 17), '=', ','));
        IF rec_MsgCollection."Prefix Seq No." = '' THEN LTxt_F004A := PADSTR('00000000000000000', 17);

        //Sequence Number
        LTxt_F004 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Sequence Number", 3), '=', ','));
        IF rec_MsgCollection."Sequence Number" = '' THEN LTxt_F004 := PADSTR('', 3);

        //SCM Customer Code
        LTxt_F005 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Customer Code", 10), '=', ','));
        //IF rec_MsgCollection."SCM Customer Code" = '' THEN LTxt_F005 := PADSTR('',10);

        //Department Grp Code
        //LTxt_F002 := STRSUBSTNO('%1',DELCHR(rec_MsgCollection."Department Gr Code",'=',','));
        //IF LTxt_F002 = '' THEN LTxt_F002 := STRSUBSTNO('%1',' ');

        //End user Code
        //LTxt_F004 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."End User Code",13),'=',','));
        //IF rec_MsgCollection."End User Code" = '' THEN LTxt_F004 := PADSTR('',13);

        //Purpose Code
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Purpose Code",3),'=',','));
        //IF rec_MsgCollection."Purpose Code" = '' THEN LTxt_F005 := PADSTR('',3);

        //Supplier Code
        //LTxt_F006 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Supplier Code",3),'=',','));
        //IF rec_MsgCollection."Supplier Code" = '' THEN LTxt_F006 := PADSTR('',3);

        //Parts Number - sh 21112011
        //window.UPDATE(2,rec_MsgCollection."Parts Number");
        //LTxt_F006 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Parts Number",40),'=',','));
        //IF rec_MsgCollection."Parts Number" = '' THEN LTxt_F006 := PADSTR('',40);

        //Parts Number - sh 21112011
        //window.UPDATE(2,rec_MsgCollection."Item Description");
        LTxt_F006 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Item Description", 40), '=', ','));
        IF rec_MsgCollection."Item Description" = '' THEN LTxt_F006 := PADSTR('', 40);

        //Order Entry Date
        LTxt_F007 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Order Entry Date", FALSE), '=', ','));
        IF rec_MsgCollection."Order Entry Date" = 0D THEN LTxt_F007 := PADSTR('', 8);

        //Demand Date
        LTxt_F008 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Demand Date", FALSE), '=', ','));
        IF rec_MsgCollection."Demand Date" = 0D THEN LTxt_F008 := PADSTR('', 8);

        //Sales Day
        LTxt_F009 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Sales Day", FALSE), '=', ','));
        IF rec_MsgCollection."Sales Day" = 0D THEN LTxt_F009 := PADSTR('', 8);

        // +/- Class
        LTxt_F010 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Pos/Neg Class", '=', ','));

        GTxt_Text01 := STRSUBSTNO('%1%2%3%4%5%6%7%8%9%10%11',
                       LTxt_F001, LTxt_F002, LTxt_F003, LTxt_F004A, LTxt_F004, LTxt_F005, LTxt_F006, LTxt_F007, LTxt_F008, LTxt_F009, LTxt_F010);

        //Sales Quantity
        LTxt_F011 := STRSUBSTNO('%1', DELCHR(FORMAT(rec_MsgCollection.Quantity, 0, '<Integer,11><Filler,0>'), '=', ','));

        //SO Document Category
        LTxt_F012 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."SO Document Category", '=', ','));

        //SCM Process Code
        LTxt_F013 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Process Code", 2), '=', ','));
        IF rec_MsgCollection."SCM Process Code" = '' THEN LTxt_F013 := PADSTR('', 2);

        //Update Date
        IF rec_MsgCollection."Update Date" = 0D THEN
            LTxt_F014 := PADSTR('', 8)
        ELSE
            LTxt_F014 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Update Date", FALSE), '=', ','));

        //Update Time
        IF rec_MsgCollection."Update Time" = 0T THEN
            LTxt_F015 := PADSTR('', 6)
        ELSE
            LTxt_F015 := STRSUBSTNO('%1', DELCHR(TIME2HHMMSS(rec_MsgCollection."Update Time"), '=', ','));

        //Agent Internal Key
        LTxt_F016 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Agent Internal Key", 40), '=', ','));
        IF rec_MsgCollection."Agent Internal Key" = '' THEN LTxt_F016 := PADSTR('', 40);

        //Now Use Sanjeev Begin 12/03/2020
        //Sales Price
        //LTxt_F017 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Price",0,'<Integer,12><Filler,0>'),'=',','));// by sanjeev

        LTxt_Padstr :=
          PADSTR('', 13 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."Sales Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
        LTxt_F017 := STRSUBSTNO('%1',
            DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."Sales Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');



        //Currency Code
        LTxt_F018 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Currency Code", 3), '=', ','));
        IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F018 := PADSTR('', 3);
        //Now Use Sanjeev END 12/03/2020


        //Currency Code
        //LTxt_F014 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Currency Code",3),'=',','));
        //IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F014 := PADSTR('',3);

        //Sales Price
        //LTxt_F015 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Price",0,'<Integer,12><Filler,0>'),'=',','));

        //Sales Amount
        //LTxt_F016 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Amount",0,'<Integer,15><Filler,0>'),'=',','));

        //SOLD TO Customer
        //LTxt_F017 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."SOLDTO Customer",20),'=',','));
        //IF rec_MsgCollection."SOLDTO Customer" = '' THEN LTxt_F017 := PADSTR('',20);

        //SOLD TO Customer2
        //LTxt_F018 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."SOLDTO Customer2",20),'=',','));
        //IF rec_MsgCollection."SOLDTO Customer2" = '' THEN LTxt_F018 := PADSTR('',20);

        //Comment
        //LTxt_F019 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection.Comment,30),'=',','));
        //IF rec_MsgCollection.Comment = '' THEN LTxt_F019 := PADSTR('',30);

        //Sequence Number
        //LTxt_F020 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Sequence Number",10),'=',','));
        //IF rec_MsgCollection."Sequence Number" = '' THEN LTxt_F020 := PADSTR('',10);

        //Now Use Sanjeev Begin 12/03/2020
        //Premilinaries
        LTxt_F019 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection.Preliminaries, 91), '=', ','));
        IF rec_MsgCollection.Preliminaries = '' THEN LTxt_F019 := PADSTR('', 91);

        Gtxt_Text02 := STRSUBSTNO('%1%2%3%4%5%6%7%8',
                              LTxt_F011, LTxt_F012, LTxt_F013, LTxt_F014, LTxt_F015, LTxt_F016, LTxt_F017, LTxt_F018);

        Gtxt_Text04 := STRSUBSTNO('%1', LTxt_F019);
        //Now Use Sanjeev End 12/03/2020

        //GTxt_Text03 := STRSUBSTNO('%1',LTxt_F021);
        //GFle_File.WRITE(STRSUBSTNO('%1%2%3',GTxt_Text01,Gtxt_Text02,GTxt_Text03));

        //GFle_File.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        //GFle_File_1.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));


        //Now Use Sanjeev BEGIN 12/03/2020
        SendMsgBuffer.INIT;
        SendMsgBuffer."Export Text" := GTxt_Text01 + Gtxt_Text02;
        SendMsgBuffer."Export Text 2" := Gtxt_Text04;
        SendMsgBuffer.INSERT;


        //InsertDataInBuffer(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        //Now Use Sanjeev End 12/03/2020
    end;

    procedure Process_JCData()
    var
        LTxt_F001: Text[2];
        LTxt_F002: Text[8];
        LTxt_F003: Text[20];
        LTxt_F004: Text[10];
        LTxt_F005: Text[40];
        LTxt_F006: Text[8];
        LTxt_F007: Text[8];
        LTxt_F008: Text[1];
        LTxt_F009: Text[11];
        LTxt_F010: Text[8];
        LTxt_F011: Text[1];
        LTxt_F012: Text[1];
        LTxt_F013: Text[2];
        LTxt_F014: Text[8];
        LTxt_F015: Text[6];
        LTxt_F016: Text[40];
        LTxt_F017: Text[13];
        LTxt_F018: Text[3];
        LTxt_F019: Text[10];
        LTxt_Padstr: Text[50];
    begin

        CLEAR(LTxt_F001);
        CLEAR(LTxt_F002);
        CLEAR(LTxt_F003);
        CLEAR(LTxt_F004);
        CLEAR(LTxt_F005);
        CLEAR(LTxt_F006);
        CLEAR(LTxt_F007);
        CLEAR(LTxt_F008);
        CLEAR(LTxt_F009);
        CLEAR(LTxt_F010);
        CLEAR(LTxt_F011);
        CLEAR(LTxt_F012);
        CLEAR(LTxt_F013);
        CLEAR(LTxt_F014);
        CLEAR(LTxt_F015);
        //CLEAR(LTxt_F016); CLEAR(LTxt_F017);
        CLEAR(LTxt_F016);
        CLEAR(LTxt_F017);
        CLEAR(LTxt_F018);
        CLEAR(LTxt_F019);
        //CLEAR(LTxt_F016); CLEAR(LTxt_F017); CLEAR(LTxt_F018); CLEAR(LTxt_F019); CLEAR(LTxt_F020); CLEAR(LTxt_F021);

        //File ID
        LTxt_F001 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."File ID", '=', ','));

        //Collection Date
        LTxt_F002 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Collected On", FALSE), '=', ','));
        IF rec_MsgCollection."Collected On" = 0D THEN LTxt_F002 := PADSTR('', 8);

        //Order No
        //LTxt_F003 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Order No",20),'=',','));
        //IF rec_MsgCollection."Order No" = '' THEN LTxt_F003 := PADSTR('',20);

        //Booking No
        LTxt_F003 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Booking No.", 20), '=', ','));
        IF rec_MsgCollection."Booking No." = '' THEN LTxt_F003 := PADSTR('', 20);

        //Department Grp Code
        //LTxt_F002 := STRSUBSTNO('%1',DELCHR(rec_MsgCollection."Department Gr Code",'=',','));
        //IF LTxt_F002 = '' THEN LTxt_F002 := STRSUBSTNO('%1',' ');

        //SCM Customer Code
        LTxt_F004 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Customer Code", 10), '=', ','));
        //IF rec_MsgCollection."SCM Customer Code" = '' THEN LTxt_F004 := PADSTR('',10);

        //End user Code
        //LTxt_F004 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."End User Code",13),'=',','));
        //IF rec_MsgCollection."End User Code" = '' THEN LTxt_F004 := PADSTR('',13);

        //Purpose Code
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Purpose Code",3),'=',','));
        //IF rec_MsgCollection."Purpose Code" = '' THEN LTxt_F005 := PADSTR('',3);

        //Supplier Code
        //LTxt_F006 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Supplier Code",3),'=',','));
        //IF rec_MsgCollection."Supplier Code" = '' THEN LTxt_F006 := PADSTR('',3);

        //Parts Number - sh 21112011
        //window.UPDATE(2,rec_MsgCollection."Parts Number");
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Parts Number",40),'=',','));
        //IF rec_MsgCollection."Parts Number" = '' THEN LTxt_F005 := PADSTR('',40);

        //Parts Number - sh 21112011
        //window.UPDATE(2,rec_MsgCollection."Item Description");
        LTxt_F005 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Item Description", 40), '=', ','));
        IF rec_MsgCollection."Item Description" = '' THEN LTxt_F005 := PADSTR('', 40);

        //Order Entry Date
        LTxt_F006 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Order Entry Date", FALSE), '=', ','));
        IF rec_MsgCollection."Order Entry Date" = 0D THEN LTxt_F006 := PADSTR('', 8);

        //Demand Date
        LTxt_F007 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Demand Date", FALSE), '=', ','));
        IF rec_MsgCollection."Demand Date" = 0D THEN LTxt_F007 := PADSTR('', 8);

        // +/- Class
        LTxt_F008 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Pos/Neg Class", '=', ','));

        //Backlog Quantity
        LTxt_F009 := STRSUBSTNO('%1', DELCHR(FORMAT(rec_MsgCollection.Quantity, 0, '<Integer,11><Filler,0>'), '=', ','));

        //Sales Amount
        //LTxt_F015 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Amount",0,'<Integer,15><Filler,0>'),'=',','));

        //Backlog Collection Day
        LTxt_F010 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Backlog Collection Day", FALSE), '=', ','));
        IF rec_MsgCollection."Backlog Collection Day" = 0D THEN LTxt_F010 := PADSTR('', 8);

        GTxt_Text01 := STRSUBSTNO('%1%2%3%4%5%6%7%8%9%10',
                       LTxt_F001, LTxt_F002, LTxt_F003, LTxt_F004, LTxt_F005, LTxt_F006, LTxt_F007, LTxt_F008, LTxt_F009, LTxt_F010);

        //Shipping Instruction Div
        LTxt_F011 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Shipping Instruction Div", '=', ','));
        IF LTxt_F011 = '' THEN LTxt_F011 := STRSUBSTNO('%1', ' ');

        //Allocated Inv. Class
        //LTxt_F017 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Allocated Inv. Class"),'=',','));
        //Sh Start 28122010
        //IF rec_MsgCollection."Allocated Inv. Class" = '' THEN LTxt_F017 := STRSUBSTNO('%1',' ');
        //sh end

        //SOLD TO Customer
        //LTxt_F018 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."SOLDTO Customer",20),'=',','));
        //IF rec_MsgCollection."SOLDTO Customer" = '' THEN LTxt_F018 := PADSTR('',20);

        //SOLD TO Customer2
        //LTxt_F019 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."SOLDTO Customer2",20),'=',','));
        //IF rec_MsgCollection."SOLDTO Customer2" = '' THEN LTxt_F019 := PADSTR('',20);

        //Comment
        //LTxt_F020 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection.Comment,30),'=',','));
        //IF rec_MsgCollection.Comment = '' THEN LTxt_F020 := PADSTR('',30);

        //SO Document Category
        LTxt_F012 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."SO Document Category", '=', ','));

        //SCM Process Code
        LTxt_F013 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Process Code", 2), '=', ','));
        IF rec_MsgCollection."SCM Process Code" = '' THEN LTxt_F013 := PADSTR('', 2);

        //Update Date
        IF rec_MsgCollection."Update Date" = 0D THEN
            LTxt_F014 := PADSTR('', 8)
        ELSE
            LTxt_F014 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Update Date", FALSE), '=', ','));

        //Update Time
        IF rec_MsgCollection."Update Time" = 0T THEN
            LTxt_F015 := PADSTR('', 6)
        ELSE
            LTxt_F015 := STRSUBSTNO('%1', DELCHR(TIME2HHMMSS(rec_MsgCollection."Update Time"), '=', ','));

        //Agent Internal Key
        LTxt_F016 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Agent Internal Key", 40), '=', ','));
        IF rec_MsgCollection."Agent Internal Key" = '' THEN LTxt_F016 := PADSTR('', 40);

        //Now Use Sanjeev Begin 12/03/2020
        //Sales Price
        //LTxt_F017 := STRSUBSTNO('%1',DELCHR(FORMAT(rec_MsgCollection."Sales Price",0,'<Integer,12><Filler,0>'),'=',','));// by sanjeev

        LTxt_Padstr :=
          PADSTR('', 13 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."Sales Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
        LTxt_F017 := STRSUBSTNO('%1',
            DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."Sales Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');


        //Currency Code
        LTxt_F018 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Currency Code", 3), '=', ','));
        IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F018 := PADSTR('', 3);
        //Now Use Sanjeev End 12/03/2020

        //Now Use Sanjeev Begin 12/03/2020
        //Premilinaries
        LTxt_F019 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection.Preliminaries, 10), '=', ','));
        IF rec_MsgCollection.Preliminaries = '' THEN LTxt_F019 := PADSTR('', 10);

        Gtxt_Text02 := STRSUBSTNO('%1%2%3%4%5%6%7%8%9',
                              LTxt_F011, LTxt_F012, LTxt_F013, LTxt_F014, LTxt_F015, LTxt_F016, LTxt_F017, LTxt_F018, LTxt_F019);

        //Now Use Sanjeev End 12/03/2020
        //GTxt_Text03 := STRSUBSTNO('%1',LTxt_F021);
        //GFle_File.WRITE(STRSUBSTNO('%1%2%3',GTxt_Text01,Gtxt_Text02,GTxt_Text03));

        //GFle_File.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        //GFle_File_1.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        InsertDataInBuffer(STRSUBSTNO('%1%2', GTxt_Text01, Gtxt_Text02));
        //Now Use Sanjeev End 12/03/2020
    end;

    procedure Process_JDData()
    var
        LTxt_F001: Text[2];
        LTxt_F002: Text[8];
        LTxt_F003: Text[10];
        LTxt_F004: Text[40];
        LTxt_F005: Text[2];
        LTxt_F006: Text[1];
        LTxt_F007: Text[11];
        LTxt_F008: Text[3];
        LTxt_F009: Text[13];
        LTxt_F010: Text[16];
        LTxt_F011: Text[8];
        LTxt_F012: Text[8];
        LTxt_F013: Text[6];
        LTxt_F014: Text[40];
        LTxt_F015: Text[32];
        LTxt_Padstr: Text[50];
    begin
        //CS101 Begin
        IF (GRec_GLSetup."Exclude Zero Balance (JD)") AND (rec_MsgCollection.Quantity = 0) THEN
            EXIT;
        //CS101 End

        CLEAR(LTxt_F001);
        CLEAR(LTxt_F002);
        CLEAR(LTxt_F003);
        CLEAR(LTxt_F004);
        CLEAR(LTxt_F005);
        CLEAR(LTxt_F006);
        CLEAR(LTxt_F007);
        CLEAR(LTxt_F008);
        CLEAR(LTxt_F009);
        CLEAR(LTxt_F010);
        CLEAR(LTxt_F011);
        CLEAR(LTxt_F012);
        CLEAR(LTxt_F013);
        CLEAR(LTxt_F014);
        CLEAR(LTxt_F015);

        //File ID
        LTxt_F001 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."File ID", '=', ','));

        //Collection Date
        LTxt_F002 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Collected On", FALSE), '=', ','));
        IF rec_MsgCollection."Collected On" = 0D THEN LTxt_F002 := PADSTR('', 8);

        //Department Grp Code
        //LTxt_F002 := STRSUBSTNO('%1',DELCHR(rec_MsgCollection."Department Gr Code",'=',','));
        //IF rec_MsgCollection."Department Gr Code" = '' THEN LTxt_F002 := STRSUBSTNO('%1',' ');

        //Warehouse Code
        //LTxt_F003 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Warehouse Code",13),'=',','));
        //IF rec_MsgCollection."Warehouse Code" = '' THEN LTxt_F003 := PADSTR('',13);

        //SCM Customer Code
        LTxt_F003 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Customer Code", 10), '=', ','));
        IF rec_MsgCollection."SCM Customer Code" = '' THEN LTxt_F003 := PADSTR('', 10);

        //End user Code
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."End User Code",13),'=',','));
        //IF rec_MsgCollection."End User Code" = '' THEN LTxt_F005 := PADSTR('',13);

        //Purpose Code
        //LTxt_F006 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Purpose Code",3),'=',','));
        //IF rec_MsgCollection."Purpose Code" = '' THEN LTxt_F006 := PADSTR('',3);

        //Supplier Code
        //LTxt_F007 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Supplier Code",3),'=',','));
        //IF rec_MsgCollection."Supplier Code" = '' THEN LTxt_F007 := PADSTR('',3);

        //Parts Number
        //window.UPDATE(2,rec_MsgCollection."Parts Number");
        //LTxt_F004 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Parts Number",40),'=',','));
        //IF rec_MsgCollection."Parts Number" = '' THEN LTxt_F004 := PADSTR('',40);

        //Parts Number
        //window.UPDATE(2,rec_MsgCollection."Item Description");
        LTxt_F004 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Item Description", 40), '=', ','));
        IF rec_MsgCollection."Item Description" = '' THEN LTxt_F004 := PADSTR('', 40);

        //Inventory Class (Inventory Status)
        LTxt_F005 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Inventory Class", '=', ','));
        IF rec_MsgCollection."Inventory Class" = '' THEN LTxt_F005 := PADSTR('', 2);

        // +/- Class
        LTxt_F006 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Pos/Neg Class", '=', ','));

        //Inventory Quantity
        LTxt_F007 := STRSUBSTNO('%1', DELCHR(FORMAT(rec_MsgCollection.Quantity, 0, '<Integer,11><Filler,0>'), '=', ','));

        //Currency Code
        LTxt_F008 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Currency Code", 3), '=', ','));
        IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F008 := PADSTR('', 3);

        //Inventory Price
        LTxt_Padstr :=
          PADSTR('', 13 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."Inventory Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
        LTxt_F009 := STRSUBSTNO('%1',
            DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."Inventory Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');

        //Inventory Amount
        LTxt_Padstr :=
          PADSTR('', 16 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."Inventory Amount", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
        LTxt_F010 := STRSUBSTNO('%1',
           DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."Inventory Amount", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');

        //CS101 Begin
        IF GRec_GLSetup."Get Purch. Price (JD)" THEN BEGIN
            IF (rec_MsgCollection."PC. Currency Code" <> '') AND (rec_MsgCollection."PC. Unit Cost" > 0) THEN BEGIN
                //Currency Code
                LTxt_F008 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."PC. Currency Code", 3), '=', ','));
                IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F008 := PADSTR('', 3);

                //Inventory Price
                LTxt_Padstr :=
                  PADSTR('', 13 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."PC. Unit Cost", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
                LTxt_F009 := STRSUBSTNO('%1',
                    DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."PC. Unit Cost", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');

                //Inventory Amount
                LTxt_Padstr :=
                  PADSTR('', 16 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."PC. Inventory Amount", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
                LTxt_F010 := STRSUBSTNO('%1',
                   DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."PC. Inventory Amount", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');
            END;
        END;
        //CS101 End
        GTxt_Text01 := STRSUBSTNO('%1%2%3%4%5%6%7%8%9%10',
                              LTxt_F001, LTxt_F002, LTxt_F003, LTxt_F004, LTxt_F005, LTxt_F006, LTxt_F007, LTxt_F008, LTxt_F009, LTxt_F010);

        //Inventory Confirmation Date
        LTxt_F011 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Inventory Confirmation Date", FALSE), '=', ','));
        IF rec_MsgCollection."Inventory Confirmation Date" = 0D THEN LTxt_F011 := PADSTR('', 8);

        //Update Date
        IF rec_MsgCollection."Update Date" = 0D THEN
            LTxt_F012 := PADSTR('', 8)
        ELSE
            LTxt_F012 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Update Date", FALSE), '=', ','));

        //Update Time
        IF rec_MsgCollection."Update Time" = 0T THEN
            LTxt_F013 := PADSTR('', 6)
        ELSE
            LTxt_F013 := STRSUBSTNO('%1', DELCHR(TIME2HHMMSS(rec_MsgCollection."Update Time"), '=', ','));

        //Agent Internal Key
        LTxt_F014 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Agent Internal Key", 40), '=', ','));
        IF rec_MsgCollection."Agent Internal Key" = '' THEN LTxt_F014 := PADSTR('', 40);

        //Comment
        //LTxt_F016 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection.Comment,30),'=',','));
        //IF rec_MsgCollection.Comment = '' THEN LTxt_F016 := PADSTR('',30);

        //Preliminaries
        LTxt_F015 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection.Preliminaries, 32), '=', ','));
        IF rec_MsgCollection.Preliminaries = '' THEN LTxt_F015 := PADSTR('', 32);

        Gtxt_Text02 := STRSUBSTNO('%1%2%3%4%5',
                              LTxt_F011, LTxt_F012, LTxt_F013, LTxt_F014, LTxt_F015);

        //GFle_File.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        //GFle_File_1.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        InsertDataInBuffer(STRSUBSTNO('%1%2', GTxt_Text01, Gtxt_Text02));
    end;

    procedure Process_JJData()
    var
        LTxt_F001: Text[2];
        LTxt_F002: Text[8];
        LTxt_F003: Text[10];
        LTxt_F004: Text[40];
        LTxt_F005: Text[6];
        LTxt_F006: Text[3];
        LTxt_F007: Text[8];
        LTxt_F008: Text[1];
        LTxt_F009: Text[11];
        LTxt_F010: Text[3];
        LTxt_F011: Text[13];
        LTxt_F012: Text[16];
        LTxt_F013: Text[8];
        LTxt_F014: Text[6];
        LTxt_F015: Text[40];
        LTxt_F016: Text[25];
        LTxt_Padstr: Text[30];
    begin

        CLEAR(LTxt_F001);
        CLEAR(LTxt_F002);
        CLEAR(LTxt_F003);
        CLEAR(LTxt_F004);
        CLEAR(LTxt_F005);
        CLEAR(LTxt_F006);
        CLEAR(LTxt_F007);
        CLEAR(LTxt_F008);
        CLEAR(LTxt_F009);
        CLEAR(LTxt_F010);
        CLEAR(LTxt_F011);
        CLEAR(LTxt_F012);
        CLEAR(LTxt_F013);
        CLEAR(LTxt_F014);
        CLEAR(LTxt_F015);
        CLEAR(LTxt_F016);

        //File ID
        LTxt_F001 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."File ID", '=', ','));

        //Collection Date
        LTxt_F002 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Collected On", FALSE), '=', ','));
        IF rec_MsgCollection."Collected On" = 0D THEN LTxt_F002 := PADSTR('', 8);

        //Department Grp Code
        //LTxt_F002 := STRSUBSTNO('%1',DELCHR(rec_MsgCollection."Department Gr Code",'=',','));
        //IF rec_MsgCollection."Department Gr Code" = '' THEN LTxt_F002 := STRSUBSTNO('%1',' ');

        //Warehouse Code
        //LTxt_F003 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Warehouse Code",13),'=',','));
        //IF rec_MsgCollection."Warehouse Code" = '' THEN LTxt_F003 := PADSTR('',13);

        //SCM Customer Code
        LTxt_F003 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."SCM Customer Code", 10), '=', ','));
        IF rec_MsgCollection."SCM Customer Code" = '' THEN LTxt_F003 := PADSTR('', 10);

        //End user Code
        //LTxt_F005 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."End User Code",13),'=',','));
        //IF rec_MsgCollection."End User Code" = '' THEN LTxt_F005 := PADSTR('',13);

        //Purpose Code
        //LTxt_F006 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Purpose Code",3),'=',','));
        //IF rec_MsgCollection."Purpose Code" = '' THEN LTxt_F006 := PADSTR('',3);

        //Supplier Code
        //LTxt_F007 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Supplier Code",3),'=',','));
        //IF rec_MsgCollection."Supplier Code" = '' THEN LTxt_F007 := PADSTR('',3);

        //Parts Number
        //window.UPDATE(2,rec_MsgCollection."Parts Number");
        //LTxt_F004 := STRSUBSTNO('%1',DELCHR(PADSTR(rec_MsgCollection."Parts Number",40),'=',','));
        //IF rec_MsgCollection."Parts Number" = '' THEN LTxt_F004 := PADSTR('',40);

        //Siak 18042012
        //Parts Number
        //window.UPDATE(2,rec_MsgCollection."Item Description");
        LTxt_F004 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Item Description", 40), '=', ','));
        IF rec_MsgCollection."Item Description" = '' THEN LTxt_F004 := PADSTR('', 40);
        //Siak End

        //CO No
        LTxt_F005 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."CO No", 6), '=', ','));
        IF rec_MsgCollection."CO No" = '' THEN LTxt_F005 := PADSTR('', 6);

        //Partial Delivery
        LTxt_F006 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Partial Delivery", 3), '=', ','));
        IF rec_MsgCollection."Partial Delivery" = '' THEN LTxt_F006 := PADSTR('', 3);

        //Demand Date (Good Receipt Date)
        //LTxt_F007 := STRSUBSTNO('%1',DELCHR(DATE2DDMMYY(rec_MsgCollection."Demand Date",FALSE),'=',','));
        //IF rec_MsgCollection."Demand Date" = 0D THEN LTxt_F007 := PADSTR('',8);

        //Purchase Day (Good Receipt Date)
        LTxt_F007 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Purchase Day", FALSE), '=', ','));
        IF rec_MsgCollection."Purchase Day" = 0D THEN LTxt_F007 := PADSTR('', 8);

        // +/- Class
        LTxt_F008 := STRSUBSTNO('%1', DELCHR(rec_MsgCollection."Pos/Neg Class", '=', ','));

        //Purchase Quantity
        LTxt_F009 := STRSUBSTNO('%1', DELCHR(FORMAT(rec_MsgCollection.Quantity, 0, '<Integer,11><Filler,0>'), '=', ','));

        //Currency Code
        LTxt_F010 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Currency Code", 3), '=', ','));
        IF rec_MsgCollection."Currency Code" = '' THEN LTxt_F013 := PADSTR('', 3);

        GTxt_Text01 := STRSUBSTNO('%1%2%3%4%5%6%7%8%9%10',
                              LTxt_F001, LTxt_F002, LTxt_F003, LTxt_F004, LTxt_F005, LTxt_F006, LTxt_F007, LTxt_F008, LTxt_F009, LTxt_F010);

        //Purchase Price
        LTxt_Padstr :=
          PADSTR('', 13 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."Purchase Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
        LTxt_F011 := STRSUBSTNO('%1',
            DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."Purchase Price", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');

        //Purchase Amount
        LTxt_Padstr :=
          PADSTR('', 16 - STRLEN(DELCHR(FORMAT(rec_MsgCollection."Purchase Amount", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '0');
        LTxt_F012 := STRSUBSTNO('%1',
            DELCHR(LTxt_Padstr + DELCHR(FORMAT(rec_MsgCollection."Purchase Amount", 0, '<Precision,4><Standard Format,1>'), '=', '.')), '=', ',');

        //Update Date
        IF rec_MsgCollection."Update Date" = 0D THEN
            LTxt_F013 := PADSTR('', 8)
        ELSE
            LTxt_F013 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY(rec_MsgCollection."Update Date", FALSE), '=', ','));

        //Update Time
        IF rec_MsgCollection."Update Time" = 0T THEN
            LTxt_F014 := PADSTR('', 6)
        ELSE
            LTxt_F014 := STRSUBSTNO('%1', DELCHR(TIME2HHMMSS(rec_MsgCollection."Update Time"), '=', ','));

        //Agent Internal Key
        LTxt_F015 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection."Agent Internal Key", 40), '=', ','));
        IF rec_MsgCollection."Agent Internal Key" = '' THEN LTxt_F015 := PADSTR('', 40);

        //Preliminaries
        LTxt_F016 := STRSUBSTNO('%1', DELCHR(PADSTR(rec_MsgCollection.Preliminaries, 25), '=', ','));
        IF rec_MsgCollection.Preliminaries = '' THEN LTxt_F016 := PADSTR('', 25);

        Gtxt_Text02 := STRSUBSTNO('%1%2%3%4%5%6',
                              LTxt_F011, LTxt_F012, LTxt_F013, LTxt_F014, LTxt_F015, LTxt_F016);

        //GFle_File.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        //GFle_File_1.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
        InsertDataInBuffer(STRSUBSTNO('%1%2', GTxt_Text01, Gtxt_Text02));
    end;

    procedure Process_JZData()
    var
        LTxt_F001: Text[2];
        LTxt_F002: Text[2];
        LTxt_F003: Text[7];
        LTxt_F004: Text[1];
        LTxt_F005: Text[15];
        LTxt_F006: Text[1];
        LTxt_F007: Text[15];
        LTxt_F008: Text[8];
        LTxt_F009: Text[8];
        LTxt_F010: Text[141];
        LTxt_Padstr: Text[50];
    begin

        CLEAR(LTxt_F001);
        CLEAR(LTxt_F002);
        CLEAR(LTxt_F003);
        CLEAR(LTxt_F004);
        CLEAR(LTxt_F005);
        CLEAR(LTxt_F006);
        CLEAR(LTxt_F007);
        CLEAR(LTxt_F008);
        CLEAR(LTxt_F009);
        CLEAR(LTxt_F010);

        WITH rec_MsgControl DO BEGIN
            RESET;
            SETFILTER("File ID", CONST_JZ);
            SETFILTER("Message Status", '=%1', "Message Status"::Ready);
            IF FINDSET THEN BEGIN


                //IF NOT gbln_CobmineCtrlMaster THEN CreateFile(CONST_JZ);

                REPEAT

                    //File ID
                    LTxt_F001 := STRSUBSTNO('%1', CONST_JZ);

                    //Detail File ID
                    LTxt_F002 := STRSUBSTNO('%1', DELCHR("Detail File ID", '=', ','));
                    IF "Detail File ID" = '' THEN LTxt_F002 := STRSUBSTNO('%1', ' ');

                    //Record Number
                    LTxt_F003 := STRSUBSTNO('%1', DELCHR(FORMAT("Record Number", 0, '<Integer,7><Filler,0>'), '=', ','));
                    //sh 27/12/10 IF "Record Number" = 0 THEN LTxt_F003 := PADSTR(' ',7);
                    IF "Record Number" = 0 THEN LTxt_F003 := PADSTR('0000000', 7);
                    //'+/- Class(Quantity)
                    LTxt_F004 := STRSUBSTNO('%1', DELCHR(PADSTR("Pos/Neg Class (Quantity)", 1), '=', ','));
                    IF "Pos/Neg Class (Quantity)" = '' THEN LTxt_F004 := PADSTR('', 1);

                    //Amount Quantity
                    LTxt_Padstr :=
                    PADSTR('', 15 - STRLEN(DELCHR(FORMAT("Amount Quantity", 0, '<Precision,3><Standard Format,1>'), '=', '.')), '0');
                    LTxt_F005 := STRSUBSTNO('%1', DELCHR(LTxt_Padstr +
                            DELCHR(FORMAT("Amount Quantity", 0, '<Precision,3><Standard Format,1>'), '=', '.')), '=', ',');

                    GTxt_Text01 := STRSUBSTNO('%1%2%3%4%5',
                                  LTxt_F001, LTxt_F002, LTxt_F003, LTxt_F004, LTxt_F005);

                    //+/- Class (Price)
                    LTxt_F006 := STRSUBSTNO('%1', DELCHR(PADSTR("Pos/Neg Class (Price)", 1), '=', ','));
                    IF "Pos/Neg Class (Price)" = '' THEN LTxt_F006 := PADSTR('', 1);

                    //Amount Price
                    LTxt_Padstr :=
                    PADSTR('', 15 - STRLEN(DELCHR(FORMAT("Amount Price", 0, '<Precision,3><Standard Format,1>'), '=', '.')), '0');
                    LTxt_F007 := STRSUBSTNO('%1', DELCHR(LTxt_Padstr +
                            DELCHR(FORMAT("Amount Price", 0, '<Precision,3><Standard Format,1>'), '=', '.')), '=', ',');

                    //Statics Date  (based on 12th Nov Discussions, we are going to use "Collected On"
                    LTxt_F008 := STRSUBSTNO('%1', DELCHR(PADSTR(DATE2DDMMYY("Collected On", FALSE), 8), '=', ','));
                    IF "Collected On" = 0D THEN LTxt_F008 := PADSTR('', 8);

                    //Order Backlog Date
                    LTxt_F009 := STRSUBSTNO('%1', DELCHR(DATE2DDMMYY("Order Backlog Date", FALSE), '=', ','));
                    IF "Order Backlog Date" = 0D THEN LTxt_F009 := PADSTR('', 8);

                    //Preliminaries
                    //sh 23072011      LTxt_F010 := STRSUBSTNO('%1',DELCHR(PADSTR(Preliminaries,191),'=',','));
                    //sh 23072011      IF Preliminaries = '' THEN LTxt_F010 := PADSTR('',191);
                    LTxt_F010 := STRSUBSTNO('%1', DELCHR(PADSTR(Preliminaries, 141), '=', ','));
                    IF Preliminaries = '' THEN LTxt_F010 := PADSTR('', 141);

                    Gtxt_Text02 := STRSUBSTNO('%1%2%3%4%5',
                                  LTxt_F006, LTxt_F007, LTxt_F008, LTxt_F009, LTxt_F010);

                    //GFle_File.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
                    //GFle_File_1.WRITE(STRSUBSTNO('%1%2',GTxt_Text01,Gtxt_Text02));
                    InsertDataInBuffer(STRSUBSTNO('%1%2', GTxt_Text01, Gtxt_Text02));

                /* Move this update to API page during BC upgrade.
                "Message Status" := "Message Status"::Sent;
                "File Sent By" := USERID;
                "File Sent On" := TODAY;
                MODIFY;
                */

                UNTIL NEXT = 0;

                //IF NOT gbln_CobmineCtrlMaster THEN CloseFile();

            END;
        END;
    end;

    procedure Get_EndDate() EndDate: Date
    var
        CurrMnth: Integer;
        CurrYear: Integer;
    begin
        EndDate := 0D;

        CurrMnth := DATE2DMY(TODAY, 2);
        CurrYear := DATE2DMY(TODAY, 3);

        IF CurrMnth = 0 THEN CurrMnth := 1;
        EndDate := DMY2DATE(1, CurrMnth + 1, CurrYear) - 1; // EndDate will be the last day of the month
        EXIT(EndDate);
    end;

    procedure Get_PostingDate() Exist: Boolean
    begin
        EXIT(TRUE);
    end;

    procedure DATE2DDMMYY(PDate: Date; optDot: Boolean) DateStr: Text[10]
    var
        DD: Text[2];
        MM: Text[2];
        YYYY: Text[4];
    begin
        //DATE2YYYYMMDD

        IF PDate = 0D THEN EXIT;

        IF DATE2DMY(PDate, 1) < 10 THEN
            DD := STRSUBSTNO('%1%2', '0', DATE2DMY(PDate, 1))
        ELSE
            DD := STRSUBSTNO('%1', DATE2DMY(PDate, 1));

        IF DATE2DMY(PDate, 2) < 10 THEN
            MM := STRSUBSTNO('%1%2', '0', DATE2DMY(PDate, 2))
        ELSE
            MM := STRSUBSTNO('%1', DATE2DMY(PDate, 2));

        YYYY := STRSUBSTNO('%1', DATE2DMY(PDate, 3));

        IF optDot THEN
            DateStr := STRSUBSTNO('%1.%2.%3', YYYY, MM, DD)
        ELSE
            DateStr := STRSUBSTNO('%1%2%3', YYYY, MM, DD);
        EXIT(DateStr)
    end;

    procedure TIME2HHMMSS(PTime: Time) TimeStr: Text[6]
    var
        HH: Integer;
        MM: Integer;
        SS: Integer;
        HHText: Text[2];
        MMText: Text[2];
        SSText: Text[2];
    begin
        //TIME2HHMMSS

        EVALUATE(HH, (COPYSTR(STRSUBSTNO('%1', PTime), 1, (STRPOS(STRSUBSTNO('%1', PTime), ':') - 1))));
        EVALUATE(MM, (COPYSTR(STRSUBSTNO('%1', PTime), (STRPOS(STRSUBSTNO('%1', PTime), ':') + 1), 2)));
        EVALUATE(SS, (COPYSTR(STRSUBSTNO('%1', PTime), (STRPOS(STRSUBSTNO('%1', PTime), ':') + 4), 2)));

        IF HH < 10 THEN
            HHText := STRSUBSTNO('0%1', HH)
        ELSE
            HHText := STRSUBSTNO('%1', HH);

        IF MM < 10 THEN
            MMText := STRSUBSTNO('0%1', MM)
        ELSE
            MMText := STRSUBSTNO('%1', MM);

        IF SS < 10 THEN
            SSText := STRSUBSTNO('0%1', SS)
        ELSE
            SSText := STRSUBSTNO('%1', SS);

        TimeStr := STRSUBSTNO('%1%2%3', HHText, MMText, SSText);

        EXIT(TimeStr);
    end;

    procedure InsertDataInBuffer(p_ExportText: Text[250])
    var
        SendMsgBuffer: Record "Send Message Buffer";
        NextEntryNo: Integer;
    begin
        SendMsgBuffer.INIT;
        SendMsgBuffer."Export Text" := p_ExportText;
        SendMsgBuffer.INSERT;
    end;

    procedure DeleteDataInBuffer()
    var
        SendMsgBuffer: Record "Send Message Buffer";
    begin
        SendMsgBuffer.DELETEALL;
    end;

}

