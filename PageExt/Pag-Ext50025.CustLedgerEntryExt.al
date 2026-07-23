pageextension 50025 CustLedgerEntryExt extends "Customer Ledger Entries"
{
    layout
    {

        addafter("Sales (LCY)")
        {

            field("Total VAT (LCY)"; VATAmountLCY)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    var
        VATAmountLCY: Decimal;

    trigger OnAfterGetRecord()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        VATAmountLCY := 0;
        if Rec."Document Type" in [Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo"] then begin
            Rec.CalcFields("Amount (LCY)");
            VATAmountLCY := Rec."Amount (LCY)" - Rec."Sales (LCY)";
        end;

    end;
}