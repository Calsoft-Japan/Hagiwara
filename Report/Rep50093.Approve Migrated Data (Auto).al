report 50093 "Approve Migrated Data (Auto)"
{
    ProcessingOnly = true;


    Caption = 'Approve Migrated Data (Auto)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
    }

    requestpage
    {

        layout
        {

        }

        actions
        {
        }


    }

    labels
    {
    }


    trigger OnPreReport()
    begin
        ProcessSalesDocuments();
        ProcessPurchaseDocuments();
        ProcessTransferOrders();
        ProcessAssemblyOrders();
        ProcessGLAccounts();

    end;

    local procedure ProcessSalesDocuments()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.SetRange("Approval Status", SalesHeader."Approval Status"::"Not Applicable");
        if SalesHeader.FindSet() then begin
            repeat
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                if SalesLine.FindSet() then begin
                    repeat
                        SalesLine."Approved Quantity" := SalesLine.Quantity;
                        SalesLine."Approved Unit Price" := SalesLine."Unit Price";
                        SalesLine.Modify();
                    until SalesLine.Next() = 0;
                end;

                SalesHeader."Approval Status" := SalesHeader."Approval Status"::"Auto Approved";
                SalesHeader.Modify();
            until SalesHeader.Next() = 0;
        end;
    end;

    local procedure ProcessPurchaseDocuments()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.SetRange("Approval Status", PurchaseHeader."Approval Status"::"Not Applicable");
        if PurchaseHeader.FindSet() then begin
            repeat
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                if PurchaseLine.FindSet() then begin
                    repeat
                        PurchaseLine."Approved Quantity" := PurchaseLine.Quantity;
                        PurchaseLine."Approved Unit Cost" := PurchaseLine."Direct Unit Cost";
                        PurchaseLine.Modify();
                    until PurchaseLine.Next() = 0;
                end;


                PurchaseHeader."Approval Status" := PurchaseHeader."Approval Status"::"Auto Approved";
                PurchaseHeader.Modify();
            until PurchaseHeader.Next() = 0;
        end;
    end;

    local procedure ProcessTransferOrders()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        FromLocation: Record Location;
        ToLocation: Record Location;
    begin
        TransferHeader.SetRange("Approval Status", TransferHeader."Approval Status"::"Not Applicable");
        if TransferHeader.FindSet() then begin
            repeat
                // Check if either location has Approval Target = true
                //FromLocation.Get(TransferHeader."Transfer-from Code");
                //ToLocation.Get(TransferHeader."Transfer-to Code");

                //if FromLocation."Approval Target" or ToLocation."Approval Target" then begin
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", TransferHeader."No.");
                if TransferLine.FindSet() then begin
                    repeat
                        TransferLine."Approved Quantity" := TransferLine.Quantity;
                        TransferLine.Modify();
                    until TransferLine.Next() = 0;
                end;

                TransferHeader."Approval Status" := TransferHeader."Approval Status"::"Auto Approved";
                TransferHeader.Modify();
            //end;
            until TransferHeader.Next() = 0;
        end;
    end;

    local procedure ProcessAssemblyOrders()
    var
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
    begin
        AssemblyHeader.SetRange("Approval Status", AssemblyHeader."Approval Status"::"Not Applicable");
        if AssemblyHeader.FindSet() then begin
            repeat
                AssemblyLine.Reset();
                AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                if AssemblyLine.FindSet() then
                    repeat
                        AssemblyLine."Approved Quantity" := AssemblyLine.Quantity;
                        AssemblyLine.Modify();
                    until AssemblyLine.Next() = 0;

                AssemblyHeader."Approved Quantity" := AssemblyHeader.Quantity;
                AssemblyHeader."Approval Status" := AssemblyHeader."Approval Status"::"Auto Approved";
                AssemblyHeader.Modify();
            until AssemblyHeader.Next() = 0;
        end;
    end;

    local procedure ProcessGLAccounts()
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.SetRange("Approval Status", GLAccount."Approval Status"::"Not Applicable");
        if GLAccount.FindSet() then begin
            repeat
                GLAccount."Approval Status" := GLAccount."Approval Status"::"Auto Approved";
                GLAccount.Modify();
            until GLAccount.Next() = 0;
        end;
    end;


}

