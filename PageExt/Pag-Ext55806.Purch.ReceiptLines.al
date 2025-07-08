pageextension 55806 PurchReceiptLinesExt extends "Purch. Receipt Lines"
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