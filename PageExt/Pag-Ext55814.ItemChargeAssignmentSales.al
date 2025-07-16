pageextension 55814 ItemChargeAssignmentSalesExt extends "Item Charge Assignment (Sales)"
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