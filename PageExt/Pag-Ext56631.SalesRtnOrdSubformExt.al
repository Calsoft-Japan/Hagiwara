pageextension 56631 SalesRtnOrdSubformExt extends "Sales Return Order Subform"
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