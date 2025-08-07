pageextension 50029 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Payment Reference")
        {
            field("IRS 1099 Code"; VendorIRS1099Code)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'IRS 1099 Code associated with the vendor.';
            }
        }
    }
    var
        VendorIRS1099Code: Code[10];

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        Clear(VendorIRS1099Code);
        if Vendor.Get(Rec."Vendor No.") then
            VendorIRS1099Code := Vendor."IRS 1099 Code";
    end;
}
