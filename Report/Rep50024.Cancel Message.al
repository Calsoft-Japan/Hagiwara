report 50024 "Cancel Message"
{
    Permissions = TableData 110 = rimd,
                  TableData 111 = rimd,
                  TableData 120 = rimd,
                  TableData 121 = rimd;
    ProcessingOnly = true;

    dataset
    {
    }

    procedure CancelMessage(pMessageCtrl: Record "Message Control")
    begin

        CASE pMessageCtrl."Detail File ID" OF
            CONST_JA:
                BEGIN
                    MessageColl.RESET;
                    MessageColl.SetRange("File ID", CONST_JA);
                    MessageColl.SetRange("Message Status", MessageColl."Message Status"::Ready);
                    MessageColl.SetRange("Collected On", pMessageCtrl."Collected On");

                    if MessageColl.FindSet() then
                        repeat

                            MessageColl."Message Status" := MessageColl."Message Status"::Cancelled;
                            MessageColl.Modify();

                            if SalesHeader.get(SalesHeader."Document Type"::Order, MessageColl."Source Document No.") then begin
                                SalesHeader."Message Status(Booking)" := SalesHeader."Message Status(Booking)"::"Ready to Collect";
                                SalesHeader."Message Collected By(Booking)" := '';
                                SalesHeader."Message Collected On(Booking)" := 0D;
                                SalesHeader.Modify();
                            end;

                            if SalesLine.Get(SalesHeader."Document Type", MessageColl."Source Document No.", MessageColl."Source Document Line No.") then begin
                                SalesLine."Message Status" := SalesLine."Message Status"::"Ready to Collect";
                                SalesLine."JA Collection Date" := 0D;
                                SalesLine.Modify();
                            end;

                        until MessageColl.Next() = 0;
                END;
            CONST_JB:
                begin

                    MessageColl.RESET;
                    MessageColl.SetRange("File ID", CONST_JB);
                    MessageColl.SetRange("Message Status", MessageColl."Message Status"::Ready);
                    MessageColl.SetRange("Collected On", pMessageCtrl."Collected On");

                    if MessageColl.FindSet() then
                        repeat

                            MessageColl."Message Status" := MessageColl."Message Status"::Cancelled;
                            MessageColl.Modify();

                            if SalesShptHeader.get(MessageColl."Source Document No.") then begin
                                SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                                SalesShptHeader."Message Collected By(Shipment)" := '';
                                SalesShptHeader."Message Collected On(Shipment)" := 0D;
                                SalesShptHeader.Modify();
                            end;

                            if SalesShptLine.Get(MessageColl."Source Document No.", MessageColl."Source Document Line No.") then begin
                                SalesShptLine."Message Status" := SalesShptLine."Message Status"::"Ready to Collect";
                                SalesShptLine."Shipment Collection Date" := 0D;
                                SalesShptLine.Modify();
                            end;

                        until MessageColl.Next() = 0;
                end;
            CONST_JC:
                begin

                    MessageColl.RESET;
                    MessageColl.SetRange("File ID", CONST_JC);
                    MessageColl.SetRange("Message Status", MessageColl."Message Status"::Ready);
                    MessageColl.SetRange("Collected On", pMessageCtrl."Collected On");

                    if MessageColl.FindSet() then
                        repeat

                            MessageColl."Message Status" := MessageColl."Message Status"::Cancelled;
                            MessageColl.Modify();

                            if SalesHeader.get(SalesHeader."Document Type"::Order, MessageColl."Source Document No.") then begin
                                SalesHeader."Message Status(Backlog)" := SalesHeader."Message Status(Backlog)"::"Ready to Collect";
                                SalesHeader."Message Collected By(Backlog)" := '';
                                SalesHeader."Message Collected On(Backlog)" := 0D;
                                SalesHeader.Modify();
                            end;

                            if SalesLine.Get(SalesHeader."Document Type", MessageColl."Source Document No.", MessageColl."Source Document Line No.") then begin
                                SalesLine."Message Status (JC)" := SalesLine."Message Status (JC)"::"Ready to Collect";
                                SalesLine."JC Collection Date" := 0D;
                                SalesLine.Modify();
                            end;

                        until MessageColl.Next() = 0;
                end;
            CONST_JD:
                begin

                    MessageColl.RESET;
                    MessageColl.SetRange("File ID", CONST_JD);
                    MessageColl.SetRange("Message Status", MessageColl."Message Status"::Ready);
                    MessageColl.SetRange("Collected On", pMessageCtrl."Collected On");

                    if MessageColl.FindSet() then
                        repeat

                            MessageColl."Message Status" := MessageColl."Message Status"::Cancelled;
                            MessageColl.Modify();

                            if Item.get(MessageColl."Item No.") then begin
                                Item."Message Collected By" := '';
                                Item."Message Collected On" := 0D;
                                Item.Modify();
                            end;

                        until MessageColl.Next() = 0;
                end;
            CONST_JJ:
                begin

                    MessageColl.RESET;
                    MessageColl.SetRange("File ID", CONST_JJ);
                    MessageColl.SetRange("Message Status", MessageColl."Message Status"::Ready);
                    MessageColl.SetRange("Collected On", pMessageCtrl."Collected On");

                    if MessageColl.FindSet() then
                        repeat

                            MessageColl."Message Status" := MessageColl."Message Status"::Cancelled;
                            MessageColl.Modify();

                            if PurchRcptHeader.get(MessageColl."Source Document No.") then begin
                                PurchRcptHeader."Message Status(Incoming)" := PurchRcptHeader."Message Status(Incoming)"::"Ready to Collect";
                                PurchRcptHeader."Message Collected By(Incoming)" := '';
                                PurchRcptHeader."Message Collected On(Incoming)" := 0D;
                                PurchRcptHeader.Modify();
                            end;

                            if PurchRcptLine.Get(MessageColl."Source Document No.", MessageColl."Source Document Line No.") then begin
                                PurchRcptLine."Message Status" := PurchRcptLine."Message Status"::"Ready to Collect";
                                PurchRcptLine."Receipt Collection Date" := 0D;
                                PurchRcptLine.Modify();
                            end;

                        until MessageColl.Next() = 0;
                end;

        END;


        pMessageCtrl."Message Status" := pMessageCtrl."Message Status"::Cancelled;
        pMessageCtrl.MODIFY(TRUE);
    end;

    var
        CONST_JA: Label 'JA';
        CONST_JB: Label 'JB';
        CONST_JC: Label 'JC';
        CONST_JD: Label 'JD';
        CONST_JJ: Label 'JJ';
        CONST_JZ: Label 'JZ';
        MessageColl: Record "Message Collection";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Item: Record Item;

}

