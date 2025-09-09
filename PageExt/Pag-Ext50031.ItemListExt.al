// pageextension 50031 ItemListExt extends "Item List"
// {
//     layout
//     {

//         addafter("No.")
//         {

//             field("Original Item No."; Rec."Original Item No.")
//             {
//                 ApplicationArea = all;
//             }
//             field("Familiar Name"; Rec."Familiar Name")
//             {
//                 ApplicationArea = all;
//             }
//         }

//         addafter(InventoryField)
//         {

//             field(Hold; Rec.Hold)
//             {
//                 ApplicationArea = all;
//             }
//             field("FCA In-Transit"; Rec."FCA In-Transit")
//             {
//                 ApplicationArea = all;
//             }
//             field("Available Inventory Balance"; Rec.Inventory - Rec.Hold - Rec."FCA In-Transit")
//             {
//                 ApplicationArea = all;
//             }
//             field("Latest Sales Price"; LatestSalesPrice)
//             {
//                 ApplicationArea = all;
//                 Caption = 'Latest Sales Price';
//                 DecimalPlaces = 2 : 5;
//             }
//             field("Latest Purchase Price"; LatestPurchasePrice)
//             {
//                 ApplicationArea = all;
//                 Caption = 'Latest Purchase Price';
//                 DecimalPlaces = 2 : 5;
//             }
//             field("No. 2"; Rec."No. 2")
//             {
//                 ApplicationArea = all;
//             }
//             field("OEM No."; Rec."OEM No.")
//             {
//                 ApplicationArea = all;
//             }
//             field("Customer No."; Rec."Customer No.")
//             {
//                 ApplicationArea = all;
//             }
//             field("Customer Item No."; Rec."Customer Item No.")
//             {
//                 ApplicationArea = all;
//             }
//             field("Customer Item No.(Plain)"; Rec."Customer Item No.(Plain)")
//             {
//                 ApplicationArea = all;
//             }
//             field("Item Supplier Source"; Rec."Item Supplier Source")
//             {
//                 ApplicationArea = all;
//                 Style = StrongAccent;
//             }
//             field(Memo; Rec.Memo)
//             {
//                 ApplicationArea = all;
//             }
//             field("One Renesas EDI"; Rec."One Renesas EDI")
//             {
//                 ApplicationArea = all;
//             }
//             field("Excluded in Inventory Report"; Rec."Excluded in Inventory Report")
//             {
//                 ApplicationArea = all;
//             }
//             field("Order Multiple"; Rec."Order Multiple")
//             {
//                 ApplicationArea = all;
//             }
//         }

//         addafter("Costing Method")
//         {


//             field("Manufacturer Code"; Rec."Manufacturer Code")
//             {
//                 ApplicationArea = all;
//             }
//             field("Manufacturer 2 Code"; Rec."Manufacturer 2 Code")
//             {
//                 ApplicationArea = all;
//             }
//         }

//         addafter("Standard Cost")
//         {


//             field("Parts No."; Rec."Parts No.")
//             {
//                 ApplicationArea = all;
//             }
//             field(Rank; Rec.Rank)
//             {
//                 ApplicationArea = all;
//             }
//             field(SBU; Rec.SBU)
//             {
//                 ApplicationArea = all;
//             }
//             field(Products; Rec.Products)
//             {
//                 ApplicationArea = all;
//             }
//             field(EOL; Rec.EOL)
//             {
//                 ApplicationArea = all;
//             }
//             field("Order Deadline Date"; Rec."Order Deadline Date")
//             {
//                 ApplicationArea = all;
//             }
//             field("Service Parts"; Rec."Service Parts")
//             {
//                 ApplicationArea = all;
//             }
//             field(EDI; Rec.EDI)
//             {
//                 ApplicationArea = all;
//             }
//             field("Country/Region of Org Cd (FE)"; Rec."Country/Region of Org Cd (FE)")
//             {
//                 ApplicationArea = all;
//                 Caption = 'Country/Region of Origin Code (Front-end)';
//             }
//             field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
//             {
//                 ApplicationArea = all;
//                 Caption = 'Country/Region of Origin Code (Back-end)';
//             }
//             field("Markup%"; Rec."Markup%")
//             {
//                 Enabled = false;
//                 ApplicationArea = all;
//                 Visible = false;
//             }
//             field("Markup%(Sales Price)"; Rec."Markup%(Sales Price)")
//             {
//                 ApplicationArea = all;
//             }
//             field("Markup%(Purchase Price)"; Rec."Markup%(Purchase Price)")
//             {
//                 ApplicationArea = all;
//             }
//             field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
//             {
//                 ApplicationArea = all;
//             }
//         }

