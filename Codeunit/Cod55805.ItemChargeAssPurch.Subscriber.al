codeunit 55805 "ItemChargeAssPurch Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", OnBeforeInsertItemChargeAssgntWithAssignValues, '', false, false)]
    local procedure DoOnBeforeInsertItemChargeAssgntWithAssignValues(var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        SalesShipLine: Record "Sales Shipment Line";
    begin
        case ItemChargeAssgntPurch."Applies-to Doc. Type" of
            ItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
                begin
                    if PurchRcptLine.Get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        PurchRcptLine.CalcFields("External Document No.");
                        ItemChargeAssgntPurch."External Document No." := PurchRcptLine."External Document No.";
                        ItemChargeAssgntPurch."Posting Date" := PurchRcptLine."Posting Date";
                        ItemChargeAssgntPurch."Item Ledger Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                    end;
                end;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
                begin
                    if SalesShipLine.Get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        SalesShipLine.CalcFields("External Document No.");
                        ItemChargeAssgntPurch."External Document No." := SalesShipLine."External Document No.";
                        ItemChargeAssgntPurch."Posting Date" := SalesShipLine."Posting Date";
                        ItemChargeAssgntPurch."Item Ledger Entry No." := SalesShipLine."Item Shpt. Entry No.";
                    end;
                end;
        end;

    end;

}