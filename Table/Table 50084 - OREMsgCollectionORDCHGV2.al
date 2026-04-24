table 50084 "ORE Msg Collection ORDCHG V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "History Entry No."; Integer)
        {
        }
        field(3; "Message Status"; Option)
        {
            OptionCaption = 'Ready,Cancelled,Sent';
            OptionMembers = Ready,Cancelled,Sent;
            TableRelation = "ORE Message History V2"."Message Status" WHERE("Entry No." = FIELD("History Entry No."));
        }
        field(4; "Action Type"; Option)
        {
            OptionCaption = 'Added,Deleted,Changed';
            OptionMembers = Added,Deleted,Changed;
        }
        field(9; "Message Name"; Code[10])
        {
            CalcFormula = Lookup("ORE Message History V2"."Message Name" WHERE("Entry No." = FIELD("History Entry No.")));
            FieldClass = FlowField;
        }
        field(10; "Order No."; Code[20])
        {
        }
        field(11; "Order Date"; Date)
        {
        }
        field(12; "Ship-to Code"; Code[50])
        {
        }
        field(13; "Currency Code"; Code[10])
        {
        }
        field(30; "Line No."; Integer)
        {
        }
        field(31; "Item No."; Code[20])
        {
        }
        field(32; Description; Text[50])
        {
        }
        field(33; Quantity; Decimal)
        {
        }
        field(34; "Requested Receipt Date"; Date)
        {
        }
        field(35; "ORE Line No."; Integer)
        {
        }
        field(36; "Reverse Routing Address"; Code[40])
        {
        }
        field(37; "Sold-to Code"; Code[35])
        {
        }
        field(38; "Ship&Debit Flag"; Boolean)
        {
        }
        field(39; "RRA NULL Flag"; Text[10])
        {
        }
        field(40; "Renesas Category Code"; Code[20])
        {
        }
        field(41; "Report Sold-to Code"; Code[35])
        {
        }
        field(42; "ORE CPN"; Text[35])
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
}

