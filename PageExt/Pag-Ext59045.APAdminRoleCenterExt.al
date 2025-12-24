pageextension 59045 "APAdminRoleCenterExt" extends "Acc. Payable Administrator RC"
{

    layout
    {
        addbefore("Intercompany Activities")
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