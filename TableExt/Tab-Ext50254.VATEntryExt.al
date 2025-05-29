tableextension 50254 "VAT Entry Ext" extends "VAT Entry"
{
    fields
    {
        field(50000; Issued; Boolean)
        {
            Caption = 'Issued';
            Description = 'SKLV6.0';
        }
        field(50001; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';
        }
        field(50002; "Non Deductive List"; Option)
        {
            Caption = 'Non Deductive List';
            Description = 'SKLV6.0';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10;
        }
        field(50003; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            Description = 'SKLV6.0';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash,Driver Welfard Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfard Card","Company Credit Card";
        }
        field(50004; "Credit Card Code"; Code[10])
        {
            Caption = 'Credit Card Code';
            Description = 'SKLV6.0';
        }
        field(50005; "Receipt Type"; Option)
        {
            Caption = 'Receipt Type';
            Description = 'SKLV6.0';
            OptionCaption = ' ,Credit Card,Cash Receipt,Other';
            OptionMembers = " ","Credit Card","Cash Receipt",Other;
        }
        field(50006; "Asset Type"; Option)
        {
            Caption = 'Asset Type';
            Description = 'SKLV6.0';
            OptionCaption = ' ,Construction,Machine,Cars,Others';
            OptionMembers = " ",Construction,Machine,Car,Other;
        }
        field(50007; "Export Document Code"; Code[20])
        {
            Caption = 'Export No.';
            Description = 'SKLV6.0';
        }
        field(50008; "Export Document Name"; Text[30])
        {
            Caption = 'Export Doc. Name';
            Description = 'SKLV6.0';
        }
        field(50009; "Export Document Issuer"; Text[30])
        {
            Caption = 'Export Doc. Issuer';
            Description = 'SKLV6.0';
        }
        field(50010; "Export Issue Date"; Date)
        {
            Caption = 'Export Issue Date';
            Description = 'SKLV6.0';
        }
        field(50011; "Export Shipping Date"; Date)
        {
            Caption = 'Export Ship Date';
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
            Caption = 'Submit Amount(LCY)';
            Description = 'SKLV6.0';
        }
        field(50014; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            Description = 'SKLV6.0';
        }
        field(50015; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
            Description = 'SKLV6.0';
        }
        field(50016; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
            Description = 'SKLV6.0';
        }
        field(50017; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';
        }
        field(50018; "Issue Type"; Option)
        {
            Caption = 'Issue Type';
            Description = 'SKLV6.0';
            OptionCaption = 'By Transaction,By Period';
            OptionMembers = ByTransaction,ByPeriod;
        }
        field(50019; "L/C Export No."; Text[30])
        {
            Caption = 'L/C Export No.';
            Description = 'SKLV6.0';
        }
        field(50020; "Other Non Deductive List"; Option)
        {
            Description = 'SKLV6.0';
            OptionCaption = '—¹„ÏŽ°,Œ÷“Ôˆ×ŒŒŒ¡ ‘ª“ËŠ¨,—‘ªˆ•¯ŒŒŽ¸,Ï˜Ô–ÝÀ°…Ø ˆ•¯ŒŒŽ¸,Ï×ˆ•¯ŒŒŽ¸,Š»‘ª„ÔŒ³ŒŒŽ¸';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(50021; "Credit Card No."; Text[30])
        {
            Description = 'SKLV6.0';
        }
        field(50022; "Item Description"; Text[100])
        {
            Description = 'SKLV6.0';
        }
        field(50023; "Document Line No."; Integer)
        {
            Description = 'SKLV6.0';
        }
        field(50031; "G/L Entry No."; Integer)
        {
            Description = 'SKLV6.0';
        }
        field(50032; InActivation; Boolean)
        {
            Description = 'SKLV6.0';
        }
        field(50033; "Business Category"; Option)
        {
            Description = 'SKLV6.0';
            OptionCaption = 'Corporate,Personal Corporate,Persion';
            OptionMembers = Corporate,"Personal Corporate",Person;
        }
        field(50034; "ID No."; Text[20])
        {
            Description = 'SKLV6.0';
        }
    }
}
