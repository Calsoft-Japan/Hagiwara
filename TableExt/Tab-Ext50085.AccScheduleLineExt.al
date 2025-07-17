tableextension 50085 "Acc. Schedule Line Ext" extends "Acc. Schedule Line"
{
    fields
    {
        field(50000; "Amount Calculation"; Integer)
        {
            Description = 'ACWSH';
            TableRelation = "Column Layout"."Column No." WHERE("Column Layout Name" = CONST('CHSREPORT'));
        }
        field(50001; "Description 2"; Text[80])
        {
            Description = 'ACWSH';
        }
    }
}
