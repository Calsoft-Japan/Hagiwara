report 50095 "Update Outstand Qty. Approved"
{
    ProcessingOnly = true;


    Caption = 'Update Outstanding Qty. (Approved)';
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
        if not Confirm('This report will update all Sales Lines and Purchase lines ''Outstanding Qty. (Approved)''.\Make sure run this report after ran ''Approve Migrated Data (Auto)''.\Are you sure to continue?') then
            exit;

        ProcessSalesDocuments();
        ProcessPurchaseDocuments();

    end;

    trigger OnPostReport()
    begin
        Message('All Sales Lines and Purchase lines ''Outstanding Qty. (Approved)'' is updated!');
    end;

    local procedure ProcessSalesDocuments()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetFilter("Approved Quantity", '>%1', 0);
        SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
        if SalesLine.FindSet() then begin
            repeat
                SalesLine.Validate("Approved Quantity");
                SalesLine.Modify();
            until SalesLine.Next() = 0;
        end;
    end;

    local procedure ProcessPurchaseDocuments()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetFilter("Approved Quantity", '>%1', 0);
        PurchaseLine.SetFilter("Outstanding Quantity", '>%1', 0);
        if PurchaseLine.FindSet() then begin
            repeat
                PurchaseLine.Validate("Approved Quantity");
                PurchaseLine.Modify();
            until PurchaseLine.Next() = 0;
        end;
    end;

}

