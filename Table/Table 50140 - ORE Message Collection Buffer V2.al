table 50140 "ORE Msg Collection Buffer V2"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "ORE Msg Hist Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Message Name"; Code[10])
        {

        }
        field(6; "File Name"; Text[250])
        {

        }
        field(7; "Message"; Blob)
        {
        }
    }


    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetData(NewData: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Message);
        Message.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewData);
        Modify();
    end;

    procedure GetData() DataText: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Message);
        Message.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Message)));
    end;
}
