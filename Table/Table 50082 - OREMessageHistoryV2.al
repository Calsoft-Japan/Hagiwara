table 50082 "ORE Message History V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Running No."; Code[10])
        {
        }
        field(3; "Report Start Date"; Date)
        {
        }
        field(4; "Report End Date"; Date)
        {

            trigger OnLookup()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
            end;
        }
        field(10; "Message Name"; Code[10])
        {

            trigger OnValidate()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
                Vendor: Record "Item";
            begin
            end;
        }
        field(12; "Message Status"; Option)
        {
            OptionCaption = 'Ready,Cancelled,Sent';
            OptionMembers = Ready,Cancelled,Sent;
        }
        field(20; "Collected By"; Code[50])
        {
        }
        field(21; "Collected On"; DateTime)
        {
        }
        field(30; "Cancelled By"; Code[50])
        {
        }
        field(31; "Cancelled On"; DateTime)
        {
        }
        field(40; "File Sent By"; Code[50])
        {
        }
        field(41; "File Sent On"; DateTime)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Collected By" := USERID;
        "Collected On" := CURRENTDATETIME;
        //"Cancelled By" := USERID;
        //"Cancelled On" := CURRENTDATETIME;
        //"File Sent By" := USERID;
        //"File Sent On" := CURRENTDATETIME;
    end;
}

