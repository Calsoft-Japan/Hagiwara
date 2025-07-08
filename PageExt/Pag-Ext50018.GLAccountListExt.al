pageextension 50018 GLAccountListExt extends "G/L Account List"
{
    layout
    {
        addlast(Content)
        {
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = all;
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = all;
            }
            field("Totaling"; Rec."Totaling")
            {
                ApplicationArea = all;
            }
        }
    }
}
