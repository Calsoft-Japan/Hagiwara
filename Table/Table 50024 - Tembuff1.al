table 50024 Tembuff1
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(6; "Document Date"; Date)
        {
            // cleaned
        }
        field(10; "OEM No."; Code[20])
        {
            // cleaned
        }
        field(11; "Currency Code"; Code[10])
        {
            // cleaned
        }
        field(12; "Vendor Customer Code"; Code[13])
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Document Date", "OEM No.")
        {
        }
        key(Key2; "Document Date", "OEM No.", "Currency Code", "Vendor Customer Code")
        {
        }
    }

    fieldgroups
    {
    }
}
