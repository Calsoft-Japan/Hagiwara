query 50005 "BI GL Entry AS"
{
    // FDD:C015/2.3.1.5
    Caption = 'BI GL Entry AS';
    QueryType = API;
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_GL_Entry_AS';
    EntitySetName = 'BIGLEntriesAS';
    QueryCategory = 'PowerBI';
    //DelayedInsert = false;

    elements
    {
        dataitem(GLE; "G/L Entry")
        {
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

            column(Amount; Amount) { }
        }
    }
}