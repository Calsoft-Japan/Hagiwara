pageextension 50050 PurchOrderExt extends "Purchase Order"
{
    layout
    {
        addafter("Quote No.")
        {
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
            }

        }

        addafter("Ship-to Contact")
        {
            field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
            {
                ApplicationArea = all;
            }

        }
    }

}