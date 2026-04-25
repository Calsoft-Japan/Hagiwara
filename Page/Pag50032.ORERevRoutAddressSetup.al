page 50032 "ORE Rev. Rout. Address Setup"
{
    // CS116 Shawn 2025/12/29 One Renesas EDI V2

    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ORE Rev. Rout. Address Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order Reverse Routing Address"; Rec."Order Reverse Routing Address")
                {
                }
                field("Report Reverse Routing Address"; Rec."Report Reverse Routing Address")
                {
                }
                field("Sold-to Code"; Rec."Sold-to Code")
                {
                }
                field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
                {
                }
                field("Renesas Category Code"; Rec."Renesas Category Code")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Report Sold-to Code"; Rec."Report Sold-to Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

