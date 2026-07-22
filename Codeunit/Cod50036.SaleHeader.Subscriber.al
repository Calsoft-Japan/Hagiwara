codeunit 50036 "Sales Header Subscriber"
{
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