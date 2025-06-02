table 50066 "SO Interface HS"
{
    fields
    {
        field(10; "Part No"; Text[30])
        {
            Caption = 'Customer Item No.';
            Description = 'PRTNO';
            Editable = true;
        }
        field(20; "Supplier Code"; Text[30])
        {
            Caption = 'Original Customer No.';
            Description = 'Supplier Code';
            Editable = true;
        }
        field(25; "Field 1"; Text[30])
        {
            Description = 'Blank 1';
        }
        field(30; "Due Date"; Integer)
        {
            Caption = 'Due Date';
            Description = 'Due Date';
            Editable = true;
        }
        field(32; Year; Integer)
        {
            // cleaned
        }
        field(34; Weekly; Integer)
        {
            // cleaned
        }
        field(40; "DO NO."; Text[30])
        {
            Caption = 'DO No.';
            Description = 'DONBR';
            Editable = false;
        }
        field(42; "Field 2"; Text[30])
        {
            Description = 'Blank 2';
        }
        field(44; "Field 3"; Text[30])
        {
            Description = 'Blank 3';
        }
        field(60; Type; Integer)
        {
            Description = 'ORFLG -0 for SQ';
        }
        field(90; Qty; Integer)
        {
            Caption = 'Order Qty';
            Description = 'ORDQTY';
            Editable = true;
        }
        field(92; "Field 4"; Integer)
        {
            Description = 'Blank 4';
        }
        field(100; "Field 5"; Integer)
        {
            Description = 'Blank 5';
        }
        field(110; "Field 6"; Integer)
        {
            Description = 'Blank 6';
        }
        field(120; "Box Qty"; Decimal)
        {
            Description = 'Box Qty1';
        }
        field(140; "Field 7"; Text[30])
        {
            Description = 'Blank 7';
        }
        field(150; "Field 8"; Text[30])
        {
            Description = 'Blank 8';
        }
        field(160; "Field 9"; Text[30])
        {
            Description = 'Blank 9';
        }
        field(170; "Field 10"; Decimal)
        {
            Description = 'Blank 10';
        }
        field(180; "Supplier Code2"; Text[30])
        {
            Caption = 'Original Cust. No.';
            Description = 'Column T';
        }
        field(190; "Field 11"; Integer)
        {
            Description = 'Blank 11';
        }
        field(200; "Field 12"; Text[30])
        {
            Caption = 'Document Date';
            Description = 'Blank 12';
        }
        field(210; "Field 13"; Text[30])
        {
            Caption = 'Part No';
            Description = 'Blank 13';
        }
        field(215; "Field 16"; Text[30])
        {
            // cleaned
        }
        field(240; "Document Date"; Integer)
        {
            Caption = 'Document Date';
            Description = 'Issue Date Y';
            Editable = true;
        }
        field(242; "Field 14"; Text[30])
        {
            Description = 'Blank 14';
        }
        field(244; "Field 15"; Integer)
        {
            Description = 'Blank 15';
        }
        field(250; "External Document No"; Text[30])
        {
            Caption = 'External Document No';
            Description = 'PONBR';
            Editable = true;
        }
        field(270; ProcFlag; Integer)
        {
            Caption = 'ProcFlag';
            Description = 'PROCFLAG';
        }
        field(272; "Check Flag"; Integer)
        {
            Description = 'CHKflag';
        }
        field(273; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = true;
        }
    }
}
