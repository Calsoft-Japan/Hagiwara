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

            column(Sell_to_Address; "Sell-to Address") { }

            column(Sell_to_Address_2; "Sell-to Address 2") { }

            column(Ship_to_Post_Code; "Ship-to Post Code") { }

            column(OrderDate; "Order Date") { }

            column(Ship_to_City; "Ship-to City") { }

            column(Amount; Amount) { }
        }
    }
}