page 50117 "Item Import Batch"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    Caption = 'Item Import Batch';
    SourceTable = "Item Import Batch";

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
                field(Approver; Rec.Approver)
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
                    begin
                        if Rec.Name = '' then begin
                            Error('Please select one record.');
                        end;

                        ItemImportline.SetRange(ItemImportline."Batch Name", Rec.Name);
                        Page.RunModal(Page::"Item Import Lines", ItemImportline);
                    end;
                }
            }
        }
    }
}
