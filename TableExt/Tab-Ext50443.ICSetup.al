tableextension 50443 "IC Setup Ext" extends "IC Setup"
{

    fields
    {
        field(50000; "IC Transaction Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
    }

}
