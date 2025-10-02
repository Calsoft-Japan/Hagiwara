report 50003 "ActualOrderAmountOrderBalance"
{
    ApplicationArea = All;
    Caption = 'Actual Order Amount & Order Balance';
    UsageCategory = ReportsAndAnalysis;

    DefaultRenderingLayout = MyLayout;

    dataset
    {
        dataitem(SalesLine1; "Sales Line")
        {
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
        }
        dataitem(SalesLine2; "Sales Line")
        {
            column(Type; "Type")
            {
            }
            column(No; "No.")
            {
            }
            column(CustomerItemNo; "Customer Item No.")
            {
            }
            column(PartsNo; "Parts No.")
            {
            }
            column(Rank; Rank)
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    rendering
    {
        layout(MyLayout)
        {
            Type = Excel;
            LayoutFile = './XLSX/ActualOrderAmountOrderBalance.xlsx';
            ExcelLayoutMultipleDataSheets = true;
        }
    }
}
