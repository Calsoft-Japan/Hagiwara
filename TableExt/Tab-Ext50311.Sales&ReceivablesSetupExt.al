tableextension 50311 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "Final Custormer No."; Code[10])
        {
            TableRelation = "No. Series";
            // cleaned
        }

        field(50002; "Posted Sales E-Sig."; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
    }
}
