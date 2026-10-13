pageextension 50529 PostedPurchInvLinesExt extends "Posted Purchase Invoice Lines"
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

        modify("Order No.")
        {
            Visible = true;
        }
    }
}