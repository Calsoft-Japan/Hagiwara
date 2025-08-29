pageextension 50254 PurchaseJournalExt extends "Purchase Journal"
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