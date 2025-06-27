pageextension 50020 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        addlast(Content)
        {
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                ApplicationArea = all;
            }
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = all;
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = all;
            }
        }
    }
}