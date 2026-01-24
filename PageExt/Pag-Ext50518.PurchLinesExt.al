pageextension 50518 PurchLinesExt extends "Purchase Lines"
{
    layout
    {

        addafter("No.")
        {

            field("CO No."; rec."CO No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }

        }

        addafter("Outstanding Quantity")
        {
            field("Approved Quantity"; Rec."Approved Quantity")
            {
                ApplicationArea = all;
            }
        }
    }
}