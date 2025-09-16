pageextension 50044 SalesCreditMemoExt extends "Sales Credit Memo"
{
    layout
    {
        addafter("Bill-to Contact")
        {
            field("From"; Rec."From")
            {
                ApplicationArea = all;
                Visible = False;
            }
        }
    }
}