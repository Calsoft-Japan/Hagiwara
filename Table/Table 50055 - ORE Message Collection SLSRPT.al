table 50055 "ORE Message Collection SLSRPT"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "History Entry No."; Integer)
        {
            TableRelation = "ORE Message History"."Entry No." WHERE("Entry No." = FIELD("History Entry No."));
            // cleaned
        }
        field(3; "Message Status"; Option)
        {
            TableRelation = "ORE Message History"."Message Status" WHERE("Entry No." = FIELD("History Entry No."));
            OptionCaption = 'Ready,Cancelled,Sent';
            OptionMembers = Ready,Cancelled,Sent;
        }
        field(10; "Transaction Type"; Code[20])
        {
            // cleaned
        }
        field(11; "Transaction Type Code"; Code[10])
        {
            // cleaned
        }
        field(12; "Transaction No."; Code[20])
        {
            // cleaned
        }
        field(13; "Transaction Date"; Date)
        {
            // cleaned
        }
        field(14; "External Document No."; Code[35])
        {
            // cleaned
        }
        field(15; "Sell-to Customer No."; Code[20])
        {
            // cleaned
        }
        field(16; "Sell-to Customer ORE Name"; Text[35])
        {
            // cleaned
        }
        field(17; "Sell-to Cust. ORE Address 1"; Text[35])
        {
            // cleaned
        }
        field(18; "Sell-to Cust. ORE Address 2"; Text[35])
        {
            // cleaned
        }
        field(19; "Sell-to ORE City"; Text[35])
        {
            // cleaned
        }
        field(20; "Sell-to ORE State/Province"; Text[35])
        {
            // cleaned
        }
        field(21; "Sell-to Post Code"; Code[20])
        {
            // cleaned
        }
        field(22; "Sell-to Country/Region Code"; Code[10])
        {
            // cleaned
        }
        field(23; "Currency Code"; Code[10])
        {
            // cleaned
        }
        field(24; "Sell-to ORE Country"; Code[3])
        {
            Description = 'CS089';
        }
        field(25; "Sell-to Customer SCM Code"; Code[13])
        {
            Description = 'CS089';
        }
        field(30; "Line No."; Integer)
        {
            // cleaned
        }
        field(40; "Item No."; Code[20])
        {
            // cleaned
        }
        field(41; Description; Text[50])
        {
            // cleaned
        }
        field(42; Quantity; Decimal)
        {
            // cleaned
        }
        field(43; "Unit Price"; Decimal)
        {
            // cleaned
        }
        field(44; "ORE Debit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(45; "ORE DBC Cost"; Decimal)
        {
            // cleaned
        }
        field(60; "OEM No."; Code[20])
        {
            // cleaned
        }
        field(61; "OEM ORE Name"; Text[35])
        {
            // cleaned
        }
        field(62; "OEM ORE Address 1"; Text[35])
        {
            // cleaned
        }
        field(63; "OEM ORE Address 2"; Text[35])
        {
            // cleaned
        }
        field(64; "OEM ORE City"; Text[35])
        {
            // cleaned
        }
        field(65; "OEM ORE State/Province"; Text[35])
        {
            // cleaned
        }
        field(66; "OEM Post Code"; Code[20])
        {
            // cleaned
        }
        field(67; "OEM Country/Region Code"; Code[10])
        {
            // cleaned
        }
        field(68; "OEM ORE Country"; Code[3])
        {
            Description = 'CS089';
        }
        field(69; "OEM SCM Code"; Code[13])
        {
            Description = 'CS089';
        }
        field(70; "Sold-to Code"; Code[35])
        {
            Description = 'CS089';
        }
        field(71; "Vendor No."; Code[20])
        {
            // cleaned
        }
        field(72; "Purchase Currency Code"; Code[10])
        {
            // cleaned
        }
        field(73; "ORE Reverse Routing Address"; Code[40])
        {
            Description = 'CS073,CS103';
        }
        field(74; "Original Document No."; Code[20])
        {
            Caption = 'Original Document No.';
            Description = 'CR30';
        }
        field(75; "Original Document Line No."; Integer)
        {
            Caption = 'Original Document Line No.';
            Description = 'CR30';
        }
        field(76; "Renesas Report Unit Price"; Decimal)
        {
            Description = 'CS089';
        }
        field(77; "Renesas Report Unit Price Cur."; Code[10])
        {
            Description = 'CS089';
        }
        field(78; "Original Item No."; Code[20])
        {
            Description = 'CS089';
        }
    }
}
