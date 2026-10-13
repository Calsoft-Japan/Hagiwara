pageextension 50138 PostedPurchInvSubformExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addbefore(Type)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
        }
    }
}