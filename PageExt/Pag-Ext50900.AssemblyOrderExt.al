pageextension 50900 AssemblyOrderExt extends "Assembly Order"
{
    layout
    {
        addafter("Ending Date")
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

        addafter(Quantity)
        {
            field("Approved Quantity"; Rec."Approved Quantity")
            {
                ApplicationArea = all;
            }

        }


    }
    actions
    {

        modify("P&ost")
        {
            trigger OnBeforeAction()

            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                //When considering Preview Mode, there is no appropriate event to subscribe in Base Post Codeunit, 
                //so add this check on page.
                recApprSetup.Get();
                if ((recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order)) then begin

                    if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                        Error('It is not approved yet.');
                    end;
                end;
                //N005 End
            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()

            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                //When considering Preview Mode, there is no appropriate event to subscribe in Base Post Codeunit, 
                //so add this check on page.
                recApprSetup.Get();
                if ((recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order)) then begin

                    if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                        Error('It is not approved yet.');
                    end;
                end;
                //N005 End
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
                        if not recApprSetup."Assembly Order" then
                            exit;

                        if rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then
                            Error('This approval request can''t be sent because it''s sent already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Assembly Order", Rec."No.", UserId);
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
                        if not recApprSetup."Assembly Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Assembly Order", Rec."No.", UserId);
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
                        if not recApprSetup."Assembly Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Assembly Order", Rec."No.", UserId);
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
                        if not recApprSetup."Assembly Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Assembly Order", Rec."No.", UserId);
                    end;
                }
                action("Update")
                {
                    Caption = 'Update';
                    ApplicationArea = all;
                    Image = ResetStatus;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Assembly Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then
                            exit;

                        if not Confirm('Do you want to update it?\\You need to start approval process from the beginning after updated.') then
                            exit;

                        cuApprMgt.Update(enum::"Hagiwara Approval Data"::"Assembly Order", Rec."No.", UserId);
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
                        if not recApprSetup."Assembly Order" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Assembly Order");
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if recApprSetup."Assembly Order" then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                CurrPage.Editable(false);
            end else begin
                CurrPage.Editable(true);
            end;
        end;
        //N005 End

    end;

}
