table 50065 "SQ Interface HS"
{
    fields
    {
        field(10; "Part No"; Text[30])
        {
            Caption = 'Part No.';
            Description = 'Customer Item No.';
            Editable = true;
        }
        field(20; "Supplier Code"; Text[30])
        {
            Caption = 'Original  Cust. No';
            Description = 'Supplier Code';
            Editable = false;
        }
        field(30; "Due Date"; Integer)
        {
            Caption = 'Due Date';
            Description = 'Due Date';
            Editable = true;
        }
        field(40; "PO NO."; Text[30])
        {
            Caption = 'PO No.';
            Description = 'PONBR';
            Editable = false;
        }
        field(50; "Field 1"; Integer)
        {
            Description = 'Blank 1';
        }
        field(60; Type; Integer)
        {
            Description = 'ORFLG -0 for SQ';
        }
        field(70; "Field 2"; Text[30])
        {
            Caption = 'Field 2';
            Description = 'Blank 2';
        }
        field(80; "Check Flag"; Integer)
        {
            Description = 'CHKflag';
        }
        field(90; Qty; Integer)
        {
            Caption = 'Order Qty';
            Description = 'ORDQTY';
            Editable = true;
        }
        field(100; "Field 3"; Text[30])
        {
            Description = 'Blank 3';
        }
        field(110; "Field 4"; Text[30])
        {
            Description = 'Blank 4';
        }
        field(120; "Box Qty1"; Integer)
        {
            Description = 'Box Qty1';
        }
        field(130; "Box Qty2"; Integer)
        {
            Description = 'Box Qty2';
        }
        field(140; "Field 5"; Text[30])
        {
            Description = 'N';
        }
        field(150; "Field 6"; Text[30])
        {
            // cleaned
        }
        field(160; Year; Integer)
        {
            // cleaned
        }
        field(170; Weekly; Integer)
        {
            Description = 'Column Q';
        }
        field(180; "Field 7"; Text[30])
        {
            Description = 'Column R';
        }
        field(190; "Field 8"; Text[30])
        {
            Description = 'Column S';
        }
        field(200; "Field 9"; Text[30])
        {
            Caption = 'Field 9';
            Description = 'Column T';
        }
        field(220; "Field 11"; Integer)
        {
            Description = 'Column V';
        }
        field(230; "Field 12"; Integer)
        {
            Description = 'Column W';
        }
        field(235; "Field 13"; Integer)
        {
            // cleaned
        }
        field(240; "Document Date"; Integer)
        {
            Caption = 'Document Date';
            Description = 'Issue Date';
            Editable = true;
        }
        field(250; "External Document No"; Text[30])
        {
            Caption = 'External Document No';
            Description = 'PONBR';
            Editable = false;
        }
        field(270; ProcFlag; Integer)
        {
            Caption = 'ProcFlag';
            Description = 'PROCFLAG';
        }
        field(275; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = true;
        }
    }
}
