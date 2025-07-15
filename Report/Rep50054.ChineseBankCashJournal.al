report 50054 ChineseBankCashJournal
{
    // CS092 FDD R047 Bobby.ji 2025/7/15 - Upgrade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Chinese Bank Cash Journal.rdlc';
    Caption = 'Chinese Bank Cash Journal';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code";
            column(Bank_Account_No_; "No.")
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("No.");
                DataItemTableView = SORTING("Bank Account No.", "Posting Date");
                RequestFilterFields = "Posting Date";
                column(AccountDesc; AccountDesc)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PAGENO)
                {
                }
                column(Bank_Account___Bank_Account_No__; "Bank Account"."Bank Account No.")
                {
                }
                column(CurrCode; CurrCode)
                {
                }
                column(FORMAT_MinDate_0___Year4___; FORMAT(MinDate, 0, '<Year4>'))
                {
                }
                column(FORMAT_MinDate_0___Month_2___; FORMAT(MinDate, 0, '<Month,2>'))
                {
                }
                column(FORMAT_MinDate_0___Day___; FORMAT(MinDate, 0, '<Day>'))
                {
                }
                column(FORMAT_MaxDate_0___Year4___; FORMAT(MaxDate, 0, '<Year4>'))
                {
                }
                column(FORMAT_MaxDate_0___Month_2___; FORMAT(MaxDate, 0, '<Month,2>'))
                {
                }
                column(FORMAT_MaxDate_0___Day___; FORMAT(MaxDate, 0, '<Day>'))
                {
                }
                column(TimeCaption; FORMAT(MinDate, 0, '<Year4>') + '年' + FORMAT(MinDate, 0, '<Month,2>') + '月' + FORMAT(MinDate, 0, '<Day>') + '日' + '--' + FORMAT(MaxDate, 0, '<Year4>') + '年' + FORMAT(MaxDate, 0, '<Month,2>') + '月' + FORMAT(MaxDate, 0, '<Day>') + '日')
                {
                }
                column(FirstBalance; FirstBalance)
                {
                }
                column(FirstBalance1; FirstBalance1)
                {
                }
                column(CurrReport_PAGENO_Control1000000019; CurrReport.PAGENO)
                {
                }
                column(CurrCode_Control1000000115; CurrCode)
                {
                }
                column(Bank_Account___Bank_Account_No___Control1000000008; "Bank Account"."Bank Account No.")
                {
                }
                column(AccountDesc_Control1000000116; AccountDesc)
                {
                }
                column(FORMAT_MinDate_0___Year4____Control1000000234; FORMAT(MinDate, 0, '<Year4>'))
                {
                }
                column(FORMAT_MinDate_0___Month_2____Control1000000236; FORMAT(MinDate, 0, '<Month,2>'))
                {
                }
                column(FORMAT_MinDate_0___Day____Control1000000238; FORMAT(MinDate, 0, '<Day>'))
                {
                }
                column(FORMAT_MaxDate_0___Year4____Control1000000241; FORMAT(MaxDate, 0, '<Year4>'))
                {
                }
                column(FORMAT_MaxDate_0___Month_2____Control1000000243; FORMAT(MaxDate, 0, '<Month,2>'))
                {
                }
                column(FORMAT_MaxDate_0___Day____Control1000000245; FORMAT(MaxDate, 0, '<Day>'))
                {
                }
                column(CAmt; CAmt)
                {
                }
                column(DAmt; DAmt)
                {
                }
                column(Bank_Account_Ledger_Entry_Description; Description)
                {
                }
                column(Bank_Account_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(FORMAT__Posting_Date__0___Day___; FORMAT("Posting Date", 0, '<Day>'))
                {
                }
                column(FORMAT__Posting_Date__0___Month___; FORMAT("Posting Date", 0, '<Month>'))
                {
                }
                column(Balance1_FirstBalance1; Balance1 + FirstBalance1)
                {
                }
                column(BlaAcc; BlaAcc)
                {
                }
                column(rate; rate)
                {
                    DecimalPlaces = 4 : 4;
                }
                column(Bank_Account_Ledger_Entry__Debit_Amount__LCY__; "Debit Amount (LCY)")
                {
                }
                column(Bank_Account_Ledger_Entry__Credit_Amount__LCY__; "Credit Amount (LCY)")
                {
                }
                column(Balance_FirstBalance; Balance + FirstBalance)
                {
                }
                column(BankJnlCaption; BankJnlCaptionLbl)
                {
                }
                column(PageNo_Caption; PageNo_CaptionLbl)
                {
                }
                column(Bank_A_c_No__Caption; Bank_A_c_No__CaptionLbl)
                {
                }
                column(Name_Caption; Name_CaptionLbl)
                {
                }
                column(Curr__Code_Caption; Curr__Code_CaptionLbl)
                {
                }
                column(Caption_Year; CaptionLbl_Year)
                {
                }
                column(Caption_Month; CaptionLbl_Month)
                {
                }
                column(Caption_Day; CaptionLbl_Day)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(Caption_Control1000000183; Caption_Control1000000183Lbl)
                {
                }
                column(Caption_Control1000000185; '185')
                {
                }
                column(Caption_Control1000000187; '187')
                {
                }
                column(CExplanationCaption; CExplanationCaptionLbl)
                {
                }
                column(CCorresponding_AccountsCaption; CCorresponding_AccountsCaptionLbl)
                {
                }
                column(Credit_Caption; Credit_CaptionLbl)
                {
                }
                column(Debit_Caption; Debit_CaptionLbl)
                {
                }
                column(CMonthCaption_Control1000000006; CMonthCaption_Control1000000006Lbl)
                {
                }
                column(CVoucherCaption; CVoucherCaptionLbl)
                {
                }
                column(CDayCaption_Control1000000011; CDayCaption_Control1000000011Lbl)
                {
                }
                column(BalanceCaption; BalanceCaptionLbl)
                {
                }
                column(MCaption; MCaptionLbl)
                {
                }
                column(DCaption; DCaptionLbl)
                {
                }
                column(VoucherCaption; VoucherCaptionLbl)
                {
                }
                column(ExplanationCaption; VoucherCaptionLbl)
                {
                }
                column(Corresponding_AccountsCaption; Corresponding_AccountsCaptionLbl)
                {
                }
                column(CreditForeignCaption; CreditForeignCaptionLbl)
                {
                }
                column(CExcRateCaption; CExcRateCaptionLbl)
                {
                }
                column(CreaditAmountCaption; CreaditAmountCaptionLbl)
                {
                }
                column(DebitAmountCaption_Control1000000147; DebitAmountCaption_Control1000000147Lbl)
                {
                }
                column(DebitForeignCaption; DebitForeignCaptionLbl)
                {
                }
                column(BalanceForeignCaption_Control1000000157; BalanceForeignCaption_Control1000000157Lbl)
                {
                }
                column(BalanceAmountCaption_Control1000000158; BalanceAmountCaption_Control1000000158Lbl)
                {
                }
                column(OpenBalanceCaption; 'OpenBalanceCaption')
                {
                }
                column(Page_Caption_Control1000000020; '页号(Page)2')
                {
                }
                column(Caption_Control1000000014; 'Caption_Control1000000014')
                {
                }
                column(Caption_Control1000000043; 'Caption_Control1000000043')
                {
                }
                column(Caption_Control1000000048; 'Caption_Control1000000048')
                {
                }
                column(Caption_Control1000000049; 'Caption_Control1000000049')
                {
                }
                column(Caption_Control1000000082; 'Caption_Control1000000082')
                {
                }
                column(Caption_Control1000000084; 'Caption_Control1000000084')
                {
                }
                column(Caption_Control1000000085; 'Caption_Control1000000085')
                {
                }
                column(Caption_Control1000000086; 'Caption_Control1000000086')
                {
                }
                column(Caption_Control1000000087; 'Caption_Control1000000087')
                {
                }
                column(MCaption_Control1000000099; MCaption_Control1000000099Lbl)
                {
                }
                column(DCaption_Control1000000100; DCaption_Control1000000100Lbl)
                {
                }
                column(VoucherCaption_Control1000000101; 'VoucherCaption_Control1000000101')
                {
                }
                column(ExplanationCaption_Control1000000102; 'ExplanationCaption_Control1000000102')
                {
                }
                column(Corresponding_AccountsCaption_Control1000000103; 'Corresponding_AccountsCaption_Control1000000103')
                {
                }
                column(Caption_Control1000000104; 'Caption_Control1000000104­')
                {
                }
                column(Caption_Control1000000106; 'Caption_Control1000000106')
                {
                }
                column(Caption_Control1000000107; 'Caption_Control1000000107')
                {
                }
                column(Caption_Control1000000193; 'Caption_Control1000000193')
                {
                }
                column(Caption_Control1000000194; 'Caption_Control1000000194­')
                {
                }
                column(Caption_Control1000000196; 'Caption_Control1000000196­')
                {
                }
                column(Caption_Control1000000197; 'Caption_Control1000000197')
                {
                }
                column(Curr__Code_Caption_Control1000000114; 'Curr__Code_Caption_Control1000000114 Curr. Code.')
                {
                }
                column(Bank_A_c_No__Caption_Control1000000009; 'Bank_A_c_No__Caption_Control1000000009:')
                {
                }
                column(Name_Caption_Control1000000117; 'Name_Caption_Control1000000117:')
                {
                }
                column(Caption_Control1000000235; 'Caption_Control1000000235')
                {
                }
                column(Caption_Control1000000237; 'Caption_Control1000000237')
                {
                }
                column(Caption_Control1000000239; 'Caption_Control1000000239')
                {
                }
                column(EmptyStringCaption_Control1000000240; '-')
                {
                }
                column(Caption_Control1000000242; 'Caption_Control1000000242')
                {
                }
                column(Caption_Control1000000244; 'Caption_Control1000000244')
                {
                }
                column(Caption_Control1000000246; 'Caption_Control1000000246')
                {
                }
                column(Bank_Account_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Bank_Account_No_; "Bank Account No.")
                {
                }
                dataitem(DayTotal; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(SumDay1_2_; SumDay1[2])
                    {
                    }
                    column(SumDay1_1_; SumDay1[1])
                    {
                    }
                    column(FORMAT_TheDate_0___Day___; FORMAT(TheDate, 0, '<Day>'))
                    {
                    }
                    column(FORMAT_TheDate_0___Month___; FORMAT(TheDate, 0, '<Month>'))
                    {
                    }
                    column(SumDay1_3_; SumDay1[3])
                    {
                    }
                    column(SumDay_1_; SumDay[1])
                    {
                    }
                    column(SumDay_2_; SumDay[2])
                    {
                    }
                    column(SumDay_3_; SumDay[3])
                    {
                    }
                    column(ShowDayAmt; ShowDayAmt)
                    {
                    }
                    column(FORMAT_TheDate_0___Month____Control1000000251; FORMAT(TheDate, 0, '<Month>'))
                    {
                    }
                    column(SumMonth_1_; SumMonth[1])
                    {
                    }
                    column(SumMonth1_1_; SumMonth1[1])
                    {
                    }
                    column(SumMonth_2_; SumMonth[2])
                    {
                    }
                    column(SumMonth1_2_; SumMonth1[2])
                    {
                    }
                    column(SumMonth_3_; SumMonth[3])
                    {
                    }
                    column(SumMonth1_3_; SumMonth1[3])
                    {
                    }
                    column(ShowMonthAmt; ShowMonthAmt)
                    {
                    }
                    column(SumYear1_2_; SumYear1[2])
                    {
                    }
                    column(SumYear1_1_; SumYear1[1])
                    {
                    }
                    column(SumYear1_3_; SumYear1[3])
                    {
                    }
                    column(SumYear_1_; SumYear[1])
                    {
                    }
                    column(SumYear_2_; SumYear[2])
                    {
                    }
                    column(SumYear_3_; SumYear[3])
                    {
                    }
                    column(ShowYearAmt; ShowYearAmt)
                    {
                    }
                    column(TotalDayCaption; TotalDayCaptionLbl)
                    {
                    }
                    column(TotalMonthCaption; TotalMonthCaptionLbl)
                    {
                    }
                    column(TotalYearCaption; TotalYearCaptionLbl)
                    {
                    }
                    column(DayTotal_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ShowDayAmt := FALSE;
                        ShowMonthAmt := FALSE;
                        ShowYearAmt := FALSE;

                        IF ("Bank Account Ledger Entry".NEXT <> 0) THEN BEGIN
                            IF ("Bank Account Ledger Entry"."Posting Date" <> TheDate) THEN
                                ShowDayAmt := TRUE;

                            IF FORMAT("Bank Account Ledger Entry"."Posting Date", 0, '<Month>') <> FORMAT(TheDate, 0, '<Month>') THEN
                                ShowMonthAmt := TRUE;

                            IF FORMAT("Bank Account Ledger Entry"."Posting Date", 0, '<Year>') <> FORMAT(TheDate, 0, '<Year>') THEN
                                ShowYearAmt := TRUE;

                            "Bank Account Ledger Entry".NEXT(-1);
                        END
                        ELSE
                            IF TheDate <> 0D THEN BEGIN
                                ShowDayAmt := TRUE;
                                ShowMonthAmt := TRUE;
                                ShowYearAmt := TRUE;
                            END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        DayTotal.SETRANGE(Number, 1, 1);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    BlaAcc := '';
                    CurrAccountNo := '';
                    i := 0;
                    MyEntry.RESET;
                    MyEntry.SETRANGE(MyEntry."Document No.", "Bank Account Ledger Entry"."Document No.");
                    MyEntry.SETFILTER(MyEntry."Entry No.", '<>%1', "Bank Account Ledger Entry"."Entry No.");

                    /*
                    IF MyEntry.FIND('-') THEN
                      REPEAT
                        i := i + 1;
                        IF MyEntry."G/L Account No." <> CurrAccountNo THEN
                          BEGIN
                            IF i=1 THEN
                              BlaAcc:=MyEntry."G/L Account No."
                            ELSE
                              BEGIN
                                IF STRLEN(BlaAcc) > 1000 THEN
                                  BlaAcc := ''
                                ELSE
                                  BlaAcc:=BlaAcc+',' + MyEntry."G/L Account No.";
                              END;
                    
                            CurrAccountNo := MyEntry."G/L Account No.";
                          END;
                      UNTIL MyEntry.NEXT=0;
                    */

                    IF "Bank Account Ledger Entry"."Bal. Account No." <> '' THEN
                        BlaAcc := FORMAT("Bank Account Ledger Entry"."Bal. Account Type") + '  ' + "Bank Account Ledger Entry"."Bal. Account No."
                    ELSE
                        BlaAcc := '';

                    GLAccount.RESET;

                    IF GLAccount.GET("Bank Account Ledger Entry"."Bank Account No.") THEN BEGIN
                        AccountDesc := GLAccount.Name;
                        Balance += "Bank Account Ledger Entry".Amount;
                        Balance1 += "Bank Account Ledger Entry"."Amount (LCY)";

                        ShowHeader := FALSE;
                        CurrDate := NORMALDATE("Bank Account Ledger Entry"."Posting Date");
                    END;

                    GLAccountRec.RESET;
                    IF "Bank Account"."Global Dimension 1 Code" <> '' THEN
                        GLAccountRec.SETFILTER("Global Dimension 1 Filter", "Bank Account"."Global Dimension 1 Code");
                    GLAccountRec.SETRANGE(GLAccountRec."Date Filter", CurrDate);

                    IF GLAccountRec.GET("Bank Account Ledger Entry"."Bank Account No.") THEN BEGIN
                        GLAccountRec.CALCFIELDS(GLAccountRec."Balance at Date (LCY)", GLAccountRec."Balance at Date",
                                            GLAccountRec."Debit Amount (LCY)", GLAccountRec."Debit Amount",
                                            GLAccountRec."Credit Amount (LCY)", GLAccountRec."Credit Amount");

                        SumDay[3] := GLAccountRec."Balance at Date";
                        SumDay1[3] := GLAccountRec."Balance at Date (LCY)";
                    END;


                    IF ShowDayAmt OR (TheDate = 0D) THEN BEGIN
                        TheDate := "Bank Account Ledger Entry"."Posting Date";
                        SumDay[1] := "Bank Account Ledger Entry"."Debit Amount";
                        SumDay1[1] := "Bank Account Ledger Entry"."Debit Amount (LCY)";
                        SumDay[2] := "Bank Account Ledger Entry"."Credit Amount";
                        SumDay1[2] := "Bank Account Ledger Entry"."Credit Amount (LCY)";
                    END
                    ELSE BEGIN
                        SumDay[1] += "Bank Account Ledger Entry"."Debit Amount";
                        SumDay1[1] += "Bank Account Ledger Entry"."Debit Amount (LCY)";
                        SumDay[2] += "Bank Account Ledger Entry"."Credit Amount";
                        SumDay1[2] += "Bank Account Ledger Entry"."Credit Amount (LCY)";
                    END;

                    IF ShowMonthAmt OR (TheDate = 0D) THEN BEGIN
                        SumMonth[1] := "Bank Account Ledger Entry"."Debit Amount";
                        SumMonth1[1] := "Bank Account Ledger Entry"."Debit Amount (LCY)";
                        SumMonth[2] := "Bank Account Ledger Entry"."Credit Amount";
                        SumMonth1[2] := "Bank Account Ledger Entry"."Credit Amount (LCY)";
                    END
                    ELSE BEGIN
                        SumMonth[1] += "Bank Account Ledger Entry"."Debit Amount";
                        SumMonth1[1] += "Bank Account Ledger Entry"."Debit Amount (LCY)";
                        SumMonth[2] += "Bank Account Ledger Entry"."Credit Amount";
                        SumMonth1[2] += "Bank Account Ledger Entry"."Credit Amount (LCY)";
                    END;

                    IF ShowYearAmt OR (TheDate = 0D) THEN BEGIN
                        SumYear[1] := "Bank Account Ledger Entry"."Debit Amount";
                        SumYear1[1] := "Bank Account Ledger Entry"."Debit Amount (LCY)";
                        SumYear[2] := "Bank Account Ledger Entry"."Credit Amount";
                        SumYear1[2] := "Bank Account Ledger Entry"."Credit Amount (LCY)";
                    END
                    ELSE BEGIN
                        SumYear[1] += "Bank Account Ledger Entry"."Debit Amount";
                        SumYear1[1] += "Bank Account Ledger Entry"."Debit Amount (LCY)";
                        SumYear[2] += "Bank Account Ledger Entry"."Credit Amount";
                        SumYear1[2] += "Bank Account Ledger Entry"."Credit Amount (LCY)";
                    END;

                    IF Amount <> 0 THEN
                        rate := "Amount (LCY)" / Amount;

                    IF LCYAcct THEN BEGIN
                        DAmt := 0;
                        CAmt := 0;
                        SumDay[1] := 0;
                        SumMonth[1] := 0;
                        SumYear[1] := 0;
                        SumDay[2] := 0;
                        SumMonth[2] := 0;
                        SumYear[2] := 0;

                        rate := 0;
                    END
                    ELSE BEGIN
                        DAmt := "Bank Account Ledger Entry"."Debit Amount";
                        CAmt := "Bank Account Ledger Entry"."Credit Amount";
                    END;

                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Bank Account Ledger Entry"."Bank Account No.");

                    //CurrReport.CREATETOTALS(Balance2);
                    GLAccount.RESET;

                    IF "Bank Account"."No." <> '' THEN
                        GLAccount.SETFILTER(GLAccount."No.", "Bank Account"."No.");
                    IF "Bank Account"."Global Dimension 1 Code" <> '' THEN
                        GLAccount.SETFILTER("Global Dimension 1 Filter", "Bank Account"."Global Dimension 1 Code");
                    GLAccount.SETRANGE(GLAccount."Date Filter", 0D, (NORMALDATE("Bank Account Ledger Entry".GETRANGEMIN("Posting Date")) - 1));
                    IF GLAccount.FIND('-') THEN BEGIN
                        GLAccount.CALCFIELDS(GLAccount."Balance at Date", GLAccount."Balance at Date (LCY)");
                        FirstBalance := FirstBalance + GLAccount."Balance at Date";
                        FirstBalance1 := FirstBalance1 + GLAccount."Balance at Date (LCY)";
                    END;

                    GLAccount.RESET;

                    IF "Bank Account"."No." <> '' THEN
                        GLAccount.SETFILTER(GLAccount."No.", "Bank Account"."No.");
                    IF "Bank Account"."Global Dimension 1 Code" <> '' THEN
                        GLAccount.SETFILTER("Global Dimension 1 Filter", "Bank Account"."Global Dimension 1 Code");
                    GLAccount.SETRANGE(GLAccount."Date Filter", MinDate, MaxDate);

                    IF GLAccount.FIND('-') THEN BEGIN
                        GLAccount.CALCFIELDS(GLAccount."Net Change", GLAccount."Net Change (LCY)",
                                        GLAccount."Debit Amount (LCY)", GLAccount."Debit Amount",
                                        GLAccount."Credit Amount (LCY)", GLAccount."Credit Amount");

                        GLAccount.CALCFIELDS(GLAccount."Net Change", GLAccount."Net Change (LCY)",
                                        GLAccount."Debit Amount (LCY)",
                                        GLAccount."Credit Amount (LCY)");




                        SumMonth[3] += GLAccount."Net Change";
                        SumMonth1[3] += GLAccount."Net Change (LCY)";
                    END;

                    SumMonth[3] := FirstBalance + SumMonth[3];
                    SumMonth1[3] := FirstBalance1 + SumMonth1[3];
                    GLAccount.RESET;

                    IF "Bank Account"."No." <> '' THEN
                        GLAccount.SETFILTER(GLAccount."No.", "Bank Account"."No.");
                    IF "Bank Account"."Global Dimension 1 Code" <> '' THEN
                        GLAccount.SETFILTER("Global Dimension 1 Filter", "Bank Account"."Global Dimension 1 Code");
                    GLAccount.SETRANGE("Date Filter", CALCDATE('CY-1Y+1D', "Bank Account Ledger Entry".GETRANGEMAX("Posting Date")),
                                       "Bank Account Ledger Entry".GETRANGEMAX("Posting Date"));

                    IF GLAccount.FIND('-') THEN
                        REPEAT
                            GLAccount.CALCFIELDS(GLAccount."Balance at Date", GLAccount."Balance at Date (LCY)",
                                            GLAccount."Debit Amount (LCY)", GLAccount."Debit Amount",
                                            GLAccount."Credit Amount (LCY)", GLAccount."Credit Amount");

                            //GLAccount.CALCFIELDS(GLAccount."Net Change",GLAccount."Debit Amount",GLAccount."Credit Amount");
                            SumYear[3] += GLAccount."Balance at Date";
                            SumYear1[3] += GLAccount."Balance at Date (LCY)";
                        UNTIL GLAccount.NEXT = 0;

                    MyEntry.SETCURRENTKEY(MyEntry."Document No.", MyEntry."Posting Date");
                    CurrDocNo := '';

                    FOR i := 1 TO 2 DO BEGIN
                        SumDay[i] := 0;
                        SumDay1[i] := 0;
                        SumMonth[i] := 0;
                        SumMonth1[i] := 0;
                        SumYear[i] := 0;
                        SumYear1[i] := 0;
                    END;

                    Balance := 0;
                    Balance1 := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FirstBalance := 0;
                SumMonth[3] := 0;
                SumMonth[2] := 0;
                SumMonth[1] := 0;
                Balance := 0;
                SumYear[3] := 0;
                SumYear[2] := 0;
                SumYear[1] := 0;

                FirstBalance1 := 0;
                SumMonth1[3] := 0;
                SumMonth1[2] := 0;
                SumMonth1[1] := 0;
                Balance1 := 0;
                SumYear1[3] := 0;
                SumYear1[2] := 0;
                SumYear1[1] := 0;

                BankLedger.RESET;
                BankLedger.SETFILTER(BankLedger."Bank Account No.", "Bank Account"."No.");
                BankLedger.SETRANGE(BankLedger."Posting Date", MinDate, MaxDate);
                BankLedger.SETFILTER(BankLedger."Currency Code", "Bank Account Ledger Entry".GETFILTER("Currency Code"));
                BankLedger.SETFILTER("Global Dimension 1 Code", "Bank Account"."Global Dimension 1 Code");
                IF NOT BankLedger.FIND('-') THEN
                    CurrReport.SKIP;

                LCYAcct := FALSE;
                IF "Bank Account"."Currency Code" <> '' THEN
                    CurrCode := "Bank Account"."Currency Code"
                ELSE BEGIN
                    GLSetup.FIND('-');
                    CurrCode := GLSetup."LCY Code";
                    LCYAcct := TRUE;
                END;
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

    trigger OnPreReport()
    begin
        ShowHeader := TRUE;
        MinDate := "Bank Account Ledger Entry".GETRANGEMIN("Posting Date");
        MaxDate := "Bank Account Ledger Entry".GETRANGEMAX("Posting Date");
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total for ';
        Balance: Decimal;
        "Bal.AccountNo1": Code[20];
        Balance1: Decimal;
        MyEntry: Record "G/L Entry";
        Balance2: Decimal;
        Document1: Code[20];
        GLAccountRec: Record "Bank Account";
        RecCount: Integer;
        CurrDate: Date;
        GLAccount: Record "Bank Account";
        AccountDesc: Text[200];
        ShowHeader: Boolean;
        FirstBalance: Decimal;
        SumDay: array[3] of Decimal;
        SumMonth: array[3] of Decimal;
        SumYear: array[3] of Decimal;
        BlaAcc: Text[1024];
        i: Integer;
        CurrAccountNo: Code[20];
        FirstBalance1: Decimal;
        SumDay1: array[3] of Decimal;
        SumMonth1: array[3] of Decimal;
        SumYear1: array[3] of Decimal;
        BankLedger: Record "Bank Account Ledger Entry";
        rate: Decimal;
        MinDate: Date;
        MaxDate: Date;
        CurrDocNo: Text[30];
        TheDate: Date;
        ShowDayAmt: Boolean;
        ShowMonthAmt: Boolean;
        ShowYearAmt: Boolean;
        CurrCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        LCYAcct: Boolean;
        DAmt: Decimal;
        CAmt: Decimal;
        BankJnlCaptionLbl: Label '银行日记帐';
        PageNo_CaptionLbl: Label '页号(Page):';
        Bank_A_c_No__CaptionLbl: Label '银行科目编号:';
        Name_CaptionLbl: Label '名称:';
        Curr__Code_CaptionLbl: Label '货币 Curr. Code.:';
        CaptionLbl_Year: Label '年';
        CaptionLbl_Month: Label '月';
        CaptionLbl_Day: Label '日';
        EmptyStringCaptionLbl: Label '-';
        Caption_Control1000000183Lbl: Label 'Caption_Control1000000183Lbl';
        Caption_Control1000000185Lbl: Label 'Caption_Control1000000185Lbl';
        Caption_Control1000000187Lbl: Label 'Caption_Control1000000187Lbl';
        CExplanationCaptionLbl: Label '摘      要';
        CCorresponding_AccountsCaptionLbl: Label '对方科目';
        Credit_CaptionLbl: Label '借方';
        Debit_CaptionLbl: Label '贷方';
        CMonthCaption_Control1000000006Lbl: Label '月';
        CVoucherCaptionLbl: Label '凭证号';
        CDayCaption_Control1000000011Lbl: Label '日';
        BalanceCaptionLbl: Label '余额';
        MCaptionLbl: Label 'M';
        DCaptionLbl: Label 'D';
        VoucherCaptionLbl: Label '凭证号';
        ExplanationCaptionLbl: Label '摘      要';
        Corresponding_AccountsCaptionLbl: Label '对方科目';
        CreditForeignCaptionLbl: Label '外币';
        CExcRateCaptionLbl: Label '汇率';
        CreaditAmountCaptionLbl: Label '金额';
        DebitAmountCaption_Control1000000147Lbl: Label '外币';
        DebitForeignCaptionLbl: Label '金额';
        BalanceForeignCaption_Control1000000157Lbl: Label '外币';
        BalanceAmountCaption_Control1000000158Lbl: Label '金额';
        OpenBalanceCaptionLbl: Label 'OpenBalanceCaptionLbl';
        Page_Caption_Control1000000020Lbl: Label '­Page_Caption_Control1000000020Lbl(Page)';
        Caption_Control1000000014Lbl: Label 'Caption_Control1000000014Lbl';
        Caption_Control1000000043Lbl: Label 'Caption_Control1000000043Lbl';
        Caption_Control1000000048Lbl: Label 'Caption_Control1000000048Lbl';
        Caption_Control1000000049Lbl: Label 'Caption_Control1000000049Lbl';
        Caption_Control1000000082Lbl: Label 'Caption_Control1000000082Lbl';
        Caption_Control1000000084Lbl: Label 'Caption_Control1000000084Lbl';
        Caption_Control1000000085Lbl: Label 'Caption_Control1000000085Lbl';
        Caption_Control1000000086Lbl: Label 'Caption_Control1000000086Lbl';
        Caption_Control1000000087Lbl: Label 'Caption_Control1000000087Lbl';
        MCaption_Control1000000099Lbl: Label 'M';
        DCaption_Control1000000100Lbl: Label 'D';
        VoucherCaption_Control1000000101Lbl: Label 'VoucherCaption_Control1000000101Lbl';
        ExplanationCaption_Control1000000102Lbl: Label 'ExplanationCaption_Control1000000102Lbl';
        Corresponding_AccountsCaption_Control1000000103Lbl: Label 'Corresponding_AccountsCaption_Control1000000103Lbl';
        Caption_Control1000000104Lbl: Label 'Caption_Control1000000104Lbl­';
        Caption_Control1000000106Lbl: Label 'Caption_Control1000000106Lbl';
        Caption_Control1000000107Lbl: Label 'Caption_Control1000000107Lbl';
        Caption_Control1000000193Lbl: Label 'Caption_Control1000000193Lbl';
        Caption_Control1000000194Lbl: Label 'Caption_Control1000000194Lbl­';
        Caption_Control1000000196Lbl: Label 'Caption_Control1000000196Lbl­';
        Caption_Control1000000197Lbl: Label 'Caption_Control1000000197Lbl';
        Curr__Code_Caption_Control1000000114Lbl: Label 'Curr__Code_Caption_Control1000000114Lbl­ Curr. Code.';
        Bank_A_c_No__Caption_Control1000000009Lbl: Label 'Bank_A_c_No__Caption_Control1000000009Lbl:';
        Name_Caption_Control1000000117Lbl: Label 'Name_Caption_Control1000000117Lbl:';
        Caption_Control1000000235Lbl: Label 'Caption_Control1000000235Lbl';
        Caption_Control1000000237Lbl: Label 'Caption_Control1000000237Lbl';
        Caption_Control1000000239Lbl: Label 'Caption_Control1000000239Lbl';
        EmptyStringCaption_Control1000000240Lbl: Label '-';
        Caption_Control1000000242Lbl: Label 'Caption_Control1000000242Lbl';
        Caption_Control1000000244Lbl: Label 'Caption_Control1000000244Lbl';
        Caption_Control1000000246Lbl: Label 'Caption_Control1000000246Lbl';
        TotalDayCaptionLbl: Label '本日合计';
        TotalMonthCaptionLbl: Label '本月合计';
        TotalYearCaptionLbl: Label '本年合计';
}

