codeunit 50014 "DWH Export"
{
    // CS045 Survey 2022/11/18 - Export Files for DWH/Takt
    // CS051 Kenya 2023/03/06 - Tact Interface
    // CS052 Kenya 2023/04/30 - Modification of DWH/Takt Interface
    // CS059 Leon 2023/08/24 - Add a new field of ‘Order Deadline Date’
    // CS063 Kenya 2023/09/29 - Fix Value Entry for deleted Purch. Rcpt. Header
    // CS064 Kenya 2023/10/05 - Inventory Last Month/Week
    // CS065 Kenya 2023/11/06 - Cost Price on Sales Shipment
    // CS071 Bobby 2024/03/12 - Add filter condition to get records
    // CS074 Bobby 2024/08/09 - Add new columns to the existing Customer file, add a new file 'Ship And Debit Flag'  and add filter condition to the existing Purch Price file
    // CS085 Naoto 2024/10/26 - Remove unnecessary condition in PurchasePrice and add a new condition in ShipAndDebitFlag
    // CS086 Shawn 2024/11/21 - DWH Export Modification.
    //                          Round to 0.00001: Sales Shipment (Cost Amount), Purchase Lines (Outstanding Amount)
    //                          Output items even if there aren’t ILE data: Inventory.
    // CS093 Naoto 2025/01/17 - Change the order of column for Outstanding Purchase Order
    // CS107 Naoto 2025/05/14 - Change the logic to fetch Purchase Price records 
    ///CS110 NieRM 2025/06/24 - Output [Item Supplier Source] for Customer and Output [Original Item No.] for ShipAndDebitFlag 
    // #################################################################
    // # For SH & HS, modify codes 'For SH' and 'For HS' after import. #
    // #################################################################


    trigger OnRun()
    var
    begin
        BEGIN
            tabPlaceholder := 't@bPlaceholder';
            tabChr := 9;
            lineChr := 10;
            lineChr2 := 13;
            tabChar := FORMAT(tabChr);
            lineChar := FORMAT(lineChr);
            lineChar2 := FORMAT(lineChr2);
            curCompany.GET();
            curCountryRegionCode := curCompany."Country/Region Code";
            GeneralLedgerSetupRec.GET();
            BaseDate := CALCDATE('-' + FORMAT(GeneralLedgerSetupRec."Historical Data Period"), TODAY);

            DeleteDataInBuffer();

            ExportCustomer();
            ExportVendor();
            ExportItem();
            ExportSalesPrice();
            ExportPurchasePrice();
            ExportCustomerItemNumber();
            //ExportCurrencyExchangeRate();
            ExportSalesQuote();
            ExportOutstandingSalesOrder();
            ExportSalesShipment();
            ExportOutstandingPurchaseOrder();
            ExportPurchaseLines();
            ExportPurchaseReceipt();
            ExportInventory();
            ExportValueEntry();
            ExportShipAndDebitFlag();//CS074

            //CS064 Begin
            ExportInventoryLastMonth();
            IF EVALUATE(VarInteger, GeneralLedgerSetupRec."Day of Week for Inv. Last Week") THEN BEGIN
                IF VarInteger = DATE2DWY(TODAY, 1) THEN
                    ExportInventoryLastWeek();
            END;
            //CS064 Begin
            MarkerToFile();

        END;
    end;

    var
        SaveString: Text;
        curCompany: Record "Company Information";
        curCountryRegionCode: Text[100];
        tabPlaceholder: Text[100];
        tabChr: Char;
        lineChr: Char;
        lineChr2: Char;
        tabChar: Text[10];
        lineChar: Text[10];
        lineChar2: Text[10];
        myFile: File;
        GeneralLedgerSetupRec: Record "General Ledger Setup";
        BaseDate: Date;
        VarInteger: Integer;
        InventoryBaseDate: Date;


        DataName: Text[50];
        Const_DN_Customer: Label 'Customer';
        Const_DN_Vendor: Label 'Vendor';
        Const_DN_Item: Label 'Item';
        Const_DN_SalesPrice: Label 'SalesPrice';
        Const_DN_PurchasePrice: Label 'PurchasePrice';
        Const_DN_CustomerItemNumber: Label 'CustomerItemNumber';
        Const_DN_SalesQuote: Label 'SalesQuote';
        Const_DN_OutstandingSalesOrder: Label 'OutstandingSalesOrder';
        Const_DN_SalesShipment: Label 'SalesShipment';
        Const_DN_OutstandingPurchaseOrder: Label 'OutstandingPurchaseOrder';
        Const_DN_PurchaseLines: Label 'PurchaseLines';
        Const_DN_PurchaseReceipt: Label 'PurchaseReceipt';
        Const_DN_Inventory: Label 'Inventory';
        Const_DN_ValueEntry: Label 'ValueEntry';
        Const_DN_ShipAndDebitFlag: Label 'ShipAndDebitFlag';
        Const_DN_InventoryLastMonth: Label 'InventoryLastMonth';
        Const_DN_InventoryLastWeek: Label 'InventoryLastWeek';
        Const_DN_Marker: Label 'Marker';


    local procedure ExportCustomer()
    var
        FileName: Text[200];
        CustomerRec: Record "Customer";
    begin
        DataName := Const_DN_Customer;
        SaveString := '';
        CustomerRec.RESET();
        //IF CustomerRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Cust. Code';
            //CS074 Begin
            SaveString := SaveString + FORMAT(tabChar) + 'ORE Customer Name';
            //CS110 Begin
            //SaveString := SaveString + FORMAT(tabChar) + 'Spare1';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            //CS110 End
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare6';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare7';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare8';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare9';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare10';
            //CS074 End
            InsertDataInBuffer();
            IF CustomerRec.FIND('-') THEN //CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec."No.";
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec."Familiar Name"; //CS052
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec."Vendor Cust. Code";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec."ORE Customer Name";//CS074
                    //CS110 Begin
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(CustomerRec."Item Supplier Source");
                    //CS110 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CS074

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL CustomerRec.NEXT() = 0;

        END;
    end;

    local procedure ExportVendor()
    var
        FileName: Text[200];
        VendorRec: Record Vendor;
    begin
        DataName := Const_DN_Vendor;
        VendorRec.RESET();

        //IF VendorRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Maker Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Priority Flag';

            InsertDataInBuffer();

            IF VendorRec.FIND('-') THEN //CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + VendorRec."Manufacturer Code";//CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + VendorRec."No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + VendorRec.Name;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Priority Flag

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL VendorRec.NEXT() = 0;


        END;
    end;

    local procedure ExportItem()
    var
        FileName: Text[200];
        ItemRec: Record Item;
        availableInventoryBalance: Decimal;
        SalesShipmentLineRec: Record "Sales Shipment Line";
        SalesShipmentHeaderRec: Record "Sales Shipment Header";
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        SalesInvoiceHeaderRec: Record "Sales Invoice Header";
    begin
        DataName := Const_DN_Item;
        ItemRec.RESET();
        ItemRec.SETRANGE(Blocked, FALSE);//CS071
        //IF ItemRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Maker Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Maker Code';
            SaveString := SaveString + FORMAT(tabChar) + 'EOL';
            SaveString := SaveString + FORMAT(tabChar) + 'EOL Last Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Category Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Category 1';
            SaveString := SaveString + FORMAT(tabChar) + 'Category 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Category 3';
            SaveString := SaveString + FORMAT(tabChar) + 'Class 1';
            SaveString := SaveString + FORMAT(tabChar) + 'Class 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Class 3';
            SaveString := SaveString + FORMAT(tabChar) + 'SPQ';
            SaveString := SaveString + FORMAT(tabChar) + 'MOQ';
            SaveString := SaveString + FORMAT(tabChar) + 'MPQ';
            SaveString := SaveString + FORMAT(tabChar) + 'Cancellable Days';
            SaveString := SaveString + FORMAT(tabChar) + 'Cancel Condition';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Period';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Lead Time';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Condition Flag';
            SaveString := SaveString + FORMAT(tabChar) + 'Auto Order Flag';
            SaveString := SaveString + FORMAT(tabChar) + 'MIV Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'MIV';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Last Direct Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Tariff No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Blocked';
            SaveString := SaveString + FORMAT(tabChar) + 'Country/Region of Origin Code (Back-end)';
            SaveString := SaveString + FORMAT(tabChar) + 'Products';
            SaveString := SaveString + FORMAT(tabChar) + 'Rank';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Country/Region of Origin Code (Front-end)';
            SaveString := SaveString + FORMAT(tabChar) + 'Inventory';
            SaveString := SaveString + FORMAT(tabChar) + 'Hold';
            SaveString := SaveString + FORMAT(tabChar) + 'Inventory Balance';
            SaveString := SaveString + FORMAT(tabChar) + 'Available Inventory Balance';
            SaveString := SaveString + FORMAT(tabChar) + 'Qty on Purch. Order';
            SaveString := SaveString + FORMAT(tabChar) + 'Qty on Sales Quote';
            SaveString := SaveString + FORMAT(tabChar) + 'Qty on Sales Order';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Last Unit Cost Calc. Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer No.';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF ItemRec.FIND('-') THEN //CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description;//Name;
                                                                                            //CS052 Start
                    IF ItemRec."Vendor Item No." = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description//Maker Item Name;
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Item No.";//Maker Item Name //CS051
                                                                                                      //CS052 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";
                    IF ItemRec.EOL THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + 'False';

                    /* //CS059 Begin
                    SalesInvoiceLineRec.RESET();
                    SalesInvoiceLineRec.SETRANGE(Type, SalesInvoiceLineRec.Type::Item);
                    SalesInvoiceLineRec.SETFILTER("No.", '%1',ItemRec."No.");
                    SalesInvoiceLineRec.SETFILTER(Quantity, '>0');
                    SalesInvoiceLineRec.SETCURRENTKEY("Posting Date","Shipment Date");
                    SalesInvoiceLineRec.SETASCENDING("Posting Date",FALSE);
                    SalesInvoiceLineRec.SETASCENDING("Shipment Date",FALSE);
                    IF SalesInvoiceLineRec.FIND('-') THEN BEGIN
                      SalesInvoiceHeaderRec.GET(SalesInvoiceLineRec."Document No.");
                      IF SalesInvoiceHeaderRec."Order No." <> '' THEN BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesInvoiceHeaderRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//ItemRec."EOL Last Order Date"
                      END
                      ELSE BEGIN
                        IF SalesInvoiceLineRec."Shipment No." <> '' THEN BEGIN
                          //SalesShipmentLineRec.GET(SalesInvoiceLineRec."Shipment No.",SalesInvoiceLineRec."Shipment Line No.");
                          SalesShipmentHeaderRec.GET(SalesInvoiceLineRec."Shipment No.");
                          SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentHeaderRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//ItemRec."EOL Last Order Date"
                        END
                        ELSE
                          SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."EOL Last Order Date";
                      END;
                    END*/
                    IF ItemRec."Order Deadline Date" <> 0D THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Order Deadline Date", 0, '<Year4>/<Month,2>/<Day,2>')//ItemRec."EOL Last Order Date"
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."EOL Last Order Date";
                                                                               //CS059 End

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."Category Code";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."Category 1";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."Category 2";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."Category 3";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Rank;//ItemRec."Class 1"; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."Class 2";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec."Class 3";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '1';//ItemRec.SPQ; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Order Multiple");//CS071
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.MPQ;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.Cancellable Days;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.Cancel Condition;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Safety Lead Time");//ItemRec.Order Period;//CS071
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Lead Time Calculation");//ItemRec.Order Lead Time;//CS071
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.Order Condition Flag;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.Auto Order Flag;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.MIV Currency;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//ItemRec.MIV;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Unit Price");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Unit Cost");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Last Direct Cost");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Item No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Tariff No.";
                    IF ItemRec.Blocked THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + 'False';
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Country/Region of Origin Code";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Products;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Rank;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Item Supplier Source");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Country/Region of Org Cd (FE)";

                    //BC Update Begin
                    /*
                    //For SH
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Country/Region of Org Cd (FE)";
                    ItemRec.CALCFIELDS(Inventory);
                    ItemRec.CALCFIELDS(Hold);
                    ItemRec.CALCFIELDS("Qty. on Purch. Order");
                    ItemRec.CALCFIELDS("Qty. on Sales Quote");
                    ItemRec.CALCFIELDS("Qty. on Sales Order");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Inventory);

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Hold);
                    //For HS
                    ItemRec.CALCFIELDS("Inventory L1");
                    ItemRec.CALCFIELDS("Inventory L2");
                    ItemRec.CALCFIELDS(Office_L);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Inventory - ItemRec."Inventory L1" - ItemRec."Inventory L2" - ItemRec.Office_L); //CS051

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Inventory);// + ItemRec."Inventory Balance";

                    //availableInventoryBalance := ItemRec.Inventory - ItemRec.Hold;
                    //For HS
                    availableInventoryBalance := ItemRec."Inventory L1" + ItemRec."Inventory L2" + ItemRec.Office_L; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(availableInventoryBalance);
                    */

                    ItemRec.CALCFIELDS(Inventory, Hold, "Qty. on Purch. Order", "Qty. on Sales Quote", "Qty. on Sales Order");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Inventory);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Hold);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Inventory);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec.Inventory - ItemRec.Hold);
                    //BC Update End

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Qty. on Purch. Order");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Qty. on Sales Quote");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Qty. on Sales Order");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Customer Item No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Vendor No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Last Unit Cost Calc. Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Customer No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."OEM No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL ItemRec.NEXT() = 0;


        END;

    end;

    local procedure ExportSalesPrice()
    var
        FileName: Text[200];
        SalesPriceRec: Record "Price List Line";
        itemRec: Record Item;
    begin
        DataName := Const_DN_SalesPrice;
        SalesPriceRec.RESET();
        //IF SalesPriceRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Maker Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Currency Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Rank Low';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Rank High';
            SaveString := SaveString + FORMAT(tabChar) + 'Applied From';
            SaveString := SaveString + FORMAT(tabChar) + 'Applied To';
            SaveString := SaveString + FORMAT(tabChar) + 'Registration Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();

            SalesPriceRec.SetRange("Price Type", SalesPriceRec."Price Type"::Sale);
            SalesPriceRec.SetRange(Status, SalesPriceRec.Status::Active);
            IF SalesPriceRec.FIND('-') THEN//CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    itemRec.GET(SalesPriceRec."Asset No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + itemRec."Manufacturer Code";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesPriceRec."Asset No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '3';//SalesPriceRec."Customer Group"; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesPriceRec."Assign-to No.";//Customer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + itemRec."OEM No.";
                    IF SalesPriceRec."Currency Code" = ''
                      THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + SalesPriceRec."Currency Code";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//SalesPriceRec.Quantity Rank Low;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//SalesPriceRec.Quantity Rank HigSSh
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesPriceRec."Starting Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesPriceRec."Ending Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//SalesPriceRec.Registration Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesPriceRec."Unit Price");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + itemRec."Vendor No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL SalesPriceRec.NEXT() = 0;


        END;
    end;

    local procedure ExportPurchasePrice()
    var
        FileName: Text[200];
        PurchasePriceRec: Record "Price List Line";
        itemRec: Record Item;
        itemRec2: Record Item;
    begin
        DataName := Const_DN_PurchasePrice;
        PurchasePriceRec.RESET();
        //IF PurchasePriceRec.FIND('-') THEN CS059
        //itemRec2.RESET();//CS074 //CS085
        //itemRec2.SETRANGE("One Renesas EDI",TRUE);//CS074 //CS085
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Maker Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Currency Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Rank Low';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Rank High';
            SaveString := SaveString + FORMAT(tabChar) + 'Applied From';
            SaveString := SaveString + FORMAT(tabChar) + 'Applied To';
            //SaveString := SaveString + FORMAT(tabChar) + 'Registration Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Purchase Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();

            //CS074
            IF itemRec2.FIND('-') THEN
                REPEAT
                    PurchasePriceRec.SetRange("Price Type", PurchasePriceRec."Price Type"::Purchase);
                    PurchasePriceRec.SetRange(Status, PurchasePriceRec.Status::Active);
                    PurchasePriceRec.SETRANGE("Asset No.", itemRec2."No.");
                    IF PurchasePriceRec.FIND('-') THEN//CS059
                        REPEAT
                            SaveString := curCountryRegionCode;
                            itemRec.GET(PurchasePriceRec."Asset No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + itemRec."Manufacturer Code";//'Maker Code'
                            SaveString := SaveString + FORMAT(tabPlaceholder) + PurchasePriceRec."Asset No.";
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '3';//PurchasePriceRec."Customer Group"; //CS051
                            SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + itemRec."Customer No." + ';' + itemRec."OEM No.";//Customer Inventory Group //CS051
                            SaveString := SaveString + FORMAT(tabPlaceholder) + itemRec."Customer No.";//PurchasePriceRec."Purchase Code";//Customer Code
                            SaveString := SaveString + FORMAT(tabPlaceholder) + itemRec."OEM No.";
                            IF PurchasePriceRec."Currency Code" = ''
                              THEN
                                SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code" //Original Currency
                            ELSE
                                SaveString := SaveString + FORMAT(tabPlaceholder) + PurchasePriceRec."Currency Code";//Original Currency
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//PurchasePriceRec.Quantity Rank Low;
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//PurchasePriceRec.Quantity Rank High
                            SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchasePriceRec."Starting Date", 0, '<Year4>/<Month,2>/<Day,2>');
                            SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchasePriceRec."Ending Date", 0, '<Year4>/<Month,2>/<Day,2>');
                            SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchasePriceRec."Direct Unit Cost");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + PurchasePriceRec."Assign-to No.";
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                            SaveString := ReplaceString(SaveString, tabChar, '');
                            SaveString := ReplaceString(SaveString, lineChar, '');
                            SaveString := ReplaceString(SaveString, lineChar2, '');
                            SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);
                            InsertDataInBuffer();
                        UNTIL PurchasePriceRec.NEXT() = 0;
                UNTIL itemRec2.NEXT() = 0;

            //CS074

        END;
    end;

    local procedure ExportCustomerItemNumber()
    var
        FileName: Text[200];
        CustomerItemNumberRec: Record Item;
    begin
        DataName := Const_DN_CustomerItemNumber;
        CustomerItemNumberRec.RESET();
        //IF CustomerItemNumberRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Priority Flag';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Salesperson';

            InsertDataInBuffer();
            IF CustomerItemNumberRec.FIND('-') THEN//CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerItemNumberRec."Customer No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerItemNumberRec."OEM No.";//End Customer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerItemNumberRec."Customer Item No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerItemNumberRec."No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Priority Flag
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + CustomerItemNumberRec."Customer No." + ';' + CustomerItemNumberRec."OEM No.";//Customer Inventory Group //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//Salesperson //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL CustomerItemNumberRec.NEXT() = 0;


        END;
    end;

    local procedure ExportSalesQuote()
    var
        FileName: Text[200];
        SalesQuoteRec: Record "Sales Line";
        ItemRec: Record Item;
        SalesHeaderRec: Record "Sales Header";
        CustomerRec: Record Customer;
    begin
        DataName := Const_DN_SalesQuote;
        SaveString := '';
        SalesQuoteRec.RESET();
        SalesQuoteRec.SETRANGE("Document Type", SalesQuoteRec."Document Type"::Quote);
        SalesQuoteRec.SETFILTER(Type, '<>0');
        SalesQuoteRec.SETFILTER(Quantity, '>0');
        //IF SalesQuoteRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Promised Delivery Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Shipment Date'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No. 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No. 3';
            SaveString := SaveString + FORMAT(tabChar) + 'Organization Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Person in Charge';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Document Type';
            //SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Order No. ';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code ';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Amount ';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Invoiced';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Shipped';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Requested Delivery Date'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Data Creation Date'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF SalesQuoteRec.FIND('-') THEN//CS059
                REPEAT
                    SalesHeaderRec.GET(SalesQuoteRec."Document Type", SalesQuoteRec."Document No.");
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Promised Delivery Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Shipment Date", 0, '<Year4>/<Month,2>/<Day,2>'); //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesHeaderRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Document No.";//Order No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Line No.");//Order Line No. 2
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Line No. 3
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Organization Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//Person in Charge //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + SalesQuoteRec."Sell-to Customer No." + ';' + SalesQuoteRec."OEM No.";//Customer Inventory Group //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec.Description;//Item Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Sell-to Customer No.";//Customer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."OEM No.";//End Customer Code

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Outstanding Quantity");//Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Unit Price");//Sales Price
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Line Amount");//Sales Amount


                    IF SalesHeaderRec."Currency Code" = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"//Sales Currency
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + SalesHeaderRec."Currency Code";

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Price
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Amount
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Currency
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Type

                    IF SalesQuoteRec.Type = SalesQuoteRec.Type::Item THEN BEGIN
                        ItemRec.GET(SalesQuoteRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                    END ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Item No.

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Document Type");
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Customer Item No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Customer Order No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Description 2";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Item Supplier Source");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Location Code";

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."Manufacturer Code";
                    IF SalesQuoteRec.Type = SalesQuoteRec.Type::Item THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code"
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';

                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesQuoteRec."OEM Name"; //OEM Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Outstanding Amount");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec.Quantity);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Quantity Invoiced");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Quantity Shipped");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesHeaderRec."Sell-to Customer Name";//Name in Sales Header, Customer Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Requested Delivery Date", 0, '<Year4>/<Month,2>/<Day,2>'); //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Unit Cost");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec."Unit Cost (LCY)");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesQuoteRec.Type);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesHeaderRec."Document Date", 0, '<Year4>/<Month,2>/<Day,2>');//Data Creation Date //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();

                UNTIL SalesQuoteRec.NEXT() = 0;


        END;
    end;

    local procedure ExportOutstandingSalesOrder()
    var
        FileName: Text[200];
        OutstandingSalesOrderRec: Record "Sales Line";
        ItemRec: Record Item;
        SalesHeaderRec: Record "Sales Header";
        CustomerRec: Record Customer;
    begin
        DataName := Const_DN_OutstandingSalesOrder;
        SaveString := '';
        OutstandingSalesOrderRec.RESET();
        OutstandingSalesOrderRec.SETRANGE("Document Type", OutstandingSalesOrderRec."Document Type"::Order);
        OutstandingSalesOrderRec.SETFILTER(Type, '<>0');
        OutstandingSalesOrderRec.SETFILTER("Outstanding Quantity", '>0');
        //IF OutstandingSalesOrderRec.FIND('-') THEN
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Promised Delivery Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Shipment Date';//CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No. 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No. 3';
            SaveString := SaveString + FORMAT(tabChar) + 'Organization Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Person in Charge';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Document Type';
            //SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Order No. ';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code ';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Amount ';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Invoiced';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Shipped';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Requested Delivery Date';//CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF OutstandingSalesOrderRec.FIND('-') THEN//CS059
                REPEAT
                    SalesHeaderRec.GET(OutstandingSalesOrderRec."Document Type", OutstandingSalesOrderRec."Document No.");
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Promised Delivery Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Shipment Date", 0, '<Year4>/<Month,2>/<Day,2>'); //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesHeaderRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."Document No.";//Order No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Line No.");//Order Line No. 2
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Line No. 3
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Organization Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//Person in Charge //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + OutstandingSalesOrderRec."Sell-to Customer No." + ';' + OutstandingSalesOrderRec."OEM No.";//Customer Inventory Group //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec.Description;//Item Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesHeaderRec."Sell-to Customer No.";//Customer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."OEM No.";//End Customer Code

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Outstanding Quantity");//Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Unit Price");//Sales Price
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Line Amount");//Sales Amount

                    IF SalesHeaderRec."Currency Code" = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"//Sales Currency
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + SalesHeaderRec."Currency Code";

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Price
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Amount
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Currency
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Type

                    IF OutstandingSalesOrderRec.Type = OutstandingSalesOrderRec.Type::Item THEN BEGIN
                        ItemRec.GET(OutstandingSalesOrderRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                    END ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Item No.

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Document Type");
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."Customer Item No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."Customer Order No.";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."Description 2";
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Item Supplier Source");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."Location Code";

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."Manufacturer Code";
                    IF OutstandingSalesOrderRec.Type = OutstandingSalesOrderRec.Type::Item THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code"
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';

                    SaveString := SaveString + FORMAT(tabPlaceholder) + OutstandingSalesOrderRec."OEM Name"; //OEM Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Outstanding Amount");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec.Quantity);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Quantity Invoiced");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Quantity Shipped");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesHeaderRec."Sell-to Customer Name";//Name in Sales Header, Customer Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Requested Delivery Date", 0, '<Year4>/<Month,2>/<Day,2>'); //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Unit Cost");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec."Unit Cost (LCY)");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(OutstandingSalesOrderRec.Type);
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL OutstandingSalesOrderRec.NEXT() = 0;


        END;
    end;

    local procedure ExportSalesShipment()
    var
        FileName: Text[200];
        SalesShipmentRec: Record "Sales Shipment Line";
        ItemRec: Record Item;
        SaleShipmentHeaderRec: Record "Sales Shipment Header";
        CustomerRec: Record "Customer";
        ValueEntryRec: Record "Value Entry";
        ItemUnitCost: Decimal;
        ItemAmtTotal: Decimal;
        ItemQtyTotal: Decimal;
    begin
        DataName := Const_DN_SalesShipment;
        SaveString := '';
        SalesShipmentRec.RESET();
        SalesShipmentRec.SETFILTER(Type, '<>0');
        SalesShipmentRec.SETFILTER("Posting Date", '%1..', BaseDate);
        SalesShipmentRec.SETFILTER(Quantity, '<>0');
        //IF SalesShipmentRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Department';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No. 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No. 3';
            SaveString := SaveString + FORMAT(tabChar) + 'Person in Charge';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Exchange Rate';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Exchange Rate';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No. ';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Line Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Rank';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code ';
            //SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF SalesShipmentRec.FIND('-') THEN//CS059
                REPEAT
                    SaleShipmentHeaderRec.GET(SalesShipmentRec."Document No.");
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//CS059'';//Sales Department
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Type
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."Document No.";//Order No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Line No.");//Order Line No. 2
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order Line No. 3
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//Person in Charge //CS051

                    SaveString := SaveString + FORMAT(tabPlaceholder) + SaleShipmentHeaderRec."Sell-to Customer No.";//Customer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."OEM No.";//End Customer Code

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Posting Date", 0, '<Year4>/<Month,2>/<Day,2>');//Sales Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SaleShipmentHeaderRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//Order Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec.Description;//Item Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + SaleShipmentHeaderRec."Sell-to Customer No." + ';' + SalesShipmentRec."OEM No.";//Customer Inventory Group //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec.Quantity);//Sales Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Unit Price");//Sales Price
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(SalesShipmentRec."Unit Price" * SalesShipmentRec.Quantity * (100 - SalesShipmentRec."Line Discount %") / 100, 0.00001));//Sales Amount
                    IF SaleShipmentHeaderRec."Currency Code" = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"//Sales Currency
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + SaleShipmentHeaderRec."Currency Code";

                    //CS065 Start
                    CLEAR(ItemAmtTotal);
                    CLEAR(ItemQtyTotal);
                    CLEAR(ItemUnitCost);
                    IF SalesShipmentRec.Type = SalesShipmentRec.Type::Item THEN BEGIN
                        ValueEntryRec.RESET();
                        ValueEntryRec.SETRANGE("Item No.", SalesShipmentRec."No.");
                        ValueEntryRec.SETFILTER("Location Code", SalesShipmentRec."Location Code");
                        ValueEntryRec.SETFILTER("Posting Date", '..%1', CALCDATE('<-CM-1D>', SalesShipmentRec."Posting Date"));
                        ValueEntryRec.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)");
                        ItemAmtTotal := ValueEntryRec."Cost Amount (Actual)" + ValueEntryRec."Cost Amount (Expected)";
                        ItemQtyTotal := ValueEntryRec."Item Ledger Entry Quantity";

                        ValueEntryRec.RESET();
                        ValueEntryRec.SETRANGE("Item No.", SalesShipmentRec."No.");
                        ValueEntryRec.SETFILTER("Location Code", SalesShipmentRec."Location Code");
                        ValueEntryRec.SETFILTER("Posting Date", '%1..%2',
                          CALCDATE('<-CM>', SalesShipmentRec."Posting Date"), CALCDATE('<CM>', SalesShipmentRec."Posting Date"));
                        ValueEntryRec.SETFILTER(
                          "Item Ledger Entry Type", '%1|%2|%3|%4',
                          ValueEntryRec."Item Ledger Entry Type"::Purchase,
                          ValueEntryRec."Item Ledger Entry Type"::"Positive Adjmt.",
                          ValueEntryRec."Item Ledger Entry Type"::Output,
                          ValueEntryRec."Item Ledger Entry Type"::"Assembly Output");
                        ValueEntryRec.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)");
                        ItemAmtTotal += (ValueEntryRec."Cost Amount (Actual)" + ValueEntryRec."Cost Amount (Expected)");
                        ItemQtyTotal += ValueEntryRec."Item Ledger Entry Quantity";

                        ValueEntryRec.RESET();
                        ValueEntryRec.SETRANGE("Item No.", SalesShipmentRec."No.");
                        ValueEntryRec.SETFILTER("Location Code", SalesShipmentRec."Location Code");
                        ValueEntryRec.SETFILTER("Posting Date", '%1..%2',
                          CALCDATE('<-CM>', SalesShipmentRec."Posting Date"), CALCDATE('<CM>', SalesShipmentRec."Posting Date"));
                        ValueEntryRec.SETFILTER("Item Ledger Entry Type", '%1', ValueEntryRec."Item Ledger Entry Type"::Transfer);
                        IF ValueEntryRec.FINDSET THEN
                            REPEAT
                                IF ValueEntryRec."Valued Quantity" > 0 THEN BEGIN
                                    ItemAmtTotal += (ValueEntryRec."Cost Amount (Actual)" + ValueEntryRec."Cost Amount (Expected)");
                                    ItemQtyTotal += ValueEntryRec."Item Ledger Entry Quantity";
                                END;
                            UNTIL ValueEntryRec.NEXT = 0;

                        IF ItemQtyTotal <> 0 THEN
                            ItemUnitCost := ROUND(ItemAmtTotal / ItemQtyTotal, GeneralLedgerSetupRec."Unit-Amount Rounding Precision");

                    END ELSE
                        ItemUnitCost := 0;

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Unit Cost");//Cost Price
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Unit Cost" * SalesShipmentRec.Quantity);//Cost Amount
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemUnitCost);//Cost Price
                                                                                             //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemUnitCost * SalesShipmentRec.Quantity);//Cost Amount //CS086
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(ItemUnitCost * SalesShipmentRec.Quantity, 0.00001));//Cost Amount //CS086
                                                                                                                                         //CS065 End

                    SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Cost Currency
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Sales Exchange Rate
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Exchange Rate

                    IF SalesShipmentRec.Type = SalesShipmentRec.Type::Item THEN BEGIN
                        ItemRec.GET(SalesShipmentRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Vendor No. //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Item No.
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."Description 2";//Description 2
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."Location Code";//Location Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Line Order Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."Order No.";//Order No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Order Line No.");//Order Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."Customer Order No.";//Customer Order No.

                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec."OEM Name"; //OEM Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec."Item Supplier Source");//Item Supplier Source
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SalesShipmentRec.Rank;//Rank
                    SaveString := SaveString + FORMAT(tabPlaceholder) + SaleShipmentHeaderRec."Sell-to Customer Name";//Customer Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                    IF SalesShipmentRec.Type = SalesShipmentRec.Type::Item THEN BEGIN
                        //ItemRec.Get(SalesShipmentRec."Item No");
                        //SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                        ItemRec.CALCFIELDS("Vendor Name");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Name";//Vendor Name
                    END
                    ELSE BEGIN
                        //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Vendor No. //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Vendor Name
                    END;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesShipmentRec.Type);//Type
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL SalesShipmentRec.NEXT() = 0;


        END;
    end;

    local procedure ExportOutstandingPurchaseOrder()
    var
        FileName: Text[200];
        PurchaseLineRec: Record "Purchase Line";
        ItemRec: Record Item;
        PurchaseHeaderRec: Record "Purchase Header";
        CustomerRec: Record "Customer";
    begin
        DataName := Const_DN_OutstandingPurchaseOrder;
        SaveString := '';
        PurchaseLineRec.RESET();
        PurchaseLineRec.SETRANGE("Document Type", PurchaseLineRec."Document Type"::Order);
        PurchaseLineRec.SETFILTER(Type, '<>0');
        PurchaseLineRec.SETFILTER("Outstanding Quantity", '>0');
        //IF PurchaseLineRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'ESD';
            SaveString := SaveString + FORMAT(tabChar) + 'CRD';
            SaveString := SaveString + FORMAT(tabChar) + 'RSD';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Buy-from Vendor';
            SaveString := SaveString + FORMAT(tabChar) + 'Organization Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            //SaveString := SaveString + FORMAT(tabChar) + 'Quantity'; //CS093
            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Quantity'; //CS093
            SaveString := SaveString + FORMAT(tabChar) + 'Order Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No. 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Amount Including VAT';
            SaveString := SaveString + FORMAT(tabChar) + 'CO No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Amount';
            //SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Quantity'; //CS093
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity'; //CS093
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Invoiced';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Received';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Price (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF PurchaseLineRec.FIND('-') THEN//CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//ESD

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Requested Receipt Date_1", 0, '<Year4>/<Month,2>/<Day,2>');//CRD(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//RSD
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//Order Date

                    PurchaseHeaderRec.GET(PurchaseLineRec."Document Type", PurchaseLineRec."Document No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Buy-from Vendor No.";//Buy-from Vendor

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Organization Code
                                                                           //CS051 Begin
                    IF PurchaseLineRec.Type = PurchaseLineRec.Type::Item THEN BEGIN
                        ItemRec.GET(PurchaseLineRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Inventory Group
                    END;
                    //CS051 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec.Description;//Item Name
                    //CS093
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Quantity);//Quantity 
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Outstanding Quantity"); //Outstanding Quantity
                    //CS093
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Direct Unit Cost");//Order Price, "Direct Unit Cost (Excl. VAT)"
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Line Amount");//Order Amount, "Line Amount (Excl. VAT)"

                    IF PurchaseHeaderRec."Currency Code" = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"//Sales Currency
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Currency Code";//Order Currency

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseRcptHeaderRec."Currency Code";//Order Currency, Currency Code in Purchase Header/Purchase Rcpt. Header
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Document No.";//Order No.
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//PurchaseLineRec."Order No. 2" //CS059
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Line No.");//Line No. //CS059

                    IF PurchaseLineRec.Type = PurchaseLineRec.Type::Item THEN BEGIN
                        //ItemRec.GET(PurchaseLineRec."No."); //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//End Customer Code
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Buy-from Vendor Name";//Vendor Name
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseRcptHeaderRec."Buy-from Vendor Name";//Vendor Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Line No.");//Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Amount);//Amount
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Amount Including VAT");//Amount Including VAT
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."CO No.";//CO No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Customer Item No.";//Customer Item No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Item Supplier Source");//Item Supplier Source
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Location Code";//Location Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Outstanding Quantity" * PurchaseLineRec."Direct Unit Cost");//Outstanding Amount(Set blank for Purchase Invoice Line)
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec.'';//Outstanding Amount(Set blank for Purchase Invoice Line)
                    //CS093
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Outstanding Quantity");//Outstanding Quantity(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Quantity); //Quantity
                    //CS093
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec.'';//Outstanding Quantity(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Quantity Invoiced");//Quantity Invoiced(Set blank for Purchase Invoice Line)
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Quantity Invoiced(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Quantity Received");//Quantity Received(Set Quantity for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Unit Cost");//Unit Cost
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Unit Cost (LCY)");//Unit Cost (LCY)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Unit Price (LCY)");//Unit Price (LCY)

                    IF PurchaseLineRec.Type = PurchaseLineRec.Type::Item THEN BEGIN
                        //ItemRec.Get(PurchaseLineRec."Item No");
                        IF ItemRec."Customer No." <> '' THEN BEGIN
                            CustomerRec.GET(ItemRec."Customer No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                        END
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name

                        IF ItemRec."OEM No." <> '' THEN BEGIN
                            CustomerRec.RESET();
                            CustomerRec.GET(ItemRec."OEM No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                        END
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//OEM Name

                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//OEM Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Manufacturer Code
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Type);//Type
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL PurchaseLineRec.NEXT() = 0;


        END;
    end;

    local procedure ExportPurchaseLines()
    var
        FileName: Text[200];
        PurchaseLineRec: Record "Purchase Line";
        PurchaseInvoiceLineRec: Record "Purch. Inv. Line";
        PurchaseRcptLineRec: Record "Purch. Rcpt. Line";
        ItemRec: Record Item;
        PurchaseHeaderRec: Record "Purchase Header";
        PurchaseRcptHeaderRec: Record "Purch. Rcpt. Header";
        CustomerRec: Record "Customer";
        PurchaseInvoiceHeaderRec: Record "Purch. Inv. Header";
        hasPurchaseLine: Boolean;
        writeInvoiceLine: Boolean;
        isInvoiceFirstLine: Boolean;
    begin
        DataName := Const_DN_PurchaseLines;
        hasPurchaseLine := FALSE;
        SaveString := '';
        PurchaseLineRec.RESET();
        PurchaseLineRec.SETRANGE("Document Type", PurchaseLineRec."Document Type"::Order);
        PurchaseLineRec.SETFILTER(Type, '<>0');
        PurchaseLineRec.SETFILTER(Quantity, '>0');
        PurchaseLineRec.SETFILTER("Order Date", '>=%1', BaseDate);
        //IF PurchaseLineRec.FIND('-') THEN CS059
        BEGIN
            hasPurchaseLine := TRUE;

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'ESD';
            SaveString := SaveString + FORMAT(tabChar) + 'CRD';
            SaveString := SaveString + FORMAT(tabChar) + 'RSD';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Buy-from Vendor';
            SaveString := SaveString + FORMAT(tabChar) + 'Organization Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No. 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Amount Including VAT';
            SaveString := SaveString + FORMAT(tabChar) + 'CO No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Invoiced';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Received';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Price (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';

            InsertDataInBuffer();
            IF PurchaseLineRec.FIND('-') THEN//CS059
                REPEAT
                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//ESD

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Requested Receipt Date_1", 0, '<Year4>/<Month,2>/<Day,2>');//CRD(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//RSD
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//Order Date

                    PurchaseHeaderRec.GET(PurchaseLineRec."Document Type", PurchaseLineRec."Document No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Buy-from Vendor No.";//Buy-from Vendor

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Organization Code
                                                                           //CS051 Begin
                    IF PurchaseLineRec.Type = PurchaseLineRec.Type::Item THEN BEGIN
                        ItemRec.GET(PurchaseLineRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Inventory Group
                    END;
                    //CS051 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec.Description;//Item Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Quantity);//Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Direct Unit Cost");//Order Price, Direct Unit Cost (Excl. VAT)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Line Amount");//Order Amount, Line Amount (Excl. VAT)

                    IF PurchaseHeaderRec."Currency Code" = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Currency Code";//Order Currency, Currency Code in Purchase Header/Purchase Rcpt. Header

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseRcptHeaderRec."Currency Code";//Order Currency, Currency Code in Purchase Header/Purchase Rcpt. Header
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Document No.";//Order No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Line No.");//CS059 '';//Order No. 2

                    IF PurchaseLineRec.Type = PurchaseLineRec.Type::Item THEN BEGIN
                        //ItemRec.GET(PurchaseLineRec."No."); //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//End Customer Code
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Buy-from Vendor Name";//Vendor Name
                                                                                                                 //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseRcptHeaderRec."Buy-from Vendor Name";//Vendor Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Line No.");//Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Amount);//Amount
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Amount Including VAT");//Amount Including VAT
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."CO No.";//CO No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Customer Item No.";//Customer Item No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Item Supplier Source");//Item Supplier Source
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Location Code";//Location Code
                                                                                                        //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Outstanding Quantity" * PurchaseLineRec."Direct Unit Cost");//Outstanding Amount(Set blank for Purchase Invoice Line) //CS086
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(PurchaseLineRec."Outstanding Quantity" * PurchaseLineRec."Direct Unit Cost", 0.00001));//Outstanding Amount(Set blank for Purchase Invoice Line) //CS086
                                                                                                                                                                            //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec.'';//Outstanding Amount(Set blank for Purchase Invoice Line)

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Outstanding Quantity");//Outstanding Quantity(Set blank for Purchase Invoice Line)
                                                                                                                       //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec.'';//Outstanding Quantity(Set blank for Purchase Invoice Line)

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Quantity Invoiced");//Quantity Invoiced(Set blank for Purchase Invoice Line)
                                                                                                                    //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Quantity Invoiced(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Quantity Received");//Quantity Received(Set Quantity for Purchase Invoice Line)
                                                                                                                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseLineRec."Quantity";//Quantity Received(Set Quantity for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Unit Cost");//Unit Cost
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Unit Cost (LCY)");//Unit Cost (LCY)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec."Unit Price (LCY)");//Unit Price (LCY)

                    IF PurchaseLineRec.Type = PurchaseLineRec.Type::Item THEN BEGIN
                        //ItemRec.Get(PurchaseLineRec."Item No");
                        IF ItemRec."Customer No." <> '' THEN BEGIN
                            CustomerRec.GET(ItemRec."Customer No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                        END
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name

                        IF ItemRec."OEM No." = '' THEN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                        ELSE BEGIN
                            CustomerRec.RESET();
                            CustomerRec.GET(ItemRec."OEM No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                        END;
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//OEM Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Manufacturer Code
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseLineRec.Type);//Type

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL PurchaseLineRec.NEXT() = 0;
            //
        END;

        isInvoiceFirstLine := TRUE;
        SaveString := '';
        PurchaseInvoiceLineRec.RESET();
        PurchaseInvoiceLineRec.SETFILTER(Type, '<>0');
        PurchaseInvoiceLineRec.SETFILTER(Quantity, '>0');
        IF PurchaseInvoiceLineRec.FIND('-') THEN BEGIN
            REPEAT
                writeInvoiceLine := TRUE;
                PurchaseInvoiceHeaderRec.GET(PurchaseInvoiceLineRec."Document No.");
                IF PurchaseInvoiceHeaderRec."Order No." <> '' THEN BEGIN
                    IF PurchaseHeaderRec.GET(PurchaseHeaderRec."Document Type"::Order, PurchaseInvoiceHeaderRec."Order No.") THEN
                        writeInvoiceLine := FALSE
                    ELSE
                        writeInvoiceLine := TRUE;
                    IF PurchaseInvoiceHeaderRec."Order Date" < BaseDate THEN
                        writeInvoiceLine := FALSE;
                END
                ELSE BEGIN
                    IF PurchaseInvoiceLineRec."Receipt No." = '' THEN
                        writeInvoiceLine := FALSE
                    ELSE BEGIN
                        PurchaseRcptLineRec.RESET();
                        PurchaseRcptLineRec.SETRANGE("Document No.", PurchaseInvoiceLineRec."Receipt No.");
                        PurchaseRcptLineRec.SETRANGE("Line No.", PurchaseInvoiceLineRec."Receipt Line No.");
                        IF PurchaseRcptLineRec.FIND('-') THEN BEGIN
                            PurchaseLineRec.RESET();
                            PurchaseLineRec.SETRANGE("Document No.", PurchaseRcptLineRec."Order No.");
                            PurchaseLineRec.SETRANGE("Line No.", PurchaseRcptLineRec."Order Line No.");
                            IF PurchaseLineRec.FIND('-') THEN
                                writeInvoiceLine := FALSE
                            ELSE IF PurchaseInvoiceHeaderRec."Posting Date" < BaseDate THEN
                                writeInvoiceLine := FALSE;
                        END
                        ELSE
                            writeInvoiceLine := FALSE;
                    END;
                END;

                IF writeInvoiceLine THEN BEGIN
                    IF isInvoiceFirstLine THEN BEGIN
                        IF NOT hasPurchaseLine THEN BEGIN
                            hasPurchaseLine := TRUE;

                            SaveString := 'Company Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'ESD';
                            SaveString := SaveString + FORMAT(tabChar) + 'CRD';
                            SaveString := SaveString + FORMAT(tabChar) + 'RSD';
                            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
                            SaveString := SaveString + FORMAT(tabChar) + 'Buy-from Vendor';
                            SaveString := SaveString + FORMAT(tabChar) + 'Organization Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
                            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
                            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
                            SaveString := SaveString + FORMAT(tabChar) + 'Order Price';
                            SaveString := SaveString + FORMAT(tabChar) + 'Order Amount';
                            SaveString := SaveString + FORMAT(tabChar) + 'Order Currency';
                            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
                            SaveString := SaveString + FORMAT(tabChar) + 'Order No. 2';
                            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
                            SaveString := SaveString + FORMAT(tabChar) + 'Line No.';
                            SaveString := SaveString + FORMAT(tabChar) + 'Amount';
                            SaveString := SaveString + FORMAT(tabChar) + 'Amount Including VAT';
                            SaveString := SaveString + FORMAT(tabChar) + 'CO No.';
                            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
                            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
                            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Amount';
                            SaveString := SaveString + FORMAT(tabChar) + 'Outstanding Quantity';
                            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Invoiced';
                            SaveString := SaveString + FORMAT(tabChar) + 'Quantity Received';
                            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
                            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost (LCY)';
                            SaveString := SaveString + FORMAT(tabChar) + 'Unit Price (LCY)';
                            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
                            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
                            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
                            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
                            SaveString := SaveString + FORMAT(tabChar) + 'Type';

                            InsertDataInBuffer();
                        END;
                        isInvoiceFirstLine := FALSE;
                    END;

                    SaveString := curCountryRegionCode;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//ESD

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//CRD(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//RSD
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceHeaderRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//Order Date

                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceHeaderRec."Buy-from Vendor No.";//Buy-from Vendor

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Organization Code
                                                                           //CS051 Begin
                    IF PurchaseInvoiceLineRec.Type = PurchaseInvoiceLineRec.Type::Item THEN BEGIN
                        ItemRec.GET(PurchaseInvoiceLineRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Inventory Group
                    END;
                    //CS051 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec.Description;//Item Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec.Quantity);//Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Direct Unit Cost");//Order Price, Direct Unit Cost (Excl. VAT)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Line Amount");//Order Amount, Line Amount (Excl. VAT)

                    IF PurchaseInvoiceHeaderRec."Currency Code" = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceHeaderRec."Currency Code";//Order Currency, Currency Code in Purchase Header/Purchase Rcpt. Header

                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Document No.";//Order No.
                                                                                                              //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Order No. 2 //CS059
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Line No.");//Line No. //CS059

                    IF PurchaseInvoiceLineRec.Type = PurchaseInvoiceLineRec.Type::Item THEN BEGIN
                        //IF PurchaseInvoiceLineRec."No." <> '' THEN BEGIN
                        //  ItemRec.GET(PurchaseInvoiceLineRec."No."); //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code
                                                                                              //END
                                                                                              //ELSE BEGIN
                                                                                              //  SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Code
                                                                                              //  SaveString := SaveString + FORMAT(tabPlaceholder) + '';//End Customer Code
                                                                                              //END;
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//End Customer Code
                    END;

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseHeaderRec."Buy-from Vendor Name";//Vendor Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceHeaderRec."Buy-from Vendor Name";//Vendor Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Line No.");//Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec.Amount);//Amount
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Amount Including VAT");//Amount Including VAT
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."CO No.";//CO No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Customer Item No.";//Customer Item No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemRec."Item Supplier Source");//FORMAT(PurchaseInvoiceLineRec."Item Supplier Source");//Item Supplier Source
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Location Code";//Location Code
                                                                                                               //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Outstanding Quantity (#27) x Order Price (#12)";//Outstanding Amount(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Outstanding Amount(Set blank for Purchase Invoice Line)

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Outstanding Quantity";//Outstanding Quantity(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Outstanding Quantity(Set blank for Purchase Invoice Line)

                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Quantity Invoiced";//Quantity Invoiced(Set blank for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Quantity Invoiced(Set blank for Purchase Invoice Line)
                                                                           //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceLineRec."Quantity Received";//Quantity Received(Set Quantity for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec.Quantity);//Quantity Received(Set Quantity for Purchase Invoice Line)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Unit Cost");//Unit Cost
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Unit Cost (LCY)");//Unit Cost (LCY)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec."Unit Price (LCY)");//Unit Price (LCY)

                    IF PurchaseInvoiceLineRec.Type = PurchaseInvoiceLineRec.Type::Item THEN BEGIN
                        //ItemRec.Get(PurchaseInvoiceLineRec."Item No");
                        IF ItemRec."Customer No." <> '' THEN BEGIN
                            CustomerRec.GET(ItemRec."Customer No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                        END
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name

                        IF ItemRec."OEM No." = '' THEN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                        ELSE BEGIN
                            CustomerRec.RESET();
                            CustomerRec.GET(ItemRec."OEM No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                        END;
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//OEM Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Manufacturer Code
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseInvoiceLineRec.Type);//Type

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                END;
            UNTIL PurchaseInvoiceLineRec.NEXT() = 0;
            //IF hasPurchaseLine THEN//CS059
            //  //CS059
        END;
        //CS059
    end;

    local procedure ExportPurchaseReceipt()
    var
        FileName: Text[200];
        PurchaseReceiptRec: Record "Purch. Rcpt. Line";
        ItemRec: Record Item;
        PurchaseReceiptHeaderRec: Record "Purch. Rcpt. Header";
        CustomerRec: Record "Customer";
    begin
        DataName := Const_DN_PurchaseReceipt;
        SaveString := '';
        PurchaseReceiptRec.RESET();
        PurchaseReceiptRec.SETFILTER(Type, '<>0');
        PurchaseReceiptRec.SETFILTER("Posting Date", '>=%1', BaseDate);
        PurchaseReceiptRec.SETFILTER(Quantity, '<>0');
        //IF PurchaseReceiptRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Slip No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Posting Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Buy-from Vendor';
            SaveString := SaveString + FORMAT(tabChar) + 'Organization Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Document No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'CO No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Expected Receipt Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Goods Arrival Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Supplier Source';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Order Line No.';
            //SaveString := SaveString + FORMAT(tabChar) + 'Order No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Requested Receipt Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost (LCY)';
            //SaveString := SaveString + FORMAT(tabChar) + 'Unit Price (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF PurchaseReceiptRec.FIND('-') THEN//CS059
                REPEAT
                    SaveString := curCountryRegionCode;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Slip No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Order Date", 0, '<Year4>/<Month,2>/<Day,2>');//Order Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Posting Date", 0, '<Year4>/<Month,2>/<Day,2>');//Posting Date
                    PurchaseReceiptHeaderRec.GET(PurchaseReceiptRec."Document No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptHeaderRec."Buy-from Vendor No.";//Buy-from Vendor
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Organization Code
                                                                           //CS051 Begin
                    IF PurchaseReceiptRec.Type = PurchaseReceiptRec.Type::Item THEN BEGIN
                        ItemRec.GET(PurchaseReceiptRec."No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Inventory Group
                    END;
                    //CS051 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec.Description;//Item Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec.Quantity);//Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Direct Unit Cost");//Order Price, Direct Unit Cost (Excl. VAT)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(PurchaseReceiptRec."Direct Unit Cost" * PurchaseReceiptRec.Quantity * (100 - PurchaseReceiptRec."Line Discount %") / 100, 0.00001));
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptHeaderRec."Currency Code";//Order Currency
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."Order No.";//Order No.
                    IF PurchaseReceiptRec.Type = PurchaseReceiptRec.Type::Item THEN BEGIN
                        //ItemRec.GET(PurchaseReceiptRec."No."); //CS051
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//End Customer Code
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."Document No.";//Document No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Line No.");//Line No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptHeaderRec."Buy-from Vendor Name";//Vendor Name
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."CO No.";//CO No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."Customer Item No.";//Customer Item No.

                    IF PurchaseReceiptRec.Type = PurchaseReceiptRec.Type::Item THEN BEGIN
                        //ItemRec.Get(PurchaseReceiptRec."Item No");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Description 2
                    END;

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Expected Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//Expected Receipt Date

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Goods Arrival Date", 0, '<Year4>/<Month,2>/<Day,2>');//Goods Arrival Date
                    /*
                    //For HS
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Goods Arrival Date
                    */

                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Item Supplier Source");//Item Supplier Source
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."Location Code";//Location Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Order Line No.");//Order Line No.
                                                                                                                    //SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseReceiptRec."Order No.";//Order No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Requested Receipt Date", 0, '<Year4>/<Month,2>/<Day,2>');//Requested Receipt Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Unit Cost");//Unit Cost
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Unit Cost (LCY)");//Unit Cost (LCY)
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec."Unit Price (LCY)");//Unit Price (LCY)

                    IF PurchaseReceiptRec.Type = PurchaseReceiptRec.Type::Item THEN BEGIN
                        //ItemRec.Get(PurchaseReceiptRec."Item No");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code

                        IF ItemRec."Customer No." <> '' THEN BEGIN
                            CustomerRec.GET(ItemRec."Customer No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                        END
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name

                        IF ItemRec."OEM No." = '' THEN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                        ELSE BEGIN
                            CustomerRec.RESET();
                            CustomerRec.GET(ItemRec."OEM No.");
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                        END;
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Manufacturer Code

                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//OEM Name
                    END;
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchaseReceiptRec.Type);//Type
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //CS051

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL PurchaseReceiptRec.NEXT() = 0;


        END;
    end;

    local procedure ExportInventory()
    var
        FileName: Text[200];
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        ItemRec: Record Item;
        CustomerRec: Record "Customer";
        sumOfRemainingQuantity: Decimal;
        subLineDataExportString: Text[1024];
        currentItem: Code[20];
        currentLocation: Code[10];
        "sumOfCostAmount(Actual)": Decimal;
        unitCost: Decimal;
        ValueEntryRec: Record "Value Entry";
        ItemLedgerEntryRec2: Record "Item Ledger Entry";
        LocationRec: Record Location;
    begin
        DataName := Const_DN_Inventory;
        SaveString := '';
        currentItem := '';
        currentLocation := '';
        subLineDataExportString := '';
        ItemLedgerEntryRec.RESET();
        ItemLedgerEntryRec.SETCURRENTKEY("Item No.", "Location Code");
        //ItemLedgerEntryRec.FILTERGROUP(1);
        //ItemLedgerEntryRec.SETFILTER("Remaining Quantity", '<>0');  //CS059
        //IF ItemLedgerEntryRec.FIND('-') THEN //CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Data Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Receipt Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Exchange Rate';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';  //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            //SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Inventory Base Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Exclusion Flag'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of SO'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of Work'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of PO'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Good Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Replenishment Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Lending Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Inspection Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Transfer Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Unaccepted Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Defective Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF ItemLedgerEntryRec.FIND('-') THEN//CS059
                REPEAT
                    ItemRec.RESET(); //CS059
                    IF ItemRec.GET(ItemLedgerEntryRec."Item No.") THEN //CS059
                        IF ItemRec.Blocked <> TRUE THEN //CS059
                            IF (currentItem <> ItemLedgerEntryRec."Item No.") OR (currentLocation <> ItemLedgerEntryRec."Location Code") THEN BEGIN

                                currentItem := ItemLedgerEntryRec."Item No.";
                                currentLocation := ItemLedgerEntryRec."Location Code";
                                //sumOfRemainingQuantity := 0;
                                //"sumOfCostAmount(Actual)" := 0;
                                //unitCost := 0;
                                ItemRec.GET(ItemLedgerEntryRec."Item No."); //CS051

                                SaveString := curCountryRegionCode;//Company Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + '30';//Data Type //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemLedgerEntryRec."Item No.";//Item Code
                                                                                                                  //ItemLedgerEntryRec.CALCFIELDS("Item Description");
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description;//Item Name
                                subLineDataExportString := SaveString + FORMAT(tabPlaceholder);

                                SaveString := '';
                                //sumOfRemainingQuantity := sumOfRemainingQuantity + ItemLedgerEntryRec."Remaining Quantity";//Quantity, Sum of Remaining Quantity
                                //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemLedgerEntryRec."Cost Amount (Actual)" / ItemLedgerEntryRec.Quantity);//Unit Cost(Round to Unit-Amount Rounding Precision in General Ledger Setup)
                                //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemLedgerEntryRec."Cost Amount (Actual)");//Cost Amount, Sum of Cost Amount (Actual)
                                //ItemLedgerEntryRec.CALCFIELDS("Cost Amount (Actual)");
                                //"sumOfCostAmount(Actual)" := "sumOfCostAmount(Actual)" + ItemLedgerEntryRec."Cost Amount (Actual)";
                                SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Currency

                                //CS052 Start
                                ItemLedgerEntryRec2.RESET();
                                ItemLedgerEntryRec2.SETRANGE("Document Type", ItemLedgerEntryRec2."Document Type"::"Purchase Receipt");
                                ItemLedgerEntryRec2.SETFILTER("Item No.", currentItem);
                                ItemLedgerEntryRec2.SETFILTER("Location Code", currentLocation);
                                ItemLedgerEntryRec2.SETCURRENTKEY("Item No.", "Location Code", "Posting Date");
                                ItemLedgerEntryRec2.SETASCENDING("Posting Date", FALSE);
                                IF ItemLedgerEntryRec2.FINDFIRST THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemLedgerEntryRec2."Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')//Receipt Date
                                ELSE
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Receipt Date
                                                                                           //CS052 End

                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code

                                SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exchange Rate
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemLedgerEntryRec."Location Code";//Location Code

                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                                                                                                                //SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                                ItemRec.CALCFIELDS("Vendor Name");
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Name";//Vendor Name

                                CustomerRec.RESET();
                                IF ItemRec."Customer No." = '' THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''//Customer Name
                                ELSE BEGIN
                                    CustomerRec.GET(ItemRec."Customer No.");
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                                END;

                                CustomerRec.RESET();
                                IF ItemRec."OEM No." = '' THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                                ELSE BEGIN
                                    CustomerRec.GET(ItemRec."OEM No.");
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                                END;

                                SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>');//Inventory Base Date

                                //BC Update Begin
                                /*
                                //CS051 Begin
                                //IF ItemLedgerEntryRec."Location Code" = 'HOLD' THEN
                                //For HS
                                IF (ItemLedgerEntryRec."Location Code" = 'L1_HOLD') OR (ItemLedgerEntryRec."Location Code" = 'L2_HOLD') THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'//Exclusion Flag
                                ELSE
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                                */

                                ItemLedgerEntryRec.CalcFields(Hold);
                                if ItemLedgerEntryRec.Hold then begin
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'//Exclusion Flag
                                end else begin
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                                end;
                                //BC Update End

                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of SO
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of Work
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of PO
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Good Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Replenishment Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Lending Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Inspection Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Transfer Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Unaccepted Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Defective Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare1
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare2
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare3
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare4
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare5
                                                                                        //CS051 End

                                //CS059 End
                                ValueEntryRec.RESET();
                                ValueEntryRec.SETRANGE("Item No.", currentItem);
                                ValueEntryRec.SETFILTER("Location Code", currentLocation);
                                ValueEntryRec.SETFILTER("Posting Date", '..%1', TODAY);
                                ValueEntryRec.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)");

                                sumOfRemainingQuantity := ValueEntryRec."Item Ledger Entry Quantity";//Quantity
                                "sumOfCostAmount(Actual)" := ValueEntryRec."Cost Amount (Actual)" + ValueEntryRec."Cost Amount (Expected)"; //Cost Amount (Actual)

                                CLEAR(unitCost); //CS059
                                IF sumOfRemainingQuantity <> 0 THEN //BEGIN //CS059
                                    unitCost := ROUND("sumOfCostAmount(Actual)" / sumOfRemainingQuantity, GeneralLedgerSetupRec."Unit-Amount Rounding Precision");

                                SaveString := subLineDataExportString + FORMAT(sumOfRemainingQuantity) + FORMAT(tabPlaceholder) + FORMAT(unitCost) + FORMAT(tabPlaceholder) + FORMAT("sumOfCostAmount(Actual)") + SaveString;
                                SaveString := ReplaceString(SaveString, tabChar, '');
                                SaveString := ReplaceString(SaveString, lineChar, '');
                                SaveString := ReplaceString(SaveString, lineChar2, '');
                                SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                                InsertDataInBuffer();
                                //CS059 End

                            END
                            ELSE BEGIN
                                //sumOfRemainingQuantity := sumOfRemainingQuantity + ItemLedgerEntryRec."Remaining Quantity";//Quantity, Sum of Remaining Quantity
                                //ItemLedgerEntryRec.CALCFIELDS("Cost Amount (Actual)");
                                //"sumOfCostAmount(Actual)" := "sumOfCostAmount(Actual)" + ItemLedgerEntryRec."Cost Amount (Actual)";//Cost Amount (Actual), Sum of Cost Amount (Actual)
                            END;

                UNTIL ItemLedgerEntryRec.NEXT() = 0;

            //CS086 Begin
            ItemLedgerEntryRec.RESET();
            ItemLedgerEntryRec.SETCURRENTKEY("Item No.");
            ItemRec.RESET();
            ItemRec.SETRANGE(Blocked, FALSE);
            IF ItemRec.FINDSET() THEN
                REPEAT
                    ItemLedgerEntryRec.SETRANGE("Item No.", ItemRec."No.");
                    IF ItemLedgerEntryRec.ISEMPTY THEN BEGIN

                        SaveString := curCountryRegionCode;//Company Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '30';//Data Type
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."No.";//Item Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description;//Item Name
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '0';//Quantity
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '0';//Unit Cost
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '0';//Cost Amount
                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Currency
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Receipt Date
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exchange Rate
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No.
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Location Code
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code

                        ItemRec.CALCFIELDS("Vendor Name");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Name";//Vendor Name

                        CustomerRec.RESET();
                        IF CustomerRec.GET(ItemRec."Customer No.") THEN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name

                        CustomerRec.RESET();
                        IF CustomerRec.GET(ItemRec."OEM No.") THEN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '';//OEM Name

                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>');//Inventory Base Date
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of SO
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of Work
                        SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of PO
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Good Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Replenishment Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Lending Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Inspection Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Transfer Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Unaccepted Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Defective Inventory
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare1
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare2
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare3
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare4
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare5

                        SaveString := ReplaceString(SaveString, tabChar, '');
                        SaveString := ReplaceString(SaveString, lineChar, '');
                        SaveString := ReplaceString(SaveString, lineChar2, '');
                        SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);
                        InsertDataInBuffer();
                    END;
                UNTIL ItemRec.NEXT() = 0;
            //CS086 End


        END;

    end;

    local procedure ExportValueEntry()
    var
        FileName: Text[200];
        ValueEntryRec: Record "Value Entry";
        ItemRec: Record Item;
        SalesInvoiceLineRec: Record "Sales Invoice Line";
        SalesInvoiceHeaderRec: Record "Sales Invoice Header";
        CustomerRec: Record "Customer";
        ItemApplicationEntryRec: Record "Item Application Entry";
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        PurchaseInvoiceHeaderRec: Record "Purch. Inv. Header";
        PurchaseRcptHeaderRec: Record "Purch. Rcpt. Header";
        VendorRec: Record Vendor;
        PurchasePriceRec: Record "Price List Line";
        CurrencyExchangeRateRec: Record "Currency Exchange Rate";
        DebitCostACY: Decimal;
        DebitCostLCY: Decimal;
        DebitCostAmountLCY: Decimal;
    begin
        DataName := Const_DN_ValueEntry;
        SaveString := '';
        ValueEntryRec.RESET();
        ValueEntryRec.SETFILTER("Posting Date", '>=%1', BaseDate);
        //IF ValueEntryRec.FIND('-') THEN CS059
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Posting Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Ledger Entry Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Source No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Valued Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Ledger Entry Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Invoiced Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost per Unit';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Amount (Actual)';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount (Actual)';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Invoice Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Document Date';
            SaveString := SaveString + FORMAT(tabChar) + 'External Document No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Document Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Document No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Document Line No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Description';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM No.';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Unit Price';
            SaveString := SaveString + FORMAT(tabChar) + 'Sales Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Vender No.';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            //CS074 Begin
            SaveString := SaveString + FORMAT(tabChar) + 'Debit Cost (ACY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Debit Cost (ACY) Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Debit Cost (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Debit Cost Amount (ACY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Debit Cost Amount (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Gross Profit (LCY)';
            SaveString := SaveString + FORMAT(tabChar) + 'Gross Profit Amount (LCY)';
            //CS074 End
            InsertDataInBuffer();
            IF ValueEntryRec.FIND('-') THEN//CS059
                REPEAT

                    SaveString := curCountryRegionCode;//Company Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Item No.";//Item No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Posting Date", 0, '<Year4>/<Month,2>/<Day,2>');//Posting Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Item Ledger Entry Type");//Item Ledger Entry Type
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Source No.";//Source No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Location Code";//Location Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Valued Quantity");//Valued Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Item Ledger Entry Quantity");//Item Ledger Entry Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Invoiced Quantity");//Invoiced Quantity
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Cost per Unit");//Cost per Unit
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Sales Amount (Actual)");//Sales Amount (Actual)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Cost Amount (Actual)");//Cost Amount (Actual)
                    IF ValueEntryRec."Document Type" = ValueEntryRec."Document Type"::"Sales Invoice" THEN BEGIN
                        //SalesInvoiceLineRec.RESET();
                        //SalesInvoiceLineRec.SETRANGE("Document No.", ValueEntryRec."Document No.");
                        //SalesInvoiceLineRec.SETRANGE("Line No.", ValueEntryRec."Document Line No.");
                        SalesInvoiceLineRec.GET(ValueEntryRec."Document No.", ValueEntryRec."Document Line No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(SalesInvoiceLineRec."Unit Price");//Sales Invoice Price
                    END
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Sales Unit Price
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Document Date", 0, '<Year4>/<Month,2>/<Day,2>');//Document Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."External Document No.";//External Document No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Document Type");//Document Type
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Document No.";//Document No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ValueEntryRec."Document Line No.");//Document Line No.
                    ItemRec.RESET();
                    ItemRec.GET(ValueEntryRec."Item No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description;//Description
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//OEM No

                    CustomerRec.RESET();
                    IF ItemRec."OEM No." = '' THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                    ELSE BEGIN
                        CustomerRec.GET(ItemRec."OEM No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                    END;

                    IF ValueEntryRec."Document Type" = ValueEntryRec."Document Type"::"Sales Invoice" THEN BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(ValueEntryRec."Sales Amount (Actual)" / (ValueEntryRec."Valued Quantity" * (-1)), GeneralLedgerSetupRec."Unit-Amount Rounding Precision"));
                        SalesInvoiceHeaderRec.GET(ValueEntryRec."Document No.");
                        IF SalesInvoiceHeaderRec."Currency Code" = '' THEN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code"
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + SalesInvoiceHeaderRec."Currency Code";//Sales Currency
                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Sales Unit Price
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Sales Currency
                    END;

                    IF ValueEntryRec."Document Type" = ValueEntryRec."Document Type"::"Purchase Invoice" THEN BEGIN
                        PurchaseInvoiceHeaderRec.GET(ValueEntryRec."Document No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseInvoiceHeaderRec."Currency Code";//Cost Currency
                    END
                    ELSE IF (ValueEntryRec."Document Type" = ValueEntryRec."Document Type"::"Sales Invoice") AND
                            (ValueEntryRec."Item Charge No." = '')
                    THEN BEGIN
                        ItemApplicationEntryRec.RESET();
                        ItemApplicationEntryRec.SETFILTER("Outbound Item Entry No.", '%1', ValueEntryRec."Item Ledger Entry No.");
                        ItemApplicationEntryRec.SETCURRENTKEY("Inbound Item Entry No.");
                        IF ItemApplicationEntryRec.FINDFIRST() THEN BEGIN

                            ItemLedgerEntryRec.GET(ItemApplicationEntryRec."Inbound Item Entry No.");

                            IF ItemLedgerEntryRec."Document Type" = ItemLedgerEntryRec."Document Type"::"Purchase Receipt" THEN BEGIN
                                //CS063 Begin
                                //PurchaseRcptHeaderRec.GET(ItemLedgerEntryRec."Document No.");
                                IF PurchaseRcptHeaderRec.GET(ItemLedgerEntryRec."Document No.") THEN BEGIN
                                    IF PurchaseRcptHeaderRec."Currency Code" <> '' THEN
                                        SaveString := SaveString + FORMAT(tabPlaceholder) + PurchaseRcptHeaderRec."Currency Code"//Cost Currency
                                    ELSE
                                        SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Cost Currency
                                END ELSE BEGIN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Currency
                                END;
                                //CS063 End
                            END
                            ELSE BEGIN
                                SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Cost Currency
                            END;
                        END
                        ELSE BEGIN
                            SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Cost Currency
                        END;
                        //If Document Type = Purchase Invoice, set Currency Code in Purchase Invoice Header where No. = Document No. (#18)
                        //If Document Type = Sales Invoice, get the first Item Application Entry (339) where Outbound Item Ledger Entry No. = Entry No. ordered by Inbound Item Ledger Entry No.
                        //Next, get Item Ledger Entry where Entry No. = Inbound Item Ledger Entry No.
                        //If Document Type of Item Ledger Entry = Purchase Receipt, then get Currency Code in Purchase Rcpt. Header where No. = Document No. in Item Ledger Entry.
                        //(If Document Type is not Purchase Receipt, set LCY Code in General Ledger Setup.)
                        //Otherwise, set blank.

                    END
                    ELSE BEGIN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Cost Currency
                    END;

                    ValueEntryRec.CALCFIELDS("Manufacturer Code", "Customer Item No.", "Customer No.", "Vendor No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Manufacturer Code";//Manufacturer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Customer Item No.";//Customer Item No.
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Customer No.";//Customer No.
                    IF ValueEntryRec."Customer No." <> '' THEN BEGIN
                        CustomerRec.GET(ValueEntryRec."Customer No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                    END ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Customer Name

                    SaveString := SaveString + FORMAT(tabPlaceholder) + ValueEntryRec."Vendor No.";//Vender No.
                    IF ValueEntryRec."Vendor No." <> '' THEN BEGIN
                        VendorRec.GET(ValueEntryRec."Vendor No.");
                        SaveString := SaveString + FORMAT(tabPlaceholder) + VendorRec.Name;//Vendor Name
                    END ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Vendor Name
                                                                               //CS074 Begin
                    PurchasePriceRec.RESET();
                    PurchasePriceRec.SETCURRENTKEY("Starting Date");
                    PurchasePriceRec.ASCENDING(FALSE); // Added by Calsoft Japan
                    PurchasePriceRec.SetRange("Price Type", PurchasePriceRec."Price Type"::Purchase);
                    PurchasePriceRec.SetRange(Status, PurchasePriceRec.Status::Active);
                    PurchasePriceRec.SETRANGE("Asset No.", ValueEntryRec."Item No.");
                    //CS107 Begin
                    //PurchasePriceRec.SETFILTER("Starting Date",'<=%1',TODAY);
                    //PurchasePriceRec.SETFILTER("Currency Code",'<>%1','');
                    PurchasePriceRec.SETFILTER("Starting Date", '<=%1', ValueEntryRec."Posting Date");
                    //CS107 END
                    IF PurchasePriceRec.FINDFIRST() THEN BEGIN
                        DebitCostACY := ROUND(PurchasePriceRec."ORE Debit Cost", 0.0001, '=');
                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(DebitCostACY);//Debit Cost (ACY)
                        SaveString := SaveString + FORMAT(tabPlaceholder) + PurchasePriceRec."Currency Code";//Debit Cost (ACY) Currency
                    END
                    ELSE BEGIN
                        DebitCostACY := 0.0;
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '0.0000';//Debit Cost (ACY)
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Debit Cost (ACY) Currency
                    END;

                    CurrencyExchangeRateRec.RESET();
                    CurrencyExchangeRateRec.SETRANGE("Currency Code", PurchasePriceRec."Currency Code");
                    CurrencyExchangeRateRec.SETCURRENTKEY("Starting Date");
                    CurrencyExchangeRateRec.ASCENDING(FALSE); // Added by Calsoft Japan
                    CurrencyExchangeRateRec.SETFILTER("Starting Date", '<=%1', ValueEntryRec."Posting Date");
                    IF CurrencyExchangeRateRec.FINDFIRST() THEN BEGIN
                        IF CurrencyExchangeRateRec."Exchange Rate Amount" <> 0 THEN BEGIN
                            DebitCostLCY := ROUND(DebitCostACY / CurrencyExchangeRateRec."Exchange Rate Amount", 0.0001, '=');
                            SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(DebitCostLCY);//Debit Cost (LCY)
                        END
                        ELSE
                            SaveString := SaveString + FORMAT(tabPlaceholder) + '0.0000';//Debit Cost (LCY)
                    END
                    ELSE BEGIN
                        DebitCostLCY := 0.0;
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '0.0000';//Debit Cost (LCY)
                    END;

                    DebitCostAmountLCY := ROUND(DebitCostLCY * ValueEntryRec."Valued Quantity", 0.01, '=');
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(DebitCostAmountLCY);//Debit Cost Amount (ACY) by Calsoft Japana
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(DebitCostACY * ValueEntryRec."Valued Quantity", 0.01, '='));//Debit Cost Amount (ACY) by Calsoft Japan
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(DebitCostLCY * ValueEntryRec."Valued Quantity", 0.01, '='));//Debit Cost Amount (LCY)
                    IF ValueEntryRec."Valued Quantity" <> 0 THEN
                        SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(ValueEntryRec."Sales Amount (Actual)" / ValueEntryRec."Valued Quantity" - DebitCostLCY, 0.01, '='))//Gross Profit (LCY)
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + '0.00';//Gross Profit (LCY)
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ROUND(ValueEntryRec."Sales Amount (Actual)" - DebitCostAmountLCY, 0.01, '='));//Gross Profit Amount (LCY)
                                                                                                                                                             //CS074 End
                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                    InsertDataInBuffer();
                UNTIL ValueEntryRec.NEXT() = 0;


        END;
    end;

    local procedure MarkerToFile()
    var
        FileName: Text[200];
    begin
        DataName := Const_DN_Marker;
        SaveString := '';

        SaveString := FORMAT(TODAY, 0, '<Year4>/<Month,2>/<Day,2>');

        InsertDataInBuffer();

    end;

    local procedure ReplaceString(String: Text[1024]; OrigSubStr: Text[100]; ReplSubStr: Text[100]) ReturnInformation: Text[1024]
    var
        StartPos: Integer;
    begin
        // StartPos : Integer
        StartPos := STRPOS(String, OrigSubStr);
        WHILE StartPos > 0 DO BEGIN
            String := DELSTR(String, StartPos) + ReplSubStr + COPYSTR(String, StartPos + STRLEN(OrigSubStr));
            StartPos := STRPOS(String, OrigSubStr);
        END;
        EXIT(String);
    end;

    local procedure ExportInventoryLastMonth()
    var
        FileName: Text[200];
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        ItemRec: Record Item;
        CustomerRec: Record "Customer";
        sumOfRemainingQuantity: Decimal;
        subLineDataExportString: Text[1024];
        currentItem: Code[20];
        currentLocation: Code[10];
        "sumOfCostAmount(Actual)": Decimal;
        unitCost: Decimal;
        ValueEntryRec: Record "Value Entry";
        ItemLedgerEntryRec2: Record "Item Ledger Entry";
    begin
        DataName := Const_DN_InventoryLastMonth;
        //CS064 Begin
        EVALUATE(VarInteger, GeneralLedgerSetupRec."Date for Inventory Last Month");
        IF DATE2DMY(TODAY, 1) < VarInteger THEN
            InventoryBaseDate := CALCDATE('CM', CALCDATE('-CM-1M-1D', TODAY))
        ELSE
            InventoryBaseDate := CALCDATE('CM', CALCDATE('-CM-1D', TODAY));

        SaveString := '';
        currentItem := '';
        currentLocation := '';
        subLineDataExportString := '';
        ItemLedgerEntryRec.RESET();
        ItemLedgerEntryRec.SETCURRENTKEY("Item No.", "Location Code");
        //ItemLedgerEntryRec.FILTERGROUP(1);
        ItemLedgerEntryRec.SETFILTER("Posting Date", '..%1', InventoryBaseDate);
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Data Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Receipt Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Exchange Rate';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';  //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            //SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Inventory Base Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Exclusion Flag'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of SO'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of Work'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of PO'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Good Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Replenishment Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Lending Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Inspection Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Transfer Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Unaccepted Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Defective Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF ItemLedgerEntryRec.FIND('-') THEN//CS059
                REPEAT
                    ItemRec.RESET(); //CS059
                    IF ItemRec.GET(ItemLedgerEntryRec."Item No.") THEN //CS059
                        IF ItemRec.Blocked <> TRUE THEN //CS059
                            IF (currentItem <> ItemLedgerEntryRec."Item No.") OR (currentLocation <> ItemLedgerEntryRec."Location Code") THEN BEGIN
                                currentItem := ItemLedgerEntryRec."Item No.";
                                currentLocation := ItemLedgerEntryRec."Location Code";

                                ItemRec.GET(ItemLedgerEntryRec."Item No."); //CS051

                                SaveString := curCountryRegionCode;//Company Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + '30';//Data Type //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemLedgerEntryRec."Item No.";//Item Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description;//Item Name
                                subLineDataExportString := SaveString + FORMAT(tabPlaceholder);

                                SaveString := '';
                                SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Currency

                                //CS052 Start
                                ItemLedgerEntryRec2.RESET();
                                ItemLedgerEntryRec2.SETRANGE("Document Type", ItemLedgerEntryRec2."Document Type"::"Purchase Receipt");
                                ItemLedgerEntryRec2.SETFILTER("Item No.", currentItem);
                                ItemLedgerEntryRec2.SETFILTER("Location Code", currentLocation);
                                ItemLedgerEntryRec2.SETCURRENTKEY("Item No.", "Location Code", "Posting Date");
                                ItemLedgerEntryRec2.SETASCENDING("Posting Date", FALSE);
                                IF ItemLedgerEntryRec2.FINDFIRST THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemLedgerEntryRec2."Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')//Receipt Date
                                ELSE
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Receipt Date
                                                                                           //CS052 End

                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code

                                SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exchange Rate
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemLedgerEntryRec."Location Code";//Location Code

                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                                                                                                                //SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                                ItemRec.CALCFIELDS("Vendor Name");
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Name";//Vendor Name

                                CustomerRec.RESET();
                                IF ItemRec."Customer No." = '' THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''//Customer Name
                                ELSE BEGIN
                                    CustomerRec.GET(ItemRec."Customer No.");
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                                END;

                                CustomerRec.RESET();
                                IF ItemRec."OEM No." = '' THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                                ELSE BEGIN
                                    CustomerRec.GET(ItemRec."OEM No.");
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                                END;

                                SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(InventoryBaseDate, 0, '<Year4>/<Month,2>/<Day,2>');//Inventory Base Date

                                //BC Update Begin
                                /*
                                //CS051 Begin
                                //IF ItemLedgerEntryRec."Location Code" = 'HOLD' THEN
                                //For HS
                                IF (ItemLedgerEntryRec."Location Code" = 'L1_HOLD') OR (ItemLedgerEntryRec."Location Code" = 'L2_HOLD') THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'//Exclusion Flag
                                ELSE
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                                */

                                ItemLedgerEntryRec.CalcFields(Hold);
                                if ItemLedgerEntryRec.Hold then begin
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'//Exclusion Flag
                                end else begin
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                                end;
                                //BC Update End

                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of SO
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of Work
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of PO
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Good Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Replenishment Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Lending Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Inspection Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Transfer Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Unaccepted Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Defective Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare1
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare2
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare3
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare4
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare5
                                                                                        //CS051 End

                                //CS059 End
                                ValueEntryRec.RESET();
                                ValueEntryRec.SETRANGE("Item No.", currentItem);
                                ValueEntryRec.SETFILTER("Location Code", currentLocation);
                                ValueEntryRec.SETFILTER("Posting Date", '..%1', InventoryBaseDate);
                                ValueEntryRec.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)");

                                sumOfRemainingQuantity := ValueEntryRec."Item Ledger Entry Quantity";//Quantity
                                "sumOfCostAmount(Actual)" := ValueEntryRec."Cost Amount (Actual)" + ValueEntryRec."Cost Amount (Expected)"; //Cost Amount (Actual)

                                CLEAR(unitCost); //CS059
                                IF sumOfRemainingQuantity <> 0 THEN //BEGIN //CS059
                                    unitCost := ROUND("sumOfCostAmount(Actual)" / sumOfRemainingQuantity, GeneralLedgerSetupRec."Unit-Amount Rounding Precision");

                                SaveString := subLineDataExportString + FORMAT(sumOfRemainingQuantity) + FORMAT(tabPlaceholder) + FORMAT(unitCost) + FORMAT(tabPlaceholder) + FORMAT("sumOfCostAmount(Actual)") + SaveString;
                                SaveString := ReplaceString(SaveString, tabChar, '');
                                SaveString := ReplaceString(SaveString, lineChar, '');
                                SaveString := ReplaceString(SaveString, lineChar2, '');
                                SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                                InsertDataInBuffer();
                                //CS059 End
                            END
                            ELSE BEGIN
                            END;
                UNTIL ItemLedgerEntryRec.NEXT() = 0;

        END;
        //CS064 End
    end;

    local procedure ExportInventoryLastWeek()
    var
        FileName: Text[200];
        ItemLedgerEntryRec: Record "Item Ledger Entry";
        ItemRec: Record Item;
        CustomerRec: Record "Customer";
        sumOfRemainingQuantity: Decimal;
        subLineDataExportString: Text[1024];
        currentItem: Code[20];
        currentLocation: Code[10];
        "sumOfCostAmount(Actual)": Decimal;
        unitCost: Decimal;
        ValueEntryRec: Record "Value Entry";
        ItemLedgerEntryRec2: Record "Item Ledger Entry";
    begin
        DataName := Const_DN_InventoryLastWeek;
        //CS064 Begin
        InventoryBaseDate := CALCDATE('-' + GeneralLedgerSetupRec."Days for Inventory Last Week" + 'D', TODAY);

        SaveString := '';
        currentItem := '';
        currentLocation := '';
        subLineDataExportString := '';
        ItemLedgerEntryRec.RESET();
        ItemLedgerEntryRec.SETCURRENTKEY("Item No.", "Location Code");
        //ItemLedgerEntryRec.FILTERGROUP(1);
        ItemLedgerEntryRec.SETFILTER("Posting Date", '..%1', InventoryBaseDate);
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Data Type';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Inventory Group';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Quantity';
            SaveString := SaveString + FORMAT(tabChar) + 'Unit Cost';
            SaveString := SaveString + FORMAT(tabChar) + 'Cost Amount';
            SaveString := SaveString + FORMAT(tabChar) + 'Currency';
            SaveString := SaveString + FORMAT(tabChar) + 'Receipt Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Exchange Rate';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.';  //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Location Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Description 2';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Item No.';
            //SaveString := SaveString + FORMAT(tabChar) + 'Vendor No.'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Manufacturer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Vendor Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Customer Name';
            SaveString := SaveString + FORMAT(tabChar) + 'OEM Name';
            SaveString := SaveString + FORMAT(tabChar) + 'Inventory Base Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Exclusion Flag'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of SO'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of Work'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'In charge of PO'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Good Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Replenishment Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Lending Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Inspection Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Transfer Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Unaccepted Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Defective Inventory'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare1'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4'; //CS051
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5'; //CS051

            InsertDataInBuffer();
            IF ItemLedgerEntryRec.FIND('-') THEN//CS059
                REPEAT
                    ItemRec.RESET(); //CS059
                    IF ItemRec.GET(ItemLedgerEntryRec."Item No.") THEN //CS059
                        IF ItemRec.Blocked <> TRUE THEN //CS059
                            IF (currentItem <> ItemLedgerEntryRec."Item No.") OR (currentLocation <> ItemLedgerEntryRec."Location Code") THEN BEGIN
                                currentItem := ItemLedgerEntryRec."Item No.";
                                currentLocation := ItemLedgerEntryRec."Location Code";

                                ItemRec.GET(ItemLedgerEntryRec."Item No."); //CS051

                                SaveString := curCountryRegionCode;//Company Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + '30';//Data Type //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode + ';' + ItemRec."Customer No." + ';' + ItemRec."OEM No.";//Customer Inventory Group //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemLedgerEntryRec."Item No.";//Item Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec.Description;//Item Name
                                subLineDataExportString := SaveString + FORMAT(tabPlaceholder);

                                SaveString := '';
                                SaveString := SaveString + FORMAT(tabPlaceholder) + GeneralLedgerSetupRec."LCY Code";//Currency

                                //CS052 Start
                                ItemLedgerEntryRec2.RESET();
                                ItemLedgerEntryRec2.SETRANGE("Document Type", ItemLedgerEntryRec2."Document Type"::"Purchase Receipt");
                                ItemLedgerEntryRec2.SETFILTER("Item No.", currentItem);
                                ItemLedgerEntryRec2.SETFILTER("Location Code", currentLocation);
                                ItemLedgerEntryRec2.SETCURRENTKEY("Item No.", "Location Code", "Posting Date");
                                ItemLedgerEntryRec2.SETASCENDING("Posting Date", FALSE);
                                IF ItemLedgerEntryRec2.FINDFIRST THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(ItemLedgerEntryRec2."Posting Date", 0, '<Year4>/<Month,2>/<Day,2>')//Receipt Date
                                ELSE
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Receipt Date
                                                                                           //CS052 End

                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer No.";//Customer Code
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No.";//End Customer Code

                                SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exchange Rate
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemLedgerEntryRec."Location Code";//Location Code

                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Description 2";//Description 2
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Customer Item No.";//Customer Item No.
                                                                                                                //SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor No.";//Vendor No. //CS051
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code";//Manufacturer Code
                                ItemRec.CALCFIELDS("Vendor Name");
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Vendor Name";//Vendor Name

                                CustomerRec.RESET();
                                IF ItemRec."Customer No." = '' THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''//Customer Name
                                ELSE BEGIN
                                    CustomerRec.GET(ItemRec."Customer No.");
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//Customer Name
                                END;

                                CustomerRec.RESET();
                                IF ItemRec."OEM No." = '' THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + ''//OEM Name
                                ELSE BEGIN
                                    CustomerRec.GET(ItemRec."OEM No.");
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + CustomerRec.Name;//OEM Name
                                END;

                                SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(InventoryBaseDate, 0, '<Year4>/<Month,2>/<Day,2>');//Inventory Base Date

                                //BC Update Begin
                                /*
                                //CS051 Begin
                                //IF ItemLedgerEntryRec."Location Code" = 'HOLD' THEN
                                //For HS
                                IF (ItemLedgerEntryRec."Location Code" = 'L1_HOLD') OR (ItemLedgerEntryRec."Location Code" = 'L2_HOLD') THEN
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'//Exclusion Flag
                                ELSE
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                                */

                                ItemLedgerEntryRec.CalcFields(Hold);
                                if ItemLedgerEntryRec.Hold then begin
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'//Exclusion Flag
                                end else begin
                                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Exclusion Flag
                                end;
                                //BC Update End

                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of SO
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of Work
                                SaveString := SaveString + FORMAT(tabPlaceholder) + curCountryRegionCode;//In charge of PO
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Good Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Replenishment Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Lending Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Inspection Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Transfer Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Unaccepted Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Defective Inventory
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare1
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare2
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare3
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare4
                                SaveString := SaveString + FORMAT(tabPlaceholder) + ''; //Spare5
                                                                                        //CS051 End

                                //CS059 End
                                ValueEntryRec.RESET();
                                ValueEntryRec.SETRANGE("Item No.", currentItem);
                                ValueEntryRec.SETFILTER("Location Code", currentLocation);
                                ValueEntryRec.SETFILTER("Posting Date", '..%1', InventoryBaseDate);
                                ValueEntryRec.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)");

                                sumOfRemainingQuantity := ValueEntryRec."Item Ledger Entry Quantity";//Quantity
                                "sumOfCostAmount(Actual)" := ValueEntryRec."Cost Amount (Actual)" + ValueEntryRec."Cost Amount (Expected)"; //Cost Amount (Actual)

                                CLEAR(unitCost); //CS059
                                IF sumOfRemainingQuantity <> 0 THEN //BEGIN //CS059
                                    unitCost := ROUND("sumOfCostAmount(Actual)" / sumOfRemainingQuantity, GeneralLedgerSetupRec."Unit-Amount Rounding Precision");

                                SaveString := subLineDataExportString + FORMAT(sumOfRemainingQuantity) + FORMAT(tabPlaceholder) + FORMAT(unitCost) + FORMAT(tabPlaceholder) + FORMAT("sumOfCostAmount(Actual)") + SaveString;
                                SaveString := ReplaceString(SaveString, tabChar, '');
                                SaveString := ReplaceString(SaveString, lineChar, '');
                                SaveString := ReplaceString(SaveString, lineChar2, '');
                                SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);

                                InsertDataInBuffer();
                                //CS059 End
                            END
                            ELSE BEGIN
                            END;
                UNTIL ItemLedgerEntryRec.NEXT() = 0;

        END;
        //CS064 End
    end;

    local procedure ExportShipAndDebitFlag()
    var
        PurchasePriceRec: Record "Price List Line";
        FileName: Text;
        ItemRec: Record Item;
    begin
        DataName := Const_DN_ShipAndDebitFlag;
        SaveString := '';
        PurchasePriceRec.RESET();
        PurchasePriceRec.SETRANGE("One Renesas EDI", TRUE);  //CS085
        ItemRec.RESET();
        BEGIN

            SaveString := 'Company Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Maker Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Item Code';
            SaveString := SaveString + FORMAT(tabChar) + 'End Customer Code';
            SaveString := SaveString + FORMAT(tabChar) + 'Starting Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Ending Date';
            SaveString := SaveString + FORMAT(tabChar) + 'Ship and Debit Flag';
            //CS110 Begin
            //SaveString := SaveString + FORMAT(tabChar) + 'Spare1';
            SaveString := SaveString + FORMAT(tabChar) + 'Original Item No.';
            //CS110 End
            SaveString := SaveString + FORMAT(tabChar) + 'Spare2';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare3';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare4';
            SaveString := SaveString + FORMAT(tabChar) + 'Spare5';

            InsertDataInBuffer();
            IF PurchasePriceRec.FINDFIRST() THEN
                REPEAT
                    SaveString := curCountryRegionCode; //Company Code
                    ItemRec.GET(PurchasePriceRec."Asset No.");
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Manufacturer Code"; //Manufacturer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + PurchasePriceRec."Asset No.";//Item Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."OEM No."; //End Customer Code
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchasePriceRec."Starting Date", 0, '<Month,2>/<Day,2>/<Year4>');//Starting Date
                    SaveString := SaveString + FORMAT(tabPlaceholder) + FORMAT(PurchasePriceRec."Ending Date", 0, '<Month,2>/<Day,2>/<Year4>');//Ending Date
                    IF PurchasePriceRec."Ship&Debit Flag" THEN //Ship&Debit Flag
                        SaveString := SaveString + FORMAT(tabPlaceholder) + 'True'
                    ELSE
                        SaveString := SaveString + FORMAT(tabPlaceholder) + 'False';
                    //CS110 Begin
                    //SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Spare1
                    SaveString := SaveString + FORMAT(tabPlaceholder) + ItemRec."Original Item No.";//Spare1
                    //CS110 End
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Spare2
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Spare3
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Spare4
                    SaveString := SaveString + FORMAT(tabPlaceholder) + '';//Spare5

                    SaveString := ReplaceString(SaveString, tabChar, '');
                    SaveString := ReplaceString(SaveString, lineChar, '');
                    SaveString := ReplaceString(SaveString, lineChar2, '');
                    SaveString := ReplaceString(SaveString, tabPlaceholder, tabChar);
                    InsertDataInBuffer();
                UNTIL PurchasePriceRec.NEXT() = 0;

        END;
    end;

    procedure InsertDataInBuffer()
    var
        DWHExportBuffer: Record "DWH Export Buffer";
    begin
        DWHExportBuffer.INIT;
        DWHExportBuffer."Data Name" := DataName;
        DWHExportBuffer.INSERT;
        DWHExportBuffer.SetData(SaveString);
        DWHExportBuffer.Modify();
    end;

    procedure DeleteDataInBuffer()
    var
        DWHExportBuffer: Record "DWH Export Buffer";
    begin
        DWHExportBuffer.DELETEALL;
    end;
}

