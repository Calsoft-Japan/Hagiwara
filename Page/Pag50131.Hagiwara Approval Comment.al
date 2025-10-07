page 50131 "Hagiwara Approval Comment"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = Card;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Title; TitleText)
                {
                    ApplicationArea = all;
                }
                field(Msg; MsgText)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        TitleText: Text;
        MsgText: BigText;

}
