codeunit 55817 "UndoPostingMgt Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Posting Management", OnUpdatePurchLineOnAfterSetQtyToReceive, '', false, false)]
    local procedure DoOnUpdatePurchLineOnAfterSetQtyToReceive(var PurchLine: Record "Purchase Line")

    begin
        //Siak Hui 20110426
        PurchLine."Update Date" := TODAY;
        PurchLine."Update Time" := TIME;
        PurchLine."Update By" := USERID;
        //PurchLine."Receipt Seq. No." := PurchLine."Rec Seq. No.";
        PurchLine."Saved Expected Receipt Date" := PurchLine."Expected Receipt Date";
        //PurchLine."Expected Receipt Date" := PurchLine."Exp Rec Date";
        //Siak Hui - END

        //Siak - Start
        IF PurchLine."Save Posting Date" = 0D THEN BEGIN
            PurchLine."Save Posting Date" := Today();
        END;
        //Siak - End

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Undo Posting Management", OnUpdateSalesLineOnBeforeInitOustanding, '', false, false)]
    local procedure DoOnUpdateSalesLineOnBeforeInitOustanding(var SalesLine: Record "Sales Line")

    begin
        //Siak Hui 20110426
        SalesLine."Update Date" := TODAY;
        SalesLine."Update Time" := TIME;
        SalesLine."Update By" := USERID;
        //"Shipment Seq. No." := "Shipment Seq No";
        SalesLine."Save Customer Order No." := SalesLine."Customer Order No.";
        //"Customer Order No." := "Cust Order No";
        //Siak Hui - END

        //Siak
        IF SalesLine."Save Posting Date" = 0D THEN BEGIN
            SalesLine."Save Posting Date" := Today();
        END;
        //Siak - End

    end;

}