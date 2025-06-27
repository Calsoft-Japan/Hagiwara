pageextension 55824 SalesShipmentLinesExt extends "Sales Shipment Lines"
{
    layout
    {
        addlast(Content)
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}