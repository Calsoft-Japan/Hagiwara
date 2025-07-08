pageextension 50461 InventorySetupExt extends "Inventory Setup"
{
    layout
    {
        addlast(Content)
        {
            field("Max. PO Quantity Restriction"; Rec."Max. PO Quantity Restriction")
            {
                ApplicationArea = all;
            }
            field("Supplier Item Source"; Rec."Supplier Item Source")
            {
                ApplicationArea = all;
            }
            field("Enable Inventory Trace"; Rec."Enable Inventory Trace")
            {
                ApplicationArea = all;
            }
            field("Enable Multicompany Trace"; Rec."Enable Multicompany Trace")
            {
                ApplicationArea = all;
            }
            field("ITE Start Date"; Rec."ITE Start Date")
            {
                ApplicationArea = all;
            }
            field("ITE End Date"; Rec."ITE End Date")
            {
                ApplicationArea = all;
            }
            field("ITE Item No. Filter"; Rec."ITE Item No. Filter")
            {
                ApplicationArea = all;
            }
            field("ITE Manufacturer Code Filter"; Rec."ITE Manufacturer Code Filter")
            {
                ApplicationArea = all;
            }
            field("Booking Serial Nos."; Rec."Booking Serial Nos.")
            {
                ApplicationArea = all;
            }
        }
    }
}