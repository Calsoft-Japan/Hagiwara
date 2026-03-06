pageextension 55742 TransferOrdersExt extends "Transfer Orders"
{
    layout
    {
        addafter("In-Transit Code")
        {

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


    }
    actions
    {
        modify("&Print")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                recApprSetup.Get();
                if (recApprSetup."Transfer Order") then begin
                    if not (Rec."Approval Status" in
                        [enum::"Hagiwara Approval Status"::Approved,
                        enum::"Hagiwara Approval Status"::"Auto Approved",
                        enum::"Hagiwara Approval Status"::"Not Applicable"
                        ]) then begin
                        Error('It is not approved yet.');
                    end;
                end;
                //N005 End
            end;
        }
        modify("Post")
        {
            trigger OnBeforeAction()

            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                //When considering Preview Mode, there is no appropriate event to subscribe in Base Post Codeunit, 
                //so add this check on page.
                recApprSetup.Get();
                if (recApprSetup."Transfer Order") then begin
                    if not (Rec."Approval Status" in
                        [enum::"Hagiwara Approval Status"::Approved,
                        enum::"Hagiwara Approval Status"::"Auto Approved",
                        enum::"Hagiwara Approval Status"::"Not Applicable"
                        ]) then begin
                        Error('It is not approved yet.');
                    end;
                end;
                //N005 End
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()

            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                //When considering Preview Mode, there is no appropriate event to subscribe in Base Post Codeunit, 
                //so add this check on page.
                recApprSetup.Get();
                if (recApprSetup."Transfer Order") then begin
                    if not (Rec."Approval Status" in
                        [enum::"Hagiwara Approval Status"::Approved,
                        enum::"Hagiwara Approval Status"::"Auto Approved",
                        enum::"Hagiwara Approval Status"::"Not Applicable"
                        ]) then begin
                        Error('It is not approved yet.');
                    end;
                end;
                //N005 End
            end;
        }
        modify("BatchPost")
        {
            trigger OnBeforeAction()

            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                //When considering Preview Mode, there is no appropriate event to subscribe in Base Post Codeunit, 
                //so add this check on page.
                recApprSetup.Get();
                if (recApprSetup."Transfer Order") then begin
                    if not (Rec."Approval Status" in
                        [enum::"Hagiwara Approval Status"::Approved,
                        enum::"Hagiwara Approval Status"::"Auto Approved",
                        enum::"Hagiwara Approval Status"::"Not Applicable"
                        ]) then begin
                        Error('It is not approved yet.');
                    end;
                end;
                //N005 End
            end;
        }

        addafter("&Print")
        {
            action("DeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Delivery Order List';
                Image = PrintDocument;
                Scope = Repeater;
                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin

                    TransferHeader.Reset;
                    TransferHeader.SetRange("No.", Rec."No.");
                    Report.Run(50045, TRUE, FALSE, TransferHeader);


                end;
            }
            action("ExportDeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Export Delivery Order List';
                Image = Export;
                Scope = Repeater;
                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin

                    TransferHeader.Reset;
                    TransferHeader.SetRange("No.", Rec."No.");
                    Report.Run(50046, TRUE, FALSE, TransferHeader);
                end;
            }
        }

        addafter("&Print_Promoted")
        {
            actionref("DeliveryOrderList_Promoted"; DeliveryOrderList)
            {
            }
            actionref("ExportDeliveryOrderList_Promoted"; ExportDeliveryOrderList)
            {
            }
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
                        if not recApprSetup."Transfer Order" then
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

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Transfer Order", Rec."No.", UserId);
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
                        if not recApprSetup."Transfer Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Transfer Order", Rec."No.", UserId);
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
                        if not recApprSetup."Transfer Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Transfer Order", Rec."No.", UserId);
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
                        if not recApprSetup."Transfer Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Transfer Order", Rec."No.", UserId);
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
                        if not recApprSetup."Transfer Order" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Transfer Order");
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }

    var
        Amount_LCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        /*
                //SiakHui  20141001 Start
                IF rec."Currency Factor" > 0 THEN BEGIN
                    Amount_LCY := ROUND(rec.Amount / rec."Currency Factor");
                END ELSE BEGIN
                    Amount_LCY := rec.Amount;
                END;
                //SiakHui  20141001 Start
        */
    end;

}
