codeunit 50117 "Item Import"
{
    trigger OnRun()
    begin
        ReadExcelSheet();
        ImportExcelData();
    end;

    var
        FileName: Text[250];
        SheetName: Text[100];
        G_BatchName: Code[20];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Import finished.';
        EntryNoNotValid: Label 'Entry No. is not valid.';
        EntryNoRequested: Label 'Entry No. is requested, can''t be empty.';
        EntryNoDuplicated: Label 'Entry No. is duplicated.';
        TypeNotValid: Label 'Type is not valid.';
        ItemNoNotValid: Label 'Item No. is not valid.';
        ItemNoRequested: Label 'Item No. is requested, can''t be empty.';
        FamiliarNameNotValid: Label 'Familiar Name is not valid.';
        DescriptionNotValid: Label 'Description is not valid.';
        Description2NotValid: Label 'Description 2 is not valid.';
        BaseUnitofMeasureNotValid: Label 'Base Unit of Measure is not valid.';
        BaseUnitofMeasureRequested: Label 'Base Unit of Measure is requested, can''t be empty.';
        SalesUnitofMeasureNotValid: Label 'Sales Unit of Measure is not valid.';
        PurchaseUnitofMeasureNotValid: Label 'Purchase Unit of Measure is not valid.';
        PriceProfitCalculationNotValid: Label 'Price/Profit Calculation is not valid.';
        LeadTimeCalculationNotValid: Label 'Lead Time Calculation is not valid.';
        TariffNoNotValid: Label 'Tariff No. is not valid.';
        ReserveNotValid: Label 'Reserve is not valid.';
        StockoutWarningNotValid: Label 'Stockout Warning is not valid.';
        PreventNegativeInventoryNotValid: Label 'Prevent Negative Inventory is not valid.';
        ReplenishmentSystemNotValid: Label 'Replenishment System is not valid.';
        ItemTrackingCodeNotValid: Label 'Item Tracking Code is not valid.';
        ManufactureCodeNotValid: Label 'Manufacture Code is not valid.';
        ItemCategoryCodeNotValid: Label 'Item Category Code is not valid.';
        OriginalItemNoNotValid: Label 'Original Item No. is not valid.';
        CountryRegionofOriginCodeNotValid: Label 'Country/Region of Origin Code is not valid.';
        CountryRegionofOrgCdFENotValid: Label 'Country/Region of Org Cd (FE) is not valid.';
        ProductGroupCodeNotValid: Label 'Product Group Code is not valid.';
        ProductsNotValid: Label 'Products is not valid.';
        PartsNoNotValid: Label 'Parts No. is not valid.';
        PKGNotValid: Label 'PKG is not valid.';
        RankNotValid: Label 'Rank is not valid.';
        SBUNotValid: Label 'SBU is not valid.';
        CarModelNotValid: Label 'Car Model is not valid.';
        SOPNotValid: Label 'SOP is not valid.';
        MPVolumePcsMNotValid: Label 'MP-Volume(pcs/M) is not valid.';
        AplNotValid: Label 'Apl is not valid.';
        ServicePartsNotValid: Label 'Service Parts is not valid.';
        OrderDeadlineDateNotValid: Label 'Order Deadline Date is not valid.';
        EOLNotValid: Label 'EOL is not valid.';
        MemoNotValid: Label 'Memo is not valid.';
        EDINotValid: Label 'EDI is not valid.';
        CustomerNoNotValid: Label 'Customer No. is not valid.';
        CustomerItemNoNotValid: Label 'Customer Item No. is not valid.';
        CustomerItemNoPlainNotValid: Label 'Customer Item No. (Plain) is not valid.';
        OEMNoRequested: Label 'OEM No. is requested, can''t be empty.';
        OEMNoNotValid: Label 'OEM No. is not valid.';
        VendorNoNotValid: Label 'Vendor No. is not valid.';
        ItemSupplierSourceNotValid: Label 'Item Supplier Source is not valid.';
        VendorItemNoNotValid: Label 'Vendor Item No. is not valid.';
        LotSizeNotValid: Label 'Lot Size is not valid.';
        MinimumOrderQuantityNotValid: Label 'Minimum Order Quantity is not valid.';
        OrderMultipleNotValid: Label 'Order Multiple is not valid.';
        MaximumOrderQuantityNotValid: Label 'Maximum Order Quantity is not valid.';
        MarkupNotValid: Label 'Markup% is not valid.';
        MarkupSalesPriceNotValid: Label 'Markup%(Sales Price) is not valid.';
        MarkupPurchasePriceNotValid: Label 'Markup%(Purchase Price) is not valid.';
        OneRenesasEDINotValid: Label 'One Renesas EDI is not valid.';
        ExcludedinInventoryReportNotValid: Label 'Excluded in Inventory Report is not valid.';
        GenProdPostingGroupNotValid: Label 'Gen. Prod. Posting Group is not valid.';
        InventoryPostingGroupNotValid: Label 'Inventory Posting Group is not valid.';
        VATProdPostingGroupNotValid: Label 'VAT Prod. Posting Group is not valid.';
        CustomerGroupCodeNotValid: Label 'Customer Group Code is not valid.';
        BaseCurrencyCodeNotValid: Label 'Base Currency Code is not valid.';
        BlockedNotValid: Label 'Blocked is not valid.';

    procedure SetBatchName(pBatchName: Code[20])
    begin
        G_BatchName := pBatchName;
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        rec_POInt: Record "Item Import Line";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        EntryNoStr: Text;
        EntryNo: Integer;
        TypeStr: Text;
        ItemNoStr: Text;
        ItemNo: Code[20];
        FamiliarNameStr: Text;
        DescriptionStr: Text;
        Description2Str: Text;
        BaseUnitofMeasureStr: Text;
        SalesUnitofMeasureStr: Text;
        PurchaseUnitofMeasureStr: Text;
        PriceProfitCalculationStr: Text;
        LeadTimeCalculationStr: text;
        TariffNoStr: text;
        ReserveStr: text;
        StockoutWarningStr: text;
        PreventNegativeInventoryStr: text;
        ReplenishmentSystemStr: text;
        ItemTrackingCodeStr: text;
        ManufactureCodeStr: text;
        ItemCategoryCodeStr: text;
        OriginalItemNoStr: text;
        CountryRegionOfOriginCodeStr: text;
        CountryRegionOfOriginCodeFEStr: text;
        ProductGroupCodeStr: text;
        ProductsStr: text;
        PartsNoStr: text;
        PKGStr: text;
        RankStr: text;
        SBUStr: text;
        CarModelStr: text;
        SOPStr: text;
        MPVolumePcsMStr: text;
        AplStr: text;
        ServicePartsStr: text;
        OrderDeadlineDateStr: text;
        EOLStr: text;
        MemoStr: text;
        EDIStr: text;
        CustomerNoStr: text;
        CustomerItemNoStr: text;
        CustomerItemNoPlainStr: text;
        OEMNoStr: text;
        VendorNoStr: text;
        ItemSupplierSourceStr: text;
        VendorItemNoStr: text;
        LotSizeStr: text;
        MinimumOrderQuantityStr: text;
        OrderMultipleStr: text;
        MaximumOrderQuantityStr: text;
        MarkupStr: text;
        MarkupSalesPriceStr: text;
        MarkupPurchasePriceStr: text;
        OneRenesasEDIStr: text;
        ExcludedInInventoryReportStr: text;
        GenProdPostingGroupStr: text;
        InventoryPostingGroupStr: text;
        VATProdPostingGroupStr: text;
        CustomerGroupCodeStr: text;
        BaseCurrencyCodeStr: text;
        BlockedStr: text;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        rec_POInt.Reset();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        if MaxRowNo <= 1 then begin
            Error('There is no record to import.');
        end;

        for RowNo := 2 to MaxRowNo do begin
            rec_POInt.Init();

            //----------------------Preparing for the check----------------------
            EntryNoStr := GetValueAtCell(RowNo, 1).Trim();
            TypeStr := GetValueAtCell(RowNo, 2);
            ItemNoStr := GetValueAtCell(RowNo, 3);
            FamiliarNameStr := GetValueAtCell(RowNo, 4).Trim();
            DescriptionStr := GetValueAtCell(RowNo, 5).Trim();
            Description2Str := GetValueAtCell(RowNo, 6).Trim();
            BaseUnitofMeasureStr := GetValueAtCell(RowNo, 7).Trim();
            SalesUnitofMeasureStr := GetValueAtCell(RowNo, 8).Trim();
            PurchaseUnitofMeasureStr := GetValueAtCell(RowNo, 9).Trim();
            PriceProfitCalculationStr := GetValueAtCell(RowNo, 10).Trim();
            LeadTimeCalculationStr := GetValueAtCell(RowNo, 11).Trim();
            TariffNoStr := GetValueAtCell(RowNo, 12).Trim();
            ReserveStr := GetValueAtCell(RowNo, 13).Trim();
            StockoutWarningStr := GetValueAtCell(RowNo, 14).Trim();
            PreventNegativeInventoryStr := GetValueAtCell(RowNo, 15).Trim();
            ReplenishmentSystemStr := GetValueAtCell(RowNo, 16).Trim();
            ItemTrackingCodeStr := GetValueAtCell(RowNo, 17).Trim();
            ManufactureCodeStr := GetValueAtCell(RowNo, 18).Trim();
            ItemCategoryCodeStr := GetValueAtCell(RowNo, 19).Trim();
            OriginalItemNoStr := GetValueAtCell(RowNo, 20).Trim();
            CountryRegionOfOriginCodeStr := GetValueAtCell(RowNo, 21).Trim();
            CountryRegionOfOriginCodeFEStr := GetValueAtCell(RowNo, 22).Trim();
            ProductGroupCodeStr := GetValueAtCell(RowNo, 23).Trim();
            ProductsStr := GetValueAtCell(RowNo, 24).Trim();
            PartsNoStr := GetValueAtCell(RowNo, 25).Trim();
            PKGStr := GetValueAtCell(RowNo, 26).Trim();
            RankStr := GetValueAtCell(RowNo, 27).Trim();
            SBUStr := GetValueAtCell(RowNo, 28).Trim();
            CarModelStr := GetValueAtCell(RowNo, 29).Trim();
            SOPStr := GetValueAtCell(RowNo, 30).Trim();
            MPVolumePcsMStr := GetValueAtCell(RowNo, 31).Trim();
            AplStr := GetValueAtCell(RowNo, 32).Trim();
            ServicePartsStr := GetValueAtCell(RowNo, 33).Trim();
            OrderDeadlineDateStr := GetValueAtCell(RowNo, 34).Trim();
            EOLStr := GetValueAtCell(RowNo, 35).Trim();
            MemoStr := GetValueAtCell(RowNo, 36).Trim();
            EDIStr := GetValueAtCell(RowNo, 37).Trim();
            CustomerNoStr := GetValueAtCell(RowNo, 38).Trim();
            CustomerItemNoStr := GetValueAtCell(RowNo, 39).Trim();
            CustomerItemNoPlainStr := GetValueAtCell(RowNo, 40).Trim();
            OEMNoStr := GetValueAtCell(RowNo, 41).Trim();
            VendorNoStr := GetValueAtCell(RowNo, 42).Trim();
            ItemSupplierSourceStr := GetValueAtCell(RowNo, 43).Trim();
            VendorItemNoStr := GetValueAtCell(RowNo, 44).Trim();
            LotSizeStr := GetValueAtCell(RowNo, 45).Trim();
            MinimumOrderQuantityStr := GetValueAtCell(RowNo, 46).Trim();
            OrderMultipleStr := GetValueAtCell(RowNo, 47).Trim();
            MaximumOrderQuantityStr := GetValueAtCell(RowNo, 48).Trim();
            MarkupStr := GetValueAtCell(RowNo, 49).Trim();
            MarkupSalesPriceStr := GetValueAtCell(RowNo, 50).Trim();
            MarkupPurchasePriceStr := GetValueAtCell(RowNo, 51).Trim();
            OneRenesasEDIStr := GetValueAtCell(RowNo, 52).Trim();
            ExcludedInInventoryReportStr := GetValueAtCell(RowNo, 53).Trim();
            GenProdPostingGroupStr := GetValueAtCell(RowNo, 54).Trim();
            InventoryPostingGroupStr := GetValueAtCell(RowNo, 55).Trim();
            VATProdPostingGroupStr := GetValueAtCell(RowNo, 56).Trim();
            CustomerGroupCodeStr := GetValueAtCell(RowNo, 57).Trim();
            BaseCurrencyCodeStr := GetValueAtCell(RowNo, 58).Trim();
            BlockedStr := GetValueAtCell(RowNo, 59).Trim();

            //-------------------------------Check-------------------------------
            if (EntryNoStr = '') then begin
                Error(EntryNoRequested);
            end;
            if (not Evaluate(EntryNo, EntryNoStr)) then begin
                Error(EntryNoNotValid);
            end;
            if rec_POInt.get(G_BatchName, EntryNo) then begin
                Error(EntryNoDuplicated);
            end;

            if ((TypeStr = '') or (not (TypeStr in ['Inventory', 'Service', 'Non-Inventory']))) then begin
                Error(TypeNotValid);
            end;

            if (ItemNoStr = '') then begin
                Error(ItemNoRequested);
            end;
            if (not Evaluate(rec_POInt."Item No.", ItemNoStr)) then begin
                Error(ItemNoNotValid);
            end;

            if ((FamiliarNameStr <> '') and (not Evaluate(rec_POInt."Familiar Name", FamiliarNameStr))) then begin
                Error(FamiliarNameNotValid);
            end;

            if ((DescriptionStr <> '') and (not Evaluate(rec_POInt."Description", DescriptionStr))) then begin
                Error(DescriptionNotValid);
            end;

            if ((Description2Str <> '') and (not Evaluate(rec_POInt."Description 2", Description2Str))) then begin
                Error(Description2NotValid);
            end;

            if (BaseUnitofMeasureStr = '') then begin
                Error(BaseUnitofMeasureRequested);
            end;
            if (not Evaluate(rec_POInt."Base Unit of Measure", BaseUnitofMeasureStr)) then begin
                Error(BaseUnitofMeasureNotValid);
            end;

            if ((SalesUnitofMeasureStr <> '') and (not Evaluate(rec_POInt."Sales Unit of Measure", SalesUnitofMeasureStr))) then begin
                Error(SalesUnitofMeasureNotValid);
            end;

            if ((PurchaseUnitofMeasureStr <> '') and (not Evaluate(rec_POInt."Purchase Unit of Measure", PurchaseUnitofMeasureStr))) then begin
                Error(PurchaseUnitofMeasureNotValid);
            end;

            if not Evaluate(rec_POInt."Price/Profit Calculation", PriceProfitCalculationStr) then begin
                Error(PriceProfitCalculationNotValid);
            end;

            if ((LeadTimeCalculationStr <> '') and (not Evaluate(rec_POInt."Lead Time Calculation", LeadTimeCalculationStr))) then begin
                Error(LeadTimeCalculationNotValid);
            end;

            if ((TariffNoStr <> '') and (not Evaluate(rec_POInt."Tariff No.", TariffNoStr))) then begin
                Error(TariffNoNotValid);
            end;

            if not Evaluate(rec_POInt."Reserve", ReserveStr) then begin
                Error(ReserveNotValid);
            end;

            if (not (StockoutWarningStr in ['Default', 'No', 'Yes'])) then begin
                Error(StockoutWarningNotValid);
            end;

            if (not (PreventNegativeInventoryStr in ['Default', 'No', 'Yes'])) then begin
                Error(PreventNegativeInventoryNotValid);
            end;

            if not Evaluate(rec_POInt."Replenishment System", ReplenishmentSystemStr) then begin
                Error(ReplenishmentSystemNotValid);
            end;

            if ((ItemTrackingCodeStr <> '') and (not Evaluate(rec_POInt."Item Tracking Code", ItemTrackingCodeStr))) then begin
                Error(ItemTrackingCodeNotValid);
            end;

            if ((ManufactureCodeStr <> '') and (not Evaluate(rec_POInt."Manufacture Code", ManufactureCodeStr))) then begin
                Error(ManufactureCodeNotValid);
            end;

            if ((ItemCategoryCodeStr <> '') and (not Evaluate(rec_POInt."Item Category Code", ItemCategoryCodeStr))) then begin
                Error(ItemCategoryCodeNotValid);
            end;

            if ((OriginalItemNoStr <> '') and (not Evaluate(rec_POInt."Original Item No.", OriginalItemNoStr))) then begin
                Error(OriginalItemNoNotValid);
            end;

            if ((CountryRegionOfOriginCodeStr <> '') and (not Evaluate(rec_POInt."Country/Region of Origin Code", CountryRegionOfOriginCodeStr))) then begin
                Error(CountryRegionofOriginCodeNotValid);
            end;

            if ((CountryRegionOfOriginCodeFEStr <> '') and (not Evaluate(rec_POInt."Country/Region of Org Cd (FE)", CountryRegionOfOriginCodeFEStr))) then begin
                Error(CountryRegionofOrgCdFENotValid);
            end;

            if ((ProductGroupCodeStr <> '') and (not Evaluate(rec_POInt."Product Group Code", ProductGroupCodeStr))) then begin
                Error(ProductGroupCodeNotValid);
            end;

            if ((ProductsStr <> '') and (not Evaluate(rec_POInt."Products", ProductsStr))) then begin
                Error(ProductsNotValid);
            end;

            if ((PartsNoStr <> '') and (not Evaluate(rec_POInt."Parts No.", PartsNoStr))) then begin
                Error(PartsNoNotValid);
            end;

            if ((PKGStr <> '') and (not Evaluate(rec_POInt."PKG", PKGStr))) then begin
                Error(PKGNotValid);
            end;

            if ((RankStr <> '') and (not Evaluate(rec_POInt."Rank", RankStr))) then begin
                Error(RankNotValid);
            end;

            if ((SBUStr <> '') and (not Evaluate(rec_POInt."SBU", SBUStr))) then begin
                Error(SBUNotValid);
            end;

            if ((CarModelStr <> '') and (not Evaluate(rec_POInt."Car Model", CarModelStr))) then begin
                Error(CarModelNotValid);
            end;

            if ((SOPStr <> '') and (not Evaluate(rec_POInt."SOP", SOPStr))) then begin
                Error(SOPNotValid);
            end;

            if ((MPVolumePcsMStr <> '') and (not Evaluate(rec_POInt."MP-Volume(pcs/M)", MPVolumePcsMStr))) then begin
                Error(MPVolumePcsMNotValid);
            end;

            if ((AplStr <> '') and (not Evaluate(rec_POInt."Apl", AplStr))) then begin
                Error(AplNotValid);
            end;

            if ((ServicePartsStr <> '') and (not Evaluate(rec_POInt."Service Parts", ServicePartsStr))) then begin
                Error(ServicePartsNotValid);
            end;

            if ((OrderDeadlineDateStr <> '') and (not Evaluate(rec_POInt."Order Deadline Date", OrderDeadlineDateStr))) then begin
                Error(OrderDeadlineDateNotValid);
            end;

            if ((EOLStr <> '') and (not Evaluate(rec_POInt."EOL", EOLStr))) then begin
                Error(EOLNotValid);
            end;

            if ((MemoStr <> '') and (not Evaluate(rec_POInt."Memo", MemoStr))) then begin
                Error(MemoNotValid);
            end;

            if ((EDIStr <> '') and (not Evaluate(rec_POInt."EDI", EDIStr))) then begin
                Error(EDINotValid);
            end;

            if ((CustomerNoStr <> '') and (not Evaluate(rec_POInt."Customer No.", CustomerNoStr))) then begin
                Error(CustomerNoNotValid);
            end;

            if ((CustomerItemNoStr <> '') and (not Evaluate(rec_POInt."Customer Item No.", CustomerItemNoStr))) then begin
                Error(CustomerItemNoNotValid);
            end;

            if ((CustomerItemNoPlainStr <> '') and (not Evaluate(rec_POInt."Customer Item No. (Plain)", CustomerItemNoPlainStr))) then begin
                Error(CustomerItemNoPlainNotValid);
            end;

            if (OEMNoStr = '') then begin
                Error(OEMNoRequested);
            end;

            if (not Evaluate(rec_POInt."OEM No.", OEMNoStr)) then begin
                Error(OEMNoNotValid);
            end;

            if ((VendorNoStr <> '') and (not Evaluate(rec_POInt."Vendor No.", VendorNoStr))) then begin
                Error(VendorNoNotValid);
            end;

            if (not Evaluate(rec_POInt."Item Supplier Source", ItemSupplierSourceStr)) then begin
                Error(ItemSupplierSourceNotValid);
            end;

            if ((VendorItemNoStr <> '') and (not Evaluate(rec_POInt."Vendor Item No.", VendorItemNoStr))) then begin
                Error(VendorItemNoNotValid);
            end;

            if ((LotSizeStr <> '') and (not Evaluate(rec_POInt."Lot Size", LotSizeStr))) then begin
                Error(LotSizeNotValid);
            end;

            if ((MinimumOrderQuantityStr <> '') and (not Evaluate(rec_POInt."Minimum Order Quantity", MinimumOrderQuantityStr))) then begin
                Error(MinimumOrderQuantityNotValid);
            end;

            if ((OrderMultipleStr <> '') and (not Evaluate(rec_POInt."Order Multiple", OrderMultipleStr))) then begin
                Error(OrderMultipleNotValid);
            end;

            if ((MaximumOrderQuantityStr <> '') and (not Evaluate(rec_POInt."Maximum Order Quantity", MaximumOrderQuantityStr))) then begin
                Error(MaximumOrderQuantityNotValid);
            end;

            if ((MarkupStr <> '') and (not Evaluate(rec_POInt."Markup%", MarkupStr))) then begin
                Error(MarkupNotValid);
            end;

            if ((MarkupSalesPriceStr <> '') and (not Evaluate(rec_POInt."Markup%(Sales Price)", MarkupSalesPriceStr))) then begin
                Error(MarkupSalesPriceNotValid);
            end;

            if ((MarkupPurchasePriceStr <> '') and (not Evaluate(rec_POInt."Markup%(Purchase Price)", MarkupPurchasePriceStr))) then begin
                Error(MarkupPurchasePriceNotValid);
            end;

            if ((OneRenesasEDIStr <> '') and (not Evaluate(rec_POInt."One Renesas EDI", OneRenesasEDIStr))) then begin
                Error(OneRenesasEDINotValid);
            end;

            if ((ExcludedInInventoryReportStr <> '') and (not Evaluate(rec_POInt."Excluded in Inventory Report", ExcludedInInventoryReportStr))) then begin
                Error(ExcludedinInventoryReportNotValid);
            end;

            if ((GenProdPostingGroupStr <> '') and (not Evaluate(rec_POInt."Gen. Prod. Posting Group", GenProdPostingGroupStr))) then begin
                Error(GenProdPostingGroupNotValid);
            end;

            if ((InventoryPostingGroupStr <> '') and (not Evaluate(rec_POInt."Inventory Posting Group", InventoryPostingGroupStr))) then begin
                Error(InventoryPostingGroupNotValid);
            end;

            if ((VATProdPostingGroupStr <> '') and (not Evaluate(rec_POInt."VAT Prod. Posting Group", VATProdPostingGroupStr))) then begin
                Error(VATProdPostingGroupNotValid);
            end;

            if ((CustomerGroupCodeStr <> '') and (not Evaluate(rec_POInt."Customer Group Code", CustomerGroupCodeStr))) then begin
                Error(CustomerGroupCodeNotValid);
            end;

            if ((BaseCurrencyCodeStr <> '') and (not Evaluate(rec_POInt."Base Currency Code", BaseCurrencyCodeStr))) then begin
                Error(BaseCurrencyCodeNotValid);
            end;

            if ((BlockedStr <> '') and (not Evaluate(rec_POInt."Blocked", BlockedStr))) then begin
                Error(BlockedNotValid);
            end;

            //----------------------Set values for each item----------------------
            rec_POInt."Batch Name" := G_BatchName;
            rec_POInt."Entry No." := EntryNo;
            Evaluate(rec_POInt."Type", GetValueAtCell(RowNo, 2));
            Evaluate(rec_POInt."Item No.", GetValueAtCell(RowNo, 3));
            if Evaluate(rec_POInt."Familiar Name", GetValueAtCell(RowNo, 4)) then;
            if Evaluate(rec_POInt."Description", GetValueAtCell(RowNo, 5)) then;
            if Evaluate(rec_POInt."Description 2", GetValueAtCell(RowNo, 6)) then;
            Evaluate(rec_POInt."Base Unit of Measure", GetValueAtCell(RowNo, 7));
            if Evaluate(rec_POInt."Sales Unit of Measure", GetValueAtCell(RowNo, 8)) then;
            if Evaluate(rec_POInt."Purchase Unit of Measure", GetValueAtCell(RowNo, 9)) then;
            Evaluate(rec_POInt."Price/Profit Calculation", GetValueAtCell(RowNo, 10));
            if Evaluate(rec_POInt."Lead Time Calculation", GetValueAtCell(RowNo, 11)) then;
            if Evaluate(rec_POInt."Tariff No.", GetValueAtCell(RowNo, 12)) then;
            Evaluate(rec_POInt."Reserve", GetValueAtCell(RowNo, 13));
            Evaluate(rec_POInt."Stockout Warning", GetValueAtCell(RowNo, 14));
            Evaluate(rec_POInt."Prevent Negative Inventory", GetValueAtCell(RowNo, 15));
            Evaluate(rec_POInt."Replenishment System", GetValueAtCell(RowNo, 16));
            if Evaluate(rec_POInt."Item Tracking Code", GetValueAtCell(RowNo, 17)) then;
            if Evaluate(rec_POInt."Manufacture Code", GetValueAtCell(RowNo, 18)) then;
            if Evaluate(rec_POInt."Item Category Code", GetValueAtCell(RowNo, 19)) then;
            if Evaluate(rec_POInt."Original Item No.", GetValueAtCell(RowNo, 20)) then;
            if Evaluate(rec_POInt."Country/Region of Origin Code", GetValueAtCell(RowNo, 21)) then;
            if Evaluate(rec_POInt."Country/Region of Org Cd (FE)", GetValueAtCell(RowNo, 22)) then;
            if Evaluate(rec_POInt."Product Group Code", GetValueAtCell(RowNo, 23)) then;
            if Evaluate(rec_POInt."Products", GetValueAtCell(RowNo, 24)) then;
            if Evaluate(rec_POInt."Parts No.", GetValueAtCell(RowNo, 25)) then;
            if Evaluate(rec_POInt."PKG", GetValueAtCell(RowNo, 26)) then;
            if Evaluate(rec_POInt."Rank", GetValueAtCell(RowNo, 27)) then;
            if Evaluate(rec_POInt."SBU", GetValueAtCell(RowNo, 28)) then;
            if Evaluate(rec_POInt."Car Model", GetValueAtCell(RowNo, 29)) then;
            if Evaluate(rec_POInt."SOP", GetValueAtCell(RowNo, 30)) then;
            if Evaluate(rec_POInt."MP-Volume(pcs/M)", GetValueAtCell(RowNo, 31)) then;
            if Evaluate(rec_POInt."Apl", GetValueAtCell(RowNo, 32)) then;
            if Evaluate(rec_POInt."Service Parts", GetValueAtCell(RowNo, 33)) then;
            if Evaluate(rec_POInt."Order Deadline Date", GetValueAtCell(RowNo, 34)) then;
            if Evaluate(rec_POInt."EOL", GetValueAtCell(RowNo, 35)) then;
            if Evaluate(rec_POInt."Memo", GetValueAtCell(RowNo, 36)) then;
            if Evaluate(rec_POInt."EDI", GetValueAtCell(RowNo, 37)) then;
            if Evaluate(rec_POInt."Customer No.", GetValueAtCell(RowNo, 38)) then;
            if Evaluate(rec_POInt."Customer Item No.", GetValueAtCell(RowNo, 39)) then;
            if Evaluate(rec_POInt."Customer Item No. (Plain)", GetValueAtCell(RowNo, 40)) then;
            if Evaluate(rec_POInt."OEM No.", GetValueAtCell(RowNo, 41)) then;
            if Evaluate(rec_POInt."Vendor No.", GetValueAtCell(RowNo, 42)) then;
            Evaluate(rec_POInt."Item Supplier Source", GetValueAtCell(RowNo, 43));
            if Evaluate(rec_POInt."Vendor Item No.", GetValueAtCell(RowNo, 44)) then;
            if Evaluate(rec_POInt."Lot Size", GetValueAtCell(RowNo, 45)) then;
            if Evaluate(rec_POInt."Minimum Order Quantity", GetValueAtCell(RowNo, 46)) then;
            if Evaluate(rec_POInt."Order Multiple", GetValueAtCell(RowNo, 47)) then;
            if Evaluate(rec_POInt."Maximum Order Quantity", GetValueAtCell(RowNo, 48)) then;
            if Evaluate(rec_POInt."Markup%", GetValueAtCell(RowNo, 49)) then;
            if Evaluate(rec_POInt."Markup%(Sales Price)", GetValueAtCell(RowNo, 50)) then;
            if Evaluate(rec_POInt."Markup%(Purchase Price)", GetValueAtCell(RowNo, 51)) then;
            if Evaluate(rec_POInt."One Renesas EDI", GetValueAtCell(RowNo, 52)) then;
            if Evaluate(rec_POInt."Excluded in Inventory Report", GetValueAtCell(RowNo, 53)) then;
            if Evaluate(rec_POInt."Gen. Prod. Posting Group", GetValueAtCell(RowNo, 54)) then;
            if Evaluate(rec_POInt."Inventory Posting Group", GetValueAtCell(RowNo, 55)) then;
            if Evaluate(rec_POInt."VAT Prod. Posting Group", GetValueAtCell(RowNo, 56)) then;
            if Evaluate(rec_POInt."Customer Group Code", GetValueAtCell(RowNo, 57)) then;
            if Evaluate(rec_POInt."Base Currency Code", GetValueAtCell(RowNo, 58)) then;
            if Evaluate(rec_POInt."Blocked", GetValueAtCell(RowNo, 59)) then;
            rec_POInt.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}
