report 50024 "Cancel Message"
{
    Permissions = TableData 110 = rimd,
                  TableData 111 = rimd,
                  TableData 120 = rimd,
                  TableData 121 = rimd;
    ProcessingOnly = true;

    dataset
    {
    }

    procedure CancelMessage(pMessageCtrl: Record "Message Control")
    var
        myInt: Integer;
    begin

    end;

}

