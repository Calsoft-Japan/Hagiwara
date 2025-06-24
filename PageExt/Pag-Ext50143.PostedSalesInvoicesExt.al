pageextension 50000 Pag-Ext50143.PostedSalesInvoicesExtExt extends "Pag-Ext50143.PostedSalesInvoicesExt"
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