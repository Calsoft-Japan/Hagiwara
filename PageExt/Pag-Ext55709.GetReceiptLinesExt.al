pageextension 55709 GetReceiptLinesExt extends "Get Receipt Lines"
{
    layout
    {

        addafter(Quantity)
        {
            field("CO No."; Rec."CO No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
        }
    }
}