table 50060 "Promissary Note"
{
    fields
    {
        field(1; "P. Note No."; Text[12])
        {
            Caption = 'P. Note No.';
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';

        }
        field(3; "Settlement Bank"; Code[20])
        {
            Caption = '‘÷€Ã•ÔÎ';
        }
        field(4; Maker; Text[50])
        {
            Caption = 'Issuer';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 0;
        }
        field(8; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Posted,Cash-In,Disc.Posted,Return';
            OptionMembers = Open,Posted,Applied,"Disc.Posted",Cancel;
        }
        field(9; "P. Note Entry No."; Integer)
        {
            Caption = 'P. Note Entry No.';
            Editable = false;
        }
        field(10; "Pay-To Vendor"; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = true;
        }
        field(11; "Cash-In Entry No."; Integer)
        {
            Caption = 'Cash-In Entry No.';
            Editable = false;
        }
        field(12; "Payment Entry No."; Integer)
        {
            Caption = 'Payment Entry No.';
            Editable = false;
        }
        field(13; "Note Payable Entry No."; Integer)
        {
            Caption = 'Note Payable Entry No.';
            Editable = false;
        }
        field(14; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Receive,Issue';
            OptionMembers = Receive,Issue;
        }
        field(15; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(16; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(17; "Receiving Posting Date"; Date)
        {
            Caption = 'Receiving Posting Date';
        }
        field(18; "Sales Entry No."; Integer)
        {
            Caption = 'Sales Entry NO.';
        }
        field(19; Endorser; Text[50])
        {
            Caption = 'Owner';
        }
        field(21; "Receiving Bank"; Code[20])
        {
            Caption = '¯€¦•ÔÎ';
        }
        field(22; "Assign Bank"; Code[20])
        {
            Caption = 'Œ÷•‰•ÔÎ';
        }
        field(30; Discount; Boolean)
        {
            Caption = 'Discount';
        }
        field(31; "Discount Date"; Date)
        {
            Caption = 'Discount Date';
        }
        field(32; "Discount Rate"; Decimal)
        {
            Caption = 'Discount Rate';
            DecimalPlaces = 2 : 2;
        }
        field(33; "Discount Day"; Integer)
        {
            Caption = 'Discount Day';
        }
        field(34; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
        }
        field(35; "P.Note Type"; Option)
        {
            Caption = 'P. Note Type';
            OptionCaption = 'ŽÊŒ®ŽØ,Àí……ŽØ,íÐŒ÷—Ñ,—Ñ‘÷ŽØ,„Ï‘’Œ÷—Ñ,€Ë•ˆŽØ1,€Ë•ˆŽØ2';
            OptionMembers = "ŽÊŒ®ŽØ","Àí……ŽØ","íÐŒ÷—Ñ","—Ñ‘÷ŽØ","„Ï‘’Œ÷—Ñ","€Ë•ˆŽØ1","€Ë•ˆŽØ2";
        }
        field(36; "P.Note Month"; Integer)
        {
            Caption = 'P.Note Month';
        }
        field(40; "P.Note Doc No."; Code[22])
        {
            Caption = 'P.Note Doc No.';
        }
        field(41; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
        }
        field(42; "Cash-In Posting Date"; Date)
        {
            Caption = 'Cash-In Posting Date';
        }
        field(43; "Dics. Posting Date"; Date)
        {
            Caption = 'Dics. Posting Date';
        }
        field(45; "Receive No."; Code[10])
        {
            Caption = 'Serial No.';
        }
        field(50; "Branch No."; Code[20])
        {
            Caption = 'Branch No.';
            Editable = false;
        }
        field(51; "Branch Description"; Text[30])
        {
            Caption = 'Branch  Description';
            Editable = false;
        }
        field(52; Comment; Text[50])
        {
            Caption = 'Payment Location';
        }
        field(53; "Employee Code"; Code[10])
        {
            Caption = 'Employee Code';
            Editable = false;
        }
        field(54; "Employee Name"; Text[30])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(55; "Disc.Posted to Applied"; Boolean)
        {
            Caption = 'Disc.Posted to Applied';
        }
        field(50000; "Trust Date"; Date)
        {
            Caption = 'Trust Date';
        }
    }
}
