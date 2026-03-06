codeunit 50150 "Hagiwara Send Email"
{

    trigger OnRun()
    var
        EmailQueue: Record "Email Queue Entry";
        SentErr: Text[250];
    begin

        EmailQueue.Reset();
        EmailQueue.SetRange(Status, EmailQueue.Status::"Ready to Send");
        if EmailQueue.IsEmpty then
            exit;

        // Find email sender.
        FromEmailAccount := 'Hagiwara Approval';
        CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
        TempCuEmailAccount.Reset;
        TempCuEmailAccount.SetRange(Name, FromEmailAccount);
        if not TempCuEmailAccount.FindFirst() then
            Error('Email Account not found.');

        // Find Email queues to send.
        EmailQueue.Reset();
        EmailQueue.SetRange(Status, Enum::"HW Email Status"::"Ready to Send");
        EmailQueue.ModifyAll(Status, Enum::"HW Email Status"::Processing);

        EmailQueue.Reset();
        EmailQueue.SetRange(Status, Enum::"HW Email Status"::Processing);
        if EmailQueue.FindSet() then
            repeat

                SentErr := SendEmail(EmailQueue);

                EmailQueue."Sent Datetime" := CurrentDateTime;

                if SentErr <> '' then begin
                    EmailQueue."Error Msg" := SentErr;
                    EmailQueue.Status := Enum::"HW Email Status"::Error;
                end else begin
                    EmailQueue.Status := Enum::"HW Email Status"::Sent;
                end;
                EmailQueue.Modify();

            until EmailQueue.Next() = 0;
    end;

    var
        FromEmailAccount: Text[250];
        CuEmailAccount: Codeunit "Email Account";
        TempCuEmailAccount: record "Email Account" temporary;

    local procedure SendEmail(pEmailQueue: Record "Email Queue Entry"): Text
    var
        EmailToList: List of [Text];
        EmailCCList: List of [Text];
        EmailBCCList: List of [Text];
        isSent: boolean;
        CuEmailMessage: codeunit "Email Message";
        CuEmail: codeunit Email;

        recPurchHeader: Record "Purchase Header";
        tmpBlob: Codeunit "Temp Blob";
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        format: ReportFormat;
        recRef: RecordRef;
        fldRef: FieldRef;
    begin
        EmailToList := pEmailQueue."Send To".Split(';');
        CuEmailMessage.Create(EmailToList, pEmailQueue."Email Subject", pEmailQueue."Email Body", true, EmailCCList, EmailBCCList);

        // Attach the pdf when it's an IC Trade purchase order. 
        if (pEmailQueue.Type = Enum::"HW Email Type"::"IC Trade")
            and (pEmailQueue."IC Doc. Type" = Enum::"HW Email IC Doc Type"::"Purchase Order") then begin

            recRef.GetTable(recPurchHeader);
            fldRef := recRef.Field(recPurchHeader.FieldNo("No."));
            fldRef.SetRange(pEmailQueue."IC Doc. No.");
            tmpBlob.CreateOutStream(OutStr);
            if Report.SaveAs(Report::"Purchase Order US", '', format::Pdf, OutStr, recRef) then begin
                tmpBlob.CreateInStream(InStr);
                txtB64 := cnv64.ToBase64(InStr, true);
                CuEmailMessage.AddAttachment('Purchase Order-' + pEmailQueue."IC Doc. No." + '.pdf', 'application/pdf', txtB64);
            end;
        end;

        isSent := CuEmail.Send(CuEmailMessage, TempCuEmailAccount."Account Id", TempCuEmailAccount.Connector);
        if not isSent then begin
            exit(CopyStr(GetLastErrorText, 1, 250));
        end;

        exit('');
    end;
}
