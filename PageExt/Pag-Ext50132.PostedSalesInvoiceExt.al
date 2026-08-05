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
        addbefore(Dimensions)
        {
            action("Invoice Details List.")
            {
                Caption = 'Invoice Details List.';
                ApplicationArea = all;
                PromotedCategory = Process;
                Image = ListPage;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Posted Sales Invoice Lines";
            }
        }

    }
}