tableextension 55747 "Transfer Receipt Line Ext" extends "Transfer Receipt Line"
{
    fields
    {
        field(50010; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = '//ms fon';
        }
    }
}
