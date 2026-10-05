pageextension 50137 PostedPurchRcptSubformExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Quantity")
        {
            field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}