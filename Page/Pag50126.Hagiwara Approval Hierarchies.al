page 50126 "Hagiwara Approval Hierarchies"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Approval Hierarchy";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Approval Group Code"; Rec."Approval Group Code")
                {
                    ApplicationArea = all;
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = all;
                }
                field("Approver User Name"; Rec."Approver User Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

