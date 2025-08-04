pageextension 50038 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
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
            // field("Shortcut Dimension 3 Code"; ShortcutDimValue3)
            // {
            //     ApplicationArea = All;
            //     CaptionClass = GetDimCaption(3);
            // }
            // field("Shortcut Dimension 4 Code"; ShortcutDimValue4)
            // {
            //     ApplicationArea = All;
            //     CaptionClass = GetDimCaption(4);
            // }
            // field("Shortcut Dimension 5 Code"; ShortcutDimValue5)
            // {
            //     ApplicationArea = All;
            //     CaptionClass = GetDimCaption(5);
            // }
            // field("Shortcut Dimension 6 Code"; ShortcutDimValue6)
            // {
            //     ApplicationArea = All;
            //     CaptionClass = GetDimCaption(6);
            // }
            // field("Shortcut Dimension 7 Code"; ShortcutDimValue7)
            // {
            //     ApplicationArea = All;
            //     CaptionClass = GetDimCaption(7);
            // }
            // field("Shortcut Dimension 8 Code"; ShortcutDimValue8)
            // {
            //     ApplicationArea = All;
            //     CaptionClass = GetDimCaption(8);
            // }

        }
        //N002: End of Shortcut Dimension Code fields

        addafter("Document Line No.")
        {

            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }

        }
        addafter("Variant Code")
        {

            field("Item Description"; Rec.Description)
            {
                ApplicationArea = all;
            }

        }

        addafter(Description)
        {

            field(SBU; SBU)
            {
                Caption = 'SBU';
                ApplicationArea = all;
            }
            field("Customer No."; CustNo)
            {
                Caption = 'Customer No.';
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                Caption = 'Customer Item No.';
                ApplicationArea = all;
            }
            field("OEM No."; OEMNo)
            {
                Caption = 'OEM No.';
                ApplicationArea = all;
            }
            field(Product; Product)
            {
                Caption = 'Product';
                ApplicationArea = all;
            }
            field("CO No."; Rec."CO No.")
            {
                ApplicationArea = all;
            }

        }

        addafter("Sales Amount (Actual)")
        {

            field("Unit Price"; g_UnitPrice)
            {
                ApplicationArea = all;
                Caption = 'Unit Price';
            }
            field("Unit Cost"; g_UnitCost)
            {
                ApplicationArea = all;
                Caption = 'Unit Cost';
            }
        }

        addafter("Assemble to Order")
        {

            field("Applies-to Entry"; Rec."Applies-to Entry")
            {
                ApplicationArea = all;
            }
        }


        addafter("Job Task No.")
        {

            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = all;
            }
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = all;
            }
            field(GetTrackingDate; Rec.GetTrackingDate)
            {
                ApplicationArea = all;
                Caption = 'Goods Arrival/Shipment Tracking Date';
            }
            field("ITE Collected"; Rec."ITE Collected")
            {
                ApplicationArea = all;
            }
            field("ITE Manually"; Rec."ITE Manually")
            {
                ApplicationArea = all;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
            field(Hold; Rec.Hold)
            {
                ApplicationArea = all;
            }


        }

    }

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        // Existing Logic to fetch related item details
        ItemRec.SETFILTER(ItemRec."No.", rec."Item No.");
        ItemRec.FIND('-');
        SBU := ItemRec.SBU;
        //Yuka 20060124
        CustNo := ItemRec."Customer No.";
        OEMNo := ItemRec."OEM No.";
        Product := ItemRec.Products;
        //Yuka 20060331
        //Desc := ItemRec.Description;
        //Customer_Item_No := ItemRec."Customer Item No.";  //CS034

        IF rec.Quantity <> 0 THEN BEGIN
            rec.CALCFIELDS("Cost Amount (Actual)");
            rec.CALCFIELDS("Cost Amount (Expected)");
            g_UnitCost := (rec."Cost Amount (Expected)" + rec."Cost Amount (Actual)") / rec.Quantity;
            g_Amount := rec."Remaining Quantity" * g_UnitCost;
            g_UnitPrice := (rec."Sales Amount (Expected)" + rec."Sales Amount (Actual)") / rec.Quantity;
            //  g_Amount := "Remaining Quantity" * g_UnitCost;
        END;

        // N002: Load dimension values from Default Dimension table (⚠ for display only — not reliable in list view)
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

    //N002: Procedure to get the Default Dimension value from Item Ledger Entry
    // Load dimension value from Default Dimension table
    local procedure LoadDimensionData(DimCode: Code[20]; var DimValue: Text[100])
    var
        DefaultDim: Record "Default Dimension";
    begin
        if DefaultDim.Get(Database::Item, Rec."Item No.", DimCode) then
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
        ItemRec: Record Item;
        SBU: Text[50];
        CustNo: Text[50];
        OEMNo: Text[50];
        Product: Text[50];
        Desc: Text[50];
        g_Amount: Decimal;
        g_UnitCost: Decimal;
        g_UnitPrice: Decimal;
        Customer_Item_No: Code[20];

        // Variables for shortcut dimensions like Item List page
        ShortcutDimValue1: Text[100];
        ShortcutDimValue2: Text[100];
        ShortcutDimValue3: Text[100];
        ShortcutDimValue4: Text[100];
        ShortcutDimValue5: Text[100];
        ShortcutDimValue6: Text[100];
        ShortcutDimValue7: Text[100];
        ShortcutDimValue8: Text[100];

}