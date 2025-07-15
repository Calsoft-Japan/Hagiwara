pageextension 50054 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        modify("Line No.")
        {
            Visible = true;
        }

        addbefore(Type)
        {
            field("ORE Line No."; rec."ORE Line No.")
            {

                ApplicationArea = all;
            }
        }

        addafter("No.")
        {
            field("Blocked"; rec."Blocked")
            {

                ApplicationArea = all;
            }
            field("Buy-from Vendor No."; rec."Buy-from Vendor No.")
            {

                ApplicationArea = all;
            }
            field("SO No."; rec."SO No.")
            {

                ApplicationArea = all;
            }
            field("Item Supplier Source"; rec."Item Supplier Source")
            {

                ApplicationArea = all;
            }
            field("CO No."; rec."CO No.")
            {

                ApplicationArea = all;
            }
            field("Purchasing Code"; rec."Purchasing Code")
            {

                ApplicationArea = all;
            }

            field("Vendor Item No."; rec."Vendor Item No.")
            {

                ApplicationArea = all;
            }

        }

        addafter(Nonstock)
        {
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
            field(Products; rec.Products)
            {

                ApplicationArea = all;
            }

        }

        addafter(Quantity)
        {

            field("Outstanding Quantity"; rec."Outstanding Quantity")
            {

                ApplicationArea = all;
            }

        }

        addafter("Line Discount Amount")
        {

            field(Amount; rec.Amount)
            {

                ApplicationArea = all;
            }
            field("Amount Including VAT"; rec."Amount Including VAT")
            {

                ApplicationArea = all;
            }
            field("Outstanding Amount"; rec."Outstanding Amount")
            {

                ApplicationArea = all;
            }
            field("Outstanding Amount (LCY)"; rec."Outstanding Amount (LCY)")
            {

                ApplicationArea = all;
            }

        }

        addafter("Requested Receipt Date")
        {

            field("Requested Receipt Date_1"; rec."Requested Receipt Date_1")
            {

                ApplicationArea = all;
            }
            field("Goods Arrival Date"; rec."Goods Arrival Date")
            {

                ApplicationArea = all;
            }
        }

        addafter("Deferral Code")
        {

            field("Update Date"; rec."Update Date")
            {

                ApplicationArea = all;
            }
            field("Update Time"; rec."Update Time")
            {

                ApplicationArea = all;
            }
            field("Update By"; rec."Update By")
            {

                ApplicationArea = all;
            }

        }

        addafter("Document No.")
        {

            field("ORE Message Status"; rec."ORE Message Status")
            {

                ApplicationArea = all;
            }
            field("ORE Change Status"; rec."ORE Change Status")
            {

                ApplicationArea = all;
            }
        }


        modify("No.")
        {
            Editable = ItemNoEditable;
        }

    }


    var
        ItemNoEditable: Boolean;


    trigger OnAfterGetRecord()
    begin

        //CS060 Shawn Begin
        ItemNoEditable := TRUE;
        IF rec."ORE Message Status" IN [rec."ORE Message Status"::Collected, rec."ORE Message Status"::Sent] THEN
            ItemNoEditable := FALSE;
        //CS060 Shawn end

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //HG10.00.02 NJ 01/06/2017

        IF rec."Document No." <> '' THEN
            rec.VALIDATE(Type);

        //HG10.00.02 NJ 01/06/2017

        //CS060 Shawn Begin
        ItemNoEditable := TRUE;
        //CS060 Shawn end

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin


        //CS060 Shawn Begin
        ItemNoEditable := TRUE;
        IF rec."ORE Message Status" IN [rec."ORE Message Status"::Collected, rec."ORE Message Status"::Sent] THEN
            ItemNoEditable := FALSE;
        //CS060 Shawn end

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //CS060
        IF rec."ORE Message Status" IN [rec."ORE Message Status"::Collected, rec."ORE Message Status"::Sent] THEN
            ERROR('You can not delete record with "Sent" ORE message status');
        //CS060


    end;
}