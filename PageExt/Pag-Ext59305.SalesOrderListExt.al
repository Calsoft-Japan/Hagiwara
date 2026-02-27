pageextension 59305 SalesOrderListExt extends "Sales Order List"
{
    layout
    {

        addafter("No.")
        {
            field("Order Date"; rec."Order Date")
            {

                ApplicationArea = all;
            }

        }

        addafter("Sell-to Customer Name")
        {

            field("Item Supplier Source"; rec."Item Supplier Source")
            {

                ApplicationArea = all;
            }
            field("OEM No."; rec."OEM No.")
            {

                ApplicationArea = all;
            }
            field("OEM Name"; rec."OEM Name")
            {

                ApplicationArea = all;
            }
            field(Ship; rec.Ship)
            {

                ApplicationArea = all;
            }
            field("Order Count"; rec."Order Count")
            {

                ApplicationArea = all;
            }
            field("Full Shipped Count"; rec."Full Shipped Count")
            {

                ApplicationArea = all;
            }
            field("Qty Invoiced"; rec."Qty Invoiced")
            {

                ApplicationArea = all;
            }
            field("Qty Ordered"; rec."Qty Ordered")
            {

                ApplicationArea = all;
            }
            field("Qty Shipped"; rec."Qty Shipped")
            {

                ApplicationArea = all;
            }
            field("Qty Outstanding (Actual)"; rec."Qty Outstanding (Actual)")
            {

                ApplicationArea = all;
            }
            field("Approval Status"; rec."Approval Status")
            {
                ApplicationArea = all;
            }
            field("Approver"; rec."Hagi Approver")
            {
                ApplicationArea = all;
            }
            field("Requester"; rec."Requester")
            {
                ApplicationArea = all;
            }
            field("Approval Cycle No."; rec."Approval Cycle No.")
            {
                ApplicationArea = all;
            }

        }

        addafter("Posting Date")
        {

            field("Amount(LCY)"; Amount_LCY)
            {

                ApplicationArea = all;
            }
            field("Message Status(Booking)"; rec."Message Status(Booking)")
            {

                ApplicationArea = all;
            }
            field("Message Collected On(Booking)"; rec."Message Collected On(Booking)")
            {

                ApplicationArea = all;
            }
        }

        addafter("Package Tracking No.")
        {
            field("Shipment Tracking Date"; rec."Shipment Tracking Date")
            {

                ApplicationArea = all;
            }
        }

    }
    actions
    {

        //hide approve related actions of Base App
        modify("Request Approval")
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }

        modify("Email Confirmation")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
            end;
        }

        modify("Print Confirmation")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
            end;
        }

        modify("AttachAsPDF")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
            end;
        }

        addbefore("P&osting")
        {
            group("Hagiwara Approval")
            {
                action("Submit")
                {

                    ApplicationArea = all;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if rec."Approval Status" in [
                            Enum::"Hagiwara Approval Status"::"Not Applicable",
                            Enum::"Hagiwara Approval Status"::Submitted,
                            Enum::"Hagiwara Approval Status"::"Re-Submitted",
                            Enum::"Hagiwara Approval Status"::"Approved",
                            Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                            Error('This approval request can''t be sent because it''s sent or approved already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Cancel")
                {

                    ApplicationArea = all;
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Approve")
                {

                    ApplicationArea = all;
                    Image = Approve;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Reject")
                {

                    ApplicationArea = all;
                    Image = Reject;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Approval Entries")
                {

                    ApplicationArea = all;
                    Image = Entries;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        recApprEntry: Record "Hagiwara Approval Entry";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Sales Order");
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }


        addafter("AttachAsPDF")
        {
            action("DeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Delivery Order List';
                Image = PrintDocument;
                Scope = Repeater;
                trigger OnAction()
                var
                    Customer: Record Customer;
                begin

                    Customer.Reset;
                    Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    Report.Run(50044, TRUE, FALSE, Customer);

                end;
            }
            action("ExportDeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'ExportDelivery Order List';
                Image = Export;
                Scope = Repeater;
                trigger OnAction()
                var
                    Customer: Record Customer;
                begin

                    Customer.Reset;
                    Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    Report.Run(50043, TRUE, FALSE, Customer);

                end;
            }


            action("ProformaInvoice")
            {
                ApplicationArea = all;
                Caption = 'Proforma Invoice ';
                Image = PrintDocument;
                Scope = Repeater;

                trigger OnAction()
                var
                    ProformaInvoice: Report "Proforma Invoice";
                begin
                    //Report.Run(50066, TRUE, FALSE, Rec);
                    ProformaInvoice.Run();
                end;
            }
        }

        addafter("AttachAsPDF_Promoted")
        {
            actionref("DeliveryOrderList_Promoted"; DeliveryOrderList)
            {
            }
            actionref("ExportDeliveryOrderList_Promoted"; ExportDeliveryOrderList)
            {
            }

            actionref("ProformaInvoice_Promoted"; ProformaInvoice)
            {
            }
        }
    }
    var
        Amount_LCY: Decimal;

    trigger OnAfterGetRecord()
    begin

        //SiakHui  20141001 Start
        IF rec."Currency Factor" > 0 THEN BEGIN
            Amount_LCY := ROUND(rec.Amount / rec."Currency Factor");
        END ELSE BEGIN
            Amount_LCY := rec.Amount;
        END;
        //SiakHui  20141001 Start

    end;

    local procedure GetSelectedCustomerNos(var SalesHeader: Record "Sales Header"): Text
    var
        Result: Text;
        First: Boolean;
    begin
        First := true;
        if SalesHeader.FindSet() then
            repeat
                if not First then
                    Result += '|';
                Result += SalesHeader."Sell-to Customer No.";
                First := false;
            until SalesHeader.Next() = 0;
        exit(Result);
    end;


}
