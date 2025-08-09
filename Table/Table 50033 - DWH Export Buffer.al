table 50033 "DWH Export Buffer"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Data Name"; Text[50])
        {

        }
        field(3; "Data"; Blob)
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
        Clear(Data);
        Data.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewData);
        Modify();
    end;

    procedure GetData() DataText: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(Data);
        Data.CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName(Data)));
    end;
}
