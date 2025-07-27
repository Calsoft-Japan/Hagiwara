page 50011 "Message Setup"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Message Setup';
    Editable = true;
    PageType = List;
    SourceTable = "Message Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Cycle; Rec.Cycle)
                {
                    ApplicationArea = all;
                }
                field(Combine; Rec.Combine)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

