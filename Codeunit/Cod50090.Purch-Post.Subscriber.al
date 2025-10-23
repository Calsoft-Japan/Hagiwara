codeunit 50090 "Purch-Post Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostPurchaseDoc, '', false, false)]
    local procedure DoOnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)

    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        if PreviewMode then
            exit;

        recApprSetup.Get();
        if ((recApprSetup."Purchase Order") and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order")
                ) then begin

            if not (PurchaseHeader."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                Error('It is not approved yet.');
            end;
        end;
        //N005 End

    end;

}