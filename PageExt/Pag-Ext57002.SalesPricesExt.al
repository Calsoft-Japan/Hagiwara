pageextension 57002 SalesPricesExt extends "Sales Prices"
{
    layout
    {
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Renesas Report Unit Price Cur."; Rec."Renesas Report Unit Price Cur.")
            {
                ApplicationArea = all;
            }
            field("Renesas Report Unit Price"; Rec."Renesas Report Unit Price")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        SalesPriceRec: Record "Sales Price";
        Text002: Label 'Starting Date must have a value in Sales Price: Item No.=%1. It cannot be zero or empty.';

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        //CS058 Begin
        SalesPriceRec.RESET;
        SalesPriceRec.SETRANGE("Item No.", rec.GETFILTER("Item No."));
        SalesPriceRec.SETFILTER("Starting Date", '%1', 0D);
        IF SalesPriceRec.FINDFIRST THEN BEGIN
            ERROR(Text002, SalesPriceRec."Item No.");
        END;
        //CS058 End
    end;
}