tableextension 50122 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50010;"Incoterm Code";Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50020;"Incoterm Location";Text[50])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50050;"Message Status(Booking)";Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051;"Message Collected By(Booking)";Code[50])
        {
            Editable = false;
        }
        field(50052;"Message Collected On(Booking)";Date)
        {
            Editable = false;
        }
        field(50053;"Message Revised By";Code[50])
        {
            Editable = false;
        }
        field(50054;"Message Revised On";Date)
        {
            Editable = false;
        }
        field(50055;"Message Status(Backlog)";Option)
        {
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50056;"Message Collected By(Backlog)";Code[50])
        {
            // cleaned
        }
        field(50057;"Message Collected On(Backlog)";Date)
        {
            // cleaned
        }
        field(50058;"Item Supplier Source";Option)
        {
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50059;"Vendor Cust. Code";Code[13])
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50063;"Goods Arrival Date";Date)
        {
            Description = '//20180109 by SS';
        }
    }
}
