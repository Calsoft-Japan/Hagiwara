report 50118 "Vendor Export"
{
    // FDDN015 Bobby 2026/4/22 -Vendor Export

    ProcessingOnly = true;
    Caption = 'Vendor Export';
    ApplicationArea = All;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", "Name", Blocked;
            trigger OnPreDataItem()
            begin
                //Remove any existing data
                TempExcelBuffer.Reset();
                TempExcelBuffer.DeleteAll();

                //Init the data columns headers in the buffer
                TempExcelBuffer.AddColumn(EntryNo_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(No_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Name_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SearchName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Name2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Address_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Address2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(City_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Contact_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PhoneNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OurAccountNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GlobalDimension1Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GlobalDimension2Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VendorPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CurrencyCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LanguageCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(StatisticsGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaymentTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FinChargeTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaserCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShipmentMethodCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingAgentCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(InvoiceDiscCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CountryRegionCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoVendorNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaymentMethodCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ApplicationMethod_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PricesIncludingVAT_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FaxNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VATRegistrationNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GenBusPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GLN_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PostCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(County_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(EMail_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(HomePage_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(NoSeries_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TaxAreaCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TaxLiable_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VATBusPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BlockPaymentTolerance_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ICPartnerCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Prepayment_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PartnerType_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CreditorNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CashFlowPaymentTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PrimaryContactNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ResponsibilityCenter_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LocationCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LeadTimeCalculation_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(IDNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingTerms_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(IncotermCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(IncotermLocation_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ManufacturerCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREReverseRoutingAddress_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ExcludedInORECollection_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREReverseRoutingAddressSD_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(HagiwaraGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FamiliarName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoAddress_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoAddress2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoCity_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoPostCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoCounty_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaytoCountryRegionCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ExcludeCheck_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UpdatePOPriceTargetDate_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(IRS1099Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Blocked_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            end;

            trigger OnAfterGetRecord()
            var

            begin
                if not FormatOnly then begin
                    EntryNo := EntryNo + 1;

                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(EntryNo, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Vendor."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.Name, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Search Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Name 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.Address, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Address 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.City, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.Contact, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Our Account No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Vendor Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Language Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Statistics Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Fin. Charge Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Purchaser Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Shipment Method Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Shipping Agent Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Invoice Disc. Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Country/Region Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to Vendor No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Payment Method Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Application Method", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Prices Including VAT", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Fax No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."VAT Registration No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Gen. Bus. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.GLN, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Post Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.County, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."E-Mail", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Home Page", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."No. Series", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Tax Area Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Tax Liable", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."VAT Bus. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Block Payment Tolerance", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Vendor."IC Partner Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Prepayment %", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Vendor."Partner Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Creditor No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Cash Flow Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Primary Contact No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Responsibility Center", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Lead Time Calculation", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."ID No. KR", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Shipping Terms", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Incoterm Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Incoterm Location", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Manufacturer Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."ORE Reverse Routing Address", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Excluded in ORE Collection", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."ORE Reverse Routing Address SD", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Hagiwara Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Familiar Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to Address", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to Address 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to City", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to Post Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to County", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Pay-to Country/Region Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Exclude Check", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor."Update PO Price Target Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(Vendor."IRS 1099 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Vendor.Blocked, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                end;
            end;

            // After all real records processed, check if buffer is empty
            trigger OnPostDataItem()
            begin
                SheetName := 'Vendor';
                ExcelFileName := 'Vendor_%1';
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
    }

    var
        EntryNo: Integer;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FormatOnly: Boolean;
        SheetName: Text[50];
        ExcelFileName: Text[50];
        EntryNo_Lbl: Label '*Entry No.';
        No_Lbl: Label 'No.';
        Name_Lbl: Label '*Name';
        SearchName_Lbl: Label 'Search Name';
        Name2_Lbl: Label 'Name 2';
        Address_Lbl: Label 'Address';
        Address2_Lbl: Label 'Address 2';
        City_Lbl: Label 'City';
        Contact_Lbl: Label 'Contact';
        PhoneNo_Lbl: Label 'Phone No.';
        OurAccountNo_Lbl: Label 'Our Account No.';
        GlobalDimension1Code_Lbl: Label 'Global Dimension 1 Code';
        GlobalDimension2Code_Lbl: Label 'Global Dimension 2 Code';
        VendorPostingGroup_Lbl: Label 'Vendor Posting Group';
        CurrencyCode_Lbl: Label 'Currency Code';
        LanguageCode_Lbl: Label 'Language Code';
        StatisticsGroup_Lbl: Label 'Statistics Group';
        PaymentTermsCode_Lbl: Label 'Payment Terms Code';
        FinChargeTermsCode_Lbl: Label 'Fin. Charge Terms Code';
        PurchaserCode_Lbl: Label 'Purchaser Code';
        ShipmentMethodCode_Lbl: Label 'Shipment Method Code';
        ShippingAgentCode_Lbl: Label 'Shipping Agent Code';
        InvoiceDiscCode_Lbl: Label 'Invoice Disc. Code';
        CountryRegionCode_Lbl: Label 'Country/Region Code';
        PaytoVendorNo_Lbl: Label 'Pay-to Vendor No.';
        PaymentMethodCode_Lbl: Label 'Payment Method Code';
        ApplicationMethod_Lbl: Label '*Application Method';
        PricesIncludingVAT_Lbl: Label '*Prices Including VAT';
        FaxNo_Lbl: Label 'Fax No.';
        VATRegistrationNo_Lbl: Label 'VAT Registration No.';
        GenBusPostingGroup_Lbl: Label 'Gen. Bus. Posting Group';
        GLN_Lbl: Label 'GLN';
        PostCode_Lbl: Label 'Post Code';
        County_Lbl: Label 'County';
        EMail_Lbl: Label 'E-Mail';
        HomePage_Lbl: Label 'Home Page';
        NoSeries_Lbl: Label 'No. Series';
        TaxAreaCode_Lbl: Label 'Tax Area Code';
        TaxLiable_Lbl: Label '*Tax Liable';
        VATBusPostingGroup_Lbl: Label 'VAT Bus. Posting Group';
        BlockPaymentTolerance_Lbl: Label '*Block Payment Tolerance';
        ICPartnerCode_Lbl: Label 'IC Partner Code';
        Prepayment_Lbl: Label 'Prepayment %';
        PartnerType_Lbl: Label 'Partner Type';
        CreditorNo_Lbl: Label 'Creditor No.';
        CashFlowPaymentTermsCode_Lbl: Label 'Cash Flow Payment Terms Code';
        PrimaryContactNo_Lbl: Label 'Primary Contact No.';
        ResponsibilityCenter_Lbl: Label 'Responsibility Center';
        LocationCode_Lbl: Label 'Location Code';
        LeadTimeCalculation_Lbl: Label 'Lead Time Calculation';
        IDNo_Lbl: Label 'ID No.';
        ShippingTerms_Lbl: Label 'Shipping Terms';
        IncotermCode_Lbl: Label 'Incoterm Code';
        IncotermLocation_Lbl: Label 'Incoterm Location';
        ManufacturerCode_Lbl: Label 'Manufacturer Code';
        OREReverseRoutingAddress_Lbl: Label 'ORE Reverse Routing Address';
        ExcludedInORECollection_Lbl: Label '*Excluded in ORE Collection';
        OREReverseRoutingAddressSD_Lbl: Label 'ORE Reverse Routing Address SD';
        HagiwaraGroup_Lbl: Label 'Hagiwara Group';
        FamiliarName_Lbl: Label 'Familiar Name';
        PaytoAddress_Lbl: Label 'Pay-to Address';
        PaytoAddress2_Lbl: Label 'Pay-to Address 2';
        PaytoCity_Lbl: Label 'Pay-to City';
        PaytoPostCode_Lbl: Label 'Pay-to Post Code';
        PaytoCounty_Lbl: Label 'Pay-to County';
        PaytoCountryRegionCode_Lbl: Label 'Pay-to Country/Region Code';
        ExcludeCheck_Lbl: Label '*Exclude Check';
        UpdatePOPriceTargetDate_Lbl: Label 'Update PO Price Target Date';
        IRS1099Code_Lbl: Label 'IRS 1099 Code';
        Blocked_Lbl: Label 'Blocked';
}

