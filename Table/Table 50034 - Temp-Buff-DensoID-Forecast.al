table 50034 "Temp-Buff-DensoID-Forecast"
{
    fields
    {
        field(10; "Entry No."; Integer)
        {
            // cleaned
        }
        field(20; "Document Date"; Date)
        {
            // cleaned
        }
        field(30; "External Document No."; Code[30])
        {
            // cleaned
        }
        field(32; "Part No."; Code[30])
        {
            // cleaned
        }
        field(35; "Due Date"; Date)
        {
            // cleaned
        }
        field(40; "Customer No."; Code[10])
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Document Date")
        {
        }
        key(Key2; "Document Date", "External Document No.", "Part No.", "Due Date")
        {
        }
    }

    fieldgroups
    {
    }
}
