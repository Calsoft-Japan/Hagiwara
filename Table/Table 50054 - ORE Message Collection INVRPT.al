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
            TableRelation = "ORE Message History"."Message Status" WHERE("Entry No." = FIELD("History Entry No."));
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

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        GenSetup: Record "General Ledger Setup";
    begin
        GenSetup.GET();
        "Sold-to Code" := GenSetup."Sold-to Code";
        "Ship-to Code" := GenSetup."Ship-to Code";
        "Ship-to Name" := GenSetup."Ship-to Name";
        "Ship-to Address" := GenSetup."Ship-to Address";
        "Ship-to Address2" := GenSetup."Ship-to Address2";
        "Ship-to City" := GenSetup."Ship-to City";
        "Ship-to County" := GenSetup."Ship-to County";
        "Ship-to Post Code" := GenSetup."Ship-to Post Code";
        "Ship-to Country" := GenSetup."Ship-to Country/Region Code";
    end;
}
