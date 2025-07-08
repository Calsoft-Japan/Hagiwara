report 50005 "Purchase Order US"
{
    // HG10.00.02 NJ 01/06/2017 - Hagirawa US Upgrade
    // CS024 Yuki 2021/07/29 - Show Rank in PO Line
    // CS064 Kenya 2023/10/02 - Add PO/Line No.
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/PurchaseOrderUS.rdlc';

    Caption = 'Purchase Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "No. Printed";
            column(No_PurchaseHeader; "No.")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(txtCompanyName; txtCompanyName)
                    {
                    }
                    column(txtSign; txtSign)
                    {
                    }
                    column(CompanyInformationPicture; CompanyInformation.Picture)
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
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BuyFromAddress1; BuyFromAddress[1])
                    {
                    }
                    column(BuyFromAddress2; BuyFromAddress[2])
                    {
                    }
                    column(BuyFromAddress3; BuyFromAddress[3])
                    {
                    }
                    column(BuyFromAddress4; BuyFromAddress[4])
                    {
                    }
                    column(BuyFromAddress5; BuyFromAddress[5])
                    {
                    }
                    column(BuyFromAddress6; BuyFromAddress[6])
                    {
                    }
                    column(BuyFromAddress7; BuyFromAddress[7])
                    {
                    }
                    column(ExptRecptDt_PurchaseHeader; "Purchase Header"."Expected Receipt Date")
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BuyfrVendNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourRef_PurchaseHeader; "Purchase Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchaseHeader; "Purchase Header"."No.")
                    {
                    }
                    column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BuyFromAddress8; BuyFromAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(CompanyInformationPhoneNo; CompanyInformation."Phone No.")
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(VendTaxIdentificationType; '')
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ReceiveByCaption; ReceiveByCaptionLbl)
                    {
                    }
                    column(VendorIDCaption; VendorIDCaptionLbl)
                    {
                    }
                    column(ConfirmToCaption; ConfirmToCaptionLbl)
                    {
                    }
                    column(BuyerCaption; BuyerCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(ToCaption1; ToCaption1Lbl)
                    {
                    }
                    column(PurchOrderCaption; PurchOrderCaptionLbl)
                    {
                    }
                    column(PurchOrderNumCaption; PurchOrderNumCaptionLbl)
                    {
                    }
                    column(PurchOrderDateCaption; PurchOrderDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(ShippingTerms; "Purchase Header"."Shipping Terms")
                    {
                    }
                    column(IncotermCode; "Purchase Header"."Incoterm Code")
                    {
                    }
                    column(IncotermLocation; "Purchase Header"."Incoterm Location")
                    {
                    }
                    column(IncotermCodeCaption; IncotermCodeCaptionLbl)
                    {
                    }
                    column(IncotermLocationCaption; IncotermLocationCaptionLbl)
                    {
                    }
                    column(UserIDCaption; UserIDCaptionLbl)
                    {
                    }
                    column(UserID; "Purchase Header"."Assigned User ID")
                    {
                    }
                    column(Loc_phoneno; Loc_phoneno)
                    {
                    }
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                            WHERE("Document Type" = CONST(Order));
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(ItemNumberToPrint; ItemNumberToPrint)
                        {
                        }
                        column(UnitofMeasure_PurchaseLine; "Unit of Measure")
                        {
                        }
                        column(Quantity_PurchaseLine; Quantity)
                        {
                        }
                        column(UnitPriceToPrint; "Direct Unit Cost")
                        {
                        }
                        column(Description_PurchaseLine; Description)
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(InvDiscountAmt_PurchaseLine; "Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount; TaxAmount)
                        {
                        }
                        column(LineAmtTaxAmtInvDiscountAmt; "Line Amount" + TaxAmount - "Inv. Discount Amount")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(DocumentNo_PurchaseLine; "Document No.")
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvDiscCaption; InvDiscCaptionLbl)
                        {
                        }
                        column(TotalCaption; STRSUBSTNO(TotalCaptionLbl, CurrencyCode))
                        {
                        }
                        column(PurchaseLinNo; "Purchase Line"."No.")
                        {
                        }
                        column(CustItemNo; "Purchase Line"."Customer Item No.")
                        {
                        }
                        column(VendorItemNo; "Purchase Line"."Vendor Item No.")
                        {
                        }
                        column(RankToPrint; "Purchase Line".Rank)
                        {
                        }
                        column(Description2; "Purchase Line"."Description 2")
                        {
                        }
                        column(PlannedReceiptDate; "Purchase Line"."Planned Receipt Date")
                        {
                        }
                        column(ReqReceiptDate_1; "Purchase Line"."Requested Receipt Date_1")
                        {
                        }
                        column(ManufacturerNoCaption; ManufacturerNoCaptionLbl)
                        {
                        }
                        column(RankCaption; RankCaptionLbl)
                        {
                        }
                        column(ReleaseNoCaption; ReleaseNoCaptionLbl)
                        {
                        }
                        column(DueDateCaption; DueDateCaptionLbl)
                        {
                        }
                        column(FooterText; FooterText)
                        {
                        }
                        column(ItemDescrtoPrint; ItemDescrtoPrint)
                        {
                        }
                        column(LineNo; "Purchase Line"."Line No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            IF "Vendor Item No." <> '' THEN
                                ItemNumberToPrint := "Vendor Item No."
                            ELSE
                                ItemNumberToPrint := "No.";

                            IF Type = Type::" " THEN BEGIN
                                ItemNumberToPrint := '';
                                "Unit of Measure" := '';
                                "Line Amount" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                            END;

                            AmountExclInvDisc := "Line Amount";

                            IF Quantity = 0 THEN
                                UnitPriceToPrint := 0 // so it won't print
                            ELSE
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);

                            //CS024 Begin
                            //RankToPrint:='';
                            //IF Type=Type::Item THEN IF Item.GET("Purchase Line"."No.") THEN RankToPrint := Item."No. 2";
                            //CS024 End
                            //sanjeev
                            ItemDescrtoPrint := '';
                            IF Type = Type::Item THEN IF Item.GET("Purchase Line"."No.") THEN ItemDescrtoPrint := Item.Description;
                            //sanjeev
                            IF OnLineNumber = NumberOfLines THEN BEGIN
                                PrintFooter := TRUE;
                            END;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //CurrReport.CREATETOTALS(AmountExclInvDisc, "Line Amount", "Inv. Discount Amount");
                            NumberOfLines := COUNT;
                            OnLineNumber := 0;
                            PrintFooter := FALSE;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PAGENO := 1;
                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN
                            PurchasePrinted.RUN("Purchase Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                    TaxAmount := 0;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF PrintCompany THEN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                CurrReport.Language := cuLanguage.GetLanguageIdOrDefault("Language Code");

                IF "Purchaser Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Purchaser Code");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                //SS add phone no : from location Location 05-01-18

                IF Loc1.GET("Location Code") THEN
                    Loc_phoneno := Loc1."Phone No.";


                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, "Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");

                IF NOT CurrReport.PREVIEW THEN BEGIN
                    IF ArchiveDocument THEN
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);

                    IF LogInteraction THEN BEGIN
                        CALCFIELDS("No. of Archived Versions");
                        SegManagement.LogDocument(
                          13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.",
                          "Purchaser Code", '', "Posting Description", '');
                    END;
                END;

                IF "Posting Date" <> 0D THEN
                    UseDate := "Posting Date"
                ELSE
                    UseDate := WORKDATE;


                CurrencyCode := "Purchase Header"."Currency Code";
                IF CurrencyCode = '' THEN BEGIN
                    GLSetup.GET;
                    CurrencyCode := GLSetup."LCY Code";
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF PrintCompany THEN
                    FormatAddress.Company(CompanyAddress, CompanyInformation)
                ELSE
                    CLEAR(CompanyAddress);

                txtCompanyName := CompanyInformation.Name;
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
                    field(NumberOfCopies; NoCopies)
                    {
                        Caption = 'Number of Copies';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
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
            ArchiveDocumentEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
            //LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Purch. Ord.") <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.GET('');
        CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
    end;

    var
        CompanyInfo3: Record "Company Information";
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        //Language: Record Language;
        cuLanguage: Codeunit Language;
        TaxArea: Record "Tax Area";
        "Vend se": Record Vendor;
        CompanyAddress: array[8] of Text[50];
        BuyFromAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[40];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchasePrinted: Codeunit "Purch.Header-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        TaxAmount: Decimal;
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        UseDate: Date;
        Text000: Label 'COPY';
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        UseExternalTaxEngine: Boolean;
        //[InDataSet]
        ArchiveDocumentEnable: Boolean;
        //[InDataSet]
        LogInteractionEnable: Boolean;
        ToCaptionLbl: Label 'To:';
        ReceiveByCaptionLbl: Label 'Receive By';
        VendorIDCaptionLbl: Label 'Vendor ID';
        ConfirmToCaptionLbl: Label 'Confirm To';
        BuyerCaptionLbl: Label 'Buyer';
        ShipCaptionLbl: Label 'Ship';
        ToCaption1Lbl: Label 'To:';
        PurchOrderCaptionLbl: Label 'PURCHASE ORDER';
        PurchOrderNumCaptionLbl: Label 'Purchase Order Number:';
        PurchOrderDateCaptionLbl: Label 'Purchase Order Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Ship Via';
        TermsCaptionLbl: Label 'Terms';
        PhoneNoCaptionLbl: Label 'Phone No.';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemNoCaptionLbl: Label 'Customer Item No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvDiscCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total %1:';
        RankToPrint: Text[40];
        Item: Record Item;
        IncotermCodeCaptionLbl: Label 'Incoterm Code';
        IncotermLocationCaptionLbl: Label 'Incoterm Location';
        ManufacturerNoCaptionLbl: Label 'Part No.';
        RankCaptionLbl: Label 'Rank';
        ReleaseNoCaptionLbl: Label 'Release No.';
        DueDateCaptionLbl: Label 'Requested Receipt Date';
        FooterText: Label 'Please confirm receipt of new purchase order within 24 hours.';
        txtCompanyName: Text;
        txtSign: Label 'Authorized Signature';
        UserIDCaptionLbl: Label 'User ID';
        CurrencyCode: Text[10];
        GLSetup: Record "General Ledger Setup";
        ItemDescrtoPrint: Text[50];
        Loc1: Record Location;
        Loc_phoneno: Text[50];
}

