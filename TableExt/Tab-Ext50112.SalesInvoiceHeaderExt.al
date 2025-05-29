tableextension 50112 "Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50010; "OEM No."; Code[20])
        {
            Caption = 'OEM No.';
        }
        field(50011; "OEM Name"; Text[50])
        {
            Caption = 'OEM Name';
        }
        field(50020; From; Text[30])
        {
            Caption = 'From';
        }
        field(50021; "To"; Text[30])
        {
            Caption = 'To';
        }
        field(50050; "Message Status(Booking)"; Option)
        {
            Caption = 'Message Status(Booking)';
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051; "Message Processed By(Booking)"; Code[20])
        {
            Caption = 'Message Collected By(Booking)';
            Editable = false;
        }
        field(50052; "Message Processed On(Booking)"; Date)
        {
            Caption = 'Message Collected On(Booking)';
            Editable = false;
        }
        field(50053; "Message Revised By"; Code[20])
        {
            Caption = 'Message Revised By';
            Editable = false;
        }
        field(50054; "Message Revised On"; Date)
        {
            Caption = 'Message Revised On';
            Editable = false;
        }
        field(50055; "Message Status(Backlog)"; Option)
        {
            Caption = 'Message Status(Backlog)';
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50056; "Message Collected By(Backlog)"; Code[20])
        {
            Caption = 'Message  Collected By(Backlog)';
        }
        field(50057; "Message Collected On(Backlog)"; Date)
        {
            Caption = 'Message  Collected On(Backlog)';
        }
        field(50058; "Item Supplier Source"; Option)
        {
            Caption = 'Item Supplier Source';
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50059; "Vendor Cust. Code"; Code[13])
        {
            Caption = 'Vendor Cust. Code';
            Description = '//20101009';
            Editable = false;
        }
    }
}
