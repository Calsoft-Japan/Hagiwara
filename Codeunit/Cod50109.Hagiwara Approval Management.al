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
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
        ReqGroup: Code[30];
        ApprGroup: Code[30];
        AmountLCY: Decimal;
        PriceMargin: Decimal;
        Approver: Code[50];
        MsgComment: Text;
        LinkText: Text;
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
            Enum::"Hagiwara Approval Data"::"Item Journal",
            Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                begin
                    AmountLCY := CalcItemJournalAmountLCY(pData, pDataNo);
                end;
            Enum::"Hagiwara Approval Data"::"Price List":
                begin
                    PriceMargin := GetPriceMargin(pData, pDataNo);
                end;

        end;

        recApprCondition.SetRange(Data, pData);
        recApprCondition.SetRange("Request Group Code", reqGroup);
        recApprCondition.SetFilter("Start Date", '..%1', WorkDate());
        recApprCondition.SetFilter("End Date", '%1|%2..', 0D, WorkDate());
        if pData = Enum::"Hagiwara Approval Data"::"Price List" then begin
            recApprCondition.SetFilter("Margin %", '%1|<=%2', 0, PriceMargin);
        end else begin
            recApprCondition.SetFilter("Amount (LCY)", '%1|<=%2', 0, AmountLCY);
        end;

        if not recApprCondition.FindLast() then
            error('Hagiwara Approval Condition seems not setup right.');

        ApprGroup := recApprCondition."Approval Group Code";

        recApprHrcy.SetRange("Approval Group Code", ApprGroup);
        if not recApprHrcy.FindFirst() then
            error('Hagiwara Approval Hierarchy seems not setup right.');

        Approver := recApprHrcy."Approver User Name";
        Approver := GetSubstitution(Approver);

        pagComment.SetData(pData, pDataNo);
        pagComment.ShowLink(true);
        if pagComment.RunModal() = Action::OK then begin

            SubmitStatus := GetSubmitStatus(pData, pDataNo);

            MsgComment := pagComment.GetComment();
            LinkText := pagComment.GetLink();
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
                MsgComment,
                LinkText
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
                Enum::"Hagiwara Approval Data"::"Assembly Order":
                    begin
                        AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                        AssemblyHeader."Approval Status" := SubmitStatus;
                        AssemblyHeader.Requester := UserId;
                        AssemblyHeader."Hagi Approver" := Approver;
                        AssemblyHeader.Modify();
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
                        /*
                        Cust.get(pDataNo);
                        Cust."Approval Status" := SubmitStatus;
                        Cust.Requester := UserId;
                        Cust."Hagi Approver" := Approver;
                        Cust.Modify();
                        */

                        CustImportBatch.get(pDataNo);
                        CustImportBatch."Approval Status" := SubmitStatus;
                        CustImportBatch.Requester := UserId;
                        CustImportBatch."Hagi Approver" := Approver;
                        CustImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Vendor:
                    begin
                        /*
                        Vend.get(pDataNo);
                        Vend."Approval Status" := SubmitStatus;
                        Vend.Requester := UserId;
                        Vend."Hagi Approver" := Approver;
                        Vend.Modify();
                        */

                        VendImportBatch.get(pDataNo);
                        VendImportBatch."Approval Status" := SubmitStatus;
                        VendImportBatch.Requester := UserId;
                        VendImportBatch."Hagi Approver" := Approver;
                        VendImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"G/L Account":
                    begin
                        GLAccount.get(pDataNo);
                        GLAccount."Approval Status" := SubmitStatus;
                        GLAccount.Requester := UserId;
                        GLAccount."Hagi Approver" := Approver;
                        GLAccount.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Price List":
                    begin
                        /*
                        PriceListHeader.get(pDataNo);
                        PriceListHeader."Approval Status" := SubmitStatus;
                        PriceListHeader.Requester := UserId;
                        PriceListHeader."Hagi Approver" := Approver;
                        PriceListHeader.Modify();
                        */

                        PriceListImportBatch.get(pDataNo);
                        PriceListImportBatch."Approval Status" := SubmitStatus;
                        PriceListImportBatch.Requester := UserId;
                        PriceListImportBatch."Hagi Approver" := Approver;
                        PriceListImportBatch.Modify();
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
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
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
            MsgComment := 'Requester (' + recApprEntry.Requester + '):' + TypeHelper.LFSeparator() + MsgComment + TypeHelper.LFSeparator();

            // update approval entry data.
            recApprEntry.Status := Enum::"Hagiwara Approval Status"::Cancelled;
            recApprEntry.Open := false;
            recApprEntry."Close Date" := CurrentDateTime;
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
                        /*
                        Cust.get(pDataNo);
                        Cust."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        Cust.Requester := '';
                        Cust."Hagi Approver" := '';
                        Cust.Modify();
                        */
                        CustImportBatch.get(pDataNo);
                        CustImportBatch."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        CustImportBatch.Requester := '';
                        CustImportBatch."Hagi Approver" := '';
                        CustImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Vendor:
                    begin
                        /*
                        Vend.get(pDataNo);
                        Vend."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        Vend.Requester := '';
                        Vend."Hagi Approver" := '';
                        Vend.Modify();
                        */

                        VendImportBatch.get(pDataNo);
                        VendImportBatch."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        VendImportBatch.Requester := '';
                        VendImportBatch."Hagi Approver" := '';
                        VendImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"G/L Account":
                    begin
                        GLAccount.get(pDataNo);
                        GLAccount."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        GLAccount.Requester := '';
                        GLAccount."Hagi Approver" := '';
                        GLAccount.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Price List":
                    begin
                        /*
                        PriceListHeader.get(pDataNo);
                        PriceListHeader."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        PriceListHeader.Requester := '';
                        PriceListHeader."Hagi Approver" := '';
                        PriceListHeader.Modify();
                        */

                        PriceListImportBatch.get(pDataNo);
                        PriceListImportBatch."Approval Status" := "Hagiwara Approval Status"::Cancelled;
                        PriceListImportBatch.Requester := '';
                        PriceListImportBatch."Hagi Approver" := '';
                        PriceListImportBatch.Modify();
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
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        AssemLine: Record "Assembly Line";
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

            recApprEntry.AddComment(MsgComment);

            // ask approvel for next approver.
            recApprHrcy.SetRange("Approval Group Code", recApprEntry."Approval Group");
            recApprHrcy.SetFilter("Sequence No.", '>%1', recApprEntry."Approval Sequence No.");
            if recApprHrcy.FindFirst() then begin
                // if next approver exists.

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
                    recApprEntry.GetComment(),
                    recApprEntry.Link
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
                            /*
                            Cust.get(pDataNo);
                            Cust."Hagi Approver" := nextApprover;
                            Cust.Modify();
                            */

                            CustImportBatch.get(pDataNo);
                            CustImportBatch."Hagi Approver" := nextApprover;
                            CustImportBatch.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::Vendor:
                        begin
                            /*
                            Vend.get(pDataNo);
                            Vend."Hagi Approver" := nextApprover;
                            Vend.Modify();
                            */

                            VendImportBatch.get(pDataNo);
                            VendImportBatch."Hagi Approver" := nextApprover;
                            VendImportBatch.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"G/L Account":
                        begin
                            GLAccount.get(pDataNo);
                            GLAccount."Hagi Approver" := nextApprover;
                            GLAccount.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Price List":
                        begin
                            /*
                            PriceListHeader.get(pDataNo);
                            PriceListHeader."Hagi Approver" := nextApprover;
                            PriceListHeader.Modify();
                            */

                            PriceListImportBatch.get(pDataNo);
                            PriceListImportBatch."Hagi Approver" := nextApprover;
                            PriceListImportBatch.Modify();
                        end;
                end;

            end else begin
                //if final approver, change the status of the data to Approved, and count "Approval Cycle No.".
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

                            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                            SalesLine.SetRange("Document No.", pDataNo);
                            if SalesLine.FindSet() then
                                repeat
                                    if SalesLine."Approved Quantity" <> SalesLine.Quantity then begin
                                        SalesLine."Approved Quantity" := SalesLine.Quantity;
                                    end;
                                    if SalesLine."Approved Unit Price" <> SalesLine."Unit Price" then begin
                                        SalesLine."Approved Unit Price" := SalesLine."Unit Price";
                                    end;

                                    SalesLine."Approval History Exists" := true;
                                    SalesLine.Modify();
                                until SalesLine.next() = 0;

                            SalesHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            SalesHeader."Approval Cycle No." += 1;
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

                            PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                            PurchLine.SetRange("Document No.", pDataNo);
                            if PurchLine.FindSet() then
                                repeat
                                    if PurchLine."Approved Quantity" <> PurchLine.Quantity then begin
                                        PurchLine."Approved Quantity" := PurchLine.Quantity;
                                    end;
                                    if PurchLine."Approved Unit Cost" <> PurchLine."Unit Cost" then begin
                                        PurchLine."Approved Unit Cost" := PurchLine."Unit Cost";
                                    end;

                                    PurchLine."Approval History Exists" := true;
                                    PurchLine.Modify();
                                until PurchLine.next() = 0;

                            PurchHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            PurchHeader."Approval Cycle No." += 1;
                            PurchHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Transfer Order":
                        begin
                            TransHeader.get(pDataNo);

                            TransLine.SetRange("Document No.", pDataNo);
                            if TransLine.FindSet() then
                                repeat
                                    if TransLine."Approved Quantity" <> TransLine.Quantity then begin
                                        TransLine."Approved Quantity" := TransLine.Quantity;
                                    end;

                                    TransLine."Approval History Exists" := true;
                                    TransLine.Modify();
                                until TransLine.next() = 0;

                            TransHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            TransHeader."Approval Cycle No." += 1;
                            TransHeader.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Assembly Order":
                        begin
                            AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);

                            AssemLine.SetRange("Document Type", AssemblyHeader."Document Type");
                            AssemLine.SetRange("Document No.", pDataNo);
                            if AssemLine.FindSet() then
                                repeat
                                    if AssemLine."Approved Quantity" <> AssemLine.Quantity then begin
                                        AssemLine."Approved Quantity" := AssemLine.Quantity;
                                    end;

                                    AssemLine."Approval History Exists" := true;
                                    AssemLine.Modify();
                                until AssemLine.next() = 0;

                            AssemblyHeader."Approval Status" := "Hagiwara Approval Status"::"Approved";
                            AssemblyHeader."Approval Cycle No." += 1;
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
                            /*
                            Cust.get(pDataNo);
                            Cust."Approval Status" := "Hagiwara Approval Status"::Approved;
                            Cust.Modify();
                            */

                            CustImportBatch.get(pDataNo);
                            CustImportBatch."Approval Status" := "Hagiwara Approval Status"::Approved;
                            CustImportBatch.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::Vendor:
                        begin
                            /*
                            Vend.get(pDataNo);
                            Vend."Approval Status" := "Hagiwara Approval Status"::Approved;
                            Vend.Modify();
                            */

                            VendImportBatch.get(pDataNo);
                            VendImportBatch."Approval Status" := "Hagiwara Approval Status"::Approved;
                            VendImportBatch.Modify();

                        end;
                    Enum::"Hagiwara Approval Data"::"G/L Account":
                        begin
                            GLAccount.get(pDataNo);
                            GLAccount."Approval Status" := "Hagiwara Approval Status"::Approved;
                            GLAccount.Blocked := false;
                            GLAccount.Modify();
                        end;
                    Enum::"Hagiwara Approval Data"::"Price List":
                        begin
                            /*
                            PriceListHeader.get(pDataNo);
                            PriceListHeader.Status := PriceListHeader.Status::Active;
                            PriceListHeader."Approval Status" := "Hagiwara Approval Status"::Approved;
                            PriceListHeader.Modify();
                            */

                            PriceListImportBatch.get(pDataNo);
                            PriceListImportBatch."Approval Status" := "Hagiwara Approval Status"::Approved;
                            PriceListImportBatch.Modify();

                        end;
                end;
            end;

            // update the current approval entry data.
            recApprEntry.Status := Enum::"Hagiwara Approval Status"::Approved;
            recApprEntry.Open := false;
            recApprEntry."Close Date" := CurrentDateTime;
            recApprEntry.Modify();

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
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
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
            recApprEntry."Close Date" := CurrentDateTime;
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
                        /*
                        Cust.get(pDataNo);
                        Cust."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        Cust."Hagi Approver" := pUsername;
                        Cust.Modify();
                        */

                        CustImportBatch.get(pDataNo);
                        CustImportBatch."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        CustImportBatch."Hagi Approver" := pUsername;
                        CustImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::Vendor:
                    begin
                        /*
                        Vend.get(pDataNo);
                        Vend."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        Vend."Hagi Approver" := pUsername;
                        Vend.Modify();
                        */

                        VendImportBatch.get(pDataNo);
                        VendImportBatch."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        VendImportBatch."Hagi Approver" := pUsername;
                        VendImportBatch.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"G/L Account":
                    begin
                        GLAccount.get(pDataNo);
                        GLAccount."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        GLAccount."Hagi Approver" := pUsername;
                        GLAccount.Modify();
                    end;
                Enum::"Hagiwara Approval Data"::"Price List":
                    begin
                        /*
                        PriceListHeader.get(pDataNo);
                        PriceListHeader."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        PriceListHeader."Hagi Approver" := pUsername;
                        PriceListHeader.Modify();
                        */

                        PriceListImportBatch.get(pDataNo);
                        PriceListImportBatch."Approval Status" := "Hagiwara Approval Status"::Rejected;
                        PriceListImportBatch."Hagi Approver" := pUsername;
                        PriceListImportBatch.Modify();
                    end;
            end;

            SendNotificationEmail(pData, pDataNo, pUsername, recApprEntry.Requester, '', EmailType::Reject, recApprEntry);

            Message('Approval Request rejected.');
        end;
    end;

    procedure Update(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20];
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
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        MsgComment: Text;
    begin

        // update transaction data.
        case pData of
            Enum::"Hagiwara Approval Data"::"Sales Order":
                begin
                    SalesHeader.get(SalesHeader."Document Type"::Order, pDataNo);
                    SalesHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    SalesHeader.Requester := '';
                    SalesHeader."Hagi Approver" := '';
                    SalesHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                begin
                    SalesHeader.get(SalesHeader."Document Type"::"Credit Memo", pDataNo);
                    SalesHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    SalesHeader."Hagi Approver" := '';
                    SalesHeader.Requester := '';
                    SalesHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Sales Return Order":
                begin
                    SalesHeader.get(SalesHeader."Document Type"::"Return Order", pDataNo);
                    SalesHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    SalesHeader."Hagi Approver" := '';
                    SalesHeader.Requester := '';
                    SalesHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Order":
                begin
                    PurchHeader.get(PurchHeader."Document Type"::Order, pDataNo);
                    PurchHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    PurchHeader."Hagi Approver" := '';
                    PurchHeader.Requester := '';
                    PurchHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                begin
                    PurchHeader.get(PurchHeader."Document Type"::"Credit Memo", pDataNo);
                    PurchHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    PurchHeader."Hagi Approver" := '';
                    PurchHeader.Requester := '';
                    PurchHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                begin
                    PurchHeader.get(PurchHeader."Document Type"::"Return Order", pDataNo);
                    PurchHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    PurchHeader."Hagi Approver" := '';
                    PurchHeader.Requester := '';
                    PurchHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Transfer Order":
                begin
                    TransHeader.get(pDataNo);
                    TransHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    TransHeader."Hagi Approver" := '';
                    TransHeader.Requester := '';
                    TransHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Assembly Order":
                begin
                    AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);
                    AssemblyHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    AssemblyHeader."Hagi Approver" := '';
                    AssemblyHeader.Requester := '';
                    AssemblyHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Item Journal",
            Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                begin
                    ItemJourLine.Reset();
                    ItemJourLine.setRange("Document No.", pDataNo);
                    if ItemJourLine.FindSet() then
                        repeat
                            ItemJourLine."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                            ItemJourLine."Hagi Approver" := '';
                            ItemJourLine.Requester := '';
                            ItemJourLine.Modify();
                        until ItemJourLine.Next() = 0;
                end;
            Enum::"Hagiwara Approval Data"::"Item":
                begin
                    ItemImportBatch.get(pDataNo);
                    ItemImportBatch."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    ItemImportBatch."Hagi Approver" := '';
                    ItemImportBatch.Requester := '';
                    ItemImportBatch.Modify();
                end;
            Enum::"Hagiwara Approval Data"::Customer:
                begin
                    /*
                    Cust.get(pDataNo);
                    Cust."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    Cust."Hagi Approver" := '';
                    Cust.Requester := '';
                    Cust.Modify();
                    */

                    CustImportBatch.get(pDataNo);
                    CustImportBatch."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    CustImportBatch."Hagi Approver" := '';
                    CustImportBatch.Requester := '';
                    CustImportBatch.Modify();
                end;
            Enum::"Hagiwara Approval Data"::Vendor:
                begin
                    /*
                    Vend.get(pDataNo);
                    Vend."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    Vend."Hagi Approver" := '';
                    Vend.Requester := '';
                    Vend.Modify();
                    */

                    VendImportBatch.get(pDataNo);
                    VendImportBatch."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    VendImportBatch."Hagi Approver" := '';
                    VendImportBatch.Requester := '';
                    VendImportBatch.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"G/L Account":
                begin
                    GLAccount.get(pDataNo);
                    GLAccount."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    GLAccount."Hagi Approver" := '';
                    GLAccount.Requester := '';
                    GLAccount.Blocked := true;
                    GLAccount.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Price List":
                begin
                    /*
                    PriceListHeader.get(pDataNo);
                    PriceListHeader."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    PriceListHeader."Hagi Approver" := '';
                    PriceListHeader.Requester := '';
                    PriceListHeader.Modify();
                    */

                    PriceListImportBatch.get(pDataNo);
                    PriceListImportBatch."Approval Status" := "Hagiwara Approval Status"::"Re-Approval Required";
                    PriceListImportBatch."Hagi Approver" := '';
                    PriceListImportBatch.Requester := '';
                    PriceListImportBatch.Modify();
                end;
        end;
    end;

    procedure ShowDoc(pApprEntry: Record "Hagiwara Approval Entry")
    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        TransHeader: Record "Transfer Header";
        AssemblyHeader: Record "Assembly Header";
        ItemJourLine: Record "Item journal Line";
        ItemImportBatch: Record "Item Import Batch";
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        MsgDocNotFound: Text;
        DocFound: Boolean;
    begin
        DocFound := false;
        MsgDocNotFound := 'The document is not found.';
        case pApprEntry.Data of
            Enum::"Hagiwara Approval Data"::"Sales Order":
                begin
                    if SalesHeader.Get(SalesHeader."Document Type"::Order, pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Sales Order", SalesHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Sales Credit Memo":
                begin
                    if SalesHeader.Get(SalesHeader."Document Type"::"Credit Memo", pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Sales Credit Memo", SalesHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Sales Return Order":
                begin
                    if SalesHeader.Get(SalesHeader."Document Type"::"Return Order", pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Sales Return Order", SalesHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Order":
                begin
                    if PurchHeader.Get(PurchHeader."Document Type"::Order, pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Purchase Order", PurchHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Credit Memo":
                begin
                    if PurchHeader.Get(PurchHeader."Document Type"::"Credit Memo", pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Purchase Credit Memo", PurchHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Purchase Return Order":
                begin
                    if PurchHeader.Get(PurchHeader."Document Type"::"Return Order", pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Purchase Return Order", PurchHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Transfer Order":
                begin
                    if TransHeader.Get(pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Transfer Order", TransHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Assembly Order":
                begin
                    if AssemblyHeader.Get(AssemblyHeader."Document Type"::Order, pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Assembly Order", AssemblyHeader);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Item Journal":
                begin
                    ItemJourLine.SetRange("Document No.", pApprEntry."No.");
                    if not ItemJourLine.IsEmpty() then begin
                        DocFound := true;
                        Page.RunModal(Page::"Item Journal", ItemJourLine);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                begin
                    ItemJourLine.SetRange("Document No.", pApprEntry."No.");
                    if not ItemJourLine.IsEmpty() then begin
                        DocFound := true;
                        Page.RunModal(Page::"Item Reclass. Journal", ItemJourLine);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Item":
                begin
                    if ItemImportBatch.Get(pApprEntry."No.") then begin
                        ItemImportBatch.SetRecFilter();
                        DocFound := true;
                        Page.RunModal(Page::"Item Import Batch", ItemImportBatch);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::Customer:
                begin
                    /*
                    if Cust.Get(pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Customer Card", Cust);
                    end;
                    */

                    if CustImportBatch.Get(pApprEntry."No.") then begin
                        CustImportBatch.SetRecFilter();
                        DocFound := true;
                        Page.RunModal(Page::"Customer Import Batches", CustImportBatch);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::Vendor:
                begin
                    /*
                    if Vend.Get(pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"Vendor Card", Vend);
                    end;
                    */

                    if VendImportBatch.Get(pApprEntry."No.") then begin
                        VendImportBatch.SetRecFilter();
                        DocFound := true;
                        Page.RunModal(Page::"Vendor Import Batches", VendImportBatch);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"G/L Account":
                begin
                    if GLAccount.Get(pApprEntry."No.") then begin
                        DocFound := true;
                        Page.RunModal(Page::"G/L Account Card", GLAccount);
                    end;
                end;
            Enum::"Hagiwara Approval Data"::"Price List":
                begin
                    /*
                    if PriceListHeader.Get(pApprEntry."No.") then begin
                        if PriceListHeader."Price Type" = PriceListHeader."Price Type"::Sale then begin
                            DocFound := true;
                            Page.RunModal(Page::"Sales Price List", PriceListHeader);
                        end else if PriceListHeader."Price Type" = PriceListHeader."Price Type"::Purchase then begin
                            DocFound := true;
                            Page.RunModal(Page::"Purchase Price List", PriceListHeader);
                        end else begin
                            //no this case.
                        end;
                    end;
                    */

                    if PriceListImportBatch.Get(pApprEntry."No.") then begin
                        PriceListImportBatch.SetRecFilter();
                        DocFound := true;
                        Page.RunModal(Page::"Price List Import Batches", PriceListImportBatch);
                    end;
                end;
        end;

        if not DocFound then begin
            Message(MsgDocNotFound);
        end;

    end;

    procedure AutoApprove(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]; pUsername: Code[50])
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
        CustImportBatch: Record "Customer Import Batch";
        VendImportBatch: Record "Vendor Import Batch";
        PriceListImportBatch: Record "Price List Import Batch";
        PriceListHeader: Record "Price List Header";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAccount: Record "G/L Account";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        AssemLine: Record "Assembly Line";
        nextApprover: Code[50];
        MsgComment: Text;
    begin

        recApprEntry := InsertApprEntry(
            pData,
            pDataNo,
            '', //Requester,
            '', //"Request Group",
            '', //Approver,
            '', //"Approval Group",
            0,  //recApprHrcy."Sequence No.",
            recApprEntry.Status::"Auto Approved",
            'System Auto Approved.', //recApprEntry.GetComment()
            '' //Link
        );

        recApprEntry.Open := false;
        recApprEntry."Close Date" := CurrentDateTime;
        recApprEntry.Modify();

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

                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", pDataNo);
                    if SalesLine.FindSet() then
                        repeat
                            if SalesLine."Approved Quantity" <> SalesLine.Quantity then begin
                                SalesLine."Approved Quantity" := SalesLine.Quantity;
                            end;
                            if SalesLine."Approved Unit Price" <> SalesLine."Unit Price" then begin
                                SalesLine."Approved Unit Price" := SalesLine."Unit Price";
                            end;

                            SalesLine."Approval History Exists" := true;
                            SalesLine.Modify();
                        until SalesLine.next() = 0;

                    SalesHeader."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    SalesHeader."Approval Cycle No." += 1;
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

                    PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine.SetRange("Document No.", pDataNo);
                    if PurchLine.FindSet() then
                        repeat
                            if PurchLine."Approved Quantity" <> PurchLine.Quantity then begin
                                PurchLine."Approved Quantity" := PurchLine.Quantity;
                            end;
                            if PurchLine."Approved Unit Cost" <> PurchLine."Unit Cost" then begin
                                PurchLine."Approved Unit Cost" := PurchLine."Unit Cost";
                            end;

                            PurchLine."Approval History Exists" := true;
                            PurchLine.Modify();
                        until PurchLine.next() = 0;

                    PurchHeader."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    PurchHeader."Approval Cycle No." += 1;
                    PurchHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Transfer Order":
                begin
                    TransHeader.get(pDataNo);

                    TransLine.SetRange("Document No.", pDataNo);
                    if TransLine.FindSet() then
                        repeat
                            if TransLine."Approved Quantity" <> TransLine.Quantity then begin
                                TransLine."Approved Quantity" := TransLine.Quantity;
                            end;

                            TransLine."Approval History Exists" := true;
                            TransLine.Modify();
                        until TransLine.next() = 0;

                    TransHeader."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    TransHeader."Approval Cycle No." += 1;
                    TransHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Assembly Order":
                begin
                    AssemblyHeader.get(AssemblyHeader."Document Type"::Order, pDataNo);

                    AssemLine.SetRange("Document Type", AssemblyHeader."Document Type");
                    AssemLine.SetRange("Document No.", pDataNo);
                    if AssemLine.FindSet() then
                        repeat
                            if AssemLine."Approved Quantity" <> AssemLine.Quantity then begin
                                AssemLine."Approved Quantity" := AssemLine.Quantity;
                            end;

                            AssemLine."Approval History Exists" := true;
                            AssemLine.Modify();
                        until AssemLine.next() = 0;

                    AssemblyHeader."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    AssemblyHeader."Approval Cycle No." += 1;
                    AssemblyHeader.Modify();
                end;
            Enum::"Hagiwara Approval Data"::"Item Journal",
            Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                begin
                    ItemJourLine.Reset();
                    ItemJourLine.setRange("Document No.", pDataNo);
                    if ItemJourLine.FindSet() then
                        repeat
                            ItemJourLine."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                            ItemJourLine.Modify();
                        until ItemJourLine.Next() = 0;
                end;
            Enum::"Hagiwara Approval Data"::"Item":
                begin
                    ItemImportBatch.get(pDataNo);
                    ItemImportBatch."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    ItemImportBatch.Modify();

                end;
            Enum::"Hagiwara Approval Data"::Customer:
                begin
                    CustImportBatch.get(pDataNo);
                    CustImportBatch."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    CustImportBatch.Modify();

                end;
            Enum::"Hagiwara Approval Data"::Vendor:
                begin
                    VendImportBatch.get(pDataNo);
                    VendImportBatch."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    VendImportBatch.Modify();

                end;
            Enum::"Hagiwara Approval Data"::"G/L Account":
                begin
                    GLAccount.get(pDataNo);
                    GLAccount."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    GLAccount.Modify();

                end;
            Enum::"Hagiwara Approval Data"::"Price List":
                begin
                    /*
                    PriceListHeader.get(pDataNo);
                    PriceListHeader.Status := PriceListHeader.Status::Active;
                    PriceListHeader."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    PriceListHeader.Modify();
                    */

                    PriceListImportBatch.get(pDataNo);
                    PriceListImportBatch."Approval Status" := "Hagiwara Approval Status"::"Auto Approved";
                    PriceListImportBatch.Modify();

                end;
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
                   pComment: Text;
                   pLink: Text
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
        recApprEntry."Request Date" := CurrentDateTime;
        recApprEntry.Status := pStatus;
        recApprEntry.Open := true;
        recApprEntry.Link := pLink;

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

    local procedure CalcItemJournalAmountLCY(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]): Decimal
    var
        ItemJourLine: Record "Item journal Line";
        CurrencyLocal: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RateDate: Date;
        rtnAmountLCY: Decimal;
    begin
        case pData of
            Enum::"Hagiwara Approval Data"::"Item Journal",
            Enum::"Hagiwara Approval Data"::"Item Reclass Journal":
                begin
                    ItemJourLine.SetRange("Document No.", pDataNo);
                    ItemJourLine.CalcSums(Amount, "Discount Amount");

                    rtnAmountLCY := ItemJourLine.Amount - ItemJourLine."Discount Amount";
                end;
        end;

        exit(rtnAmountLCY);
    end;

    local procedure GetPriceMargin(pData: Enum "Hagiwara Approval Data"; pDataNo: Code[20]): Decimal
    var
        /*
        recPriceHeader: Record "Price List Header";
        recSalesPrice: Record "Price List Line";
        recPurchPrice: Record "Price List Line";
        */
        PriceListImportline: Record "Price List Import Line";
        rtnMargin: Decimal;
    begin
        /*
        recPriceHeader.get(pDataNo);
        if recPriceHeader."Price Type" = recPriceHeader."Price Type"::Sale then begin
            recSalesPrice.SetRange("Price List Code", pDataNo);
            if recSalesPrice.FindSet() then
                repeat
                    recPurchPrice.Reset();
                    recPurchPrice.SetRange("Price Type", recPurchPrice."Price Type"::Purchase);
                    recPurchPrice.SetRange("Product No.", recSalesPrice."Product No.");
                    recPurchPrice.SetFilter("Ending Date", '%1..|%2', recSalesPrice."Starting Date", 0D);
                    recPurchPrice.SetFilter("Starting Date", '..%1|%2', recSalesPrice."Ending Date", 0D);
                    if recPurchPrice.Count > 1 then begin
                        Error('Multiple valid purchase prices were found for Item No. %1', recSalesPrice."Product No.");
                    end else if recPurchPrice.Count = 1 then begin
                        if rtnMargin < (recPurchPrice."Direct Unit Cost" / recSalesPrice."Unit Price") then begin
                            rtnMargin := (recPurchPrice."Direct Unit Cost" / recSalesPrice."Unit Price");
                        end;
                    end;
                until recSalesPrice.Next() = 0;
        end else if recPriceHeader."Price Type" = recPriceHeader."Price Type"::Purchase then begin
            recPurchPrice.SetRange("Price List Code", pDataNo);
            if recPurchPrice.FindSet() then
                repeat
                    recSalesPrice.Reset();
                    recPurchPrice.SetRange("Price Type", recPurchPrice."Price Type"::Sale);
                    recSalesPrice.SetRange("Product No.", recPurchPrice."Product No.");
                    recSalesPrice.SetFilter("Ending Date", '%1..|%2', recPurchPrice."Starting Date", 0D);
                    recSalesPrice.SetFilter("Starting Date", '..%1|%2', recPurchPrice."Ending Date", 0D);
                    if recSalesPrice.Count > 1 then begin
                        Error('Multiple valid sales prices were found for Item No. %1', recPurchPrice."Product No.");
                    end else if recSalesPrice.Count = 1 then begin
                        if rtnMargin < (recPurchPrice."Direct Unit Cost" / recSalesPrice."Unit Price") then begin
                            rtnMargin := (recPurchPrice."Direct Unit Cost" / recSalesPrice."Unit Price");
                        end;
                    end;
                until recPurchPrice.Next() = 0;
        end else begin
            //no this case.
        end;
        */

        PriceListImportline.SetCurrentKey("Margin%");
        PriceListImportline.SetRange("Batch Name", pDataNo);
        if PriceListImportline.FindFirst() then begin
            rtnMargin := PriceListImportline."Margin%";
        end;

        exit(rtnMargin);
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
    var
        PriceListHeader: Record "Price List Header";
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
                //exit('&page=21&filter=''Customer''.''No.'' is ''' + pDataNo + '''');
                exit('&page=50119&filter=''Customer Import Batch''.''Name'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::Vendor:
                //exit('&page=26&filter=''Vendor''.''No.'' is ''' + pDataNo + '''');
                exit('&page=50113&filter=''Vendor Import Batch''.''Name'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::Item:
                exit('&page=50117&filter=''Item Import Batch''.''Name'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"G/L Account":
                exit('&page=17&filter=''G/L Account''.''No.'' is ''' + pDataNo + '''');
            Enum::"Hagiwara Approval Data"::"Price List":
                begin
                    /*
                    PriceListHeader.Get(pDataNo);
                    if PriceListHeader."Price Type" = PriceListHeader."Price Type"::Sale then begin
                        exit('&page=7016&filter=''Price List Header''.''Code'' is ''' + pDataNo + '''');
                    end else if PriceListHeader."Price Type" = PriceListHeader."Price Type"::Purchase then begin
                        exit('&page=7018&filter=''Price List Header''.''Code'' is ''' + pDataNo + '''');
                    end else begin
                        //no this case.
                        exit('');
                    end;
                    */
                    exit('&page=50106&filter=''Price List Import Batch''.''Name'' is ''' + pDataNo + '''');
                end;
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
        TempCuEmailAccount: record "Email Account" temporary;
        isSent: boolean;
        CuEmailMessage: codeunit "Email Message";
        CuEmail: codeunit Email;
        FromEmailAccount: Text;
    begin
        FromEmailAccount := 'Hagiwara Approval';
        EmailToList := EmailTo.Split(';');
        EmailCCList := EmailCC.Split(';');
        CuEmailMessage.Create(EmailToList, EmailSubject, EmailBody, true, EmailCCList, EmailBCCList);

        CuEmailAccount.GetAllAccounts(TempCuEmailAccount);
        TempCuEmailAccount.Reset;
        //TempCuEmailAccount.SetRange(Name, 'Current User');
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
