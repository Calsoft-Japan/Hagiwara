pageextension 56641 PurchaseRtnOrdSubformExt extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Direct Unit Cost")
        {

            field("Quantity to Update"; Rec."Quantity to Update")
            {
                ApplicationArea = all;
            }
            field("Unit Cost to Update"; Rec."Unit Cost to Update")
            {
                ApplicationArea = all;
            }
        }
    }
}