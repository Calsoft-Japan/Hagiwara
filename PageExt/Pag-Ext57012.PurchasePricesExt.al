pageextension 57012 PurchasePricesExt extends "Purchase Prices"
{
    layout
    {
        addlast(Content)
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
        }
    }
}