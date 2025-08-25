query 50003 "BI Value Entry"
{
    // FDD:C015/2.3.1.3
    Caption = 'BI Value Entry';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Value_Entry';
    EntitySetName = 'BIValueEntries';
    //DelayedInsert = false;

    elements
    {
        dataitem(VE; "Value Entry")
        {
            // Expose a runtime filter for Posting Date
            filter(PostingDateFilter; "Posting Date") { }

            // Fields per FDD
            column(PostingDate; "Posting Date") { }

            column(ItemNo; "Item No.") { }

            column(Item_Ledger_Entry_Type; "Item Ledger Entry Type") { }

            column(SourceNo; "Source No.") { }

            column(Invoicedquantity; "Invoiced Quantity") { }

            column(SalesAmountActual; "Sales Amount (Actual)") { }

            column(CostAmountActual; "Cost Amount (Actual)") { }

            column(CostPostedToGL; "Cost Posted to G/L") { }

            column(Document_Type; "Document Type") { }

        }
    }

    // Trigger to set the Posting Date filter to the last two years when the query is opened
    trigger OnBeforeOpen()
    var
        fromDate: Date;
        toDate: Date;
    begin
        // Only apply a default if the caller did NOT pass a PostingDate filter
        if GetFilter(PostingDateFilter) = '' then begin
            toDate := Today;                           // or WorkDate() if you want “work date” semantics
            fromDate := CalcDate('<-2Y>', toDate);     // two years back from today
            SetRange(PostingDateFilter, fromDate, toDate);
        end;
        // If a caller passes $filter / OData filter, it remains in effect (no conflict).
    end;

}