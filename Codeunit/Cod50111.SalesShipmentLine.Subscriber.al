codeunit 50111 "Sales Shipment Line"
{
    Permissions = tabledata "Sales Shipment Header" = m;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Sales Shipment Line"; RunTrigger: Boolean)
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        IF ((Rec.Type = Rec.Type::Item) AND (Rec.Description <> ' ')) THEN BEGIN
            IF SalesShptHeader.GET(Rec."Document No.") THEN BEGIN
                if (SalesShptHeader."Message Collected On(Shipment)" <> 0D)
                or (SalesShptHeader."Message Status(Shipment)" <> SalesShptHeader."Message Status(Shipment)"::"Ready to Collect") then begin
                    SalesShptHeader."Message Collected On(Shipment)" := 0D;
                    SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                    SalesShptHeader.MODIFY;
                End;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", OnAfterInitFromSalesLine, '', false, false)]
    local procedure DoOnAfterInitFromSalesLine(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    var
        Item: Record Item;
    begin

        //sh..Start 20110427
        SalesShptLine."Item Supplier Source" := SalesLine."Item Supplier Source";
        IF (SalesLine.Type = SalesLine.Type::Item)
        THEN BEGIN
            SalesShptLine."Message Status" := SalesShptLine."Message Status"::"Ready to Collect";
            SalesShptLine."Update Date" := TODAY;
            SalesShptLine."Update Time" := TIME;
            SalesShptLine."Update By" := USERID;
            IF Item.GET(SalesShptLine."No.") THEN BEGIN
                Item."Update Date" := TODAY;
                Item."Update Time" := TIME;
                Item."Update By" := USERID;
                Item."Update Doc. No." := SalesShptHeader."No.";
                Item.MODIFY;
            END ELSE BEGIN
            END;
        END ELSE BEGIN
            SalesShptLine."Update Date" := 0D;
            SalesShptLine."Update Time" := 0T;
        END;
        //sh..End 20110427

        //sh 04Nov2012 - Improve PSI DAta Maikntenanced
        IF SalesShptLine.Quantity = 0 THEN BEGIN
            SalesShptLine."Message Status" := SalesShptLine."Message Status"::" ";
        END;
        //sh 04Nov2012 End
        SalesShptLine.Modify();
    end;

}

