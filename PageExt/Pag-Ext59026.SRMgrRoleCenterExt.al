pageextension 59026 "SRMgrRoleCenterExt" extends "Sales & Relationship Mgr. RC"
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