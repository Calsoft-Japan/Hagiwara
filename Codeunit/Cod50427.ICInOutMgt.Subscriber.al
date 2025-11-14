codeunit 50427 "ICInboxOutboxMgt Subscriber"
{

    /// <summary>
    /// Purchase order will be sent to PC automatically. (for example, HET Purchase Order => SH Inbox.)
    /// </summary>
    /// <param name="PurchaseHeader"></param>
    /// <param name="PurchaseLine"></param>
    /// <param name="ICOutboxPurchaseHeader"></param>
    /// <param name="ICOutboxTransaction"></param>
    /// <param name="LinesCreated"></param>
    /// <param name="Post"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnBeforeICOutboxTransactionCreatedPurchDocTrans, '', false, false)]
    local procedure DoOnBeforeICOutboxTransactionCreatedPurchDocTrans(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var ICOutboxPurchaseHeader: Record "IC Outbox Purchase Header"; var ICOutboxTransaction: Record "IC Outbox Transaction"; LinesCreated: Boolean; Post: Boolean)
    var
        IC_Hagi: Boolean;
        ICSetup: Record "IC Setup";
        cuICOutboxExp: Codeunit "IC Outbox Export";
    begin
        IC_Hagi := true; //Just in case if this function needs to be on/off.

        if IC_Hagi then begin
            ICSetup.Get();
            ICSetup."Auto. Send Transactions" := true;
            ICSetup.Modify();

            ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::"Send to IC Partner";
            ICOutboxTransaction.Modify();
            cuICOutboxExp.ProcessAutoSendOutboxTransactionNo(ICOutboxTransaction."Transaction No.");

            ICSetup."Auto. Send Transactions" := false;
            ICSetup.Modify();

            //todo
            //SendMail();
        end;

    end;

    /// <summary>
    /// Purchase order will be sent back SC automatically. (for example, SH Inbox => HET Outbox.)
    /// </summary>
    /// <param name="ICInboxTransaction"></param>
    /// <param name="ICOutboxTransaction"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterForwardToOutBoxSalesDoc, '', false, false)]
    local procedure DoOnAfterForwardToOutBoxSalesDoc(var ICInboxTransaction: Record "IC Inbox Transaction"; var ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        IC_Hagi: Boolean;
        ICSetup: Record "IC Setup";
        cuICOutboxExp: Codeunit "IC Outbox Export";
    begin
        IC_Hagi := true; //Just in case if this function needs to be on/off.

        if IC_Hagi then begin
            ICSetup.Get();
            ICSetup."Auto. Send Transactions" := true;
            ICSetup.Modify();

            ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::"Send to IC Partner";
            ICOutboxTransaction.Modify();
            cuICOutboxExp.ProcessAutoSendOutboxTransactionNo(ICOutboxTransaction."Transaction No.");

            ICSetup."Auto. Send Transactions" := false;
            ICSetup.Modify();

            //todo
            //SendMail();
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnCreateOutboxPurchDocTransOnAfterICOutBoxPurchLineInsert, '', false, false)]
    local procedure DoOnCreateOutboxPurchDocTransOnAfterICOutBoxPurchLineInsert(var ICOutboxPurchaseLine: Record "IC Outbox Purchase Line"; PurchaseLine: Record "Purchase Line")
    var
    begin
        ICOutboxPurchaseLine."Customer Order No." := PurchaseLine."CO No.";
        ICOutboxPurchaseLine."Requested Delivery Date_1" := PurchaseLine."Requested Receipt Date_1";
        ICOutboxPurchaseLine.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterICInboxSalesLineInsert, '', false, false)]
    local procedure DoOnAfterICInboxSalesLineInsert(var ICInboxSalesLine: Record "IC Inbox Sales Line"; ICOutboxPurchaseLine: Record "IC Outbox Purchase Line")
    begin
        ICInboxSalesLine."Customer Order No." := ICOutboxPurchaseLine."Customer Order No.";
        ICInboxSalesLine."Requested Delivery Date_1" := ICOutboxPurchaseLine."Requested Delivery Date_1";
        ICInboxSalesLine.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterCreateSalesLines, '', false, false)]
    local procedure DoOnAfterCreateSalesLines(ICInboxSalesLine: Record "IC Inbox Sales Line"; var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header")
    begin
        SalesLine."Customer Order No." := ICInboxSalesLine."Customer Order No.";
        SalesLine."Requested Delivery Date_1" := ICInboxSalesLine."Requested Delivery Date_1";
        SalesLine.Modify();
    end;

}