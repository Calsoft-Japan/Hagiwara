codeunit 50090 "Purch-Post Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostPurchaseDoc, '', false, false)]
    local procedure DoOnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)

    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N007 Begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            CheckICPost(PurchaseHeader);
        end;
        //N007 End

        //N005 Begin
        if PreviewMode then
            exit;

        recApprSetup.Get();
        if ((recApprSetup."Purchase Order") and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Return Order")
                ) then begin

            if not (PurchaseHeader."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                Error('It is not approved yet.');
            end;
        end;
        //N005 End

    end;

    local procedure CheckICPost(var pPurchHeader: Record "Purchase Header")
    var
        ICSetup: Record "IC Setup";
        ICPartner: Record "IC Partner";
        SC_HandledOutTran: Record "Handled IC Outbox Trans.";
        SC_Vend: Record Vendor;
        SC_PurchLine: Record "Purchase Line";

        PC_HandledInTran: Record "Handled IC Inbox Trans.";
        PC_SalesHeader: Record "Sales Header";
        PC_SalesLine: Record "Sales Line";
        PC_SalesShptHeader: Record "Sales Shipment Header";

        IC_Hagi: Boolean;
        CheckResult: Boolean;
        PC_Qty_Insufficient: Boolean;

    begin
        IC_Hagi := true; //Just in case if this function needs to be on/off.
        CheckResult := false;
        PC_Qty_Insufficient := false;

        if not IC_Hagi then
            exit;

        SC_Vend.Get(pPurchHeader."Buy-from Vendor No.");
        if SC_Vend."IC Partner Code" = '' then begin
            CheckResult := true;
        end else begin
            ICPartner.Get(SC_Vend."IC Partner Code");
            if pPurchHeader."IC Status" = pPurchHeader."IC Status"::Sent then begin
                PC_HandledInTran.ChangeCompany(ICPartner."Inbox Details");
                PC_SalesHeader.ChangeCompany(ICPartner."Inbox Details");
                PC_SalesLine.ChangeCompany(ICPartner."Inbox Details");
                PC_SalesShptHeader.ChangeCompany(ICPartner."Inbox Details");

                SC_HandledOutTran.Reset();
                SC_HandledOutTran.SetAscending("Transaction No.", false);
                SC_HandledOutTran.SetRange("Document No.", pPurchHeader."No.");
                SC_HandledOutTran.SetRange("IC Source Type", SC_HandledOutTran."IC Source Type"::"Purchase Document");
                SC_HandledOutTran.SetRange("Document Type", SC_HandledOutTran."Document Type"::Order);
                SC_HandledOutTran.SetRange(Status, SC_HandledOutTran.Status::"Sent to IC Partner");
                if SC_HandledOutTran.FindFirst() then begin
                    PC_HandledInTran.Reset();
                    PC_HandledInTran.SetRange("Transaction No.", SC_HandledOutTran."Transaction No.");
                    PC_HandledInTran.SetRange("Document No.", pPurchHeader."No.");
                    PC_HandledInTran.SetRange("IC Source Type", PC_HandledInTran."IC Source Type"::"Sales Document");
                    PC_HandledInTran.SetRange("Document Type", PC_HandledInTran."Document Type"::Order);
                    PC_HandledInTran.SetFilter(Status, '%1|%2', PC_HandledInTran.Status::Accepted, PC_HandledInTran.Status::Posted);
                    if PC_HandledInTran.FindFirst() then begin
                        PC_SalesHeader.SetRange("External Document No.", pPurchHeader."No.");
                        if PC_SalesHeader.FindFirst() then begin
                            SC_PurchLine.SetRange("Document Type", pPurchHeader."Document Type");
                            SC_PurchLine.SetRange("Document No.", pPurchHeader."No.");
                            SC_PurchLine.SetFilter("Qty. to Receive", '>%1', 0);
                            if SC_PurchLine.FindSet() then
                                repeat
                                    if PC_SalesLine.Get(PC_SalesHeader."Document Type", PC_SalesHeader."No.", SC_PurchLine."Line No.") then begin
                                        if PC_SalesLine."Quantity Shipped" < SC_PurchLine."Qty. to Receive" then begin
                                            PC_Qty_Insufficient := true;
                                            break;
                                        end;
                                    end else begin
                                        PC_Qty_Insufficient := true;
                                        break;
                                    end;
                                until SC_PurchLine.Next() = 0;

                            if not PC_Qty_Insufficient then begin
                                CheckResult := true;
                            end;
                        end else begin
                            //case of the whole Sales order was posted.
                            PC_SalesShptHeader.SetRange("External Document No.", pPurchHeader."No.");
                            if PC_SalesShptHeader.FindFirst() then begin
                                CheckResult := true;
                            end;
                        end;
                    end;
                end; //SC_HandledOutTran.FindFirst()
            end; //pPurchHeader."IC Status" = pPurchHeader."IC Status"::Sent
        end; //SC_Vend."IC Partner Code" = ''

        if not CheckResult then begin
            Error('IC Partner has not posted Ship. Posting Receipt is not allowed.');
        end;
    end;

}