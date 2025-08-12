pageextension 50029 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Payment Reference")
        {
            field("IRS 1099 Code"; Rec."IRS 1099 Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'IRS 1099 Code associated with the vendor.';
            }
        }
    }
}
