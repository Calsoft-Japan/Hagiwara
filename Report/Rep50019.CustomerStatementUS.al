report 50019 "Customer Statement US"
{
    // HG10.00.02 NJ 01/06/2017 - Hagirawa US Upgrade
    // CS092 FDD R014 Channing.Zhou 07/03/2025 - Upgrade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Customer Statement US.rdlc';

    Caption = 'Customer Statement US';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Print Statements", "Date Filter";
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem(HeaderFooter; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(CompanyInformationPicture; CompanyInformation.Picture)
                {
                }
                column(CompanyInfo1_Picture; CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2_Picture; CompanyInfo2.Picture)
                {
                }
                column(CompanyAddress_1_; CompanyAddress[1])
                {
                }
                column(CompanyAddress_2_; CompanyAddress[2])
                {
                }
                column(CompanyAddress_3_; CompanyAddress[3])
                {
                }
                column(CompanyAddress_4_; CompanyAddress[4])
                {
                }
                column(CompanyAddress_5_; CompanyAddress[5])
                {
                }
                column(ToDate; ToDate)
                {
                }
                column(CompanyAddress_6_; CompanyAddress[6])
                {
                }
                column(Customer__No__; Customer."No.")
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(CustomerAddress_1_; CustomerAddress[1])
                {
                }
                column(CustomerAddress_2_; CustomerAddress[2])
                {
                }
                column(CustomerAddress_3_; CustomerAddress[3])
                {
                }
                column(CustomerAddress_4_; CustomerAddress[4])
                {
                }
                column(CustomerAddress_5_; CustomerAddress[5])
                {
                }
                column(CustomerAddress_6_; CustomerAddress[6])
                {
                }
                column(CustomerAddress_7_; CustomerAddress[7])
                {
                }
                column(CompanyAddress_7_; CompanyAddress[7])
                {
                }
                column(CompanyAddress_8_; CompanyAddress[8])
                {
                }
                column(CustomerAddress_8_; CustomerAddress[8])
                {
                }
                column(CurrencyDesc; CurrencyDesc)
                {
                }
                column(AgingMethod_Int; AgingMethod_Int)
                {
                }
                column(StatementStyle_Int; StatementStyle_Int)
                {
                }
                column(printfooter3ornot; (AgingMethod <> AgingMethod::None) AND StatementComplete)
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBalance; -CreditBalance)
                {
                }
                column(BalanceToPrint; BalanceToPrint)
                {
                }
                column(DebitBalance_Control22; DebitBalance)
                {
                }
                column(CreditBalance_Control23; -CreditBalance)
                {
                }
                column(BalanceToPrint_Control24; BalanceToPrint)
                {
                }
                column(AgingDaysText; AgingDaysText)
                {
                }
                column(AgingHead_1_; AgingHead[1])
                {
                }
                column(AgingHead_2_; AgingHead[2])
                {
                }
                column(AgingHead_3_; AgingHead[3])
                {
                }
                column(AgingHead_4_; AgingHead[4])
                {
                }
                column(AmountDue_1_; AmountDue[1])
                {
                }
                column(AmountDue_2_; AmountDue[2])
                {
                }
                column(AmountDue_3_; AmountDue[3])
                {
                }
                column(AmountDue_4_; AmountDue[4])
                {
                }
                column(TempAmountDue_1_; TempAmountDue[1])
                {
                }
                column(TempAmountDue_3_; TempAmountDue[3])
                {
                }
                column(TempAmountDue_2_; TempAmountDue[2])
                {
                }
                column(TempAmountDue_4_; TempAmountDue[4])
                {
                }
                column(HeaderFooter_Number; Number)
                {
                }
                column(STATEMENTCaption; STATEMENTCaptionLbl)
                {
                }
                column(Statement_Date_Caption; Statement_Date_CaptionLbl)
                {
                }
                column(Account_Number_Caption; Account_Number_CaptionLbl)
                {
                }
                column(Page_Caption; Page_CaptionLbl)
                {
                }
                column(RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_Caption; RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_CaptionLbl)
                {
                }
                column(Amount_RemittedCaption; Amount_RemittedCaptionLbl)
                {
                }
                column(TempCustLedgEntry__Document_No__Caption; TempCustLedgEntry__Document_No__CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Posting_Date_Caption; TempCustLedgEntry__Posting_Date_CaptionLbl)
                {
                }
                column(GetTermsString_TempCustLedgEntry_Caption; GetTermsString_TempCustLedgEntry_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Document_Type_Caption; TempCustLedgEntry__Document_Type_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Remaining_Amount_Caption; TempCustLedgEntry__Remaining_Amount_CaptionLbl)
                {
                }
                column(TempCustLedgEntry__Remaining_Amount__Control47Caption; TempCustLedgEntry__Remaining_Amount__Control47CaptionLbl)
                {
                }
                column(BalanceToPrint_Control48Caption; BalanceToPrint_Control48CaptionLbl)
                {
                }
                column(Statement_BalanceCaption; Statement_BalanceCaptionLbl)
                {
                }
                column(Statement_BalanceCaption_Control25; Statement_BalanceCaption_Control25Lbl)
                {
                }
                column(Statement_Aging_Caption; Statement_Aging_CaptionLbl)
                {
                }
                column(Aged_amounts_Caption; Aged_amounts_CaptionLbl)
                {
                }
                dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", Open)
                                        WHERE(Open = CONST(true));

                    trigger OnAfterGetRecord()
                    begin
                        SETRANGE("Date Filter", 0D, ToDate);
                        CALCFIELDS("Remaining Amount");
                        IF "Remaining Amount" <> 0 THEN
                            InsertTemp("Cust. Ledger Entry");
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (AgingMethod = AgingMethod::None) AND (StatementStyle = StatementStyle::Balance) THEN
                            CurrReport.BREAK;    // Optimization

                        // Find ledger entries which are open and posted before the statement date.
                        SETRANGE("Posting Date", 0D, ToDate);
                    end;
                }
                dataitem(AfterStmntDateEntry; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No."),
                                   "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                   "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        GetAppliedCustEntries(TempAppliedCustLedgEntry, AfterStmntDateEntry, FALSE);
                        TempAppliedCustLedgEntry.SETRANGE("Posting Date", 0D, ToDate);
                        IF TempAppliedCustLedgEntry.FIND('-') THEN
                            REPEAT
                                InsertTemp(TempAppliedCustLedgEntry);
                            UNTIL TempAppliedCustLedgEntry.NEXT = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (AgingMethod = AgingMethod::None) AND (StatementStyle = StatementStyle::Balance) THEN
                            CurrReport.BREAK;    // Optimization

                        // Find ledger entries which are posted after the statement date and eliminate
                        // their application to ledger entries posted before the statement date.
                        SETFILTER("Posting Date", '%1..', ToDate + 1);
                    end;
                }
                dataitem("Balance Forward"; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(FromDate___1; FromDate - 1)
                    {
                    }
                    column(BalanceToPrint_Control39; BalanceToPrint)
                    {
                    }
                    column(Balance_Forward_Number; Number)
                    {
                    }
                    column(Balance_ForwardCaption; Balance_ForwardCaptionLbl)
                    {
                    }
                    column(Bal_FwdCaption; Bal_FwdCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF StatementStyle <> StatementStyle::Balance THEN
                            CurrReport.BREAK;
                    end;

                    trigger OnPreDataItem()
                    begin
                        StatementStyle_Int := StatementStyle;
                    end;
                }
                dataitem(OpenItem; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(TempCustLedgEntry__Document_No__; TempCustLedgEntry."Document No.")
                    {
                    }
                    column(TempCustLedgEntry__Posting_Date_; TempCustLedgEntry."Posting Date")
                    {
                    }
                    column(GetTermsString_TempCustLedgEntry_; GetTermsString(TempCustLedgEntry))
                    {
                    }
                    column(TempCustLedgEntry__Document_Type_; TempCustLedgEntry."Document Type")
                    {
                        //OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
                    }
                    column(TempCustLedgEntry__Remaining_Amount_; TempCustLedgEntry."Remaining Amount")
                    {
                    }
                    column(TempCustLedgEntry__Remaining_Amount__Control47; -TempCustLedgEntry."Remaining Amount")
                    {
                    }
                    column(BalanceToPrint_Control48; BalanceToPrint)
                    {
                    }
                    column(OpenItem_Number; Number)
                    {
                    }
                    column(TempCustLedgEntry__ExtDoc_No_; TempCustLedgEntry."External Document No.")
                    {
                    }
                    column(TempCustLedgEntry__Due_Date; TempCustLedgEntry."Due Date")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN
                            TempCustLedgEntry.FIND('-')
                        ELSE
                            TempCustLedgEntry.NEXT;
                        TempCustLedgEntry.CALCFIELDS("Remaining Amount");
                        IF TempCustLedgEntry."Currency Code" <> Customer."Currency Code" THEN
                            TempCustLedgEntry."Remaining Amount" :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  TempCustLedgEntry."Posting Date",
                                  TempCustLedgEntry."Currency Code",
                                  Customer."Currency Code",
                                  TempCustLedgEntry."Remaining Amount"),
                                Currency."Amount Rounding Precision");

                        IF AgingMethod <> AgingMethod::None THEN BEGIN
                            CASE AgingMethod OF
                                AgingMethod::"Due Date":
                                    AgingDate := TempCustLedgEntry."Due Date";
                                AgingMethod::"Trans Date":
                                    AgingDate := TempCustLedgEntry."Posting Date";
                                AgingMethod::"Doc Date":
                                    AgingDate := TempCustLedgEntry."Document Date";
                            END;
                            i := 0;
                            WHILE AgingDate < PeriodEndingDate[i + 1] DO
                                i := i + 1;
                            IF i = 0 THEN
                                i := 1;
                            AmountDue[i] := TempCustLedgEntry."Remaining Amount";
                            TempAmountDue[i] := TempAmountDue[i] + AmountDue[i];
                        END;

                        IF StatementStyle = StatementStyle::"Open Item" THEN BEGIN
                            BalanceToPrint := BalanceToPrint + TempCustLedgEntry."Remaining Amount";
                            IF TempCustLedgEntry."Remaining Amount" >= 0 THEN
                                DebitBalance := DebitBalance + TempCustLedgEntry."Remaining Amount"
                            ELSE
                                CreditBalance := CreditBalance + TempCustLedgEntry."Remaining Amount";
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF (NOT TempCustLedgEntry.FIND('-')) OR
                           ((StatementStyle = StatementStyle::Balance) AND
                            (AgingMethod = AgingMethod::None))
                        THEN
                            CurrReport.BREAK
                            ;
                        SETRANGE(Number, 1, TempCustLedgEntry.COUNT);
                        TempCustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date");
                        TempCustLedgEntry.SETRANGE("Date Filter", 0D, ToDate);
                        //CurrReport.CREATETOTALS(AmountDue);
                    end;
                }
                dataitem(CustLedgerEntry4; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemLinkReference = Customer;
                    DataItemTableView = SORTING("Customer No.", "Posting Date");
                    column(CustLedgerEntry4__Document_No__; "Document No.")
                    {
                    }
                    column(CustLedgerEntry4__Posting_Date_; "Posting Date")
                    {
                    }
                    column(GetTermsString_CustLedgerEntry4_; GetTermsString(CustLedgerEntry4))
                    {
                    }
                    column(CustLedgerEntry4__Document_Type_; "Document Type")
                    {
                    }
                    column(CustLedgerEntry4_Amount; Amount)
                    {
                    }
                    column(Amount; -Amount)
                    {
                    }
                    column(BalanceToPrint_Control55; BalanceToPrint)
                    {
                    }
                    column(CustLedgerEntry4_Entry_No_; "Entry No.")
                    {
                    }
                    column(CustLedgerEntry4_Customer_No_; "Customer No.")
                    {
                    }
                    column(CustLedgerEntry4_ExtDoc_No_; "External Document No.")
                    {
                    }
                    column(CustLedgerEntry4_Due_Date; CustLedgerEntry4."Due Date")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CALCFIELDS(Amount, "Amount (LCY)");
                        IF (Customer."Currency Code" = '') AND ("Cust. Ledger Entry"."Currency Code" = '') THEN
                            Amount := "Amount (LCY)"
                        ELSE
                            Amount :=
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToFCY(
                                  "Posting Date",
                                  "Currency Code",
                                  Customer."Currency Code",
                                  Amount),
                                Currency."Amount Rounding Precision");

                        BalanceToPrint := BalanceToPrint + Amount;
                        IF Amount >= 0 THEN
                            DebitBalance := DebitBalance + Amount
                        ELSE
                            CreditBalance := CreditBalance + Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF StatementStyle <> StatementStyle::Balance THEN
                            CurrReport.BREAK;
                        SETRANGE("Posting Date", FromDate, ToDate);
                    end;
                }
                dataitem(EndOfCustomer; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(StatementComplete; StatementComplete)
                    {
                    }
                    column(EndOfCustomer_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        StatementComplete := TRUE;
                        IF UpdateNumbers AND (NOT CurrReport.PREVIEW) THEN BEGIN
                            Customer.MODIFY; // just update the Last Statement No
                            COMMIT;
                        END;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    AgingMethod_Int := AgingMethod;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                CurrReport.Language := cuLanguage.GetLanguageIdOrDefault("Language Code");
                DebitBalance := 0;
                CreditBalance := 0;
                CLEAR(AmountDue);
                CLEAR(TempAmountDue);
                CompanyInformation.CALCFIELDS(Picture);
                Print := FALSE;
                IF AllHavingBalance THEN BEGIN
                    SETRANGE("Date Filter", 0D, ToDate);
                    CALCFIELDS("Net Change");
                    Print := "Net Change" <> 0;
                END;
                IF (NOT Print) AND AllHavingEntries THEN BEGIN
                    "Cust. Ledger Entry".RESET;
                    IF StatementStyle = StatementStyle::Balance THEN BEGIN
                        "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", "Posting Date");
                        "Cust. Ledger Entry".SETRANGE("Posting Date", FromDate, ToDate);
                    END ELSE BEGIN
                        "Cust. Ledger Entry".SETCURRENTKEY("Customer No.", Open);
                        "Cust. Ledger Entry".SETRANGE("Posting Date", 0D, ToDate);
                        "Cust. Ledger Entry".SETRANGE(Open, TRUE);
                    END;
                    "Cust. Ledger Entry".SETRANGE("Customer No.", "No.");
                    Print := "Cust. Ledger Entry".FIND('-');
                END;
                IF NOT Print THEN
                    CurrReport.SKIP;

                TempCustLedgEntry.DELETEALL;

                AgingDaysText := '';
                IF AgingMethod <> AgingMethod::None THEN BEGIN
                    AgingHead[1] := Text006;
                    PeriodEndingDate[1] := ToDate;
                    IF AgingMethod = AgingMethod::"Due Date" THEN BEGIN
                        PeriodEndingDate[2] := PeriodEndingDate[1];
                        FOR i := 3 TO 4 DO
                            PeriodEndingDate[i] := CALCDATE(PeriodCalculation, PeriodEndingDate[i - 1]);
                        AgingDaysText := Text007;
                        AgingHead[2] := Text008 + ' '
                          + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + Text009;
                    END ELSE BEGIN
                        FOR i := 2 TO 4 DO
                            PeriodEndingDate[i] := CALCDATE(PeriodCalculation, PeriodEndingDate[i - 1]);
                        AgingDaysText := Text010;
                        AgingHead[2] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[2] + 1)
                          + ' - '
                          + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3])
                          + Text009;
                    END;
                    PeriodEndingDate[5] := 0D;
                    AgingHead[3] := FORMAT(PeriodEndingDate[1] - PeriodEndingDate[3] + 1)
                      + ' - '
                      + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                      + Text009;
                    AgingHead[4] := Text011 + ' '
                      + FORMAT(PeriodEndingDate[1] - PeriodEndingDate[4])
                      + Text009;
                END;

                IF "Currency Code" = '' THEN BEGIN
                    CLEAR(Currency);
                    CurrencyDesc := '';
                END ELSE BEGIN
                    Currency.GET("Currency Code");
                    CurrencyDesc := STRSUBSTNO(Text013, Currency.Description);
                END;

                IF StatementStyle = StatementStyle::Balance THEN BEGIN
                    SETRANGE("Date Filter", 0D, FromDate - 1);
                    CALCFIELDS("Net Change (LCY)");
                    IF "Currency Code" = '' THEN
                        BalanceToPrint := "Net Change (LCY)"
                    ELSE
                        BalanceToPrint := CurrExchRate.ExchangeAmtFCYToFCY(FromDate - 1, '', "Currency Code", "Net Change (LCY)");
                    SETRANGE("Date Filter");
                END ELSE
                    BalanceToPrint := 0;

                /* Update Statement Number so it can be printed on the document. However,
                  defer actually updating the customer file until the statement is complete. */
                IF "Last Statement No." >= 9999 THEN
                    "Last Statement No." := 1
                ELSE
                    "Last Statement No." := "Last Statement No." + 1;
                //CurrReport.PAGENO := 1;

                FormatAddress.Customer(CustomerAddress, Customer);
                StatementComplete := FALSE;

                IF LogInteraction THEN
                    IF NOT CurrReport.PREVIEW THEN
                        SegManagement.LogDocument(
                          7, FORMAT(Customer."Last Statement No."), 0, 0, DATABASE::Customer, "No.", "Salesperson Code",
                          '', Text012 + FORMAT(Customer."Last Statement No."), '');

            end;

            trigger OnPreDataItem()
            begin
                /* remove user-entered date filter; info now in FromDate & ToDate */
                SETRANGE("Date Filter");

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
                    field(AllHavingEntries; AllHavingEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print All with Entries';
                        ToolTip = 'Specifies if an account statement is included for all customers with entries by the end of the statement period, as specified in the date filter.';
                    }
                    field(AllHavingBalance; AllHavingBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print All with Balance';
                        ToolTip = 'Specifies if an account statement is included for all customers with a balance by the end of the statement period, as specified in the date filter.';
                    }
                    field(UpdateNumbers; UpdateNumbers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Update Statement No.';
                        ToolTip = 'Specifies if you want to update the Last Statement No. field on each customer card after it prints the customer''s statement. Do not select this check box if you are not using statement numbers, if you are just viewing the statements, or if you are printing statements which will not be sent to the customer.';
                    }
                    field(PrintCompany; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(StatementStyle; StatementStyle)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statement Style';
                        OptionCaption = 'Open Item,Balance';
                        ToolTip = 'Specifies how to print the statement. Balance: Prints balance forward statements that list all entries made during the statement period that you specify in the date filter. Open Item: Prints open item statements that list all entries that are still open as of the date that you specify in the date filter.';
                    }
                    field(AgingMethod; AgingMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged By';
                        OptionCaption = 'None,Due Date,Trans Date,Doc Date';
                        ToolTip = 'Specifies how aging is calculated. Due Date: Aging is calculated by the number of days that the transaction is overdue. Trans Date: Aging is calculated by the number of days since the transaction posting date. Document Date: Aging is calculated by the number of days since the document date.';
                    }
                    field(PeriodCalculation; PeriodCalculation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Length of Aging Periods';
                        ToolTip = 'Specifies the length of each of the aging periods. For example, enter 30D to base aging on 30-day intervals.';

                        trigger OnValidate()
                        begin
                            IF (AgingMethod <> AgingMethod::None) AND (FORMAT(PeriodCalculation) = '') THEN
                                ERROR(Text014);
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                }
                /*The BC Customer Statement report need to have the following output options in the request page section.*/
                group("Output Options")
                {
                    Caption = 'Output Options';
                    field(ReportOutput; SupportedOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Output';
                        OptionCaption = 'Print,Preview,Word,PDF,Email,XML - RDLC layouts only', Comment = 'Each item is a verb/action - to print, to preview, to export to Word, export to PDF, send email, export to XML for RDLC layouts only';
                        ToolTip = 'Specifies the output of the scheduled report, such as PDF or Word.';

                        trigger OnValidate()
                        var
                            CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                        begin
                            ShowPrintIfEmailIsMissing := (SupportedOutputMethod = SupportedOutputMethod::Email);

                            case SupportedOutputMethod of
                                SupportedOutputMethod::Print:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption();
                                SupportedOutputMethod::Preview:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption();
                                SupportedOutputMethod::Word:
                                    //ChosenOutputMethod := CustomLayoutReporting.GetWordOption();
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption();
                                SupportedOutputMethod::PDF:
                                    //ChosenOutputMethod := CustomLayoutReporting.GetPDFOption();
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption();
                                SupportedOutputMethod::Email:
                                    //ChosenOutputMethod := CustomLayoutReporting.GetEmailOption();
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption();
                                SupportedOutputMethod::XML:
                                    //ChosenOutputMethod := CustomLayoutReporting.GetXMLOption();
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption();
                            end;
                        end;
                    }
                    field(ChosenOutput; ChosenOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Chosen Output';
                        ToolTip = 'Specifies how to output the report, such as Print or Excel.';
                        Visible = false;
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintIfEmailIsMissing;
                        field(PrintMissingAddresses; PrintIfEmailIsMissing)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Print Although Email is Missing or Invalid';
                            ToolTip = 'Specifies if you want to print also the statements for customers that have not been set up with a send-to email address or defined send-to email address is invalid.';
                        }
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
            IF (NOT AllHavingEntries) AND (NOT AllHavingBalance) THEN
                AllHavingBalance := TRUE;

            //LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Stmnt.") <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF (NOT AllHavingEntries) AND (NOT AllHavingBalance) THEN
            ERROR(Text000);
        IF UpdateNumbers AND CurrReport.PREVIEW THEN
            ERROR(Text001);
        FromDate := Customer.GETRANGEMIN("Date Filter");
        ToDate := Customer.GETRANGEMAX("Date Filter");

        IF (StatementStyle = StatementStyle::Balance) AND (FromDate = ToDate) THEN
            ERROR(Text002 + ' '
              + Text003);

        IF (AgingMethod <> AgingMethod::None) AND (FORMAT(PeriodCalculation) = '') THEN
            ERROR(Text004);

        IF FORMAT(PeriodCalculation) <> '' THEN
            EVALUATE(PeriodCalculation, '-' + FORMAT(PeriodCalculation));

        IF PrintCompany THEN BEGIN
            CompanyInformation.GET;
            FormatAddress.Company(CompanyAddress, CompanyInformation);
        END ELSE
            CLEAR(CompanyAddress);

        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                CompanyInformation.CALCFIELDS(Picture);
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
    end;

    var
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        //Language: Record "8";
        cuLanguage: Codeunit Language;
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempAppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        FormatAddress: Codeunit "Format Address";
        StatementStyle: Option "Open Item",Balance;
        AllHavingEntries: Boolean;
        AllHavingBalance: Boolean;
        UpdateNumbers: Boolean;
        AgingMethod: Option "None","Due Date","Trans Date","Doc Date";
        PrintCompany: Boolean;
        PeriodCalculation: DateFormula;
        Print: Boolean;
        FromDate: Date;
        ToDate: Date;
        AgingDate: Date;
        LogInteraction: Boolean;
        CustomerAddress: array[8] of Text[50];
        CompanyAddress: array[8] of Text[50];
        BalanceToPrint: Decimal;
        DebitBalance: Decimal;
        CreditBalance: Decimal;
        AgingHead: array[4] of Text[20];
        AmountDue: array[4] of Decimal;
        AgingDaysText: Text[20];
        PeriodEndingDate: array[5] of Date;
        StatementComplete: Boolean;
        i: Integer;
        CurrencyDesc: Text[80];
        SegManagement: Codeunit SegManagement;
        Text000: Label 'You must select either All with Entries or All with Balance.';
        Text001: Label 'You must print statements if you want to update statement numbers.';
        Text002: Label 'You must enter a range of dates (not just one date) in the';
        Text003: Label 'Date Filter if you want to print Balance Forward Statements.';
        Text004: Label 'You must enter a Length of Aging Periods if you select aging.';
        Text006: Label 'Current';
        Text007: Label 'Days overdue:';
        Text008: Label 'Up To';
        Text009: Label ' Days';
        Text010: Label 'Days old:';
        Text011: Label 'Over';
        Text012: Label 'Statement ';
        Text013: Label '(All amounts are in %1)';
        TempAmountDue: array[4] of Decimal;
        AgingMethod_Int: Integer;
        StatementStyle_Int: Integer;
        //[InDataSet]
        LogInteractionEnable: Boolean;
        Text014: Label 'You must enter a Length of Aging Periods if you select aging.';
        STATEMENTCaptionLbl: Label 'STATEMENT';
        Statement_Date_CaptionLbl: Label 'Statement Date:';
        Account_Number_CaptionLbl: Label 'Account Number:';
        Page_CaptionLbl: Label 'Page:';
        RETURN_THIS_PORTION_OF_STATEMENT_WITH_YOUR_PAYMENT_CaptionLbl: Label 'RETURN THIS PORTION OF STATEMENT WITH YOUR PAYMENT.';
        Amount_RemittedCaptionLbl: Label 'Amount Remitted';
        TempCustLedgEntry__Document_No__CaptionLbl: Label 'Document';
        TempCustLedgEntry__Posting_Date_CaptionLbl: Label 'Date';
        GetTermsString_TempCustLedgEntry_CaptionLbl: Label 'Terms';
        TempCustLedgEntry__Document_Type_CaptionLbl: Label 'Code';
        TempCustLedgEntry__Remaining_Amount_CaptionLbl: Label 'Debits';
        TempCustLedgEntry__Remaining_Amount__Control47CaptionLbl: Label 'Credits';
        BalanceToPrint_Control48CaptionLbl: Label 'Balance';
        Statement_BalanceCaptionLbl: Label 'Statement Balance';
        Statement_BalanceCaption_Control25Lbl: Label 'Statement Balance';
        Statement_Aging_CaptionLbl: Label 'Statement Aging:';
        Aged_amounts_CaptionLbl: Label 'Aged amounts:';
        Balance_ForwardCaptionLbl: Label 'Balance Forward';
        Bal_FwdCaptionLbl: Label 'Bal Fwd';
        SupportedOutputMethod: Option Print,Preview,Word,PDF,Email,XML;
        ChosenOutputMethod: Integer;
        PrintIfEmailIsMissing: Boolean;
        ShowPrintIfEmailIsMissing: Boolean;

    procedure GetTermsString(var CustLedgerEntry: Record "Cust. Ledger Entry"): Text[250]
    var
        InvoiceHeader: Record "Sales Invoice Header";
        PaymentTerms: Record "Payment Terms";
    begin
        IF (CustLedgerEntry."Document No." = '') OR (CustLedgerEntry."Document Type" <> CustLedgerEntry."Document Type"::Invoice) THEN
            EXIT('');

        IF InvoiceHeader.READPERMISSION THEN
            IF InvoiceHeader.GET(CustLedgerEntry."Document No.") THEN BEGIN
                IF PaymentTerms.GET(InvoiceHeader."Payment Terms Code") THEN BEGIN
                    IF PaymentTerms.Description <> '' THEN
                        EXIT(PaymentTerms.Description);

                    EXIT(InvoiceHeader."Payment Terms Code");
                END;
                EXIT(InvoiceHeader."Payment Terms Code");
            END;

        IF Customer."Payment Terms Code" <> '' THEN BEGIN
            IF PaymentTerms.GET(Customer."Payment Terms Code") THEN BEGIN
                IF PaymentTerms.Description <> '' THEN
                    EXIT(PaymentTerms.Description);

                EXIT(Customer."Payment Terms Code");
            END;
            EXIT(Customer."Payment Terms Code");
        END;

        EXIT('');
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        IF TempCustLedgEntry.GET(CustLedgEntry."Entry No.") THEN
            EXIT;
        TempCustLedgEntry := CustLedgEntry;
        TempCustLedgEntry.INSERT;
    end;

    procedure GetAppliedCustEntries(var AppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary; CustLedgEntry: Record "Cust. Ledger Entry"; UseLCY: Boolean)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PmtDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        PmtCustLedgEntry: Record "Cust. Ledger Entry";
        ClosingCustLedgEntry: Record "Cust. Ledger Entry";
        AmountToApply: Decimal;
        cu: report 1316;
    begin
        // Temporary Table, AppliedCustLedgEntry, to be filled in with everything that CustLedgEntry applied to.
        // Note that within AppliedCustLedgEntry, the "Amount to Apply" field will be filled in with the Amount Applied.
        // IF UseLCY is TRUE, Amount Applied will be in LCY, else it will be in the application currency
        AppliedCustLedgEntry.RESET;
        AppliedCustLedgEntry.DELETEALL;

        DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
        DtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
        DtldCustLedgEntry.SETRANGE(Unapplied, FALSE);
        IF DtldCustLedgEntry.FIND('-') THEN
            REPEAT
                PmtDtldCustLedgEntry.SETFILTER("Cust. Ledger Entry No.", '<>%1', CustLedgEntry."Entry No.");
                PmtDtldCustLedgEntry.SETRANGE("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
                PmtDtldCustLedgEntry.SETRANGE("Transaction No.", DtldCustLedgEntry."Transaction No.");
                PmtDtldCustLedgEntry.SETRANGE("Application No.", DtldCustLedgEntry."Application No.");
                PmtDtldCustLedgEntry.SETRANGE("Customer No.", DtldCustLedgEntry."Customer No.");
                PmtDtldCustLedgEntry.FINDSET;
                REPEAT
                    IF UseLCY THEN
                        AmountToApply := -PmtDtldCustLedgEntry."Amount (LCY)"
                    ELSE
                        AmountToApply := -PmtDtldCustLedgEntry.Amount;
                    PmtCustLedgEntry.GET(PmtDtldCustLedgEntry."Cust. Ledger Entry No.");
                    AppliedCustLedgEntry := PmtCustLedgEntry;
                    IF AppliedCustLedgEntry.FIND THEN BEGIN
                        AppliedCustLedgEntry."Amount to Apply" += AmountToApply;
                        AppliedCustLedgEntry.MODIFY;
                    END ELSE BEGIN
                        AppliedCustLedgEntry := PmtCustLedgEntry;
                        AppliedCustLedgEntry."Amount to Apply" := AmountToApply;
                        IF CustLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
                            ClosingCustLedgEntry.GET(PmtDtldCustLedgEntry."Cust. Ledger Entry No.");
                            IF ClosingCustLedgEntry."Closed by Entry No." <> AppliedCustLedgEntry."Entry No." THEN
                                AppliedCustLedgEntry."Pmt. Disc. Given (LCY)" := 0;
                        END;
                        AppliedCustLedgEntry.INSERT;
                    END;
                UNTIL PmtDtldCustLedgEntry.NEXT = 0;
            UNTIL DtldCustLedgEntry.NEXT = 0;
    end;
}

