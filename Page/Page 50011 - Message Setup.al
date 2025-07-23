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
                }
                field(Description; Rec.Description)
                {
                }
                field(Cycle; Rec.Cycle)
                {
                }
                field(Combine; Rec.Combine)
                {
                }
            }
        }
    }

    actions
    {
    }
}

