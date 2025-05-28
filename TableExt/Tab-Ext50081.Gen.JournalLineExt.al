tableextension 50081 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(50000;"VAT Category Type Code";Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';
            
        }
        field(50001;"VAT Category Type Name";Text[30])
        {
            Caption = 'VAT Category Type Name';
            Description = 'SKLV6.0';
        }
        field(50002;"VAT Company Code";Code[10])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';
            
        }
        field(50003;"VAT Issue Type";Option)
        {
            Caption = 'VAT Issue Type';
            Description = 'SKLV6.0';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
            
        }
        field(50004;"Export Document Code";Code[10])
        {
            Caption = 'Export Document Code';
            Description = 'SKLV6.0';
            
        }
        field(50005;"Export Document Name";Text[30])
        {
            Caption = 'Export Document Name';
            Description = 'SKLV6.0';
        }
        field(50006;"L/C Export No.";Text[30])
        {
            Caption = 'L/C Export No.';
            Description = 'SKLV6.0';
        }
        field(50007;"Export Document Issuer";Text[30])
        {
            Caption = 'Export Document Issuer';
            Description = 'SKLV6.0';
        }
        field(50008;"Export Issue Date";Date)
        {
            Caption = 'Export Issue Date';
            Description = 'SKLV6.0';
        }
        field(50009;"Export Shipping Date";Date)
        {
            Caption = 'Export Shipping Date';
            Description = 'SKLV6.0';
        }
        field(50010;"Submit Amount";Decimal)
        {
            Caption = 'Submit Amount';
            Description = 'SKLV6.0';
        }
        field(50011;"Submit Amount (LCY)";Decimal)
        {
            Caption = 'Submit Amount (LCY)';
            Description = 'SKLV6.0';
        }
        field(50012;"Non Deductive List";Option)
        {
            Caption = 'Non Deductive List';
            Description = 'SKLV6.0';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12;
        }
        field(50013;"Collect Type";Option)
        {
            Caption = 'Collect Type';
            Description = 'SKLV6.0';
            OptionCaption = ' ,Cash,Bank,Card,Apply,Enury,Point';
            OptionMembers = " ",Cash,Bank,Card,Apply,Enury,Point;
        }
        field(50014;"Credit Card Code";Code[10])
        {
            Caption = 'Credit Card Code';
            Description = 'SKLV6.0';
            
        }
        field(50015;"Asset Type";Option)
        {
            Caption = 'Asset Type';
            Description = 'SKLV6.0';
            OptionCaption = ' ,Construction,Machine,Cars,Others';
            OptionMembers = " ",Construction,Machine,Car,Other;
        }
        field(50016;"Other Non Deductive List";Option)
        {
            Caption = 'Other Non Deductive List';
            Description = 'SKLV6.0';
            OptionCaption = '—¹„ÏŽ°,Œ÷“Ôˆ×ŒŒŒ¡ ‘ª“ËŠ¨,—‘ªˆ•¯ŒŒŽ¸,Ï˜Ô–ÝÀ°…Ø ˆ•¯ŒŒŽ¸,Ï×ˆ•¯ŒŒŽ¸,Š»‘ª„ÔŒ³ŒŒŽ¸';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(50017;"Issue Type";Option)
        {
            Caption = 'Issue Type';
            Description = 'SKLV6.0';
            OptionCaption = 'By Transaction,By Period';
            OptionMembers = ByTransaction,ByPeriod;
        }
        field(50018;"Bill-to/Pay-to No. 2";Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
            Description = 'SKLV6.0';
            
        }
        field(50019;"VAT Currency Code";Code[10])
        {
            Caption = 'VAT Currency Code';
            Description = 'SKLV6.0';
            
        }
        field(50020;"Editable Base Amount";Decimal)
        {
            Caption = 'Editable Base Amount';
            Description = 'SKLV6.0';
        }
        field(50021;"Editable VAT Amount";Decimal)
        {
            Caption = 'Editable Tax Amount';
            Description = 'SKLV6.0';
        }
        field(50022;"Tax Invoice Date";Date)
        {
            Caption = 'Tax Invioce Date';
            Description = 'SKLV6.0';
        }
        field(50023;"VAT Exchange Rate";Decimal)
        {
            Caption = 'VAT Currency Factor';
            Description = 'SKLV6.0';
        }
        field(50024;"Base Amount (Foreign)";Decimal)
        {
            Caption = 'Statement Base Amount';
            Description = 'SKLV6.0';
        }
        field(50025;"Tax Amount (Foreign)";Decimal)
        {
            Caption = 'Foriegn Currency Tax Amount';
            Description = 'SKLV6.0';
        }
        field(50026;"Make Korean VAT";Boolean)
        {
            Caption = 'Make Korean VAT';
            Description = 'SKLV6.0';
        }
        field(50027;"Receipt Type";Option)
        {
            Caption = 'Receipt Type';
            Description = 'SKLV6.0';
            OptionCaption = ' ,Credit Card,Cash Receipt,Other';
            OptionMembers = " ","Credit Card","Cash Receipt",Other;
        }
        field(50028;"VAT Credit Card No.";Text[30])
        {
            Caption = 'Credit Card No.';
            Description = 'SKLV6.0';
        }
        field(50029;"Payment Type";Option)
        {
            Caption = 'Payment Type';
            Description = 'SKLV6.0';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash Receipt,Driver Welfard Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfard Card","Company Credit Card";
            
        }
        field(50030;"VAT Company Name";Text[50])
        {
            Caption = 'VAT Company Name';
            Description = 'SKLV6.0';
        }
        field(50031;"Item Description";Text[100])
        {
            Caption = 'Item Description';
            Description = 'SKLV6.0';
        }
        field(50032;"Bill-to/Pay-to Name";Text[100])
        {
            Caption = 'Bill-to/Pay-to Name';
            Description = 'SKLV6.0';
        }
        field(50033;"Document Line No.";Integer)
        {
            Description = 'SKLV6.0';
        }
        field(50034;"ID No.";Text[20])
        {
            Caption = 'ID No.';
            Description = 'SKLV6.0';
        }
        field(50035;"Participant Name";Text[50])
        {
            Caption = 'Participant Name';
            Description = 'SKLV6.0';
        }
        field(50036;"VAT Registration No. 2";Text[20])
        {
            Caption = 'VAT Registration No.';
            Description = 'SKLV6.0';
        }
        field(50037;"Account Name";Text[50])
        {
            Caption = 'Account Name';
            Description = 'SKLV6.0';
        }
        field(50038;"Description 2";Text[100])
        {
            Caption = 'Description 2';
            Description = 'SKLV6.0';
            
        }
        field(50039;"P. Note";Text[12])
        {
            Caption = 'P. Note';
            Description = 'SKLN6.0';
            Editable = false;
        }
        field(50040;"P. Note Status";Code[10])
        {
            Caption = 'P. Note Status';
            Description = 'SKLN6.0';
        }
        field(50041;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Description = 'SKLN6.0';
        }
    }
}
