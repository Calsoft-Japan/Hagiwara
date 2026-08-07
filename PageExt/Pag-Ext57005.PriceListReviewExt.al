pageextension 57005 PriceListReview extends "Price List Line Review"
{
    Editable = false;

    layout
    {
        addafter("Ending Date")
        {
            field("ORE Debit Cost"; Rec."ORE Debit Cost")
            {
                ApplicationArea = all;
            }
            field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
            {
                ApplicationArea = all;
            }
            field("PC. Currency Code"; Rec."PC. Currency Code")
            {
                ApplicationArea = all;
            }
            field("PC. Direct Unit Cost"; Rec."PC. Direct Unit Cost")
            {
                ApplicationArea = all;
            }
            field("PC. Update Price"; Rec."PC. Update Price")
            {
                ApplicationArea = all;
            }
            field("Renesas Report Unit Price"; Rec."Renesas Report Unit Price")
            {
                ApplicationArea = all;
            }
            field("Renesas Report Unit Price Cur."; Rec."Renesas Report Unit Price Cur.")
            {
                ApplicationArea = all;
            }
        }
    }
}