pageextension 50525 PostedSalesShipLInesExt extends "Posted Sales Shipment Lines"
{
    layout
    {

        addafter("Document No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
        }
    }
}