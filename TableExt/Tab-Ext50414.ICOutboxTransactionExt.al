tableextension 50414 "IC Outbox Transaction Ext" extends "IC Outbox Transaction"
{

    fields
    {
        field(50000; "External Document No."; Code[50])
        {
            Editable = false;
        }
        field(50001; "Customer Order No."; Code[50])
        {
            Editable = false;
        }
        field(50002; "Requested Delivery Date_1"; Date)
        {
            Editable = false;
        }
    }

}
