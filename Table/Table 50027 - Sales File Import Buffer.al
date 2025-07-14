table 50027 "Sales File Import Buffer"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Supplier Code"; Code[10])
        {
            Caption = 'Supplier Code';
        }
        field(3; "Buyer Part Number"; Code[20])
        {
            Caption = 'Buyer Part Number';
        }
        field(4; "Buyer Part Description"; Text[50])
        {
            Caption = 'Buyer Part Description';
        }
        field(5; "Supplier Part Number"; Code[20])
        {
            Caption = 'Supplier Part Number';
        }
        field(6; "Supplier Part Description"; Text[50])
        {
            Caption = 'Supplier Part Description';
        }
        field(7; UOM; Code[10])
        {
            Caption = 'UOM';
        }
        field(8; "Delivery Order"; Code[35])
        {
            Caption = 'Delivery Order';
        }
        field(9; Urgent; Code[10])
        {
            Caption = 'Urgent';
        }
        field(10; "Purchase Order Number"; Code[35])
        {
            Caption = 'Purchase Order Number';
        }
        field(11; "Ship To"; Code[20])
        {
            Caption = 'Ship To';
        }
        field(12; "Ship Date"; Date)
        {
            Caption = 'Ship Date';
        }
        field(13; "Ship Time"; Time)
        {
            Caption = 'Ship Time';
        }
        field(14; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(15; "Due Time"; Time)
        {
            Caption = 'Due Time';
        }
        field(16; "D.A.R Date"; Date)
        {
            Caption = 'D.A.R Date';
        }
        field(17; "Qty Due"; Decimal)
        {
            Caption = 'Qty Due';
        }
        field(18; "D.A.R Qty"; Decimal)
        {
            Caption = 'D.A.R Qty';
        }
        field(19; "Change From Last"; Code[10])
        {
            Caption = 'Change From Last';
        }
        field(20; "Qty Shipped to Date"; Decimal)
        {
            Caption = 'Qty Shipped to Date';
        }
        field(21; "Net Due"; Decimal)
        {
            Caption = 'Net Due';
        }
        field(22; "Dock No"; Code[10])
        {
            Caption = 'Dock No';
        }
        field(23; Warehouse; Code[10])
        {
            Caption = 'Warehouse';
        }
        field(24; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Firm,Planned';
            OptionMembers = " ",Firm,Planned;
        }
        field(25; "Date Type"; Code[10])
        {
            Caption = 'Date Type';
        }
        field(26; Route; Code[10])
        {
            Caption = 'Route';
        }
        field(27; "Special Instructions"; Text[30])
        {
            Caption = 'Special Instructions';
        }
        field(28; "Buyer/Planner Name"; Text[50])
        {
            Caption = 'Buyer/Planner Name';
        }
        field(29; "Planner Phone"; Text[30])
        {
            Caption = 'Planner Phone';
        }
        field(30; "Units per Box"; Integer)
        {
            Caption = 'Units per Box';
        }
        field(31; "Units per Pallet"; Integer)
        {
            Caption = 'Units per Pallet';
        }
        field(32; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(33; "Horizon Start Date"; Date)
        {
            Caption = 'Horizon Start Date';
        }
        field(34; "Horizon End Date"; Date)
        {
            Caption = 'Horizon End Date';
        }
        field(35; "Range Minimum"; Decimal)
        {
            Caption = 'Range Minimum';
        }
        field(36; "Range Maximum"; Decimal)
        {
            Caption = 'Range Maximum';
        }
        field(37; "A Part"; Integer)
        {
            Caption = 'A Part';
        }
        field(38; "Tag Slip Remark #1"; Text[50])
        {
            Caption = 'Tag Slip Remark #1';
        }
        field(39; "Tag Slip Remark #2"; Text[50])
        {
            Caption = 'Tag Slip Remark #2';
        }
        field(40; "Tag Slip Remark #3"; Text[50])
        {
            Caption = 'Tag Slip Remark #3';
        }
        field(41; "Schedule Issuer Name"; Text[50])
        {
            Caption = 'Schedule Issuer Name';
        }
        field(42; "Schedule Issuer Address 1"; Text[50])
        {
            Caption = 'Schedule Issuer Address 1';
        }
        field(43; "Schedule Issuer Address 2"; Text[50])
        {
            Caption = 'Schedule Issuer Address 2';
        }
        field(44; "Schedule Issuer Address 3"; Text[50])
        {
            Caption = 'Schedule Issuer Address 3';
        }
        field(45; "Schedule Type"; Code[10])
        {
            Caption = 'Schedule Type';
        }
        field(46; "File Name"; Text[50])
        {
            Caption = 'File Name';
        }
        field(47; "Row No."; Integer)
        {
            Caption = 'Row No.';
        }
        field(48; "Error Description"; Text[100])
        {
            Caption = 'Error Description';
        }
        field(49; "Denso Group"; Boolean)
        {
            Caption = 'Denso Group';
        }
        field(50; "Date Imported"; Date)
        {
            Caption = 'Date Imported';
        }
        field(51; "User ID Imported"; Code[50])
        {
            Caption = 'User ID Imported';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "File Name", "Row No.")
        {
        }
    }

    fieldgroups
    {
    }

}
