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
                ToolTip = 'Specifies how many approved units of the item on the purchase line are available.';

            }
        }
    }

    var
        PurchApprQtyMgt: Codeunit "Purch Approved Qty. Mgt.";
}