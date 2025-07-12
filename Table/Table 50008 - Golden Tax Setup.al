table 50008 "Golden Tax Setup"
{
    fields
    {
        field(1; "Primay Key"; Code[10])
        {
            // cleaned
        }
        field(2; "Maximum Lines"; Integer)
        {
            Caption = 'Maximum Lines';
        }
        field(3; "Maximum Amount"; Decimal)
        {
            Caption = 'Maximum Amount';
        }
    }

    keys
    {
        key(Key1; "Primay Key")
        {
        }
    }

    fieldgroups
    {
    }
}
