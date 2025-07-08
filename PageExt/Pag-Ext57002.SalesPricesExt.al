pageextension 57002 SalesPricesExt extends "Sales Prices"
{
    layout
    {
        addlast(Content)
        {
            field("Published Price"; Rec."Published Price")
            {
                ApplicationArea = all;
            }
            field("Cost"; Rec."Cost")
            {
                ApplicationArea = all;
            }
            field("Cost-plus %"; Rec."Cost-plus %")
            {
                ApplicationArea = all;
            }
            field("Discount Amount"; Rec."Discount Amount")
            {
                ApplicationArea = all;
            }
            field("Renesas Report Unit Price Cur."; Rec."Renesas Report Unit Price Cur.")
            {
                ApplicationArea = all;
            }
            field("Renesas Report Unit Price"; Rec."Renesas Report Unit Price")
            {
                ApplicationArea = all;
            }
        }
    }
}