codeunit 50080 "Sales-Post Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostSalesDoc, '', false, false)]
    local procedure DoOnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)

    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        if PreviewMode then
            exit;

        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (SalesHeader."Document Type" = SalesHeader."Document Type"::"Return Order")
                ) then begin

            if not (SalesHeader."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                Error('It is not approved yet.');
            end;
        end;
        //N005 End

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostItemJnlLineOnAfterPrepareItemJnlLine, '', false, false)]
    local procedure DoOnPostItemJnlLineOnAfterPrepareItemJnlLine(
        var ItemJournalLine: Record "Item Journal Line";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        WhseShip: Boolean;
        var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        var QtyToBeShipped: Decimal;
        TrackingSpecification: Record "Tracking Specification";
        var QtyToBeInvoiced: Decimal;
        var QtyToBeInvoicedBase: Decimal;
        var QtyToBeShippedBase: Decimal;
        var RemAmt: Decimal;
        var RemDiscAmt: Decimal)

    var
    begin
        ItemJournalLine."Sales Order No." := SalesLine."Document No."; //HG10.00.02 NJ 01/06/2017
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnModifyTempLineOnBeforeSalesLineModify, '', false, false)]
    local procedure DoOnModifyTempLineOnBeforeSalesLineModify(var SalesLine: Record "Sales Line")
    begin

        //UPG 2017
        IF SalesLine."Qty. to Ship" <> 0 THEN BEGIN
            SalesLine."Shipment Seq. No." := SalesLine."Shipment Seq. No." + 1; //>> 2010/10/05
                                                                                //Siak 2011/08/11 - Start
            IF SalesLine."Shipment Seq. No." < SalesLine."Next Shipment Seq. No." THEN BEGIN
                SalesLine."Shipment Seq. No." := SalesLine."Next Shipment Seq. No.";
            END ELSE BEGIN
                SalesLine."Next Shipment Seq. No." := SalesLine."Shipment Seq. No.";
            END;
        END;
        IF SalesLine."Save Customer Order No." <> '' THEN BEGIN
            SalesLine."Customer Order No." := SalesLine."Save Customer Order No.";
            SalesLine."Save Customer Order No." := '';
        END;
        SalesLine."Save Posting Date" := 0D;
        //Siak 2011/08/11 - End
        //UPG 2017
    end;

}