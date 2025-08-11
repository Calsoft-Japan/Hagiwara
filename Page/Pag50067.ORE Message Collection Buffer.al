page 50067 "ORE Message Collection Buffer"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Maintenance,Revision';
    SourceTable = "ORE Message Collection Buffer";

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
                field("ORE Msg Hist Entry No."; Rec."ORE Msg Hist Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Message Name"; Rec."Message Name")
                {
                    ApplicationArea = all;
                }
                field("Reverse Routing Address"; Rec."Reverse Routing Address")
                {
                    ApplicationArea = all;
                }
                field("Reverse Routing Address (SD)"; Rec."Reverse Routing Address (SD)")
                {
                    ApplicationArea = all;
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = all;
                }
                field(Message; DataText)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DataText := Rec.GetData();
    end;

    var
        DataText: Text;
}

