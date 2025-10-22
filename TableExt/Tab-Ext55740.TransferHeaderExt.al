tableextension 55740 "Transfer Header Ext" extends "Transfer Header"
{
    fields
    {
        field(50001; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(50002; Requester; Code[50])
        {
            Editable = false;
        }
        field(50003; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }
    }
}
