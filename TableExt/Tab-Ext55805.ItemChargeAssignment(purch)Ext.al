tableextension 55805 "Item Charge Assign (Purch) Ext" extends "Item Charge Assignment (Purch)"
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
        field(50002; "Item Ledger Entry No."; Integer)
        {
        }
    }
}
