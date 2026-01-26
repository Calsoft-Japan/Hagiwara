pageextension 59087 "Sales Line FB Ext" extends "Sales Line FactBox"
{

    layout
    {
        addafter("Item Availability")
        {
            field("Item Availability (Approved)"; SalesApprQtyMgt.CalcAvailability(Rec))
            {
                ApplicationArea = ALL;
                Caption = 'Item Availability (Approved)';
                DecimalPlaces = 0 : 5;

            }
        }
    }

    var
        SalesApprQtyMgt: Codeunit "Sales Approved Qty. Mgt.";
}