pageextension 50253 SalesJournalExt extends "Sales Journal"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Currency Factor"; rec."Currency Factor")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bal. Account No.")
        {
            field(BalAccName_Line; BalAccName)
            {
                ApplicationArea = all;
                Caption = 'Bal. Account Name';
            }
        }
    }
}