tableextension 50112 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50010;"OEM No.";Code[20])
        {
            // cleaned
        }
        field(50011;"OEM Name";Text[50])
        {
            // cleaned
        }
        field(50020;From;Text[30])
        {
            // cleaned
        }
        field(50021;"To";Text[30])
        {
            // cleaned
        }
        field(50050;"Message Status(Booking)";Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051;"Message Processed By(Booking)";Code[20])
        {
            Editable = false;
        }
        field(50052;"Message Processed On(Booking)";Date)
        {
            Editable = false;
        }
        field(50053;"Message Revised By";Code[20])
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
        field(50056;"Message Collected By(Backlog)";Code[20])
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
        field(50075;"Shipment Tracking Date";Date)
        {
            Description = '//20180225 by SS';
        }
    }
}
