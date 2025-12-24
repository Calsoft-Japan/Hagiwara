pageextension 59028 "TeamMemberRoleCenterExt" extends "Team Member Role Center"
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