tableextension 55809 "Item Charge Assign (Sales) Ext" extends "Item Charge Assignment (Sales)"
{
    fields
    {
        field(50000; "Posting Date"; Date)
        {
            Description = '//CS077';
        }
        field(50001; "External Document No."; Code[35])
        {
            Description = '//CS077';
        }
    }
}
