pageextension 50132 PostedSalesInvoiceExt extends "Posted Sales Invoice"
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

    actions
    {
        addafter(ChangePaymentService)
        {
            action("Invoice Details List.")
            {
                Caption = 'Invoice Details List.';
                ApplicationArea = all;

                Image = ListPage;
                RunObject = Page "Posted Sales Invoice Lines";
            }
        }

        addafter(ChangePaymentService_Promoted)
        {
            actionref("Invoice Details List._Promoted"; "Invoice Details List.")
            {
            }
        }

    }
}