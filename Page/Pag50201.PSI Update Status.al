//FDD301 page for the NBKAPI INSTOKUCD.
page 50201 "PSI Update Status"
{
    Caption = 'PSI Update Status';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'PSI';
    APIVersion = 'v2.0';
    EntitySetCaption = 'PSIUpdateStatus';
    EntitySetName = 'PSIUpdateStatus';
    EntityCaption = 'PSIUpdateStatus';
    EntityName = 'PSIUpdateStatus';
    ODataKeyFields = "Entry No.";
    SourceTable = "Send Message Buffer";
    SourceTableTemporary = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec."Entry No.")
                {
                }
            }
        }
    }

    var
        GRec_GLSetup: Record "General Ledger Setup";
        CONST_JA: Label 'JA';
        CONST_JB: Label 'JB';
        CONST_JC: Label 'JC';
        CONST_JD: Label 'JD';
        CONST_JJ: Label 'JJ';
        CONST_JZ: Label 'JZ';

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        UpdateGLStatus();
        UpdatePSIDataStatus();
        UpdatePSIControlStatus();
    end;

    local procedure UpdateGLStatus()
    var
        myInt: Integer;
    begin
        GRec_GLSetup.get();
        GRec_GLSetup."PSI Job Status" := '3';
        GRec_GLSetup."Daily PSI Data Collection" := '0';
        GRec_GLSetup."Monthly PSI Data Collection" := '0';
        GRec_GLSetup.MODIFY;
    end;


    local procedure UpdatePSIDataStatus()
    var
        myInt: Integer;
        MessageCollect: Record "Message Collection";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShipHeader: Record "Sales Shipment Header";
        SalesShipLine: Record "Sales Shipment Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        MessageCollect.Reset();
        MessageCollect.SetRange("Collected On", Today);
        MessageCollect.SetRange("Message Status", MessageCollect."Message Status"::Ready);
        if MessageCollect.FindSet() then
            repeat
                case
                    MessageCollect."File ID" of
                    CONST_JA:
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::Order, MessageCollect."Source Document No.");
                            SalesHeader."Message Status(Booking)" := SalesHeader."Message Status(Booking)"::Sent;
                            SalesHeader.Modify();

                            SalesLine.get(SalesLine."Document Type"::Order, MessageCollect."Source Document No.", MessageCollect."Source Document Line No.");
                            SalesLine."Message Status" := SalesLine."Message Status"::Sent;
                            SalesLine.Modify();
                        end;
                    CONST_JB:
                        begin
                            SalesShipHeader.get(MessageCollect."Source Document No.");
                            SalesShipHeader."Message Status(Shipment)" := SalesShipHeader."Message Status(Shipment)"::Sent;
                            SalesShipHeader.Modify();

                            SalesShipLine.get(MessageCollect."Source Document No.", MessageCollect."Source Document Line No.");
                            SalesShipLine."Message Status" := SalesShipLine."Message Status"::Sent;
                            SalesShipLine.Modify();
                        end;
                    CONST_JC:
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::Order, MessageCollect."Source Document No.");
                            SalesHeader."Message Status(Backlog)" := SalesHeader."Message Status(Backlog)"::Sent;
                            SalesHeader.Modify();

                            SalesLine.get(SalesLine."Document Type"::Order, MessageCollect."Source Document No.", MessageCollect."Source Document Line No.");
                            SalesLine."Message Status (JC)" := SalesLine."Message Status (JC)"::Sent;
                            SalesLine.Modify();
                        end;
                    CONST_JJ:
                        begin
                            PurchRcptHeader.get(MessageCollect."Source Document No.");
                            PurchRcptHeader."Message Status(Incoming)" := PurchRcptHeader."Message Status(Incoming)"::Sent;
                            PurchRcptHeader.Modify();

                            PurchRcptLine.get(MessageCollect."Source Document No.", MessageCollect."Source Document Line No.");
                            PurchRcptLine."Message Status" := PurchRcptLine."Message Status"::Sent;
                            PurchRcptLine.Modify();
                        end;
                end;

                MessageCollect."Message Status" := MessageCollect."Message Status"::Sent;
                MessageCollect."File Sent By" := USERID;
                MessageCollect."File Sent On" := TODAY;
                MessageCollect.Modify();

            until MessageCollect.Next() = 0;
    end;

    local procedure UpdatePSIControlStatus()
    var
        myInt: Integer;
        MessageControl: Record "Message Control";
    begin
        MessageControl.Reset();
        MessageControl.SetRange("File ID", CONST_JZ);
        MessageControl.SetRange("Collected On", Today);
        MessageControl.SetRange("Message Status", MessageControl."Message Status"::Ready);
        if MessageControl.FindSet() then
            repeat

                MessageControl."Message Status" := MessageControl."Message Status"::Sent;
                MessageControl."File Sent By" := USERID;
                MessageControl."File Sent On" := TODAY;
                MessageControl.Modify();

            until MessageControl.Next() = 0;
    end;
}
