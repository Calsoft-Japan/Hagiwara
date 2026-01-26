pageextension 50516 SalesLinesExt extends "Sales Lines"
{
    layout
    {

        addafter("No.")
        {

            field("Customer Item No."; rec."Customer Item No.")
            {

                ApplicationArea = all;
            }
            field("Parts No."; rec."Parts No.")
            {

                ApplicationArea = all;
            }
            field("Rank"; rec."Rank")
            {

                ApplicationArea = all;
            }
            field("Products"; rec."Products")
            {

                ApplicationArea = all;
            }
            field("OEM No."; rec."OEM No.")
            {

                ApplicationArea = all;
            }
            field("Order Date"; OrderDate)
            {

                ApplicationArea = all;
            }
            field("Promised Delivery Date"; rec."Promised Delivery Date")
            {

                ApplicationArea = all;
            }
            field("Requested Delivery Date"; rec."Requested Delivery Date")
            {

                ApplicationArea = all;
            }
            field("Promised Delivery Date_1"; rec."Promised Delivery Date_1")
            {

                ApplicationArea = all;
            }
            field("Requested Delivery Date_1"; rec."Requested Delivery Date_1")
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


        }

        addafter("Reserved Qty. (Base)")
        {



            field("Fully Reserved"; rec."Fully Reserved")
            {

                ApplicationArea = all;
            }

        }

        addafter("Unit of Measure Code")
        {

            field("Unit Price"; rec."Unit Price")
            {

                ApplicationArea = all;
            }
            field("Unit Cost"; rec."Unit Cost")
            {

                ApplicationArea = all;
            }
            field("Unit Cost (LCY)"; rec."Unit Cost (LCY)")
            {

                ApplicationArea = all;
            }


        }

        addafter("Line Amount")
        {

            field("Line Amount Excl. VAT (LCY)"; LineAmtExclVAT_LCY)
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
            field("Outstanding Qty. (Base)"; rec."Outstanding Qty. (Base)")
            {

                ApplicationArea = all;
            }

        }

    }

    var
        OrderDate: Date;
        ItemMaster: Record Item;
        RecSalesHeader: Record "Sales Header";
        LineAmtExclVAT_LCY: Decimal;

    trigger OnAfterGetRecord()
    begin

        // YUKA for Hagiwara 20030602
        RecSalesHeader.SETRANGE(RecSalesHeader."Document Type", Rec."Document Type");
        RecSalesHeader.SETRANGE(RecSalesHeader."No.", Rec."Document No.");
        IF RecSalesHeader.FIND('-') THEN BEGIN
            IF Rec.Type = Rec.Type::Item THEN BEGIN
                OrderDate := RecSalesHeader."Order Date";
            END ELSE BEGIN
                OrderDate := 0D;
            END;
            // YUKA for Hagiwara 20030602 - END

            // SiakHui for Hagiwara 20110324
            IF Rec.Type = Rec.Type::Item THEN
                ItemMaster.SETRANGE(ItemMaster."No.", Rec."No.");
            IF ItemMaster.FIND('-') THEN
                Rec.Products := ItemMaster.Products;
        END;

        // SiakHui for Hagiwara 20110324 = END
        LineAmtExclVAT_LCY := ROUND(Rec.Quantity * Rec."Unit Price");
        RecSalesHeader.SETRANGE(RecSalesHeader."Document Type", Rec."Document Type");
        RecSalesHeader.SETRANGE(RecSalesHeader."No.", Rec."Document No.");
        IF RecSalesHeader.FIND('-') THEN BEGIN
            IF RecSalesHeader."Currency Factor" > 0 THEN BEGIN
                LineAmtExclVAT_LCY := ROUND(Rec.Quantity * Rec."Unit Price" / RecSalesHeader."Currency Factor");
            END;
        END;

    end;
}