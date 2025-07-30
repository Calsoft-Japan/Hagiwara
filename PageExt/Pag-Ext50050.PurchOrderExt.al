pageextension 50050 PurchOrderExt extends "Purchase Order"
{
    layout
    {

        addafter("Ship-to Contact")
        {
            field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
            {
                ApplicationArea = all;
            }

        }
    }

}