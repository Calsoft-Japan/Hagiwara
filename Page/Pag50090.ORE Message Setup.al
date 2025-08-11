page 50090 "ORE Message Setup"
{
    // CS060 Shawn 2024/03/09 - Page name optimized.

    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ORE Message Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field("Message Name"; REC."Message Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Cycle; Rec.Cycle)
                {
                }
            }
        }
    }

    actions
    {
    }
}

