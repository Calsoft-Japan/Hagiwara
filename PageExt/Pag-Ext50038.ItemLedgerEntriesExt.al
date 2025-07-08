pageextension 50038 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        addlast(Content)
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("CO No."; Rec."CO No.")
            {
                ApplicationArea = all;
            }
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = all;
            }
            field("ITE Collected"; Rec."ITE Collected")
            {
                ApplicationArea = all;
            }
            field("ITE Manually"; Rec."ITE Manually")
            {
                ApplicationArea = all;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
            field("Applies-to Entry"; Rec."Applies-to Entry")
            {
                ApplicationArea = all;
            }
        }
    }
}