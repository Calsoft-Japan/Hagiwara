pageextension 59048 "APActivitiesExt" extends "Acc. Payable Activities"
{

    layout
    {
        modify(DocumentApprovals)
        {
            Visible = false;
        }
    }
}