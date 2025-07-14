table 50052 "ORE Message Collection ORDERS"
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
        field(13; "Currency Code"; Code[10])
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
        field(34; "Direct Unit Cost"; Decimal)
        {
            // cleaned
        }
        field(35; "Customer No."; Code[20])
        {
            // cleaned
        }
        field(36; "Requested Receipt Date"; Date)
        {
            // cleaned
        }
        field(37; "ORE Customer Name"; Text[35])
        {
            // cleaned
        }
        field(38; "ORE Line No."; Integer)
        {
            // cleaned
        }
        field(39; "ORE Reverse Routing Address"; Code[40])
        {
            Description = 'CS073,CS103';
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
}
