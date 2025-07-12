table 50043 "VAT Category Type"
{
    fields
    {
        field(1; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            Description = 'Sales/Purchase';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(4; Taxation; Option)
        {
            Caption = 'Taxation';
            OptionCaption = 'Taxation,0%';
            OptionMembers = Taxation,"0%";
        }
        field(5; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
        }
    }

    keys
    {
        key(Key1; "Invoice Type", "Code")
        {
        }
    }

    fieldgroups
    {
    }
}
