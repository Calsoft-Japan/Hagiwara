table 50013 "Tembuff-Sales"
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            // cleaned
        }
        field(2;"Document No.";Code[20])
        {
            // cleaned
        }
        field(3;"Document Date";Date)
        {
            // cleaned
        }
        field(4;"Customer No.";Code[20])
        {
            // cleaned
        }
        field(5;"Currency Code";Code[10])
        {
            // cleaned
        }
        field(6;"OEM No.";Code[20])
        {
            // cleaned
        }
        field(7;"Order Date";Date)
        {
            // cleaned
        }
        field(8;"Requested Delivery Date";Date)
        {
            // cleaned
        }
        field(9;"Promised Delivery Date";Date)
        {
            // cleaned
        }
        field(10;"Posting Date";Date)
        {
            // cleaned
        }
        field(11;"External Document No.";Code[20])
        {
            // cleaned
        }
        field(12;"Location Code";Code[10])
        {
            // cleaned
        }
        field(13;"Item Supplier Source";Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(14;"Message Status(Booking)";Option)
        {
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(15;"Message Collected By(Booking)";Code[20])
        {
            // cleaned
        }
        field(16;"Message Collected On(Booking)";Date)
        {
            // cleaned
        }
        field(17;"Currency Factor";Decimal)
        {
            // cleaned
        }
        field(18;"Salesperson Code";Code[10])
        {
            // cleaned
        }
        field(19;"Shortcut Dimension 1 Code";Code[20])
        {
            // cleaned
        }
        field(20;"Shortcut Dimension 2 Code";Code[20])
        {
            // cleaned
        }
        field(21;"Shipment Date (SH)";Date)
        {
            // cleaned
        }
        field(22;"Due Date";Date)
        {
            // cleaned
        }
    }
}
