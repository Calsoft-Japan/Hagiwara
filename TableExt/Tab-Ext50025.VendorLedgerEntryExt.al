tableextension 50025 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50100; "IRS 1099 Code"; Code[10])
        {
            Caption = 'IRS 1099 Code';
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeInsert()
    var
        VendorRec: Record Vendor;
    begin
        if VendorRec.Get("Vendor No.") then
            Rec."IRS 1099 Code" := VendorRec."IRS 1099 Code";
    end;
}
