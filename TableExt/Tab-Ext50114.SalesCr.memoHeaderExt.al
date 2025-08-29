tableextension 50114 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
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
        field(50075; "Shipment Tracking Date"; Date)
        {
            Description = '//20180225 by SS';
        }
    }
}
