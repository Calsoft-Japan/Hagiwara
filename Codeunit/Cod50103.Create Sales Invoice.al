codeunit 50103 "Create Sales Invoice"
{
    trigger OnRun()
    begin
        CreatePurchInvoice();
    end;

    local procedure CreatePurchInvoice()
    var
        Staging1: Record "Shipment Import Line";
        Staging2: Record "Shipment Import Line";
        SalesHeader: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipLine: Record "Sales Shipment Line";
        SalesLine: Record "Sales Line";
        NoSeries: Codeunit "No. Series";
        SalesGetReceipt: Codeunit "Sales-Get Shipment";
        GroupKey: Integer;
    begin
        SalesSetup.get();
        SalesSetup.TestField("Invoice Nos.");

        Staging1.Reset();
        Staging1.SETFILTER(Status, '%1', Staging1.Status::Processed);
        if Staging1.FindSet() then
            repeat
                if GroupKey <> Staging1."Group Key" then begin

                    GroupKey := Staging1."Group Key";

                    //create sales header.
                    SalesHeader.Init();
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                    SalesHeader.Validate("No.", NoSeries.GetNextNo(SalesSetup."Invoice Nos."));
                    SalesHeader.Validate("Sell-to Customer No.", Staging1."Customer No.");
                    SalesHeader.Validate("Bill-to Customer No.", Staging1."Customer No.");
                    SalesHeader.Validate("Posting Date", Today);
                    SalesHeader.Status := SalesHeader.Status::Open;
                    SalesHeader.Insert(true);

                    Staging2.Reset();
                    Staging2.SetRange("Group Key", Staging1."Group Key");
                    if Staging2.FindSet() then
                        repeat
                            SalesShipLine.SetRange("Sell-to Customer No.", Staging1."Customer No.");
                            SalesShipLine.SetRange("Bill-to Customer No.", Staging1."Customer No.");
                            SalesShipLine.SetRange("Customer Item No.", Staging1."Customer Item No.");
                            SalesShipLine.SetRange("Customer Order No.", Staging1."Customer Order No.");
                            SalesShipLine.SetRange(Description, Staging2."Item Description");
                            SalesShipLine.SetRange("Currency Code", Staging2."Currency Code");
                            SalesShipLine.SetFilter("Qty. Shipped Not Invoiced", '<>%1', 0);
                            SalesShipLine.SetRange(Quantity, Staging2."Shipped Quantity");
                            SalesShipLine.SetRange("Authorized for Credit Card", false);

                            if not SalesShipLine.IsEmpty() then begin
                                SalesGetReceipt.SetSalesHeader(SalesHeader);
                                SalesGetReceipt.CreateInvLines(SalesShipLine);

                                Staging2.Status := Staging2.Status::OK;
                                Staging2.Modify();
                            end;

                            SalesLine.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                            SalesLine.SetRange("Document No.", SalesHeader."No.");
                            SalesLine.SetRange("Customer Order No.", Staging2."Customer Order No.");
                            SalesLine.SetRange("Customer Item No.", Staging2."Customer Item No.");
                            SalesLine.SetRange(Description, Staging2."Item Description");
                            SalesLine.SetRange("Currency Code", Staging2."Currency Code");
                            SalesLine.SetRange(Quantity, Staging2."Shipped Quantity");
                            if SalesLine.FindFirst() then begin
                                if (Staging2."Unit Price" <> 0) and (Staging2."Unit Price" <> SalesLine."Unit Price") then begin
                                    SalesLine.Validate("Unit Price", Staging2."Unit Price");
                                    SalesLine.Modify();
                                end;
                            end;

                        until Staging2.Next() = 0;
                end;
            until Staging1.Next() = 0;


        Staging1.Reset();
        Staging1.SETFILTER(Status, '%1', Staging1.Status::OK);
        Staging1.DeleteAll();
    end;
}
