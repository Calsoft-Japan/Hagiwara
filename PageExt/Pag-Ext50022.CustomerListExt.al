pageextension 50022 CustomerListExt extends "Customer List"
{
    layout
    {

        addafter("No.")
        {

            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
        }

        addafter(Name)
        {

            field("Shipment Method Code"; Rec."Shipment Method Code")
            {
                ApplicationArea = all;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
            }
            field("Days for Auto Inv. Reservation"; Rec."Days for Auto Inv. Reservation")
            {
                ApplicationArea = all;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field("Home Page"; Rec."Home Page")
            {
                ApplicationArea = all;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                ApplicationArea = all;
            }
            field(County; Rec.County)
            {
                ApplicationArea = all;
            }
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
                Style = StrongAccent;
            }
        }

        addafter("Location Code")
        {

            field("Receiving Location"; Rec."Receiving Location")
            {
                ApplicationArea = all;
            }
        }

        addafter("Language Code")
        {

            field("NEC OEM Code"; Rec."NEC OEM Code")
            {
                ApplicationArea = all;
            }
            field("NEC OEM Name"; Rec."NEC OEM Name")
            {
                ApplicationArea = all;
            }
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = all;
            }
        }

        addafter("Base Calendar Code")
        {

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }

        }

        addafter("Sales (LCY)")
        {

            field("Default Country/Region of Org"; Rec."Default Country/Region of Org")
            {
                ApplicationArea = all;
            }
        }


    }
}