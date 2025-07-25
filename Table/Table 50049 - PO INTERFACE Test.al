table 50049 "PO INTERFACE Test"
{
    fields
    {
        field(5; "Entry No.."; Integer)
        {
            AutoIncrement = true;
        }
        field(10; Type; Integer)
        {
            Description = 'ORFLG';
        }
        field(20; "Document Date"; Integer)
        {
            Description = 'ISSUE DATE';
        }
        field(30; "Part No"; Text[30])
        {
            Description = 'PRTNO';
        }
        field(40; Qty; Integer)
        {
            Description = 'ORDQTY';
        }
        field(50; "Due Date"; Integer)
        {
            Description = 'Due Date';
        }
        field(60; "External Document No"; Text[30])
        {
            Description = 'PONBR';
        }
        field(100; ProcFlag; Integer)
        {
            Description = 'PROCFLAG';
        }
    }

    keys
    {
        key(Key1; "Entry No..")
        {
        }
    }

    fieldgroups
    {
    }
}
