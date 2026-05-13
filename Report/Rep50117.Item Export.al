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
        dataitem("Real Item Import Line"; "Item Import Line")
        {
            //UseTemporary = true;
            RequestFilterFields = "Item No.", "Customer No.", "Vendor No.", "Item Supplier Source", Blocked;
            trigger OnAfterGetRecord()
            begin
                //Message("Real Item Import Line".GetFilters());
                if FormatOnly then
                    exit;
                if "Real Item Import Line"."Batch Name" = BatchNameIntFilter then begin
                    "Item Import Line".Init();
                    "Item Import Line".TransferFields("Real Item Import Line");
                    "Item Import Line".Insert();
                end;
            end;

            // After all real records processed, check if buffer is empty
            trigger OnPostDataItem()
            begin
                if "Item Import Line".IsEmpty() then begin
                    "Item Import Line".Init();
                    "Item Import Line".Insert();
                end;
            end;
        }
        dataitem("Item Import Line"; "Item Import Line")
        {
            UseTemporary = true;
            //RequestFilterFields = "Item No.", "Customer No.", "Vendor No.", "Item Supplier Source", Blocked;
            DataItemTableView = sorting("Entry No.");
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
                        ApplicationArea = All;
                        ToolTip = 'When checked, only the template format will be exported with no data included.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        recItemImpLn: Record "Item Import Line";
    begin
        //Clear("Item Import Line");
        if FormatOnly then begin
            //"Real Item Import Line".SetRange("Entry No.", -1);
            //"Real Item Import Line".FindSet();
            //"Item Import Line".Init();
            //"Item Import Line".Insert();
        end else begin
            /*if BatchNameIntFilter <> '' then begin
                "Item Import Line".SetRange("Batch Name", BatchNameIntFilter);
                //"Item Import Line".FindSet();
            end;*/
            //recItemImpLn.CopyFilters("Item Import Line");
            //recItemImpLn.SetView("Item Import Line".GetView());
            /*ItemNoFilter := "Item Import Line".GetFilter("Item No.");
            CustomerNoFilter := "Item Import Line".GetFilter("Customer No.");
            VendorNoFilter := "Item Import Line".GetFilter("Vendor No.");
            ItemSupplierSourceFilter := "Item Import Line".GetFilter("Item Supplier Source");
            BlockedFilter := "Item Import Line".GetFilter("Blocked");
            if ItemNoFilter <> '' then begin
                recItemImpLn.SetFilter("Item No.", ItemNoFilter);
            end;
            if CustomerNoFilter <> '' then begin
                recItemImpLn.SetFilter("Customer No.", CustomerNoFilter);
            end;
            if VendorNoFilter <> '' then begin
                recItemImpLn.SetFilter("Vendor No.", VendorNoFilter);
            end;
            if ItemSupplierSourceFilter <> '' then begin
                recItemImpLn.SetFilter("Item Supplier Source", ItemSupplierSourceFilter);
            end;
            if BlockedFilter <> '' then begin
                recItemImpLn.SetFilter("Blocked", BlockedFilter);
            end;*/
            /*if BatchNameIntFilter <> '' then begin
                "Real Item Import Line".SetRange("Batch Name", BatchNameIntFilter);
            end;*/
            /*if not recItemImpLn.IsEmpty() and recItemImpLn.FindSet() then begin
                repeat
                    "Item Import Line".Init();
                    "Item Import Line".TransferFields(recItemImpLn);
                    "Item Import Line".Insert();
                until recItemImpLn.Next() = 0;
            end else begin
                "Item Import Line".Reset();
                "Item Import Line".Init();
                "Item Import Line".Insert();
            end;*/
        end;

    end;

    var
        FormatOnly: Boolean;
        ItemNoFilter: Text;
        CustomerNoFilter: Text;
        VendorNoFilter: Text;
        ItemSupplierSourceFilter: Text;
        BlockedFilter: Text;
        BatchNameIntFilter: Code[20];

    procedure SetBatchNameIntFilter(BtNmIntFilter: Code[20])
    begin
        BatchNameIntFilter := BtNmIntFilter;
    end;

    procedure SetFiltersFromXml(RequestPageXml: Text)
    var
        XmlDoc: XmlDocument;
        XmlNode: XmlNode;
        XmlElem: XmlElement;
    begin
        if not XmlDocument.ReadFrom(RequestPageXml, XmlDoc) then
            exit;

        // Extract each filter field value from the XML
        // Request page XML structure:
        // <ReportParameters>
        //   <DataItems>
        //     <DataItem name="TempItem">FILTER</DataItem>
        //   </DataItems>
        //   <Options>
        //     <Field name="ItemNoFilter">1000</Field>
        //     <Field name="StatusFilter">Pending|Error</Field>
        //   </Options>
        // </ReportParameters>

        if XmlDoc.SelectSingleNode('//Field[@name="ItemNoFilter"]', XmlNode) then begin
            XmlElem := XmlNode.AsXmlElement();
            ItemNoFilter := XmlElem.InnerText;
        end;

        if XmlDoc.SelectSingleNode('//Field[@name="CustomerNoFilter"]', XmlNode) then begin
            XmlElem := XmlNode.AsXmlElement();
            CustomerNoFilter := XmlElem.InnerText;
        end;

        if XmlDoc.SelectSingleNode('//Field[@name="VendorNoFilter"]', XmlNode) then begin
            XmlElem := XmlNode.AsXmlElement();
            VendorNoFilter := XmlElem.InnerText;
        end;

        if XmlDoc.SelectSingleNode('//Field[@name="ItemSupplierSourceFilter"]', XmlNode) then begin
            XmlElem := XmlNode.AsXmlElement();
            ItemSupplierSourceFilter := XmlElem.InnerText;
        end;

        if XmlDoc.SelectSingleNode('//Field[@name="BlockedFilter"]', XmlNode) then begin
            XmlElem := XmlNode.AsXmlElement();
            BlockedFilter := XmlElem.InnerText;
        end;
    end;

}

