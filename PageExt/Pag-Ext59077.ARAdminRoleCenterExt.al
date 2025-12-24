pageextension 59077 "ARAdminRoleCenterExt" extends "Account Receivables"
{

    layout
    {
        addbefore("User Task Activities")
        {
            part(HagiApprActivities; "Hagiwara Approval Fact Box")
            {
                ApplicationArea = All;
            }
        }
    }
}