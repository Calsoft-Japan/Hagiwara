table 50054 "ORE Message Collection INVRPT"
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
            OptionCaption = 'Ready,Cancelled,Sent';
            OptionMembers = Ready,Cancelled,Sent;
        }
        field(10; "Sold-to Code"; Code[35])
        {
            Description = 'CS089';
        }
        field(11; "Ship-to Code"; Code[35])
        {
            Description = 'CS089';
        }
        field(12; "Ship-to Name"; Text[35])
        {
            Description = 'CS089';
        }
        field(13; "Ship-to Address"; Text[35])
        {
            Description = 'CS089';
        }
        field(14; "Ship-to City"; Text[35])
        {
            Description = 'CS089';
        }
        field(15; "Ship-to County"; Text[9])
        {
            Description = 'CS089';
        }
        field(16; "Ship-to Post Code"; Code[35])
        {
            Description = 'CS089';
        }
        field(17; "Ship-to Country"; Code[3])
        {
            Description = 'CS089';
        }
        field(18; "Ship-to Address2"; Text[35])
        {
            Description = 'CS089';
        }
        field(30; "Item No."; Code[20])
        {
            // cleaned
        }
        field(31; Description; Text[50])
        {
            // cleaned
        }
        field(32; Quantity; Decimal)
        {

        }
        field(33; "Cost Amount (Actual)"; Decimal)
        {

        }
        field(34; "ORE DBC Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Editable = false;
        }
        field(35; "ORE Customer Name"; Text[35])
        {
            // cleaned
        }
        field(36; "Original Item No."; Code[20])
        {
            // cleaned
        }
        field(37; "ORE Reverse Routing Address"; Code[40])
        {
            Description = 'CS073,CS103';
        }
    }
}
