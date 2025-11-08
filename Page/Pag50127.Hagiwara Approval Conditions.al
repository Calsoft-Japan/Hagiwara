page 50127 "Hagiwara Approval Conditions"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Approval Condition";

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
                field("Approval Group Code"; Rec."Approval Group Code")
                {
                    ApplicationArea = all;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Margin %"; Rec."Margin %")
                {
                    ApplicationArea = all;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

