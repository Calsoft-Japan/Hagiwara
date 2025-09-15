pageextension 59006 "SOProRoleCenterExt" extends "Order Processor Role Center"
{

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