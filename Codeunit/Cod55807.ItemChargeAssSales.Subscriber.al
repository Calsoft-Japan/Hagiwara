codeunit 55807 "ItemChargeAssSales Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Sales)", OnBeforeInsertItemChargeAssgntWithAssignValues, '', false, false)]
    local procedure DoOnBeforeInsertItemChargeAssgntWithAssignValues(var ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)"; FromItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    var
        SalesShipLine: Record "Sales Shipment Line";
    begin
        case ItemChargeAssgntSales."Applies-to Doc. Type" of
            ItemChargeAssgntSales."Applies-to Doc. Type"::Shipment:
                begin
                    if SalesShipLine.Get(ItemChargeAssgntSales."Applies-to Doc. No.", ItemChargeAssgntSales."Applies-to Doc. Line No.") then begin
                        SalesShipLine.CalcFields("External Document No.");
                        ItemChargeAssgntSales."External Document No." := SalesShipLine."External Document No.";
                        ItemChargeAssgntSales."Posting Date" := SalesShipLine."Posting Date";
                        ItemChargeAssgntSales."Item Ledger Entry No." := SalesShipLine."Item Shpt. Entry No.";
                    end;
                end;
        end;

    end;

}