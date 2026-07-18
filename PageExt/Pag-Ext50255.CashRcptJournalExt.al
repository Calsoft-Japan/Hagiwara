pageextension 50255 CashRcptJournalExt extends "Cash Receipt Journal"
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