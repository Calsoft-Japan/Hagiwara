pageextension 59008 "InvtMgrRoleCenterExt" extends "Whse. Basic Role Center"
{

    layout
    {
        addbefore(Emails)
        {
            part(HagiApprActivities; "Hagiwara Approval Fact Box")
            {
                ApplicationArea = All;
            }
        }
        modify(ApprovalsActivities)
        {
            Visible = false;
        }
    }
}