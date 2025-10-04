page 50122 "Hagiwara Approver E-Signature"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Approver E-Signature";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = all;
                }
                field("E-Signature"; Rec."E-Signature")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

