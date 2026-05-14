report 50127 "Item Export"
{

    ProcessingOnly = true;
    Caption = 'Item Export';
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; "Item")
        {
            RequestFilterFields = "No.", "Customer No.", "Vendor No.", "Item Supplier Source", Blocked;

            trigger OnPreDataItem()
            begin

                TempExcelBuffer.Reset();
                TempExcelBuffer.DeleteAll();

                // prepare header
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(EntryNo_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Type_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ItemNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FamiliarName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Description_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Description2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BaseUnitofMeasure_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesUnitofMeasure_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseUnitofMeasure_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Price_ProfitCalculation_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LeadTimeCalculation_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TariffNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Reserve_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(StockoutWarning_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PreventNegativeInventory_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ReplenishmentSystem_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ItemTrackingCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ManufactureCode_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ItemCategoryCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OriginalItemNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Country_RegionofOriginCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Country_RegionofOrgCd_FE__Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ProductGroupCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Products_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PartsNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PKG_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Rank_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SBU_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CarModel_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SOP_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MP_Volume_pcs_M__Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Apl_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ServiceParts_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OrderDeadlineDate_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(EOL_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Memo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(EDI_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerNo_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerItemNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerItemNo_Plain__Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OEMNo_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VendorNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ItemSupplierSource_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VendorItemNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LotSize_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MinimumOrderQuantity_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OrderMultiple_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(MaximumOrderQuantity_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Markup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Markup_SalesPrice__Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Markup_PurchasePrice__Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OneRenesasEDI_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ExcludedinInventoryReport_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GenProdPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(InventoryPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VATProdPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GlobalDimension1Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GlobalDimension2Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Blocked_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

            end;

            trigger OnAfterGetRecord()
            var

            begin
                if not FormatOnly then begin
                    EntryNo := EntryNo + 1;

                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(EntryNo, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Type", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Familiar Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Description", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Description 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Base Unit of Measure", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Sales Unit of Measure", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Purch. Unit of Measure", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Price/Profit Calculation", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Lead Time Calculation", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Tariff No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Reserve", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Stockout Warning", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Prevent Negative Inventory", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Replenishment System", false, '', false, true, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Item Tracking Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Manufacturer Code", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Item Category Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Original Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Country/Region of Origin Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Country/Region of Org Cd (FE)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Item Group Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Products", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Parts No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."PKG", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Rank", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."SBU", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Car Model", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."SOP", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."MP-Volume(pcs/M)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Apl", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Service Parts", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Order Deadline Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(Item."EOL", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Memo", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."EDI", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Customer No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Customer Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Customer Item No.(Plain)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."OEM No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Vendor No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Item Supplier Source", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Vendor Item No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Lot Size", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Minimum Order Quantity", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Order Multiple", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Maximum Order Quantity", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Markup%", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Markup%(Sales Price)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."Markup%(Purchase Price)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Item."One Renesas EDI", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Excluded in Inventory Report", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Gen. Prod. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Inventory Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."VAT Prod. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Item."Blocked", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                end;
            end;

            trigger OnPostDataItem()
            begin

                SheetName := 'Item';
                ExcelFileName := 'Item_%1';
                TempExcelBuffer.CreateNewBook(SheetName);
                TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
                TempExcelBuffer.CloseBook();
                TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime));
                TempExcelBuffer.OpenExcel();
            end;
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

        actions
        {
        }
    }

    var
        EntryNo: Integer;

        TempExcelBuffer: Record "Excel Buffer" temporary;
        FormatOnly: Boolean;

        SheetName: Text[50];
        ExcelFileName: Text[50];

        EntryNo_Lbl: Label '*Entry No.';
        Type_Lbl: Label '*Type';
        ItemNo_Lbl: Label 'Item No.';
        FamiliarName_Lbl: Label 'Familiar Name';
        Description_Lbl: Label 'Description';
        Description2_Lbl: Label 'Description 2';
        BaseUnitofMeasure_Lbl: Label '*Base Unit of Measure';
        SalesUnitofMeasure_Lbl: Label 'Sales Unit of Measure';
        PurchaseUnitofMeasure_Lbl: Label 'Purchase Unit of Measure';
        Price_ProfitCalculation_Lbl: Label '*Price/Profit Calculation';
        LeadTimeCalculation_Lbl: Label 'Lead Time Calculation';
        TariffNo_Lbl: Label 'Tariff No.';
        Reserve_Lbl: Label '*Reserve';
        StockoutWarning_Lbl: Label '*Stockout Warning';
        PreventNegativeInventory_Lbl: Label '*Prevent Negative Inventory';
        ReplenishmentSystem_Lbl: Label '*Replenishment System';
        ItemTrackingCode_Lbl: Label 'Item Tracking Code';
        ManufactureCode_Lbl: Label '*Manufacture Code';
        ItemCategoryCode_Lbl: Label 'Item Category Code';
        OriginalItemNo_Lbl: Label 'Original Item No.';
        Country_RegionofOriginCode_Lbl: Label 'Country/Region of Origin Code';
        Country_RegionofOrgCd_FE__Lbl: Label 'Country/Region of Org Cd (FE)';
        ProductGroupCode_Lbl: Label 'Product Group Code';
        Products_Lbl: Label 'Products';
        PartsNo_Lbl: Label 'Parts No.';
        PKG_Lbl: Label 'PKG';
        Rank_Lbl: Label 'Rank';
        SBU_Lbl: Label 'SBU';
        CarModel_Lbl: Label 'Car Model';
        SOP_Lbl: Label 'SOP';
        MP_Volume_pcs_M__Lbl: Label 'MP-Volume(pcs/M)';
        Apl_Lbl: Label 'Apl';
        ServiceParts_Lbl: Label 'Service Parts';
        OrderDeadlineDate_Lbl: Label 'Order Deadline Date';
        EOL_Lbl: Label 'EOL';
        Memo_Lbl: Label 'Memo';
        EDI_Lbl: Label 'EDI';
        CustomerNo_Lbl: Label '*Customer No.';
        CustomerItemNo_Lbl: Label 'Customer Item No.';
        CustomerItemNo_Plain__Lbl: Label 'Customer Item No. (Plain)';
        OEMNo_Lbl: Label '*OEM No.';
        VendorNo_Lbl: Label 'Vendor No.';
        ItemSupplierSource_Lbl: Label 'Item Supplier Source';
        VendorItemNo_Lbl: Label 'Vendor Item No.';
        LotSize_Lbl: Label 'Lot Size';
        MinimumOrderQuantity_Lbl: Label 'Minimum Order Quantity';
        OrderMultiple_Lbl: Label 'Order Multiple';
        MaximumOrderQuantity_Lbl: Label 'Maximum Order Quantity';
        Markup_Lbl: Label 'Markup%';
        Markup_SalesPrice__Lbl: Label 'Markup%(Sales Price)';
        Markup_PurchasePrice__Lbl: Label 'Markup%(Purchase Price)';
        OneRenesasEDI_Lbl: Label 'One Renesas EDI';
        ExcludedinInventoryReport_Lbl: Label 'Excluded in Inventory Report';
        GenProdPostingGroup_Lbl: Label 'Gen. Prod. Posting Group';
        InventoryPostingGroup_Lbl: Label 'Inventory Posting Group';
        VATProdPostingGroup_Lbl: Label 'VAT Prod. Posting Group';
        GlobalDimension1Code_Lbl: Label 'Global Dimension 1 Code';
        GlobalDimension2Code_Lbl: Label 'Global Dimension 2 Code';
        Blocked_Lbl: Label 'Blocked';



}

