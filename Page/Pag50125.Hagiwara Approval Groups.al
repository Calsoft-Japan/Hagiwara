page 50125 "Hagiwara Approval Groups"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Approval Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

