table 50009 "PO INTERFACE"
{
    fields
    {
        field(10;Type;Integer)
        {
            Description = 'ORFLG';
        }
        field(20;"Document Date";Integer)
        {
            Description = 'ISSUE DATE';
        }
        field(30;"Part No";Text[30])
        {
            Description = 'PRTNO';
        }
        field(40;Qty;Integer)
        {
            Description = 'ORDQTY';
        }
        field(50;"Due Date";Integer)
        {
            Description = 'Due Date';
        }
        field(60;"External Document No";Text[30])
        {
            Description = 'PONBR';
        }
        field(100;ProcFlag;Integer)
        {
            Description = 'PROCFLAG';
        }
    }
}
