pageextension 50038 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {

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

        }

    }

    trigger OnAfterGetRecord()
    begin

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


}