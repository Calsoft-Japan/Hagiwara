pageextension 55628 FixAssetGLJournalExt extends "Fixed Asset G/L Journal"
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
            field(BalAccName_Line; BalAccountName)
            {
                ApplicationArea = all;
                Caption = 'Bal. Account Name';
            }
        }
    }
}