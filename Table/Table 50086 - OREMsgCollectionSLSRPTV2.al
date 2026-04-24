table 50086 "ORE Msg Collection SLSRPT V2"
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
            TableRelation = "ORE Message History V2"."Entry No." WHERE("Entry No." = FIELD("History Entry No."));
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
        field(10; "Transaction Type"; Code[20])
        {
        }
        field(11; "Transaction Type Code"; Code[10])
        {
        }
        field(12; "Document No."; Code[20])
        {
        }
        field(13; "Transaction Date"; Date)
        {
        }
        field(14; "External Document No."; Code[35])
        {
        }
        field(15; "Sell-to Customer No."; Code[20])
        {
        }
        field(16; "Sell-to Customer ORE Name"; Text[35])
        {
        }
        field(17; "Sell-to Cust. ORE Address 1"; Text[35])
        {
        }
        field(18; "Sell-to Cust. ORE Address 2"; Text[35])
        {
        }
        field(19; "Sell-to ORE City"; Text[35])
        {
        }
        field(20; "Sell-to ORE State/Province"; Text[35])
        {
        }
        field(21; "Sell-to Post Code"; Code[20])
        {
        }
        field(22; "Sell-to Country/Region Code"; Code[10])
        {
        }
        field(23; "Currency Code"; Code[10])
        {
        }
        field(24; "Sell-to ORE Country"; Code[3])
        {
        }
        field(25; "Sell-to Customer SCM Code"; Code[13])
        {
        }
        field(30; "Line No."; Integer)
        {
        }
        field(31; "Sub Line No."; Integer)
        {
        }
        field(40; "Item No."; Code[20])
        {
        }
        field(41; Description; Text[50])
        {
        }
        field(42; Quantity; Decimal)
        {
        }
        field(43; "Unit Price"; Decimal)
        {
        }
        field(44; "Inventory Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(45; "ORE DBC Cost"; Decimal)
        {
        }
        field(60; "OEM No."; Code[20])
        {
        }
        field(61; "OEM ORE Name"; Text[35])
        {
        }
        field(62; "OEM ORE Address 1"; Text[35])
        {
        }
        field(63; "OEM ORE Address 2"; Text[35])
        {
        }
        field(64; "OEM ORE City"; Text[35])
        {
        }
        field(65; "OEM ORE State/Province"; Text[35])
        {
        }
        field(66; "OEM Post Code"; Code[20])
        {
        }
        field(67; "OEM Country/Region Code"; Code[10])
        {
        }
        field(68; "OEM ORE Country"; Code[3])
        {
        }
        field(69; "OEM SCM Code"; Code[13])
        {
        }
        field(70; "Sold-to Code"; Code[35])
        {
        }
        field(71; "Vendor No."; Code[20])
        {
        }
        field(72; "Purchase Currency Code"; Code[10])
        {
        }
        field(73; "Reverse Routing Address"; Code[40])
        {
        }
        field(74; "Original Document No."; Code[20])
        {
            Caption = 'Original Document No.';
        }
        field(75; "Original Document Line No."; Integer)
        {
            Caption = 'Original Document Line No.';
        }
        field(76; "Renesas Report Unit Price"; Decimal)
        {
        }
        field(77; "Renesas Report Unit Price Cur."; Code[10])
        {
        }
        field(78; "Original Item No."; Code[20])
        {
        }
        field(79; "Original Document Sub Line No."; Integer)
        {
        }
        field(80; "Ship&Debit Flag"; Boolean)
        {
        }
        field(81; "RRA NULL Flag"; Text[10])
        {
        }
        field(82; "Renesas Category"; Code[20])
        {
        }
        field(83; "Company Category"; Option)
        {
            OptionCaption = ' ,PC,SC';
            OptionMembers = " ",PC,SC;
        }
        field(84; "Report Sold-to Code"; Code[35])
        {
        }
        field(85; "ORE CPN"; Text[35])
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

