page 50128 "Hagiwara Approval Substitution"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Hagiwara Approval Substitutions';
    PageType = List;
    SourceTable = "Hagiwara Approval Substitution";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Approver User Name"; Rec."Approver User Name")
                {
                    ApplicationArea = all;
                }
                field("Substitution User Name"; Rec."Substitution User Name")
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

