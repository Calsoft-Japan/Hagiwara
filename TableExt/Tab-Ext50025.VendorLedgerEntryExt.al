tableextension 50025 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50100; "IRS 1099 Code"; Code[10])
        {
            Caption = 'IRS 1099 Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor."IRS 1099 Code" where("No." = field("Vendor No.")));
            Editable = false; // FlowFields are read-only on pages
        }
    }
}
