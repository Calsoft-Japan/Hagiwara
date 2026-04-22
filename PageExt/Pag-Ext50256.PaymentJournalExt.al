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
            field("GST Amount"; Rec."GST Amount")
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


    }

}