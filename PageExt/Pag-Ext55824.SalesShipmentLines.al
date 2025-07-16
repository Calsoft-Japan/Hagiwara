pageextension 55824 SalesShipmentLinesExt extends "Sales Shipment Lines"
{
    layout
    {
        movebefore("Document No."; "No.")

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
        //IF AssignmentType = AssignmentType::Sale THEN BEGIN //CS077 Shawn
        rec.SETCURRENTKEY("Sell-to Customer No.");
        //CS077 by Bobby 2024/05/10
        //rec.SETRANGE("Sell-to Customer No.", SellToCustomerNo); //ToDo
        rec.SETRANGE("No.", '');
        rec.SETRANGE("Posting Date", 0D);
        rec.SETRANGE("External Document No.", '');
        //CS077 by Bobby 2024/05/10
        //END; //CS077 Shawn
    end;
}