codeunit 50001 "SOPO Line Price Update Message"
{
    // CS092 FDD S002 Bobby.ji 2025/8/22 - Upgrade to the BC version

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnUpdateUnitPriceByFieldOnBeforeValidateUnitPrice, '', false, false)]
    local procedure "Sales Line_OnUpdateUnitPriceByFieldOnBeforeValidateUnitPrice"(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        Text000: Label 'The Unit Price has been updated from %1 to %2. \\Select "Yes" to allow the update, or "No" to revert the Unit Price to its previous state.\\(Item No:%3 Line No.:%4)';
    begin
        if (SalesLine."Document Type" = SalesLine."Document Type"::Order) and (xSalesLine."Unit Price" <> 0) and (SalesLine."Unit Price" <> xSalesLine."Unit Price") then begin
            if NOT Confirm(STRSUBSTNO(Text000, xSalesLine."Unit Price", SalesLine."Unit Price", SalesLine."No.", SalesLine."Line No."), true) then begin
                SalesLine.Validate("Unit Price", xSalesLine."Unit Price");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterUpdateDirectUnitCost, '', false, false)]
    local procedure "Purchase Line_OnAfterUpdateDirectUnitCost"(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer)
    var
        Text000: Label 'The Unit Cost has been updated from %1 to %2.\\Select "Yes" to allow the update, or "No" to revert the Unit Cost to its previous state.\\(Item No:%3 Line No.:%4)';
    begin
        if (PurchLine."Document Type" = PurchLine."Document Type"::Order) and (xPurchLine."Direct Unit Cost" <> 0) and (PurchLine."Direct Unit Cost" <> xPurchLine."Direct Unit Cost") then begin
            if NOT Confirm(STRSUBSTNO(Text000, xPurchLine."Direct Unit Cost", PurchLine."Direct Unit Cost", PurchLine."No.", PurchLine."Line No."), true) then begin
                PurchLine.Validate("Direct Unit Cost", xPurchLine."Direct Unit Cost");
            end;
        end;
    end;


}

