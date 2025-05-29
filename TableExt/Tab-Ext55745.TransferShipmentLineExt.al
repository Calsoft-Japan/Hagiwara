tableextension 55745 "Transfer Shipment Line Ext" extends "Transfer Shipment Line"
{
    fields
    {
        field(50010; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = '//ms fon';
        }
    }
}
