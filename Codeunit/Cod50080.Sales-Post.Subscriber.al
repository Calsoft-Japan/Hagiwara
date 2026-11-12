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

    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnModifyTempLineOnBeforeSalesLineModify, '', false, false)]
    local procedure DoOnModifyTempLineOnBeforeSalesLineModify(var SalesLine: Record "Sales Line")
    var
        recSalesLine: Record "Sales Line";
    begin

        recSalesLine.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");

        //UPG 2017
        IF recSalesLine."Qty. to Ship" <> 0 THEN BEGIN
            recSalesLine."Shipment Seq. No." := recSalesLine."Shipment Seq. No." + 1; //>> 2010/10/05
                                                                                      //Siak 2011/08/11 - Start
            IF recSalesLine."Shipment Seq. No." < recSalesLine."Next Shipment Seq. No." THEN BEGIN
                recSalesLine."Shipment Seq. No." := recSalesLine."Next Shipment Seq. No.";
            END ELSE BEGIN
                recSalesLine."Next Shipment Seq. No." := recSalesLine."Shipment Seq. No.";
            END;
        END;
        IF recSalesLine."Save Customer Order No." <> '' THEN BEGIN
            recSalesLine."Customer Order No." := recSalesLine."Save Customer Order No.";
            recSalesLine."Save Customer Order No." := '';
        END;
        recSalesLine."Save Posting Date" := 0D;
        //Siak 2011/08/11 - End
        //UPG 2017

        recSalesLine.Modify();
    end;
    */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterPostSalesDoc, '', false, false)]
    local procedure DoOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        recSalesLine: Record "Sales Line";
        recSalesShipHdr: Record "Sales Shipment Header";
        recSalesShipLine: Record "Sales Shipment Line";
    begin
        recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", SalesHeader."No.");
        if recSalesLine.FindSet() then
            repeat
                if recSalesShipLine.Get(SalesShptHdrNo, recSalesLine."Line No.") and (recSalesShipLine.Quantity <> 0) then begin

                    //UPG 2017
                    recSalesLine."Shipment Seq. No." := recSalesLine."Shipment Seq. No." + 1; //>> 2010/10/05
                                                                                              //Siak 2011/08/11 - Start
                    IF recSalesLine."Shipment Seq. No." < recSalesLine."Next Shipment Seq. No." THEN BEGIN
                        recSalesLine."Shipment Seq. No." := recSalesLine."Next Shipment Seq. No.";
                    END ELSE BEGIN
                        recSalesLine."Next Shipment Seq. No." := recSalesLine."Shipment Seq. No.";
                    END;

                    IF recSalesLine."Save Customer Order No." <> '' THEN BEGIN
                        recSalesLine."Customer Order No." := recSalesLine."Save Customer Order No.";
                        recSalesLine."Save Customer Order No." := '';
                    END;
                    recSalesLine."Save Posting Date" := 0D;
                    //Siak 2011/08/11 - End
                    //UPG 2017

                    recSalesLine.Modify();
                end;

            until recSalesLine.Next() = 0;

    end;


}