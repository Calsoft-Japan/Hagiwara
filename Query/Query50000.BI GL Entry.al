query 50000 "BI GL Entry"
{
    // FDD 2.3.1.1
    Caption = 'BI GL Entry';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_GL_Entry';
    EntitySetName = 'BIGLEntries';
    //DelayedInsert = false;

    elements
    {
        dataitem(GLE; "G/L Entry")
        {
            // Expose a runtime filter for Posting Date (set to -2Y.. when running)
            filter(PostingDateFilter; "Posting Date") { }

            // Fields per FDD
            column(PostingDate; "Posting Date") { }
            column(DocumentType; "Document Type") { }
            column(GLAccountNo; "G/L Account No.") { }

            // G/L Account Name via join
            dataitem(GLA; "G/L Account")
            {
                DataItemLink = "No." = GLE."G/L Account No.";
                SqlJoinType = LeftOuterJoin;
                column(GLAccountName; Name) { }
            }

            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Amount; Amount) { }
            column(AdditionalCurrencyAmount; "Additional-Currency Amount") { }
            column(VATAmount; "VAT Amount") { }
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
