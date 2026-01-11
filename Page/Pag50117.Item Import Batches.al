page 50117 "Item Import Batch"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    Caption = 'Item Import Batches';
    SourceTable = "Item Import Batch";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("No. of Items"; Rec."No. of Items")
                {
                    ApplicationArea = all;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = all;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = all;
                }
                field(Approver; Rec."Hagi Approver")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Purchase)
            {
                action("Delete")
                {
                    ApplicationArea = All;
                    Caption = 'Delete';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        ItemImportline: Record "Item Import Line";
                    begin


                        recApprSetup.Get();
                        if recApprSetup."Item" then begin
                            if not (Rec."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t delete this record because approval process already initiated.');
                            end;
                        end;

                        //Delete Item Import Line
                        ItemImportline.SetRange("Batch Name", Rec.Name);
                        ItemImportline.DeleteAll();

                        //Delete Item Import Batch
                        Rec.Delete();
                    end;
                }
                action("Item Import Lines")
                {
                    ApplicationArea = all;
                    Image = EntriesList;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ItemImportline: Record "Item Import Line";
                        Pag_ItemImportline: Page "Item Import Lines";
                    begin
                        if Rec.Name = '' then begin
                            Error('Please select one record.');
                        end;

                        ItemImportline.SetRange(ItemImportline."Batch Name", Rec.Name);
                        Pag_ItemImportline.SetTableView(ItemImportline);
                        Pag_ItemImportline.SetBatchName(Rec.Name);
                        Pag_ItemImportline.RunModal();
                    end;
                }
            }
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
                        ItemImportline: Record "Item Import Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Item" then
                            exit;

                        if rec."Approval Status" in [
                            Enum::"Hagiwara Approval Status"::"Not Applicable",
                            Enum::"Hagiwara Approval Status"::Submitted,
                            Enum::"Hagiwara Approval Status"::"Re-Submitted",
                            Enum::"Hagiwara Approval Status"::"Approved",
                            Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                            Error('This approval request can''t be sent because it''s sent or approved already.');

                        ItemImportline.SetRange("Batch Name", Rec.Name);
                        ItemImportline.SETFILTER(ItemImportline.Status, '<>%1', ItemImportline.Status::Validated);
                        if not ItemImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Item", Rec."Name", UserId);
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
                        ItemImportline: Record "Item Import Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Item" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        ItemImportline.SetRange("Batch Name", Rec.Name);
                        ItemImportline.SETFILTER(ItemImportline.Status, '<>%1', ItemImportline.Status::Validated);
                        if not ItemImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Item", Rec."Name", UserId);
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
                        ItemImportline: Record "Item Import Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        ItemImportline.SetRange("Batch Name", Rec.Name);
                        ItemImportline.SETFILTER(ItemImportline.Status, '<>%1', ItemImportline.Status::Validated);
                        if not ItemImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Item", Rec."Name", UserId);
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
                        ItemImportline: Record "Item Import Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Item" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        ItemImportline.SetRange("Batch Name", Rec.Name);
                        ItemImportline.SETFILTER(ItemImportline.Status, '<>%1', ItemImportline.Status::Validated);
                        if not ItemImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Item", Rec."Name", UserId);
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
                        if not recApprSetup."Item" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Item");
                        recApprEntry.SetRange("No.", Rec."Name");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }
}
