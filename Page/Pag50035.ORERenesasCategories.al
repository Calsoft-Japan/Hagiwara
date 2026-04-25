page 50035 "ORE Renesas Categories"
{
    // CS116 Shawn 2025/12/29 One Renesas EDI V2

    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ORE Renesas Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

