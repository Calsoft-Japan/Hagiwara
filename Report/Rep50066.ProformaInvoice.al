report 50066 "Proforma Invoice"
{
    // CS019 Tony 6/29/2021 - Performa Invoice
    // CS038 Kenya 2022/03/27 - HEE Sales Invoice Enhancement
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Proforma Invoice.rdlc';

    Caption = 'Proforma Invoice';
    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Salesperson Code", Priority;
            column(CustomerNo; "No.")
            {
            }
            column(HomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyAddress1; CompanyAddress[1])
            {
            }
            column(CompanyAddress2; CompanyAddress[2])
            {
            }
            column(CompanyAddress3; CompanyAddress[3])
            {
            }
            column(CompanyAddress4; CompanyAddress[4])
            {
            }
            column(CompanyAddress5; CompanyAddress[5])
            {
            }
            column(CompanyAddress6; CompanyAddress[6])
            {
            }
            column(Logo; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
                AutoFormatType = 1;
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CountryName; CountryName)
            {
            }
            column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_FaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_CommercialRegister; CompanyInfo."Commercial Register")
            {
            }
            column(VatRegistrationNoText; VatRegistrationNoText)
            {
            }
            column(CeoText; CEOText)
            {
            }
            column(BankText; BANKText)
            {
            }
            column(IBANText; IBANText)
            {
            }
            column(ShipFrom; ShipFrom)
            {
            }
            column(FiscalRepresentative; FiscalRepresentative)
            {
            }
            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Document Type" = CONST(Order),
                                          Type = CONST(Item),
                                          "Outstanding Quantity" = FILTER(> 0));
                RequestFilterFields = "Shipment Date", "OEM No.", Blocked;
                column(InvoiceDate; FORMAT(InvoiceDate, 11, '<Day>/<Month Text,3>/<Year4>'))
                {
                }
                column(SalesNo; "Document No.")
                {
                }
                column(InvoiceNo; InvoiceNo)
                {
                }
                column(TradeTerms; TradeTerms)
                {
                }
                column(BilltoCustomerNo; BillToCustNo)
                {
                }
                column(ShipToContact; ShipToContact)
                {
                }
                column(PhoneNo; PhoneNo)
                {
                }
                column(SellToCustomerNo; SellToCustNo)
                {
                }
                column(SellToAddr; SellToAddr)
                {
                }
                column(SellToAddr2; SellToAddr2)
                {
                }
                column(SellToAddr3; SellToAddr3)
                {
                }
                column(SellToAddr4; SellToAddr4)
                {
                }
                column(ShipToName; ShipToName)
                {
                }
                column(ShipToAddr; ShipToAddr)
                {
                }
                column(ShipToAddr2; ShipToAddr2)
                {
                }
                column(ShipToAddr3; ShipToAddr3)
                {
                }
                column(ShipToAddr4; ShipToAddr4)
                {
                }
                column(ShipToCode; ShipToCode)
                {
                }
                column(SellToCustomerName; SellToCustomerName)
                {
                }
                column(ShipToAddressType; ShipToAddressType)
                {
                }
                column(CustomNo; CustomNo)
                {
                }
                column(CurrencyCode1; CurrencyCodeArr[1])
                {
                }
                column(CurrencyCode2; CurrencyCodeArr[2])
                {
                }
                column(CurrencyCode3; CurrencyCodeArr[3])
                {
                }
                column(CurrencyAmount1; CurrencyAmountArr[1])
                {
                }
                column(CurrencyAmount2; CurrencyAmountArr[2])
                {
                }
                column(CurrencyAmount3; CurrencyAmountArr[3])
                {
                }
                column(TotalQty; TotalQty)
                {
                }
                column(Group; GroupNum)
                {
                }
                column(LineNo_Line; "Line No.")
                {
                }
                column(CustomerOrderNo_Line; "Customer Order No.")
                {
                }
                column(CustomerItemNo_Line; "Customer Item No.")
                {
                }
                column(Description_Line; Description)
                {
                }
                column(TariffDescription_Line; TariffDescription)
                {
                }
                column(TariffNo_Line; TariffNo)
                {
                }
                column(CountryRegionOC_Line; CountryRegionOC)
                {
                }
                column(Quantity_Line; "Outstanding Quantity")
                {
                }
                column(UOM_Line; "Unit of Measure Code")
                {
                }
                column(UnitPrice_Line; "Unit Price")
                {
                }
                column(CurrencyCode_Line; "Currency Code")
                {
                }
                column(Amount_Line; "Outstanding Quantity" * "Unit Price")
                {
                }
                column(Amount1_Line; CurrencyAmountLineArr[1])
                {
                }
                column(Amount2_Line; CurrencyAmountLineArr[2])
                {
                }
                column(Amount3_Line; CurrencyAmountLineArr[3])
                {
                }

                trigger OnAfterGetRecord()
                var
                    str: Text;
                    KeyName: Code[50];
                    i: Integer;
                begin
                    SellToAddr := '';
                    SellToAddr2 := '';
                    SellToAddr3 := '';
                    SellToAddr4 := '';
                    ShipToAddr := '';
                    ShipToAddr2 := '';
                    ShipToAddr3 := '';
                    ShipToAddr4 := '';
                    PhoneNo := '';
                    TradeTerms := '';
                    BillToCustNo := '';
                    ShipToContact := '';
                    SellToCustNo := '';
                    ShipToName := '';
                    ShipToCode := '';
                    CLEAR(CurrencyCodeArr);
                    CLEAR(CurrencyAmountArr);
                    CLEAR(CurrencyAmountLineArr);
                    SellToCustomerName := '';
                    SalesHeader.RESET;
                    SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SETRANGE("No.", "Document No.");
                    SalesHeader.SETCURRENTKEY("Document Type", "Sell-to Customer No.", "Ship-to Address Type", "Ship-to Code", "Shipment Method Code", "No.");
                    IF SalesHeader.FIND('-') THEN BEGIN
                        KeyName := SalesHeader."Sell-to Customer No." + '|' + FORMAT(SalesHeader."Ship-to Address Type") + '|' + SalesHeader."Ship-to Code" + '|' + SalesHeader."Shipment Method Code";
                        TradeTerms := SalesHeader."Shipment Method Code";
                        BillToCustNo := SalesHeader."Bill-to Customer No.";
                        ShipToContact := SalesHeader."Ship-to Contact";
                        SellToCustNo := SalesHeader."Sell-to Customer No.";
                        ShipToName := SalesHeader."Ship-to Name";
                        SellToCustomerName := SalesHeader."Sell-to Customer Name";
                        ShipToAddressType := SalesHeader."Ship-to Address Type";
                        ShipToCode := SalesHeader."Ship-to Code";

                        TempTotalNum.RESET;
                        TempTotalNum.SETRANGE("Applies-to ID", KeyName);
                        IF TempTotalNum.FIND('-') THEN BEGIN
                            TotalQty := TempTotalNum."Closed by Amount";
                            GroupNum := TempTotalNum."Entry No.";
                            IF TempTotalNum."Currency Code" <> 'NONE' THEN
                                CurrencyCodeArr[1] := TempTotalNum."Currency Code";
                            CurrencyAmountArr[1] := TempTotalNum."Sales (LCY)";
                            IF TempTotalNum."Global Dimension 1 Code" <> 'NONE' THEN
                                CurrencyCodeArr[2] := TempTotalNum."Global Dimension 1 Code";
                            CurrencyAmountArr[2] := TempTotalNum."Profit (LCY)";
                            IF TempTotalNum."Global Dimension 2 Code" <> 'NONE' THEN
                                CurrencyCodeArr[3] := TempTotalNum."Global Dimension 2 Code";
                            CurrencyAmountArr[3] := TempTotalNum."Inv. Discount (LCY)";
                            IF "Currency Code" = '' THEN
                                CurrencyAmountLineArr[1] := "Outstanding Quantity" * "Unit Price"
                            ELSE
                                IF "Currency Code" = CurrencyCodeArr[2] THEN
                                    CurrencyAmountLineArr[2] := "Outstanding Quantity" * "Unit Price"
                                ELSE
                                    IF "Currency Code" = CurrencyCodeArr[3] THEN
                                        CurrencyAmountLineArr[3] := "Outstanding Quantity" * "Unit Price";
                        END;
                        //Sold To
                        SellToAddr := SalesHeader."Sell-to Address";
                        IF SalesHeader."Sell-to Address 2" <> '' THEN BEGIN
                            SellToAddr2 := SalesHeader."Sell-to Address 2";
                            SellToAddr3 := SalesHeader."Sell-to City";
                            IF SalesHeader."Sell-to County" <> '' THEN
                                SellToAddr3 := SellToAddr3 + ', ' + SalesHeader."Sell-to County" + ' ' + SalesHeader."Sell-to Post Code"
                            ELSE
                                SellToAddr3 := SellToAddr3 + ' ' + SalesHeader."Sell-to Post Code";
                            IF SalesHeader."Sell-to Country/Region Code" <> '' THEN BEGIN
                                IF CountryRegion.GET(SalesHeader."Sell-to Country/Region Code") THEN
                                    SellToAddr4 := CountryRegion.Name;
                            END;
                        END
                        ELSE BEGIN
                            SellToAddr2 := SalesHeader."Sell-to City";
                            IF SalesHeader."Sell-to County" <> '' THEN
                                SellToAddr2 := SellToAddr2 + ', ' + SalesHeader."Sell-to County" + ' ' + SalesHeader."Sell-to Post Code"
                            ELSE
                                SellToAddr2 := SellToAddr2 + ' ' + SalesHeader."Sell-to Post Code";
                            IF SalesHeader."Sell-to Country/Region Code" <> '' THEN BEGIN
                                IF CountryRegion.GET(SalesHeader."Sell-to Country/Region Code") THEN
                                    SellToAddr3 := CountryRegion.Name;
                            END;
                        END;

                        //Ship to
                        ShipToAddr := SalesHeader."Ship-to Address";
                        IF SalesHeader."Ship-to Address 2" <> '' THEN BEGIN
                            ShipToAddr2 := SalesHeader."Ship-to Address 2";
                            ShipToAddr3 := SalesHeader."Ship-to City";
                            IF SalesHeader."Ship-to County" <> '' THEN
                                ShipToAddr3 := ShipToAddr3 + ', ' + SalesHeader."Ship-to County" + ' ' + SalesHeader."Ship-to Post Code"
                            ELSE
                                ShipToAddr3 := ShipToAddr3 + ' ' + SalesHeader."Ship-to Post Code";
                            IF SalesHeader."Ship-to Country/Region Code" <> '' THEN BEGIN
                                IF CountryRegion.GET(SalesHeader."Ship-to Country/Region Code") THEN
                                    ShipToAddr4 := CountryRegion.Name;
                            END;
                        END
                        ELSE BEGIN
                            ShipToAddr2 := SalesHeader."Ship-to City";
                            IF SalesHeader."Ship-to County" <> '' THEN
                                ShipToAddr2 := ShipToAddr2 + ', ' + SalesHeader."Ship-to County" + ' ' + SalesHeader."Ship-to Post Code"
                            ELSE
                                ShipToAddr2 := ShipToAddr2 + ' ' + SalesHeader."Ship-to Post Code";
                            IF SalesHeader."Ship-to Country/Region Code" <> '' THEN BEGIN
                                IF CountryRegion.GET(SalesHeader."Ship-to Country/Region Code") THEN
                                    ShipToAddr3 := CountryRegion.Name;
                            END;
                        END;

                        //Phone
                        IF SalesHeader."Ship-to Address Type" = SalesHeader."Ship-to Address Type"::"Sell-to" THEN BEGIN
                            IF CustomerRec.GET(SalesHeader."Sell-to Customer No.") THEN
                                PhoneNo := CustomerRec."Phone No.";
                        END
                        ELSE
                            IF SalesHeader."Ship-to Address Type" = SalesHeader."Ship-to Address Type"::"Ship-to" THEN BEGIN
                                IF ShipToAddress.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code") THEN
                                    PhoneNo := ShipToAddress."Phone No.";
                            END;

                        IF SalesHeader."Ship-to Address Type" = SalesHeader."Ship-to Address Type"::Custom THEN
                            CustomNo := SalesHeader."No."
                        ELSE
                            CustomNo := 'None';

                        //Fiscal Representative, VAT Regiesration
                        CLEAR(ShipFrom); //CS038
                        CLEAR(FiscalRepresentative);
                        Location.RESET;
                        IF (Location.GET("Location Code")) THEN BEGIN
                            ShipFrom := STRSUBSTNO(ShipFromText, Location.City, Location.County, Location."Vat Registration No."); //CS038
                                                                                                                                   //FiscalRepresentative := STRSUBSTNO(FiscalRepresentativeText, Location.Name, Location.Address, Location."Post Code", Location.City, Location.County, Location."Vat Registration No."); //CS038
                            FiscalRepresentative := Location."Fiscal Representative"; //CS038
                            IF CountryRegion.GET(Location."Country/Region Code") THEN
                                VatRegistrationNoText := 'VAT ID No.: ' + Location."Vat Registration No."
                            ELSE
                                VatRegistrationNoText := '';
                        END;

                    END;

                    TariffDescription := '';
                    TariffNo := '';
                    CountryRegionOC := '';
                    IF ItemRec.GET("No.") THEN BEGIN
                        TariffNo := ItemRec."Tariff No.";
                        IF TariffNumber.GET(TariffNo) THEN
                            TariffDescription := TariffNumber.Description;
                        IF CustomerRec.GET(SellToCustNo) THEN BEGIN
                            IF CustomerRec."Default Country/Region of Org" = CustomerRec."Default Country/Region of Org"::"Front-end" THEN BEGIN
                                CountryRegionOC := ItemRec."Country/Region of Org Cd (FE)";
                            END
                            ELSE BEGIN
                                CountryRegionOC := ItemRec."Country/Region of Origin Code";
                            END;
                        END;
                    END;

                    IF PrintToExcel THEN
                        MakeExcelDataBody;
                end;
            }

            trigger OnAfterGetRecord()
            var
                i: Integer;
                isExist: Boolean;
                MaxCC: Integer;
                KeyName: Code[50];
                ExistItem: array[3] of Boolean;
                mySalesLine: Record "Sales Line";
            begin
                TempTotalNum.DELETEALL;
                CustomerNo := "No.";

                SalesHeader.RESET;
                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                SalesHeader.SETRANGE("Sell-to Customer No.", CustomerNo);
                SalesHeader.SETCURRENTKEY("Document Type", "Sell-to Customer No.", "Ship-to Address Type", "Ship-to Code", "Shipment Method Code", "No.");
                IF SalesHeader.FIND('-') THEN BEGIN
                    IF PrintToExcel THEN
                        MakeExcelInfo();
                    REPEAT
                        CLEAR(CurrencyCodeArr);
                        CLEAR(CurrencyAmountArr);
                        CCEmptyAmount := 0;
                        MaxCC := 0;
                        TotalQty := 0;
                        CurrencyCodeArr[1] := 'NONE';
                        CurrencyAmountArr[1] := 0;
                        KeyName := SalesHeader."Sell-to Customer No." + '|' + FORMAT(SalesHeader."Ship-to Address Type") + '|' + SalesHeader."Ship-to Code" + '|' + SalesHeader."Shipment Method Code";
                        mySalesLine.RESET;
                        mySalesLine.SETRANGE("Document Type", mySalesLine."Document Type"::Order);
                        mySalesLine.SETRANGE("Document No.", SalesHeader."No.");
                        mySalesLine.SETRANGE(Type, mySalesLine.Type::Item);
                        mySalesLine.SETFILTER("Outstanding Quantity", '>0');
                        IF mySalesLine.FIND('-') THEN BEGIN
                            REPEAT
                                IF mySalesLine."Currency Code" <> '' THEN BEGIN
                                    isExist := FALSE;
                                    FOR i := 2 TO 3 DO BEGIN
                                        IF CurrencyCodeArr[i] = UPPERCASE(mySalesLine."Currency Code") THEN BEGIN
                                            CurrencyAmountArr[i] := CurrencyAmountArr[i] + mySalesLine."Outstanding Quantity" * mySalesLine."Unit Price";
                                            isExist := TRUE;
                                            BREAK;
                                        END;
                                    END;
                                    IF NOT isExist THEN BEGIN
                                        MaxCC := MaxCC + 1;
                                        FOR i := 2 TO 3 DO BEGIN
                                            IF CurrencyCodeArr[i] = '' THEN BEGIN
                                                CurrencyCodeArr[i] := UPPERCASE(mySalesLine."Currency Code");
                                                CurrencyAmountArr[i] := mySalesLine."Outstanding Quantity" * mySalesLine."Unit Price";
                                                BREAK;
                                            END;
                                        END;
                                    END;
                                END
                                ELSE BEGIN
                                    CurrencyAmountArr[1] := CurrencyAmountArr[1] + mySalesLine."Outstanding Quantity" * mySalesLine."Unit Price";
                                END;
                                TotalQty := TotalQty + mySalesLine."Outstanding Quantity";
                            UNTIL mySalesLine.NEXT = 0;
                        END;
                        TempTotalNum.RESET;
                        TempTotalNum.SETRANGE("Applies-to ID", KeyName);
                        IF TempTotalNum.FIND('-') THEN BEGIN
                            TempTotalNum."Closed by Amount" := TempTotalNum."Closed by Amount" + TotalQty;
                            CLEAR(ExistItem);
                            FOR i := 1 TO 3 DO BEGIN
                                IF CurrencyCodeArr[i] <> '' THEN BEGIN
                                    IF TempTotalNum."Currency Code" = CurrencyCodeArr[i] THEN BEGIN
                                        TempTotalNum."Sales (LCY)" := TempTotalNum."Sales (LCY)" + CurrencyAmountArr[i];
                                        ExistItem[i] := TRUE;
                                    END
                                    ELSE
                                        IF TempTotalNum."Global Dimension 1 Code" = CurrencyCodeArr[i] THEN BEGIN
                                            TempTotalNum."Profit (LCY)" := TempTotalNum."Profit (LCY)" + CurrencyAmountArr[i];
                                            ExistItem[i] := TRUE;
                                        END
                                        ELSE
                                            IF TempTotalNum."Global Dimension 2 Code" = CurrencyCodeArr[i] THEN BEGIN
                                                TempTotalNum."Inv. Discount (LCY)" := TempTotalNum."Inv. Discount (LCY)" + CurrencyAmountArr[i];
                                                ExistItem[i] := TRUE;
                                            END;
                                END;
                            END;
                            FOR i := 1 TO 3 DO BEGIN
                                IF NOT ExistItem[i] THEN BEGIN
                                    IF TempTotalNum."Currency Code" = '' THEN BEGIN
                                        TempTotalNum."Currency Code" := CurrencyCodeArr[i];
                                        TempTotalNum."Sales (LCY)" := CurrencyAmountArr[i];
                                    END
                                    ELSE
                                        IF TempTotalNum."Global Dimension 1 Code" = '' THEN BEGIN
                                            TempTotalNum."Global Dimension 1 Code" := CurrencyCodeArr[i];
                                            TempTotalNum."Profit (LCY)" := CurrencyAmountArr[i];
                                        END
                                        ELSE
                                            IF TempTotalNum."Global Dimension 2 Code" = '' THEN BEGIN
                                                TempTotalNum."Global Dimension 2 Code" := CurrencyCodeArr[i];
                                                TempTotalNum."Inv. Discount (LCY)" := CurrencyAmountArr[i];
                                            END
                                END;
                            END;
                            TempTotalNum.MODIFY;
                        END
                        ELSE BEGIN
                            TempTotalNum.INIT;
                            TempTotalNum."Customer No." := SalesHeader."Sell-to Customer No.";
                            TempTotalNum."Posting Date" := TODAY;
                            TempTotalNum."Applies-to ID" := KeyName;
                            TempTotalNum."Closed by Amount" := TotalQty;
                            TempTotalNum."Sales (LCY)" := CurrencyAmountArr[1];
                            TempTotalNum."Profit (LCY)" := CurrencyAmountArr[2];
                            TempTotalNum."Inv. Discount (LCY)" := CurrencyAmountArr[3];
                            TempTotalNum."Currency Code" := CurrencyCodeArr[1];
                            TempTotalNum."Global Dimension 1 Code" := CurrencyCodeArr[2];
                            TempTotalNum."Global Dimension 2 Code" := CurrencyCodeArr[3];
                            TempTotalNum."Entry No." := EntryNo;
                            TempTotalNum.INSERT;
                            EntryNo := EntryNo + 1;
                        END;
                    UNTIL SalesHeader.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    Visible = false;
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.SETAUTOCALCFIELDS(Picture);
        CompanyInfo.GET();
        GetCompanyAddress(CompanyAddress, CompanyInfo);
        InvoiceDate := WORKDATE;
        EntryNo := 1;
        CountryRegion.GET(CompanyInfo."Country/Region Code");
        CountryName := CountryRegion.Name;
        CEOText := STRSUBSTNO(CEO, CompanyInfo."CEO 1", CompanyInfo."CEO 2", CompanyInfo."CEO 3");
        BANKText := STRSUBSTNO(Bank, CompanyInfo."Bank Name", CompanyInfo."Bank Account No.", CompanyInfo."Bank Branch No.");
        IBANText := STRSUBSTNO(IBAN, CompanyInfo.IBAN, CompanyInfo."SWIFT Code");
    end;

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook();
    end;

    trigger OnPreReport()
    begin
        FilterString := Customer.GETFILTERS();
    end;

    var
        CompanyInfo: Record "Company Information";
        ShipToAddress: Record "Ship-to Address";
        ShipmentMethod: Record "Shipment Method";
        TariffNumber: Record "Tariff Number";
        ItemRec: Record Item;
        CustomerRec: Record Customer;
        CountryRegion: Record "Country/Region";
        SalesHeader: Record "Sales Header";
        TempTotalNum: Record "Cust. Ledger Entry" temporary;
        ExcelBuf: Record "Excel Buffer" temporary;
        CompanyAddress: array[6] of Text[100];
        SalesNo: Code[20];
        SellToAddr: Text;
        ShipToAddr: Text;
        InvoiceDate: Date;
        InvoiceNo: Text;
        PhoneNo: Text;
        TariffDescription: Text[100];
        TariffNo: Code[20];
        CountryRegionOC: Code[10];
        CurrencyCodeArr: array[3] of Code[10];
        CurrencyAmountArr: array[3] of Decimal;
        CurrencyAmountLineArr: array[3] of Decimal;
        FormatAddr: Codeunit "Format Address";
        TradeTerms: Code[10];
        BillToCustNo: Code[20];
        ShipToContact: Text[50];
        SellToCustNo: Code[20];
        ShipToName: Text[50];
        SellToCustomerName: Text[50];
        ShipToAddressType: Integer;
        ShipToCode: Code[10];
        CustomerNo: Code[20];
        CCEmptyAmount: Decimal;
        TotalQty: Decimal;
        EntryNo: Integer;
        GroupNum: Integer;
        PrintToExcel: Boolean;
        CompanyNameLbl: Label 'Company Name';
        ReportNoLbl: Label 'Report No.';
        ReportNameLbl: Label 'Report Name';
        UserIDLbl: Label 'User ID';
        DateTimeLbl: Label 'Date / Time';
        CustomerFiltersLbl: Label 'Customer Filters';
        ReportName: Label 'Performa Invoice';
        FilterString: Text;
        SellToAddr2: Text;
        SellToAddr3: Text;
        SellToAddr4: Text;
        ShipToAddr2: Text;
        ShipToAddr3: Text;
        ShipToAddr4: Text;
        CustomNo: Code[20];
        CountryName: Text;
        CEOText: Text[256];
        BANKText: Text[256];
        IBANText: Text[256];
        CEO: Label 'CEO: %1, %2, %3';
        FiscalRepresentativeText: Label 'Ship from/Fiscal representative:%1, %2, %3 %4, %5    VAT ID No.: %6';
        Bank: Label '%1    Account No.: %2    BLZ: %3';
        IBAN: Label 'IBAN: %1    SWIFT: %2';
        FiscalRepresentative: Text[250];
        Location: Record Location;
        VatRegistrationNoText: Text;
        ShipFrom: Text[250];
        ShipFromText: Label 'Ship from:%1, %2    VAT ID No.: %3';

    local procedure GetCompanyAddress(var CompanyAddr: array[6] of Text[100]; var CompanyInfo: Record "Company Information")
    var
        str: Text;
        CountryRegion: Record "Country/Region";
    begin
        CLEAR(CompanyAddr);
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyAddr[2] := CompanyInfo.Address;
        str := '';
        IF CompanyInfo."Post Code" <> '' THEN
            str := CompanyInfo."Post Code";
        IF CompanyInfo.City <> '' THEN BEGIN
            IF str <> '' THEN
                str := str + ' ' + CompanyInfo.City
            ELSE
                str := CompanyInfo.City;
        END;
        CompanyAddr[3] := str;
        CompanyAddr[4] := '';
        IF CompanyInfo."Country/Region Code" <> '' THEN BEGIN
            IF CountryRegion.GET(CompanyInfo."Country/Region Code") THEN
                CompanyAddr[4] := CountryRegion.Name;
        END;
        CompanyAddr[5] := CompanyInfo.County;
        CompanyAddr[6] := CompanyInfo."Phone No.";
    end;

    local procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', 'Data', ReportName, COMPANYNAME, USERID);
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Customer Order No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Item No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Tariff Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Tariff No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Country/Region of Origin Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Quantity', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Unit of Measure', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Unit Price', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Currency', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet();
        ExcelBuf.AddInfoColumn(FORMAT(CompanyNameLbl), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(CompanyInfo.Name, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(ReportNameLbl), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(ReportName, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(ReportNoLbl), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Proforma Invoice", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(UserIDLbl), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID(), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(DateTimeLbl), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY(), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddInfoColumn(TIME(), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.NewRow();
        ExcelBuf.AddInfoColumn(FORMAT(CustomerFiltersLbl), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FilterString, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.ClearNewRow();
        MakeExcelDataHeader();
    end;

    local procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(SalesLine."Customer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesLine."Customer Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TariffDescription, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TariffNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CountryRegionOC, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesLine."Outstanding Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(SalesLine."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesLine."Currency Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(SalesLine.Amount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
    end;
}

