report 50015 "Sales - Invoice (Item/CustPN)"
{
    // HG1.00 - Upgrade from Nav 3.60 to Nav Dynamics 5.00 (SG)
    // CS036 Leon 2022/01/26 - PO,SI Report Header Modification
    // CS092 FDD R007 Bobby.Ji 2025/6/25 - Upgade to the BC version

    //DefaultLayout = RDLC;
    //RDLCLayout = './RDLC/Sales - Invoice (ItemCustPN).rdlc';

    Caption = 'Sales - Invoice (Item No + Customer P/N)';
    Permissions = TableData 7190 = rimd;
    DefaultRenderingLayout = "Sales - Invoice (ItemCustPN).rdlc";

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(No_SalesInvHeader; "No.")
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(SubtotalCaption; SubtotalCaptionLbl)
            {
            }
            column(SubtotalVATCaption; SubtotalVATCaptionLbl)
            {
            }
            column(GrandTotalCaption; GrandTotalCaptionLbl)
            {
            }
            column(ESign; ESignTenantMedia.Content)
            {
                //N005
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyInfoPicture; CompanyInfo.Picture)
                    {
                    }
                    column(HdrAddrLine1; UPPERCASE(CompanyInfo.Name))
                    {
                    }
                    column(HdrAddrLine2; UPPERCASE(CompanyInfo."Name 2") + ' ' + UPPERCASE(CompanyInfo.Address))
                    {
                    }
                    column(HdrAddrLine3; UPPERCASE(CompanyInfo."Address 2") + ' ' + UPPERCASE(Country.Name) + '.')
                    {
                    }
                    column(HdrAddrLine4; 'TEL:' + UPPERCASE(CompanyInfo."Phone No.") + '     FAX:' + UPPERCASE(CompanyInfo."Fax No."))
                    {
                    }
                    column(HdrAddrLine5; 'TAX ID: ' + UPPERCASE(CompanyInfo."VAT Registration No.") + ' ' + UPPERCASE(CompanyInfo."Register Type"))
                    {
                    }
                    column(CompanyPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr7; CompanyAddr[7])
                    {
                    }
                    column(CompanyAddr8; CompanyAddr[8])
                    {
                    }
                    column(DocCaptionCopyText; STRSUBSTNO(DocumentCaption, CopyText))
                    {
                    }
                    column(CustAddr1; "Sales Invoice Header"."Sell-to Customer Name")
                    {
                    }
                    column(CustAddr2; "Sales Invoice Header"."Sell-to Address")
                    {
                    }
                    column(CustAddr3; "Sales Invoice Header"."Sell-to Address 2")
                    {
                    }
                    column(CustAddr4; "Sales Invoice Header"."Sell-to City")
                    {
                    }
                    column(CustAddr5; "Sales Invoice Header"."Sell-to Post Code")
                    {
                    }
                    column(CustAddr6; CountrySold)
                    {
                    }
                    column(ShipToAddr1; "Sales Invoice Header"."Ship-to Name")
                    {
                    }
                    column(ShipToAddr2; "Sales Invoice Header"."Ship-to Address")
                    {
                    }
                    column(ShipToAddr3; "Sales Invoice Header"."Ship-to Address 2")
                    {
                    }
                    column(ShipToAddr4; "Sales Invoice Header"."Ship-to City")
                    {
                    }
                    column(ShipToAddr5; "Sales Invoice Header"."Ship-to Post Code")
                    {
                    }
                    column(ShipToAddr6; CountryShip)
                    {
                    }
                    column(ShipToAddr7; TelNo)
                    {
                    }
                    column(ShipToAddr8; "Sales Invoice Header"."Ship-to Contact")
                    {
                    }
                    column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                    {
                    }
                    column(SelltoAddressCaption; SelltoAddressCaptionLbl)
                    {
                    }
                    column(SalesInvHeaderNo1; "Sales Invoice Header"."No.")
                    {
                    }
                    column(ShipMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(CompInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompInfoBankBranchNo; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(CompInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompInfoBranchCode; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompInfoSwiftCode; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompInfoSwiftCodeCaption; SwiftCodeCaptionLbl)
                    {
                    }
                    column(DueDate_SalesInvHeader; FORMAT("Sales Invoice Header"."Due Date", 0, '<Day>. <Month text,3> <Year4>'))
                    {
                    }
                    column(CompAddr1; CompanyInfo.Name)
                    {
                    }
                    column(CompAddr2; CompanyInfo."Signature Name")
                    {
                    }
                    column(DocumentDate04_SalesInvHeader; FORMAT("Sales Invoice Header"."Document Date", 0, '<Day>. <Month text,3> <Year4>'))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(BankAccountNoCaption; BankAccountNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl)
                    {
                    }
                    column(ShipmentMethodDescriptionCaption; ShipmentMethodDescriptionCaptionLbl)
                    {
                    }
                    column(FromCaption; FromCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(AttnCaption; AttnCaptionLbl)
                    {
                    }
                    column(CountryFrom; CountryFrom)
                    {
                    }
                    column(CountryTo; CountryTo)
                    {
                    }
                    column(g_ShipFrom_SalesInvHeader; g_ShipFrom)
                    {
                    }
                    column(g_ShipFromName_SalesInvHeader; g_ShipFromName)
                    {
                    }
                    column(g_ShipFromAddr_SalesInvHeader; g_ShipFromAddr)
                    {
                    }
                    column(Cust_ShipFromName; Cust."Ship From Name")
                    {
                    }
                    column(Cust_VATRegistrationNo; Cust."VAT Registration No.")
                    {
                    }
                    column(Cust_HQType; Cust.HQType)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number1_IntergerLine; DimensionLoop1.Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(LineAmt_SalesInvLine; "Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_SalesInvLine; Description)
                        {
                        }
                        column(No_SalesInvLine; "No.")
                        {
                        }
                        column(ItemType_SalesInvLine; ItemType)
                        {
                        }
                        column(CustOrderNo_SalesInvLine; "Customer Order No.")
                        {
                        }
                        column(CustItemNo_SalesInvLine; "Customer Item No.")
                        {
                        }
                        column(PartsNo_SalesInvLine; "Parts No.")
                        {
                        }
                        column(Rank_SalesInvLine; Rank)
                        {
                        }
                        column(Qty_SalesInvLine; Quantity)
                        {
                        }
                        column(UnitMeasure_SalesInvLine; "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Unit Price")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(SalesLineType_SalesInvLine; FORMAT("Sales Invoice Line".Type))
                        {
                        }
                        column(UOM_SalesInvLine; UOM)
                        {
                        }
                        column(Amount__SalesInvLine; Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalAmount__SalesInvLine; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT__SalesInvLine; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT__SalesInvLine; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(GSTAmtLineGSTAmtText; GSTAmtText)
                        {
                        }
                        column(TotalQty_SalesInvLine; TotalQty)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(TotalAmountExcRate_SalesInvLine; TotalAmountExcRate)
                        {
                        }
                        column(TotalAmountVATExcRate_SalesInvLine; TotalAmountVATExcRate)
                        {
                        }
                        column(TotalAmountInclVATExcRate_SalesInvLine; TotalAmountInclVATExcRate)
                        {
                        }
                        column(CurrCode_SalesInvHeader; "Sales Invoice Header"."Currency Code")
                        {
                        }
                        column(LCYCode_SalesInvHeader; GLSetup."LCY Code")
                        {
                        }
                        column(SalesInvLineLineNo; "Line No.")
                        {
                        }
                        column(ItemTypeCaption; ItemTypeCaptionLbl)
                        {
                        }
                        column(YourOrderNoCaption; YourOrderNoCaptionLbl)
                        {
                        }
                        column(DescCaption; DescCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(ExchangeRateCaption; ExchangeRateCaptionLbl)
                        {
                        }
                        column(Qty_SalesInvLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(TextSGD; TextSGD)
                        {
                        }
                        column(TextTHB; TextTHB)
                        {
                        }
                        column(ColonCaption; ColonCaptionLbl)
                        {
                        }
                        column(Footer1Visible; Footer1Visible)
                        {
                        }
                        column(Footer2Visible; Footer2Visible)
                        {
                        }
                        column(Footer3Visible; Footer3Visible)
                        {
                        }
                        column(Footer4Visible; Footer4Visible)
                        {
                        }
                        column(Footer5Visible; Footer5Visible)
                        {
                        }
                        column(CurCode; CurCode)
                        {
                        }
                        column(ExchangeRate; ExchangeRate)
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimTextCtrl82; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            VATAmountLine.INIT;
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            IF "Allow Invoice Disc." THEN
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            // YUKA for Hagiwara 20030218
                            IF "Sales Invoice Line".Type = "Sales Invoice Line".Type::Item THEN BEGIN
                                //Siak - 20140912
                                IF "No." <> '' THEN BEGIN
                                    //Siak - END
                                    ItemRec.RESET;
                                    ItemRec.GET("Sales Invoice Line"."No.");
                                    //ItemType := ItemRec."Product Group Code";
                                    ItemType := ItemRec."Item Group Code";
                                END ELSE BEGIN
                                    ItemType := ' ';
                                END;
                            END;
                            // YUKA for Hagiwara 20030218 - END
                            // YUKA for Hagiwara 20030822
                            IF "Sales Invoice Line"."Unit of Measure" <> '' THEN
                                UOM := "Sales Invoice Line"."Unit of Measure";
                            // YUKA for Hagiwara 20030822 - END

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                            TotalQty += Quantity;

                            TotalAmountExcRate := TotalAmount * ExchangeRate;
                            TotalAmountVATExcRate := TotalAmountVAT * ExchangeRate;
                            TotalAmountInclVATExcRate := TotalAmountInclVAT * ExchangeRate;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DELETEALL;
                            SalesShipmentBuffer.RESET;
                            SalesShipmentBuffer.DELETEALL;
                            FirstValueEntryNo := 0;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SETRANGE("Line No.", 0, "Line No.");
                            // YUKA for Hagiwara 20030218
                            //CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including GST","Inv. Discount Amount");
                            //CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", Quantity);
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            /*CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                              */
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    //CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                    TotalQty := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        SalesInvCountPrinted.RUN("Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                recApprSetup: Record "Hagiwara Approval Setup"; //N005
                recApprESign: Record "Hagiwara Approver E-Signature"; //N005
            begin
                //N005 Begin
                recApprSetup.Get();
                if recApprSetup."Sales Order" then begin
                    if "Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"] then begin
                        if recApprESign.get("Hagi Approver") then begin
                            if recApprESign."Sign Picture".HasValue then begin
                                ESignTenantMedia.get(recApprESign."Sign Picture".MediaId);
                                ESignTenantMedia.CalcFields(Content);
                            end;
                        end;
                    end;
                end;
                //N005 End
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                CurrReport.Language := cuLanguage.GetLanguageIdOrDefault("Language Code");

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                END;

                //CS036 BEGIN
                CompanyInfo.CALCFIELDS(Picture);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                CompanyAddr[5] := 'TEL: ' + CompanyInfo."Phone No." + '   FAX: ' + CompanyInfo."Fax No.";
                CompanyAddr[6] := 'CO. REG. NO.: ' + CompanyInfo."Industrial Classification" + '   GST REG. NO.:' + CompanyInfo."VAT Registration No.";
                //CS036 END

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                IF "Order No." = '' THEN
                    OrderNoText := ''
                ELSE
                    OrderNoText := FIELDCAPTION("Order No.");
                IF "Salesperson Code" = '' THEN BEGIN
                    SalesPurchPerson.INIT;
                    SalesPersonText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Salesperson Code");
                    SalesPersonText := Text000;
                END;
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text002, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text006, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text002, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text006, "Currency Code");
                    TotalInclVATTextLCY := STRSUBSTNO(Text002, GLSetup."LCY Code");
                    TotalExclVATTextLCY := STRSUBSTNO(Text006, GLSetup."LCY Code");
                END;
                FormatAddr.SalesInvBillTo(CustAddr, "Sales Invoice Header");
                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);

                //SH 09082007 start
                IF "Ship-to Code" = '' THEN BEGIN
                    TelNo := Cust."Phone No.";
                END ELSE BEGIN
                    ShipToAddress.GET("Bill-to Customer No.", "Ship-to Code");
                    TelNo := ShipToAddress."Phone No.";
                END;
                //SH End

                //SH 28062013
                IF Cust."Ship From Name" <> '' THEN BEGIN
                    g_ShipFrom := 'Ship From:';
                    g_ShipFromName := Cust."Ship From Name";
                    g_ShipFromAddr := Cust."Ship From Address";
                END ELSE BEGIN
                    g_ShipFrom := ' ';
                    g_ShipFromName := '';
                    g_ShipFromAddr := '';
                END;
                //SH END

                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                END;
                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT
                ELSE BEGIN
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                END;
                FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, "Sales Invoice Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                    IF ShipToAddr[i] <> CustAddr[i] THEN
                        ShowShippingAddr := TRUE;

                CALCFIELDS(Amount);
                CALCFIELDS("Amount Including VAT");

                AmountLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      WORKDATE, "Currency Code", Amount, "Currency Factor"));
                AmountIncLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      WORKDATE, "Currency Code", "Amount Including VAT", "Currency Factor"));
                SalesLine.InitTextVariable;
                SalesLine.FormatNoText(AmountLangA, "Amount Including VAT", "Currency Code");
                IF ShowTHFormatting THEN BEGIN
                    SalesLine.InitTextVariableTH;
                    SalesLine.FormatNoTextTH(AmountLangB, "Amount Including VAT", "Sales Invoice Header"."Currency Code");
                END ELSE BEGIN
                    AmountLangB[1] := '';
                    AmountLangB[2] := '';
                END;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                              "Campaign No.", "Posting Description", '');
                    END;


                // YUKA for Hagiwara 20030218
                CountryFrom := '';
                CountryTo := '';
                CountrySold := '';
                CountryShip := '';
                Country.RESET;
                Country.GET(CompanyInfo."Country/Region Code");
                CountryFrom := Country.Name;
                IF "Sales Invoice Header"."Ship-to Country/Region Code" <> '' THEN BEGIN
                    Country.GET("Sales Invoice Header"."Ship-to Country/Region Code");
                    CountryTo := Country.Name;
                    CountryShip := Country.Name;
                END ELSE BEGIN
                    CountryTo := CountryFrom;
                END;

                IF "Sales Invoice Header"."Sell-to Country/Region Code" <> '' THEN BEGIN
                    Country.GET("Sales Invoice Header"."Sell-to Country/Region Code");
                    CountrySold := Country.Name;
                END;
                // YUKA for Hagiwara 20030218 - END
                // YUKA for Hagiwara 20030226
                //  New Filed added on Sales Invoice for From and To
                IF "Sales Invoice Header".From <> '' THEN
                    CountryFrom := "Sales Invoice Header".From;
                IF "Sales Invoice Header"."To" <> '' THEN
                    CountryTo := "Sales Invoice Header"."To";

                // YUKA For Hagiwara 20040109
                IF "Sales Invoice Header"."Currency Code" <> 'SGD' THEN
                    ExchangeRate := GetExchangeRate("Sales Invoice Header"."Currency Code", "Sales Invoice Header"."Posting Date");
                // YUKA For Hagiwara 20040421
                IF "Sales Invoice Header"."Currency Code" = '' THEN
                    ExchangeRate := 1 / ExchangeRate;
                // YUKA For Hagiwara 20040109 - END
                //IF "Sales Invoice Header"."Currency Factor" <> 0 THEN
                //  ExchangeRate := 1/"Sales Invoice Header"."Currency Factor";
                // YUKA for Hagiwara 20030226 - END
                // YUKA For Hagiwara 20040105
                IF "Sales Invoice Header"."Currency Code" <> '' THEN
                    CurCode := "Sales Invoice Header"."Currency Code"
                ELSE
                    CurCode := GLSetup."LCY Code";
                // YUKA for Hagiwara 20040105 - END

                Footer1Visible := FALSE;
                Footer2Visible := FALSE;
                Footer3Visible := FALSE;
                Footer4Visible := FALSE;
                Footer5Visible := FALSE;

                CASE "Show GST" OF
                    "Show GST"::DEFAULT:
                        // For Hagiwara
                        //  CurrReport.SHOWOUTPUT(("Sales Invoice Header"."Currency Code" <> '')
                        //    AND ("Sales Invoice Header"."Bill-to Country Code" <> '')
                        Footer1Visible := (("Sales Invoice Header"."Bill-to Country/Region Code" <> '')
                        AND ("Sales Invoice Header"."Bill-to Country/Region Code" <> CompanyInfo."Country/Region Code"));
                    "Show GST"::WithGST:
                        Footer1Visible := FALSE;
                    "Show GST"::WithoutGST:
                        Footer1Visible := TRUE;
                END;

                CASE "Show GST" OF
                    "Show GST"::DEFAULT:
                        Footer2Visible := (("Sales Invoice Header"."Bill-to Country/Region Code" = '')
                          OR ("Sales Invoice Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code"));
                    "Show GST"::WithGST:
                        Footer2Visible := TRUE;
                    "Show GST"::WithoutGST:
                        Footer2Visible := FALSE;
                END;

                //CurrReport.SHOWOUTPUT(
                //  (NOT "Sales Invoice Header"."Prices Including GST") AND ("Amount Including GST" <> Amount));
                CASE "Show GST" OF
                    "Show GST"::DEFAULT:
                        // For Hagiwara 20040105
                        //  CurrReport.SHOWOUTPUT(("Sales Invoice Header"."Currency Code" <> '')
                        //    AND (("Sales Invoice Header"."Bill-to Country Code" = '')
                        Footer3Visible := (("Sales Invoice Header"."Bill-to Country/Region Code" = '')
                        OR ("Sales Invoice Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code"));
                    "Show GST"::WithGST:
                        Footer3Visible := ("Sales Invoice Header"."Currency Code" <> '');
                    "Show GST"::WithoutGST:
                        Footer3Visible := FALSE;
                END;

                CASE "Show GST" OF
                    "Show GST"::DEFAULT:
                        // For Hagiwara
                        //  CurrReport.SHOWOUTPUT(("Sales Invoice Header"."Currency Code" <> '')
                        //    AND (("Sales Invoice Header"."Bill-to Country Code" = '')
                        Footer4Visible := (("Sales Invoice Header"."Bill-to Country/Region Code" = '')
                        OR ("Sales Invoice Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code"));
                    "Show GST"::WithGST:
                        // For Hagiwara 20040109
                        //    CurrReport.SHOWOUTPUT("Sales Invoice Header"."Currency Code" <> '');
                        Footer4Visible := ("Sales Invoice Header"."Currency Code" <> 'SGD');
                    "Show GST"::WithoutGST:
                        Footer4Visible := FALSE;
                END;

                CASE "Show GST" OF
                    "Show GST"::DEFAULT:
                        Footer5Visible := (("Sales Invoice Header"."Bill-to Country/Region Code" = '')
                        OR ("Sales Invoice Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code"));
                    "Show GST"::WithGST:
                        Footer5Visible := TRUE;
                    "Show GST"::WithoutGST:
                        Footer5Visible := FALSE;
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field(ShowGST; "Show GST")
                    {
                        ApplicationArea = All;
                        Caption = 'Show GST';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
            // YUKA
            "Show GST" := "Show GST"::DEFAULT;
        end;
    }
    rendering
    {
        layout("Sales - Invoice (ItemCustPN).rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Sales - Invoice (ItemCustPN).rdlc';
            Caption = 'Sales - Invoice (ItemCustPN)';
            //Summary = 'The Standard Sales Invoice (RDLC) is the most detailed layout and provides most flexible layout options.';
        }
        layout("Sales - Invoice (ItemCustPN)2.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Sales - Invoice (ItemCustPN)2.rdlc';
            Caption = 'Sales - Invoice (ItemCustPN)2';
            //Summary = 'The Standard Sales Invoice (RDLC) is the most detailed layout and provides most flexible layout options.';
        }
        layout("Sales - Invoice (ItemCustPN)3.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Sales - Invoice (ItemCustPN)3.rdlc';
            Caption = 'Sales - Invoice (ItemCustPN)3';
            //Summary = 'The Standard Sales Invoice (RDLC) is the most detailed layout and provides most flexible layout options.';
        }
        layout("Sales - Invoice CustomerPN.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Sales - Invoice CustomerPN.rdlc';
            Caption = 'Sales - Invoice CustomerPN';
            //Summary = 'The Standard Sales Invoice (RDLC) is the most detailed layout and provides most flexible layout options.';
        }
        layout("Sales-Invoice (Header)-TH.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Sales - Invoice (Header)-TH.rdlc';
            Caption = 'Sales - Invoice (Header)-TH';
            //Summary = 'The Standard Sales Invoice (RDLC) is the most detailed layout and provides most flexible layout options.';
        }
    }
    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        CompanyInfo.GET;
    end;

    trigger OnPreReport()
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. GST';
        Text003: Label 'COPY';
        Text004: Label 'Tax Invoice';
        PageCaptionCap: Label 'Page %1 of %2';
        Text006: Label 'Total %1 Excl. GST';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        //Language: Record Language;
        cuLanguage: Codeunit Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        SalesInvCountPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        PostedShipmentDate: Date;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[80];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CalculatedExchRate: Decimal;
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        TotalInclVATTextLCY: Text[50];
        TotalExclVATTextLCY: Text[50];
        AmountLCY: Decimal;
        AmountIncLCY: Decimal;
        CurrencyLCY: Boolean;
        AmountInWords: Boolean;
        AmountLangA: array[2] of Text[80];
        AmountLangB: array[2] of Text[80];
        SalesLine: Record "Sales Line";
        ShowTHFormatting: Boolean;
        //[InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        TextSGD: Label 'SGD';
        TextTHB: Label 'THB';
        TotalCaptionLbl: Label 'TOTAL';
        DocumentDateCaptionLbl: Label 'Date';
        PhoneNoCaptionLbl: Label 'Tel No : ';
        BankAccountNoCaptionLbl: Label 'Account No. :';
        SwiftCodeCaptionLbl: Label 'Swift Code: ';
        DueDateCaptionLbl: Label 'Due Date';
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        PaymentTermsDescriptionCaptionLbl: Label 'P/S : ';
        ShipmentMethodDescriptionCaptionLbl: Label 'Per';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        AmountCaptionLbl: Label 'Amount';
        SubtotalCaptionLbl: Label 'TOTAL BEFORE GST';
        SubtotalVATCaptionLbl: Label 'TOTAL BEFORE VAT';
        ExchangeRateCaptionLbl: Label 'LOCAL EQUIVALENT AMOUNT - EXCHANGE RATE :';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        ShiptoAddressCaptionLbl: Label 'Shipped To :';
        CountryFrom: Text[30];
        CountryTo: Text[30];
        Country: Record "Country/Region";
        CountrySold: Text[30];
        CountryShip: Text[30];
        ItemType: Text[30];
        ItemRec: Record Item;
        ExchangeRate: Decimal;
        "Show GST": Option DEFAULT,WithGST,WithoutGST;
        UOM: Text[10];
        CurCode: Text[10];
        SelltoAddressCaptionLbl: Label 'Sold To :';
        FromCaptionLbl: Label 'from';
        ToCaptionLbl: Label 'to';
        ItemTypeCaptionLbl: Label 'Item Type';
        YourOrderNoCaptionLbl: Label 'Your Order No.';
        DescCaptionLbl: Label 'Description';
        GrandTotalCaptionLbl: Label 'GRAND TOTAL';
        AttnCaptionLbl: Label 'Attn : ';
        GSTAmtText: Label 'GST Amount';
        ShipToAddress: Record "Ship-to Address";
        TelNo: Text[30];
        g_ShipFrom: Text[10];
        g_ShipFromName: Text[50];
        g_ShipFromAddr: Text[50];
        TotalQty: Decimal;
        TotalAmountExcRate: Decimal;
        TotalAmountVATExcRate: Decimal;
        TotalAmountInclVATExcRate: Decimal;
        ColonCaptionLbl: Label ':';
        //[InDataSet]
        Footer1Visible: Boolean;
        // [InDataSet]
        Footer2Visible: Boolean;
        //[InDataSet]
        Footer3Visible: Boolean;
        //[InDataSet]
        Footer4Visible: Boolean;
        //[InDataSet]
        Footer5Visible: Boolean;
        ESignTenantMedia: Record "Tenant Media"; //N005


    procedure InitLogInteraction()
    begin
        //LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;

    local procedure DocumentCaption(): Text[250]
    begin
        EXIT(Text004);
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewAmountInWords: Boolean; NewCurrencyLCY: Boolean; NewShowTHFormatting: Boolean; NewDisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        AmountInWords := NewAmountInWords;
        CurrencyLCY := NewCurrencyLCY;
        ShowTHFormatting := NewShowTHFormatting;
        DisplayAssemblyInformation := NewDisplayAsmInfo;
    end;

    procedure GetExchangeRate(Currency: Text[10]; TransDate: Date) Rate: Decimal
    var
        RecCur: Record "Currency Exchange Rate";
    begin
        Rate := 1;
        IF Currency = '' THEN
            Currency := 'SGD';
        RecCur.SETFILTER(RecCur."Currency Code", Currency);
        IF RecCur.FIND('+') THEN
            REPEAT
                IF RecCur."Starting Date" < TransDate THEN BEGIN
                    Rate := RecCur."Relational Exch. Rate Amount" / RecCur."Exchange Rate Amount";
                    EXIT;
                END;
            UNTIL RecCur.NEXT(-1) = 0;
    end;
}

