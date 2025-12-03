tableextension 50124 "Purch. Cr. Memo Hdr. Ext" extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        field(50000; "Shipping Terms"; Text[100])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50001; "VAT Category Type Code"; Code[10])
        {
            Description = 'SKLV6.0';
        }
        field(50002; "VAT Category Type Name"; Text[30])
        {
            Description = 'SKLV6.0';
        }
        field(50003; "Non Deductive List"; Option)
        {
            Description = 'SKLV6.0';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12;
        }
        field(50004; "Other Deductive List"; Option)
        {
            Description = 'SKLV6.0';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(50005; "Payment Type"; Option)
        {
            Description = 'SKLV6.0';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash,Driver Welfare Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfard Card","Company Credit Card";
        }
        field(50006; "Credit Card Code"; Code[10])
        {
            //TableRelation = "Renesas PO Interface";
            TableRelation = "VAT Credit Card";//under confirm 
            Description = 'SKLV6.0';
        }
        field(50007; "Credit Card Name"; Text[30])
        {
            FieldClass = FlowField;
            //CalcFormula = Lookup("Renesas PO Interface"."OEM No." WHERE("Entry No." = FIELD("Credit Card Code"))); 
            CalcFormula = Lookup("VAT Credit Card".Name WHERE("Credit Card No." = FIELD("Credit Card Code")));//under confirm 
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
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50070; "VAT Company Code"; Code[10])
        {
            Description = 'SKLV6.0';
        }
        field(50071; "GST Rate"; Decimal)
        {
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
    }
}
