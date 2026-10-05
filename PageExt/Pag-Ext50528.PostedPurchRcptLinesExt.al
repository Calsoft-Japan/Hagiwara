pageextension 50528 PostedPurchRcptLinesExt extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter("Quantity")
        {
            field("Unit Price (LCY)"; rec."Unit Price (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}