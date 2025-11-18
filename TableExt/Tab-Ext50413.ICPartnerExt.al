tableextension 50413 "IC Partner Ext" extends "IC Partner"
{

    fields
    {
        field(50000; "IC Transaction Partner Contact"; Code[20])
        {
            TableRelation = Contact."No.";
        }
    }

}
