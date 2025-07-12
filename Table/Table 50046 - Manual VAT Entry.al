table 50046 "Manual VAT Entry"
{
    fields
    {
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';

        }
        field(4; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,,Invoice,Credit Memo';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(6; "Base Amount"; Decimal)
        {
            Caption = 'Base Amount';

        }
        field(7; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
        }
        field(8; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';

        }
        field(9; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
        field(10; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
        }
        field(11; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

        }
        field(12; Issued; Boolean)
        {
            Caption = 'Issued';
        }
        field(13; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Code';

        }
        field(14; "Non Deductive List"; Option)
        {
            Caption = 'Non Deductive List';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12;
        }
        field(15; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash,Driver Welfare Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfare Card","Company Credit Card";

        }
        field(16; "Credit Card Code"; Code[10])
        {
            Caption = 'Credit Card Code';

        }
        field(17; "Receipt Type"; Option)
        {
            Caption = 'Receipt Type';
            OptionCaption = ' ,Credit Card,Cash Receipt,Other';
            OptionMembers = " ","Credit Card","Cash Receipt",Other;
        }
        field(18; "Asset Type"; Option)
        {
            Caption = 'Asset Type';
            OptionCaption = ' ,Construction,Machine,Cars,Others';
            OptionMembers = " ",Construction,Machine,Car,Other;
        }
        field(19; "Export Document Code"; Code[10])
        {
            Caption = 'Export Document Code';
        }
        field(20; "Export Document Name"; Text[30])
        {
            Caption = 'Export Document Name';
        }
        field(21; "Export Document Issuer"; Text[30])
        {
            Caption = 'Export Document Issuer';
        }
        field(22; "Export Issue Date"; Date)
        {
            Caption = 'Export Issue Date';
        }
        field(23; "Export Shipping Date"; Date)
        {
            Caption = 'Export Shipping Date';
        }
        field(24; "Submit Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Submit Amount';
        }
        field(25; "Submit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Submit Amount (LCY)';
        }
        field(26; "Exchange Rate Amount"; Decimal)
        {
            Caption = 'Currency Rate';
        }
        field(27; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';
        }
        field(28; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';

        }
        field(29; "Other Non Deductive List"; Option)
        {
            Caption = 'Other Deductive List';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(30; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Manual,Journal';
            OptionMembers = Manual,Journal;
        }
        field(31; "Issue Type"; Option)
        {
            Caption = 'Issue Type';
            OptionCaption = 'By Transaction,By Period';
            OptionMembers = ByTransaction,ByPeriod;
        }
        field(32; "VAT Category Type Name"; Text[50])
        {
            Caption = 'VAT Category Type Name';
            Editable = false;
        }
        field(33; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
        }
        field(34; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';

        }
        field(35; "L/C Export No."; Text[30])
        {
            Caption = 'L/C Export No.';
        }
        field(36; "Bill-to/Pay-to Name"; Text[50])
        {
            Caption = 'Bill-to/Pay-to Name';
        }
        field(37; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';

        }
        field(38; "Base Amount (Foreign)"; Decimal)
        {
            Caption = 'Base Amount (Foreign)';
        }
        field(39; "Tax Amount (Foreign)"; Decimal)
        {
            Caption = 'Tax Amount (Foreign)';
        }
        field(40; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(41; Remark; Text[100])
        {
            Caption = 'Remark';
        }
        field(42; "Credit Card No."; Text[30])
        {
            Caption = 'Credit Card No.';
        }
        field(43; "Source Code"; Code[10])
        {
            // cleaned
        }
        field(44; "G/L Register No."; Integer)
        {
            // cleaned
        }
        field(45; "ID No."; Text[20])
        {
            Caption = 'ID No.';
        }
        field(46; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(47; "Business Category"; Option)
        {
            Caption = 'Business Category';
            OptionCaption = 'Corporate,Personal Corporate,Person';
            OptionMembers = Corporate,"Personal Corporate",Person;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Document No.")
        {
        }
        key(Key2; "VAT Company Code", Type, "Bill-to/Pay-to No.", "Posting Date")
        {
        }
        key(Key3; "Tax Invoice No.")
        {
        }
    }

    fieldgroups
    {
    }
}
