pageextension 55805 ItemChargeAssignmentPurchaseExt extends "Item Charge Assignment Purchase"
{
    layout
    {
        addlast(Content)
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