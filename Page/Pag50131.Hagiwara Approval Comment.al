page 50131 "Hagiwara Approval Comment"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Data; Format(Data))
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("Data No"; DataNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Msg; MsgText)
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
            }
        }
    }

    var
        Data: Enum "Hagiwara Approval Data";
        DataNo: Code[20];
        TitleText: Text;
        MsgText: BigText;


    procedure SetData(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20])
    begin
        Data := pData;
        DataNo := pDataNo;

    end;

    procedure GetComment(): BigText
    begin
        exit(MsgText);

    end;



}
