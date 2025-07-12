table 50051 "ORE Message History"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Running No."; Code[10])
        {
            // cleaned
        }
        field(3; "Report Start Date"; Date)
        {
            // cleaned
        }
        field(4; "Report End Date"; Date)
        {

        }
        field(10; "Message Name"; Code[10])
        {

        }
        field(11; "Reverse Routing Address"; Code[40])
        {
            Caption = 'ORE Reverse Routing Address (NoneSD)';
            Description = 'CS103';
        }
        field(12; "Message Status"; Option)
        {
            OptionCaption = 'Ready,Cancelled,Sent';
            OptionMembers = Ready,Cancelled,Sent;
        }
        field(13; "Reverse Routing Address (SD)"; Code[40])
        {
            Caption = 'ORE Reverse Routing Address (SD)';
            Description = 'CS073,CS103';
        }
        field(20; "Collected By"; Code[50])
        {
            // cleaned
        }
        field(21; "Collected On"; DateTime)
        {
            // cleaned
        }
        field(30; "Cancelled By"; Code[50])
        {
            // cleaned
        }
        field(31; "Cancelled On"; DateTime)
        {
            // cleaned
        }
        field(40; "File Sent By"; Code[50])
        {
            // cleaned
        }
        field(41; "File Sent On"; DateTime)
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Reverse Routing Address", "Message Name")
        {
        }
    }

    fieldgroups
    {
    }
}
