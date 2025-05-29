tableextension 59053 "Sales Cue Ext" extends "Sales Cue"
{
    fields
    {
        field(50001; "Fully Shipped"; Integer)
        {
            Caption = 'Partially Shipped';
            Editable = false;
        }
    }
}
