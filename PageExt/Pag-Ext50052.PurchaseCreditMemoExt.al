pageextension 50052 PurchaseCreditMemoExt extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Currency Code")
        {
            field("GST Rate"; Rec."GST Rate")
            {
                ApplicationArea = all;
                Visible = False;
            }
        }


    }

}