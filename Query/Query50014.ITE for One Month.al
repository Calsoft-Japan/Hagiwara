query 50014 "ITE for One Month"
{

    elements
    {
        dataitem(QueryElement1120082000; "Inventory Trace Entry")
        {
            column(Entry_No; "Entry No.")
            {
            }
            column(Item_Application_Entry_No; "Item Application Entry No.")
            {
            }
            column(Item_Ledger_Entry_No; "Item Ledger Entry No.")
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No; "Document No.")
            {
            }
            column(Document_Line_No; "Document Line No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Item_No; "Item No")
            {
            }
            column(Item_Description; "Item Description")
            {
            }
            column(Customer_No; "Customer No.")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(OEM_No; "OEM No.")
            {
            }
            column(OEM_Name; "OEM Name")
            {
            }
            column(SCM_Customer_Code; "SCM Customer Code")
            {
            }
            column(Vendor_No; "Vendor No.")
            {
            }
            column(Vendor_Name; "Vendor Name")
            {
            }
            column(Manufacturer_Code; "Manufacturer Code")
            {
            }
            column(Ship_Debit_Flag; "Ship&Debit Flag")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(New_Ship_Debit_Flag; "New Ship&Debit Flag")
            {
            }
            column(Purchase_Order_No; "Purchase Order No.")
            {
            }
            column(Purch_Item_No; "Purch. Item No.")
            {
            }
            column(Purch_Item_Vendor_No; "Purch. Item Vendor No.")
            {
            }
            column(Purch_Item_Vendor_Name; "Purch. Item Vendor Name")
            {
            }
            column(Purch_Item_Manufacturer_Code; "Purch. Item Manufacturer Code")
            {
            }
            column(Purch_Hagiwara_Group; "Purch. Hagiwara Group")
            {
            }
            column(Cost_Currency; "Cost Currency")
            {
            }
            column(Direct_Unit_Cost; "Direct Unit Cost")
            {
            }
            column(New_Direct_Unit_Cost; "New Direct Unit Cost")
            {
            }
            column(PC_Cost_Currency; "PC. Cost Currency")
            {
            }
            column(PC_Direct_Unit_Cost; "PC. Direct Unit Cost")
            {
            }
            column(New_PC_Direct_Unit_Cost; "New PC. Direct Unit Cost")
            {
            }
            column(SLS_Purchase_Price; "SLS. Purchase Price")
            {
            }
            column(SLS_Purchase_Currency; "SLS. Purchase Currency")
            {
            }
            column(New_Cost_Currency; "New Cost Currency")
            {
            }
            column(New_PC_Cost_Currency; "New PC. Cost Currency")
            {
            }
            column(INV_Purchase_Price; "INV. Purchase Price")
            {
            }
            column(INV_Purchase_Currency; "INV. Purchase Currency")
            {
            }
            column(PC_Entry_No; "PC. Entry No.")
            {
            }
            column(External_Document_No; "External Document No.")
            {
            }
            column(Booking_No; "Booking No.")
            {
            }
            column(Shipment_Seq_No; "Shipment Seq. No.")
            {
            }
            column(Sales_Price; "Sales Price")
            {
            }
            column(Sales_Amount; "Sales Amount")
            {
            }
            column(Sales_Currency; "Sales Currency")
            {
            }
            column(Original_Document_No; "Original Document No.")
            {
            }
            column(Original_Document_Line_No; "Original Document Line No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Incoming_Item_Ledger_Entry_No; "Incoming Item Ledger Entry No.")
            {
            }
            column(Calc_Rem_Qty; "Calc. Rem. Qty.")
            {
            }
            column(Manually_Updated; "Manually Updated")
            {
            }
            column(Note; Note)
            {
            }
            column(Pattern; Pattern)
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        CurrQuery.SETFILTER(Posting_Date, '%1..%2', CALCDATE('<-1M>', TODAY), TODAY);
    end;
}

