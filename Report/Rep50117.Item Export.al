report 50117 "Item Export"
{
    // FDDN010 Bobby 2026/4/22 -Item Export

    //ProcessingOnly = true;
    RDLCLayout = './RDLC/ItemExport.rdlc';

    Caption = 'Item Export';
    //UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Item Import Line"; "Item Import Line")
        {
            UseTemporary = true;
            RequestFilterFields = "Item No.", "Customer No.", "Vendor No.", "Item Supplier Source", Blocked;
            column(Entry_No_; "Entry No.") { }
            column(Type; Type) { }
            column(Item_No_; "Item No.") { }
            column(Familiar_Name; "Familiar Name") { }
            column("Description"; "Description") { }
            column(Description_2; "Description 2") { }
            column(Base_Unit_of_Measure; "Base Unit of Measure") { }
            column(Sales_Unit_of_Measure; "Sales Unit of Measure") { }
            column(Purchase_Unit_of_Measure; "Purchase Unit of Measure") { }
            column(Price_Profit_Calculation; "Price/Profit Calculation") { }
            column(Lead_Time_Calculation; "Lead Time Calculation") { }
            column(Tariff_No_; "Tariff No.") { }
            column(Reserve; "Reserve") { }
            column(Stockout_Warning; "Stockout Warning") { }
            column(Prevent_Negative_Inventory; "Prevent Negative Inventory") { }
            column(Replenishment_System; "Replenishment System") { }
            column(Item_Tracking_Code; "Item Tracking Code") { }
            column(Manufacture_Code; "Manufacture Code") { }
            column(Item_Category_Code; "Item Category Code") { }
            column(Original_Item_No_; "Original Item No.") { }
            column(Country_Region_of_Origin_Code; "Country/Region of Origin Code") { }
            column(Country_Region_of_Org_Cd_FE; "Country/Region of Org Cd (FE)") { }
            column(Product_Group_Code; "Product Group Code") { }
            column(Products; Products) { }
            column(Parts_No_; "Parts No.") { }
            column(PKG; PKG) { }
            column(Rank; Rank) { }
            column(SBU; SBU) { }
            column(Car_Model; "Car Model") { }
            column(SOP; SOP) { }
            column(MP_Volume_pcs_M; "MP-Volume(pcs/M)") { }
            column(Apl; Apl) { }
            column(Service_Parts; "Service Parts") { }
            column(Order_Deadline_Date; "Order Deadline Date") { }
            column(EOL; EOL) { }
            column(Memo; Memo) { }
            column(EDI; EDI) { }
            column(Customer_No_; "Customer No.") { }
            column(Customer_Item_No_; "Customer Item No.") { }
            column(Customer_Item_No_Plain; "Customer Item No. (Plain)") { }
            column(OEM_No_; "OEM No.") { }
            column(Vendor_No_; "Vendor No.") { }
            column(Item_Supplier_Source; "Item Supplier Source") { }
            column(Vendor_Item_No_; "Vendor Item No.") { }
            column(Lot_Size; "Lot Size") { }
            column(Minimum_Order_Quantity; "Minimum Order Quantity") { }
            column(Order_Multiple; "Order Multiple") { }
            column(Maximum_Order_Quantity; "Maximum Order Quantity") { }
            column(Markup_Pct; "Markup%") { }
            column(Markup_Pct_Sales_Price; "Markup%(Sales Price)") { }
            column(Markup_Pct_Purchase_Price; "Markup%(Purchase Price)") { }
            column(One_Renesas_EDI; "One Renesas EDI") { }
            column(Excluded_in_Inventory_Report; "Excluded in Inventory Report") { }
            column(Gen_Prod_Posting_Group; "Gen. Prod. Posting Group") { }
            column(Inventory_Posting_Group; "Inventory Posting Group") { }
            column(VAT_Prod_Posting_Group; "VAT Prod. Posting Group") { }
            column(Customer_Group_Code; "Customer Group Code") { }
            column(Base_Currency_Code; "Base Currency Code") { }
            column(Blocked; Blocked) { }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Options")
                {
                    Caption = 'Options';
                    field(FormatOnly; FormatOnly)
                    {
                        Caption = 'Format Only';
                        ToolTip = 'When checked, only the template format will be exported with no data included.';
                    }
                }
            }
        }

        actions
        {
        }
    }
    trigger OnPreReport()
    var
        recItemImpLn: Record "Item Import Line";
    begin
        if FormatOnly then begin
            "Item Import Line".Init();
            "Item Import Line".Insert();
        end else begin
            recItemImpLn.CopyFilters("Item Import Line");

            if BatchNameIntFilter <> '' then begin
                recItemImpLn.SetRange("Batch Name", BatchNameIntFilter);
            end;
            if recItemImpLn.FindSet() then begin
                repeat
                    "Item Import Line".Init();
                    "Item Import Line".TransferFields(recItemImpLn);
                    "Item Import Line".Insert();
                until recItemImpLn.Next() = 0;
            end else begin
                "Item Import Line".Init();
                "Item Import Line".Insert();
            end;
        end;

    end;

    var
        FormatOnly: Boolean;
        ItemNoFilter: Code[20];
        CustomerNoFilter: Code[20];
        VendorNoFilter: Code[20];
        ItemSupplierSourceFilter: Option;
        BlockedFilter: Boolean;
        BatchNameIntFilter: Code[20];

    procedure SetBatchNameIntFilter(BtNmIntFilter: Code[20])
    begin
        BatchNameIntFilter := BtNmIntFilter;
    end;
}

