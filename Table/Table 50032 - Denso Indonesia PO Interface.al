table 50032 "Denso Indonesia PO Interface"
{
    fields
    {
        field(10; Type; Integer)
        {
            // cleaned
        }
        field(20; "Document Date"; Date)
        {
            // cleaned
        }
        field(30; "Part No"; Text[30])
        {
            // cleaned
        }
        field(40; "Due Date"; Date)
        {
            // cleaned
        }
        field(50; Qty; Integer)
        {
            // cleaned
        }
        field(60; "External Document No"; Text[30])
        {
            // cleaned
        }
        field(70; ProcFlag; Integer)
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; Type, "Document Date", "Part No", "Due Date")
        {
        }
        key(Key2; Type, "Document Date", "External Document No", "Part No", "Due Date")
        {
        }
    }

    fieldgroups
    {
    }
}
