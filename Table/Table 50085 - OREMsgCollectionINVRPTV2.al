table 50085 "ORE Msg Collection INVRPT V2"
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
        field(10; "Sold-to Code"; Code[35])
        {
        }
        field(11; "Ship-to Code"; Code[35])
        {
        }
        field(12; "Ship-to Name"; Text[35])
        {
        }
        field(13; "Ship-to Address"; Text[35])
        {
        }
        field(14; "Ship-to City"; Text[35])
        {
        }
        field(15; "Ship-to County"; Text[9])
        {
        }
        field(16; "Ship-to Post Code"; Code[35])
        {
        }
        field(17; "Ship-to Country"; Code[3])
        {
        }
        field(18; "Ship-to Address2"; Text[35])
        {
        }
        field(30; "Item No."; Code[20])
        {
        }
        field(31; Description; Text[50])
        {
        }
        field(32; Quantity; Decimal)
        {
        }
        field(34; "Inventory Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(35; "ORE Customer Name"; Text[35])
        {
        }
        field(36; "Original Item No."; Code[20])
        {
        }
        field(37; "Reverse Routing Address"; Code[40])
        {
        }
        field(38; "Currency Code"; Code[10])
        {
        }
        field(39; "Ship&Debit Flag"; Boolean)
        {
        }
        field(40; "RRA NULL Flag"; Text[10])
        {
        }
        field(41; "Renesas Category"; Code[20])
        {
        }
        field(42; "Company Category"; Option)
        {
            OptionCaption = ' ,PC,SC';
            OptionMembers = " ",PC,SC;
        }
        field(43; "Report Sold-to Code"; Code[35])
        {
        }
        field(44; "ORE CPN"; Text[35])
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

