query 50002 "BI Item List"
{
    // FDD:C015/2.3.1.2     
    Caption = 'BI Item List';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Item_List';
    EntitySetName = 'BIItemLists';
    //SourceTable = Item;
    //DelayedInsert = false;

    elements
    {
        dataitem(Item; "Item")
        {
            // Source Table: Item
            column(No; "No.") { }

            column(FamiliarName; "Familiar Name") { }

            column(CustomerItemNo; "Customer Item No.") { }

            column(Description; Description) { }

            column(UnitCost; "Unit Cost") { }

            column(VendorNo; "Vendor No.") { }

            column(CountryRegionOfOrgCdFE; "Country/Region of Org Cd (FE)") { }

            column(Minimum_Order_Quantity; "Minimum Order Quantity") { }

            column(Order_Multiple; "Order Multiple") { }

            column(Customer_No_; "Customer No.") { }
        }
    }
}