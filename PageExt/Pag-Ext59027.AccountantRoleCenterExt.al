pageextension 59027 "AccountantRoleCenterExt" extends "Accountant Role Center"
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