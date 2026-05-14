report 50119 "Customer Export"
{
    // FDDN014 Bobby 2026/4/22 -Customer Export

    ProcessingOnly = true;
    Caption = 'Customer Export';
    ApplicationArea = All;
    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Name", "Item Supplier Source", "Vendor Cust. Code", Blocked;

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
                TempExcelBuffer.AddColumn(GlobalDimension1Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GlobalDimension2Code_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CurrencyCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerPriceGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LanguageCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaymentTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FinChargeTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalespersonCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShipmentMethodCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingAgentCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(InvoiceDiscCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CountryRegionCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CollectionMethod_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PrintStatements_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BilltoCustomerNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PaymentMethodCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ApplicationMethod_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PricesIncludingVAT_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(LocationCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FaxNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VATRegistrationNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CombineShipments_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GenBusPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GLN_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PostCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(County_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(EMail_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(HomePage_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ReminderTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(NoSeries_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TaxAreaCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TaxLiable_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VATBusPostingGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Reserve_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(BlockPaymentTolerance_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ICPartnerCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PrepaymentPct_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PartnerType_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CashFlowPaymentTermsCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PrimaryContactNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ResponsibilityCenter_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingAdvice_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingTime_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingAgentServiceCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ServiceZoneCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ContractGainLossAmount_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AllowLineDisc_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CopySelltoAddrtoQteFrom_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerType_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(NECOEMCode_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(NECOEMName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingMark1_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingMark2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingMark3_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingMark4_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShippingMark5_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Remarks1_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Remarks2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Remarks3_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Remarks4_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Remarks5_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ItemSupplierSource_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VendorCustCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShipFromName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShipFromAddress_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(HQType_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(DefaultCountryRegionOfOrg_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PriceUpdateTargetDate_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ORECustomerName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREAddress_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREAddress2_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ORECity_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREStateProvince_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ExcludedInORECollection_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ORECountry_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREPostCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerGroup_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FamiliarName_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ImportFileShipTo_Lbl, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ReceivingLocation_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(DaysForAutoInvReservation_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Blocked_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            end;

            trigger OnAfterGetRecord()
            var

            begin
                if not FormatOnly then begin
                    EntryNo := EntryNo + 1;

                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(EntryNo, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Customer."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Name, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Search Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Name 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Address, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Address 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.City, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Contact, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Customer Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Customer Price Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Language Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Fin. Charge Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Salesperson Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipment Method Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Agent Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Invoice Disc. Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Country/Region Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Collection Method", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Print Statements", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Bill-to Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Payment Method Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Application Method", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Prices Including VAT", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Fax No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."VAT Registration No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Combine Shipments", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Gen. Bus. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.GLN, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Post Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.County, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."E-Mail", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Home Page", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Reminder Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."No. Series", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Tax Area Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Tax Liable", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."VAT Bus. Posting Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Reserve, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Block Payment Tolerance", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."IC Partner Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Prepayment %", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Customer."Partner Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Cash Flow Payment Terms Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Primary Contact No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Responsibility Center", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Advice", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Time", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Customer."Shipping Agent Service Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Service Zone Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Contract Gain/Loss Amount", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Customer."Allow Line Disc.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Copy Sell-to Addr. to Qte From", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Customer Type", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."NEC OEM Code", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."NEC OEM Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Mark1", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Mark2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Mark3", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Mark4", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Shipping Mark5", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Remarks1, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Remarks2, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Remarks3, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Remarks4, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.Remarks5, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Item Supplier Source", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Vendor Cust. Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Ship From Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Ship From Address", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer.HQType, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Default Country/Region of Org", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Update SO Price Target Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(Customer."ORE Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."ORE Address", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."ORE Address 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."ORE City", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."ORE State/Province", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Excluded in ORE Collection", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."ORE Country", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."ORE Post Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Customer Group", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Familiar Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Import File Ship To", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Receiving Location", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(Customer."Days for Auto Inv. Reservation", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(Customer.Blocked, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                end;
            end;

            // After all real records processed, check if buffer is empty
            trigger OnPostDataItem()
            begin
                SheetName := 'Customer';
                ExcelFileName := 'Customer_%1';
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
        GlobalDimension1Code_Lbl: Label 'Global Dimension 1 Code';
        GlobalDimension2Code_Lbl: Label 'Global Dimension 2 Code';
        CustomerPostingGroup_Lbl: Label 'Customer Posting Group';
        CurrencyCode_Lbl: Label 'Currency Code';
        CustomerPriceGroup_Lbl: Label 'Customer Price Group';
        LanguageCode_Lbl: Label 'Language Code';
        PaymentTermsCode_Lbl: Label 'Payment Terms Code';
        FinChargeTermsCode_Lbl: Label 'Fin. Charge Terms Code';
        SalespersonCode_Lbl: Label 'Salesperson Code';
        ShipmentMethodCode_Lbl: Label 'Shipment Method Code';
        ShippingAgentCode_Lbl: Label 'Shipping Agent Code';
        InvoiceDiscCode_Lbl: Label 'Invoice Disc. Code';
        CountryRegionCode_Lbl: Label 'Country/Region Code';
        CollectionMethod_Lbl: Label 'Collection Method';
        PrintStatements_Lbl: Label '*Print Statements';
        BilltoCustomerNo_Lbl: Label 'Bill-to Customer No.';
        PaymentMethodCode_Lbl: Label 'Payment Method Code';
        ApplicationMethod_Lbl: Label '*Application Method';
        PricesIncludingVAT_Lbl: Label '*Prices Including VAT';
        LocationCode_Lbl: Label 'Location Code';
        FaxNo_Lbl: Label 'Fax No.';
        VATRegistrationNo_Lbl: Label 'VAT Registration No.';
        CombineShipments_Lbl: Label '*Combine Shipments';
        GenBusPostingGroup_Lbl: Label 'Gen. Bus. Posting Group';
        GLN_Lbl: Label 'GLN';
        PostCode_Lbl: Label 'Post Code';
        County_Lbl: Label 'County';
        EMail_Lbl: Label 'E-Mail';
        HomePage_Lbl: Label 'Home Page';
        ReminderTermsCode_Lbl: Label 'Reminder Terms Code';
        NoSeries_Lbl: Label 'No. Series';
        TaxAreaCode_Lbl: Label 'Tax Area Code';
        TaxLiable_Lbl: Label '*Tax Liable';
        VATBusPostingGroup_Lbl: Label 'VAT Bus. Posting Group';
        Reserve_Lbl: Label '*Reserve';
        BlockPaymentTolerance_Lbl: Label '*Block Payment Tolerance';
        ICPartnerCode_Lbl: Label 'IC Partner Code';
        PrepaymentPct_Lbl: Label 'Prepayment %';
        PartnerType_Lbl: Label 'Partner Type';
        CashFlowPaymentTermsCode_Lbl: Label 'Cash Flow Payment Terms Code';
        PrimaryContactNo_Lbl: Label 'Primary Contact No.';
        ResponsibilityCenter_Lbl: Label 'Responsibility Center';
        ShippingAdvice_Lbl: Label 'Shipping Advice';
        ShippingTime_Lbl: Label '*Shipping Time';
        ShippingAgentServiceCode_Lbl: Label 'Shipping Agent Service Code';
        ServiceZoneCode_Lbl: Label 'Service Zone Code';
        ContractGainLossAmount_Lbl: Label 'Contract Gain/Loss Amount';
        AllowLineDisc_Lbl: Label 'Allow Line Disc.';
        CopySelltoAddrtoQteFrom_Lbl: Label '*Copy Sell-to Addr. to Qte From';
        CustomerType_Lbl: Label '*Customer Type';
        NECOEMCode_Lbl: Label '*NEC OEM Code';
        NECOEMName_Lbl: Label 'NEC OEM Name';
        ShippingMark1_Lbl: Label 'Shipping Mark1';
        ShippingMark2_Lbl: Label 'Shipping Mark2';
        ShippingMark3_Lbl: Label 'Shipping Mark3';
        ShippingMark4_Lbl: Label 'Shipping Mark4';
        ShippingMark5_Lbl: Label 'Shipping Mark5';
        Remarks1_Lbl: Label 'Remarks1';
        Remarks2_Lbl: Label 'Remarks2';
        Remarks3_Lbl: Label 'Remarks3';
        Remarks4_Lbl: Label 'Remarks4';
        Remarks5_Lbl: Label 'Remarks5';
        ItemSupplierSource_Lbl: Label 'Item Supplier Source';
        VendorCustCode_Lbl: Label 'Vendor Cust. Code';
        ShipFromName_Lbl: Label 'Ship From Name';
        ShipFromAddress_Lbl: Label 'Ship From Address';
        HQType_Lbl: Label 'HQType';
        DefaultCountryRegionOfOrg_Lbl: Label 'Default Country/Region of Org';
        PriceUpdateTargetDate_Lbl: Label 'Price Update Target Date';
        ORECustomerName_Lbl: Label 'ORE Customer Name';
        OREAddress_Lbl: Label 'ORE Address';
        OREAddress2_Lbl: Label 'ORE Address 2';
        ORECity_Lbl: Label 'ORE City';
        OREStateProvince_Lbl: Label 'ORE State/Province';
        ExcludedInORECollection_Lbl: Label 'Excluded in ORE Collection';
        ORECountry_Lbl: Label '*ORE Country';
        OREPostCode_Lbl: Label 'ORE Post Code';
        CustomerGroup_Lbl: Label 'Customer Group';
        FamiliarName_Lbl: Label 'Familiar Name';
        ImportFileShipTo_Lbl: Label '*Import File Ship To';
        ReceivingLocation_Lbl: Label 'Receiving Location';
        DaysForAutoInvReservation_Lbl: Label 'Days for Auto Inv. Reservation';
        Blocked_Lbl: Label 'Blocked';
}

