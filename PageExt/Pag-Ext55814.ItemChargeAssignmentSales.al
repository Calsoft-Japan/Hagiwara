pageextension 55814 ItemChargeAssignmentSalesExt extends "Item Charge Assignment Sales"
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