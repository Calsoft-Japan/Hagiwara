table 50012 "Forecast Header"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(3; "Supplier Code"; Text[100])
        {
            Caption = 'Supplier Code';
        }
        field(4; "Release No."; Text[100])
        {
            Caption = 'Release No.';
        }
        field(5; "Issued Date"; Text[100])
        {
            Caption = 'Issued Date';
        }
        field(6; "From Date"; Text[100])
        {
            Caption = 'From Date';
        }
        field(7; "To Date"; Text[100])
        {
            Caption = 'To Date';
        }
        field(8; Status; Option)
        {
            OptionMembers = Imported,Processed;
        }
    }
}
