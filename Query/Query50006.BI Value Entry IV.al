query 50006 "BI Value Entry IV"
{
    // FDD:C015/2.3.1.6
    Caption = 'BI Value Entry IV';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Value_Entry_IV';
    EntitySetName = 'BIValueEntriesIV';
    //DelayedInsert = false;

    elements
    {
        dataitem(VE; "Value Entry")
        {
            column(ItemNo; "Item No.") { }

            column(PostingDate; "Posting Date") { }

            column(Source_No; "Source No.") { }

            column(InvoicedQuantity; "Invoiced Quantity") { }

            column(SalesAmountActual; "Sales Amount (Actual)") { }

            column(CostAmountActual; "Cost Amount (Actual)") { }

            column(DocumentType; "Document Type") { }

            column(LocationCode; "Location Code") { }
        }
    }
}