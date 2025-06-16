table 50057 "VAT Issue Header"
{
    fields
    {
        field(1; "Tax Invoice No."; Code[20])
        {
            Caption = 'Tax Invoice No.';

        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Tax Invoice Date"; Date)
        {
            Caption = 'Tax Invoice Date';
        }
        field(6; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';

        }
        field(7; "VAT Registration No."; Code[20])
        {
            Caption = 'VAT Registration No.';

        }
        field(8; "Tax Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Base Amount';
        }
        field(9; "Tax Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Tax Amount';
        }
        field(10; "Total Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Amount';
        }
        field(11; "Editable Base Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Editable Base Amount';
        }
        field(12; "Editable Tax Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Editable Tax Amount';
        }
        field(13; "Editable Total Amount"; Decimal)
        {
            Caption = 'Editable Total Amount';

        }
        field(14; "Base Amount Difference"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base Amount Difference';
        }
        field(15; "Tax Amount Difference"; Decimal)
        {
            Caption = 'Tax Amount Difference';
        }
        field(16; "Saperated Invoice"; Boolean)
        {
            // cleaned
        }
        field(17; "Non Deductive List"; Option)
        {
            Caption = 'Non Deductive List';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12;
        }
        field(18; "Other Non Deductive List"; Option)
        {
            Caption = 'Other Non Deductive List';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(19; "No. of Invoice"; Integer)
        {
            Caption = 'No. of Invoice';
        }
        field(20; "Print Date"; Date)
        {
            // cleaned
        }
        field(21; Printed; Boolean)
        {
            // cleaned
        }
        field(22; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(23; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';

        }
        field(24; "VAT Category Type Name"; Text[50])
        {
            Caption = 'VAT Category Type Name';
        }
        field(25; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(26; "L/C Export No."; Text[30])
        {
            Caption = 'L/C Export No.';
        }
        field(27; "Export Document Issuer"; Text[30])
        {
            Caption = 'Export Document Issuer';
        }
        field(28; "Export Document Code"; Code[10])
        {
            Caption = 'Export Document Code';

        }
        field(29; "Export Document Name"; Text[30])
        {
            Caption = 'Export Document Name';
        }
        field(30; "Export Shipping Date"; Date)
        {
            Caption = 'Export Shipping Date';
        }
        field(31; "Export Issue Date"; Date)
        {
            Caption = 'Export Issue Date';
        }
        field(32; "Submit Amount"; Decimal)
        {
            Caption = 'Submit Amount';
        }
        field(33; "Submit Amount (LCY)"; Decimal)
        {
            Caption = 'Submit Amount (LCY)';
        }
        field(34; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash,Driver Welfare Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfare Card","Company Credit Card";
        }
        field(35; "Credit Card Code"; Code[10])
        {
            Caption = 'Credit Card Code';
        }
        field(36; "Credit Card Name"; Text[30])
        {
            Caption = 'Credit Card Name';
        }
        field(37; "Asset Type"; Option)
        {
            Caption = 'Asset Type';
            OptionCaption = ' ,Construction,Machine,Cars,Others';
            OptionMembers = " ",Construction,Machine,Car,Other;
        }
        field(38; "Receipt Type"; Option)
        {
            Caption = 'Receipt Type';
            OptionCaption = ' ,Credit Card,Cash Receipt,Other';
            OptionMembers = " ","Credit Card","Cash Receipt",Other;
        }
        field(39; Omission; Boolean)
        {
            Caption = 'Omission';
        }
        field(40; Cancel; Boolean)
        {
            Caption = 'Cancel';
        }
        field(41; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
        }
        field(42; "Print Issue Type"; Option)
        {
            Caption = 'Issue Type';
            OptionCaption = 'Request,Receipt';
            OptionMembers = Request,Receipt;
        }
        field(43; "Bill-to/Pay-to Name"; Text[50])
        {
            Caption = 'Bill-to/Pay-to Name';
        }
        field(44; "VAT Category Type Group Code"; Code[10])
        {
            Caption = 'VAT Category Type Group Code';
        }
        field(45; "Business Category"; Option)
        {
            Caption = 'Business Category';
            OptionCaption = 'Corporate,Personal Corporate,Person';
            OptionMembers = Corporate,"Personal Corporate",Person;
        }
        field(46; "Base Amount (Foreign)"; Decimal)
        {
            Caption = 'Base Amount (Foreign)';
        }
        field(47; "Tax Amount (Foreign)"; Decimal)
        {
            Caption = 'Tax Amount (Foreign)';
        }
        field(48; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';

        }
        field(49; "Exchange Rate Amount"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(50; "Credit Card No."; Text[30])
        {
            Caption = 'Credit Card No.';
        }
        field(51; "Closing Quarter"; Code[10])
        {
            Caption = 'Closing Quarter';
        }
        field(52; Remark; Text[100])
        {
            Caption = 'Remark';
        }
        field(53; "ID No."; Text[20])
        {
            Caption = 'ID No.';
        }
        field(54; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(100; Select; Boolean)
        {
            // cleaned
        }
        field(101; "Closing Select"; Boolean)
        {
            // cleaned
        }
    }
}
