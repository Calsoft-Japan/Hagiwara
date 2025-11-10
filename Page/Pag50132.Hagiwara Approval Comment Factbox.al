page 50132 "Hagiwara Approval Comment FB"
{
    Caption = 'Approval Comment';
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = CardPart;
    SourceTable = "Hagiwara Approval Entry";

    layout
    {
        area(Content)
        {
            group("Comment")
            {
                Caption = 'Comment';
                field(Msg; Rec.GetComment())
                {
                    Caption = '';
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }
}
