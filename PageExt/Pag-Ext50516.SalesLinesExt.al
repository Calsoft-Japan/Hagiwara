pageextension 50516 SalesLinesExt extends "Sales Lines"
{
    layout
    {
        addlast(Content)
        {
            field("OrderDate"; Rec."OrderDate")
            {
                ApplicationArea = all;
            }
            field("Products"; Rec."Products")
            {
                ApplicationArea = all;
            }
            field("Rank"; Rec."Rank")
            {
                ApplicationArea = all;
            }
            field("LineAmtExclVAT_LCY"; Rec."LineAmtExclVAT_LCY")
            {
                ApplicationArea = all;
            }
            field("Fully Reserved"; Rec."Fully Reserved")
            {
                ApplicationArea = all;
            }
            field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
            {
                ApplicationArea = all;
            }
            field("Shipped Not Invoiced (LCY)"; Rec."Shipped Not Invoiced (LCY)")
            {
                ApplicationArea = all;
            }
            field("Shipped Not Invoiced Cost(LCY)"; Rec."Shipped Not Invoiced Cost(LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}