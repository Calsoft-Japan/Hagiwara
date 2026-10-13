pageextension 50137 PostedPurchRcptSubformExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addbefore(Type)
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

        addafter("Quantity")
        {
            field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}