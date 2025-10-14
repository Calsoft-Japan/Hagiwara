report 50031 "PO Hagiwara-Cust Item3"
{
    // HG1.00 - Upgrade from Nav 3.60 to Nav Dynamics 5.00 (SG)
    // CS022 KenChen 2021/07/30 - PO Line Modification to fix Page-break
    // CS064 Kenya 2023/10/03 - Add PO/Line No.
    // CS092 FDD R020 Bobby.Ji 2025/7/7 - Upgade to the BC version

    /*DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Purchase Order Cust Item3.rdlc';
*/
    Caption = 'Purchase Order Cust Item';
    DefaultRenderingLayout = "Purchase Order Cust Item.rdlc";
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Order';
            column(DocumentType_PurchHdr; "Document Type")
            {
            }
            column(No_PurchHdr; "No.")
            {
            }
            column(AmtCaption; AmtCaptionLbl)
            {
            }
            column(ColonCaption; ColonCaptionLbl)
            {
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
                    column(CompanyPicture; CompanyInfo.Picture)
                    {
                    }
                    column(CompanyName; CompanyInfo.Name)
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
                    column(OrderCopyText; Text004)
                    {
                    }
                    column(BuyFromAddr1; "Purchase Header"."Buy-from Vendor Name")
                    {
                    }
                    column(BuyFromAddr2; "Purchase Header"."Buy-from Address")
                    {
                    }
                    column(BuyFromAddr3; "Purchase Header"."Buy-from Address 2")
                    {
                    }
                    column(BuyFromAddr4; "Purchase Header"."Buy-from City")
                    {
                    }
                    column(BuyFromAddr5; "Purchase Header"."Buy-from Post Code")
                    {
                    }
                    column(BuyFromAddr6; "Purchase Header"."Buy-from Country/Region Code")
                    {
                    }
                    column(BuyFromAddr7; "Purchase Header"."Buy-from Contact")
                    {
                    }
                    column(BuyFromAddCaption; BuyFromAddCaptionLbl)
                    {
                    }
                    column(BuyFromAddCaption1; BuyFromAddCaptionLbl1)
                    {
                    }
                    column(ShipToAddr1; "Purchase Header"."Ship-to Name")
                    {
                    }
                    column(ShipToAddr2; "Purchase Header"."Ship-to Address")
                    {
                    }
                    column(ShipToAddr3; "Purchase Header"."Ship-to Address 2")
                    {
                    }
                    column(ShipToAddr4; "Purchase Header"."Ship-to City")
                    {
                    }
                    column(ShipToAddr5; "Purchase Header"."Ship-to Post Code")
                    {
                    }
                    column(ShipToAddr6; ShipToTel)
                    {
                    }
                    column(ShipToAddr7; ShipToFax)
                    {
                    }
                    column(ShipToAddr8; "Purchase Header"."Ship-to Contact")
                    {
                    }
                    column(ShiptoAddCaption; ShiptoAddCaptionLbl)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(DocDate_PurchHdr; FORMAT("Purchase Header"."Document Date", 0, 4))
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(DocDateCaption; DocDateCaptionLbl)
                    {
                    }
                    column(AttnCaption; AttnCaptionLbl)
                    {
                    }
                    column(FaxCaption; FaxCaptionLbl)
                    {
                    }
                    column(PricesIncVAT_PurchHdr; "Purchase Header"."Prices Including VAT")
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
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
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.BREAK;
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(SecondLineDesc; SecondLineDesc)
                        {
                        }
                        column(PurchLineLineAmt; TotalAmount)
                        {
                            AutoFormatExpression = "Purchase Line"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Desc_PurchLine; "Purchase Line".Description)
                        {
                        }
                        column(LineNo_PurchLine; "Purchase Line"."Line No.")
                        {
                        }
                        column(Type_PurchLine; FORMAT("Purchase Line".Type, 0, 2))
                        {
                        }
                        column(No_PurchLine; "Purchase Line"."No.")
                        {
                        }
                        column(Quantity_PurchLine; "Purchase Line".Quantity)
                        {
                        }
                        column(UnitofMeasure_PurchLine; "Purchase Line"."Unit of Measure")
                        {
                        }
                        column(DirectUnitCost_PurchLine; "Purchase Line"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineAmt_PurchLine; "Purchase Line"."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalCaptionLbl)
                        {
                        }
                        column(PurchLineLineAmtInvDiscAmt; PurchLine."Line Amount" - PurchLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmt; VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DirectUnitCostCaption; DirectUnitCostCaptionLbl)
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(QtyCaption; QtyCaptionLbl)
                        {
                        }
                        column(DeliveryCaption; DeliveryCaptionLbl)
                        {
                        }
                        column(CurCode_PurchLine; CurCode)
                        {
                        }
                        column(Parts_PurchLine; "Purchase Line"."Parts No.")
                        {
                        }
                        column(Rank_PurchLine; "Purchase Line".Rank)
                        {
                        }
                        column(Delivery_PurchLine; ExpectedReceiptDate)
                        {
                        }
                        column(UOM_PurchLine; UOM)
                        {
                        }
                        column(VATAmt; VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DescCaption; DescCaptionLbl)
                        {
                        }
                        column(TotalQuantity; TotalQuantity)
                        {
                            //DecimalPlaces = 0:0;
                        }
                        column(CustItemNo_PurchLine; "Purchase Line"."Customer Item No.")
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimsCaption; LineDimsCaptionLbl)
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

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Purchase Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            PurchaseLine: Record "Purchase Line";
                            TopLineNo: Integer;
                        begin
                            IF Number = 1 THEN
                                PurchLine.FIND('-')
                            ELSE
                                PurchLine.NEXT;
                            "Purchase Line" := PurchLine;
                            //--CS022 Begin
                            IF PurchLine."No." = '' THEN BEGIN
                                CurrReport.SKIP;
                            END;
                            CLEAR(PurchaseLine);
                            CLEAR(SecondLineDesc);

                            // IF PurchaseLine.GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN
                            //  PurchaseLine.NEXT;
                            // IF PurchaseLine."No."='' THEN
                            // REPEAT
                            //  SecondLineDesc:=SecondLineDesc+PurchaseLine.Description+'||';
                            //  PurchaseLine.NEXT;
                            // UNTIL (PurchaseLine."No."<>'') OR (PurchaseLine."Document No."<>PurchLine."Document No.");

                            /*IF PurchaseLine.GET(PurchLine."Document Type", PurchLine."Document No.", PurchLine."Line No.") THEN
                                PurchaseLine.NEXT;
                            IF PurchaseLine."No." = '' THEN
                                REPEAT
                                    SecondLineDesc := SecondLineDesc + PurchaseLine.Description + '||';
                                    PurchaseLine.NEXT;
                                UNTIL (PurchaseLine."No." <> '') OR (PurchaseLine."Document No." <> PurchLine."Document No.");
*/
                            PurchaseLine.SETRANGE("Document Type", PurchLine."Document Type");
                            PurchaseLine.SETRANGE("Document No.", PurchLine."Document No.");
                            IF PurchaseLine.FINDFIRST THEN
                                REPEAT
                                    IF (PurchaseLine."No." <> '') THEN
                                        TopLineNo := PurchaseLine."Line No.";
                                    IF (PurchaseLine."No." = '') AND (TopLineNo = PurchLine."Line No.") THEN
                                        SecondLineDesc := SecondLineDesc + PurchaseLine.Description + '||';
                                UNTIL PurchaseLine.NEXT = 0;
                            IF STRPOS(SecondLineDesc, '||') > 0 THEN
                                SecondLineDesc := COPYSTR(SecondLineDesc, 1, STRLEN(SecondLineDesc) - 2);


                            //--CS022 End

                            IF NOT "Purchase Header"."Prices Including VAT" AND
                               (PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Full VAT")
                            THEN
                                PurchLine."Line Amount" := 0;

                            IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "Purchase Line"."No." := '';

                            // YUKA for Hagiwara 20030613
                            IF (PurchLine.Type = PurchLine.Type::Item) THEN
                                UOM := "Purchase Line"."Unit of Measure";
                            // YUKA for Hagiwara 20030613 - END

                            ExpectedReceiptDate := '';
                            IF "Purchase Line"."Expected Receipt Date" <> 0D THEN
                                ExpectedReceiptDate := FORMAT("Purchase Line"."Expected Receipt Date", 0, '<Closing><Day,2>-<Month Text, 3>-<Year>');

                            AllowInvDisctxt := FORMAT("Purchase Line"."Allow Invoice Disc.");
                            TotalSubTotal += "Purchase Line"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";

                            TotalAmount += PurchLine."Line Amount";
                            ;
                            TotalQuantity += PurchLine.Quantity;
                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLine.DELETEALL;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.FIND('+');
                            WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2" = '') AND
                                  (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
                                  (PurchLine.Amount = 0) DO
                                MoreLines := PurchLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            PurchLine.SETRANGE("Line No.", 0, PurchLine."Line No.");
                            SETRANGE(Number, 1, PurchLine.COUNT);
                            //CurrReport.CREATETOTALS(PurchLine."Line Amount",PurchLine."Inv. Discount Amount");
                            //CurrReport.CREATETOTALS(PurchLine."Line Amount", PurchLine."Inv. Discount Amount", PurchLine.Quantity);
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
                            IF VATAmount = 0 THEN
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            /*CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");*/
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
                            IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(Total3; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));

                        trigger OnPreDataItem()
                        begin
                            IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtPurchLine: Record "Purchase Line" temporary;
                    TempPurchLine: Record "Purchase Line" temporary;
                begin
                    CLEAR(PurchLine);
                    CLEAR(PurchPost);
                    PurchLine.DELETEALL;
                    VATAmountLine.DELETEALL;
                    PurchPost.GetPurchLines("Purchase Header", PurchLine, 0);
                    PurchLine.CalcVATAmountLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    PurchLine.UpdateVATOnLines(0, "Purchase Header", PurchLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DELETEALL;
                    PurchPostPrepmt.GetPurchLines("Purchase Header", 0, PrepmtPurchLine);
                    IF (NOT PrepmtPurchLine.ISEMPTY) THEN BEGIN
                        PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header", TempPurchLine);
                        IF NOT TempPurchLine.ISEMPTY THEN
                            PurchPostPrepmt.CalcVATAmountLines("Purchase Header", TempPurchLine, PrePmtVATAmountLineDeduct, 1);
                    END;
                    PurchPostPrepmt.CalcVATAmountLines("Purchase Header", PrepmtPurchLine, PrepmtVATAmountLine, 0);
                    IF PrepmtVATAmountLine.FINDSET THEN
                        REPEAT
                            PrePmtVATAmountLineDeduct := PrepmtVATAmountLine;
                            IF PrePmtVATAmountLineDeduct.FIND THEN BEGIN
                                PrepmtVATAmountLine."VAT Base" := PrepmtVATAmountLine."VAT Base" - PrePmtVATAmountLineDeduct."VAT Base";
                                PrepmtVATAmountLine."VAT Amount" := PrepmtVATAmountLine."VAT Amount" - PrePmtVATAmountLineDeduct."VAT Amount";
                                PrepmtVATAmountLine."Amount Including VAT" := PrepmtVATAmountLine."Amount Including VAT" -
                                  PrePmtVATAmountLineDeduct."Amount Including VAT";
                                PrepmtVATAmountLine."Line Amount" := PrepmtVATAmountLine."Line Amount" - PrePmtVATAmountLineDeduct."Line Amount";
                                PrepmtVATAmountLine."Inv. Disc. Base Amount" := PrepmtVATAmountLine."Inv. Disc. Base Amount" -
                                  PrePmtVATAmountLineDeduct."Inv. Disc. Base Amount";
                                PrepmtVATAmountLine."Invoice Discount Amount" := PrepmtVATAmountLine."Invoice Discount Amount" -
                                  PrePmtVATAmountLineDeduct."Invoice Discount Amount";
                                PrepmtVATAmountLine."Calculated VAT Amount" := PrepmtVATAmountLine."Calculated VAT Amount" -
                                  PrePmtVATAmountLineDeduct."Calculated VAT Amount";
                                PrepmtVATAmountLine.MODIFY;
                            END;
                        UNTIL PrepmtVATAmountLine.NEXT = 0;
                    PurchPostPrepmt.UpdateVATOnLines("Purchase Header", PrepmtPurchLine, PrepmtVATAmountLine, 0);
                    PurchPostPrepmt.BuildInvLineBuffer("Purchase Header", PrepmtPurchLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    //CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalAmount := 0;
                    TotalQuantity := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        PurchCountPrinted.RUN("Purchase Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                CurrReport.Language := cuLanguage.GetLanguageIdOrDefault("Language Code");

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                //CS036 BEGIN
                CompanyInfo.CALCFIELDS(Picture);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                CompanyAddr[5] := 'TEL: ' + CompanyInfo."Phone No." + '   FAX: ' + CompanyInfo."Fax No.";
                CompanyAddr[6] := 'CO. REG. NO.: ' + CompanyInfo."Industrial Classification" + '   GST REG. NO.:' + CompanyInfo."VAT Registration No.";
                //CS036 END
                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                IF "Purchaser Code" = '' THEN BEGIN
                    SalesPurchPerson.INIT;
                    PurchaserText := '';
                END ELSE BEGIN
                    SalesPurchPerson.GET("Purchaser Code");
                    PurchaserText := Text000
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
                END;

                FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, "Purchase Header");
                IF "Buy-from Vendor No." <> "Pay-to Vendor No." THEN
                    FormatAddr.PurchHeaderPayTo(VendAddr, "Purchase Header");
                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                END;
                IF "Prepmt. Payment Terms Code" = '' THEN
                    PrepmtPaymentTerms.INIT
                ELSE BEGIN
                    PrepmtPaymentTerms.GET("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                END;
                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT
                ELSE BEGIN
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                END;


                FormatAddr.PurchHeaderShipTo(ShipToAddr, "Purchase Header");

                // YUKA for Hagiwara 20020211
                IF "Purchase Header"."Location Code" = '' THEN BEGIN
                    ShipToTel := '';
                    ShipToFax := '';
                END ELSE BEGIN
                    LocationRec.GET("Location Code");
                    ShipToTel := LocationRec."Phone No.";
                    ShipToFax := LocationRec."Fax No.";
                END;

                // YUKA for Hagiwara 20020211 - END
                // YUKA for Hagiwara 20040116
                IF "Purchase Header"."Currency Code" = '' THEN
                    CurCode := GLSetup."LCY Code"
                ELSE
                    CurCode := "Purchase Header"."Currency Code";
                // YUKA for Hagiwara 20040116 - END


                IF NOT CurrReport.PREVIEW THEN BEGIN
                    IF ArchiveDocument THEN
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

                    IF LogInteraction THEN BEGIN
                        CALCFIELDS("No. of Archived Versions");
                        SegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", "Campaign No.", "Posting Description", '');
                    END;
                END;

                PricesInclVATtxt := FORMAT("Prices Including VAT");
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
                    field(NoofCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInformation; ShowInternalInfo)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Internal Information';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = All;
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;

                        trigger OnValidate()
                        begin
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            IF LogInteraction THEN
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
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
            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule;
            //LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }
    rendering
    {
        layout("Purchase Order Cust Item.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Purchase Order Cust Item.rdlc';
            Caption = 'Purchase Order Cust Item';
        }
        layout("Purchase Order Cust Item3.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Purchase Order Cust Item3.rdlc';
            Caption = 'Purchase Order Cust Item3';
        }
    }
    labels
    {
        FooterText1 = 'REMARKS:  PLEASE RETURN TO US THE DUPLICATED COPY DULY STAMPED AND SIGNED AS CONFIRMATION';
        FooterText2 = 'SINGAPORE HAGIWARA PTE. LTD.';
        FooterText3 = 'SIGN & COMPANY STAMP';
        FooterText4 = 'AUTHORISED SIGNATURES';
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        PurchSetup.GET;

        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        Country.GET(CompanyInfo."Country/Region Code");
    end;

    var
        Text000: Label 'Purchaser';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label ' COPY';
        Text004: Label 'PURCHASE ORDER';
        Text005: Label 'Page%1';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        PurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        PrepmtDimSetEntry: Record "Dimension Set Entry";
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        //Language: Record 8;
        cuLanguage: Codeunit Language;
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchCountPrinted: Codeunit "Purch.Header-Printed";
        FormatAddr: Codeunit "Format Address";
        PurchPost: Codeunit "Purch.-Post";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[80];
        BuyFromAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtAmountInclVAT: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        ArchiveDocumentEnable: Boolean;
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        PhoneNoCaptionLbl: Label 'Tel';
        PageCaptionLbl: Label 'Page %1 of %2';
        OrderNoCaptionLbl: Label 'P/O No.';
        DocDateCaptionLbl: Label 'Date';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        DirectUnitCostCaptionLbl: Label 'Unit Price';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        TotalCaptionLbl: Label 'TOTAL';
        ShiptoAddCaptionLbl: Label 'Ship To';
        DescCaptionLbl: Label 'Product Name';
        AmtCaptionLbl: Label 'Amount';
        ShipToTel: Text[30];
        ShipToFax: Text[30];
        LocationRec: Record Location;
        UOM: Text[10];
        CurCode: Text[10];
        BuyFromAddCaptionLbl: Label 'MESSRS';
        BuyFromAddCaptionLbl1: Label 'Address';
        AttnCaptionLbl: Label 'Attn';
        FaxCaptionLbl: Label 'Fax';
        ItemNoCaptionLbl: Label 'Item No.';
        QtyCaptionLbl: Label 'Quantity';
        DeliveryCaptionLbl: Label 'Delivery';
        ColonCaptionLbl: Label ':';
        ExpectedReceiptDate: Text[20];
        TotalQuantity: Integer;
        Country: Record "Country/Region";
        SecondLineDesc: Text;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewArchiveDocument: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;
}

