tableextension 50003 "Payment Terms Ext" extends "Payment Terms"
{
    fields
    {
        field(50000;"Special Due Date Calc";Option)
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            OptionMembers = " ","15th or EOM";
        }
    }
}
