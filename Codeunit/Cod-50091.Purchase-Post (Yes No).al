codeunit 50091 "Purchase-Post (Yes No)"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeConfirmPostProcedure, '', false, false)]
    local procedure "Purch.-Post (Yes/No)_OnBeforeConfirmPostProcedure"(var PurchaseHeader: Record "Purchase Header"; var DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    begin
        Result := ConfirmPostPurchaseDocument(PurchaseHeader, DefaultOption, false, false);
        PurchaseHeader."Print Posted Documents" := false;
        IsHandled := true;
    end;


    procedure ConfirmPostPurchaseDocument(var PurchaseHeaderToPost: Record "Purchase Header"; DefaultOption: Integer; WithPrint: Boolean; WithEmail: Boolean) Result: Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        UserSetupManagement: Codeunit "User Setup Management";
        ConfirmManagement: Codeunit "Confirm Management";
        Selection: Integer;
        IsHandled: Boolean;
        UserSetup: Record "User Setup";
    begin
        if DefaultOption > 3 then
            DefaultOption := 3;
        if DefaultOption <= 0 then
            DefaultOption := 1;

        PurchaseHeader.Copy(PurchaseHeaderToPost);

        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    IsHandled := false;
                    if not IsHandled then
                        UserSetupManagement.GetPurchaseInvoicePostingPolicy(PurchaseHeader.Receive, PurchaseHeader.Invoice);
                    case true of
                        not PurchaseHeader.Receive and not PurchaseHeader.Invoice:
                            begin
                                //Selection := StrMenu(ReceiveInvoiceOptionsQst, DefaultOption);
                                IF UserSetup.GET(USERID) THEN
                                    DefaultOption := UserSetup."Purchase Order Post" + 1;

                                Selection := STRMENU(ReceiveInvoiceOptionsQst, DefaultOption);
                                if Selection = 0 then
                                    exit(false);
                                PurchaseHeader.Receive := Selection in [1, 3];
                                PurchaseHeader.Invoice := Selection in [2, 3];
                            end;
                        PurchaseHeader.Receive and not PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(PostingSelectionManagement.GetReceiveConfirmationMessage(), true) then
                                exit(false);
                        PurchaseHeader.Receive and PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(ReceiveInvoiceConfirmQst, true) then
                                exit(false);
                    end;
                end;
            PurchaseHeader."Document Type"::"Return Order":
                begin
                    IsHandled := false;
                    if not IsHandled then
                        UserSetupManagement.GetPurchaseInvoicePostingPolicy(PurchaseHeader.Ship, PurchaseHeader.Invoice);
                    case true of
                        not PurchaseHeader.Ship and not PurchaseHeader.Invoice:
                            begin
                                //Selection := StrMenu(ShipInvoiceOptionsQst, DefaultOption);
                                IF UserSetup.GET(USERID) THEN
                                    DefaultOption := UserSetup."Purchase Return Order Post" + 1;

                                Selection := STRMENU(ShipInvoiceOptionsQst, DefaultOption);
                                if Selection = 0 then
                                    exit(false);
                                PurchaseHeader.Ship := Selection in [1, 3];
                                PurchaseHeader.Invoice := Selection in [2, 3];
                            end;
                        PurchaseHeader.Ship and not PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(PostingSelectionManagement.GetShipConfirmationMessage(), true) then
                                exit(false);
                        PurchaseHeader.Ship and PurchaseHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(PostingSelectionManagement.GetShipInvoiceConfirmationMessage(), true) then
                                exit(false);
                    end;
                end;
            PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo":
                begin
                    PostingSelectionManagement.CheckUserCanInvoicePurchase();
                    if not ConfirmManagement.GetResponseOrDefault(
                            PostingSelectionManagement.GetPostConfirmationMessage(PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice, WithPrint, WithEmail), true)
                    then
                        exit(false);
                end;
            else
                if not ConfirmManagement.GetResponseOrDefault(
                        PostingSelectionManagement.GetPostConfirmationMessage(Format(PurchaseHeader."Document Type"), WithPrint, WithEmail), true)
                then
                    exit(false);
        end;

        PurchaseHeaderToPost.Copy(PurchaseHeader);
        exit(true);
    end;

    var
        ShipInvoiceOptionsQst: Label '&Ship,&Invoice,Ship &and Invoice';
        ReceiveInvoiceOptionsQst: Label '&Receive,&Invoice,Receive &and Invoice';
        ReceiveInvoiceConfirmQst: Label 'Do you want to post the receipt and invoice?';
        PostingSelectionManagement: Codeunit "Posting Selection Management";
}