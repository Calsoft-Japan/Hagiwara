page 50123 "Hagiwara Request Groups"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Request Group";

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

