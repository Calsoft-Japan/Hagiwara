report 50118 "Vendor Export"
{
    // FDDN015 Bobby 2026/4/22 -Vendor Export

    //ProcessingOnly = true;
    RDLCLayout = './RDLC/VendorExport.rdlc';

    Caption = 'Vendor Export';
    //UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Vendor Import Line"; "Vendor Import Line")
        {
            UseTemporary = true;
            RequestFilterFields = "No.", "Name", Blocked;
            column(Entry_No_; "Entry No.") { }
            column(No_; "No.") { }
            column(Name; "Name") { }
            column(Search_Name; "Search Name") { }
            column(Name_2; "Name 2") { }
            column(Address; "Address") { }
            column(Address_2; "Address 2") { }
            column(City; "City") { }
            column(Contact; "Contact") { }
            column(Phone_No_; "Phone No.") { }
            column(Our_Account_No_; "Our Account No.") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Vendor_Posting_Group; "Vendor Posting Group") { }
            column(Currency_Code; "Currency Code") { }
            column(Language_Code; "Language Code") { }
            column(Statistics_Group; "Statistics Group") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Fin_Charge_Terms_Code; "Fin. Charge Terms Code") { }
            column(Purchaser_Code; "Purchaser Code") { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(Invoice_Disc_Code; "Invoice Disc. Code") { }
            column(Country_Region_Code; "Country/Region Code") { }
            column(Pay_to_Vendor_No_; "Pay-to Vendor No.") { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(Application_Method; "Application Method") { }
            column(Prices_Including_VAT; "Prices Including VAT") { }
            column(Fax_No_; "Fax No.") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group") { }
            column(GLN; "GLN") { }
            column(Post_Code; "Post Code") { }
            column(County; "County") { }
            column(E_Mail; "E-Mail") { }
            column(Home_Page; "Home Page") { }
            column(No_Series; "No. Series") { }
            column(Tax_Area_Code; "Tax Area Code") { }
            column(Tax_Liable; "Tax Liable") { }
            column(VAT_Bus_Posting_Group; "VAT Bus. Posting Group") { }
            column(Block_Payment_Tolerance; "Block Payment Tolerance") { }
            column(IC_Partner_Code; "IC Partner Code") { }
            column(Prepayment_Pct; "Prepayment %") { }
            column(Partner_Type; "Partner Type") { }
            column(Creditor_No_; "Creditor No.") { }
            column(Cash_Flow_Payment_Terms_Code; "Cash Flow Payment Terms Code") { }
            column(Primary_Contact_No_; "Primary Contact No.") { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Location_Code; "Location Code") { }
            column(Lead_Time_Calculation; "Lead Time Calculation") { }
            column(ID_No_; "ID No.") { }
            column(Shipping_Terms; "Shipping Terms") { }
            column(Incoterm_Code; "Incoterm Code") { }
            column(Incoterm_Location; "Incoterm Location") { }
            column(Manufacturer_Code; "Manufacturer Code") { }
            column(ORE_Reverse_Routing_Address; "ORE Reverse Routing Address") { }
            column(Excluded_in_ORE_Collection; "Excluded in ORE Collection") { }
            column(ORE_Reverse_Routing_Address_SD; "ORE Reverse Routing Address SD") { }
            column(Hagiwara_Group; "Hagiwara Group") { }
            column(Familiar_Name; "Familiar Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Pay_to_City; "Pay-to City") { }
            column(Pay_to_Post_Code; "Pay-to Post Code") { }
            column(Pay_to_County; "Pay-to County") { }
            column(Pay_to_Country_Region_Code; "Pay-to Country/Region Code") { }
            column(Exclude_Check; "Exclude Check") { }
            column(Update_PO_Price_Target_Date; "Update PO Price Target Date") { }
            column(IRS_1099_Code; "IRS 1099 Code") { }
            column(Blocked; "Blocked") { }
            column(Status; "Status") { }
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
        recItemImpLn: Record "Vendor Import Line";
    begin
        if FormatOnly then begin
            "Vendor Import Line".Init();
            "Vendor Import Line".Insert();
        end else begin
            recItemImpLn.CopyFilters("Vendor Import Line");

            if BatchNameIntFilter <> '' then begin
                recItemImpLn.SetRange("Batch Name", BatchNameIntFilter);
            end;
            if recItemImpLn.FindSet() then begin
                repeat
                    "Vendor Import Line".Init();
                    "Vendor Import Line".TransferFields(recItemImpLn);
                    "Vendor Import Line".Insert();
                until recItemImpLn.Next() = 0;
            end else begin
                "Vendor Import Line".Init();
                "Vendor Import Line".Insert();
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

