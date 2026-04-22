page 50097 "ORE CPN Setup"
{
    // CS116 Shawn 2026/04/05 - One Renesas EDI V2

    PageType = List;
    SourceTable = "ORE CPN Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(CPN; Rec.CPN)
                {
                }
            }
        }
    }

    actions
    {
    }
}

