pageextension 50256 PaymentJournalExt extends "Payment Journal"
{
    layout
    {
        addafter("Amount (LCY)")
        {
            field("GST Rate"; Rec."GST Rate")
            {
                ApplicationArea = all;
                Visible = False;
            }
            field("GST Exchange Rate"; Rec."GST Exchange Rate")
            {
                ApplicationArea = all;
                Visible = False;
                Tooltip = 'For GST reporting purposes, to record the exchange rate used to convert from USD to SGD.';
            }
            field("GST Amount (SGD)"; Rec."GST Amount (SGD)")
            {
                ApplicationArea = all;
                Visible = False;
                Tooltip = 'For GST reporting purposes, to record the GST amount based on SGD.';
            }
            field("Base Amount (GST)"; Rec."Base Amount (GST)")
            {
                ApplicationArea = all;
                Visible = False;
                Tooltip = 'For GST reporting purposes, to record the base amount in SGD.';
            }
        }

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