//         addafter("Unit Price")
//         {


//             field("Lot Size"; Rec."Lot Size")
//             {
//                 ApplicationArea = all;
//             }
//             field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
//             {
//                 ApplicationArea = all;
//             }
//             field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
//             {
//                 ApplicationArea = all;
//             }
//         }

//         addafter("Default Deferral Template Code")
//         {


//             field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
//             {
//                 ApplicationArea = all;
//             }
//             field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
//             {
//                 ApplicationArea = all;
//             }
//             field("Car Model"; Rec."Car Model")
//             {
//                 ApplicationArea = all;
//             }
//             field(SOP; Rec.SOP)
//             {
//                 ApplicationArea = all;
//             }
//             field("MP-Volume(pcs/M)"; Rec."MP-Volume(pcs/M)")
//             {
//                 ApplicationArea = all;
//             }
//             field(Apl; Rec.Apl)
//             {
//                 ApplicationArea = all;
//             }
//         }

//     }

//     trigger OnAfterGetRecord()
//     begin

//         //SH: 29 July 2014
//         //Highlight No., Name and Item Supplier Source with Style = StrongAccent for Renesas Item
//         //StyleIsStrong := "Item Supplier Source" = "Item Supplier Source"::Renesas;

//         //CS055 Start
//         SalesPriceRec.RESET;
//         SalesPriceRec.SETFILTER("Item No.", Rec."No.");
//         SalesPriceRec.SETASCENDING("Starting Date", FALSE);
//         IF SalesPriceRec.FINDFIRST THEN
//             LatestSalesPrice := SalesPriceRec."Unit Price"
//         ELSE
//             LatestSalesPrice := 0;

//         PurchasePriceRec.RESET;
//         PurchasePriceRec.SETFILTER("Item No.", Rec."No.");
//         PurchasePriceRec.SETASCENDING("Starting Date", FALSE);
//         IF PurchasePriceRec.FINDFIRST THEN
//             LatestPurchasePrice := PurchasePriceRec."Direct Unit Cost"
//         ELSE
//             LatestPurchasePrice := 0;
//         //CS055 End
//     end;

//     var
//         SalesPriceRec: Record "Sales Price";
//         PurchasePriceRec: Record "Purchase Price";

//         LatestSalesPrice: Decimal;
//         LatestPurchasePrice: Decimal;

// }




