codeunit 50119 "Customer Import"
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
        NameNotValid: Label 'Name is not valid.';
        PrintStatementsNotValid: Label 'Print Statements is not valid.';
        ApplicationMethodNotValid: Label 'Application Method is not valid.';
        PricesIncludingVATNotValid: Label 'Prices Including VAT is not valid.';
        CombineShipmentsNotValid: Label 'Combine Shipments is not valid.';
        TaxLiableNotValid: Label 'Tax Liable is not valid.';
        ReserveNotValid: Label 'Reserve is not valid.';
        BlockPaymentToleranceNotValid: Label 'Block Payment Tolerance is not valid.';
        PrepaymentNotValid: Label 'Prepayment is not valid.';
        PartnerTypeNotValid: Label 'Partner Type is not valid.';
        ShippingAdviceNotValid: Label 'Shipping Advice is not valid.';
        ShippingTimeNotValid: Label 'Shipping Time is not valid.';
        ContractGainLossAmountNotValid: Label 'Contract Gain/Loss Amount is not valid.';
        AllowLineDiscNotValid: Label 'Allow Line Disc. is not valid.';
        CopySelltoAddrtoQteFromNotValid: Label 'Copy Sell-to Addr. to Qte From is not valid.';
        CustomerTypeNotValid: Label 'Customer Type is not valid.';
        ItemSupplierSourceNotValid: Label 'Item Supplier Source is not valid.';
        DefaultCountryRegionofOrgNotValid: Label 'Default Country/Region of Org is not valid.';
        PriceUpdateTargetDateNotValid: Label 'Price Update Target Date is not valid.';
        ExcludedinORECollectionNotValid: Label 'Excluded in ORE Collection is not valid.';
        DaysforAutoInvReservationNotValid: Label 'Days for Auto Inv. Reservation is not valid.';
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
        rec_POInt: Record "Customer Import Line";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        EntryNoStr: Text;
        EntryNo: Integer;
        NoStr: Text;
        NameStr: Text;
        SearchNameStr: Text;
        Name2Str: Text;
        AddressStr: Text;
        Address2Str: Text;
        CityStr: Text;
        ContactStr: Text;
        PhoneNoStr: Text;
        GlobalDimension1CodeStr: Text;
        GlobalDimension2CodeStr: Text;
        CustomerPostingGroupStr: Text;
        CurrencyCodeStr: Text;
        CustomerPriceGroupStr: Text;
        LanguageCodeStr: Text;
        PaymentTermsCodeStr: Text;
        FinChargeTermsCodeStr: Text;
        SalespersonCodeStr: Text;
        ShipmentMethodCodeStr: Text;
        ShippingAgentCodeStr: Text;
        InvoiceDiscCodeStr: Text;
        CountryRegionCodeStr: Text;
        CollectionMethodStr: Text;
        PrintStatementsStr: Text;
        PrintStatements: Boolean;
        BilltoCustomerNoStr: Text;
        PaymentMethodCodeStr: Text;
        ApplicationMethodStr: Text;
        PricesIncludingVATStr: Text;
        PricesIncludingVAT: Boolean;
        LocationCodeStr: Text;
        FaxNoStr: Text;
        VATRegistrationNoStr: Text;
        CombineShipmentsStr: Text;
        CombineShipments: Boolean;
        GenBusPostingGroupStr: Text;
        GLNStr: Text;
        PostCodeStr: Text;
        CountyStr: Text;
        EMailStr: Text;
        HomePageStr: Text;
        ReminderTermsCodeStr: Text;
        NoSeriesStr: Text;
        TaxAreaCodeStr: Text;
        TaxLiableStr: Text;
        TaxLiable: Boolean;
        VATBusPostingGroupStr: Text;
        ReserveStr: Text;
        BlockPaymentToleranceStr: Text;
        BlockPaymentTolerance: Boolean;
        ICPartnerCodeStr: Text;
        PrepaymentStr: Text;
        Prepayment: Decimal;
        PartnerTypeStr: Text;
        PreferredBankAccountCodeStr: Text;
        CashFlowPaymentTermsCodeStr: Text;
        PrimaryContactNoStr: Text;
        ResponsibilityCenterStr: Text;
        ShippingAdviceStr: Text;
        ShippingTimeStr: Text;
        ShippingTime: DateFormula;
        ShippingAgentServiceCodeStr: Text;
        ServiceZoneCodeStr: Text;
        ContractGainLossAmountStr: Text;
        ContractGainLossAmount: Decimal;
        AllowLineDiscStr: Text;
        AllowLineDisc: Boolean;
        CopySelltoAddrtoQteFromStr: Text;
        CustomerTypeStr: Text;
        NECOEMCodeStr: Text;
        NECOEMNameStr: Text;
        ShippingMark1Str: Text;
        ShippingMark2Str: Text;
        ShippingMark3Str: Text;
        ShippingMark4Str: Text;
        ShippingMark5Str: Text;
        Remarks1Str: Text;
        Remarks2Str: Text;
        Remarks3Str: Text;
        Remarks4Str: Text;
        Remarks5Str: Text;
        ItemSupplierSourceStr: Text;
        VendorCustCodeStr: Text;
        ShipFromNameStr: Text;
        ShipFromAddressStr: Text;
        HQTypeStr: Text;
        DefaultCountryRegionofOrgStr: Text;
        PriceUpdateTargetDateStr: Text;
        ExcludedinORECollection: Boolean;
        ORECustomerNameStr: Text;
        OREAddressStr: Text;
        OREAddress2Str: Text;
        ORECityStr: Text;
        OREStateProvinceStr: Text;
        ExcludedinORECollectionStr: Text;
        ORECountryStr: Text;
        OREPostCodeStr: Text;
        CustomerGroupStr: Text;
        FamiliarNameStr: Text;
        ImportFileShipToStr: Text;
        ReceivingLocationStr: Text;
        DaysforAutoInvReservationStr: Text;
        DaysforAutoInvReservation: Integer;
        BlockedStr: Text;
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
            NoStr := GetValueAtCell(RowNo, 2).Trim();
            NameStr := GetValueAtCell(RowNo, 3).Trim();
            SearchNameStr := GetValueAtCell(RowNo, 4).Trim();
            Name2Str := GetValueAtCell(RowNo, 5).Trim();
            AddressStr := GetValueAtCell(RowNo, 6).Trim();
            Address2Str := GetValueAtCell(RowNo, 7).Trim();
            CityStr := GetValueAtCell(RowNo, 8).Trim();
            ContactStr := GetValueAtCell(RowNo, 9).Trim();
            PhoneNoStr := GetValueAtCell(RowNo, 10).Trim();
            GlobalDimension1CodeStr := GetValueAtCell(RowNo, 11).Trim();
            GlobalDimension2CodeStr := GetValueAtCell(RowNo, 12).Trim();
            CustomerPostingGroupStr := GetValueAtCell(RowNo, 13).Trim();
            CurrencyCodeStr := GetValueAtCell(RowNo, 14).Trim();
            CustomerPriceGroupStr := GetValueAtCell(RowNo, 15).Trim();
            LanguageCodeStr := GetValueAtCell(RowNo, 16).Trim();
            PaymentTermsCodeStr := GetValueAtCell(RowNo, 17).Trim();
            FinChargeTermsCodeStr := GetValueAtCell(RowNo, 18).Trim();
            SalespersonCodeStr := GetValueAtCell(RowNo, 19).Trim();
            ShipmentMethodCodeStr := GetValueAtCell(RowNo, 20).Trim();
            ShippingAgentCodeStr := GetValueAtCell(RowNo, 21).Trim();
            InvoiceDiscCodeStr := GetValueAtCell(RowNo, 22).Trim();
            CountryRegionCodeStr := GetValueAtCell(RowNo, 23).Trim();
            CollectionMethodStr := GetValueAtCell(RowNo, 24).Trim();
            PrintStatementsStr := GetValueAtCell(RowNo, 25).Trim();
            BilltoCustomerNoStr := GetValueAtCell(RowNo, 26).Trim();
            PaymentMethodCodeStr := GetValueAtCell(RowNo, 27).Trim();
            ApplicationMethodStr := GetValueAtCell(RowNo, 28).Trim().ToUpper();
            PricesIncludingVATStr := GetValueAtCell(RowNo, 29).Trim();
            LocationCodeStr := GetValueAtCell(RowNo, 30).Trim();
            FaxNoStr := GetValueAtCell(RowNo, 31).Trim();
            VATRegistrationNoStr := GetValueAtCell(RowNo, 32).Trim();
            CombineShipmentsStr := GetValueAtCell(RowNo, 33).Trim();
            GenBusPostingGroupStr := GetValueAtCell(RowNo, 34).Trim();
            GLNStr := GetValueAtCell(RowNo, 35).Trim();
            PostCodeStr := GetValueAtCell(RowNo, 36).Trim();
            CountyStr := GetValueAtCell(RowNo, 37).Trim();
            EMailStr := GetValueAtCell(RowNo, 38).Trim();
            HomePageStr := GetValueAtCell(RowNo, 39).Trim();
            ReminderTermsCodeStr := GetValueAtCell(RowNo, 40).Trim();
            NoSeriesStr := GetValueAtCell(RowNo, 41).Trim();
            TaxAreaCodeStr := GetValueAtCell(RowNo, 42).Trim();
            TaxLiableStr := GetValueAtCell(RowNo, 43).Trim();
            VATBusPostingGroupStr := GetValueAtCell(RowNo, 44).Trim();
            ReserveStr := GetValueAtCell(RowNo, 45).Trim().ToUpper();
            BlockPaymentToleranceStr := GetValueAtCell(RowNo, 46).Trim();
            ICPartnerCodeStr := GetValueAtCell(RowNo, 47).Trim();
            PrepaymentStr := GetValueAtCell(RowNo, 48).Trim();
            PartnerTypeStr := GetValueAtCell(RowNo, 49).Trim().ToUpper();
            PreferredBankAccountCodeStr := GetValueAtCell(RowNo, 50).Trim();
            CashFlowPaymentTermsCodeStr := GetValueAtCell(RowNo, 51).Trim();
            PrimaryContactNoStr := GetValueAtCell(RowNo, 52).Trim();
            ResponsibilityCenterStr := GetValueAtCell(RowNo, 53).Trim();
            ShippingAdviceStr := GetValueAtCell(RowNo, 54).Trim().ToUpper();
            ShippingTimeStr := GetValueAtCell(RowNo, 55).Trim();
            ShippingAgentServiceCodeStr := GetValueAtCell(RowNo, 56).Trim();
            ServiceZoneCodeStr := GetValueAtCell(RowNo, 57).Trim();
            ContractGainLossAmountStr := GetValueAtCell(RowNo, 58).Trim();
            AllowLineDiscStr := GetValueAtCell(RowNo, 59).Trim();
            CopySelltoAddrtoQteFromStr := GetValueAtCell(RowNo, 60).Trim().ToUpper();
            CustomerTypeStr := GetValueAtCell(RowNo, 61).Trim().ToUpper();
            NECOEMCodeStr := GetValueAtCell(RowNo, 62).Trim();
            NECOEMNameStr := GetValueAtCell(RowNo, 63).Trim();
            ShippingMark1Str := GetValueAtCell(RowNo, 64).Trim();
            ShippingMark2Str := GetValueAtCell(RowNo, 65).Trim();
            ShippingMark3Str := GetValueAtCell(RowNo, 66).Trim();
            ShippingMark4Str := GetValueAtCell(RowNo, 67).Trim();
            ShippingMark5Str := GetValueAtCell(RowNo, 68).Trim();
            Remarks1Str := GetValueAtCell(RowNo, 69).Trim();
            Remarks2Str := GetValueAtCell(RowNo, 70).Trim();
            Remarks3Str := GetValueAtCell(RowNo, 71).Trim();
            Remarks4Str := GetValueAtCell(RowNo, 72).Trim();
            Remarks5Str := GetValueAtCell(RowNo, 73).Trim();
            ItemSupplierSourceStr := GetValueAtCell(RowNo, 74).Trim().ToUpper();
            VendorCustCodeStr := GetValueAtCell(RowNo, 75).Trim();
            ShipFromNameStr := GetValueAtCell(RowNo, 76).Trim();
            ShipFromAddressStr := GetValueAtCell(RowNo, 77).Trim();
            HQTypeStr := GetValueAtCell(RowNo, 78).Trim();
            DefaultCountryRegionofOrgStr := GetValueAtCell(RowNo, 79).Trim().ToUpper();
            PriceUpdateTargetDateStr := GetValueAtCell(RowNo, 80).Trim().ToUpper();
            ORECustomerNameStr := GetValueAtCell(RowNo, 81).Trim();
            OREAddressStr := GetValueAtCell(RowNo, 82).Trim();
            OREAddress2Str := GetValueAtCell(RowNo, 83).Trim();
            ORECityStr := GetValueAtCell(RowNo, 84).Trim();
            OREStateProvinceStr := GetValueAtCell(RowNo, 85).Trim();
            ExcludedinORECollectionStr := GetValueAtCell(RowNo, 86).Trim();
            ORECountryStr := GetValueAtCell(RowNo, 87).Trim();
            OREPostCodeStr := GetValueAtCell(RowNo, 88).Trim();
            CustomerGroupStr := GetValueAtCell(RowNo, 89).Trim();
            FamiliarNameStr := GetValueAtCell(RowNo, 90).Trim();
            ImportFileShipToStr := GetValueAtCell(RowNo, 91).Trim();
            ReceivingLocationStr := GetValueAtCell(RowNo, 92).Trim();
            DaysforAutoInvReservationStr := GetValueAtCell(RowNo, 93).Trim();
            BlockedStr := GetValueAtCell(RowNo, 94).Trim().ToUpper();

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
            if (not Evaluate(rec_POInt.Name, NameStr)) then begin
                Error(NameNotValid);
            end;

            if ((PrintStatementsStr <> '') and (not Evaluate(PrintStatements, PrintStatementsStr))) then begin
                Error(PrintStatementsNotValid);
            end;

            if ((ApplicationMethodStr <> '') and (not Evaluate(rec_POInt."Application Method", ApplicationMethodStr))) then begin
                Error(ApplicationMethodNotValid);
            end;

            if ((PricesIncludingVATStr <> '') and (not Evaluate(PricesIncludingVAT, PricesIncludingVATStr))) then begin
                Error(PricesIncludingVATNotValid);
            end;

            if ((CombineShipmentsStr <> '') and (not Evaluate(CombineShipments, CombineShipmentsStr))) then begin
                Error(CombineShipmentsNotValid);
            end;

            if ((TaxLiableStr <> '') and (not Evaluate(TaxLiable, TaxLiableStr))) then begin
                Error(TaxLiableNotValid);
            end;

            if ((ReserveStr <> '') and (not Evaluate(rec_POInt.Reserve, ReserveStr))) then begin
                Error(ReserveNotValid);
            end;

            if ((BlockPaymentToleranceStr <> '') and (not Evaluate(BlockPaymentTolerance, BlockPaymentToleranceStr))) then begin
                Error(BlockPaymentToleranceNotValid);
            end;

            if ((PrepaymentStr <> '') and (not Evaluate(Prepayment, PrepaymentStr))) then begin
                Error(PrepaymentNotValid);
            end;

            if ((PartnerTypeStr <> '') and (not Evaluate(rec_POInt."Partner Type", PartnerTypeStr))) then begin
                Error(PartnerTypeNotValid);
            end;

            if ((ShippingAdviceStr <> '') and (not Evaluate(rec_POInt."Shipping Advice", ShippingAdviceStr))) then begin
                Error(ShippingAdviceNotValid);
            end;

            if ((not Evaluate(ShippingTime, ShippingTimeStr)) or (ShippingTimeStr <> '')) then begin
                Error(ShippingTimeNotValid);
            end;

            if ((ContractGainLossAmountStr <> '') and (not Evaluate(ContractGainLossAmount, ContractGainLossAmountStr))) then begin
                Error(ContractGainLossAmountNotValid);
            end;

            if ((AllowLineDiscStr <> '') and (not Evaluate(AllowLineDisc, AllowLineDiscStr))) then begin
                Error(AllowLineDiscNotValid);
            end;

            if ((CopySelltoAddrtoQteFromStr <> '') and (not Evaluate(rec_POInt."Copy Sell-to Addr. to Qte From", CopySelltoAddrtoQteFromStr))) then begin
                Error(CopySelltoAddrtoQteFromNotValid);
            end;

            if ((CustomerTypeStr <> '') and (not Evaluate(rec_POInt."Customer Type", CustomerTypeStr))) then begin
                Error(CustomerTypeNotValid);
            end;

            if ((ItemSupplierSourceStr <> '') and (not Evaluate(rec_POInt."Item Supplier Source", ItemSupplierSourceStr))) then begin
                Error(ItemSupplierSourceNotValid);
            end;

            if ((DefaultCountryRegionofOrgStr <> '') and (not Evaluate(rec_POInt."Default Country/Region of Org", DefaultCountryRegionofOrgStr))) then begin
                Error(DefaultCountryRegionofOrgNotValid);
            end;

            if ((PriceUpdateTargetDateStr <> '') and (not Evaluate(rec_POInt."Price Update Target Date", PriceUpdateTargetDateStr))) then begin
                Error(PriceUpdateTargetDateNotValid);
            end;

            if ((ExcludedinORECollectionStr <> '') and (not Evaluate(ExcludedinORECollection, ExcludedinORECollectionStr))) then begin
                Error(ExcludedinORECollectionNotValid);
            end;

            if ((DaysforAutoInvReservationStr <> '') and (not Evaluate(DaysforAutoInvReservation, DaysforAutoInvReservationStr))) then begin
                Error(DaysforAutoInvReservationNotValid);
            end;

            if ((BlockedStr <> '') and (not Evaluate(rec_POInt.Blocked, BlockedStr))) then begin
                Error(BlockedNotValid);
            end;
            //----------------------Set values for each item----------------------
            rec_POInt."Batch Name" := G_BatchName;
            rec_POInt."Entry No." := EntryNo;
            rec_POInt."No." := NoStr;
            rec_POInt.Name := NameStr;
            rec_POInt."Search Name" := SearchNameStr;
            rec_POInt."Name 2" := Name2Str;
            rec_POInt.Address := AddressStr;
            rec_POInt."Address 2" := Address2Str;
            rec_POInt.City := CityStr;
            rec_POInt.Contact := ContactStr;
            rec_POInt."Phone No." := PhoneNoStr;
            rec_POInt."Global Dimension 1 Code" := GlobalDimension1CodeStr;
            rec_POInt."Global Dimension 2 Code" := GlobalDimension2CodeStr;
            rec_POInt."Customer Posting Group" := CustomerPostingGroupStr;
            rec_POInt."Currency Code" := CurrencyCodeStr;
            rec_POInt."Customer Price Group" := CustomerPriceGroupStr;
            rec_POInt."Language Code" := LanguageCodeStr;
            rec_POInt."Payment Terms Code" := PaymentTermsCodeStr;
            rec_POInt."Fin. Charge Terms Code" := FinChargeTermsCodeStr;
            rec_POInt."Salesperson Code" := SalespersonCodeStr;
            rec_POInt."Shipment Method Code" := ShipmentMethodCodeStr;
            rec_POInt."Shipping Agent Code" := ShippingAgentCodeStr;
            rec_POInt."Invoice Disc. Code" := InvoiceDiscCodeStr;
            rec_POInt."Country/Region Code" := CountryRegionCodeStr;
            rec_POInt."Collection Method" := CollectionMethodStr;
            rec_POInt."Print Statements" := PrintStatements;
            rec_POInt."Bill-to Customer No." := BilltoCustomerNoStr;
            rec_POInt."Payment Method Code" := PaymentMethodCodeStr;
            Evaluate(rec_POInt."Application Method", ApplicationMethodStr);
            rec_POInt."Prices Including VAT" := PricesIncludingVAT;
            rec_POInt."Location Code" := LocationCodeStr;
            rec_POInt."Fax No." := FaxNoStr;
            rec_POInt."VAT Registration No." := VATRegistrationNoStr;
            rec_POInt."Combine Shipments" := CombineShipments;
            rec_POInt."Gen. Bus. Posting Group" := GenBusPostingGroupStr;
            rec_POInt.GLN := GLNStr;
            rec_POInt."Post Code" := PostCodeStr;
            rec_POInt.County := CountyStr;
            rec_POInt."E-Mail" := EMailStr;
            rec_POInt."Home Page" := HomePageStr;
            rec_POInt."Reminder Terms Code" := ReminderTermsCodeStr;
            rec_POInt."No. Series" := NoSeriesStr;
            rec_POInt."Tax Area Code" := TaxAreaCodeStr;
            rec_POInt."Tax Liable" := TaxLiable;
            rec_POInt."VAT Bus. Posting Group" := VATBusPostingGroupStr;
            Evaluate(rec_POInt.Reserve, ReserveStr);
            rec_POInt."Block Payment Tolerance" := BlockPaymentTolerance;
            rec_POInt."IC Partner Code" := ICPartnerCodeStr;
            rec_POInt."Prepayment %" := Prepayment;
            Evaluate(rec_POInt."Partner Type", PartnerTypeStr);
            rec_POInt."Preferred Bank Account Code" := PreferredBankAccountCodeStr;
            rec_POInt."Cash Flow Payment Terms Code" := CashFlowPaymentTermsCodeStr;
            rec_POInt."Primary Contact No." := PrimaryContactNoStr;
            rec_POInt."Responsibility Center" := ResponsibilityCenterStr;
            Evaluate(rec_POInt."Shipping Advice", ShippingAdviceStr);
            rec_POInt."Shipping Time" := ShippingTime;
            rec_POInt."Shipping Agent Service Code" := ShippingAgentServiceCodeStr;
            rec_POInt."Service Zone Code" := ServiceZoneCodeStr;
            rec_POInt."Contract Gain/Loss Amount" := ContractGainLossAmount;
            rec_POInt."Allow Line Disc." := AllowLineDisc;
            Evaluate(rec_POInt."Copy Sell-to Addr. to Qte From", CopySelltoAddrtoQteFromStr);
            Evaluate(rec_POInt."Customer Type", CustomerTypeStr);
            rec_POInt."NEC OEM Code" := NECOEMCodeStr;
            rec_POInt."NEC OEM Name" := NECOEMNameStr;
            rec_POInt."Shipping Mark1" := ShippingMark1Str;
            rec_POInt."Shipping Mark2" := ShippingMark2Str;
            rec_POInt."Shipping Mark3" := ShippingMark3Str;
            rec_POInt."Shipping Mark4" := ShippingMark4Str;
            rec_POInt."Shipping Mark5" := ShippingMark5Str;
            rec_POInt.Remarks1 := Remarks1Str;
            rec_POInt.Remarks2 := Remarks2Str;
            rec_POInt.Remarks3 := Remarks3Str;
            rec_POInt.Remarks4 := Remarks4Str;
            rec_POInt.Remarks5 := Remarks5Str;
            Evaluate(rec_POInt."Item Supplier Source", ItemSupplierSourceStr);
            rec_POInt."Vendor Cust. Code" := VendorCustCodeStr;
            rec_POInt."Ship From Name" := ShipFromNameStr;
            rec_POInt."Ship From Address" := ShipFromAddressStr;
            rec_POInt.HQType := HQTypeStr;
            Evaluate(rec_POInt."Default Country/Region of Org", DefaultCountryRegionofOrgStr);
            Evaluate(rec_POInt."Price Update Target Date", PriceUpdateTargetDateStr);
            rec_POInt."ORE Customer Name" := ORECustomerNameStr;
            rec_POInt."ORE Address" := OREAddressStr;
            rec_POInt."ORE Address 2" := OREAddress2Str;
            rec_POInt."ORE City" := ORECityStr;
            rec_POInt."ORE State/Province" := OREStateProvinceStr;
            rec_POInt."Excluded in ORE Collection" := ExcludedinORECollection;
            rec_POInt."ORE Country" := ORECountryStr;
            rec_POInt."ORE Post Code" := OREPostCodeStr;
            rec_POInt."Customer Group" := CustomerGroupStr;
            rec_POInt."Familiar Name" := FamiliarNameStr;
            rec_POInt."Import File Ship To" := ImportFileShipToStr;
            rec_POInt."Receiving Location" := ReceivingLocationStr;
            rec_POInt."Days for Auto Inv. Reservation" := DaysforAutoInvReservation;
            Evaluate(rec_POInt.Blocked, BlockedStr);

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
