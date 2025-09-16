query 50009 "BI Sales Header"
{
    // FDD
    Caption = 'BI Sales Header';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Sales_Header';
    EntitySetName = 'BISalesHeaders';
    //DelayedInsert = false;

    elements
    {
        dataitem(SH; "Sales Header")
        {
            // Fields per FDD
            column(No; "No.") { }

            column(Ship_to_Address; "Ship-to Address") { }

            column(Ship_to_Address_2; "Ship-to Address 2") { }

            column(Ship_to_Post_Code; "Ship-to Post Code") { }

            column(Ship_to_City; "Ship-to City") { }

            //Use an aggregate function to get the maximum amount from the Sales Header
            column(Amount; Amount) { Method = Max; }

            //Include only headers with at least one outstanding line
            dataitem(SL; "Sales Line")
            {
                SqlJoinType = InnerJoin;
                DataItemLink =
                "Document No." = SH."No.",
                "Document Type" = SH."Document Type";

                DataItemTableFilter = "Outstanding Quantity" = filter(<> 0);
                //No columns needed from SL
            }
        }
    }
}