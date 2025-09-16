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
        }


    }

}