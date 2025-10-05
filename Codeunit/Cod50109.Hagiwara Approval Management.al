codeunit 50109 "Hagiwara Approval Management"
{
    trigger OnRun()
    begin
    end;

    var
        EmailType: Option Submit,Cancel,Approval,Reject;


    local procedure CreateDataLink(Data: Option; DataNo: Code[20]) dataLink: Text
    var
        AADTenant: Codeunit "Azure AD Tenant";
        EnvInfo: Codeunit "Environment Information";
    begin
        dataLink := 'https://businesscentral.dynamics.com/';
        dataLink := dataLink + AADTenant.GetAadTenantId() + '/';
        dataLink := dataLink + EnvInfo.GetEnvironmentName();
        dataLink := dataLink + '?company=' + CompanyName;
        dataLink := dataLink + '&page=42';
        dataLink := dataLink + '&filter=''No.'' is ''' + DataNo + '''';

        exit(dataLink);
    end;

    [TryFunction]
    procedure SendNotificationEmail(Data: Option; DataNo: code[20]; SendFrom: Code[50]; SendTo: Code[50]; EmailType: Option Submit,Cancel,Approval,Reject)
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

                    subject := Format(Data) + ' : ' + DataNo + ' Approval Request has been made.';
                    //body := body + ApprovalEntry.Comment + '</p><br/>'; //TODO
                    body := body + '<p>' + CreateDataLink(Data, DataNo) + '</p><br/>';
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
