pageextension 50518 PurchLinesExt extends "Purchase Lines"
{
    layout
    {

        addafter("No.")
        {

            field("CO No."; rec."CO No.")
            {

                ApplicationArea = all;
            }

        }
    }
}