codeunit 50121 "Purch Rcpt Line Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", OnAfterInitFromPurchLine, '', false, false)]
    local procedure DoOnAfterInitFromPurchLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin

        //sh..Start
        PurchRcptLine."Item Supplier Source" := PurchLine."Item Supplier Source";
        IF (PurchRcptLine.Type = PurchRcptLine.Type::Item)
        THEN BEGIN
            PurchRcptLine."Message Status" := PurchRcptLine."Message Status"::"Ready to Collect";
            PurchRcptLine."Update Date" := TODAY;
            PurchRcptLine."Update Time" := TIME;
            PurchRcptLine."Update By" := USERID;
            PurchRcptLine."Posting Date" := PurchRcptHeader."Posting Date";
            PurchRcptLine."Save Posting Date" := PurchLine."Save Posting Date";

            PurchLine."Save Posting Date" := 0D;
            IF Item.GET(PurchRcptLine."No.") THEN BEGIN
                Item."Update Date" := TODAY;
                Item."Update Time" := TIME;
                Item."Update By" := USERID;
                Item."Update Doc. No." := PurchRcptHeader."No.";
                Item.MODIFY;
            END ELSE BEGIN
                //               Item.MODIFY;
            END;
        END ELSE BEGIN
            PurchRcptLine."Update Date" := 0D;
            PurchRcptLine."Update Time" := 0T;
        END;
        //sh..End
    end;



    var
        Item: Record Item;
}