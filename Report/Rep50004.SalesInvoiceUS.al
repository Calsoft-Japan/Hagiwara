report 50004 "Sales Invoice US"
{
    // HG10.00.02 NJ 01/06/2017 - Hagirawa US Upgrade
    // Bobby 05/21/2024 - Bug fix of Sales Invoice US
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/SalesInvoiceUS.rdlc';

    Caption = 'Sales - Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Invoice';
            column(No_SalesInvHeader; "No.")
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    WHERE(Quantity = FILTER(<> 0));
                dataitem(SalesLineComments; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Document No."),
                                   "Document Line No." = FIELD("Line No.");
                    DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.")
                                        WHERE("Document Type" = CONST("Posted Invoice"));

                    trigger OnAfterGetRecord()
                    begin
                        TempSalesInvoiceLine.INIT;
                        TempSalesInvoiceLine."Document No." := "Sales Invoice Header"."No.";
                        TempSalesInvoiceLine."Line No." := HighestLineNo + 10;
                        HighestLineNo := TempSalesInvoiceLine."Line No.";
                        IF STRLEN(Comment) <= MAXSTRLEN(TempSalesInvoiceLine.Description) THEN BEGIN
                            TempSalesInvoiceLine.Description := Comment;
                            TempSalesInvoiceLine."Description 2" := '';
                        END ELSE BEGIN
                            SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            WHILE (SpacePointer > 1) AND (Comment[SpacePointer] <> ' ') DO
                                SpacePointer := SpacePointer - 1;
                            IF SpacePointer = 1 THEN
                                SpacePointer := MAXSTRLEN(TempSalesInvoiceLine.Description) + 1;
                            TempSalesInvoiceLine.Description := COPYSTR(Comment, 1, SpacePointer - 1);
                            TempSalesInvoiceLine."Description 2" :=
                              COPYSTR(COPYSTR(Comment, SpacePointer + 1), 1, MAXSTRLEN(TempSalesInvoiceLine."Description 2"));
                        END;
                        TempSalesInvoiceLine.INSERT;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesInvoiceLine := "Sales Invoice Line";
                    TempSalesInvoiceLine.INSERT;
                    TempSalesInvoiceLineAsm := "Sales Invoice Line";
                    TempSalesInvoiceLineAsm.INSERT;

                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesInvoiceLine.RESET;
                    TempSalesInvoiceLine.DELETEALL;
                    TempSalesInvoiceLineAsm.RESET;
                    TempSalesInvoiceLineAsm.DELETEALL;
                end;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyInformationPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyName; CompanyInfo3.Name)
                    {
                    }
                    column(BankName; CompanyInfo3."Bank Name")
                    {
                    }
                    column(BankAccount; CompanyInfo3."Bank Account No.")
                    {
                    }
                    column(SwiftCode; CompanyInfo3."SWIFT Code")
                    {
                    }
                    column(BankABA; CompanyInfo3."Bank ABA")
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
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(ShptDate_SalesInvHeader; "Sales Invoice Header"."Shipment Date")
                    {
                    }
                    column(DueDate_SalesInvHeader; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
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
                    column(BilltoCustNo_SalesInvHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesInvHeader; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(DocumentDate_SalesInvHeader; "Sales Invoice Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(BillCaption; BillCaptionLbl)
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(OurOrderNoCaption; OurOrderNoCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(InvoiceNumberCaption; InvoiceNumberCaptionLbl)
                    {
                    }
                    column(InvoiceDateCaption; InvoiceDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShippingAgentCode; "Sales Invoice Header"."Shipping Agent Code")
                    {
                    }
                    column(PackageTrackingNo; "Sales Invoice Header"."Package Tracking No.")
                    {
                    }
                    dataitem(SalesInvLine; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(TempSalesInvoiceLineNo; TempSalesInvoiceLine."No.")
                        {
                        }
                        column(TempSalesInvoiceCustItemNo; TempSalesInvoiceLine."Customer Item No.")
                        {
                        }
                        column(TempSalesInvoiceLineDescription2; TempSalesInvoiceLine."Description 2")
                        {
                        }
                        column(TempSalesInvoiceLineUOM; TempSalesInvoiceLine."Unit of Measure")
                        {
                        }
                        column(DescriptionToPrint; DescriptionToPrint)
                        {
                        }
                        column(TempSalesInvoiceLineQty; TempSalesInvoiceLine.Quantity)
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(TempSalesInvoiceLineDocNo; TempSalesInvoiceLine."Document No.")
                        {
                        }
                        column(TempSalesInvoiceLineLineNo; TempSalesInvoiceLine."Line No.")
                        {
                        }
                        column(TempSalesInvoiceLineAmtInclVAT; TempSalesInvoiceLine."Amount Including VAT")
                        {
                        }
                        column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
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
                        column(TotalCaption; TotalCaption)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(OrderQtyCaption; OrderQtyCaptionLbl)
                        {
                        }
                        column(CustPO; TempSalesInvoiceLine."Customer Order No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            IF OnLineNumber = 1 THEN
                                TempSalesInvoiceLine.FIND('-')
                            ELSE
                                TempSalesInvoiceLine.NEXT;

                            OrderedQuantity := 0;
                            IF "Sales Invoice Header"."Order No." = '' THEN
                                OrderedQuantity := TempSalesInvoiceLine.Quantity
                            ELSE
                                IF OrderLine.GET(1, "Sales Invoice Header"."Order No.", TempSalesInvoiceLine."Line No.") THEN
                                    OrderedQuantity := OrderLine.Quantity
                                ELSE BEGIN
                                    ShipmentLine.SETRANGE("Order No.", "Sales Invoice Header"."Order No.");
                                    ShipmentLine.SETRANGE("Order Line No.", TempSalesInvoiceLine."Line No.");
                                    IF ShipmentLine.FIND('-') THEN
                                        REPEAT
                                            OrderedQuantity := OrderedQuantity + ShipmentLine.Quantity;
                                        UNTIL 0 = ShipmentLine.NEXT;
                                END;

                            DescriptionToPrint := TempSalesInvoiceLine.Description + ' ' + TempSalesInvoiceLine."Description 2";
                            IF TempSalesInvoiceLine.Type = TempSalesInvoiceLine.Type::" " THEN BEGIN
                                TempSalesInvoiceLine."No." := '';
                                TempSalesInvoiceLine."Unit of Measure" := '';
                                TempSalesInvoiceLine.Amount := 0;
                                TempSalesInvoiceLine."Amount Including VAT" := 0;
                                TempSalesInvoiceLine."Inv. Discount Amount" := 0;
                                TempSalesInvoiceLine.Quantity := 0;
                            END ELSE
                                IF TempSalesInvoiceLine.Type = TempSalesInvoiceLine.Type::"G/L Account" THEN
                                    TempSalesInvoiceLine."No." := '';

                            IF TempSalesInvoiceLine."No." = '' THEN BEGIN
                                HighDescriptionToPrint := DescriptionToPrint;
                                LowDescriptionToPrint := '';
                            END ELSE BEGIN
                                HighDescriptionToPrint := '';
                                LowDescriptionToPrint := DescriptionToPrint;
                            END;

                            IF TempSalesInvoiceLine.Amount <> TempSalesInvoiceLine."Amount Including VAT" THEN
                                TaxLiable := TempSalesInvoiceLine.Amount
                            ELSE
                                TaxLiable := 0;

                            AmountExclInvDisc := TempSalesInvoiceLine.Amount + TempSalesInvoiceLine."Inv. Discount Amount";

                            IF TempSalesInvoiceLine.Quantity = 0 THEN
                                UnitPriceToPrint := 0
                            // so it won't print
                            ELSE
                                // UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);//SS25042018
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / TempSalesInvoiceLine.Quantity, 0.0001);

                            DescriptionToPrint := TempSalesInvoiceLine.Description;
                            IF TempSalesInvoiceLine.Type = TempSalesInvoiceLine.Type::Item THEN
                                IF Item.GET(TempSalesInvoiceLine."No.") THEN DescriptionToPrint := Item."Vendor Item No.";
                        end;

                        trigger OnPreDataItem()
                        begin
                            //CurrReport.CREATETOTALS(TaxLiable, AmountExclInvDisc, TempSalesInvoiceLine.Amount, TempSalesInvoiceLine."Amount Including VAT");
                            NumberOfLines := TempSalesInvoiceLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PAGENO := 1;

                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN
                            SalesInvPrinted.RUN("Sales Invoice Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies) + Customer."Invoice Copies";
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

                IF "Salesperson Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Salesperson Code");

                IF NOT Customer.GET("Bill-to Customer No.") THEN BEGIN
                    CLEAR(Customer);
                    "Bill-to Name" := Text009;
                    "Ship-to Name" := Text009;
                END;
                DocumentText := USText000;
                IF "Prepayment Invoice" THEN
                    DocumentText := USText001;

                FormatAddress.SalesInvBillTo(BillToAddress, "Sales Invoice Header");
                FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");

                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");

                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");

                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, GLSetup."LCY Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaptionTxt, GLSetup."LCY Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaptionTxt, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalCaption := STRSUBSTNO(TotalCaptionTxt, "Currency Code");
                    AmountExemptfromSalesTaxCaption := STRSUBSTNO(AmountExemptfromSalesTaxCaption, "Currency Code");
                    AmountSubjecttoSalesTaxCaption := STRSUBSTNO(AmountSubjecttoSalesTaxCaption, "Currency Code");
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
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
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
        end;
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
        ShipmentLine.SETCURRENTKEY("Order No.", "Order Line No.");
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;

        CompanyInformation.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;

        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;

    var
        TaxLiable: Decimal;
        OrderedQuantity: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        OrderLine: Record "Sales Line";
        ShipmentLine: Record "Sales Shipment Line";
        TempSalesInvoiceLine: Record "Sales Invoice Line" temporary;
        TempSalesInvoiceLineAsm: Record "Sales Invoice Line" temporary;
        RespCenter: Record "Responsibility Center";
        //Language: Record Language;
        cuLanguage: Codeunit Language;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        GLSetup: Record "General Ledger Setup";
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        DescriptionToPrint: Text[210];
        HighDescriptionToPrint: Text[210];
        LowDescriptionToPrint: Text[210];
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesInvPrinted: Codeunit "Sales Inv.-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: Label 'COPY';
        TaxRegNo: Text;
        TaxRegLabel: Text;
        TotalTaxLabel: Text;
        BreakdownTitle: Text;
        BreakdownLabel: array[4] of Text;
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        DocumentText: Text[20];

        LogInteractionEnable: Boolean;
        Text009: Label 'VOID INVOICE';
        USText000: Label 'INVOICE';
        USText001: Label 'PREPAYMENT REQUEST';
        BillCaptionLbl: Label 'Bill';
        ToCaptionLbl: Label 'To:';
        ShipViaCaptionLbl: Label 'Ship Via';
        ShipDateCaptionLbl: Label 'Ship Date';
        DueDateCaptionLbl: Label 'Due Date';
        TermsCaptionLbl: Label 'Terms';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'P.O. Number';
        PODateCaptionLbl: Label 'P.O. Date';
        OurOrderNoCaptionLbl: Label 'S.O. Number';
        ShipCaptionLbl: Label 'Ship';
        InvoiceNumberCaptionLbl: Label 'Invoice Number:';
        InvoiceDateCaptionLbl: Label 'Invoice Date:';
        PageCaptionLbl: Label 'Page:';
        ItemDescriptionCaptionLbl: Label 'Item Code';
        UnitCaptionLbl: Label 'Description';
        OrderQtyCaptionLbl: Label 'Notes';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        TotalCaptionTxt: Label 'Total:';
        TotalCaption: Text;
        AmountSubjecttoSalesTaxCaption: Text;
        AmountExemptfromSalesTaxCaption: Text;
        AmountSubjecttoSalesTaxCaptionTxt: Label 'Amount Subject to Sales Tax %1';
        AmountExemptfromSalesTaxCaptionTxt: Label 'Amount Exempt from Sales Tax %1';
        Item: Record Item;

    procedure InitLogInteraction()
    begin
        //LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;
}

