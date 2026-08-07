pageextension 55708 GetShipmentLinesExt extends "Get Shipment Lines"
{
    layout
    {

        addafter(Description)
        {
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Customer Order No."; Rec."Customer Order No.")
            {
                ApplicationArea = all;
            }
        }
    }
}