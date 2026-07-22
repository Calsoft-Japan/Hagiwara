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

        addafter("Invoice Nos.")
        {
            field("Invoice Nos. (DS)"; Rec."Invoice Nos. (DS)")
            {
                ApplicationArea = all;
            }
        }

        addafter("Posted Invoice Nos.")
        {
            field("Posted Invoice Nos. (DS)"; Rec."Posted Invoice Nos. (DS)")
            {
                ApplicationArea = all;
            }
        }
    }
}