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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostItemJnlLineOnAfterPrepareItemJnlLine, '', false, false)]
    local procedure DoOnPostItemJnlLineOnAfterPrepareItemJnlLine(
        var ItemJournalLine: Record "Item Journal Line";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        WhseShip: Boolean;
        var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        var QtyToBeShipped: Decimal;
        TrackingSpecification: Record "Tracking Specification";
        var QtyToBeInvoiced: Decimal;
        var QtyToBeInvoicedBase: Decimal;
        var QtyToBeShippedBase: Decimal;
        var RemAmt: Decimal;
        var RemDiscAmt: Decimal)

    var
    begin
        ItemJournalLine."Sales Order No." := SalesLine."Document No."; //HG10.00.02 NJ 01/06/2017
    end;

}