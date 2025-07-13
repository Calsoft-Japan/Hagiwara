pageextension 50031 ItemListExt extends "Item List"
{
    layout
    {

        addafter("No.")
        {

            field("Original Item No."; Rec."Original Item No.")
            {
                ApplicationArea = all;
            }
            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
        }

        addafter(InventoryField)
        {

            field(Hold; Rec.Hold)
            {
                ApplicationArea = all;
            }
            field("FCA In-Transit"; Rec."FCA In-Transit")
            {
                ApplicationArea = all;
            }
            field("Available Inventory Balance"; Rec.Inventory - Rec.Hold - Rec."FCA In-Transit")
            {
                ApplicationArea = all;
            }
            field("Latest Sales Price"; LatestSalesPrice)
            {
                ApplicationArea = all;
                Caption = 'Latest Sales Price';
                DecimalPlaces = 2 : 5;
            }
            field("Latest Purchase Price"; LatestPurchasePrice)
            {
                ApplicationArea = all;
                Caption = 'Latest Purchase Price';
                DecimalPlaces = 2 : 5;
            }
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = all;
            }
            field("OEM No."; Rec."OEM No.")
            {
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No.(Plain)"; Rec."Customer Item No.(Plain)")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
                Style = StrongAccent;
            }
            field(Memo; Rec.Memo)
            {
                ApplicationArea = all;
            }
            field("One Renesas EDI"; Rec."One Renesas EDI")
            {
                ApplicationArea = all;
            }
            field("Excluded in Inventory Report"; Rec."Excluded in Inventory Report")
            {
                ApplicationArea = all;
            }
            field("Order Multiple"; Rec."Order Multiple")
            {
                ApplicationArea = all;
            }
        }

        addafter("Costing Method")
        {


            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
            field("Manufacturer 2 Code"; Rec."Manufacturer 2 Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Standard Cost")
        {


            field("Parts No."; Rec."Parts No.")
            {
                ApplicationArea = all;
            }
            field(Rank; Rec.Rank)
            {
                ApplicationArea = all;
            }
            field(SBU; Rec.SBU)
            {
                ApplicationArea = all;
            }
            field(Products; Rec.Products)
            {
                ApplicationArea = all;
            }
            field(EOL; Rec.EOL)
            {
                ApplicationArea = all;
            }
            field("Order Deadline Date"; Rec."Order Deadline Date")
            {
                ApplicationArea = all;
            }
            field("Service Parts"; Rec."Service Parts")
            {
                ApplicationArea = all;
            }
            field(EDI; Rec.EDI)
            {
                ApplicationArea = all;
            }
            field("Country/Region of Org Cd (FE)"; Rec."Country/Region of Org Cd (FE)")
            {
                ApplicationArea = all;
                Caption = 'Country/Region of Origin Code (Front-end)';
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = all;
                Caption = 'Country/Region of Origin Code (Back-end)';
            }
            field("Markup%"; Rec."Markup%")
            {
                Enabled = false;
                ApplicationArea = all;
                Visible = false;
            }
            field("Markup%(Sales Price)"; Rec."Markup%(Sales Price)")
            {
                ApplicationArea = all;
            }
            field("Markup%(Purchase Price)"; Rec."Markup%(Purchase Price)")
            {
                ApplicationArea = all;
            }
            field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Unit Price")
        {


            field("Lot Size"; Rec."Lot Size")
            {
                ApplicationArea = all;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
        }

        addafter("Default Deferral Template Code")
        {


            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field("Car Model"; Rec."Car Model")
            {
                ApplicationArea = all;
            }
            field(SOP; Rec.SOP)
            {
                ApplicationArea = all;
            }
            field("MP-Volume(pcs/M)"; Rec."MP-Volume(pcs/M)")
            {
                ApplicationArea = all;
            }
            field(Apl; Rec.Apl)
            {
                ApplicationArea = all;
            }
        }

    }

    trigger OnAfterGetRecord()
    begin

        //SH: 29 July 2014
        //Highlight No., Name and Item Supplier Source with Style = StrongAccent for Renesas Item
        //StyleIsStrong := "Item Supplier Source" = "Item Supplier Source"::Renesas;

        //CS055 Start
        SalesPriceRec.RESET;
        SalesPriceRec.SETFILTER("Item No.", Rec."No.");
        SalesPriceRec.SETASCENDING("Starting Date", FALSE);
        IF SalesPriceRec.FINDFIRST THEN
            LatestSalesPrice := SalesPriceRec."Unit Price"
        ELSE
            LatestSalesPrice := 0;

        PurchasePriceRec.RESET;
        PurchasePriceRec.SETFILTER("Item No.", Rec."No.");
        PurchasePriceRec.SETASCENDING("Starting Date", FALSE);
        IF PurchasePriceRec.FINDFIRST THEN
            LatestPurchasePrice := PurchasePriceRec."Direct Unit Cost"
        ELSE
            LatestPurchasePrice := 0;
        //CS055 End
    end;

    var
        SalesPriceRec: Record "Sales Price";
        PurchasePriceRec: Record "Purchase Price";

        LatestSalesPrice: Decimal;
        LatestPurchasePrice: Decimal;

}
