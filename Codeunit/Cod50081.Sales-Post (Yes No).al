codeunit 50081 "Sales-Post (Yes No)"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmPost, '', false, false)]
    local procedure "Sales-Post (Yes/No)_OnBeforeConfirmPost"(var SalesHeader: Record "Sales Header"; var DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)

    begin
        Result := ConfirmPostSalesDocument(SalesHeader, DefaultOption, false, false);
        SalesHeader."Print Posted Documents" := false;
        IsHandled := true;
    end;

    procedure ConfirmPostSalesDocument(var SalesHeaderToPost: Record "Sales Header"; DefaultOption: Integer; WithPrint: Boolean; WithEmail: Boolean) Result: Boolean
    var
        SalesHeader: Record "Sales Header";
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

        SalesHeader.Copy(SalesHeaderToPost);

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    IsHandled := false;
                    if not IsHandled then
                        UserSetupManagement.GetSalesInvoicePostingPolicy(SalesHeader.Ship, SalesHeader.Invoice);
                    case true of
                        not SalesHeader.Ship and not SalesHeader.Invoice:
                            begin
                                //Selection := StrMenu(ShipInvoiceOptionsQst, DefaultOption);
                                IF UserSetup.GET(USERID) THEN
                                    DefaultOption := UserSetup."Sales Order Post" + 1;
                                Selection := STRMENU(ShipInvoiceOptionsQst, DefaultOption);
                                if Selection = 0 then
                                    exit(false);
                                SalesHeader.Ship := Selection in [1, 3];
                                SalesHeader.Invoice := Selection in [2, 3];
                            end;
                        SalesHeader.Ship and not SalesHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(PostingSelectionManagement.GetShipConfirmationMessage(), true) then
                                exit(false);
                        SalesHeader.Ship and SalesHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(PostingSelectionManagement.GetShipInvoiceConfirmationMessage(), true) then
                                exit(false);
                    end;
                end;
            SalesHeader."Document Type"::"Return Order":
                begin
                    IsHandled := false;
                    if not IsHandled then
                        UserSetupManagement.GetSalesInvoicePostingPolicy(SalesHeader.Receive, SalesHeader.Invoice);
                    case true of
                        not SalesHeader.Receive and not SalesHeader.Invoice:
                            begin
                                //Selection := StrMenu(ReceiveInvoiceOptionsQst, DefaultOption);
                                IF UserSetup.GET(USERID) THEN
                                    DefaultOption := UserSetup."Sales Return Order Post" + 1;

                                Selection := STRMENU(ReceiveInvoiceOptionsQst, DefaultOption);
                                if Selection = 0 then
                                    exit(false);
                                SalesHeader.Receive := Selection in [1, 3];
                                SalesHeader.Invoice := Selection in [2, 3];
                            end;
                        SalesHeader.Receive and not SalesHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(PostingSelectionManagement.GetReceiveConfirmationMessage(), true) then
                                exit(false);
                        SalesHeader.Receive and SalesHeader.Invoice:
                            if not ConfirmManagement.GetResponseOrDefault(ReceiveInvoiceConfirmQst, true) then
                                exit(false);
                    end;
                end;
            SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo":
                begin
                    PostingSelectionManagement.CheckUserCanInvoiceSales();
                    if not ConfirmManagement.GetResponseOrDefault(
                            PostingSelectionManagement.GetPostConfirmationMessage(SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice, WithPrint, WithEmail), true)
                    then
                        exit(false);
                end;
            else
                if not ConfirmManagement.GetResponseOrDefault(
                        PostingSelectionManagement.GetPostConfirmationMessage(Format(SalesHeader."Document Type"), WithPrint, WithEmail), true)
                then
                    exit(false);
        end;

        SalesHeaderToPost.Copy(SalesHeader);
        exit(true);
    end;

    var
        ShipInvoiceOptionsQst: Label '&Ship,&Invoice,Ship &and Invoice';
        ReceiveInvoiceOptionsQst: Label '&Receive,&Invoice,Receive &and Invoice';
        ReceiveInvoiceConfirmQst: Label 'Do you want to post the receipt and invoice?';
        PostingSelectionManagement: Codeunit "Posting Selection Management";
}