tableextension 50110 "Sales Shipment Header Ext" extends "Sales Shipment Header"
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
            Editable = true;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50059;"Vendor Cust. Code";Code[13])
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50063;"Last Serial No.";Integer)
        {
            // cleaned
        }
        field(50064;"Final Customer No.";Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(50065;"Final Customer Name";Text[50])
        {
            Editable = false;
        }
        field(50075;"Shipment Tracking Date";Date)
        {
            Description = '//20180225 by SS';
        }
        field(50500;"Message Status(Shipment)";Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Sent';
            OptionMembers = "Ready to Collect",Collected,Sent;
        }
        field(50501;"Message Collected By(Shipment)";Code[50])
        {
            Editable = false;
        }
        field(50502;"Message Collected On(Shipment)";Date)
        {
            Editable = true;
        }
        field(50503;"Save Posting Date (Original)";Date)
        {
            Editable = false;
        }
    }
}
