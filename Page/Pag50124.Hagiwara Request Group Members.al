page 50124 "Hagiwara Request Group Members"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Request Group Member";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Data; Rec.Data)
                {
                    ApplicationArea = all;
                }
                field("Request Group Code"; Rec."Request Group Code")
                {
                    ApplicationArea = all;
                }
                field("Request User Name"; Rec."Request User Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

