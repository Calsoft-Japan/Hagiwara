report 50002 "Check (Stub/Stub/Check) US"
{
    // HG10.00.02 NJ 01/06/2017 - Hagirawa US Upgrade

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Check (StubStubCheck) US.rdlc';

    Caption = 'Check (Stub/Stub/Check)';
    Permissions = TableData 270 = m;
    ApplicationArea = All;
    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                IF CurrReport.PREVIEW THEN
                    ERROR(Text000);

                IF UseCheckNo = '' THEN
                    ERROR(Text001);

                IF INCSTR(UseCheckNo) = '' THEN
                    ERROR(USText004);

                IF TestPrint THEN
                    CurrReport.BREAK;

                IF NOT ReprintChecks THEN
                    CurrReport.BREAK;

                IF (GETFILTER("Line No.") <> '') OR (GETFILTER("Document No.") <> '') THEN
                    ERROR(
                      Text002, FIELDCAPTION("Line No."), FIELDCAPTION("Document No."));
                SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed", TRUE);
            end;
        }
        dataitem(TestGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");

            trigger OnAfterGetRecord()
            begin
                IF Amount = 0 THEN
                    CurrReport.SKIP;

                TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                IF "Bal. Account No." <> BankAcc2."No." THEN
                    CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            begin
                IF TestPrint THEN BEGIN
                    BankAcc2.GET(BankAcc2."No.");
                    BankCurrencyCode := BankAcc2."Currency Code";
                END;

                IF TestPrint THEN
                    CurrReport.BREAK;
                BankAcc2.GET(BankAcc2."No.");
                BankCurrencyCode := BankAcc2."Currency Code";

                IF BankAcc2."Country/Region Code" <> 'CA' THEN
                    CurrReport.BREAK;
                BankAcc2.TESTFIELD(Blocked, FALSE);
                COPY(VoidGenJnlLine);
                BankAcc2.GET(BankAcc2."No.");
                BankAcc2.TESTFIELD(Blocked, FALSE);
                SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed", FALSE);
            end;
        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            column(GenJnlLine_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(GenJnlLine_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(GenJnlLine_Line_No_; "Line No.")
            {
            }
            dataitem(CheckPages; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(CheckToAddr_1_; CheckToAddr[1])
                {
                }
                column(CheckDateText; CheckDateText)
                {
                }
                column(CheckNoText; CheckNoText)
                {
                }
                column(PageNo; PageNo)
                {
                }
                column(CheckPages_Number; Number)
                {
                }
                column(CheckNoTextCaption; CheckNoTextCaptionLbl)
                {
                }
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 15;
                    column(PreprintedStub; PreprintedStub)
                    {
                    }
                    column(LineAmount; LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineDiscount; LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount___LineDiscount; LineAmount + LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(DocNo; DocNo)
                    {
                    }
                    column(DocDate; DocDate)
                    {
                    }
                    column(PostingDesc; PostingDesc)
                    {
                    }
                    column(PrintSettledLoop_Number; Number)
                    {
                    }
                    column(LineAmountCaption; LineAmountCaptionLbl)
                    {
                    }
                    column(LineDiscountCaption; LineDiscountCaptionLbl)
                    {
                    }
                    column(AmountCaption; AmountCaptionLbl)
                    {
                    }
                    column(DocNoCaption; DocNoCaptionLbl)
                    {
                    }
                    column(DocDateCaption; DocDateCaptionLbl)
                    {
                    }
                    column(Posting_DescriptionCaption; Posting_DescriptionCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT TestPrint THEN BEGIN
                            IF FoundLast THEN BEGIN
                                IF RemainingAmount <> 0 THEN BEGIN
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    CurrentLineAmount := LineAmount2;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;

                                    PostingDesc := CheckToAddr[1];
                                END ELSE
                                    CurrReport.BREAK;
                            END ELSE
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustLedgEntry.RESET;
                                                        CustLedgEntry.SETCURRENTKEY("Document No.");
                                                        CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                        CustLedgEntry.FIND('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendLedgEntry.RESET;
                                                        VendLedgEntry.SETCURRENTKEY("Document No.");
                                                        VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                        VendLedgEntry.FIND('-');
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                            FoundLast := TRUE;
                                        END;
                                    ApplyMethod::OneLineID:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            CustLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT CustLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.NEXT = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            VendLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT VendLedgEntry.FIND('-');
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        BEGIN
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;
                                            IF GenJnlLine2."Applies-to ID" <> '' THEN
                                                ERROR(
                                                  Text016 +
                                                  Text017);
                                            GenJnlLine2.TESTFIELD("Check Printed", FALSE);
                                            GenJnlLine2.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");

                                            IF GenJnlLine2."Applies-to Doc. No." = '' THEN BEGIN
                                                DocNo := '';
                                                ExtDocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                                PostingDesc := GenJnlLine2.Description;
                                            END ELSE
                                                CASE BalancingType OF
                                                    BalancingType::"G/L Account":
                                                        BEGIN
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                            PostingDesc := GenJnlLine2.Description;
                                                        END;
                                                    BalancingType::Customer:
                                                        BEGIN
                                                            CustLedgEntry.RESET;
                                                            CustLedgEntry.SETCURRENTKEY("Document No.");
                                                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                            CustLedgEntry.FIND('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::Vendor:
                                                        BEGIN
                                                            VendLedgEntry.RESET;
                                                            VendLedgEntry.SETCURRENTKEY("Document No.");
                                                            VendLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                            VendLedgEntry.FIND('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::"Bank Account":
                                                        BEGIN
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                            PostingDesc := GenJnlLine2.Description;
                                                        END;
                                                END;

                                            FoundLast := GenJnlLine2.NEXT = 0;
                                        END;
                                END;

                            TotalLineAmount := TotalLineAmount + CurrentLineAmount;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        END ELSE BEGIN
                            IF FoundLast THEN
                                CurrReport.BREAK;
                            FoundLast := TRUE;
                            DocNo := Text010;
                            ExtDocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                            PostingDesc := '';
                        END;

                        IF DocNo = '' THEN
                            CurrencyCode2 := GenJnlLine."Currency Code";

                        Stub2LineNo := Stub2LineNo + 1;
                        Stub2DocNo[Stub2LineNo] := DocNo;
                        Stub2DocDate[Stub2LineNo] := DocDate;
                        Stub2LineAmount[Stub2LineNo] := LineAmount;
                        Stub2LineDiscount[Stub2LineNo] := LineDiscount;
                        Stub2PostingDescription[Stub2LineNo] := PostingDesc;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT TestPrint THEN
                            IF FirstPage THEN BEGIN
                                FoundLast := TRUE;
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := FALSE;
                                    ApplyMethod::OneLineID:
                                        CASE BalancingType OF
                                            BalancingType::Customer:
                                                BEGIN
                                                    CustLedgEntry.RESET;
                                                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                                                    CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                    CustLedgEntry.SETRANGE(Open, TRUE);
                                                    CustLedgEntry.SETRANGE(Positive, TRUE);
                                                    CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT CustLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        CustLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT CustLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                            BalancingType::Vendor:
                                                BEGIN
                                                    VendLedgEntry.RESET;
                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SETRANGE(Open, TRUE);
                                                    VendLedgEntry.SETRANGE(Positive, TRUE);
                                                    VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT VendLedgEntry.FIND('-');
                                                    IF FoundLast THEN BEGIN
                                                        VendLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT VendLedgEntry.FIND('-');
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := FALSE;
                                END;
                            END ELSE
                                FoundLast := FALSE;

                        IF PreprintedStub THEN BEGIN
                            TotalText := '';
                        END ELSE BEGIN
                            TotalText := Text019;
                            Stub2DocNoHeader := USText011;
                            Stub2DocDateHeader := USText012;
                            Stub2AmountHeader := USText013;
                            Stub2DiscountHeader := USText014;
                            Stub2NetAmountHeader := USText015;
                            Stub2PostingDescHeader := USText017;
                        END;
                        GLSetup.GET;
                        PageNo := PageNo + 1;
                    end;
                }
                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(PrnChkCheckToAddr_CheckStyle__CA_5_; PrnChkCheckToAddr[CheckStyle::CA, 5])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_4_; PrnChkCheckToAddr[CheckStyle::CA, 4])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_3_; PrnChkCheckToAddr[CheckStyle::CA, 3])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_2_; PrnChkCheckToAddr[CheckStyle::CA, 2])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__CA_1_; PrnChkCheckToAddr[CheckStyle::CA, 1])
                    {
                    }
                    column(PrnChkCheckAmountText_CheckStyle__US_; PrnChkCheckAmountText[CheckStyle::US])
                    {
                    }
                    column(PrnChkCheckDateText_CheckStyle__US_; PrnChkCheckDateText[CheckStyle::US])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__US_2_; PrnChkDescriptionLine[CheckStyle::US, 2])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__US_1_; PrnChkDescriptionLine[CheckStyle::US, 1])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_1_; PrnChkCheckToAddr[CheckStyle::US, 1])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_2_; PrnChkCheckToAddr[CheckStyle::US, 2])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_4_; PrnChkCheckToAddr[CheckStyle::US, 4])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_3_; PrnChkCheckToAddr[CheckStyle::US, 3])
                    {
                    }
                    column(PrnChkCheckToAddr_CheckStyle__US_5_; PrnChkCheckToAddr[CheckStyle::US, 5])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_4_; PrnChkCompanyAddr[CheckStyle::US, 4])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_6_; PrnChkCompanyAddr[CheckStyle::US, 6])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_5_; PrnChkCompanyAddr[CheckStyle::US, 5])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_3_; PrnChkCompanyAddr[CheckStyle::US, 3])
                    {
                    }
                    column(PrnChkCheckNoText_CheckStyle__US_; PrnChkCheckNoText[CheckStyle::US])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_2_; PrnChkCompanyAddr[CheckStyle::US, 2])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__US_1_; PrnChkCompanyAddr[CheckStyle::US, 1])
                    {
                    }
                    column(TotalLineAmount; TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(PrnChkVoidText_CheckStyle__US_; PrnChkVoidText[CheckStyle::US])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_1_; PrnChkCompanyAddr[CheckStyle::CA, 1])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_2_; PrnChkCompanyAddr[CheckStyle::CA, 2])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_3_; PrnChkCompanyAddr[CheckStyle::CA, 3])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_4_; PrnChkCompanyAddr[CheckStyle::CA, 4])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_5_; PrnChkCompanyAddr[CheckStyle::CA, 5])
                    {
                    }
                    column(PrnChkCompanyAddr_CheckStyle__CA_6_; PrnChkCompanyAddr[CheckStyle::CA, 6])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__CA_1_; PrnChkDescriptionLine[CheckStyle::CA, 1])
                    {
                    }
                    column(PrnChkDescriptionLine_CheckStyle__CA_2_; PrnChkDescriptionLine[CheckStyle::CA, 2])
                    {
                    }
                    column(PrnChkCheckDateText_CheckStyle__CA_; PrnChkCheckDateText[CheckStyle::CA])
                    {
                    }
                    column(PrnChkDateIndicator_CheckStyle__CA_; PrnChkDateIndicator[CheckStyle::CA])
                    {
                    }
                    column(PrnChkCheckAmountText_CheckStyle__CA_; PrnChkCheckAmountText[CheckStyle::CA])
                    {
                    }
                    column(PrnChkVoidText_CheckStyle__CA_; PrnChkVoidText[CheckStyle::CA])
                    {
                    }
                    column(PrnChkCurrencyCode_CheckStyle__CA_; PrnChkCurrencyCode[CheckStyle::CA])
                    {
                    }
                    column(PrnChkCurrencyCode_CheckStyle__US_; PrnChkCurrencyCode[CheckStyle::US])
                    {
                    }
                    column(CheckNoText_Control1480000; CheckNoText)
                    {
                    }
                    column(CheckDateText_Control1480021; CheckDateText)
                    {
                    }
                    column(CheckToAddr_1__Control1480022; CheckToAddr[1])
                    {
                    }
                    column(Stub2DocNoHeader; Stub2DocNoHeader)
                    {
                    }
                    column(Stub2DocDateHeader; Stub2DocDateHeader)
                    {
                    }
                    column(Stub2AmountHeader; Stub2AmountHeader)
                    {
                    }
                    column(Stub2DiscountHeader; Stub2DiscountHeader)
                    {
                    }
                    column(Stub2NetAmountHeader; Stub2NetAmountHeader)
                    {
                    }
                    column(Stub2LineAmount_1_; Stub2LineAmount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_1_; Stub2LineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_1____Stub2LineDiscount_1_; Stub2LineAmount[1] + Stub2LineDiscount[1])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_1_; Stub2DocDate[1])
                    {
                    }
                    column(Stub2DocNo_1_; Stub2DocNo[1])
                    {
                    }
                    column(Stub2LineAmount_2_; Stub2LineAmount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_2_; Stub2LineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_2____Stub2LineDiscount_2_; Stub2LineAmount[2] + Stub2LineDiscount[2])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_2_; Stub2DocDate[2])
                    {
                    }
                    column(Stub2DocNo_2_; Stub2DocNo[2])
                    {
                    }
                    column(Stub2LineAmount_3_; Stub2LineAmount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_3_; Stub2LineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_3____Stub2LineDiscount_3_; Stub2LineAmount[3] + Stub2LineDiscount[3])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_3_; Stub2DocDate[3])
                    {
                    }
                    column(Stub2DocNo_3_; Stub2DocNo[3])
                    {
                    }
                    column(Stub2LineAmount_4_; Stub2LineAmount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_4_; Stub2LineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_4____Stub2LineDiscount_4_; Stub2LineAmount[4] + Stub2LineDiscount[4])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_4_; Stub2DocDate[4])
                    {
                    }
                    column(Stub2DocNo_4_; Stub2DocNo[4])
                    {
                    }
                    column(Stub2LineAmount_5_; Stub2LineAmount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_5_; Stub2LineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_5____Stub2LineDiscount_5_; Stub2LineAmount[5] + Stub2LineDiscount[5])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_5_; Stub2DocDate[5])
                    {
                    }
                    column(Stub2DocNo_5_; Stub2DocNo[5])
                    {
                    }
                    column(Stub2LineAmount_6_; Stub2LineAmount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_6_; Stub2LineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_6____Stub2LineDiscount_6_; Stub2LineAmount[6] + Stub2LineDiscount[6])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_6_; Stub2DocDate[6])
                    {
                    }
                    column(Stub2DocNo_6_; Stub2DocNo[6])
                    {
                    }
                    column(Stub2LineAmount_7_; Stub2LineAmount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_7_; Stub2LineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_7____Stub2LineDiscount_7_; Stub2LineAmount[7] + Stub2LineDiscount[7])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_7_; Stub2DocDate[7])
                    {
                    }
                    column(Stub2DocNo_7_; Stub2DocNo[7])
                    {
                    }
                    column(Stub2LineAmount_8_; Stub2LineAmount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_8_; Stub2LineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_8____Stub2LineDiscount_8_; Stub2LineAmount[8] + Stub2LineDiscount[8])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_8_; Stub2DocDate[8])
                    {
                    }
                    column(Stub2DocNo_8_; Stub2DocNo[8])
                    {
                    }
                    column(Stub2LineAmount_9_; Stub2LineAmount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_9_; Stub2LineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_9____Stub2LineDiscount_9_; Stub2LineAmount[9] + Stub2LineDiscount[9])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_9_; Stub2DocDate[9])
                    {
                    }
                    column(Stub2DocNo_9_; Stub2DocNo[9])
                    {
                    }
                    column(Stub2LineAmount_10_; Stub2LineAmount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_10_; Stub2LineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_10____Stub2LineDiscount_10_; Stub2LineAmount[10] + Stub2LineDiscount[10])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_10_; Stub2DocDate[10])
                    {
                    }
                    column(Stub2DocNo_10_; Stub2DocNo[10])
                    {
                    }
                    column(Stub2LineAmount_11_; Stub2LineAmount[11])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_11_; Stub2LineDiscount[11])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_11____Stub2LineDiscount_11_; Stub2LineAmount[11] + Stub2LineDiscount[11])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_11_; Stub2DocDate[11])
                    {
                    }
                    column(Stub2DocNo_11_; Stub2DocNo[11])
                    {
                    }
                    column(Stub2LineAmount_12_; Stub2LineAmount[12])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_12_; Stub2LineDiscount[12])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_12____Stub2LineDiscount_12_; Stub2LineAmount[12] + Stub2LineDiscount[12])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_12_; Stub2DocDate[12])
                    {
                    }
                    column(Stub2DocNo_12_; Stub2DocNo[12])
                    {
                    }
                    column(Stub2LineAmount_13_; Stub2LineAmount[13])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_13_; Stub2LineDiscount[13])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_13____Stub2LineDiscount_13_; Stub2LineAmount[13] + Stub2LineDiscount[13])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_13_; Stub2DocDate[13])
                    {
                    }
                    column(Stub2DocNo_13_; Stub2DocNo[13])
                    {
                    }
                    column(Stub2LineAmount_14_; Stub2LineAmount[14])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_14_; Stub2LineDiscount[14])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_14____Stub2LineDiscount_14_; Stub2LineAmount[14] + Stub2LineDiscount[14])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_14_; Stub2DocDate[14])
                    {
                    }
                    column(Stub2DocNo_14_; Stub2DocNo[14])
                    {
                    }
                    column(Stub2LineAmount_15_; Stub2LineAmount[15])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineDiscount_15_; Stub2LineDiscount[15])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2LineAmount_15____Stub2LineDiscount_15_; Stub2LineAmount[15] + Stub2LineDiscount[15])
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Stub2DocDate_15_; Stub2DocDate[15])
                    {
                    }
                    column(Stub2DocNo_15_; Stub2DocNo[15])
                    {
                    }
                    column(TotalLineAmount_Control1480082; TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText_Control1480083; TotalText)
                    {
                    }
                    column(Stub2PostingDescHeader; Stub2PostingDescHeader)
                    {
                    }
                    column(Stub2PostingDescription_1_; Stub2PostingDescription[1])
                    {
                    }
                    column(Stub2PostingDescription_2_; Stub2PostingDescription[2])
                    {
                    }
                    column(Stub2PostingDescription_4_; Stub2PostingDescription[4])
                    {
                    }
                    column(Stub2PostingDescription_3_; Stub2PostingDescription[3])
                    {
                    }
                    column(Stub2PostingDescription_8_; Stub2PostingDescription[8])
                    {
                    }
                    column(Stub2PostingDescription_7_; Stub2PostingDescription[7])
                    {
                    }
                    column(Stub2PostingDescription_6_; Stub2PostingDescription[6])
                    {
                    }
                    column(Stub2PostingDescription_5_; Stub2PostingDescription[5])
                    {
                    }
                    column(Stub2PostingDescription_10_; Stub2PostingDescription[10])
                    {
                    }
                    column(Stub2PostingDescription_9_; Stub2PostingDescription[9])
                    {
                    }
                    column(CheckToAddr_5_; CheckToAddr[5])
                    {
                    }
                    column(CheckToAddr_4_; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr_3_; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr_2_; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr_01_; CheckToAddr[1])
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    column(BankCurrencyCode; BankCurrencyCode)
                    {
                    }
                    column(DollarSignBefore_CheckAmountText_DollarSignAfter; DollarSignBefore + CheckAmountText + DollarSignAfter)
                    {
                    }
                    column(DescriptionLine_1__; DescriptionLine[1])
                    {
                    }
                    column(DescriptionLine_2__; DescriptionLine[2])
                    {
                    }
                    column(DateIndicator; DateIndicator)
                    {
                    }
                    column(CheckDateText_Control1020014; CheckDateText)
                    {
                    }
                    column(CheckNoText_Control1020015; CheckNoText)
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CheckStyleIndex; CheckStyleIndex)
                    {
                    }
                    column(PageNo_Control1020024; PageNo)
                    {
                    }
                    column(PrintCheck_Number; Number)
                    {
                    }
                    column(CheckNoText_Control1480000Caption; CheckNoText_Control1480000CaptionLbl)
                    {
                    }
                    column(AccountNoCaption; AccountNoCaptionLbl)
                    {
                    }
                    column(OurAccountNo; Vend."Our Account No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        CurrencySymbol: Code[5];
                    begin
                        IF NOT TestPrint THEN BEGIN
                            CheckLedgEntry.INIT;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document Type" := GenJnlLine."Document Type";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := CheckToAddr[1];
                            CheckLedgEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type" := BalancingType;
                            CheckLedgEntry."Bal. Account No." := BalancingNo;
                            IF FoundLast THEN BEGIN
                                IF TotalLineAmount < 0 THEN
                                    ERROR(
                                      Text020,
                                      UseCheckNo, TotalLineAmount);
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                CheckLedgEntry.Amount := TotalLineAmount;
                            END ELSE BEGIN
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                CheckLedgEntry.Amount := 0;
                            END;
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, GenJnlLine.RECORDID);

                            IF FoundLast THEN BEGIN
                                CheckAmountText := GetCheckAmountText(BankAcc2."Currency Code", CurrencySymbol, CheckLedgEntry.Amount);

                                IF CheckLanguage = 3084 THEN BEGIN
                                    // French
                                    DollarSignBefore := '';
                                    DollarSignAfter := CurrencySymbol;
                                END ELSE BEGIN
                                    DollarSignBefore := CurrencySymbol;
                                    DollarSignAfter := ' ';
                                END;
                                IF NOT FormatNoText(DescriptionLine, CheckLedgEntry.Amount, CheckLanguage, BankAcc2."Currency Code") THEN
                                    ERROR(DescriptionLine[1]);
                                VoidText := '';
                            END ELSE BEGIN
                                CLEAR(CheckAmountText);
                                CLEAR(DescriptionLine);
                                DescriptionLine[1] := Text021;
                                DescriptionLine[2] := DescriptionLine[1];
                                VoidText := Text022;
                            END;
                        END
                        ELSE BEGIN
                            CheckLedgEntry.INIT;
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := Text023;
                            CheckLedgEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type"::"Computer Check";
                            CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, GenJnlLine.RECORDID);

                            CheckAmountText := Text024;
                            DescriptionLine[1] := Text025;
                            DescriptionLine[2] := DescriptionLine[1];
                            VoidText := Text022;
                        END;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := FALSE;

                        CLEAR(PrnChkCompanyAddr);
                        CLEAR(PrnChkCheckToAddr);
                        CLEAR(PrnChkCheckNoText);
                        CLEAR(PrnChkCheckDateText);
                        CLEAR(PrnChkDescriptionLine);
                        CLEAR(PrnChkVoidText);
                        CLEAR(PrnChkDateIndicator);
                        CLEAR(PrnChkCurrencyCode);
                        CLEAR(PrnChkCheckAmountText);
                        COPYARRAY(PrnChkCompanyAddr[CheckStyle], CompanyAddr, 1);
                        COPYARRAY(PrnChkCheckToAddr[CheckStyle], CheckToAddr, 1);
                        PrnChkCheckNoText[CheckStyle] := CheckNoText;
                        PrnChkCheckDateText[CheckStyle] := CheckDateText;
                        COPYARRAY(PrnChkDescriptionLine[CheckStyle], DescriptionLine, 1);
                        PrnChkVoidText[CheckStyle] := VoidText;
                        PrnChkDateIndicator[CheckStyle] := DateIndicator;
                        PrnChkCurrencyCode[CheckStyle] := BankAcc2."Currency Code";
                        StartingLen := STRLEN(CheckAmountText);
                        IF CheckStyle = CheckStyle::US THEN
                            ControlLen := 27
                        ELSE
                            ControlLen := 29;
                        CheckAmountText := CheckAmountText + DollarSignBefore + DollarSignAfter;
                        Index := 0;
                        IF CheckAmountText = Text024 THEN BEGIN
                            IF STRLEN(CheckAmountText) < (ControlLen - 12) THEN BEGIN
                                REPEAT
                                    Index := Index + 1;
                                    CheckAmountText := INSSTR(CheckAmountText, '*', STRLEN(CheckAmountText) + 1);
                                UNTIL (Index = ControlLen) OR (STRLEN(CheckAmountText) >= (ControlLen - 12))
                            END;
                        END ELSE
                            IF STRLEN(CheckAmountText) < (ControlLen - 11) THEN BEGIN
                                REPEAT
                                    Index := Index + 1;
                                    CheckAmountText := INSSTR(CheckAmountText, '*', STRLEN(CheckAmountText) + 1);
                                UNTIL (Index = ControlLen) OR (STRLEN(CheckAmountText) >= (ControlLen - 11))
                            END;
                        CheckAmountText :=
                          DELSTR(CheckAmountText, StartingLen + 1, STRLEN(DollarSignBefore + DollarSignAfter));
                        NewLen := STRLEN(CheckAmountText);
                        IF NewLen <> StartingLen THEN
                            CheckAmountText :=
                              COPYSTR(CheckAmountText, StartingLen + 1) +
                              COPYSTR(CheckAmountText, 1, StartingLen);
                        PrnChkCheckAmountText[CheckStyle] :=
                          DollarSignBefore + CheckAmountText + DollarSignAfter;

                        IF CheckStyle = CheckStyle::CA THEN
                            CheckStyleIndex := 0
                        ELSE
                            CheckStyleIndex := 1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF FoundLast THEN
                        CurrReport.BREAK;

                    UseCheckNo := INCSTR(UseCheckNo);
                    IF NOT TestPrint THEN
                        CheckNoText := UseCheckNo
                    ELSE
                        CheckNoText := Text011;

                    Stub2LineNo := 0;
                    CLEAR(Stub2DocNo);
                    CLEAR(Stub2DocDate);
                    CLEAR(Stub2LineAmount);
                    CLEAR(Stub2LineDiscount);
                    CLEAR(Stub2PostingDescription);
                    Stub2DocNoHeader := '';
                    Stub2DocDateHeader := '';
                    Stub2AmountHeader := '';
                    Stub2DiscountHeader := '';
                    Stub2NetAmountHeader := '';
                    Stub2PostingDescHeader := '';
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT TestPrint THEN BEGIN
                        IF UseCheckNo <> GenJnlLine."Document No." THEN BEGIN
                            GenJnlLine3.RESET;
                            GenJnlLine3.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SETRANGE("Document No.", UseCheckNo);
                            IF GenJnlLine3.FIND('-') THEN
                                GenJnlLine3.FIELDERROR("Document No.", STRSUBSTNO(Text013, UseCheckNo));
                        END;

                        IF ApplyMethod <> ApplyMethod::MoreLinesOneEntry THEN BEGIN
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.TESTFIELD("Posting No. Series", '');
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3.MODIFY;
                        END ELSE BEGIN
                            "TotalLineAmount$" := 0;
                            IF GenJnlLine2.FIND('-') THEN BEGIN
                                HighestLineNo := GenJnlLine2."Line No.";
                                REPEAT
                                    IF BankAcc2."Currency Code" <> GenJnlLine2."Currency Code" THEN
                                        ERROR(Text005);
                                    IF GenJnlLine2."Line No." > HighestLineNo THEN
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    GenJnlLine3.TESTFIELD("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3.VALIDATE(Amount);
                                    "TotalLineAmount$" := "TotalLineAmount$" + GenJnlLine3."Amount (LCY)";
                                    GenJnlLine3.MODIFY;
                                UNTIL GenJnlLine2.NEXT = 0;
                            END;

                            GenJnlLine3.RESET;
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            IF GenJnlLine3.NEXT = 0 THEN
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            ELSE BEGIN
                                WHILE GenJnlLine3."Line No." = HighestLineNo + 1 DO BEGIN
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    IF GenJnlLine3.NEXT = 0 THEN
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                END;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                            END;
                            GenJnlLine3.INIT;
                            GenJnlLine3.VALIDATE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.VALIDATE("Account No.", BankAcc2."No.");
                            IF BalancingType <> BalancingType::"G/L Account" THEN
                                GenJnlLine3.Description := STRSUBSTNO(Text014, SELECTSTR(BalancingType + 1, Text062), BalancingNo);
                            GenJnlLine3.VALIDATE(Amount, -TotalLineAmount);
                            IF TotalLineAmount <> "TotalLineAmount$" THEN
                                GenJnlLine3.VALIDATE("Amount (LCY)", -"TotalLineAmount$");
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := TRUE;
                            GenJnlLine3."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                            GenJnlLine3."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                            GenJnlLine3."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            GenJnlLine3.INSERT;
                        END;
                    END;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.MODIFY;
                    IF CommitEachCheck THEN BEGIN
                        COMMIT;
                        CLEAR(CheckManagement);
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    FirstPage := TRUE;
                    FoundLast := FALSE;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF OneCheckPrVendor AND ("Currency Code" <> '') AND
                   ("Currency Code" <> Currency.Code)
                THEN BEGIN
                    Currency.GET("Currency Code");
                    Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                    Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                END;

                IF NOT TestPrint THEN BEGIN
                    IF Amount = 0 THEN
                        CurrReport.SKIP;

                    TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                    IF "Bal. Account No." <> BankAcc2."No." THEN
                        CurrReport.SKIP;

                    IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                        BalancingType := "Account Type";
                        BalancingNo := "Account No.";
                        RemainingAmount := Amount;
                        IF OneCheckPrVendor THEN BEGIN
                            ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                            GenJnlLine2.RESET;
                            GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                            GenJnlLine2.SETRANGE("Document No.", "Document No.");
                            GenJnlLine2.SETRANGE("Account Type", "Account Type");
                            GenJnlLine2.SETRANGE("Account No.", "Account No.");
                            GenJnlLine2.SETRANGE("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SETRANGE("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SETRANGE("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.FIND('-');
                            RemainingAmount := 0;
                        END ELSE
                            IF "Applies-to Doc. No." <> '' THEN
                                ApplyMethod := ApplyMethod::OneLineOneEntry
                            ELSE
                                IF "Applies-to ID" <> '' THEN
                                    ApplyMethod := ApplyMethod::OneLineID
                                ELSE
                                    ApplyMethod := ApplyMethod::Payment;
                    END ELSE
                        IF "Account No." = '' THEN
                            FIELDERROR("Account No.", Text004)
                        ELSE
                            FIELDERROR("Bal. Account No.", Text004);

                    CLEAR(CheckToAddr);
                    CLEAR(SalesPurchPerson);
                    CASE BalancingType OF
                        BalancingType::"G/L Account":
                            BEGIN
                                CheckToAddr[1] := Description;
                                SetCheckPrintParams(
                                  0,
                                  0,
                                  BankAcc2."Country/Region Code",
                                  0,
                                  CheckToAddr[1],
                                  CheckDateFormat,
                                  DateSeparator,
                                  CheckLanguage,
                                  CheckStyle);
                            END;
                        BalancingType::Customer:
                            BEGIN
                                Cust.GET(BalancingNo);
                                IF Cust.Blocked = Cust.Blocked::All THEN
                                    ERROR(Text064, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                                Cust.Contact := '';
                                FormatAddr.Customer(CheckToAddr, Cust);
                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(Text005);
                                IF Cust."Salesperson Code" <> '' THEN
                                    SalesPurchPerson.GET(Cust."Salesperson Code");
                                SetCheckPrintParams(
                                  0,
                                  0,
                                  BankAcc2."Country/Region Code",
                                  0,
                                  CheckToAddr[1],
                                  CheckDateFormat,
                                  DateSeparator,
                                  CheckLanguage,
                                  CheckStyle);
                            END;
                        BalancingType::Vendor:
                            BEGIN
                                Vend.GET(BalancingNo);
                                IF Vend.Blocked IN [Vend.Blocked::All, Vend.Blocked::Payment] THEN
                                    ERROR(Text064, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                                Vend.Contact := '';
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(Text005);
                                IF Vend."Purchaser Code" <> '' THEN
                                    SalesPurchPerson.GET(Vend."Purchaser Code");
                                SetCheckPrintParams(
                                  0,
                                  0,
                                  BankAcc2."Country/Region Code",
                                  0,
                                  CheckToAddr[1],
                                  CheckDateFormat,
                                  DateSeparator,
                                  CheckLanguage,
                                  CheckStyle);
                            END;
                        BalancingType::"Bank Account":
                            BEGIN
                                BankAcc.GET(BalancingNo);
                                BankAcc.TESTFIELD(Blocked, FALSE);
                                BankAcc.Contact := '';
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                IF BankAcc2."Currency Code" <> BankAcc."Currency Code" THEN
                                    ERROR(Text008);
                                IF BankAcc."Our Contact Code" <> '' THEN
                                    SalesPurchPerson.GET(BankAcc."Our Contact Code");
                                SetCheckPrintParams(
                                  0,
                                  0,
                                  BankAcc2."Country/Region Code",
                                  0,
                                  CheckToAddr[1],
                                  CheckDateFormat,
                                  DateSeparator,
                                  CheckLanguage,
                                  CheckStyle);
                            END;
                    END;

                    CheckDateText :=
                      FormatDate("Posting Date", CheckDateFormat, DateSeparator, CheckLanguage, DateIndicator);
                END ELSE BEGIN
                    IF ChecksPrinted > 0 THEN
                        CurrReport.BREAK;
                    SetCheckPrintParams(
                      0,
                      0,
                      BankAcc2."Country/Region Code",
                      0,
                      CheckToAddr[1],
                      CheckDateFormat,
                      DateSeparator,
                      CheckLanguage,
                      CheckStyle);
                    BalancingType := BalancingType::Vendor;
                    BalancingNo := Text010;
                    CLEAR(CheckToAddr);
                    FOR i := 1 TO 5 DO
                        CheckToAddr[i] := Text003;
                    CLEAR(SalesPurchPerson);
                    CheckNoText := Text011;
                    IF CheckStyle = CheckStyle::CA THEN
                        CheckDateText := DateIndicator
                    ELSE
                        CheckDateText := Text010;
                END;
            end;

            trigger OnPreDataItem()
            var
                CompanyInfo: Record "Company Information";
            begin
                COPY(VoidGenJnlLine);
                CompanyInfo.GET;
                IF NOT TestPrint THEN BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.GET(BankAcc2."No.");
                    BankAcc2.TESTFIELD(Blocked, FALSE);
                    COPY(VoidGenJnlLine);
                    SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SETRANGE("Check Printed", FALSE);
                END ELSE BEGIN
                    CLEAR(CompanyAddr);
                    FOR i := 1 TO 5 DO
                        CompanyAddr[i] := Text003;
                END;
                ChecksPrinted := 0;

                SETRANGE("Account Type", "Account Type"::"Fixed Asset");
                IF FIND('-') THEN
                    FIELDERROR("Account Type");
                SETRANGE("Account Type");
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
                    field(BankAccount; BankAcc2."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specifies the bank account that the check will be drawn from.';

                        trigger OnValidate()
                        begin
                            IF BankAcc2."No." <> '' THEN BEGIN
                                BankAcc2.GET(BankAcc2."No.");
                                BankAcc2.TESTFIELD("Last Check No.");
                                UseCheckNo := BankAcc2."Last Check No.";
                            END;
                        end;
                    }
                    field(UseCheckNo; UseCheckNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Check No.';
                        ToolTip = 'Specifies the number of the last check that was issued. If you have entered a number in the Last Check No. field in the Bank Account Card window, the number will appear here when you fill in the Bank Account field.';
                    }
                    field(OneCheckPerVendorPerDocumentNo; OneCheckPrVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'One Check per Vendor per Document No.';
                        MultiLine = true;
                        ToolTip = 'Specifies if only one check is printed per vendor for each document number.';
                    }
                    field(ReprintChecks; ReprintChecks)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reprint Checks';
                        ToolTip = 'Specifies if checks are printed again if you canceled the printing due to a problem.';
                    }
                    field(TestPrint; TestPrint)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Test Print';
                        ToolTip = 'Specifies if you want to print the checks on blank paper before you print them on check forms.';
                    }
                    field(PreprintedStub; PreprintedStub)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Preprinted Stub';
                        ToolTip = 'Specifies if you use check forms with preprinted stubs.';
                    }
                    field(CommitEachCheck; CommitEachCheck)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Commit Each Check';
                        ToolTip = 'Specifies if you want each check to commit to the database after printing instead of at the end of the print job. This allows you to avoid differences between the data and check stock on networks where the print job is cached.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF BankAcc2."No." <> '' THEN
                IF BankAcc2.GET(BankAcc2."No.") THEN
                    UseCheckNo := BankAcc2."Last Check No."
                ELSE BEGIN
                    BankAcc2."No." := '';
                    UseCheckNo := '';
                END;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        GenJnlTemplate.GET(VoidGenJnlLine.GETFILTER("Journal Template Name"));
        IF NOT GenJnlTemplate."Force Doc. Balance" THEN
            IF NOT CONFIRM(USText001, TRUE) THEN
                ERROR(USText002);

        PageNo := 0;
    end;

    var
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GenJnlTemplate: Record "Gen. Journal Template";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        ChkTransMgt: Report "Detail General Ledger";
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        //BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingType: Enum "Gen. Journal Account Type";
        BalancingNo: Code[20];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocNo: Text[30];
        ExtDocNo: Text[30];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        "TotalLineAmount$": Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        CommitEachCheck: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        CurrencyCode2: Code[10];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LineAmount2: Decimal;
        GLSetup: Record "General Ledger Setup";
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        USText001: Label 'Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        USText002: Label 'Process canceled at user request.';
        USText004: Label 'Last Check No. must include at least one digit, so that it can be incremented.';
        DateIndicator: Text[10];
        CheckDateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD";
        CheckStyle: Option ,US,CA;
        CheckLanguage: Integer;
        DateSeparator: Option " ","-",".","/";
        DollarSignBefore: Code[5];
        DollarSignAfter: Code[5];
        PrnChkCompanyAddr: array[2, 8] of Text[50];
        PrnChkCheckToAddr: array[2, 8] of Text[50];
        PrnChkCheckNoText: array[2] of Text[30];
        PrnChkCheckDateText: array[2] of Text[30];
        PrnChkCheckAmountText: array[2] of Text[30];
        PrnChkDescriptionLine: array[2, 2] of Text[80];
        PrnChkVoidText: array[2] of Text[30];
        PrnChkDateIndicator: array[2] of Text[10];
        PrnChkCurrencyCode: array[2] of Code[10];
        USText006: Label 'You cannot use the <blank> %1 option with a Canadian style check. Please check %2 %3.';
        USText007: Label 'You cannot use the Spanish %1 option with a Canadian style check. Please check %2 %3.';
        Stub2LineNo: Integer;
        Stub2DocNo: array[105] of Text[30];
        Stub2DocDate: array[105] of Date;
        Stub2LineAmount: array[105] of Decimal;
        Stub2LineDiscount: array[105] of Decimal;
        Stub2PostingDescription: array[105] of Text[50];
        Stub2DocNoHeader: Text[30];
        Stub2DocDateHeader: Text[30];
        Stub2AmountHeader: Text[30];
        Stub2DiscountHeader: Text[30];
        Stub2PostingDescHeader: Text[50];
        Stub2NetAmountHeader: Text[30];
        USText011: Label 'Document No.';
        USText012: Label 'Document Date';
        USText013: Label 'Amount';
        USText014: Label 'Discount';
        USText015: Label 'Net Amount';
        PostingDesc: Text[50];
        USText017: Label 'Posting Description';
        StartingLen: Integer;
        ControlLen: Integer;
        NewLen: Integer;
        CheckStyleIndex: Integer;
        Index: Integer;
        BankCurrencyCode: Text[30];
        PageNo: Integer;
        CheckNoTextCaptionLbl: Label 'Check No.';
        LineAmountCaptionLbl: Label 'Net Amount';
        LineDiscountCaptionLbl: Label 'Discount';
        AmountCaptionLbl: Label 'Amount';
        DocNoCaptionLbl: Label 'Document No.';
        DocDateCaptionLbl: Label 'Document Date';
        Posting_DescriptionCaptionLbl: Label 'Posting Description';
        CheckNoText_Control1480000CaptionLbl: Label 'Check No.';
        AccountNoCaptionLbl: Label 'Account Number:';
        USTextErr: Label '%1 language is not enabled. %2 is set up for checks in %1.', Comment = 'English language is not enabled. Bank of America is set up for checks in English.';
        EnglishLanguageCode: Integer;
        FrenchLanguageCode: Integer;
        SpanishLanguageCode: Integer;
        CAEnglishLanguageCode: Integer;
        LanguageCode: Integer;
        CurrencyCode: Code[10];
        OnesText: array[30] of Text[30];
        TensText: array[10] of Text[30];
        HundredsText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        HundredText: Text[30];
        AndText: Text[30];
        ZeroText: Text[30];
        CentsText: Text[30];
        OneMillionText: Text[30];

        Texts000: Label 'Zero';
        Texts001: Label 'One';
        Texts002: Label 'Two';
        Texts003: Label 'Three';
        Texts004: Label 'Four';
        Texts005: Label 'Five';
        Texts006: Label 'Six';
        Texts007: Label 'Seven';
        Texts008: Label 'Eight';
        Texts009: Label 'Nine';
        Texts010: Label 'Ten';
        Texts011: Label 'Eleven';
        Texts012: Label 'Twelve';
        Texts013: Label 'Thirteen';
        Texts014: Label 'Fourteen';
        Texts015: Label 'Fifteen';
        Texts016: Label 'Sixteen';
        Texts017: Label 'Seventeen';
        Texts018: Label 'Eighteen';
        Texts019: Label 'Nineteen';
        Texts020: Label 'Twenty';
        Texts021: Label 'Thirty';
        Texts022: Label 'Forty';
        Texts023: Label 'Fifty';
        Texts024: Label 'Sixty';
        Texts025: Label 'Seventy';
        Texts026: Label 'Eighty';
        Texts027: Label 'Ninety';
        Texts028: Label 'Hundred';
        Texts029: Label 'and';
        Texts031: Label 'Thousand';
        Texts032: Label 'Million';
        Texts033: Label 'Billion';
        Texts035: Label '/100';
        Texts036: Label 'One Million';
        Texts041: Label 'Twenty One';
        Texts042: Label 'Twenty Two';
        Texts043: Label 'Twenty Three';
        Texts044: Label 'Twenty Four';
        Texts045: Label 'Twenty Five';
        Texts046: Label 'Twenty Six';
        Texts047: Label 'Twenty Seven';
        Texts048: Label 'Twenty Eight';
        Texts049: Label 'Twenty Nine';
        Texts051: Label 'One Hundred';
        Texts052: Label 'Two Hundred';
        Texts053: Label 'Three Hundred';
        Texts054: Label 'Four Hundred';
        Texts055: Label 'Five Hundred';
        Texts056: Label 'Six Hundred';
        Texts057: Label 'Seven Hundred';
        Texts058: Label 'Eight Hundred';
        Texts059: Label 'Nine Hundred';
        Texts100: Label 'Language Code %1 is not implemented.';
        Texts101: Label '%1 results in a written number that is too long.';
        Texts102: Label '%1 is too large to convert to Texts.';
        Texts103: Label '%1 language is not enabled.';
        Texts104: Label '****';
        Texts107: Label 'MM DD YYYY';
        Texts108: Label 'DD MM YYYY';
        Texts109: Label 'YYYY MM DD';
        Texts110: Label 'US dollars';
        Texts111: Label 'Mexican pesos';
        Texts112: Label 'Canadian dollars';

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SETRANGE("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text030,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        END;

        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Document Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";
        CustLedgEntry2.CALCFIELDS("Remaining Amount");
        PostingDesc := CustLedgEntry2.Description;

        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" -
                        CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");
        IF ((((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::Invoice) AND
              (LineAmount2 >= RemainingAmount2)) OR
             ((CustLedgEntry2."Document Type" = CustLedgEntry2."Document Type"::"Credit Memo") AND
              (LineAmount2 <= RemainingAmount2))) AND
            (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) OR
           CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            IF CustLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
               ROUND(
                 -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                     CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            THEN
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                        CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                      LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET;
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FIND('-') THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        Text031,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        END;

        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocNo := ExtDocNo;
        DocDate := VendLedgEntry2."Document Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        PostingDesc := VendLedgEntry2.Description;
        VendLedgEntry2.CALCFIELDS("Remaining Amount");
        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" -
                        VendLedgEntry2."Accepted Payment Tolerance");

        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF ((((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::Invoice) AND
              (LineAmount2 <= RemainingAmount2)) OR
             ((VendLedgEntry2."Document Type" = VendLedgEntry2."Document Type"::"Credit Memo") AND
              (LineAmount2 <= RemainingAmount2))) AND
            (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) OR
           VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            IF VendLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
               ROUND(
                 -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                     VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision")
            THEN BEGIN
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                        VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision");
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                      LineAmount2), Currency."Amount Rounding Precision");
            END ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                      LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        IF BankAcc <> '' THEN
            IF BankAcc2.GET(BankAcc) THEN BEGIN
                UseCheckNo := LastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            END;
    end;

    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        IF (CurrencyCode <> '') AND (CurrencyCode2 = '') THEN
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        ELSE
            IF (CurrencyCode = '') AND (CurrencyCode2 <> '') THEN
                Amount2 :=
                  CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    PostingDate, CurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode2))
            ELSE
                IF (CurrencyCode <> '') AND (CurrencyCode2 <> '') AND (CurrencyCode <> CurrencyCode2) THEN
                    Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, CurrencyCode2, CurrencyCode, Amount)
                ELSE
                    Amount2 := Amount;
    end;

    procedure GetCheckAmountText(CurrencyCode: Code[10]; var CurrencySymbol: Code[5]; var Amount: Decimal) CheckAmountText: Text
    var
        Currency: Record Currency;
        Decimals: Decimal;
    begin
        //HG10.00.02 NJ 01/06/2017 -->
        IF CurrencyCode <> '' THEN
            Currency.GET(CurrencyCode)
        ELSE
            Currency.InitRoundingPrecision;

        Decimals := Amount - ROUND(Amount, 1, '<');

        IF (GetFractionPartLength(Amount) <> GetFractionPartLength(Currency."Amount Rounding Precision")) THEN
            IF (Decimals = 0) OR (GetFractionPartLength(Amount) > GetFractionPartLength(Currency."Amount Rounding Precision")) THEN
                CheckAmountText :=
                  FORMAT(
                    ROUND(Amount, 1, '<')) +
                    GetDecimalSeparator +
                    PADSTR('', STRLEN(FORMAT(ROUND(Currency."Amount Rounding Precision", Currency."Amount Rounding Precision"))) - 2, '0')
            ELSE
                CheckAmountText := FORMAT(ROUND(Amount, Currency."Amount Rounding Precision")) +
                  PADSTR('', GetFractionPartLength(Currency."Amount Rounding Precision") - GetFractionPartLength(Amount), '0')
        ELSE
            CheckAmountText := FORMAT(Amount, 0, 0);

        CurrencySymbol := Currency.Symbol;
        //HG10.00.02 NJ 01/06/2017 <--
    end;

    local procedure GetFractionPartLength(DecimalValue: Decimal): Integer
    begin
        //HG10.00.02 NJ 01/06/2017 -->
        IF STRPOS(FORMAT(DecimalValue), GetDecimalSeparator) = 0 THEN
            EXIT(0);

        EXIT(STRLEN(FORMAT(DecimalValue)) - STRPOS(FORMAT(DecimalValue), GetDecimalSeparator));
        //HG10.00.02 NJ 01/06/2017 <--
    end;

    local procedure GetDecimalSeparator(): Code[1]
    begin
        EXIT(COPYSTR(FORMAT(0.01), 2, 1)); //HG10.00.02 NJ 01/06/2017
    end;

    local procedure FormatNoTextFRC(var NoText: array[2] of Text[80]; No: Decimal): Boolean
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        NoTextIndex := 1;
        NoText[1] := Texts104;

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText, ' ')
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;

                IF Hundreds = 1 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ')
                ELSE
                    IF Hundreds > 1 THEN BEGIN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds], ' ');
                        IF (Tens * 10 + Ones) = 0 THEN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText + 's', ' ')
                        ELSE
                            AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ');
                    END;

                FormatTensFRC(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

                IF PrintExponent AND (Exponent > 1) THEN
                    IF ((Hundreds * 100 + Tens * 10 + Ones) > 1) AND (Exponent <> 2) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent] + 's', ' ')
                    ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], ' ');

                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' ');
        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
        EXIT(AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100, 2) + CentsText, ' '));
    end;

    local procedure FormatTensFRC(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; Exponent: Integer; Hundreds: Integer; Tens: Integer; Ones: Integer)
    begin
        CASE Tens OF
            9:
                IF Ones = 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[9] + 's', ' ')
                ELSE BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[8], ' ');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10], '-');
                END;
            8:
                IF Ones = 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[8] + 's', ' ')
                ELSE BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[8], ' ');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '-');
                END;
            7:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[6], ' ');
                    IF Ones = 1 THEN BEGIN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10], ' ');
                    END ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10], '-');
                END;
            2:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[2], ' ');
                    IF Ones > 0 THEN BEGIN
                        IF Ones = 1 THEN BEGIN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                        END ELSE
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '-');
                    END;
                END;
            1:
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], ' ');
            0:
                BEGIN
                    IF Ones > 0 THEN
                        IF (Ones = 1) AND (Hundreds < 1) AND (Exponent = 2) THEN
                            PrintExponent := TRUE
                        ELSE
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                END;
            ELSE BEGIN
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], ' ');
                IF Ones > 0 THEN BEGIN
                    IF Ones = 1 THEN BEGIN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                    END ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], '-');
                END;
            END;
        END;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[40]; Divider: Text[1]): Boolean
    begin
        IF NoTextIndex > ARRAYLEN(NoText) THEN
            EXIT(FALSE);
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN BEGIN
                NoText[ARRAYLEN(NoText)] := STRSUBSTNO(Texts101, AddText);
                EXIT(FALSE);
            END;
        END;

        CASE LanguageCode OF
            EnglishLanguageCode:
                IF NoText[NoTextIndex] = Texts104 THEN
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + UPPERCASE(AddText), '<')
                ELSE
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + UPPERCASE(AddText), '<');
            SpanishLanguageCode:
                IF NoText[NoTextIndex] = Texts104 THEN
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + UPPERCASE(AddText), '<')
                ELSE
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + UPPERCASE(AddText), '<');
            CAEnglishLanguageCode:
                IF NoText[NoTextIndex] = Texts104 THEN
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + AddText, '<')
                ELSE
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + AddText, '<');
            FrenchLanguageCode:
                IF NoText[NoTextIndex] = Texts104 THEN
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + AddText, '<')
                ELSE
                    NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + Divider + LOWERCASE(AddText), '<');
        END;

        EXIT(TRUE);
    end;

    procedure SetCheckPrintParams(NewDateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD"; NewDateSeparator: Option " ","-",".","/"; NewCountryCode: Code[10]; NewCheckLanguage: Option "E English","F French","S Spanish"; CheckToAddr: Text[50]; var CheckDateFormat: Option; var DateSeparator: Option; var CheckLanguage: Integer; var CheckStyle: Option ,US,CA)
    var
        WindowsLanguage: Record "Windows Language";
        CompanyInformation: Record "Company Information";
    begin
        CheckDateFormat := NewDateFormat;
        DateSeparator := NewDateSeparator;
        CASE NewCheckLanguage OF
            NewCheckLanguage::"E English":
                IF NewCountryCode = 'CA' THEN
                    CheckLanguage := 4105
                ELSE
                    CheckLanguage := 1033;
            NewCheckLanguage::"F French":
                CheckLanguage := 3084;
            NewCheckLanguage::"S Spanish":
                CheckLanguage := 2058;
            ELSE
                CheckLanguage := 1033;
        END;
        CompanyInformation.GET;
        CASE CompanyInformation.GetCountryRegionCode(NewCountryCode) OF
            'US', 'MX':
                CheckStyle := CheckStyle::US;
            'CA':
                CheckStyle := CheckStyle::CA;
            ELSE
                CheckStyle := CheckStyle::US;
        END;
        IF CheckLanguage <> WindowsLanguage."Language ID" THEN
            WindowsLanguage.GET(CheckLanguage);
        IF NOT WindowsLanguage."Globally Enabled" THEN BEGIN
            IF CheckLanguage = 4105 THEN
                CheckLanguage := 1033
            ELSE
                ERROR(USTextErr, WindowsLanguage.Name, CheckToAddr);
        END;
    end;

    local procedure SetObjectLanguage(NewLanguageCode: Integer)
    var
        WindowsLang: Record "Windows Language";
    begin
        EnglishLanguageCode := 1033;
        FrenchLanguageCode := 3084;
        SpanishLanguageCode := 2058;
        CAEnglishLanguageCode := 4105;

        WindowsLang.GET(NewLanguageCode);
        IF NOT WindowsLang."Globally Enabled" THEN
            ERROR(Texts103, WindowsLang.Name);
        LanguageCode := NewLanguageCode;
        CurrReport.LANGUAGE(LanguageCode);
    end;

    procedure FormatDate(Date: Date; DateFormat: Option " ","MM DD YYYY","DD MM YYYY","YYYY MM DD"; DateSeparator: Option " ","-",".","/"; NewLanguageCode: Integer; var DateIndicator: Text) ChequeDate: Text[30]
    begin
        SetObjectLanguage(NewLanguageCode);

        CASE DateFormat OF
            DateFormat::"MM DD YYYY":
                BEGIN
                    DateIndicator := Texts107;
                    CASE DateSeparator OF
                        0:
                            ChequeDate := FORMAT(Date, 0, '<Month,2> <Day,2> <Year4>');
                        1:
                            ChequeDate := FORMAT(Date, 0, '<Month,2>-<Day,2>-<Year4>');
                        2:
                            ChequeDate := FORMAT(Date, 0, '<Month,2>.<Day,2>.<Year4>');
                        3:
                            ChequeDate := FORMAT(Date, 0, '<Month,2>/<Day,2>/<Year4>');
                    END;
                END;
            DateFormat::"DD MM YYYY":
                BEGIN
                    DateIndicator := Texts108;
                    CASE DateSeparator OF
                        0:
                            ChequeDate := FORMAT(Date, 0, '<Day,2> <Month,2> <Year4>');
                        1:
                            ChequeDate := FORMAT(Date, 0, '<Day,2>-<Month,2>-<Year4>');
                        2:
                            ChequeDate := FORMAT(Date, 0, '<Day,2>.<Month,2>.<Year4>');
                        3:
                            ChequeDate := FORMAT(Date, 0, '<Day,2>/<Month,2>/<Year4>');
                    END;
                END;
            DateFormat::"YYYY MM DD":
                BEGIN
                    DateIndicator := Texts109;
                    CASE DateSeparator OF
                        0:
                            ChequeDate := FORMAT(Date, 0, '<Year4> <Month,2> <Day,2>');
                        1:
                            ChequeDate := FORMAT(Date, 0, '<Year4>-<Month,2>-<Day,2>');
                        2:
                            ChequeDate := FORMAT(Date, 0, '<Year4>.<Month,2>.<Day,2>');
                        3:
                            ChequeDate := FORMAT(Date, 0, '<Year4>/<Month,2>/<Day,2>');
                    END;
                END;
            ELSE BEGIN
                DateIndicator := '';
                ChequeDate := FORMAT(Date, 0, 4);
            END;
        END;
    end;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; NewLanguageCode: Integer; NewCurrencyCode: Code[10]) Result: Boolean
    begin
        SetObjectLanguage(NewLanguageCode);

        InitTextVariable;
        GLSetup.GET;
        GLSetup.TESTFIELD("LCY Code");
        CurrencyCode := NewCurrencyCode;
        IF CurrencyCode = '' THEN BEGIN
            Currency.INIT;
            Currency.Code := GLSetup."LCY Code";
            CASE GLSetup."LCY Code" OF
                'USD':
                    Currency.Description := Texts110;
                'MXP':
                    Currency.Description := Texts111;
                'CAD':
                    Currency.Description := Texts112;
            END;
        END ELSE
            IF NOT Currency.GET(CurrencyCode) THEN
                CLEAR(Currency);
        CLEAR(NoText);

        IF No < 1000000000000.0 THEN
            CASE LanguageCode OF
                EnglishLanguageCode, CAEnglishLanguageCode:
                    Result := FormatNoTextENU(NoText, No);
                SpanishLanguageCode:
                    Result := FormatNoTextESM(NoText, No);
                FrenchLanguageCode:
                    Result := FormatNoTextFRC(NoText, No);
                ELSE BEGIN
                    NoText[1] := STRSUBSTNO(Texts100, LanguageCode);
                    Result := FALSE;
                END;
            END
        ELSE BEGIN
            NoText[1] := STRSUBSTNO(Texts102, No);
            Result := FALSE;
        END;
    end;

    local procedure FormatNoTextENU(var NoText: array[2] of Text[80]; No: Decimal): Boolean
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        NoTextIndex := 1;
        NoText[1] := Texts104;

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText, ' ')
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds], ' ');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ');
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], ' ');
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], ' ');
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], ' ');
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        IF LanguageCode = CAEnglishLanguageCode THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' ');
            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
            EXIT(AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + CentsText, ' '));
        END;
        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + CentsText, ' ');
        EXIT(AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' '));
    end;

    local procedure FormatNoTextESM(var NoText: array[2] of Text[80]; No: Decimal): Boolean
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        NoTextIndex := 1;
        NoText[1] := Texts104;

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText, ' ')
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    IF (Hundreds = 1) AND (Tens = 0) AND (Ones = 0) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText, ' ')
                    ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, HundredsText[Hundreds], ' ');
                END;
                CASE Tens OF
                    0:
                        IF (Hundreds = 0) AND (Ones = 1) AND (Exponent > 1) THEN
                            PrintExponent := TRUE
                        ELSE
                            IF Ones > 0 THEN
                                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                    1, 2:
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones], ' ');
                    ELSE BEGIN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens], ' ');
                        IF Ones <> 0 THEN BEGIN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, AndText, ' ');
                            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones], ' ');
                        END;
                    END;
                END;
                IF PrintExponent AND (Exponent > 1) THEN BEGIN
                    IF (Hundreds = 0) AND (Tens = 0) AND (Ones = 1) AND (Exponent = 3) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OneMillionText, ' ')
                    ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent], ' ');
                END;
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Currency.Description, ' ');
        EXIT(AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + CentsText, ' '));
    end;

    local procedure InitTextVariable()
    begin
        OnesText[1] := Texts001;
        OnesText[2] := Texts002;
        OnesText[3] := Texts003;
        OnesText[4] := Texts004;
        OnesText[5] := Texts005;
        OnesText[6] := Texts006;
        OnesText[7] := Texts007;
        OnesText[8] := Texts008;
        OnesText[9] := Texts009;
        OnesText[10] := Texts010;
        OnesText[11] := Texts011;
        OnesText[12] := Texts012;
        OnesText[13] := Texts013;
        OnesText[14] := Texts014;
        OnesText[15] := Texts015;
        OnesText[16] := Texts016;
        OnesText[17] := Texts017;
        OnesText[18] := Texts018;
        OnesText[19] := Texts019;
        OnesText[20] := Texts020;
        OnesText[21] := Texts041;
        OnesText[22] := Texts042;
        OnesText[23] := Texts043;
        OnesText[24] := Texts044;
        OnesText[25] := Texts045;
        OnesText[26] := Texts046;
        OnesText[27] := Texts047;
        OnesText[28] := Texts048;
        OnesText[29] := Texts049;

        TensText[1] := Texts010;
        TensText[2] := Texts020;
        TensText[3] := Texts021;
        TensText[4] := Texts022;
        TensText[5] := Texts023;
        TensText[6] := Texts024;
        TensText[7] := Texts025;
        TensText[8] := Texts026;
        TensText[9] := Texts027;

        HundredsText[1] := Texts051;
        HundredsText[2] := Texts052;
        HundredsText[3] := Texts053;
        HundredsText[4] := Texts054;
        HundredsText[5] := Texts055;
        HundredsText[6] := Texts056;
        HundredsText[7] := Texts057;
        HundredsText[8] := Texts058;
        HundredsText[9] := Texts059;

        ExponentText[1] := '';
        ExponentText[2] := Texts031;
        ExponentText[3] := Texts032;
        ExponentText[4] := Texts033;

        HundredText := Texts028;
        AndText := Texts029;
        ZeroText := Texts000;
        CentsText := Texts035;
        OneMillionText := Texts036;
    end;
}

