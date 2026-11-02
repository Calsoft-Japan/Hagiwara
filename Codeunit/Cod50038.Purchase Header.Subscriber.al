codeunit 50038 "Purchase Header Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnAfterInitRecord, '', false, false)]
    local procedure DoOnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        PurchHeader."Assigned User ID" := USERID; //HG10.00.02 NJ 01/06/2017

        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Purchase Order") and (PurchHeader."Document Type" = PurchHeader."Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order")
                ) then begin
            PurchHeader."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;
        //N005 End

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnAfterUpdatePurchLines, '', false, false)]
    local procedure DoOnAfterUpdatePurchLines(var PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchLine.FINDSET THEN
            REPEAT
                IF PurchLine."No." <> '' THEN BEGIN
                    PurchLine.VALIDATE("Requested Receipt Date_1", PurchaseHeader."Expected Receipt Date");//sanjeev
                    PurchLine.Modify();
                END;
            UNTIL PurchLine.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", OnAfterCopyBuyFromVendorAddressFieldsFromVendor, '', false, false)]
    local procedure DoOnAfterCopyBuyFromVendorAddressFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; BuyFromVendor: Record Vendor)
    var
        PurchLine: Record "Purchase Line";
    begin

        //HG10.00.10 NJ 10/04/2018 -->
        PurchaseHeader."Pay-to Address" := BuyFromVendor."Pay-to Address";
        PurchaseHeader."Pay-to Address 2" := BuyFromVendor."Pay-to Address 2";
        PurchaseHeader."Pay-to City" := BuyFromVendor."Pay-to City";
        PurchaseHeader."Pay-to Post Code" := BuyFromVendor."Pay-to Post Code";
        PurchaseHeader."Pay-to County" := BuyFromVendor."Pay-to County";
        PurchaseHeader."Pay-to Country/Region Code" := BuyFromVendor."Pay-to Country/Region Code";
        //HG10.00.10 NJ 10/04/2018 <--
    end;






    var
        myInt: Integer;
}