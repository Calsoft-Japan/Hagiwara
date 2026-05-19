report 50106 "Price List Export"
{

    ProcessingOnly = true;
    Caption = 'Price List Export';
    ApplicationArea = All;

    dataset
    {
        dataitem("PriceList"; "Price List Line")
        {
            RequestFilterFields = "Product No.", "Starting Date", "Ending Date";
            DataItemTableView = where("Asset Type" = const(Item));

            trigger OnPreDataItem()
            begin

                if PurchFirst then begin
                    PriceList.SetRange("Price List Code", G_PriceCode_Purch);
                    PriceList.SetRange("Source Type", Enum::"Price Source Type"::Vendor);
                    PriceList.SetFilter("Assign-to No.", VendNoOpt);
                end else begin
                    PriceList.SetRange("Price List Code", G_PriceCode_Sales);
                    PriceList.SetRange("Source Type", Enum::"Price Source Type"::Customer);
                    PriceList.SetFilter("Assign-to No.", CustNoOpt);
                end;

                TempExcelBuffer.Reset();
                TempExcelBuffer.DeleteAll();

                // prepare header
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(StartingDate_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(EndingDate_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ProductType_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ProductNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CustomerNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesCurrencyCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UnitPrice_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(DirectUnitCost_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchaseCurrencyCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VendorNo_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UnitofMeasureCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(RenesasReportUnitPriceCur_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(RenesasReportUnitPrice_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(OREDebitCost_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ShipDebitFlag_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PCCurrencyCode_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PCDirectUnitCost_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PCUpdatePrice_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PriceLineStatus_Lbl, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

            end;

            trigger OnAfterGetRecord()
            var
                PriceLineCombi: Record "Price List Line";

            begin

                if FormatOnly then begin
                    CurrReport.Skip();
                end;

                if PurchFirst then begin

                    //Get the corresponding Sales Price Line.
                    PriceLineCombi.Reset();
                    PriceLineCombi.SetRange("Price List Code", G_PriceCode_Sales);
                    PriceLineCombi.SetRange("Price Type", Enum::"Price Type"::Sale);
                    PriceLineCombi.SetRange("Source Type", Enum::"Price Source Type"::Customer);
                    PriceLineCombi.SetRange("Asset Type", Enum::"Price Asset Type"::Item);
                    PriceLineCombi.SetRange("Asset No.", PriceList."Asset No.");
                    PriceLineCombi.SetRange("Starting Date", PriceList."Starting Date");
                    PriceLineCombi.SetRange("Ending Date", PriceList."Ending Date");
                    PriceLineCombi.SetFilter("Assign-to No.", CustNoOpt);
                    if not PriceLineCombi.FindFirst() then begin
                        CurrReport.Skip();
                    end;
                end else begin

                    //Get the corresponding Purchase Price Line.
                    PriceLineCombi.Reset();
                    PriceLineCombi.SetRange("Price List Code", G_PriceCode_Purch);
                    PriceLineCombi.SetRange("Price Type", Enum::"Price Type"::Purchase);
                    PriceLineCombi.SetRange("Source Type", Enum::"Price Source Type"::Vendor);
                    PriceLineCombi.SetRange("Asset Type", Enum::"Price Asset Type"::Item);
                    PriceLineCombi.SetRange("Asset No.", PriceList."Asset No.");
                    PriceLineCombi.SetRange("Starting Date", PriceList."Starting Date");
                    PriceLineCombi.SetRange("Ending Date", PriceList."Ending Date");
                    //No need Vendor Filter becuase VendNo should be empty.

                    if not PriceLineCombi.FindFirst() then begin
                        CurrReport.Skip();
                    end;
                end;

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(PriceList."Starting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(PriceList."Ending Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(PriceList."Asset Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PriceList."Asset No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                if PurchFirst then begin

                    TempExcelBuffer.AddColumn(PriceLineCombi."Assign-to No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);


                    TempExcelBuffer.AddColumn(PriceList."Direct Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PriceList."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."Assign-to No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                    TempExcelBuffer.AddColumn(PriceLineCombi."Renesas Report Unit Price Cur.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Renesas Report Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);


                    TempExcelBuffer.AddColumn(PriceList."ORE Debit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PriceList."Ship&Debit Flag", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."PC. Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."PC. Direct Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PriceList."PC. Update Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList.Status, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                end else begin

                    TempExcelBuffer.AddColumn(PriceList."Assign-to No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

                    TempExcelBuffer.AddColumn(PriceLineCombi."Direct Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Assign-to No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Unit of Measure Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                    TempExcelBuffer.AddColumn(PriceList."Renesas Report Unit Price Cur.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceList."Renesas Report Unit Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

                    TempExcelBuffer.AddColumn(PriceLineCombi."ORE Debit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PriceLineCombi."Ship&Debit Flag", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."PC. Currency Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi."PC. Direct Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PriceLineCombi."PC. Update Price", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PriceLineCombi.Status, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

                end;

            end;

            trigger OnPostDataItem()
            begin

                SheetName := 'PriceList';
                ExcelFileName := 'PriceList_%1';
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
                    field(VendNoOpt; VendNoOpt)
                    {
                        Caption = 'Vendor No.';
                        ApplicationArea = All;
                        ToolTip = 'Price data matching this filter will be exported. Maximum length: 250 characters.';
                    }
                    field(CustNoOpt; CustNoOpt)
                    {
                        Caption = 'Customer No.';
                        ApplicationArea = All;
                        ToolTip = 'Price data matching this filter will be exported. Maximum length: 250 characters.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitReport()
    begin
        G_PriceCode_Sales := 'S00001';
        G_PriceCode_Purch := 'P00001';
    end;

    trigger OnPreReport()
    begin

        //Except the Vendor No. is empty and Customer No. is not empty,
        //The report will be iterated through Purchase Price List Lines first as the primary driver.
        PurchFirst := true;
        if (VendNoOpt = '') and (CustNoOpt <> '') then begin
            PurchFirst := false;
        end;
    end;

    var
        G_PriceCode_Sales: Code[20];
        G_PriceCode_Purch: Code[20];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FormatOnly: Boolean;
        CustNoOpt: Text[250];
        VendNoOpt: Text[250];
        PurchFirst: Boolean;

        SheetName: Text[50];
        ExcelFileName: Text[50];

        StartingDate_Lbl: Label 'Starting Date';
        EndingDate_Lbl: Label 'Ending Date';
        ProductType_Lbl: Label 'Product Type';
        ProductNo_Lbl: Label 'Product No.';
        CustomerNo_Lbl: Label 'Customer No.';
        SalesCurrencyCode_Lbl: Label 'Sales Currency Code';
        UnitPrice_Lbl: Label 'Unit Price';
        DirectUnitCost_Lbl: Label 'Direct Unit Cost';
        PurchaseCurrencyCode_Lbl: Label 'Purchase Currency Code';
        VendorNo_Lbl: Label 'Vendor No.';
        UnitofMeasureCode_Lbl: Label 'Unit of Measure Code';
        RenesasReportUnitPriceCur_Lbl: Label 'Renesas Report Unit Price Cur.';
        RenesasReportUnitPrice_Lbl: Label 'Renesas Report Unit Price';
        OREDebitCost_Lbl: Label 'ORE Debit Cost';
        ShipDebitFlag_Lbl: Label 'Ship&Debit Flag';
        PCCurrencyCode_Lbl: Label 'PC. Currency Code';
        PCDirectUnitCost_Lbl: Label 'PC. Direct Unit Cost';
        PCUpdatePrice_Lbl: Label 'PC. Update Price';
        PriceLineStatus_Lbl: Label 'Price Line Status';


}

