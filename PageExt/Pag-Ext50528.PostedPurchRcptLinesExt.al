pageextension 50528 PostedPurchRcptLinesExt extends "Posted Purchase Receipt Lines"
{
    layout
    {

        addafter("Document No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
        }

        addafter("Quantity")
        {
            field("Unit Price (LCY)"; rec."Unit Price (LCY)")
            {
                ApplicationArea = all;
            }
        }

        modify("Order No.")
        {
            Visible = true;
        }
    }
}