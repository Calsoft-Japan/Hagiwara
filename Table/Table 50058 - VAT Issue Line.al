table 50058 "VAT Issue Line"
{
    fields
    {
        field(1; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "VAT Entry No."; Integer)
        {
            Caption = 'VAT Entry No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(8; "Tax Base Amount"; Decimal)
        {
            Caption = 'Tax Base Amount';
        }
        field(9; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
        }
        field(10; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
        }
        field(11; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(12; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
        }
        field(13; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Manual,Journal';
            OptionMembers = Manual,Journal;
        }
        field(14; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,,Invoice,Credit Memo';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(15; "Source Code"; Code[10])
        {
            // cleaned
        }
        field(16; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(17; "Document Line No."; Integer)
        {
            // cleaned
        }
    }
}
