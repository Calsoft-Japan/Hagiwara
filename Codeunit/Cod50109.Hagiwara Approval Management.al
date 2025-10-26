codeunit 50109 "Hagiwara Approval Management"
{
    trigger OnRun()
    begin
    end;

    procedure Submit(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pUsername: Code[50])
    var
        recReqGroupMem: Record "Hagiwara Request Group Member";
        recApprCondition: Record "Hagiwara Approval Condition";
        recApprHrcy: Record "Hagiwara Approval Hierarchy";
        pagComment: page "Hagiwara Approval Comment";
        recApprEntry: Record "Hagiwara Approval Entry";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        ReqGroup: Code[30];
        ApprGroup: Code[30];
        AmountLCY: Decimal;
        Approver: Code[50];
        MsgComment: Text;
    begin

        recReqGroupMem.SetRange(Data, pData);
        recReqGroupMem.SetRange("Request User Name", pUsername);
        if recReqGroupMem.FindFirst() then
            ReqGroup := recReqGroupMem."Request Group Code";

        //Calculate Amount(LCY) to find Approval Condition.
        case pData of
            Enum::"Hagiwara Approval Data"::"Sales Order":
                begin
                    SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                    SalesHeader.CalcFields(Amount);
                    AmountLCY := CalcSOAmountLCY(SalesHeader);
                end;
            Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                begin
                    SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                    SalesHeader.CalcFields(Amount);
                    AmountLCY := CalcSOAmountLCY(SalesHeader);
                end;
            Enum::"Hagiwara Approval Data"::"Sales Return Order":
                begin
                    SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                    SalesHeader.CalcFields(Amount);
                    AmountLCY := CalcSOAmountLCY(SalesHeader);
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Order":
                begin
                    PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                    PurchHeader.CalcFields(Amount);
                    AmountLCY := CalcPOAmountLCY(PurchHeader);
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                begin
                    PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                    PurchHeader.CalcFields(Amount);
                    AmountLCY := CalcPOAmountLCY(PurchHeader);
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                begin
                    PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                    PurchHeader.CalcFields(Amount);
                    AmountLCY := CalcPOAmountLCY(PurchHeader);
                end;
        end;


        recApprCondition.SetRange(Data, pData);
        recApprCondition.SetRange("Request Group Code", reqGroup);
        recApprCondition.SetFilter("Start Date", '..%1', WorkDate());
        recApprCondition.SetFilter("End Date", '%1|%2..', 0D, WorkDate());
        recApprCondition.SetFilter("Amount (LCY)", '%1|<=%2', 0, AmountLCY);
        if not recApprCondition.FindLast() then
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
            MsgComment := 'Requester (' + pUsername + '):' + TypeHelper.LFSeparator() + MsgComment + TypeHelper.LFSeparator();
            recApprEntry := InsertApprEntry(
                pData,
                pDataNo,
                pUsername,
                ReqGroup,
                Approver,
                ApprGroup,
                recApprHrcy."Sequence No.",
                "Hagiwara Approval Status"::Submitted,
                MsgComment
            );


            case pData of
                Enum::"Hagiwara Approval Data"::"Sales Order",
                Enum::"Hagiwara Approval Data"::"Sales Credit Memo",
                Enum::"Hagiwara Approval Data"::"Sales Return Order":
                    begin
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Submitted;
                        SalesHeader.Requester := UserId;
                        SalesHeader."Hagi Approver" := Approver;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Order",
                Enum::"Hagiwara Approval Data"::"Purchase Credit Memo",
                Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                    begin
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Submitted;
                        PurchHeader.Requester := UserId;
                        PurchHeader."Hagi Approver" := Approver;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Transfer Order":
                    begin
                        TransHeader.get(pDataNo);
                        TransHeader."Approval Status" := "Hagiwara Approval Status"::Submitted;
                        TransHeader.Requester := UserId;
                        TransHeader."Hagi Approver" := Approver;
                        TransHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Item Journal",
                Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                    begin
                        ItemJourLine.Reset();
                        ItemJourLine.setRange("Document No.", pDataNo);
                        if ItemJourLine.FindSet() then
                            repeat
                                ItemJourLine."Approval Status" := "Hagiwara Approval Status"::Submitted;
                                ItemJourLine.Requester := UserId;
                                ItemJourLine."Hagi Approver" := Approver;
                                ItemJourLine.Modify();
                            until ItemJourLine.Next() = 0;
                    end;
                Enum::"Hagiwara Approval Data"::"Item":
                    begin
                        ItemImportBatch.get(pDataNo);
                        ItemImportBatch."Approval Status" := "Hagiwara Approval Status"::Submitted;
                        ItemImportBatch.Requester := UserId;
                        ItemImportBatch."Hagi Approver" := Approver;
                        ItemImportBatch.Modify();
                    end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, Approver, '', EmailType::Submit, recApprEntry);

            Message('Approval Request submitted.');
        end;

    end;

    procedure Cancel(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pUsername: Code[50])
    var
        recApprEntry: Record "Hagiwara Approval Entry";
        pagComment: page "Hagiwara Approval Comment";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        MsgComment: Text;
    begin

        recApprEntry.SetRange(Open, true);
        recApprEntry.SetRange(Data, pData);
        recApprEntry.SetRange("No.", pDataNo);
        if not recApprEntry.FindFirst() then
            Error('No Approval Entry found!');

        pagComment.SetData(pData, pDataNo);
        if pagComment.RunModal() = Action::OK then begin
            MsgComment := pagComment.GetComment();
            MsgComment := 'Approver (' + recApprEntry.Requester + '):' + TypeHelper.LFSeparator() + MsgComment + TypeHelper.LFSeparator();

            // update approval entry data.
            recApprEntry.Status := Enum::"Hagiwara Approval Status"::Cancelled;
            recApprEntry.Open := false;
            recApprEntry."Close Date" := WorkDate();
            recApprEntry.Modify();

            recApprEntry.AddComment(MsgComment);

            // update transaction data.
            case pData of
                Enum::"Hagiwara Approval Data"::"Sales Order":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        SalesHeader.Requester := '';
                        SalesHeader."Hagi Approver" := '';
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        SalesHeader.Requester := '';
                        SalesHeader."Hagi Approver" := '';
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Sales Return Order":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        SalesHeader.Requester := '';
                        SalesHeader."Hagi Approver" := '';
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Order":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        PurchHeader.Requester := '';
                        PurchHeader."Hagi Approver" := '';
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        PurchHeader.Requester := '';
                        PurchHeader."Hagi Approver" := '';
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        PurchHeader.Requester := '';
                        PurchHeader."Hagi Approver" := '';
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Transfer Order":
                    begin
                        TransHeader.get(pDataNo);
                        TransHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        TransHeader.Requester := '';
                        TransHeader."Hagi Approver" := '';
                        TransHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Assembly Order":
                    begin
                        AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                        AssemblyHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        AssemblyHeader.Requester := '';
                        AssemblyHeader."Hagi Approver" := '';
                        AssemblyHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Item Journal",
                Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                    begin
                        ItemJourLine.Reset();
                        ItemJourLine.setRange("Document No.", pDataNo);
                        if ItemJourLine.FindSet() then
                            repeat
                                ItemJourLine."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                                ItemJourLine.Requester := '';
                                ItemJourLine."Hagi Approver" := '';
                                ItemJourLine.Modify();
                            until ItemJourLine.Next() = 0;
                    end;
                Enum::"Hagiwara Approval Data"::"Item":
                    begin
                        ItemImportBatch.get(pDataNo);
                        ItemImportBatch."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        ItemImportBatch.Requester := '';
                        ItemImportBatch."Hagi Approver" := '';
                        ItemImportBatch.Modify();
                    end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, recApprEntry.Requester, '', EmailType::Cancel, recApprEntry);

            Message('Approval Request cancelled.');
        end;
    end;

    procedure Approve(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pUsername: Code[50])
    var
        recApprHrcy: Record "Hagiwara Approval Hierarchy";
        recApprEntry: Record "Hagiwara Approval Entry";
        pagComment: page "Hagiwara Approval Comment";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        nextApprover: Code[50];
        MsgComment: Text;
    begin
        recApprEntry.SetRange(Open, true);
        recApprEntry.SetRange(Data, pData);
        recApprEntry.SetRange("No.", pDataNo);
        if not recApprEntry.FindFirst() then
            Error('No Approval Entry found!');

        pagComment.SetData(pData, pDataNo);
        if pagComment.RunModal() = Action::OK then begin
            MsgComment := pagComment.GetComment();
            MsgComment := 'Approver (' + recApprEntry.Approver + '):' + TypeHelper.LFSeparator() + MsgComment + TypeHelper.LFSeparator();

            // update approval entry data.
            recApprEntry.Status := Enum::"Hagiwara Approval Status"::Approved;
            recApprEntry.Open := false;
            recApprEntry."Close Date" := WorkDate();
            recApprEntry.Modify();

            recApprEntry.AddComment(MsgComment);

            // update transaction data.
            case pData of
                Enum::"Hagiwara Approval Data"::"Sales Order":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                        SalesHeader."Hagi Approver" := pUsername;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                        SalesHeader."Hagi Approver" := pUsername;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Sales Return Order":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                        SalesHeader."Hagi Approver" := pUsername;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Order":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                        PurchHeader."Hagi Approver" := pUsername;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                        PurchHeader."Hagi Approver" := pUsername;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                        PurchHeader."Hagi Approver" := pUsername;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Transfer Order":
                    begin
                        TransHeader.get(pDataNo);
                        TransHeader."Hagi Approver" := pUsername;
                        TransHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Assembly Order":
                    begin
                        AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                        AssemblyHeader."Hagi Approver" := pUsername;
                        AssemblyHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Item Journal",
                Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                    begin
                        ItemJourLine.Reset();
                        ItemJourLine.setRange("Document No.", pDataNo);
                        if ItemJourLine.FindSet() then
                            repeat
                                ItemJourLine."Hagi Approver" := pUsername;
                                ItemJourLine.Modify();
                            until ItemJourLine.Next() = 0;
                    end;
                Enum::"Hagiwara Approval Data"::"Item":
                    begin
                        ItemImportBatch.get(pDataNo);
                        ItemImportBatch."Hagi Approver" := pUsername;
                        ItemImportBatch.Modify();
                    end;
            end;

            // ask approvel for next approver.
            recApprHrcy.SetRange("Approval Group Code", recApprEntry."Approval Group");
            recApprHrcy.SetFilter("Sequence No.", '>%1', recApprEntry."Approval Sequence No.");
            if recApprHrcy.FindFirst() then begin

                nextApprover := recApprHrcy."Approver User Name";

                InsertApprEntry(
                    pData,
                    pDataNo,
                    recApprEntry.Requester,
                    recApprEntry."Request Group",
                    nextApprover,
                    recApprEntry."Approval Group",
                    recApprHrcy."Sequence No.",
                    "Hagiwara Approval Status"::Submitted,
                    recApprEntry.GetComment()
                );
            end else begin
                //if no next approver, change the status of the data to Approved.
                case pData of
                    Enum::"Hagiwara Approval Data"::"Sales Order":
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            SalesHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            SalesHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Sales Return Order":
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            SalesHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Order":
                        begin
                            PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                            PurchHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                        begin
                            PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                            PurchHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                        begin
                            PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                            PurchHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Transfer Order":
                        begin
                            TransHeader.get(pDataNo);
                            TransHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            TransHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Assembly Order":
                        begin
                            AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                            AssemblyHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            AssemblyHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Item Journal",
                    Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                        begin
                            ItemJourLine.Reset();
                            ItemJourLine.setRange("Document No.", pDataNo);
                            if ItemJourLine.FindSet() then
                                repeat
                                    ItemJourLine."Approval Status" := "Hagiwara Approval Status"::Approved;
                                    ItemJourLine.Modify();
                                until ItemJourLine.Next() = 0;
                        end;
                    Enum::"Hagiwara Approval Data"::"Item":
                        begin
                            ItemImportBatch.get(pDataNo);
                            ItemImportBatch."Approval Status" := "Hagiwara Approval Status"::Approved;
                            ItemImportBatch.Modify();
                        end;
                end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, recApprEntry.Requester, nextApprover, EmailType::Approval, recApprEntry);

            Message('Approval Request approved.\\The following approval request was sent if the furthermore approval is necessary.');
        end;
    end;

    procedure Reject(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pUsername: Code[50])
    var
        recApprEntry: Record "Hagiwara Approval Entry";
        pagComment: page "Hagiwara Approval Comment";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        MsgComment: Text;
    begin

        recApprEntry.SetRange(Open, true);
        recApprEntry.SetRange(Data, pData);
        recApprEntry.SetRange("No.", pDataNo);
        if not recApprEntry.FindFirst() then
            Error('No Approval Entry found!');

        pagComment.SetData(pData, pDataNo);
        if pagComment.RunModal() = Action::OK then begin
            MsgComment := pagComment.GetComment();
            MsgComment := 'Approver (' + recApprEntry.Approver + '):' + TypeHelper.LFSeparator() + MsgComment + TypeHelper.LFSeparator();

            // update approval entry data.
            recApprEntry.Status := Enum::"Hagiwara Approval Status"::Rejected;
            recApprEntry.Open := false;
            recApprEntry."Close Date" := WorkDate();
            recApprEntry.Modify();

            recApprEntry.AddComment(MsgComment);

            // update transaction data.
            case pData of
                Enum::"Hagiwara Approval Data"::"Sales Order":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        SalesHeader."Hagi Approver" := pUsername;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        SalesHeader."Hagi Approver" := pUsername;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Sales Return Order":
                    begin
                        SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                        SalesHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        SalesHeader."Hagi Approver" := pUsername;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Order":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        PurchHeader."Hagi Approver" := pUsername;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        PurchHeader."Hagi Approver" := pUsername;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                    begin
                        PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                        PurchHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        PurchHeader."Hagi Approver" := pUsername;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Transfer Order":
                    begin
                        TransHeader.get(pDataNo);
                        TransHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        TransHeader."Hagi Approver" := pUsername;
                        TransHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Assembly Order":
                    begin
                        AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                        AssemblyHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        AssemblyHeader."Hagi Approver" := pUsername;
                        AssemblyHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Item Journal",
                Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                    begin
                        ItemJourLine.Reset();
                        ItemJourLine.setRange("Document No.", pDataNo);
                        if ItemJourLine.FindSet() then
                            repeat
                                ItemJourLine."Approval Status" := "Hagiwara Approval Status"::Rejected;
                                ItemJourLine."Hagi Approver" := pUsername;
                                ItemJourLine.Modify();
                            until ItemJourLine.Next() = 0;
                    end;
                Enum::"Hagiwara Approval Data"::"Item":
                    begin
                        ItemImportBatch.get(pDataNo);
                        ItemImportBatch."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        ItemImportBatch."Hagi Approver" := pUsername;
                        ItemImportBatch.Modify();
                    end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, recApprEntry.Requester, '', EmailType::Reject, recApprEntry);

            Message('Approval Request rejected.');
        end;
    end;

    local procedure InsertApprEntry(
        pData: Enum "Hagiwara Approval Data";
        pDataNo: Code[20];
        pRequester: Code[50];
        pReqGroup: Code[30];
        pApprover: Code[50];
        pApprGroup: Code[30];
        pApprSeq: Integer;
        pStatus: Enum "Hagiwara Approval Status";
        pComment: Text
    ): Record "Hagiwara Approval Entry"
    var
        recApprEntry: Record "Hagiwara Approval Entry";
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

        exit(recApprEntry);

    end;

    var
        EmailType: Option Submit,Cancel,Approval,Reject;
        TypeHelper: Codeunit "Type Helper";

    local procedure CalcSOAmountLCY(pSalesHeader: Record "Sales Header"): Decimal
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

    local procedure CalcPOAmountLCY(pPurchHeader: Record "Purchase Header"): Decimal
    var
        CurrencyLocal: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RateDate: Date;
        rtnAmountLCY: Decimal;
    begin
        RateDate := pPurchHeader."Posting Date";
        if RateDate = 0D then
            RateDate := WorkDate();

        CurrencyLocal.InitRoundingPrecision();
        if pPurchHeader."Currency Code" <> '' then
            rtnAmountLCY :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  RateDate, pPurchHeader."Currency Code",
                  pPurchHeader.Amount, pPurchHeader."Currency Factor"),
                CurrencyLocal."Amount Rounding Precision")
        else
            rtnAmountLCY :=
              Round(pPurchHeader.Amount, CurrencyLocal."Amount Rounding Precision");

        exit(rtnAmountLCY);
    end;


    local procedure CreateDataLink(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]): Text
    var
        AADTenant: Codeunit "Azure AD Tenant";
        EnvInfo: Codeunit "Environment Information";
        dataLink: Text;
    begin
        dataLink := '<a href="https://businesscentral.dynamics.com/';
        dataLink := dataLink + AADTenant.GetAadTenantId() + '/';
        dataLink := dataLink + EnvInfo.GetEnvironmentName();
        dataLink := dataLink + '?company=' + CompanyName;
        dataLink := dataLink + GetDataPageURI(pData, pDataNo);
        /*
        dataLink := dataLink + '&page=42';
        dataLink := dataLink + '&filter=''No.'' is ''' + pDataNo + '''';
        */
        dataLink := dataLink + '">'; //<a href> end
        dataLink := dataLink + 'View this data on Business Central'; // anchor text
        dataLink := dataLink + '</a>';

        exit(dataLink);
    end;

    local procedure GetDataPageURI(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]): Text
    begin
        case pData of
            Enum::"Hagiwara Approval Data"::"Sales Order":
                exit('&page=42&filter=''Sales Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                exit('&page=44&filter=''Sales Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Sales Return Order":
                exit('&page=6630&filter=''Sales Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Purchase Order":
                exit('&page=50&filter=''Purchase Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                exit('&page=52&filter=''Purchase Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                exit('&page=6640&filter=''Purchase Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Item Journal":
                exit('&page=40&filter=''Item Journal Line''.''Document No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                exit('&page=393&filter=''Item Journal Line''.''Document No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Transfer Order":
                exit('&page=5740&filter=''Transfer Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Assembly Order":
                exit('&page=900&filter=''Assembly Header''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::Customer:
                exit(''); //TODO
            Enum::"Hagiwara Approval Data"::Vendor:
                exit(''); //TODO
            Enum::"Hagiwara Approval Data"::Item:
                exit('&page=50117&filter=''Item Import Batch''.''Name'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"G/L Account":
                exit(''); //TODO
            Enum::"Hagiwara Approval Data"::"Price List":
                exit(''); //TODO
        end;

    end;

    local procedure GetApprHrcy(pApprGroup: Code[30]): Text
    var
        recApprHrcy: Record "Hagiwara Approval Hierarchy";
        dataLink: Text;
    begin

        recApprHrcy.SetRange("Approval Group Code", pApprGroup);
        if not recApprHrcy.FindFirst() then
            exit('Hagiwara Approval Hierarchy not found.');

        if recApprHrcy.FindSet() then
            repeat
                dataLink := dataLink + Format(recApprHrcy."Sequence No.") + ': ' + recApprHrcy."Approver User Name" + '<br/>';
            until recApprHrcy.Next() = 0;

        exit(dataLink);
    end;

    [TryFunction]
    procedure SendNotificationEmail(
        pData: Enum "Hagiwara Approval Data";
                   pDataNo: code[20];
                   SendFrom: Code[50];
                   SendTo: Code[50];
                   SendCC: Code[50];
                   EmailType: Option Submit,Cancel,Approval,Reject;
                   pApprEntry: Record "Hagiwara Approval Entry")
    var
        subject, body : text;
        isSent: boolean;
        dateStr: text;
        UserInfo: Record User;
        EmailTo: Text;
        EmailCC: Text;
    begin
        case EmailType of
            EmailType::Submit:
                begin

                    subject := Format(pData) + ' : ' + pDataNo + ' Approval Request has been made.';
                    body := body + '<p><b>Comment:</b></p>';
                    body := body + '<p>' + pApprEntry.GetComment().Replace(TypeHelper.LFSeparator(), '<br/>') + '</p>';
                    body := body + '<p><b>Data Link:</b></p>';
                    body := body + '<p>' + CreateDataLink(pData, pDataNo) + '</p>';
                    body := body + '<p><b>Approval Hierarchy(Seq: Approver)</b></p>';
                    body := body + '<p>' + GetApprHrcy(pApprEntry."Approval Group") + '</p>';
                end;
            EmailType::Cancel:
                begin

                    subject := Format(pData) + ' : ' + pDataNo + ' Approval Request has been cancelled.';
                    body := body + '<p><b>Comment:</b></p>';
                    body := body + '<p>' + pApprEntry.GetComment().Replace(TypeHelper.LFSeparator(), '<br/>') + '</p>';
                    body := body + '<p><b>Data Link:</b></p>';
                    body := body + '<p>' + CreateDataLink(pData, pDataNo) + '</p>';
                    body := body + '<p><b>Approval Hierarchy(Seq: Approver)</b></p>';
                    body := body + '<p>' + GetApprHrcy(pApprEntry."Approval Group") + '</p>';
                end;
            EmailType::Approval:
                begin

                    subject := Format(pData) + ' : ' + pDataNo + ' Approval Request has been approved.';
                    body := body + '<p><b>Comment:</b></p>';
                    body := body + '<p>' + pApprEntry.GetComment().Replace(TypeHelper.LFSeparator(), '<br/>') + '</p>';
                    body := body + '<p><b>Data Link:</b></p>';
                    body := body + '<p>' + CreateDataLink(pData, pDataNo) + '</p>';
                    body := body + '<p><b>Approval Hierarchy(Seq: Approver)</b></p>';
                    body := body + '<p>' + GetApprHrcy(pApprEntry."Approval Group") + '</p>';
                end;
            EmailType::Reject:
                begin

                    subject := Format(pData) + ' : ' + pDataNo + ' Approval Request has been rejected.';
                    body := body + '<p><b>Comment:</b></p>';
                    body := body + '<p>' + pApprEntry.GetComment().Replace(TypeHelper.LFSeparator(), '<br/>') + '</p>';
                    body := body + '<p><b>Data Link:</b></p>';
                    body := body + '<p>' + CreateDataLink(pData, pDataNo) + '</p>';
                    body := body + '<p><b>Approval Hierarchy(Seq: Approver)</b></p>';
                    body := body + '<p>' + GetApprHrcy(pApprEntry."Approval Group") + '</p>';
                end;
        end;

        userinfo.SetRange("User Name", SendTo);
        if userinfo.FindFirst() then
            EmailTo := userinfo."Contact Email";

        userinfo.SetRange("User Name", SendCC);
        if userinfo.FindFirst() then
            EmailCC := userinfo."Contact Email";

        isSent := SendEmail(EmailTo, EmailCC, subject, body);

    end;

    [TryFunction]
    local procedure SendEmail(EmailTo: Text; EmailCC: Text; EmailSubject: Text; EmailBody: Text)
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
        EmailToList := EmailTo.Split(';');
        EmailCCList := EmailCC.Split(';');
        CuEmailMessage.Create(EmailToList, EmailSubject, EmailBody, true, EmailCCList, EmailBCCList);

        CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
        TempCuEmailAccount.Reset;
        TempCuEmailAccount.SetRange(Name, 'Current User');
        if TempCuEmailAccount.FindFirst() then
            isSent := CuEmail.Send(CuEmailMessage, TempCuEmailAccount."Account Id", TempCuEmailAccount.Connector)
        else
            isSent := CuEmail.Send(CuEmailMessage);
    end;
}
