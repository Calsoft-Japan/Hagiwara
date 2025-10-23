codeunit 50080 "Sales-Post Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure DoOnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)

    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        if PreviewMode then
            exit;

        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")
                ) then begin

            if not (SalesHeader."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                Error('It is not approved yet.');
            end;
        end;
        //N005 End

    end;

}