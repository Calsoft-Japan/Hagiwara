table 50002 "Renesas PO Interface"
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Document Date";Date)
        {
            // cleaned
        }
        field(3;"OEM No.";Code[20])
        {
            // cleaned
        }
        field(4;"Vendor Customer Code";Code[13])
        {
            // cleaned
        }
        field(5;"Customer Name";Text[30])
        {
            // cleaned
        }
        field(6;"Item Description";Text[40])
        {
            // cleaned
        }
        field(7;Product;Text[20])
        {
            // cleaned
        }
        field(8;"CO No.";Code[6])
        {
            // cleaned
        }
        field(9;"Demand Date";Date)
        {
            // cleaned
        }
        field(10;Quantity;Decimal)
        {
            MinValue = 0;
        }
        field(11;"Currency Code";Code[3])
        {
            // cleaned
        }
        field(12;Price;Decimal)
        {
            DecimalPlaces = 0:4;
        }
        field(13;Amount;Decimal)
        {
            // cleaned
        }
        field(14;ProcFlag;Code[1])
        {
            
        }
    }
}
