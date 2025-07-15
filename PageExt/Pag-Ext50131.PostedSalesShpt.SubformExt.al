pageextension 50131 PostedSalesShptSubformExt extends "Posted Sales Shpt. Subform"
{
    layout
    {

        addbefore(Type)
        {


            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = all;
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }

        addafter("No.")
        {

            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Booking No."; Rec."Booking No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("OEM No."; Rec."OEM No.")
            {
                ApplicationArea = all;
                Editable = true;
                HideValue = false;
            }
            field("OEM Name"; Rec."OEM Name")
            {
                ApplicationArea = all;
                Editable = TRUE;
            }
            field(Products; Rec.Products)
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Customer Order No."; Rec."Customer Order No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Parts No."; Rec."Parts No.")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field(Rank; Rec.Rank)
            {
                ApplicationArea = all;
                Editable = true;
            }

        }

        addafter("Planned Shipment Date")
        {

            field(Insertion; Rec.Insertion)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Edition; Rec.Edition)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Message Status"; Rec."Message Status")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Shipment Collection Date"; Rec."Shipment Collection Date")
            {
                ApplicationArea = all;
            }
            field("Update Date"; Rec."Update Date")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Update Time"; Rec."Update Time")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Update By"; Rec."Update By")
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Shipment Seq. No."; Rec."Shipment Seq. No.")
            {
                BlankNumbers = BlankZero;
                BlankZero = true;
                ApplicationArea = all;
                Editable = true;
            }
            field("Save Posting Date"; Rec."Save Posting Date")
            {
                ApplicationArea = all;
                Editable = true;
            }


            field("Attached to Line No."; Rec."Attached to Line No.")
            {
                ApplicationArea = all;
            }

        }

    }
}