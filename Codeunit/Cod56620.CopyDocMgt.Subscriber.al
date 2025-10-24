codeunit 56620 "Copy Doc. Mgt. Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnBeforeModifySalesHeader, '', false, false)]
    local procedure DoOnBeforeModifySalesHeader(var ToSalesHeader: Record "Sales Header"; FromDocType: Option; FromDocNo: Code[20]; IncludeHeader: Boolean; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; RecalculateLines: Boolean; FromSalesHeader: Record "Sales Header"; FromSalesInvoiceHeader: Record "Sales Invoice Header"; FromSalesCrMemoHeader: Record "Sales Cr.Memo Header"; OldSalesHeader: Record "Sales Header")

    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        ToSalesHeader."Hagi Approver" := '';
        ToSalesHeader."Requester" := '';
        ToSalesHeader."Approval Status" := Enum::"Hagiwara Approval Status"::"Not Applicable";

        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (ToSalesHeader."Document Type" = Enum::"Sales Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (ToSalesHeader."Document Type" = Enum::"Sales Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (ToSalesHeader."Document Type" = Enum::"Sales Document Type"::"Return Order")
                ) then begin

            ToSalesHeader."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;
        //N005 End

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", OnBeforeModifyPurchHeader, '', false, false)]
    local procedure DoOnBeforeModifyPurchHeader(var ToPurchHeader: Record "Purchase Header"; FromDocType: Option; FromDocNo: Code[20]; IncludeHeader: Boolean; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer; RecalculateLines: Boolean; FromPurchaseHeader: Record "Purchase Header"; FromPurchInvHeader: Record "Purch. Inv. Header"; FromPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr."; OldPurchaseHeader: Record "Purchase Header")

    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        ToPurchHeader."Hagi Approver" := '';
        ToPurchHeader."Requester" := '';
        ToPurchHeader."Approval Status" := Enum::"Hagiwara Approval Status"::"Not Applicable";

        recApprSetup.Get();
        if ((recApprSetup."Purchase Order") and (ToPurchHeader."Document Type" = Enum::"Purchase Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (ToPurchHeader."Document Type" = Enum::"Purchase Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (ToPurchHeader."Document Type" = Enum::"Purchase Document Type"::"Return Order")
                ) then begin

            ToPurchHeader."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;
        //N005 End

    end;

}