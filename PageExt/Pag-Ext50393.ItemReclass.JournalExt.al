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
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        if rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then
                            Error('This approval request can''t be sent because it''s sent already.');

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
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

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
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

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
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item Reclass Journal" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Item Reclass Journal", Rec."Document No.", UserId);
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

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Item Reclass Journal");
                        recApprEntry.SetRange("No.", Rec."Document No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
        recLocation: Record Location;
    begin

        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Item Reclass Journal") then begin
            if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then begin
                Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
            end;

            //check if location is approval target.
            if (xRec."New Location Code" <> Rec."New Location Code") then begin
                if (Rec."New Location Code" <> '')
                and (recLocation.Get(Rec."New Location Code"))
                and (not recLocation."Approval Target") then begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
                end else begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
                end;
            end;
        end;

        //N005 End

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
        recLocation: Record Location;
    begin

        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Item Reclass Journal") then begin
            ItemJourLine.SetRange("Document No.", Rec."Document No.");
            ItemJourLine.SetFilter("Approval Status", '%1|%2', Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted");
            if Not ItemJourLine.IsEmpty then begin
                Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
            end;

            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;

            //check if location is approval target.
            if recLocation.Get(Rec."New Location Code") then begin
                if not recLocation."Approval Target" then begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
                end;
            end;

        end;
        //N005 End

    end;

    trigger OnDeleteRecord(): Boolean
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Item Reclass Journal") then begin
            if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then begin
                Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
            end;
        end;
        //N005 End

    end;

}