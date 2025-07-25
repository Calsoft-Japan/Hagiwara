tableextension 50122 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "Shipping Terms"; Text[100])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';
        }
        field(50001; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';
        }
        field(50002; "VAT Category Type Name"; Text[30])
        {
            Caption = 'VAT Category Type Name';
            Description = 'SKLV6.0';
        }
        field(50003; "Non Deductive List"; Option)
        {
            Caption = 'Non Deductive List';
            Description = 'SKLV6.0';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12;
        }
        field(50004; "Other Non Deductive List"; Option)
        {
            Caption = 'Other Non Deductive List';
            Description = 'SKLV6.0';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(50005; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            Description = 'SKLV6.0';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash,Driver Welfare Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfard Card","Company Credit Card";
        }
        field(50006; "Credit Card Code"; Code[10])
        {
            Caption = 'Credit Card Code';
            Description = 'SKLV6.0';
        }
        field(50007; "Credit Card Name"; Text[30])
        {
            Caption = 'Credit Card Name';
            Description = 'SKLV6.0';
        }
        field(50008; "Credit Card No."; Text[30])
        {
            Description = 'SKLV6.0';
        }
        field(50009; "VAT Company Name"; Text[50])
        {
            Caption = 'VAT Company Name';
            Description = 'SKLV6.0';
        }
        field(50010; "Incoterm Code"; Code[20])
        {
            TableRelation = Incoterm;
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50020; "Incoterm Location"; Text[50])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
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
        field(50058; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
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
        field(50070; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';
        }
    }
}
