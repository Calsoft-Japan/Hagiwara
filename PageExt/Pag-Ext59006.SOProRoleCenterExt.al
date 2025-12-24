pageextension 59006 "SOProRoleCenterExt" extends "Order Processor Role Center"
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

    actions
    {
        addafter("Locations")
        {
            action("Item Application Entries")
            {
                ApplicationArea = All;
                Caption = 'Item Application Entries';
                RunObject = page "Item Application Entries";
                Tooltip = 'Open Item Application Entries';
            }
        }
    }
}