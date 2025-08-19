query 50004 "BI Sales Line"
{
    // FDD:C015/2.3.1.4
    Caption = 'BI Sales Line';
    QueryType = API;
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Sales_Line';
    EntitySetName = 'BISalesLines';
    QueryCategory = 'PowerBI';
    //DelayedInsert = false;

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            // Only lines with open quantity
            DataItemTableFilter = "Outstanding Quantity" = FILTER(<> 0);

            // Fields per FDD
            column(DocumentType; "Document Type") { }

            column(SelltoCustomerNo; "Sell-to Customer No.") { }

            column(No; "No.") { }

            column(UnitPrice; "Unit Price") { }

            column(UnitCostLCY; "Unit Cost (LCY)") { }

            column(ShipmentDate; "Shipment Date") { }

            column(OutstandingQuantity; "Outstanding Quantity") { }

            column(CurrencyCode; "Currency Code") { }

            column(DocumentNo; "Document No.") { }

            column("LineNo"; "Line No.") { }

            column(Quantity; Quantity) { }

            // Ensure the field exists in "Sales Line" or use Method = Count
            // column(RegisteredDeliveryDate_1; "Registered Delivery Date_1") { }
            // Removed invalid column as "Registered Delivery Date_1" does not exist in "Sales Line"

        }
    }
}