table 50053 "ORE Message Collection ORDCHG"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "History Entry No."; Integer)
        {
            // cleaned
        }
        field(3; "Message Status"; Option)
        {
            TableRelation = "ORE Message History"."Message Status" WHERE("Entry No." = FIELD("History Entry No."));
            OptionCaption = 'Ready,Cancelled,Sent';
            OptionMembers = Ready,Cancelled,Sent;
        }
        field(4; "Action Type"; Option)
        {
            OptionCaption = 'Added,Deleted,Changed';
            OptionMembers = Added,Deleted,Changed;
        }
        field(10; "Order No."; Code[20])
        {
            // cleaned
        }
        field(11; "Order Date"; Date)
        {
            // cleaned
        }
        field(12; "Ship-to Code"; Code[50])
        {
            // cleaned
        }
        field(30; "Line No."; Integer)
        {
            // cleaned
        }
        field(31; "Item No."; Code[20])
        {
            // cleaned
        }
        field(32; Description; Text[50])
        {
            // cleaned
        }
        field(33; Quantity; Decimal)
        {
            // cleaned
        }
        field(34; "Requested Receipt Date"; Date)
        {
            // cleaned
        }
        field(35; "ORE Line No."; Integer)
        {
            // cleaned
        }
        field(36; "ORE Reverse Routing Address"; Code[40])
        {
            Description = 'CS073,CS103';
        }
    }
}
