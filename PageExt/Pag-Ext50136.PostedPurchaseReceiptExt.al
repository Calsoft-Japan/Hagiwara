pageextension 50136 PostedPurchaseReceiptExt extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Vendor Shipment No.")
        {
            field("Goods Arrival Date"; Rec."Goods Arrival Date")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
            }
            field("Message Collected By(Incoming)"; Rec."Message Collected By(Incoming)")
            {
                ApplicationArea = all;
            }
            field("Message Collected On(Incoming)"; Rec."Message Collected On(Incoming)")
            {
                ApplicationArea = all;
            }
        }


        addafter("Expected Receipt Date")
        {
            field("Save Posting Date (Original)"; Rec."Save Posting Date (Original)")
            {
                ApplicationArea = all;
            }
        }
    }

}