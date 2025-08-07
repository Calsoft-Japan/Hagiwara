tableextension 50025 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50100; "IRS 1099 Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
    }
}
