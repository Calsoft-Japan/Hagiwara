pageextension 50040 ItemJournalExt extends "Item Journal"
{
    layout
    {
        addafter("Description")
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
        }

    }

    actions
    {
        modify("Post")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
                ItemJourLine: Record "Item Journal Line";
            begin
                recApprSetup.Get();
                if (recApprSetup."Item Journal") then begin
                    //Why need this copy(Rec)?
                    //The lines to be post are possibly filtered (opened from approval email is also in this case).
                    //Make sure the lines to be checked are as same as what users see on the BC screen.
                    ItemJourLine.Copy(Rec);
                    ItemJourLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJourLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if ItemJourLine.FindSet() then
                        repeat
                            if not (ItemJourLine."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                                Error('All lines need to be approved.');
                            end;
                        until ItemJourLine.Next() = 0;

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
                        if not recApprSetup."Item Journal" then
                            exit;

                        if rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then
                            Error('This approval request can''t be sent because it''s sent already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
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
                        if not recApprSetup."Item Journal" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
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
                        if not recApprSetup."Item Journal" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
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
                        if not recApprSetup."Item Journal" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
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
                        if not recApprSetup."Item Journal" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Item Journal");
                        recApprEntry.SetRange("No.", Rec."Document No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }

}
