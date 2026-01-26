pageextension 59100 "Purch Line FB Ext" extends "Purchase Line FactBox"
{

    layout
    {
        addafter("Availability")
        {
            field("Item Availability (Approved)"; PurchApprQtyMgt.CalcAvailability(Rec))
            {
                ApplicationArea = ALL;
                Caption = 'Availability (Approved)';
                DecimalPlaces = 0 : 5;

            }
        }
    }

    var
        PurchApprQtyMgt: Codeunit "Purch Approved Qty. Mgt.";
}