pageextension 56631 SalesRtnOrdSubformExt extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Approved Quantity"; Rec."Approved Quantity")
            {
                ApplicationArea = all;
            }
            field("Approved Unit Price"; Rec."Approved Unit Price")
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