page 50033 "DWH Export Buffer"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Maintenance,Revision';
    SourceTable = "DWH Export Buffer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Data Name"; Rec."Data Name")
                {
                    ApplicationArea = all;
                }
                field(Data; DataText)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Process")
            {
                Caption = 'Process';
                Image = Line;
                action("Export All")
                {
                    Caption = 'Export All';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        cuDwhExport: Codeunit "DWH Export";
                    begin
                        if Confirm('Do you want to export all records?') then
                            cuDwhExport.Run();

                    end;
                }
                action("Delete All")
                {
                    Caption = 'Delete All';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        cuDwhExport: Codeunit "DWH Export";
                    begin
                        if Confirm('Do you want to delete all records?') then
                            cuDwhExport.DeleteDataInBuffer();
                    end;
                }
            }

        }
    }


    trigger OnAfterGetRecord()
    var
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
    begin
        DataText := Rec.GetData();
    end;

    var
        DataText: Text;
}

