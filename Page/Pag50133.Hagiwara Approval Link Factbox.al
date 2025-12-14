page 50133 "Hagiwara Approval Link FB"
{
    Caption = 'Approval Link';
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = CardPart;
    SourceTable = "Hagiwara Approval Entry";

    layout
    {
        area(Content)
        {
            group("Link")
            {
                Caption = 'Link';
                field(LinkText; Rec.Link)
                {
                    Caption = '';
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }
}
