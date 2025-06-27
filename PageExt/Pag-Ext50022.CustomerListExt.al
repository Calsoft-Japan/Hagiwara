pageextension 50022 CustomerListExt extends "Customer List"
{
    layout
    {
        addlast(Content)
        {
            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = all;
            }
            field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
            {
                ApplicationArea = all;
            }
            field("Address"; Rec."Address")
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field("City"; Rec."CITY")
            {
                ApplicationArea = all;
            }

            field("Receiving Location"; Rec."Receiving Location")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
            }
            field("Days for Auto Inv. Reservation"; Rec."Days for Auto Inv. Reservation")
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field("Default Country/Region of Org"; Rec."Default Country/Region of Org")
            {
                ApplicationArea = all;
            }
        }
    }
}