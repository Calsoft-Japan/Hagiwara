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

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterCopyFromSalesLine, '', false, false)]
    local procedure DoOnAfterCopyFromSalesLine(var SalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line")
    begin

        // Siak Hui For hagiwara 20110428
        SalesLine."Update Date" := FromSalesLine."Update Date";
        SalesLine."Update Time" := FromSalesLine."Update Time";
        SalesLine."Update By" := FromSalesLine."Update By";
        SalesLine."Message Status" := SalesLine."Message Status"::"Ready to Collect";
        // Siak Hui For hagiwara 20110428 - END
        // Yuka For hagiwara 20041117
        SalesLine."OEM No." := FromSalesLine."OEM No.";
        SalesLine."OEM Name" := FromSalesLine."OEM Name";
        // Yuka For hagiwara 20041117 - END
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterCopyFromSalesShptLine, '', false, false)]
    local procedure DoOnAfterCopyFromSalesShptLine(var SalesLine: Record "Sales Line"; FromSalesShipmentLine: Record "Sales Shipment Line")
    begin

        // Siak Hui For hagiwara 20110428
        SalesLine."Update Date" := FromSalesShipmentLine."Update Date";
        SalesLine."Update Time" := FromSalesShipmentLine."Update Time";
        SalesLine."Update By" := FromSalesShipmentLine."Update By";
        SalesLine."Message Status" := FromSalesShipmentLine."Message Status"::"Ready to Collect";
        // Siak Hui For hagiwara 20110428 - END
        // Yuka For hagiwara 20041117
        SalesLine."OEM No." := FromSalesShipmentLine."OEM No.";
        SalesLine."OEM Name" := FromSalesShipmentLine."OEM Name";
        // Yuka For hagiwara 20041117 - END
    end;

    var
        myInt: Integer;
}