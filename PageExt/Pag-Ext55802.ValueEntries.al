pageextension 55802 ValueEntriesExt extends "Value Entries"
{
    layout
    {

        addafter("Item No.")
        {

            field("Item Description"; Rec.ItemDesc)
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }

        }

        addafter("Job Ledger Entry No.")
        {

            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Customer Familiar Name"; Rec."Customer Familiar Name")
            {
                ApplicationArea = all;
            }
            field("Vendor Familiar Name"; Rec."Vendor Familiar Name")
            {
                ApplicationArea = all;
            }

        }
    }
}