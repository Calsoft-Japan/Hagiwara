table 50028 "Reporting Data Buffer"
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(3;"Customer Order No.";Text[35])
        {
            Caption = 'Customer Order No.';
        }
        field(4;"Order Date";Date)
        {
            Caption = 'Order Date';
        }
        field(5;"Due Date";Date)
        {
            Caption = 'Due Date';
        }
        field(6;"Customer Group";Text[30])
        {
            Caption = 'Customer Group';
        }
        field(7;Customer;Text[50])
        {
            Caption = 'Customer';
        }
        field(8;OEM;Text[50])
        {
            Caption = 'OEM';
        }
        field(9;Vendor;Text[50])
        {
            Caption = 'Vendor';
        }
        field(10;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(11;"Customer Item No.";Code[20])
        {
            Caption = 'Customer Item No.';
        }
        field(12;Manufacturer;Text[50])
        {
            Caption = 'Manufacturer';
        }
        field(13;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(14;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
        }
        field(15;"Line Amount";Decimal)
        {
            Caption = 'Line Amount';
        }
        field(16;"Unit Cost";Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(17;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(18;"Outstanding Quantity";Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0:5;
        }
        field(19;Year;Integer)
        {
            Caption = 'Year';
        }
        field(20;Month;Integer)
        {
            Caption = 'Month';
        }
        field(21;"Vendor CO";Code[10])
        {
            Caption = 'Vendor CO';
        }
        field(22;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        }
        field(23;"Cost Amount (Actual)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount (Actual)';
        }
        field(24;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
        }
        field(25;"Value Entry No.";Integer)
        {
            Caption = 'Value Entry No.';
        }
        field(26;"Item No.";Code[20])
        {
            Caption = 'Item No.';
        }
        field(27;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(28;"Customer CO";Code[10])
        {
            Caption = 'Customer CO';
        }
        field(29;"OEM CO";Code[10])
        {
            Caption = 'OEM CO';
        }
        field(30;EOL;Boolean)
        {
            Caption = 'EOL';
        }
        field(31;"Sales Amount (Actual)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Sales Amount (Actual)';
        }
        field(60053;Apl;Text[5])
        {
            // cleaned
        }
    }
}
