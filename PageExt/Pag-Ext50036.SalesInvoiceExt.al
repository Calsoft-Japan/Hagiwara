pageextension 50036 SalesInvoiceExt extends "Sales Invoice"
{
    layout
    {
        addafter("Ship-to Contact")
        {
            field("From"; Rec."From")
            {
                ApplicationArea = all;
                Visible = False;
            }
            field("To"; Rec."To")
            {
                ApplicationArea = all;
                Visible = False;
            }
        }


    }

}