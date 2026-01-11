pageextension 50393 ItemReclassJournalExt extends "Item Reclass. Journal"
{
    layout
    {
        addafter("Document No.")
        {

            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }

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

        addafter("Item No.")
        {
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Rank"; Rec."RANK")
            {
                ApplicationArea = all;
            }
            field("Parts No."; Rec."Parts No.")
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
                if (recApprSetup."Item Reclass Journal") then begin
                    //Why need this copy(Rec)?
                    //The lines to be post are possibly filtered (opened from approval email is also in this case).
                    //Make sure the lines to be checked are as same as what users see on the BC screen.
                    ItemJourLine.Copy(Rec);
                    ItemJourLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ItemJourLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if ItemJourLine.FindSet() then
                        repeat
                            if not (ItemJourLine."Approval Status" in
                                [Enum::"Hagiwara Approval Status"::"Not Applicable",
                                Enum::"Hagiwara Approval Status"::Approved,
                                Enum::"Hagiwara Approval Status"::"Auto Approved"
                                ]) then begin
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
                        ItemJourLine: Record "Item Journal Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        rec.TestField("Document No.");

                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        ItemJourLine.SetFilter("Approval Status", '<>%1', Enum::"Hagiwara Approval Status"::"Not Applicable");
                        if ItemJourLine.IsEmpty() then
                            Error('This approval request can''t be sent.');

                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        if ItemJourLine.FindSet() then
                            repeat
                                if rec."Approval Status" in [
                                    Enum::"Hagiwara Approval Status"::Submitted,
                                    Enum::"Hagiwara Approval Status"::"Re-Submitted",
                                    Enum::"Hagiwara Approval Status"::"Approved",
                                    Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                                    Error('This approval request can''t be sent because it''s sent or approved already.');

                            until ItemJourLine.Next() = 0;

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Item Reclass Journal", Rec."Document No.", UserId);
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
                        ItemJourLine: Record "Item Journal Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        rec.TestField("Document No.");

                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        if ItemJourLine.FindSet() then
                            repeat
                                if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                                    Error('This approval request can not be cancelled.');
                            until ItemJourLine.Next() = 0;


                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Item Reclass Journal", Rec."Document No.", UserId);
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
                        ItemJourLine: Record "Item Journal Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        rec.TestField("Document No.");

                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        if ItemJourLine.FindSet() then
                            repeat
                                if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                                    Error('This approval request can not be approved.');
                            until ItemJourLine.Next() = 0;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Item Reclass Journal", Rec."Document No.", UserId);
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
                        ItemJourLine: Record "Item Journal Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        rec.TestField("Document No.");

                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        if ItemJourLine.FindSet() then
                            repeat
                                if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                                    Error('This approval request can not be rejected.');
                            until ItemJourLine.Next() = 0;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Item Reclass Journal", Rec."Document No.", UserId);
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
                        ItemJourLine: Record "Item Journal Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        rec.TestField("Document No.");

                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        if ItemJourLine.FindSet() then
                            repeat
                                if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then
                                    exit;
                            until ItemJourLine.Next() = 0;

                        if not Confirm('Do you want to update it?\\You need to start approval process from the beginning after updated.') then
                            exit;

                        cuApprMgt.Update(enum::"Hagiwara Approval Data"::"Item Reclass Journal", Rec."Document No.", UserId);
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
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        rec.TestField("Document No.");

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Item Reclass Journal");
                        recApprEntry.SetRange("No.", Rec."Document No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }

}