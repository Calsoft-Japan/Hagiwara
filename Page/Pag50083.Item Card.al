page 50083 "Product Group"
{
    ApplicationArea = All;
    Caption = 'Product Group';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Item Group";

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
                field(Description; Rec.Description)
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

