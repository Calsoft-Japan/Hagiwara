page 50131 "Hagiwara Approval Comment"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group("Approval Data")
            {
                Caption = 'Approval Data';
                field(Data; Format(Data))
                {
                    Caption = 'Data';
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Data No"; DataNo)
                {
                    Caption = 'Data No.';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            group("Comment")
            {
                Caption = 'Comment';
                field(Msg; MsgText)
                {
                    Importance = Promoted;
                    Caption = 'Comment';
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
            group("Link")
            {
                field(LinkText; LinkText)
                {
                    Importance = Promoted;
                    Visible = LinkVisible;
                    Caption = 'Link';
                    ApplicationArea = all;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if StrLen(LinkText) > 2048 then begin
                            Error('Link is over maximum length (2048).');
                        end;
                    end;
                }
            }
        }
    }

    var
        Data: Enum "Hagiwara Approval Data";
        DataNo: Code[20];
        TitleText: Text;
        MsgText: Text;
        LinkText: Text;
        LinkVisible: Boolean;


    procedure SetData(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20])
    begin
        Data := pData;
        DataNo := pDataNo;

    end;

    procedure GetComment(): Text
    begin
        exit(MsgText);

    end;

    procedure ShowLink(pShowLink: Boolean)
    begin
        LinkVisible := pShowLink;
    end;

    procedure GetLink(): Text
    begin
        exit(LinkText);
    end;

}
