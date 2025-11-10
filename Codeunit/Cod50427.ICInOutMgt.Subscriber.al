codeunit 50427 "ICInboxOutboxMgt Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnBeforeICOutboxTransactionCreatedPurchDocTrans, '', false, false)]
    local procedure DoOnBeforeICOutboxTransactionCreatedPurchDocTrans(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var ICOutboxPurchaseHeader: Record "IC Outbox Purchase Header"; var ICOutboxTransaction: Record "IC Outbox Transaction"; LinesCreated: Boolean; Post: Boolean)
    var
        IC_Hagi: Boolean;
    begin
        IC_Hagi := true; //Just in case if this function needs to be on/off.

        if IC_Hagi then begin

        end;

    end;

}