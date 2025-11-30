codeunit 50427 "ICInboxOutboxMgt Subscriber"
{
    /// <summary>
    /// Purchase order will be sent to PC automatically. (for example, HET Purchase Order => SH Inbox.)
    /// </summary>
    /// <param name="PurchaseHeader"></param>
    /// <param name="PurchaseLine"></param>
    /// <param name="ICOutboxPurchaseHeader"></param>
    /// <param name="ICOutboxTransaction"></param>
    /// <param name="LinesCreated"></param>
    /// <param name="Post"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnBeforeICOutboxTransactionCreatedPurchDocTrans, '', false, false)]
    local procedure DoOnBeforeICOutboxTransactionCreatedPurchDocTrans(
        var PurchaseHeader: Record "Purchase Header";
        var PurchaseLine: Record "Purchase Line";
        var ICOutboxPurchaseHeader: Record "IC Outbox Purchase Header";
        var ICOutboxTransaction: Record "IC Outbox Transaction";
        LinesCreated: Boolean;
        Post: Boolean)
    var
        IC_Hagi: Boolean;
        ICSetup: Record "IC Setup";
        cuICOutboxExp: Codeunit "IC Outbox Export";
    begin
        IC_Hagi := true; //Just in case if this function needs to be on/off.

        if IC_Hagi then begin
            ICSetup.Get();
            ICSetup."Auto. Send Transactions" := true;
            ICSetup.Modify();

            ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::"Send to IC Partner";
            ICOutboxTransaction.Modify();
            cuICOutboxExp.ProcessAutoSendOutboxTransactionNo(ICOutboxTransaction."Transaction No.");

            ICSetup."Auto. Send Transactions" := false;
            ICSetup.Modify();

            SendEmail_SendToPC(ICOutboxTransaction, PurchaseHeader);
        end;

    end;

    /// <summary>
    /// Purchase order will be sent back SC automatically. (for example, SH Inbox => HET Outbox.)
    /// </summary>
    /// <param name="ICInboxTransaction"></param>
    /// <param name="ICOutboxTransaction"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterForwardToOutBoxSalesDoc, '', false, false)]
    local procedure DoOnAfterForwardToOutBoxSalesDoc(
        var ICInboxTransaction: Record "IC Inbox Transaction";
        var ICOutboxTransaction: Record "IC Outbox Transaction")
    var
        IC_Hagi: Boolean;
        ICSetup: Record "IC Setup";
        cuICOutboxExp: Codeunit "IC Outbox Export";
    begin
        IC_Hagi := true; //Just in case if this function needs to be on/off.

        if IC_Hagi then begin
            ICSetup.Get();
            ICSetup."Auto. Send Transactions" := true;
            ICSetup.Modify();

            ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::"Send to IC Partner";
            ICOutboxTransaction.Modify();
            cuICOutboxExp.ProcessAutoSendOutboxTransactionNo(ICOutboxTransaction."Transaction No.");

            ICSetup."Auto. Send Transactions" := false;
            ICSetup.Modify();

            SendEmail_ReturnToSC(ICInboxTransaction);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnCreateOutboxPurchDocTransOnAfterICOutBoxPurchLineInsert, '', false, false)]
    local procedure DoOnCreateOutboxPurchDocTransOnAfterICOutBoxPurchLineInsert(
        var ICOutboxPurchaseLine: Record "IC Outbox Purchase Line";
        PurchaseLine: Record "Purchase Line")
    var
    begin
        ICOutboxPurchaseLine."Customer Order No." := PurchaseLine."CO No.";
        ICOutboxPurchaseLine."Requested Delivery Date_1" := PurchaseLine."Requested Receipt Date_1";
        ICOutboxPurchaseLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterICInboxSalesLineInsert, '', false, false)]
    local procedure DoOnAfterICInboxSalesLineInsert(
        var ICInboxSalesLine: Record "IC Inbox Sales Line";
        ICOutboxPurchaseLine: Record "IC Outbox Purchase Line")
    begin
        ICInboxSalesLine."Customer Order No." := ICOutboxPurchaseLine."Customer Order No.";
        ICInboxSalesLine."Requested Delivery Date_1" := ICOutboxPurchaseLine."Requested Delivery Date_1";
        ICInboxSalesLine.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterCreateSalesLines, '', false, false)]
    local procedure DoOnAfterCreateSalesLines(
        ICInboxSalesLine: Record "IC Inbox Sales Line";
        var SalesLine: Record "Sales Line";
        var SalesHeader: Record "Sales Header")
    begin
        SalesLine."Customer Order No." := ICInboxSalesLine."Customer Order No.";
        SalesLine."Requested Delivery Date_1" := ICInboxSalesLine."Requested Delivery Date_1";
        SalesLine.Modify();

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnAfterCreateSalesDocument, '', false, false)]
    local procedure DoOnAfterCreateSalesDocument(
        var SalesHeader: Record "Sales Header";
        ICInboxSalesHeader: Record "IC Inbox Sales Header";
        HandledICInboxSalesHeader: Record "Handled IC Inbox Sales Header")
    var
        cuApprMgt: Codeunit "Hagiwara Approval Management";
    begin

        cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Sales Order", SalesHeader."No.", UserId);
    end;

    local procedure GetCompBadgeText(var pCompInfo: Record "Company Information"): Text[6]
    var
        CustomSystemIndicatorText: Text[250];
        IndicatorStyle: Option;
    begin
        pCompInfo.GetSystemIndicator(CustomSystemIndicatorText, IndicatorStyle); // IndicatorStyle is not used
        exit(CopyStr(CustomSystemIndicatorText, 1, 6));
    end;

    /// <summary>
    /// Send Email from SC to PC when SC sent the purchase order.
    /// This function is supposed called only from SC.
    /// </summary>
    /// <param name="pICOutboxTransaction"></param>
    /// <param name="pPurchHeader"></param>
    /// <returns></returns>
    [TryFunction]
    procedure SendEmail_SendToPC(pICOutboxTransaction: Record "IC Outbox Transaction"; pPurchHeader: Record "Purchase Header")
    var
        CompInfoSC: Record "Company Information";
        CompInfoPC: Record "Company Information";
        ContactInfo: Record Contact;
        ICSetup: Record "IC Setup";
        ICPartner: Record "IC Partner";
        subject, body : text;
        isSent: boolean;
        dateStr: text;
        EmailTo: Text;
        EmailCC: Text;

        EmailToList: List of [Text];
        EmailCCList: List of [Text];
        EmailBCCList: List of [Text];
        CuEmailAccount: Codeunit "Email Account";
        TempCuEmailAccount: record "Email Account" temporary;
        CuEmailMessage: codeunit "Email Message";
        CuEmail: codeunit Email;
        FromEmailAccount: Text;

        tmpBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        format: ReportFormat;
        recRef: RecordRef;
        fldRef: FieldRef;
    begin
        CompInfoSC.Get(); //Sales Company. such as Hagiwara Thailand.
        ICSetup.Get();

        ICPartner.Get(pICOutboxTransaction."IC Partner Code");
        CompInfoPC.ChangeCompany(ICPartner."Inbox Details");
        CompInfoPC.Get(); //Purchase Company. such as Hagiwara Singaore. So needs ChangeCompany call.

        subject := '[' + GetCompBadgeText(CompInfoSC) + '] Sales Order Creation Request_';
        subject := subject + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2>-<Hours24><Minutes,2>');

        body := body + '<p>Dear ' + ICPartner.Name + ',</p>';
        body := body + '<p>';
        body := body + 'Please kindly confirm the Intercompany Inbox Transactions,<br/>';
        body := body + 'Thank you in advance for your cooperation.';
        body := body + '</p>';
        body := body + '<p>';
        body := body + 'Best regards,<br/>';
        body := body + CompInfoSC.Name + '<br/>';
        body := body + ICSetup."IC Transaction Approver";
        body := body + '</p>';

        EmailTo := ICPartner."IC Transaction Partner Email";

        FromEmailAccount := 'IC Approval';
        EmailToList := EmailTo.Split(';');
        EmailCCList := EmailCC.Split(';');

        recRef.GetTable(pPurchHeader);
        fldRef := recRef.Field(pPurchHeader.FieldNo("No."));
        fldRef.SetRange(pPurchHeader."No.");
        tmpBlob.CreateOutStream(OutStr);
        if Report.SaveAs(Report::"Purchase Order US", '', format::Pdf, OutStr, recRef) then begin
            tmpBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
            CuEmailMessage.Create(EmailToList, subject, body, true, EmailCCList, EmailBCCList);
            CuEmailMessage.AddAttachment('Purchase Order-' + pPurchHeader."No." + '.pdf', 'application/pdf', txtB64);
        end;

        CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
        TempCuEmailAccount.Reset;
        TempCuEmailAccount.SetRange(Name, FromEmailAccount);
        if TempCuEmailAccount.FindFirst() then begin
            isSent := CuEmail.Send(CuEmailMessage, TempCuEmailAccount."Account Id", TempCuEmailAccount.Connector);
            if not isSent then begin
                Error('Email Account seems not setup right.');
            end;
        end else begin
            Error('There is no email account ''%1''', FromEmailAccount);
        end;

    end;


    [TryFunction]
    /// Send Email from PC to SC when PC rejected the purchase order.
    /// This function is supposed called only from PC.
    procedure SendEmail_ReturnToSC(pICInboxTransaction: Record "IC Inbox Transaction")
    var
        CompInfoSC: Record "Company Information";
        CompInfoPC: Record "Company Information";
        UserInfo: Record User;
        ICSetup: Record "IC Setup";
        ICPartner: Record "IC Partner";
        subject, body : text;
        isSent: boolean;
        dateStr: text;
        EmailTo: Text;
        EmailCC: Text;

        EmailToList: List of [Text];
        EmailCCList: List of [Text];
        EmailBCCList: List of [Text];
        CuEmailAccount: Codeunit "Email Account";
        TempCuEmailAccount: record "Email Account" temporary;
        CuEmailMessage: codeunit "Email Message";
        CuEmail: codeunit Email;
        FromEmailAccount: Text;
    begin
        CompInfoPC.Get(); //Purchase Company. such as Hagiwara Singaore.
        ICSetup.Get();

        ICPartner.Get(pICInboxTransaction."IC Partner Code");
        CompInfoSC.ChangeCompany(ICPartner."Inbox Details");
        CompInfoSC.Get(); //Sales Company. such as Hagiwara Thailand. So needs ChangeCompany call.

        subject := '[' + GetCompBadgeText(CompInfoPC) + '] Sales Order Creation Rejected_';
        subject := subject + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2>-<Hours24><Minutes,2>');

        body := body + '<p>Dear ' + ICPartner.Name + ',</p>';
        body := body + '<p>';
        body := body + 'Please kindly confirm the Intercompany Inbox Transactions,<br/>';
        body := body + 'Thank you in advance for your cooperation.';
        body := body + '</p>';
        body := body + '<p>';
        body := body + 'Best regards,<br/>';
        body := body + CompInfoPC.Name + '<br/>';
        body := body + ICSetup."IC Transaction Approver";
        body := body + '</p>';

        userinfo.SetRange("User Name", ICSetup."IC Transaction Approver");
        if userinfo.FindFirst() then
            EmailTo := userinfo."Contact Email";

        FromEmailAccount := 'IC Approval';
        EmailToList := EmailTo.Split(';');
        EmailCCList := EmailCC.Split(';');
        CuEmailMessage.Create(EmailToList, subject, body, true, EmailCCList, EmailBCCList);

        CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
        TempCuEmailAccount.Reset;
        TempCuEmailAccount.SetRange(Name, FromEmailAccount);
        if TempCuEmailAccount.FindFirst() then begin
            isSent := CuEmail.Send(CuEmailMessage, TempCuEmailAccount."Account Id", TempCuEmailAccount.Connector);
            if not isSent then begin
                Error('Email Account seems not setup right.');
            end;
        end else begin
            Error('There is no email account ''%1''', FromEmailAccount);
        end;

    end;



}