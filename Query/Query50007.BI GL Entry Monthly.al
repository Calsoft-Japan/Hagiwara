query 50007 "BI GL Entry Monthly"
{
    // FDD
    Caption = 'BI GL Entry Monthly';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_GL_Entry_Monthly';
    EntitySetName = 'BIGLEntriesMonthly';
    //DelayedInsert = false;

    elements
    {
        dataitem(GLE; "G/L Entry")
        {
            // Use these two in the client to extract Year and Month
            column(Year_Posting_Date; "Posting Date") { Method = Year; }
            column(Month_Posting_Date; "Posting Date") { Method = Month; }

            // Grouping keys per FDD
            column(Document_Type; "Document Type") { }
            column(GL_Account_No; "G/L Account No.") { }

            // Measure
            column(Sum_Amount; Amount) { Method = Sum; }
        }
    }
}