page 50106 "Price List Import Batches"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    Caption = 'Price List Import Batches';
    SourceTable = "Price List Import Batch";

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
                field("No. of Price Lines"; Rec."No. of Price Lines")
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
                action("Price List Import Lines")
                {
                    ApplicationArea = all;
                    Image = EntriesList;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PriceListImportline: Record "Price List Import Line";
                        Pag_PriceListImportline: Page "Price List Import Lines";
                    begin
                        if Rec.Name = '' then begin
                            Error('Please select one record.');
                        end;

                        PriceListImportline.SetRange(PriceListImportline."Batch Name", Rec.Name);
                        Pag_PriceListImportline.SetTableView(PriceListImportline);
                        Pag_PriceListImportline.SetBatchName(Rec.Name);
                        Pag_PriceListImportline.RunModal();
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
                        PriceListImportline: Record "Price List Import Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Price List" then
                            exit;

                        if rec."Approval Status" in [
                            Enum::"Hagiwara Approval Status"::Submitted,
                            Enum::"Hagiwara Approval Status"::"Re-Submitted",
                            Enum::"Hagiwara Approval Status"::"Approved",
                            Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                            Error('This approval request can''t be sent because it''s sent or approved already.');

                        PriceListImportline.SetRange("Batch Name", Rec.Name);
                        PriceListImportline.SETFILTER(PriceListImportline.Status, '<>%1', PriceListImportline.Status::Validated);
                        if not PriceListImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Price List", Rec."Name", UserId);
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
                        PriceListImportline: Record "Price List Import Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Price List" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        /*
                        PriceListImportline.SetRange("Batch Name", Rec.Name);
                        PriceListImportline.SETFILTER(PriceListImportline.Status, '<>%1', PriceListImportline.Status::Validated);
                        if not PriceListImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;
                        */

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Price List", Rec."Name", UserId);
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
                        PriceListImportline: Record "Price List Import Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Price List" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        PriceListImportline.SetRange("Batch Name", Rec.Name);
                        PriceListImportline.SETFILTER(PriceListImportline.Status, '<>%1', PriceListImportline.Status::Validated);
                        if not PriceListImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Price List", Rec."Name", UserId);
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
                        PriceListImportline: Record "Price List Import Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Price List" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        /*
                        PriceListImportline.SetRange("Batch Name", Rec.Name);
                        PriceListImportline.SETFILTER(PriceListImportline.Status, '<>%1', PriceListImportline.Status::Validated);
                        if not PriceListImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;
                        */

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Price List", Rec."Name", UserId);
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
                        if not recApprSetup."Price List" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Price List");
                        recApprEntry.SetRange("No.", Rec."Name");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }
}
