pageextension 55805 ItemChargeAssignmentPurchExt extends "Item Charge Assignment (Purch)"
{
    layout
    {
        addbefore("Applies-to Doc. Type")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}