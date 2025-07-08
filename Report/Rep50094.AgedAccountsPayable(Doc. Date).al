report 50094 "Aged Accounts Payable(HA)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Aged Accounts Payable(Doc. Date).rdlc';
    Caption = 'Aged Accounts Payable (Doc. Date)';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(CompanyName; COMPANYNAME)
            {
            }
            column(NewPagePerVendor; NewPagePerVendor)
            {
            }
            column(AgesAsOfEndingDate; STRSUBSTNO(Text006, FORMAT(EndingDate, 0, 4)))
            {
            }
            column(SelectAgeByDuePostngDocDt; STRSUBSTNO(Text007, SELECTSTR(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(CaptionVendorFilter; TABLECAPTION + ': ' + VendorFilter)
            {
            }
            column(VendorFilter; VendorFilter)
            {
            }
            column(AgingBy; AgingBy)
            {
            }
            column(SelctAgeByDuePostngDocDt1; STRSUBSTNO(Text004, SELECTSTR(AgingBy + 1, Text009)))
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(GrandTotalVLE5RemAmtLCY; GrandTotalVLERemaingAmtLCY[5])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE4RemAmtLCY; GrandTotalVLERemaingAmtLCY[4])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE3RemAmtLCY; GrandTotalVLERemaingAmtLCY[3])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE2RemAmtLCY; GrandTotalVLERemaingAmtLCY[2])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1RemAmtLCY; GrandTotalVLERemaingAmtLCY[1])
            {
                AutoFormatType = 1;
            }
            column(GrandTotalVLE1AmtLCY; GrandTotalVLEAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(No_Vendor; "No.")
            {
            }
            column(AgedAcctPayableCaption; AgedAcctPayableCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AllAmtsinLCYCaption; AllAmtsinLCYCaptionLbl)
            {
            }
            column(AgedOverdueAmsCaption; AgedOverdueAmsCaptionLbl)
            {
            }
            column(GrandTotalVLE5RemAmtLCYCaption; GrandTotalVLE5RemAmtLCYCaptionLbl)
            {
            }
            column(AmountLCYCaption; AmountLCYCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(DocumentNoCaption; DocumentNoCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeCaptionLbl)
            {
            }
            column(VendorNoCaption; FIELDCAPTION("No."))
            {
            }
            column(VendorNameCaption; FIELDCAPTION(Name))
            {
            }
            column(CurrencyCaption; CurrencyCaptionLbl)
            {
            }
            column(TotalLCYCaption; TotalLCYCaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                var
                    VendorLedgEntry: Record "Vendor Ledger Entry";
                begin
                    VendorLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                    VendorLedgEntry.SETRANGE("Closed by Entry No.", "Entry No.");
                    VendorLedgEntry.SETRANGE("Posting Date", 0D, EndingDate);
                    IF VendorLedgEntry.FindFirst() THEN
                        REPEAT
                            InsertTemp(VendorLedgEntry);
                        UNTIL VendorLedgEntry.NEXT = 0;

                    IF "Closed by Entry No." <> 0 THEN BEGIN
                        VendorLedgEntry.SETRANGE("Closed by Entry No.", "Closed by Entry No.");
                        IF VendorLedgEntry.FindFirst() THEN
                            REPEAT
                                InsertTemp(VendorLedgEntry);
                            UNTIL VendorLedgEntry.NEXT = 0;
                    END;

                    VendorLedgEntry.RESET;
                    VendorLedgEntry.SETRANGE("Entry No.", "Closed by Entry No.");
                    VendorLedgEntry.SETRANGE("Posting Date", 0D, EndingDate);
                    IF VendorLedgEntry.FindFirst() THEN
                        REPEAT
                            InsertTemp(VendorLedgEntry);
                        UNTIL VendorLedgEntry.NEXT = 0;
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin
                    SETRANGE("Posting Date", EndingDate + 1, DMY2DATE(31, 12, 9999));
                end;
            }
            dataitem(OpenVendorLedgEntry; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", Open, Positive, "Due Date", "Currency Code");
                PrintOnlyIfDetail = true;

                trigger OnAfterGetRecord()
                begin
                    IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                        CALCFIELDS("Remaining Amt. (LCY)");
                        IF "Remaining Amt. (LCY)" = 0 THEN
                            CurrReport.SKIP;
                    END;
                    InsertTemp(OpenVendorLedgEntry);
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin
                    IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                        SETRANGE("Posting Date", 0D, EndingDate);
                        SETRANGE("Date Filter", 0D, EndingDate);
                    END
                end;
            }
            dataitem(CurrencyLoop; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 ..));
                PrintOnlyIfDetail = true;
                dataitem(TempVendortLedgEntryLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = FILTER(1 ..));
                    column(VendorName; Vendor.Name)
                    {
                    }
                    column(VendorNo; Vendor."No.")
                    {
                    }
                    column(VLEEndingDateRemAmtLCY; VendorLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVLE1RemAmtLCY; AgedVendorLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmtLCY; AgedVendorLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmtLCY; AgedVendorLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmtLCY; AgedVendorLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt5RemAmtLCY; AgedVendorLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtAmtLCY; VendorLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndDtDueDate; FORMAT(VendorLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocNo; VendorLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(VendLedgEntyEndgDtDocType; FORMAT(VendorLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(VendLedgEntryEndDtPostgDt; FORMAT(VendorLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(VendLedgEntryEndDtDocDt; FORMAT(VendorLedgEntryEndingDate."Document Date"))
                    {
                    }
                    column(AgedVendLedgEnt5RemAmt; AgedVendorLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt4RemAmt; AgedVendorLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt3RemAmt; AgedVendorLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt2RemAmt; AgedVendorLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedVendLedgEnt1RemAmt; AgedVendorLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VLEEndingDateRemAmt; VendorLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VendLedgEntryEndingDtAmt; VendorLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalVendorName; STRSUBSTNO(Text005, Vendor.Name))
                    {
                    }
                    column(CurrCode_TempVenLedgEntryLoop; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PeriodIndex: Integer;
                    begin
                        IF Number = 1 THEN BEGIN
                            IF NOT TempVendorLedgEntry.FindFirst() THEN
                                CurrReport.BREAK;
                        END ELSE
                            IF TempVendorLedgEntry.NEXT = 0 THEN
                                CurrReport.BREAK;

                        VendorLedgEntryEndingDate := TempVendorLedgEntry;
                        DetailedVendorLedgerEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgEntryEndingDate."Entry No.");
                        IF DetailedVendorLedgerEntry.FindFirst() THEN
                            REPEAT
                                IF (DetailedVendorLedgerEntry."Entry Type" =
                                    DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") AND
                                   (VendorLedgEntryEndingDate."Posting Date" > EndingDate) AND
                                   (AgingBy <> AgingBy::"Posting Date")
                                THEN BEGIN
                                    IF VendorLedgEntryEndingDate."Document Date" <= EndingDate THEN
                                        DetailedVendorLedgerEntry."Posting Date" :=
                                          VendorLedgEntryEndingDate."Document Date"
                                    ELSE
                                        IF (VendorLedgEntryEndingDate."Due Date" <= EndingDate) AND
                                           (AgingBy = AgingBy::"Due Date")
                                        THEN
                                            DetailedVendorLedgerEntry."Posting Date" :=
                                              VendorLedgEntryEndingDate."Due Date"
                                END;

                                IF (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) OR
                                   (TempVendorLedgEntry.Open AND
                                    (AgingBy = AgingBy::"Due Date") AND
                                    (VendorLedgEntryEndingDate."Due Date" > EndingDate) AND
                                    (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                                THEN BEGIN
                                    IF DetailedVendorLedgerEntry."Entry Type" IN
                                       [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                        DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                        DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                    THEN BEGIN
                                        VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Amount (LCY)" :=
                                          VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    END;
                                    IF DetailedVendorLedgerEntry."Posting Date" <= EndingDate THEN BEGIN
                                        VendorLedgEntryEndingDate."Remaining Amount" :=
                                          VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                          VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                    END;
                                END;
                            UNTIL DetailedVendorLedgerEntry.NEXT = 0;

                        IF VendorLedgEntryEndingDate."Remaining Amount" = 0 THEN
                            CurrReport.SKIP;

                        CASE AgingBy OF
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                BEGIN
                                    IF VendorLedgEntryEndingDate."Document Date" > EndingDate THEN BEGIN
                                        VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                        VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                        VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                                    END;
                                    PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                                END;
                        END;
                        CLEAR(AgedVendorLedgEntry);
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
                        AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
                        TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                    end;

                    trigger OnPostDataItem()
                    begin
                        IF NOT PrintAmountInLCY THEN
                            UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT PrintAmountInLCY THEN
                            TempVendorLedgEntry.SETRANGE("Currency Code", TempCurrency.Code);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(TotalVendorLedgEntry);

                    IF Number = 1 THEN BEGIN
                        IF NOT TempCurrency.FindFirst() THEN
                            CurrReport.BREAK;
                    END ELSE
                        IF TempCurrency.NEXT = 0 THEN
                            CurrReport.BREAK;

                    IF TempCurrency.Code <> '' THEN
                        CurrencyCode := TempCurrency.Code
                    ELSE
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPostDataItem()
                begin
                    //IF NewPagePerVendor AND (NumberOfCurrencies > 0) THEN
                    //CurrReport.NEWPAGE;
                end;

                trigger OnPreDataItem()
                begin
                    NumberOfCurrencies := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF NewPagePerVendor THEN
                    PageGroupNo := PageGroupNo + 1;

                TempCurrency.RESET;
                TempCurrency.DELETEALL;
                TempVendorLedgEntry.RESET;
                TempVendorLedgEntry.DELETEALL;
                CLEAR(GrandTotalVLERemaingAmtLCY);
                GrandTotalVLEAmtLCY := 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
            end;
        }
        dataitem(CurrencyTotals; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            column(Number_CurrencyTotals; Number)
            {
            }
            column(NewPagePerVend_CurrTotal; NewPagePerVendor)
            {
            }
            column(TempCurrency2Code; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt6RemAmtLCY5; AgedVendorLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt1RemAmtLCY1; AgedVendorLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt2RemAmtLCY2; AgedVendorLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt3RemAmtLCY3; AgedVendorLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt4RemAmtLCY4; AgedVendorLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedVendLedgEnt5RemAmtLCY5; AgedVendorLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrencySpecificationCaption; CurrencySpecificationCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN BEGIN
                    IF NOT TempCurrency2.FindFirst() THEN
                        CurrReport.BREAK;
                END ELSE
                    IF TempCurrency2.NEXT = 0 THEN
                        CurrReport.BREAK;

                CLEAR(AgedVendorLedgEntry);
                TempCurrencyAmount.SETRANGE("Currency Code", TempCurrency2.Code);
                IF TempCurrencyAmount.FindFirst() THEN
                    REPEAT
                        IF TempCurrencyAmount.Date <> DMY2DATE(31, 12, 9999) THEN
                            AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                              TempCurrencyAmount.Amount
                        ELSE
                            AgedVendorLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                    UNTIL TempCurrencyAmount.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
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
                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the aging calculated for.';
                    }
                    field(AgingBy; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aging by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the aging will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the length of each period, for example, enter "1M" for one month.';
                    }
                    field(PrintAmountInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies if you want the report to specify the aging per vendor ledger entry.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each vendor.';
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(NewPagePerVendor; NewPagePerVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF EndingDate = 0D THEN
                EndingDate := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        VendorFilter := GetRecordFiltersWithCaptions(Vendor);

        GLSetup.GET;

        CalcDates;
        CreateHeadings;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempVendorLedgEntry: Record "Vendor Ledger Entry" temporary;
        VendorLedgEntryEndingDate: Record "Vendor Ledger Entry";
        TotalVendorLedgEntry: array[5] of Record "Vendor Ledger Entry";
        AgedVendorLedgEntry: array[6] of Record "Vendor Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        GrandTotalVLERemaingAmtLCY: array[5] of Decimal;
        GrandTotalVLEAmtLCY: Decimal;
        VendorFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePerVendor: Boolean;
        PeriodStartDate: array[5] of Date;
        PeriodEndDate: array[5] of Date;
        HeaderText: array[5] of Text[30];
        Text000: Label 'Not Due';
        Text001: Label 'Before';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text003: Label 'More than';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        Text011: Label 'Enter a date formula in the Period Length field.';
        Text027: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        AgedAcctPayableCaptionLbl: Label 'Aged Accounts Payable';
        CurrReportPageNoCaptionLbl: Label 'Page';
        AllAmtsinLCYCaptionLbl: Label 'All Amounts in LCY';
        AgedOverdueAmsCaptionLbl: Label 'Aged Overdue Amounts';
        GrandTotalVLE5RemAmtLCYCaptionLbl: Label 'Balance';
        AmountLCYCaptionLbl: Label 'Original Amount';
        DueDateCaptionLbl: Label 'Due Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentTypeCaptionLbl: Label 'Document Type';
        CurrencyCaptionLbl: Label 'Currency Code';
        TotalLCYCaptionLbl: Label 'Total (LCY)';
        CurrencySpecificationCaptionLbl: Label 'Currency Specification';

    local procedure CalcDates()
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        IF NOT EVALUATE(PeriodLength2, STRSUBSTNO(Text027, PeriodLength)) THEN
            ERROR(Text011);
        IF AgingBy = AgingBy::"Due Date" THEN BEGIN
            PeriodEndDate[1] := DMY2DATE(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
        END ELSE BEGIN
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CALCDATE(PeriodLength2, EndingDate + 1);
        END;
        FOR i := 2 TO ARRAYLEN(PeriodEndDate) DO BEGIN
            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CALCDATE(PeriodLength2, PeriodEndDate[i] + 1);
        END;

        i := ARRAYLEN(PeriodEndDate);

        PeriodStartDate[i] := 0D;

        FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
            IF PeriodEndDate[i] < PeriodStartDate[i] THEN
                ERROR(Text010, PeriodLength);
    end;

    local procedure CreateHeadings()
    var
        i: Integer;
    begin
        IF AgingBy = AgingBy::"Due Date" THEN BEGIN
            HeaderText[1] := Text000;
            i := 2;
        END ELSE
            i := 1;
        WHILE i < ARRAYLEN(PeriodEndDate) DO BEGIN
            IF HeadingType = HeadingType::"Date Interval" THEN
                HeaderText[i] := STRSUBSTNO('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            ELSE
                HeaderText[i] :=
                  STRSUBSTNO('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i := i + 1;
        END;
        IF HeadingType = HeadingType::"Date Interval" THEN
            HeaderText[i] := STRSUBSTNO('%1\%2', Text001, PeriodStartDate[i - 1])
        ELSE
            HeaderText[i] := STRSUBSTNO('%1\%2 %3', Text003, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;

    local procedure InsertTemp(var VendorLedgEntry: Record "Vendor Ledger Entry")
    var
        Currency: Record Currency;
    begin
        IF TempVendorLedgEntry.GET(VendorLedgEntry."Entry No.") THEN
            EXIT;
        TempVendorLedgEntry := VendorLedgEntry;
        TempVendorLedgEntry.INSERT;
        IF PrintAmountInLCY THEN BEGIN
            CLEAR(TempCurrency);
            TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            IF TempCurrency.INSERT THEN;
            EXIT;
        END;
        IF TempCurrency.GET(TempVendorLedgEntry."Currency Code") THEN
            EXIT;
        IF TempVendorLedgEntry."Currency Code" <> '' THEN
            Currency.GET(TempVendorLedgEntry."Currency Code")
        ELSE BEGIN
            CLEAR(Currency);
            Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        END;
        TempCurrency := Currency;
        TempCurrency.INSERT;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer
    var
        i: Integer;
    begin
        FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
            IF Date IN [PeriodStartDate[i] .. PeriodEndDate[i]] THEN
                EXIT(i);
    end;

    local procedure UpdateCurrencyTotals()
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        IF TempCurrency2.INSERT THEN;
        FOR i := 1 TO ARRAYLEN(TotalVendorLedgEntry) DO BEGIN
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := PeriodStartDate[i];
            IF TempCurrencyAmount.FIND THEN BEGIN
                TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalVendorLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.MODIFY;
            END ELSE BEGIN
                TempCurrencyAmount."Currency Code" := CurrencyCode;
                TempCurrencyAmount.Date := PeriodStartDate[i];
                TempCurrencyAmount.Amount := TotalVendorLedgEntry[i]."Remaining Amount";
                TempCurrencyAmount.INSERT;
            END;
        END;
        TempCurrencyAmount."Currency Code" := CurrencyCode;
        TempCurrencyAmount.Date := DMY2DATE(31, 12, 9999);
        IF TempCurrencyAmount.FIND THEN BEGIN
            TempCurrencyAmount.Amount := TempCurrencyAmount.Amount + TotalVendorLedgEntry[1].Amount;
            TempCurrencyAmount.MODIFY;
        END ELSE BEGIN
            TempCurrencyAmount."Currency Code" := CurrencyCode;
            TempCurrencyAmount.Date := DMY2DATE(31, 12, 9999);
            TempCurrencyAmount.Amount := TotalVendorLedgEntry[1].Amount;
            TempCurrencyAmount.INSERT;
        END;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewNewPagePerVendor: Boolean)
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePerVendor := NewNewPagePerVendor;
    end;

    procedure GetRecordFiltersWithCaptions(RecVariant: Variant) Filters: Text;
    VAR
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldFilter: Text;
        Name: Text;
        Cap: Text;
        Pos: Integer;
        i: Integer;
    BEGIN
        RecRef.GETTABLE(RecVariant);
        Filters := RecRef.GETFILTERS;
        IF Filters = '' THEN
            EXIT;

        FOR i := 1 TO RecRef.FIELDCOUNT DO BEGIN
            FieldRef := RecRef.FIELDINDEX(i);
            FieldFilter := FieldRef.GETFILTER;
            IF FieldFilter <> '' THEN BEGIN
                Name := STRSUBSTNO('%1: ', FieldRef.NAME);
                Cap := STRSUBSTNO('%1: ', FieldRef.CAPTION);
                Pos := STRPOS(Filters, Name);
                IF Pos <> 0 THEN
                    Filters := INSSTR(DELSTR(Filters, Pos, STRLEN(Name)), Cap, Pos);
            END;
        END;
    END;
}

