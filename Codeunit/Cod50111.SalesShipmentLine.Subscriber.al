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

}

