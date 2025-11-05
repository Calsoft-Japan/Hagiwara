pageextension 59022 "BusMgrRoleCenterExt" extends "Business Manager Role Center"
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