report 50119 "Customer Export"
{
    // FDDN014 Bobby 2026/4/22 -Customer Export

    //ProcessingOnly = true;
    RDLCLayout = './RDLC/CustomerExport.rdlc';

    Caption = 'Customer Export';
    //UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Customer Import Line"; "Customer Import Line")
        {
            UseTemporary = true;
            RequestFilterFields = "No.", "Name", "Item Supplier Source", "Vendor Cust. Code", Blocked;
            column(Entry_No_; "Entry No.") { }
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Search_Name; "Search Name") { }
            column(Name_2; "Name 2") { }
            column(Address; Address) { }
            column(Address_2; "Address 2") { }
            column(City; City) { }
            column(Contact; Contact) { }
            column(Phone_No_; "Phone No.") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Customer_Posting_Group; "Customer Posting Group") { }
            column(Currency_Code; "Currency Code") { }
            column(Customer_Price_Group; "Customer Price Group") { }
            column(Language_Code; "Language Code") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Fin_Charge_Terms_Code; "Fin. Charge Terms Code") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(Shipping_Agent_Code; "Shipping Agent Code") { }
            column(Invoice_Disc_Code; "Invoice Disc. Code") { }
            column(Country_Region_Code; "Country/Region Code") { }
            column(Collection_Method; "Collection Method") { }
            column(Print_Statements; "Print Statements") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(Application_Method; "Application Method") { }
            column(Prices_Including_VAT; "Prices Including VAT") { }
            column(Location_Code; "Location Code") { }
            column(Fax_No_; "Fax No.") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(Combine_Shipments; "Combine Shipments") { }
            column(Gen_Bus_Posting_Group; "Gen. Bus. Posting Group") { }
            column(GLN; GLN) { }
            column(Post_Code; "Post Code") { }
            column(County; County) { }
            column(E_Mail; "E-Mail") { }
            column(Home_Page; "Home Page") { }
            column(Reminder_Terms_Code; "Reminder Terms Code") { }
            column(No_Series; "No. Series") { }
            column(Tax_Area_Code; "Tax Area Code") { }
            column(Tax_Liable; "Tax Liable") { }
            column(VAT_Bus_Posting_Group; "VAT Bus. Posting Group") { }
            column(Reserve; Reserve) { }
            column(Block_Payment_Tolerance; "Block Payment Tolerance") { }
            column(IC_Partner_Code; "IC Partner Code") { }
            column(Prepayment_Pct; "Prepayment %") { }
            column(Partner_Type; "Partner Type") { }
            column(Cash_Flow_Payment_Terms_Code; "Cash Flow Payment Terms Code") { }
            column(Primary_Contact_No_; "Primary Contact No.") { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Shipping_Advice; "Shipping Advice") { }
            column(Shipping_Time; "Shipping Time") { }
            column(Shipping_Agent_Service_Code; "Shipping Agent Service Code") { }
            column(Service_Zone_Code; "Service Zone Code") { }
            column(Contract_Gain_Loss_Amount; "Contract Gain/Loss Amount") { }
            column(Allow_Line_Disc_; "Allow Line Disc.") { }
            column(Copy_Sell_to_Addr_to_Qte_From; "Copy Sell-to Addr. to Qte From") { }
            column(Customer_Type; "Customer Type") { }
            column(NEC_OEM_Code; "NEC OEM Code") { }
            column(NEC_OEM_Name; "NEC OEM Name") { }
            column(Shipping_Mark1; "Shipping Mark1") { }
            column(Shipping_Mark2; "Shipping Mark2") { }
            column(Shipping_Mark3; "Shipping Mark3") { }
            column(Shipping_Mark4; "Shipping Mark4") { }
            column(Shipping_Mark5; "Shipping Mark5") { }
            column(Remarks1; Remarks1) { }
            column(Remarks2; Remarks2) { }
            column(Remarks3; Remarks3) { }
            column(Remarks4; Remarks4) { }
            column(Remarks5; Remarks5) { }
            column(Item_Supplier_Source; "Item Supplier Source") { }
            column(Vendor_Cust_Code; "Vendor Cust. Code") { }
            column(Ship_From_Name; "Ship From Name") { }
            column(Ship_From_Address; "Ship From Address") { }
            column(HQType; HQType) { }
            column(Default_Country_Region_of_Org; "Default Country/Region of Org") { }
            column(Price_Update_Target_Date; "Price Update Target Date") { }
            column(ORE_Customer_Name; "ORE Customer Name") { }
            column(ORE_Address; "ORE Address") { }
            column(ORE_Address_2; "ORE Address 2") { }
            column(ORE_City; "ORE City") { }
            column(ORE_State_Province; "ORE State/Province") { }
            column(Excluded_in_ORE_Collection; "Excluded in ORE Collection") { }
            column(ORE_Country; "ORE Country") { }
            column(ORE_Post_Code; "ORE Post Code") { }
            column(Customer_Group; "Customer Group") { }
            column(Familiar_Name; "Familiar Name") { }
            column(Import_File_Ship_To; "Import File Ship To") { }
            column(Receiving_Location; "Receiving Location") { }
            column(Days_for_Auto_Inv_Reservation; "Days for Auto Inv. Reservation") { }
            column(Blocked; Blocked) { }
            column(Status; Status) { }
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

    trigger OnPreReport()
    var
        recItemImpLn: Record "Customer Import Line";
    begin
        if FormatOnly then begin
            "Customer Import Line".Init();
            "Customer Import Line".Insert();
        end else begin
            recItemImpLn.CopyFilters("Customer Import Line");

            if BatchNameIntFilter <> '' then begin
                recItemImpLn.SetRange("Batch Name", BatchNameIntFilter);
            end;
            if recItemImpLn.FindSet() then begin
                repeat
                    "Customer Import Line".Init();
                    "Customer Import Line".TransferFields(recItemImpLn);
                    "Customer Import Line".Insert();
                until recItemImpLn.Next() = 0;
            end else begin
                "Customer Import Line".Init();
                "Customer Import Line".Insert();
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