pageextension 50031 ItemListExt extends "Item List"
{
    layout
    {
        // N002: Add stored shortcut dimension fields to Item List
        addlast(Control1)
        {
            field("Shortcut Dimension 1 Code"; ShortcutDimValue1)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(1);
            }
            field("Shortcut Dimension 2 Code"; ShortcutDimValue2)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(2);
            }
            field("Shortcut Dimension 3 Code"; ShortcutDimValue3)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(3);
            }
            field("Shortcut Dimension 4 Code"; ShortcutDimValue4)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(4);
            }
            field("Shortcut Dimension 5 Code"; ShortcutDimValue5)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(5);
            }
            field("Shortcut Dimension 6 Code"; ShortcutDimValue6)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(6);
            }
            field("Shortcut Dimension 7 Code"; ShortcutDimValue7)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(7);
            }
            field("Shortcut Dimension 8 Code"; ShortcutDimValue8)
            {
                ApplicationArea = All;
                CaptionClass = GetDimCaption(8);
            }

        }

        // Existing custom fields after "No."
        addafter("No.")
        {
            field("Original Item No."; Rec."Original Item No.") { ApplicationArea = All; }
            field("Familiar Name"; Rec."Familiar Name") { ApplicationArea = All; }
        }

        // Existing custom fields after Inventory
        addafter(InventoryField)
        {
            field(Hold; Rec.Hold) { ApplicationArea = All; }
            field("FCA In-Transit"; Rec."FCA In-Transit") { ApplicationArea = All; }
            field("Available Inventory Balance"; Rec.Inventory - Rec.Hold - Rec."FCA In-Transit")
            {
                ApplicationArea = All;
            }
            field("Latest Sales Price"; LatestSalesPrice)
            {
                ApplicationArea = All;
                Caption = 'Latest Sales Price';
                DecimalPlaces = 2 : 5;
            }
            field("Latest Purchase Price"; LatestPurchasePrice)
            {
                ApplicationArea = All;
                Caption = 'Latest Purchase Price';
                DecimalPlaces = 2 : 5;
            }
            field("No. 2"; Rec."No. 2") { ApplicationArea = All; }
            field("OEM No."; Rec."OEM No.") { ApplicationArea = All; }
            field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
            field("Customer Item No."; Rec."Customer Item No.") { ApplicationArea = All; }
            field("Customer Item No.(Plain)"; Rec."Customer Item No.(Plain)") { ApplicationArea = All; }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = All;
                Style = StrongAccent;
            }
            field(Memo; Rec.Memo) { ApplicationArea = All; }
            field("One Renesas EDI"; Rec."One Renesas EDI") { ApplicationArea = All; }
            field("Excluded in Inventory Report"; Rec."Excluded in Inventory Report") { ApplicationArea = All; }
            field("Order Multiple"; Rec."Order Multiple") { ApplicationArea = All; }
        }

        addafter("Costing Method")
        {
            field("Manufacturer Code"; Rec."Manufacturer Code") { ApplicationArea = All; }
            field("Manufacturer 2 Code"; Rec."Manufacturer 2 Code") { ApplicationArea = All; }
        }

        addafter("Standard Cost")
        {
            field("Parts No."; Rec."Parts No.") { ApplicationArea = All; }
            field(Rank; Rec.Rank) { ApplicationArea = All; }
            field(SBU; Rec.SBU) { ApplicationArea = All; }
            field(Products; Rec.Products) { ApplicationArea = All; }
            field(EOL; Rec.EOL) { ApplicationArea = All; }
            field("Order Deadline Date"; Rec."Order Deadline Date") { ApplicationArea = All; }
            field("Service Parts"; Rec."Service Parts") { ApplicationArea = All; }
            field(EDI; Rec.EDI) { ApplicationArea = All; }
            field("Country/Region of Org Cd (FE)"; Rec."Country/Region of Org Cd (FE)")
            {
                ApplicationArea = All;
                Caption = 'Country/Region of Origin Code (Front-end)';
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Caption = 'Country/Region of Origin Code (Back-end)';
            }
            field("Markup%"; Rec."Markup%")
            {
                Enabled = false;
                ApplicationArea = All;
                Visible = false;
            }
            field("Markup%(Sales Price)"; Rec."Markup%(Sales Price)") { ApplicationArea = All; }
            field("Markup%(Purchase Price)"; Rec."Markup%(Purchase Price)") { ApplicationArea = All; }
            field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code") { ApplicationArea = All; }
        }

        addafter("Unit Price")
        {
            field("Lot Size"; Rec."Lot Size") { ApplicationArea = All; }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order") { ApplicationArea = All; }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order") { ApplicationArea = All; }
        }

        addafter("Default Deferral Template Code")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = All; }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = All; }
            field("Car Model"; Rec."Car Model") { ApplicationArea = All; }
            field(SOP; Rec.SOP) { ApplicationArea = All; }
            field("MP-Volume(pcs/M)"; Rec."MP-Volume(pcs/M)") { ApplicationArea = All; }
            field(Apl; Rec.Apl) { ApplicationArea = All; }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // Load latest sales price
        SalesPriceRec.Reset();
        SalesPriceRec.SetRange("Price Type", SalesPriceRec."Price Type"::Sale);
        SalesPriceRec.SetRange(Status, SalesPriceRec.Status::Active);
        SalesPriceRec.SetRange("Asset No.", Rec."No.");
        SalesPriceRec.SetCurrentKey("Starting Date");
        SalesPriceRec.SetAscending("Starting Date", false);
        if SalesPriceRec.FindFirst() then
            LatestSalesPrice := SalesPriceRec."Unit Price"
        else
            LatestSalesPrice := 0;

        // Load latest purchase price
        PurchasePriceRec.Reset();
        PurchasePriceRec.SetRange("Price Type", PurchasePriceRec."Price Type"::Purchase);
        PurchasePriceRec.SetRange(Status, PurchasePriceRec.Status::Active);
        PurchasePriceRec.SetRange("Asset No.", Rec."No.");
        PurchasePriceRec.SetCurrentKey("Starting Date");
        PurchasePriceRec.SetAscending("Starting Date", false);
        if PurchasePriceRec.FindFirst() then
            LatestPurchasePrice := PurchasePriceRec."Direct Unit Cost"
        else
            LatestPurchasePrice := 0;

        // Load dimension values from Default Dimension table (⚠ for display only — not reliable in list view)
        GLSetup.Get();
        LoadDimensionData(GLSetup."Shortcut Dimension 1 Code", ShortcutDimValue1);
        LoadDimensionData(GLSetup."Shortcut Dimension 2 Code", ShortcutDimValue2);
        LoadDimensionData(GLSetup."Shortcut Dimension 3 Code", ShortcutDimValue3);
        LoadDimensionData(GLSetup."Shortcut Dimension 4 Code", ShortcutDimValue4);
        LoadDimensionData(GLSetup."Shortcut Dimension 5 Code", ShortcutDimValue5);
        LoadDimensionData(GLSetup."Shortcut Dimension 6 Code", ShortcutDimValue6);
        LoadDimensionData(GLSetup."Shortcut Dimension 7 Code", ShortcutDimValue7);
        LoadDimensionData(GLSetup."Shortcut Dimension 8 Code", ShortcutDimValue8);
    end;

    // Load dimension value from Default Dimension table
    local procedure LoadDimensionData(DimCode: Code[20]; var DimValue: Text[100])
    var
        DefaultDim: Record "Default Dimension";
    begin
        if DefaultDim.Get(Database::Item, Rec."No.", DimCode) then
            DimValue := DefaultDim."Dimension Value Code"
        else
            DimValue := '';
    end;

    // Get the display name of the dimension for caption
    local procedure GetDimCaption(DimNo: Integer): Text[100]
    var
        GLSetup: Record "General Ledger Setup";
        Dim: Record Dimension;
        DimCode: Code[20];
    begin
        GLSetup.Get();
        DimCode := GetDimCode(DimNo);
        if Dim.Get(DimCode) then
            exit(Dim.Name)
        else
            exit('');
    end;

    // Get dimension code from General Ledger Setup by number
    local procedure GetDimCode(DimNo: Integer): Code[20]
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        case DimNo of
            1:
                exit(GLSetup."Shortcut Dimension 1 Code");
            2:
                exit(GLSetup."Shortcut Dimension 2 Code");
            3:
                exit(GLSetup."Shortcut Dimension 3 Code");
            4:
                exit(GLSetup."Shortcut Dimension 4 Code");
            5:
                exit(GLSetup."Shortcut Dimension 5 Code");
            6:
                exit(GLSetup."Shortcut Dimension 6 Code");
            7:
                exit(GLSetup."Shortcut Dimension 7 Code");
            8:
                exit(GLSetup."Shortcut Dimension 8 Code");
            else
                exit('');
        end;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SalesPriceRec: Record "Price List Line";
        PurchasePriceRec: Record "Price List Line";

        LatestSalesPrice: Decimal;
        LatestPurchasePrice: Decimal;

        ShortcutDimValue1: Text[100];
        ShortcutDimValue2: Text[100];
        ShortcutDimValue3: Text[100];
        ShortcutDimValue4: Text[100];
        ShortcutDimValue5: Text[100];
        ShortcutDimValue6: Text[100];
        ShortcutDimValue7: Text[100];
        ShortcutDimValue8: Text[100];
}
