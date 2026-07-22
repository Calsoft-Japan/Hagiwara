pageextension 50025 CustLedgerEntryExt extends "Customer Ledger Entries"
{
    layout
    {

        addafter("Sales (LCY)")
        {

            field("Total VAT (LCY)"; VATAmountLCY)
            {
                ApplicationArea = all;
            }
        }
    }

    var
        VATAmountLCY: Decimal;

    trigger OnAfterGetRecord()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        Rec.CalcFields("Amount (LCY)");
        VATAmountLCY := Rec."Amount (LCY)" - Rec."Sales (LCY)";

    end;
}