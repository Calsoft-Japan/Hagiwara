pageextension 55806 PurchReceiptLinesExt extends "Purch. Receipt Lines"
{
    layout
    {

        movebefore("Document No."; "Order No.", "No.")

        addbefore("Document No.")
        {
            field("Posting Date"; rec."Posting Date")
            {

                ApplicationArea = all;
            }
            field("External Document No."; rec."External Document No.")
            {

                ApplicationArea = all;
            }


        }
    }

    trigger OnOpenPage()
    begin

        //CS077 by Bobby 2024/05/10
        rec.SETRANGE("Order No.", '');
        rec.SETRANGE("No.", '');
        rec.SETRANGE("Posting Date", 0D);
        rec.SETRANGE("External Document No.", '');
        //CS077 by Bobby 2024/05/10
    end;

}