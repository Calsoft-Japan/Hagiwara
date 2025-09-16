pageextension 50051 PurchaseInvoiceExt extends "Purchase Invoice"
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