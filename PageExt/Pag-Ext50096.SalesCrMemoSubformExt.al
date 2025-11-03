pageextension 50096 SalesCrMemoSubformExt extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Quantity to Update"; Rec."Quantity to Update")
            {
                ApplicationArea = all;
            }
            field("Unit Price to Update"; Rec."Unit Price to Update")
            {
                ApplicationArea = all;
            }
        }

    }

}