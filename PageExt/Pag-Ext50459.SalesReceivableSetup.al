pageextension 50459 SalesReceivableSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Posted Sales E-Sig."; Rec."Posted Sales E-Sig.")
            {
                ApplicationArea = all;
            }
        }
    }
}