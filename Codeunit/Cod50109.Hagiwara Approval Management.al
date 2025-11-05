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
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        ItemImportBatch: Record "Item Import Batch";
        ReqGroup: Code[30];
        ApprGroup: Code[30];
        AmountLCY: Decimal;
        Approver: Code[50];
        MsgComment: Text;
        SubmitStatus: Enum "Hagiwara Approval Status";
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
        Approver := GetSubstitution(Approver);

        pagComment.SetData(pData, pDataNo);
        if pagComment.RunModal() = Action::OK then begin

            SubmitStatus := GetSubmitStatus(pData, pDataNo);

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
                SubmitStatus,
                MsgComment
            );

            case pData of
                Enum::"Hagiwara Approval Data"::"Sales Order",
                Enum::"Hagiwara Approval Data"::"Sales Credit Memo",
                Enum::"Hagiwara Approval Data"::"Sales Return Order":
                    begin
                        SalesHeader."Approval Status" := SubmitStatus;
                        SalesHeader.Requester := UserId;
                        SalesHeader."Hagi Approver" := Approver;
                        SalesHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Purchase Order",
                Enum::"Hagiwara Approval Data"::"Purchase Credit Memo",
                Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                    begin
                        PurchHeader."Approval Status" := SubmitStatus;
                        PurchHeader.Requester := UserId;
                        PurchHeader."Hagi Approver" := Approver;
                        PurchHeader.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Transfer Order":
                    begin
                        TransHeader.get(pDataNo);
                        TransHeader."Approval Status" := SubmitStatus;
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
                                ItemJourLine."Approval Status" := SubmitStatus;
                                ItemJourLine.Requester := UserId;
                                ItemJourLine."Hagi Approver" := Approver;
                                ItemJourLine.Modify();
                            until ItemJourLine.Next() = 0;
                    end;
                Enum::"Hagiwara Approval Data"::"Item":
                    begin
                        ItemImportBatch.get(pDataNo);
                        ItemImportBatch."Approval Status" := SubmitStatus;
                        ItemImportBatch.Requester := UserId;
                        ItemImportBatch."Hagi Approver" := Approver;
                        ItemImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Customer:
                    begin
                        Cust.get(pDataNo);
                        Cust."Approval Status" := SubmitStatus;
                        Cust.Requester := UserId;
                        Cust."Hagi Approver" := Approver;
                        Cust.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Vendor:
                    begin
                        Vend.get(pDataNo);
                        Vend."Approval Status" := SubmitStatus;
                        Vend.Requester := UserId;
                        Vend."Hagi Approver" := Approver;
                        Vend.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"G/L Account":
                    begin
                        GLAccount.get(pDataNo);
                        GLAccount."Approval Status" := SubmitStatus;
                        GLAccount.Requester := UserId;
                        GLAccount."Hagi Approver" := Approver;
                        GLAccount.Modify();
                    end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, Approver, '', EmailType::Submit, recApprEntry);

            Message('Approval Request submitted.');
        end;

    end;

    procedure Cancel(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20];
                                pUsername: Code[50])
    var
        recApprEntry: Record "Hagiwara Approval Entry";
        pagComment: page "Hagiwara Approval Comment";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
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
                Enum::"Hagiwara Approval Data"::Customer:
                    begin
                        Cust.get(pDataNo);
                        Cust."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        Cust.Requester := '';
                        Cust."Hagi Approver" := '';
                        Cust.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Vendor:
                    begin
                        Vend.get(pDataNo);
                        Vend."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        Vend.Requester := '';
                        Vend."Hagi Approver" := '';
                        Vend.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"G/L Account":
                    begin
                        GLAccount.get(pDataNo);
                        GLAccount."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        GLAccount.Requester := '';
                        GLAccount."Hagi Approver" := '';
                        GLAccount.Modify();
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
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        SalesLine: Record "Sales Line";
        SalesLineUpdated: Boolean;
        PurchLine: Record "Purchase Line";
        PurchLineUpdated: Boolean;
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

            // ask approvel for next approver.
            recApprHrcy.SetRange("Approval Group Code", recApprEntry."Approval Group");
            recApprHrcy.SetFilter("Sequence No.", '>%1', recApprEntry."Approval Sequence No.");
            if recApprHrcy.FindFirst() then begin

                nextApprover := recApprHrcy."Approver User Name";
                nextApprover := GetSubstitution(nextApprover);

                InsertApprEntry(
                    pData,
                    pDataNo,
                    recApprEntry.Requester,
                    recApprEntry."Request Group",
                    nextApprover,
                    recApprEntry."Approval Group",
                    recApprHrcy."Sequence No.",
                    recApprEntry.Status,
                    recApprEntry.GetComment()
                );

                // update transaction data.
                case pData of
                    Enum::"Hagiwara Approval Data"::"Sales Order":
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                            SalesHeader."Hagi Approver" := nextApprover;
                            SalesHeader.Modify();
                        end;

                    Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                            SalesHeader."Hagi Approver" := nextApprover;
                            SalesHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Sales Return Order":
                        begin
                            SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                            SalesHeader."Hagi Approver" := nextApprover;
                            SalesHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Order":
                        begin
                            PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                            PurchHeader."Hagi Approver" := nextApprover;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                        begin
                            PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                            PurchHeader."Hagi Approver" := nextApprover;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                        begin
                            PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                            PurchHeader."Hagi Approver" := nextApprover;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Transfer Order":
                        begin
                            TransHeader.get(pDataNo);
                            TransHeader."Hagi Approver" := nextApprover;
                            TransHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Assembly Order":
                        begin
                            AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                            AssemblyHeader."Hagi Approver" := nextApprover;
                            AssemblyHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Item Journal",
                    Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                        begin
                            ItemJourLine.Reset();
                            ItemJourLine.setRange("Document No.", pDataNo);
                            if ItemJourLine.FindSet() then
                                repeat
                                    ItemJourLine."Hagi Approver" := nextApprover;
                                    ItemJourLine.Modify();
                                until ItemJourLine.Next() = 0;
                        end;
                    Enum::"Hagiwara Approval Data"::"Item":
                        begin
                            ItemImportBatch.get(pDataNo);
                            ItemImportBatch."Hagi Approver" := nextApprover;
                            ItemImportBatch.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::Customer:
                        begin
                            Cust.get(pDataNo);
                            Cust."Hagi Approver" := nextApprover;
                            Cust.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::Vendor:
                        begin
                            Vend.get(pDataNo);
                            Vend."Hagi Approver" := nextApprover;
                            Vend.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"G/L Account":
                        begin
                            GLAccount.get(pDataNo);
                            GLAccount."Hagi Approver" := nextApprover;
                            GLAccount.Modify();
                        end;
                end;

            end else begin
                //if no next approver, change the status of the data to Approved.
                case pData of
                    Enum::"Hagiwara Approval Data"::"Sales Order",
                    Enum::"Hagiwara Approval Data"::"Sales Credit Memo",
                    Enum::"Hagiwara Approval Data"::"Sales Return Order":
                        begin
                            if pData = Enum::"Hagiwara Approval Data"::"Sales Order" then begin
                                SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                            end else if pData = Enum::"Hagiwara Approval Data"::"Sales Credit Memo" then begin
                                SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                            end else if pData = Enum::"Hagiwara Approval Data"::"Sales Return Order" then begin
                                SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                            end;

                            if SalesHeader."Approval Status" = Enum::"Hagiwara Approval Status"::"Re-Submitted" then begin
                                SalesHeader.InApproving := true; //make quantity and unit price possible to modify during aprrove process.
                                SalesHeader.Modify();

                                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetRange("Document No.", pDataNo);
                                if SalesLine.FindSet() then
                                    repeat
                                        SalesLineUpdated := false;
                                        if SalesLine.Quantity <> SalesLine."Quantity to Update" then begin
                                            SalesLine.Validate(Quantity, SalesLine."Quantity to Update");
                                            SalesLineUpdated := true;
                                        end;
                                        if SalesLine."Unit Price" <> SalesLine."Unit Price to Update" then begin
                                            SalesLine.Validate("Unit Price", SalesLine."Unit Price to Update");
                                            SalesLineUpdated := true;
                                        end;
                                        if SalesLineUpdated then begin
                                            SalesLine.Modify(true);
                                        end;
                                    until SalesLine.next() = 0;
                                SalesHeader.InApproving := false;
                            end;

                            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            SalesHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Purchase Order",
                    Enum::"Hagiwara Approval Data"::"Purchase Credit Memo",
                    Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                        begin
                            if pData = Enum::"Hagiwara Approval Data"::"Purchase Order" then begin
                                PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                            end else if pData = Enum::"Hagiwara Approval Data"::"Purchase Credit Memo" then begin
                                PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                            end else if pData = Enum::"Hagiwara Approval Data"::"Purchase Return Order" then begin
                                PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                            end;

                            if PurchHeader."Approval Status" = Enum::"Hagiwara Approval Status"::"Re-Submitted" then begin
                                PurchHeader.InApproving := true; //make quantity and unit price possible to modify during aprrove process.
                                PurchHeader.Modify();

                                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                                PurchLine.SetRange("Document No.", pDataNo);
                                if PurchLine.FindSet() then
                                    repeat
                                        PurchLineUpdated := false;
                                        if PurchLine.Quantity <> PurchLine."Quantity to Update" then begin
                                            PurchLine.Validate(Quantity, PurchLine."Quantity to Update");
                                            PurchLineUpdated := true;
                                        end;
                                        if PurchLine."Direct Unit Cost" <> PurchLine."Unit Cost to Update" then begin
                                            PurchLine.Validate("Direct Unit Cost", PurchLine."Unit Cost to Update");
                                            PurchLineUpdated := true;
                                        end;
                                        if PurchLineUpdated then begin
                                            PurchLine.Modify(true);
                                        end;
                                    until PurchLine.next() = 0;
                                PurchHeader.InApproving := false;
                            end;

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
                    Enum::"Hagiwara Approval Data"::Customer:
                        begin
                            Cust.get(pDataNo);
                            Cust."Approval Status" := "Hagiwara Approval Status"::Approved;
                            Cust.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::Vendor:
                        begin
                            Vend.get(pDataNo);
                            Vend."Approval Status" := "Hagiwara Approval Status"::Approved;
                            Vend.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"G/L Account":
                        begin
                            GLAccount.get(pDataNo);
                            GLAccount."Approval Status" := "Hagiwara Approval Status"::Approved;
                            GLAccount.Modify();
                        end;
                end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, recApprEntry.Requester, nextApprover, EmailType::Approval, recApprEntry);

            Message('Approval Request approved.\\The following approval request was sent if the furthermore approval is necessary.');
        end;
    end;

    procedure Reject(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20];
                                pUsername: Code[50])
    var
        recApprEntry: Record "Hagiwara Approval Entry";
        pagComment: page "Hagiwara Approval Comment";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
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
                Enum::"Hagiwara Approval Data"::Customer:
                    begin
                        Cust.get(pDataNo);
                        Cust."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        Cust."Hagi Approver" := pUsername;
                        Cust.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Vendor:
                    begin
                        Vend.get(pDataNo);
                        Vend."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        Vend."Hagi Approver" := pUsername;
                        Vend.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"G/L Account":
                    begin
                        GLAccount.get(pDataNo);
                        GLAccount."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        GLAccount."Hagi Approver" := pUsername;
                        GLAccount.Modify();
                    end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, recApprEntry.Requester, '', EmailType::Reject, recApprEntry);

            Message('Approval Request rejected.');
        end;
    end;

    procedure GetSubmitStatus(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]): Enum "Hagiwara Approval Status"
    var
        recApprEntry: Record "Hagiwara Approval Entry";
    begin

        recApprEntry.SetRange(Open, false);
        recApprEntry.SetRange(Data, pData);
        recApprEntry.SetRange("No.", pDataNo);
        recApprEntry.SetRange(Status, Enum::"Hagiwara Approval Status"::Approved);
        if not recApprEntry.IsEmpty() then
            exit(Enum::"Hagiwara Approval Status"::"Re-Submitted");

        exit(Enum::"Hagiwara Approval Status"::"Submitted");

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
                exit('&page=21&filter=''Customer''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::Vendor:
                exit('&page=26&filter=''Vendor''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::Item:
                exit('&page=50117&filter=''Item Import Batch''.''Name'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"G/L Account":
                exit('&page=17&filter=''G/L Account''.''No.'' is ''' + pDataNo + '''');
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

    local procedure GetSubstitution(pApprover: Code[50]): Code[50]
    var
        recApprSubst: Record "Hagiwara Approval Substitution";
    begin

        recApprSubst.SetCurrentKey("Approver User Name", "Start Date");
        recApprSubst.Ascending(false);
        recApprSubst.SetRange("Approver User Name", pApprover);
        recApprSubst.SetFilter("Start Date", '..%1', WorkDate());
        recApprSubst.SetFilter("End Date", '%1..|%2', WorkDate(), 0D);
        if recApprSubst.FindFirst() then begin
            exit(recApprSubst."Substitution User Name");
        end;

        exit(pApprover);
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
