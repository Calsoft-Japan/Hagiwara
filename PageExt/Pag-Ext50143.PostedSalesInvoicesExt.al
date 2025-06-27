pageextension 500143 PostedSalesInvoicesExt extends "Posted Sales Invoices"
{
    layout
    {
        addlast(Content)
        {
            field("To"; Rec."TO")
            {
                ApplicationArea = all;
            }
            field("From"; Rec."FROM")
            {
                ApplicationArea = all;
            }
        }
    }
}