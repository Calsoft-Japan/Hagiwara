codeunit 50010 "VAR Subscriber"
{
    /// <summary>
    /// Some VATRegistNo is not compatibility with BC Standard validation.
    /// Reported from HEE for Belguim customers.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Customer", OnBeforeValidateVATRegistrationNo, '', false, false)]
    local procedure DoOnBeforeValidateVATRegistrationNo(var Customer: Record "Customer"; xCustomer: Record "Customer"; FieldNumber: Integer; var IsHandled: Boolean)
    var
    begin
        IsHandled := true;
    end;

    /// <summary>
    /// During Renesas PO Interface Quantity update processing, do not update Direct Unit Cost.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeUpdateDirectUnitCost, '', false, false)]
    local procedure DoOnBeforeUpdateDirectUnitCost(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        SessionInstance: Codeunit "Session Instance";
    begin
        if (CalledByFieldNo = PurchLine.FieldNo(Quantity)) and (SessionInstance.IsRenesasPOIF()) then
            Handled := true;
    end;

}

