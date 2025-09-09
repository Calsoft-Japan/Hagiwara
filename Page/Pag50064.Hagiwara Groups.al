page 50064 "Hagiwara Groups"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Hagiwara Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

