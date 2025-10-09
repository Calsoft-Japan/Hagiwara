codeunit 50109 "Hagiwara Approval Management"
{
    trigger OnRun()
    begin
    end;

    procedure Submit(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pRequester: Code[50])
    var
        SalesHeader: Record "Sales Header";
        recReqGroupMem: Record "Hagiwara Request Group Member";
        recApprCondition: Record "Hagiwara Approval Condition";
        recApprHrcy: Record "Hagiwara Approval Hierarchy";
        pagComment: page "Hagiwara Approval Comment";
        recApprEntry: Record "Hagiwara Approval Entry";
        ReqGroup: Code[30];
        ApprGroup: Code[30];
        AmountLCY: Decimal;
        Approver: Code[50];
        MsgComment: Text;
    begin
        recReqGroupMem.SetRange(Data, pData);
        recReqGroupMem.SetRange("Request User Name", pRequester);
        if recReqGroupMem.FindFirst() then
            ReqGroup := recReqGroupMem."Request Group Code";

        SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
        SalesHeader.CalcFields(Amount);
        AmountLCY := CalcSOAmountLCY(SalesHeader);

        recApprCondition.SetRange(Data, pData);
        recApprCondition.SetRange("Request Group Code", reqGroup);
        recApprCondition.SetFilter("Start Date", '..%1', WorkDate());
        recApprCondition.SetFilter("End Date", '%1|%2..', 0D, WorkDate());
        recApprCondition.SetFilter("Amount (LCY)", '%1|%2..', 0, AmountLCY);
        if not recApprCondition.FindFirst() then
            error('Hagiwara Approval Condition seems not setup right.');

        ApprGroup := recApprCondition."Approval Group Code";

        recApprHrcy.SetRange("Approval Group Code", ApprGroup);
        if not recApprHrcy.FindFirst() then
            error('Hagiwara Approval Hierarchy seems not setup right.');

        Approver := recApprHrcy."Approver User Name";


        //ToDo, consider Approval Substitution.


        pagComment.SetData(pData, pDataNo);
        if pagComment.RunModal() = Action::OK then begin
            MsgComment := pagComment.GetComment();
            MsgComment := Format(CurrentDateTime) + '. ' + 'Submit. ' + UserId() + '\' + MsgComment;
            InsertApprEntry(
                pData,
                pDataNo,
                pRequester,
                ReqGroup,
                Approver,
                ApprGroup,
                recApprHrcy."Sequence No.",
                "Hagiwara Approval Status"::Submitted,
                MsgComment
            );

            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Submitted;
            SalesHeader.Requester := UserId;
            SalesHeader."Hagi Approver" := Approver;
            SalesHeader.Modify();

            SendNotificationEmail(pData, pDataNo, pRequester, Approver, EmailType::Submit);

            Message('Approval Request submitted.');
        end;

    end;


    procedure Cancel(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pRequester: Code[50])
    var
        SalesHeader: Record "Sales Header";
        pagComment: page "Hagiwara Approval Comment";
        MsgComment: Text;
    begin

        pagComment.SetData(pData, pDataNo);
        if pagComment.RunModal() = Action::OK then begin
            MsgComment := pagComment.GetComment();
            MsgComment := Format(CurrentDateTime) + '. ' + 'Cancel. ' + UserId() + '\' + MsgComment;
            CancelApprEntry(
                pData,
                pDataNo,
                MsgComment
            );

            SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
            SalesHeader.Requester := '';
            SalesHeader."Hagi Approver" := '';
            SalesHeader.Modify();

            SendNotificationEmail(pData, pDataNo, pRequester, '', EmailType::Cancel);

            Message('Approval Request cancelled.');
        end;
    end;


    procedure CancelApprEntry(
        pData: Enum "Hagiwara Approval Data";
        pDataNo: Code[20];
        pComment: Text
    )
    var
        recApprEntry: Record "Hagiwara Approval Entry";
    begin
        recApprEntry.SetRange(Open, true);
        recApprEntry.SetRange(Data, pData);
        recApprEntry.SetRange("No.", pDataNo);

        if recApprEntry.FindFirst() then begin
            recApprEntry.Status := Enum::"Hagiwara Approval Status"::Cancelled;
            recApprEntry.Modify();

            recApprEntry.AddComment(pComment);
        end;
    end;

    procedure InsertApprEntry(
        pData: Enum "Hagiwara Approval Data";
        pDataNo: Code[20];
        pRequester: Code[50];
        pReqGroup: Code[30];
        pApprover: Code[50];
        pApprGroup: Code[30];
        pApprSeq: Integer;
        pStatus: Enum "Hagiwara Approval Status";
        pComment: Text
    )
    var
        recApprEntry: Record "Hagiwara Approval Entry";
        ReqComment: BigText;
        Ostream: OutStream;
    begin
        recApprEntry.Data := pData;
        recApprEntry."No." := pDataNo;
        recApprEntry.Requester := pRequester;
        recApprEntry."Request Group" := pReqGroup;
        recApprEntry.Approver := pApprover;
        recApprEntry."Approval Group" := pApprGroup;
        recApprEntry."Approval Sequence No." := pApprSeq;
        recApprEntry."Request Date" := WorkDate();
        recApprEntry.Status := pStatus;
        recApprEntry.Open := true;

        recApprEntry.Insert();

        recApprEntry.AddComment(pComment);


    end;

    var
        EmailType: Option Submit,Cancel,Approval,Reject;

    procedure CalcSOAmountLCY(pSalesHeader: Record "Sales Header"): Decimal
    var
        CurrencyLocal: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RateDate: Date;
        rtnAmountLCY: Decimal;
    begin
        RateDate := pSalesHeader."Posting Date";
        if RateDate = 0D then
            RateDate := WorkDate();

        CurrencyLocal.InitRoundingPrecision();
        if pSalesHeader."Currency Code" <> '' then
            rtnAmountLCY :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  RateDate, pSalesHeader."Currency Code",
                  pSalesHeader.Amount, pSalesHeader."Currency Factor"),
                CurrencyLocal."Amount Rounding Precision")
        else
            rtnAmountLCY :=
              Round(pSalesHeader.Amount, CurrencyLocal."Amount Rounding Precision");

        exit(rtnAmountLCY);
    end;


    local procedure CreateDataLink(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]): Text
    var
        AADTenant: Codeunit "Azure AD Tenant";
        EnvInfo: Codeunit "Environment Information";
        dataLink: Text;
    begin
        dataLink := 'https://businesscentral.dynamics.com/';
        dataLink := dataLink + AADTenant.GetAadTenantId() + '/';
        dataLink := dataLink + EnvInfo.GetEnvironmentName();
        dataLink := dataLink + '?company=' + CompanyName;
        dataLink := dataLink + '&page=42';
        dataLink := dataLink + '&filter=''No.'' is ''' + pDataNo + '''';

        exit(dataLink);
    end;

    [TryFunction]
    procedure SendNotificationEmail(pData: Enum "Hagiwara Approval Data"; pDataNo: code[20]; SendFrom: Code[50]; SendTo: Code[50]; EmailType: Option Submit,Cancel,Approval,Reject)
    var
        subject, body : text;
        isSent: boolean;
        dateStr: text;
        UserInfo: Record User;
        EmailTo: Text;
    begin
        case EmailType of
            EmailType::Submit:
                begin

                    subject := Format(pData) + ' : ' + pDataNo + ' Approval Request has been made.';
                    //body := body + ApprovalEntry.Comment + '</p><br/>'; //TODO
                    body := body + '<p>' + CreateDataLink(pData, pDataNo) + '</p><br/>';
                    //body := body + '<p>' + approver's info+'</p><br/>'; //TODO
                end;
            EmailType::Cancel:
                begin

                    subject := Format(pData) + ' : ' + pDataNo + ' Approval Request has been cancelled.';
                    //body := body + ApprovalEntry.Comment + '</p><br/>'; //TODO
                    body := body + '<p>' + CreateDataLink(pData, pDataNo) + '</p><br/>';
                    //body := body + '<p>' + approver's info+'</p><br/>'; //TODO
                end;
        end;

        userinfo.SetRange("User Name", SendTo);
        if userinfo.FindFirst() then
            EmailTo := userinfo."Contact Email";

        isSent := SendEmail(EmailTo, '', subject, body);

    end;

    [TryFunction]
    procedure SendEmail(EmailTo: Text; EmailCC: Text; EmailSubject: Text; EmailBody: Text)
    var
        EmailToList: List of [Text];
        EmailCCList: List of [Text];
        EmailBCCList: List of [Text];
        CuEmailAccount: Codeunit "Email Account";
        TempCuEmailAccount:
                record "Email Account" temporary;
        isSent:
                boolean;
        CuEmailMessage:
                codeunit "Email Message";
        CuEmail:
                codeunit Email;
    begin
        if EmailCC <> '' then begin
            CuEmailMessage.Create(EmailTo, EmailSubject, EmailBody, true);
        end
        else begin
            EmailToList := EmailTo.Split(';');
            EmailCCList := EmailCC.Split(';');
            CuEmailMessage.Create(EmailToList, EmailSubject, EmailBody, true, EmailCCList, EmailBCCList);
        end;
        CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
        TempCuEmailAccount.Reset;
        TempCuEmailAccount.SetRange(Name, 'Current User');
        if TempCuEmailAccount.FindFirst() then
            isSent := CuEmail.Send(CuEmailMessage, TempCuEmailAccount."Account Id", TempCuEmailAccount.Connector)
        else
            isSent := CuEmail.Send(CuEmailMessage);
    end;
}
