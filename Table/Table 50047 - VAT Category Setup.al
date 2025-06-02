table 50047 "VAT Category Setup"
{
    fields
    {
        field(1; "Group Type"; Option)
        {
            Caption = 'Group Type';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(2; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
        }
        field(3; "Group Name"; Text[50])
        {
            Caption = 'Group Name';
        }
        field(4; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';
        }
        field(5; "VAT Category Type Name"; Text[50])
        {
            Caption = 'VAT Category Type Name';
        }
        field(6; "VAT Category Type Taxation"; Option)
        {
            Caption = 'VAT Category Type Taxation';
            OptionCaption = 'Taxation,0%';
            OptionMembers = Taxation,"0%";
        }
        field(7; "VAT Category Type VAT %"; Decimal)
        {
            Caption = 'VAT Category Type VAT %';
        }
    }
}
