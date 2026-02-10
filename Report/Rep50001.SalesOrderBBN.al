report 50001 "Sales Order BBN"
{
    // ********************************************************************************
    // Bechtle GmbH & Co. KG, Competence Center MS Dynamics NAV, Systemhaus Bonn/Köln
    // --------------------------------------------------------------------------------
    // 01, 13.05.2013, TTR
    // -created
    // 02, 27.05.2014, CKR
    // - Fixed several layout bugs
    // - Dynamics footer & header
    // CS092 FDD R035 7/9/2025 Channing.Zhou Upgrade to BC version
    // ********************************************************************************
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Sales Order BBN.rdlc';

    Caption = 'Sales Order BBN';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(Sales_Header_No_; "No.")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(Text005; Text005)
                    {
                    }
                    column(Sales_Header___No__; "Sales Header"."No.")
                    {
                    }
                    column(FORMAT__Sales_Header___Document_Date__0_7_; FORMAT("Sales Header"."Document Date", 0, '<Day>. <Month text,3> <Year4>'))
                    {
                    }
                    column(FORMAT__Sales_Header___Due_Date__0_7_; FORMAT("Sales Header"."Due Date", 0, '<Day>. <Month text,3> <Year4>'))
                    {
                    }
                    column(ShipmentMethod_Description; ShipmentMethod.Description)
                    {
                    }
                    column(CountryFrom; CountryFrom)
                    {
                    }
                    column(CountryTo; CountryTo)
                    {
                    }
                    column(Sales_Header_External_Document_No; "Sales Header"."External Document No.")
                    {
                    }
                    column(Sales_Header___Ship_to_Address_; "Sales Header"."Ship-to Address")
                    {
                    }
                    column(Sales_Header___Ship_to_Address_2_; "Sales Header"."Ship-to Address 2")
                    {
                    }
                    column(Sales_Header___Ship_to_Name_; "Sales Header"."Ship-to Name")
                    {
                    }
                    column(Sales_Header___Ship_to_City_; "Sales Header"."Ship-to City")
                    {
                    }
                    column(Sales_Header___Ship_to_Post_Code_; "Sales Header"."Ship-to Post Code")
                    {
                    }
                    column(Sales_Header___Ship_to_Contact_; "Sales Header"."Ship-to Contact")
                    {
                    }
                    column(Sales_Header___Sell_to_Customer_Name_; "Sales Header"."Sell-to Customer Name")
                    {
                    }
                    column(Sales_Header___Sell_to_Address_; "Sales Header"."Sell-to Address")
                    {
                    }
                    column(Sales_Header___Sell_to_Address_2_; "Sales Header"."Sell-to Address 2")
                    {
                    }
                    column(Sales_Header___Sell_to_City_; "Sales Header"."Sell-to City")
                    {
                    }
                    column(Sales_Header_Sell_to_Contact; "Sales Header"."Sell-to Contact")
                    {
                    }
                    column(Sales_Header_Shipment_Method; "Sales Header"."Shipment Method Code")
                    {
                    }
                    column(CountrySold; CountrySold)
                    {
                    }
                    column(Sales_Header___Sell_to_Post_Code_; "Sales Header"."Sell-to Post Code")
                    {
                    }
                    column(Sales_Header_VatRegistrationNo; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(TelNo; TelNo)
                    {
                    }
                    column(FaxNo; FaxNo)
                    {
                    }
                    column(OutputNo; OutputNo)
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
                    column(CompanyInfo__Signature_Name_; CompanyInfo."Signature Name")
                    {
                        AutoFormatType = 1;
                    }
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(PaymentTerms_Description; PaymentTerms.Description)
                    {
                    }
                    column(CompanyInfo__Bank_Name_; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfo__Bank_Account_No__; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CompanyInfo__Bank_Branch_No__; CompanyInfo."Bank Branch No.")
                    {
                    }
                    column(CompanyInfo_PhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo_FaxNo; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo_CEO1; CompanyInfo."CEO 1")
                    {
                    }
                    column(CompanyInfo_CEO2; CompanyInfo."CEO 2")
                    {
                    }
                    column(CompanyInfo_CEO3; CompanyInfo."CEO 3")
                    {
                    }
                    column(CompanyInfo_CommercialRegister; CompanyInfo."Commercial Register")
                    {
                    }
                    column(Invoice_No_Caption; Invoice_No_CaptionLbl)
                    {
                    }
                    column(Tax_InvoiceCaption; Tax_InvoiceCaptionLbl)
                    {
                    }
                    column(PerCaption; PerCaptionLbl)
                    {
                    }
                    column(fromCaption; fromCaptionLbl)
                    {
                    }
                    column(toCaption; toCaptionLbl)
                    {
                    }
                    column(Shipped_To__Caption; Shipped_To__CaptionLbl)
                    {
                    }
                    column(Sold_To__Caption; Sold_To__CaptionLbl)
                    {
                    }
                    column(Attn___Caption; Attn___CaptionLbl)
                    {
                    }
                    column(DateCaption; DateCaptionLbl)
                    {
                    }
                    column(Due_DateCaption; Due_DateCaptionLbl)
                    {
                    }
                    column(Tel_No___Caption; Tel_No___CaptionLbl)
                    {
                    }
                    column(P_S___Caption; P_S___CaptionLbl)
                    {
                    }
                    column(Account_No___Caption; Account_No___CaptionLbl)
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(YourReferenceCaption; YourReferenceCaption)
                    {
                    }
                    column(TradeTermsCaption; TradeTermsCaption)
                    {
                    }
                    column(PaymentTermsCaption; PaymentTermsCaption)
                    {
                    }
                    column(FaxNoCaption; FaxNoCaption)
                    {
                    }
                    column(VATRegistrationNoCaption; VatRegistrationNoCaption)
                    {
                    }
                    column(RemarkText; RemarkText)
                    {
                    }
                    column(SignCompanyStamp; SignCompanyStamp)
                    {
                    }
                    column(AuthorisedSignatures; AuthorisedSignatures)
                    {
                    }
                    column(CeoText; CEOText)
                    {
                    }
                    column(CommercialRegisterCaption; CommercialRegister)
                    {
                    }
                    column(VatRegistrationNoText; VatRegistrationNoText)
                    {
                    }
                    column(LocationCodeText; LocationCodeText)
                    {
                    }
                    column(FiscalRepresentative; FiscalRepresentative)
                    {
                    }
                    column(BankText; BANKText)
                    {
                    }
                    column(IBANText; IBANText)
                    {
                    }
                    column(ESign; ESignTenantMedia.Content)
                    {
                        //N005
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1_Number; DimensionLoop1.Number)
                        {
                        }
                        column(DimText_Control98; DimText)
                        {
                        }
                        column(Header_DimensionsCaption; Header_DimensionsCaptionLbl)
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
                            //REP:FILTER:CStr(Fields!DimensionLoop1_Number.Value):>:""""""
                            //REP:LAYOUTRECT

                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(FORMAT__Sales_Header___Currency_Code__; FORMAT("Sales Header"."Currency Code"))
                        {
                        }
                        column(Sales_Header___Currency_Code_; "Sales Header"."Currency Code")
                        {
                        }
                        column(FORMAT_GLSetup__LCY_Code__; FORMAT(GLSetup."LCY Code"))
                        {
                        }
                        column(GLSetup__LCY_Code_; GLSetup."LCY Code")
                        {
                        }
                        column(Sales_Line__Line_Amount_; "Line Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(Sales_Line_No_; "No.")
                        {
                        }
                        column(Sales_Line_Description; Description)
                        {
                        }
                        column(Sales_Line__Parts_No__; "Parts No.")
                        {
                        }
                        column(Sales_Line_Quantity; Quantity)
                        {
                        }
                        column(Sales_Line__Unit_of_Measure_; "Unit of Measure")
                        {
                        }
                        column(Sales_Line__Unit_Price_; "Unit Price")
                        {
                            AutoFormatType = 2;
                        }
                        column(Sales_Line__Line_Amount__Control70; "Line Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(Sales_Line__Customer_Item_No__; "Customer Item No.")
                        {
                        }
                        column(Sales_Line__Customer_Order_No__; "Customer Order No.")
                        {
                        }
                        column(ItemType; ItemType)
                        {
                        }
                        column(Sales_Line_Rank; Rank)
                        {
                        }
                        column(SalesLineType; FORMAT("Sales Line".Type))
                        {
                        }
                        column(Sales_Line_Line_No; "Line No.")
                        {
                        }
                        column(Sales_Line__Line_Amount__Control86; "Line Amount")
                        {
                            AutoFormatType = 1;
                        }
                        column(Sales_Line_Quantity_Control1000000085; Quantity)
                        {
                        }
                        column(UOM; UOM)
                        {
                        }
                        column(CurCode; CurCode)
                        {
                        }
                        column(Sales_Line_Amount; Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(ShowGST; "Show GST")
                        {
                        }
                        column(SalesHeader_BillToCountryCode; "Sales Header"."Bill-to Country/Region Code")
                        {
                        }
                        column(CompanyInfo_CountryRegionCode; CompanyInfo."Country/Region Code")
                        {
                        }
                        column(SalesHeader_CurrencyCode; "Sales Header"."Currency Code")
                        {
                        }
                        column(Sales_Line_Quantity_Control1000000070; Quantity)
                        {
                        }
                        column(UOM_Control1000000073; UOM)
                        {
                        }
                        column(Sales_Line_Amount_Control90; Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(Amount_Including_VAT____Amount; "Amount Including VAT" - Amount)
                        {
                            AutoFormatType = 1;
                        }
                        column(Sales_Line__Amount_Including_VAT_; "Amount Including VAT")
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLine_VATAmountText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(CurCode_Control1000000047; CurCode)
                        {
                        }
                        column(CurCode_Control1000000048; CurCode)
                        {
                        }
                        column(CurCode_Control1000000050; CurCode)
                        {
                        }
                        column(ExchangeRate; ExchangeRate)
                        {
                            AutoFormatType = 2;
                            DecimalPlaces = 4 : 4;
                        }
                        column(VATAmountLine_VATAmountText_Control1000000030; VATAmountLine.VATAmountText)
                        {
                        }
                        column(Amount___ExchangeRate; Amount * ExchangeRate)
                        {
                            AutoFormatType = 1;
                        }
                        column(Amount_Including_VAT____Amount___ExchangeRate; ("Amount Including VAT" - Amount) * ExchangeRate)
                        {
                            AutoFormatType = 1;
                        }
                        column(Amount_Including_VAT____ExchangeRate; "Amount Including VAT" * ExchangeRate)
                        {
                            AutoFormatType = 1;
                        }
                        column(TextSGD; TextSGD)
                        {
                        }
                        column(TextSGD_Control1000000051; TextSGD)
                        {
                        }
                        column(TextSGD_Control1000000052; TextSGD)
                        {
                        }
                        column(NoCaption; NoCaption)
                        {
                        }
                        column(QuantityCaption; QuantityCaption)
                        {
                        }
                        column(PartsNoCaption; PartsNoCaption)
                        {
                        }
                        column(Item_TypeCaption; Item_TypeCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(Sales_Line_QuantityCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(Your_Order_No_Caption; Your_Order_No_CaptionLbl)
                        {
                        }
                        column(ContinuedCaption; ContinuedCaptionLbl)
                        {
                        }
                        column(ContinuedCaption_Control85; ContinuedCaption_Control85Lbl)
                        {
                        }
                        column(TOTALCaption; TOTALCaptionLbl)
                        {
                        }
                        column(TOTALCaption_Control1000000068; TOTALCaption_Control1000000068Lbl)
                        {
                        }
                        column(GRAND_TOTALCaption; GRAND_TOTALCaptionLbl)
                        {
                        }
                        column(TOTAL_BEFORE_GSTCaption; TOTAL_BEFORE_GSTCaptionLbl)
                        {
                        }
                        column(EmptyStringCaption; EmptyStringCaptionLbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000053; EmptyStringCaption_Control1000000053Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000054; EmptyStringCaption_Control1000000054Lbl)
                        {
                        }
                        column(LOCAL_EQUIVALENT_AMOUNT___EXCHANGE_RATE__Caption; LOCAL_EQUIVALENT_AMOUNT___EXCHANGE_RATE__CaptionLbl)
                        {
                        }
                        column(GRAND_TOTALCaption_Control1000000043; GRAND_TOTALCaption_Control1000000043Lbl)
                        {
                        }
                        column(TOTAL_BEFORE_GSTCaption_Control1000000046; TOTAL_BEFORE_GSTCaption_Control1000000046Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000056; EmptyStringCaption_Control1000000056Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000057; EmptyStringCaption_Control1000000057Lbl)
                        {
                        }
                        column(EmptyStringCaption_Control1000000058; EmptyStringCaption_Control1000000058Lbl)
                        {
                        }
                        column(Sales_Line_Document_No_; "Document No.")
                        {
                        }
                        column(PrintFooter1; PrintFooter1)
                        {
                        }
                        column(PrintFooter2; PrintFooter2)
                        {
                        }
                        column(PrintFooter3; PrintFooter3)
                        {
                        }
                        column(PrintFooter4; PrintFooter4)
                        {
                        }
                        column(PrintFooter5; PrintFooter5)
                        {
                        }
                        column(ItemCounterText; ItemCounterText)
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText_Control82; DimText)
                            {
                            }
                            column(Line_DimensionsCaption; Line_DimensionsCaptionLbl)
                            {
                            }
                            column(DimensionLoop2_Number; Number)
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
                            IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
                                ItemRec.RESET;
                                ItemRec.GET("Sales Line"."No.");
                                ItemType := ItemRec."Item Category Code";
                            END;
                            // YUKA for Hagiwara 20030218 - END
                            // YUKA for Hagiwara 20030822
                            IF "Sales Line"."Unit of Measure" <> '' THEN
                                UOM := "Sales Line"."Unit of Measure";
                            // YUKA for Hagiwara 20030822 - END

                            // BBN.02.sn
                            ItemCounter += 1;
                            ItemCounterText := FORMAT(ItemCounter);
                            // BBN.02.en
                        end;

                        trigger OnPreDataItem()
                        begin
                            //REP:FILTER:CStr(Fields!Sales_Invoice_Line_Line_No.Value):>:""""""
                            //REP:GROUP:1:FIELDS:Fields!Sales_Invoice_Header___No__.Value
                            //REP:GROUP:1:FIELDS:Fields!OutputNo.Value
                            //REP:GROUP:1:FIELDS:Sales_Invoice_Line_Line_No.Value
                            //REP:REPEATHEADERROWS
                            //REP:LAYOUTRECT

                            VATAmountLine.DELETEALL;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SETRANGE("Line No.", 0, "Line No.");
                            // YUKA for Hagiwara 20030218
                            //CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including GST","Inv. Discount Amount");
                            //CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including VAT", Quantity);

                            //CurrReport.Showoutput....
                            CASE "Show GST" OF
                                "Show GST"::DEFAULT:
                                    BEGIN
                                        PrintFooter1 := ("Sales Header"."Bill-to Country/Region Code" <> '') AND
                                          ("Sales Header"."Bill-to Country/Region Code" <> CompanyInfo."Country/Region Code");
                                        PrintFooter2 := ("Sales Header"."Bill-to Country/Region Code" = '') OR
                                          ("Sales Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code");
                                        PrintFooter3 := ("Sales Header"."Bill-to Country/Region Code" = '') OR
                                          ("Sales Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code");
                                        PrintFooter4 := ("Sales Header"."Bill-to Country/Region Code" = '') OR
                                          ("Sales Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code");
                                        PrintFooter5 := ("Sales Header"."Bill-to Country/Region Code" = '') OR
                                          ("Sales Header"."Bill-to Country/Region Code" = CompanyInfo."Country/Region Code");

                                    END;
                                "Show GST"::WithGST:
                                    BEGIN
                                        PrintFooter1 := FALSE;
                                        PrintFooter2 := TRUE;
                                        PrintFooter3 := "Sales Header"."Currency Code" <> '';
                                        PrintFooter4 := "Sales Header"."Currency Code" <> 'SGD';
                                        PrintFooter5 := TRUE;
                                    END;
                                "Show GST"::WithoutGST:
                                    BEGIN
                                        PrintFooter1 := TRUE;
                                        PrintFooter2 := FALSE;
                                        PrintFooter3 := FALSE;
                                        PrintFooter4 := FALSE;
                                        PrintFooter5 := FALSE;
                                    END;
                            END;
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
                            IF VATAmountLine.GetTotalVATAmount = 0 THEN
                                CurrReport.BREAK;
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            /*CurrReport.CREATETOTALS(
                              VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");*/
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
                        //IF ISSERVICETIER THEN
                        OutputNo += 1;
                        CopyText := Text003;
                    END;
                    //CurrReport.PAGENO := 1;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT CurrReport.PREVIEW THEN
                        SalesCountPrinted.RUN("Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    //IF ISSERVICETIER THEN
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                _SalesLine2: Record "Sales Line";
                _Location: Record Location;
                _Country: Record "Country/Region";
                recApprSetup: Record "Hagiwara Approval Setup"; //N005
                recApprESign: Record "Hagiwara Approver E-Signature"; //N005
                recSalesSetup: Record "Sales & Receivables Setup";
            begin
                //N005 Begin
                recApprSetup.Get();
                if recApprSetup."Sales Order" then begin
                    if "Approval Status" = Enum::"Hagiwara Approval Status"::Approved then begin
                        if recApprESign.get("Hagi Approver") then begin
                            if recApprESign."Sign Picture".HasValue then begin
                                ESignTenantMedia.get(recApprESign."Sign Picture".MediaId);
                                ESignTenantMedia.CalcFields(Content);
                            end;
                        end;
                    end else if "Approval Status" = Enum::"Hagiwara Approval Status"::"Auto Approved" then begin
                        recSalesSetup.Get();
                        if recApprESign.get(recSalesSetup."Posted Sales E-Sig.") then begin
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

                CompanyInfo.GET;

                CompanyInfo.CALCFIELDS(Picture);
                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                END;

                IF "No." = '' THEN
                    OrderNoText := ''
                ELSE
                    OrderNoText := FIELDCAPTION("No.");
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
                END;
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");
                Cust.GET("Bill-to Customer No.");

                //SH 09082007 start
                IF "Ship-to Code" = '' THEN BEGIN
                    TelNo := Cust."Phone No.";
                    FaxNo := Cust."Fax No.";
                END ELSE BEGIN
                    ShipToAddress.GET("Bill-to Customer No.", "Ship-to Code");
                    TelNo := ShipToAddress."Phone No.";
                    FaxNo := ShipToAddress."Fax No.";
                END;
                //SH End

                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT
                ELSE
                    PaymentTerms.GET("Payment Terms Code");
                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                    IF ShipToAddr[i] <> CustAddr[i] THEN
                        ShowShippingAddr := TRUE;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN BEGIN
                        IF "Bill-to Contact No." <> '' THEN
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No."
                               , "Salesperson Code", "Campaign No.", "Posting Description", '')
                        ELSE
                            SegManagement.LogDocument(
                              4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No."
                               , "Salesperson Code", "Campaign No.", "Posting Description", '');
                    END;

                // YUKA for Hagiwara 20030218
                CountryFrom := '';
                CountryTo := '';
                CountrySold := '';
                CountryShip := '';
                Country.RESET;
                Country.GET(CompanyInfo."Country/Region Code");
                CountryFrom := Country.Name;
                IF "Sales Header"."Ship-to Country/Region Code" <> '' THEN BEGIN
                    Country.GET("Sales Header"."Ship-to Country/Region Code");
                    CountryTo := Country.Name;
                    CountryShip := Country.Name;
                END ELSE BEGIN
                    CountryTo := CountryFrom;
                END;

                IF "Sales Header"."Sell-to Country/Region Code" <> '' THEN BEGIN
                    Country.GET("Sales Header"."Sell-to Country/Region Code");
                    CountrySold := Country.Name;
                END;
                // YUKA for Hagiwara 20030218 - END
                // YUKA for Hagiwara 20030226
                //  New Filed added on Sales Invoice for From and To
                IF "Sales Header".From <> '' THEN
                    CountryFrom := "Sales Header".From;
                IF "Sales Header"."To" <> '' THEN
                    CountryTo := "Sales Header"."To";

                // YUKA for Hagiwara 20040109
                IF "Sales Header"."Currency Code" <> 'SGD' THEN
                    ExchangeRate := GetExchangeRate("Sales Header"."Currency Code", "Sales Header"."Posting Date");
                // YUKA for Hagiwara 20040421
                IF "Sales Header"."Currency Code" = '' THEN
                    ExchangeRate := 1 / ExchangeRate;
                //  YUKA for Hagiwara 20040109 _END
                //IF "Sales Invoice Header"."Currency Factor" <> 0 THEN
                //  ExchangeRate := 1/"Sales Invoice Header"."Currency Factor";
                // YUKA for Hagiwara 20030226 - END
                // YUKA For Hagiwara 20040105
                IF "Sales Header"."Currency Code" <> '' THEN
                    CurCode := "Sales Header"."Currency Code"
                ELSE
                    CurCode := GLSetup."LCY Code";
                // YUKA for Hagiwara 20040105 - END

                // BBN.02.sn
                _SalesLine2.SETRANGE("Document No.", "No.");
                _SalesLine2.SETFILTER("Location Code", '<>''''');
                IF _SalesLine2.FINDFIRST THEN
                    IF _Location.GET(_SalesLine2."Location Code") THEN BEGIN
                        IF _Country.GET(_Location."Country/Region Code") THEN;
                        VatRegistrationNoText := VatRegistrationNoCaption + ' ' + _Location."Vat Registration No.";
                    END ELSE BEGIN
                        VatRegistrationNoText := '';
                    END;
                CEOText := STRSUBSTNO(CEO, CompanyInfo."CEO 1", CompanyInfo."CEO 2", CompanyInfo."CEO 3");
                BANKText := STRSUBSTNO(Bank, CompanyInfo."Bank Name", CompanyInfo."Bank Account No.", CompanyInfo."Bank Branch No.");
                IBANText := STRSUBSTNO(IBAN, CompanyInfo.IBAN, CompanyInfo."SWIFT Code");
                ItemCounter := 0;
                // BBN.02.en
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        GLSetup.GET;
    end;

    trigger OnPreReport()
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label 'Sales - Invoice %1';
        Text005: Label 'Page:';
        Text006: Label 'Total %1 Excl. VAT';
        ShipToAddress: Record "Ship-to Address";
        TelNo: Text[30];
        FaxNo: Text[30];
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        //Language: Record "8";
        cuLanguage: Codeunit Language;
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[30];
        SalesPersonText: Text[30];
        VATNoText: Text[30];
        ReferenceText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
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
        TextSGD: Label 'SGD';
        OutputNo: Integer;
        Invoice_No_CaptionLbl: Label 'Order No.';
        Tax_InvoiceCaptionLbl: Label 'Sales Order';
        PerCaptionLbl: Label 'Per';
        fromCaptionLbl: Label 'from';
        toCaptionLbl: Label 'To:';
        Shipped_To__CaptionLbl: Label 'Shipped To :';
        Sold_To__CaptionLbl: Label 'Sold To :';
        Attn___CaptionLbl: Label 'ATTN :';
        DateCaptionLbl: Label 'DATE :';
        Due_DateCaptionLbl: Label 'Due Date';
        Tel_No___CaptionLbl: Label 'TEL :';
        P_S___CaptionLbl: Label 'P/S : ';
        Account_No___CaptionLbl: Label 'Account No. :';
        Header_DimensionsCaptionLbl: Label 'Header Dimensions';
        Item_TypeCaptionLbl: Label 'Item Type';
        DescriptionCaptionLbl: Label 'Description';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        AmountCaptionLbl: Label 'Amount';
        Your_Order_No_CaptionLbl: Label 'Your Order No.';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption_Control85Lbl: Label 'Continued';
        TOTALCaptionLbl: Label 'TOTAL';
        TOTALCaption_Control1000000068Lbl: Label 'TOTAL';
        GRAND_TOTALCaptionLbl: Label 'GRAND TOTAL';
        TOTAL_BEFORE_GSTCaptionLbl: Label 'TOTAL BEFORE GST';
        EmptyStringCaptionLbl: Label ': ';
        EmptyStringCaption_Control1000000053Lbl: Label ': ';
        EmptyStringCaption_Control1000000054Lbl: Label ': ';
        LOCAL_EQUIVALENT_AMOUNT___EXCHANGE_RATE__CaptionLbl: Label 'LOCAL EQUIVALENT AMOUNT - EXCHANGE RATE :';
        GRAND_TOTALCaption_Control1000000043Lbl: Label 'GRAND TOTAL';
        TOTAL_BEFORE_GSTCaption_Control1000000046Lbl: Label 'TOTAL BEFORE GST';
        EmptyStringCaption_Control1000000056Lbl: Label ': ';
        EmptyStringCaption_Control1000000057Lbl: Label ': ';
        EmptyStringCaption_Control1000000058Lbl: Label ': ';
        Line_DimensionsCaptionLbl: Label 'Line Dimensions';
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        PrintFooter1: Boolean;
        PrintFooter2: Boolean;
        PrintFooter3: Boolean;
        PrintFooter4: Boolean;
        PrintFooter5: Boolean;
        NoCaption: Label 'No.';
        PartsNoCaption: Label 'Customer Item No.';
        YourReferenceCaption: Label 'Your reference No.:';
        TradeTermsCaption: Label 'Trade terms:';
        PaymentTermsCaption: Label 'Payment terms:';
        FaxNoCaption: Label 'FAX :';
        VatRegistrationNoCaption: Label 'VAT ID No.:';
        RemarkText: Label 'REMARKS: PLEASE RETURN TO US THE DUPLICATED COPY DULY STAMPED AND SIGNED CONFIRMATION';
        SignCompanyStamp: Label 'SIGN & COMPANY STAMP';
        AuthorisedSignatures: Label 'Authorised Signatures';
        VatRegistrationNoText: Text[50];
        LocationCodeText: Text[256];
        CEOText: Text[256];
        CEO: Label 'CEO: %1, %2, %3';
        CommercialRegister: Label 'Commercial Register:';
        FiscalRepresentative: Label 'Fiscal representative: NEC Logistics Europe B.V.    Hoeksteen 26, 2132 MS Hoofddrorp, Netherlands    VAT ID No.: NL8105 86 836 B01';
        Bank: Label '%1    Account No.: %2    BLZ: %3';
        IBAN: Label 'IBAN: %1    SWIFT: %2';
        BANKText: Text[256];
        IBANText: Text[256];
        ItemCounter: Integer;
        ItemCounterText: Text[256];
        QuantityCaption: Label 'Quantity';
        ESignTenantMedia: Record "Tenant Media"; //N005

    procedure InitLogInteraction()
    begin
        //LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
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

