pageextension 57011 PurchasePriceListLinesExt extends "Purchase Price List Lines"
{
    layout
    {
        modify("Variant Code")
        {
            Editable = false;
        }

        modify("Minimum Quantity")
        {
            Editable = false;
        }

        addafter(DirectUnitCost)
        {
            field("ORE Debit Cost"; Rec."ORE Debit Cost")
            {
                ApplicationArea = all;
            }
            field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
            {
                ApplicationArea = all;
            }
            field("PC. Currency Code"; Rec."PC. Currency Code")
            {
                ApplicationArea = all;
            }
            field("PC. Direct Unit Cost"; Rec."PC. Direct Unit Cost")
            {
                ApplicationArea = all;
            }
            field("PC. Update Price"; Rec."PC. Update Price")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        PurchasePriceRec: Record "Price List Line";
        Text000: label 'Starting Date must have a value in Purchase Price: Item No.=%1. It cannot be zero or empty.';

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        //CS058 Begin
        PurchasePriceRec.RESET;
        PurchasePriceRec.SETRANGE("Asset No.", rec.GETFILTER("Asset No."));
        PurchasePriceRec.SETFILTER("Starting Date", '%1', 0D);
        IF PurchasePriceRec.FINDFIRST THEN BEGIN
            ERROR(Text000, PurchasePriceRec."Asset No.");
        END;
        //CS058 End


    end;
}