table 50129 "Hagiwara Approval Entry"
{

    fields
    {

        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Data; Enum "Hagiwara Approval Data")
        {
        }
        field(3; "No."; Code[20])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }
        field(4; "Requester"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(5; "Request Group"; Code[30])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }
        field(6; "Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(7; "Approval Group"; Code[30])
        {
            TableRelation = "Hagiwara Approval Group".Code;
        }
        field(8; "Approval Sequence No."; Integer)
        {
        }
        field(9; "Request Date"; Date)
        {

        }
        field(10; Status; Enum "Hagiwara Approval Status")
        {
        }
        field(11; Comment; Blob)
        {
        }
        field(12; Open; Boolean)
        {
            InitValue = true;
        }
        field(13; "Close Date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    procedure AddComment(pComment: BigText)
    var
        OutStream: OutStream;
    begin
        Comment.CreateOutStream(OutStream);
        OutStream.Write(pComment);
        Modify();
    end;

    procedure GetComment() CommentText: BigText
    var
        InStream: InStream;
    begin
        CalcFields(Comment);
        Comment.CreateInStream(InStream, TEXTENCODING::UTF8);
        CommentText.Read(InStream);
        exit(CommentText);
    end;
}

