table 50039 "VAT Category Type Group"
{
    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}
