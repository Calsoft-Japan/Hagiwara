pageextension 56641 PurchaseRtnOrdSubformExt extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Direct Unit Cost")
        {
            field("Approved Quantity"; Rec."Approved Quantity")
            {
                ApplicationArea = all;
            }
            field("Approved Unit Cost"; Rec."Approved Unit Cost")
            {
                ApplicationArea = all;
            }
            field("Approval History Exists"; Rec."Approval History Exists")
            {
                ApplicationArea = all;
            }
        }
    }
}