page 50113 "Vendor Import Batches"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    Caption = 'Vendor Import Batches';
    SourceTable = "Vendor Import Batch";

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
                field("No. of Vendors"; Rec."No. of Vendors")
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
                action("Vendor Import Lines")
                {
                    ApplicationArea = all;
                    Image = EntriesList;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        VendorImportline: Record "Vendor Import Line";
                        Pag_VendorImportline: Page "Vendor Import Lines";
                    begin
                        if Rec.Name = '' then begin
                            Error('Please select one record.');
                        end;

                        VendorImportline.SetRange(VendorImportline."Batch Name", Rec.Name);
                        Pag_VendorImportline.SetTableView(VendorImportline);
                        Pag_VendorImportline.SetBatchName(Rec.Name);
                        Pag_VendorImportline.RunModal();
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
                        VendorImportline: Record "Vendor Import Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Vendor" then
                            exit;

                        if rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then
                            Error('This approval request can''t be sent because it''s sent already.');

                        VendorImportline.SetRange("Batch Name", Rec.Name);
                        VendorImportline.SETFILTER(VendorImportline.Status, '<>%1', VendorImportline.Status::Validated);
                        if not VendorImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Vendor", Rec."Name", UserId);
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
                        VendorImportline: Record "Vendor Import Line";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Vendor" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        VendorImportline.SetRange("Batch Name", Rec.Name);
                        VendorImportline.SETFILTER(VendorImportline.Status, '<>%1', VendorImportline.Status::Validated);
                        if not VendorImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Vendor", Rec."Name", UserId);
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
                        VendorImportline: Record "Vendor Import Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Vendor" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        VendorImportline.SetRange("Batch Name", Rec.Name);
                        VendorImportline.SETFILTER(VendorImportline.Status, '<>%1', VendorImportline.Status::Validated);
                        if not VendorImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Vendor", Rec."Name", UserId);
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
                        VendorImportline: Record "Vendor Import Line";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Vendor" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        VendorImportline.SetRange("Batch Name", Rec.Name);
                        VendorImportline.SETFILTER(VendorImportline.Status, '<>%1', VendorImportline.Status::Validated);
                        if not VendorImportline.IsEmpty() then begin
                            Error('All Lines of Batch %1 should be validated.', Rec.Name);
                        end;

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Vendor", Rec."Name", UserId);
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
                        if not recApprSetup."Vendor" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Vendor");
                        recApprEntry.SetRange("No.", Rec."Name");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }
}
