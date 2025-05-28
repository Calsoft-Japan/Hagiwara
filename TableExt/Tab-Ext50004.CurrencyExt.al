tableextension 50004 "Currency Ext" extends "Currency"
{
    fields
    {
        field(50001; "Alternate Currency Code"; Code[10])
        {
            Description = 'for PSI Data System only';
        }
    }
}
