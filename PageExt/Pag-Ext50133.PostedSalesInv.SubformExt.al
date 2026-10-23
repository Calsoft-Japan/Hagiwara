pageextension 50133 PostedSalesInvSubformExt extends "Posted Sales Invoice Subform"
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
            field("Customer Order No."; rec."Customer Order No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; rec."Customer Item No.")
            {
                ApplicationArea = all;
            }

        }
    }
}