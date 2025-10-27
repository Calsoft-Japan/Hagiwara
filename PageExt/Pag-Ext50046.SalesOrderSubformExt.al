pageextension 50046 SalesOrderSubformExt extends "Sales Order Subform"
{
    layout
    {

        addafter("No.")
        {


            field("Item Supplier Source"; rec."Item Supplier Source")
            {

                ApplicationArea = all;
            }
            field("Booking No."; rec."Booking No.")
            {

                ApplicationArea = all;
            }
            field("Serial No."; rec."Serial No.")
            {

                ApplicationArea = all;
            }
            field("Vendor Item Number"; rec."Vendor Item Number")
            {

                ApplicationArea = all;
            }
            field(Blocked; rec.Blocked)
            {

                ApplicationArea = all;
            }
            field("Shipped Quantity"; rec."Shipped Quantity")
            {

                ApplicationArea = all;
            }
            field("OEM No."; rec."OEM No.")
            {

                ApplicationArea = all;
            }
            field("OEM Name"; rec."OEM Name")
            {

                ApplicationArea = all;
            }
            field("Currency Code"; rec."Currency Code")
            {

                ApplicationArea = all;
            }

            field(Products; rec.Products)
            {

                ApplicationArea = all;
            }
        }


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
            field("Parts No."; rec."Parts No.")
            {

                ApplicationArea = all;
            }
            field(Rank; rec.Rank)
            {

                ApplicationArea = all;
            }
        }


        addafter("Bin Code")
        {
            field("Fully Reserved"; rec."Fully Reserved")
            {

                ApplicationArea = all;
            }

        }

        addafter("Quantity Shipped")
        {

            field("Outstanding Quantity"; rec."Outstanding Quantity")
            {

                ApplicationArea = all;
            }
            field("Outstanding Quantity (Actual)"; rec."Outstanding Quantity (Actual)")
            {

                ApplicationArea = all;
            }
            field("Outstanding Qty. (Base)"; rec."Outstanding Qty. (Base)")
            {

                ApplicationArea = all;
            }
        }

        addafter("Unit of Measure")
        {

            field("Unit Cost"; rec."Unit Cost")
            {

                ApplicationArea = all;
            }
        }

        addafter("Requested Delivery Date")
        {


            field("Requested Delivery Date_1"; rec."Requested Delivery Date_1")
            {

                ApplicationArea = all;
            }

        }
        addafter("Promised Delivery Date")
        {


            field("Promised Delivery Date_1"; rec."Promised Delivery Date_1")
            {

                ApplicationArea = all;
            }

        }

        addafter("Document No.")
        {

            field("Original Doc. No."; rec."Original Doc. No.")
            {

                ApplicationArea = all;
            }
            field("Original Booking No."; rec."Original Booking No.")
            {

                ApplicationArea = all;
            }
            field("Original Line No."; rec."Original Line No.")
            {

                ApplicationArea = all;
            }
            field("Message Status"; rec."Message Status")
            {

                ApplicationArea = all;
                Editable = false;
            }
            field("Message Status (JC)"; rec."Message Status (JC)")
            {

                ApplicationArea = all;
                Editable = false;
            }
            field("JA Collection Date"; rec."JA Collection Date")
            {

                ApplicationArea = all;
                Editable = false;
            }
            field("JC Collection Date"; rec."JC Collection Date")
            {

                ApplicationArea = all;
                Editable = false;
            }
            field("Update Date"; rec."Update Date")
            {

                ApplicationArea = all;
                Editable = false;
            }

            field("Update Time"; rec."Update Time")
            {

                ApplicationArea = all;
                Editable = false;
            }
            field("Update By"; rec."Update By")
            {

                ApplicationArea = all;
                Editable = false;
            }
            field("Shipment Seq. No."; rec."Shipment Seq. No.")
            {

                ApplicationArea = all;
            }
            field("Next Shipment Seq. No."; rec."Next Shipment Seq. No.")
            {

                ApplicationArea = all;
            }
            field("Save Customer Order No."; rec."Save Customer Order No.")
            {

                ApplicationArea = all;
            }
            field("Save Posting Date"; rec."Save Posting Date")
            {

                ApplicationArea = all;
            }

        }

        addafter("Unit Price")
        {

            field("Price Target Update"; rec."Price Target Update")
            {

                ApplicationArea = all;
            }
            field("Quantity to Update"; Rec."Quantity to Update")
            {
                ApplicationArea = all;
            }
            field("Unit Price to Update"; Rec."Unit Price to Update")
            {
                ApplicationArea = all;
            }
        }

    }

    trigger OnOpenPage()
    var
        SalesHeader: Record "Sales Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        /*
        recApprSetup.Get();
        if recApprSetup."Sales Order" then begin
            SalesHeader := Rec.GetSalesHeader();
            if SalesHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                CurrPage.Editable(false);
            end else begin
                CurrPage.Editable(true);
            end;
        end;
        */
    end;

    trigger OnAfterGetRecord()
    begin
        rec."Fully Reserved" := (rec."Reserved Quantity" > 0) AND (rec."Reserved Quantity" = rec."Outstanding Quantity");//CS018
        //MODIFY();//CS018
    end;

}