codeunit 50037 "Sales Line Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInitOutstandingQty, '', false, false)]
    local procedure DoOnAfterInitOutstandingQty(var SalesLine: Record "Sales Line")
    begin

        //SH 10Nov2012
        SalesLine."Outstanding Quantity (Actual)" := SalesLine."Outstanding Quantity";
        //SH END
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterInitHeaderDefaults, '', false, false)]
    local procedure DoOnAfterInitHeaderDefaults(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; xSalesLine: Record "Sales Line")
    begin

        // Siak Hui - insert Salesperson Code from Sales Header 20120816
        SalesLine."Salesperson Code" := SalesHeader."Salesperson Code";
        // Siak Hui - END
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeAutoReserve, '', false, false)]
    local procedure DoOnBeforeAutoReserve(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; FullAutoReservation: Boolean; var ReserveSalesLine: Codeunit "Sales Line-Reserve")
    begin
        IsHandled := true;
    end;

    var
        myInt: Integer;
}