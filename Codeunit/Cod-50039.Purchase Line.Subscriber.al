codeunit 50039 "Purchase Line Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeValidateRequestedReceiptDate, '', false, false)]
    local procedure DoOnBeforeValidateRequestedReceiptDate(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; var CustomCalendarChange: array[2] of Record "Customized Calendar Change"; CurrFieldNo: Integer; var IsHandled: Boolean)
    begin

        IsHandled := true; // because all the logic of this field is commented.
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeValidatePromisedReceiptDate, '', false, false)]
    local procedure DoOnBeforeValidatePromisedReceiptDate(var PurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer; var IsHandled: Boolean; xPurchaseLine: Record "Purchase Line")
    begin

        IsHandled := true; // because all the logic of this field is commented.
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterTestStatusOpen, '', false, false)]
    local procedure DoOnAfterTestStatusOpen(var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header")
    begin
        IF PurchaseLine."Document Type" IN [PurchaseLine."Document Type"::Order] THEN BEGIN
            IF PurchaseHeader."Message Status(Backlog)" IN [PurchaseHeader."Message Status(Backlog)"::Collected,
               PurchaseHeader."Message Status(Backlog)"::Sent] THEN
                ERROR('Message Status must be either [Ready to Collect] OR [Revise]');
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeUpdateDates, '', false, false)]
    local procedure DoOnBeforeUpdateDates(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin

        IsHandled := true; // because all the logic of this field is commented.
    end;



    var
        myInt: Integer;
}