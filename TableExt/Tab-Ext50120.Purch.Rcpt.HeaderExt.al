tableextension 50120 "Purch. Rcpt. Header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50024; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50050; "Message Status(Booking)"; Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051; "Message Collected By(Booking)"; Code[50])
        {
            Editable = false;
        }
        field(50052; "Message Collected On(Booking)"; Date)
        {
            Editable = false;
        }
        field(50053; "Message Revised By"; Code[50])
        {
            Editable = false;
        }
        field(50054; "Message Revised On"; Date)
        {
            Editable = false;
        }
        field(50055; "Message Status(Backlog)"; Option)
        {
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50056; "Message Collected By(Backlog)"; Code[50])
        {
            // cleaned
        }
        field(50057; "Message Collected On(Backlog)"; Date)
        {
            // cleaned
        }
        field(50059; "Vendor Cust. Code"; Code[13])
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50091; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(50092; Requester; Code[50])
        {
            Editable = false;
        }
        field(50093; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }
        field(50500; "Message Status(Incoming)"; Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Sent';
            OptionMembers = "Ready to Collect",Collected,Sent;
        }
        field(50501; "Message Collected By(Incoming)"; Code[50])
        {
            Editable = false;
        }
        field(50502; "Message Collected On(Incoming)"; Date)
        {
            Editable = true;
        }
        field(50503; "Save Posting Date (Original)"; Date)
        {
            Editable = false;
        }
    }
}
