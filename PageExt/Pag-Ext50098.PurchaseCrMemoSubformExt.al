pageextension 50098 PurchaseCrMemoSubformExt extends "Purch. Cr. Memo Subform"
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