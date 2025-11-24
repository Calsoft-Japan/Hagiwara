codeunit 50108 "Create Purchase Invoice"
{
    trigger OnRun()
    begin
        CreatePurchInvoice();
    end;

    local procedure CreatePurchInvoice()
    var
        Staging1: Record "Receipt Import Line";
        Staging2: Record "Receipt Import Line";
        PurchHeader: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchLine: Record "Purchase Line";
        NoSeries: Codeunit "No. Series";
        PurchGetReceipt: Codeunit "Purch.-Get Receipt";
        GroupKey: Integer;
    begin
        PurchSetup.get();
        PurchSetup.TestField("Invoice Nos.");

        Staging1.Reset();
        Staging1.SETFILTER(Status, '%1', Staging1.Status::Processed);
        if Staging1.FindSet() then
            repeat
                if GroupKey <> Staging1."Group Key" then begin

                    GroupKey := Staging1."Group Key";

                    //create purchaes header.
                    PurchHeader.Init();
                    PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
                    PurchHeader.Validate("No.", NoSeries.GetNextNo(PurchSetup."Invoice Nos."));
                    PurchHeader.Validate("Buy-from Vendor No.", Staging1."Vendor No.");
                    PurchHeader.Validate("Pay-to Vendor No.", Staging1."Vendor No.");
                    PurchHeader.Validate("Posting Date", Today);
                    PurchHeader.Status := PurchHeader.Status::Open;
                    PurchHeader.Insert(true);

                    Staging2.Reset();
                    Staging2.SetRange("Group Key", Staging1."Group Key");
                    if Staging2.FindSet() then
                        repeat
                            PurchRcptLine.SetRange("Buy-from Vendor No.", Staging2."Vendor No.");
                            if Staging2."CO No." = '' then begin
                                PurchRcptLine.SetRange("Document No.", Staging2."Purch. Rept. No.");
                                PurchRcptLine.SetRange("Line No.", Staging2."Line No.");
                            end else begin
                                PurchRcptLine.SetRange("CO No.", Staging2."CO No.");
                            end;
                            PurchRcptLine.SetRange("Customer Item No.", Staging2."Customer Item No.");
                            PurchRcptLine.SetRange(Description, Staging2."Item Description");
                            PurchRcptLine.SetRange("Currency Code", Staging2."Currency Code");
                            PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
                            PurchRcptLine.SetRange(Quantity, Staging2."Received Quantity");

                            if not PurchRcptLine.IsEmpty() then begin
                                clear(PurchGetReceipt);
                                PurchGetReceipt.SetPurchHeader(PurchHeader);
                                PurchGetReceipt.CreateInvLines(PurchRcptLine);

                                Staging2.Status := Staging2.Status::OK;
                                Staging2.Modify();
                            end;

                        until Staging2.Next() = 0;
                end;
            until Staging1.Next() = 0;


        Staging1.Reset();
        Staging1.SETFILTER(Status, '%1', Staging1.Status::OK);
        Staging1.DeleteAll();
    end;
}
