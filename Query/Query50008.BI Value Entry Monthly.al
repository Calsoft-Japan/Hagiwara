query 50008 "BI Value Entry Monthly"
{
    // FDD
    Caption = 'BI Value Entry Monthly';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Value_Entry_Monthly';
    EntitySetName = 'BIValueEntriesMonthly';
    //DelayedInsert = false;

    elements
    {
        dataitem(VE; "Value Entry")
        {
            // Use these two in the client to extract Year and Month
            column(Year_Posting_Date; "Posting Date") { Method = Year; }
            column(Month_Posting_Date; "Posting Date") { Method = Month; }

            column(DocumentType; "Document Type") { }

            column(CostAmount_Actual; "Cost Amount (Actual)") { Method = Sum; }

            column(SalesAmount_Actual; "Sales Amount (Actual)") { Method = Sum; }
        }
    }
}