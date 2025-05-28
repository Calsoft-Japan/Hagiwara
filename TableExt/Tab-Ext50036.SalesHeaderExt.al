tableextension 50036 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50000; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';

        }
        field(50001; "VAT Company Name"; Text[50])
        {
            Caption = 'VAT Company Name';
            Description = 'SKLV6.0';
        }
        field(50002; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';

        }
        field(50003; "VAT Category Type Name"; Text[50])
        {
            Caption = 'VAT Category Type Name';
            Description = 'SKLV6.0';
        }
        field(50004; "Export Document Code"; Code[10])
        {
            Caption = 'Export Doc. Code';
            Description = 'SKLV6.0';

        }
        field(50005; "Export Document Name"; Text[50])
        {
            Caption = 'Export Doc. Name';
            Description = 'SKLV6.0';
        }
        field(50006; "L/C Export No."; Text[30])
        {
            Caption = 'L/C Export No.';
            Description = 'SKLV6.0';
        }
        field(50007; "Export Document Issuer"; Text[30])
        {
            Caption = 'Export Document Issuer';
            Description = 'SKLV6.0';
        }
        field(50008; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            Description = 'SKLV6.0';
        }
        field(50009; "Shipping Date"; Date)
        {
            Caption = 'Shipping Date';
            Description = 'SKLV6.0';
        }
        field(50010; "OEM No."; Code[20])
        {

        }
        field(50011; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50012; "Submit Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Submit Amount';
            Description = 'SKLV6.0';
        }
        field(50013; "Submit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Submit Amount (LCY)';
            Description = 'SKLV6.0';
        }
        field(50020; From; Text[30])
        {
            // cleaned
        }
        field(50021; "To"; Text[30])
        {
            // cleaned
        }
        field(50050; "Message Status(Booking)"; Option)
        {
            Editable = true;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051; "Message Collected By(Booking)"; Code[50])
        {
            Editable = false;
        }
        field(50052; "Message Collected On(Booking)"; Date)
        {
            Editable = true;
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
            Editable = true;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50056; "Message Collected By(Backlog)"; Code[50])
        {
            Editable = false;
        }
        field(50057; "Message Collected On(Backlog)"; Date)
        {
            Editable = false;
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
        field(50060; "No. Of Message Revisions"; Integer)
        {
            Description = '//20101018';
            Editable = false;
        }
        field(50061; "Message Revised at"; Time)
        {
            // cleaned
        }
        field(50062; "Save Posting Date (Original)"; Date)
        {
            Editable = false;
        }
        field(50063; "Last Serial No."; Integer)
        {
            // cleaned
        }
        field(50064; "Final Customer No."; Code[20])
        {
            Caption = 'No.';

        }
        field(50065; "Final Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(50066; "Revised JA Collection Date"; Date)
        {
            // cleaned
        }
        field(50067; "Revised JC Collection Date"; Date)
        {
            // cleaned
        }
        field(50068; "Original Doc. No."; Code[20])
        {
            Description = '//20131215';
        }
        field(50069; "Qty Invoiced"; Decimal)
        {
            Description = '//20140808 Siak Hui';
        }
        field(50070; "Qty Ordered"; Decimal)
        {
            Description = '//20140808 Siak Hui';
        }
        field(50071; "Qty Outstanding (Actual)"; Decimal)
        {
            Description = '//20140808 Siak Hui';
        }
        field(50072; "Order Count"; Integer)
        {
            Description = '//20140808 Siak Hui';
        }
        field(50073; "Full Shipped Count"; Integer)
        {
            Description = '//20140808 Siak Hui';
        }
        field(50074; "Qty Shipped"; Decimal)
        {
            Description = '//20140808 Siak Hui';
        }
        field(50075; "Shipment Tracking Date"; Date)
        {
            Description = '//20180225 by SS';
        }
        field(50076; "Ship-to Address Type"; Option)
        {
            Description = 'CS019';
            OptionCaption = 'Sell-to,Ship-to,Custom';
            OptionMembers = "Sell-to","Ship-to",Custom;
        }
        field(50080; "Request Delivery Time"; Time)
        {
            Caption = 'Request Delivery Time';
        }
        field(50081; Approver; Text[8])
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50082; Receiver; Text[8])
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50083; Cancelled; Boolean)
        {
            Description = 'ACWHKGT01.1,ACWSH';

        }
        field(50084; "Golden Tax"; Boolean)
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50085; Biller; Text[8])
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50545; "Requested Delivery Date_1"; Date)
        {

        }
    }
}
