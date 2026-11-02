codeunit 50036 "Sales Header Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInitRecord, '', false, false)]
    local procedure DoOnAfterInitRecord(var SalesHeader: Record "Sales Header")
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")
                ) then begin
            SalesHeader."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;
        //N005 End
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInitPostingNoSeries, '', false, false)]
    local procedure DoOnAfterInitPostingNoSeries(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if SalesHeader."Document Type" = Enum::"Sales Document Type"::Invoice then begin
            SalesSetup.Get();
            if (SalesSetup."Invoice Nos. (DS)" <> '') and (SalesHeader."No. Series" = SalesSetup."Invoice Nos. (DS)") then begin
                SalesSetup.TestField("Posted Invoice Nos. (DS)");
                SalesHeader."Posting No. Series" := SalesSetup."Posted Invoice Nos. (DS)";
            end;
        end;
    end;

}