pageextension 50047 SalesInvSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {

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