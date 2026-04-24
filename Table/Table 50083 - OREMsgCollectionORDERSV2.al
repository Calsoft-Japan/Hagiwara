table 50083 "ORE Msg Collection ORDERS V2"
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
        field(34; "Direct Unit Cost"; Decimal)
        {
        }
        field(35; "Customer No."; Code[20])
        {
        }
        field(36; "Requested Receipt Date"; Date)
        {
        }
        field(37; "ORE Customer Name"; Text[35])
        {
        }
        field(38; "ORE Line No."; Integer)
        {
        }
        field(39; "Reverse Routing Address"; Code[40])
        {
        }
        field(40; "Sold-to Code"; Code[35])
        {
        }
        field(41; "Ship&Debit Flag"; Boolean)
        {
        }
        field(42; "RRA NULL Flag"; Text[10])
        {
        }
        field(43; "Renesas Category Code"; Code[20])
        {
        }
        field(44; "Report Sold-to Code"; Code[35])
        {
        }
        field(45; "ORE CPN"; Text[35])
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

