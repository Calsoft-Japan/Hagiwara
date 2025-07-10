report 50006 "Detail General Ledger"
{
    // Error to set myEntry as Temporary table which will only include the structure of table, not data.
    // 
    // #ESGEW01  20031026
    //   Update the field Month No of the table G/L Entry,set it to the month of the field posting date.
    // CS092 Bobby.Ji 2025/6/16 - Upgade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/DetailGeneralLedger.rdlc';
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Detail General Ledger';
    ApplicationArea = All;
    //PaperSize = A4 210 x 297 mm;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Account Type" = FILTER(Posting));
            RequestFilterFields = "No.", "Global Dimension 1 Filter";
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("Posting Date");
                RequestFilterFields = "Posting Date", "Document No.";
                column(G_L_Account__No___15; "G/L Account"."No.")
                {
                }
                column(Entry_No__; "Entry No.")
                {
                }
                column(G_L_Entry__Posting_Date__17; "Posting Date")
                {
                }
                column(G_L_EntryHeader2SectionVisible; G_L_EntryHeader2SectionVisible)
                {
                }
                column(Caption; CaptionLbl)
                {
                }
                column(ComName; ComName)
                {
                }
                column(FORMAT_MinDate_0__Year4__; FORMAT(MinDate, 0, '<Year4>'))
                {
                }
                column(Caption_Control1000000152; Caption_Control1000000152Lbl)
                {
                }
                column(FORMAT_MinDate_0__Month_2__; FORMAT(MinDate, 0, '<Month,2>'))
                {
                }
                column(Caption_Control1000000154; Caption_Control1000000154Lbl)
                {
                }
                column(FORMAT_MinDate_0__Day__; FORMAT(MinDate, 0, '<Day>'))
                {
                }
                column(Caption_Control1000000156; Caption_Control1000000156Lbl)
                {
                }
                column(FORMAT_MaxDate_0__Year4__; FORMAT(MaxDate, 0, '<Year4>'))
                {
                }
                column(Caption_Control1000000158; Caption_Control1000000152Lbl)
                {
                }
                column(FORMAT_MaxDate_0__Month_2__; FORMAT(MaxDate, 0, '<Month,2>'))
                {
                }
                column(Caption_Control1000000160; Caption_Control1000000154Lbl)
                {
                }
                column(FORMAT_MaxDate_0__Day__; FORMAT(MaxDate, 0, '<Day>'))
                {
                }
                column(Caption_Control1000000163; Caption_Control1000000156Lbl)
                {
                }
                column(AccountDesc; AccountDesc)
                {
                }
                column(Caption_Control1000000169; Caption_Control1000000169Lbl)
                {
                }
                column(Page__Caption; Page__CaptionLbl)
                {
                }
                column(Caption_Control1000000172; CaptionLbl)
                {
                }
                column(MCaption; MCaptionLbl)
                {
                }
                column(Caption_Control1000000174; CaptionLbl)
                {
                }
                column(DCaption; DCaptionLbl)
                {
                }
                column(Caption_Control1000000176; Caption_Control1000000176Lbl)
                {
                }
                column(VoucherCaption; VoucherCaptionLbl)
                {
                }
                column(S________Caption; S________CaptionLbl)
                {
                }
                column(ExplanationCaption; ExplanationCaptionLbl)
                {
                }
                column(Caption_Control1000000180; Caption_Control1000000180Lbl)
                {
                }
                column(DebitCaption; DebitCaptionLbl)
                {
                }
                column(Caption_Control1000000182; Caption_Control1000000182Lbl)
                {
                }
                column(CreditCaption; CreditCaptionLbl)
                {
                }
                column(Caption_Control1000000184; Caption_Control1000000184Lbl)
                {
                }
                column(BalanceCaption; BalanceCaptionLbl)
                {
                }
                column(G_L_Account___No___; "G/L Account"."No.")
                {
                }
                column(CHSCaption; CHSCaptionLbl)
                {
                }
                column(DirCaption; DirCaptionLbl)
                {
                }
                column(S__Caption; S__CaptionLbl)
                {
                }
                column(Caption_Control1000000202; Caption_Control1000000202Lbl)
                {
                }
                column(FirstBalanceShow; FirstBalanceShow)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(FirstBalanceDirection; FirstBalanceDirection)
                {
                }
                column(Credit_Amount__; "Credit Amount")
                {
                }
                column(Debit_Amount__; "Debit Amount")
                {
                }
                column(Description; Description)
                {
                }
                column(G_L_Entry___Document_No___; "G/L Entry"."Document No.")
                {
                }
                column(FORMAT__Posting_Date__0__Day__; FORMAT("Posting Date", 0, '<Day>'))
                {
                }
                column(FORMAT__Posting_Date__0__Month__; FORMAT("Posting Date", 0, '<Month>'))
                {
                }
                column(Balance2Show; Balance2Show)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Balance2Direction; Balance2Direction)
                {
                }
                dataitem(SumSection; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(SumSection_Number_2000000026; Number)
                    {
                    }
                    column(Integer_Caption; Integer_CaptionLbl)
                    {
                    }
                    column(SumMonth_1_; SumMonth[1])
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(SumMonth_2_; SumMonth[2])
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(Balance2Show_Control1000000120; Balance2Show)
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(SumYear_2_; SumYear[2])
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(SumYear_1_; SumYear[1])
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(SumYear_3_; SumYear[3])
                    {
                        DecimalPlaces = 2 : 2;
                    }
                    column(Integer_Caption_Control1000000143; Integer_Caption_Control1000000143Lbl)
                    {
                    }
                    column(ShowMonthAmt; ShowMonthAmt)
                    {
                    }
                    column(ShowYearAmt; ShowYearAmt)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ShowDayAmt := FALSE;
                        ShowMonthAmt := FALSE;
                        ShowYearAmt := FALSE;

                        IF ("G/L Entry".NEXT <> 0) THEN BEGIN
                            IF ("G/L Entry"."Posting Date" <> TheDate) THEN
                                ShowDayAmt := TRUE;

                            IF FORMAT("G/L Entry"."Posting Date", 0, '<Month>') <> FORMAT(TheDate, 0, '<Month>') THEN
                                ShowMonthAmt := TRUE;

                            IF FORMAT("G/L Entry"."Posting Date", 0, '<Year>') <> FORMAT(TheDate, 0, '<Year>') THEN
                                ShowYearAmt := TRUE;

                            "G/L Entry".NEXT(-1);
                        END
                        ELSE
                            IF TheDate <> 0D THEN BEGIN
                                ShowDayAmt := TRUE;
                                ShowMonthAmt := TRUE;
                                ShowYearAmt := TRUE;
                            END;

                        //code from sections
                        //Body1Section
                        SumSectionBody1SectionVisible := (ShowMonthAmt);
                        //Body2Section
                        SumSectionBody2SectionVisible := (ShowYearAmt);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SumSection.SETRANGE(Number, 1, 1);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF ("Source Code" = 'Purchase') AND (STRPOS("G/L Account No.", '1201') = 1) AND
                       (("Document Type" = "G/L Entry"."Document Type"::Invoice) OR ("Document Type" = "G/L Entry"."Document Type"::"Credit Memo")) AND
                       ((STRPOS("Document No.", 'PPM') = 1) OR (STRPOS("Document No.", 'PPI') = 1) OR
                        (STRPOS("Document No.", 'NPPM') = 1) OR (STRPOS("Document No.", 'NPPI') = 1) OR
                        (STRPOS("Document No.", 'JPPI') = 1) OR (STRPOS("Document No.", 'JPPM') = 1) OR
                        (STRPOS("Document No.", 'HPPI') = 1) OR (STRPOS("Document No.", 'HPPM') = 1) OR
                        (STRPOS("Document No.", 'EPPI') = 1) OR (STRPOS("Document No.", 'EPPM') = 1)) THEN BEGIN

                        "Debit Amount" := "Credit Amount";
                        "Credit Amount" := 0;

                        SumYear[1] += "Debit Amount";
                        SumYear[2] -= "Credit Amount";
                    END;

                    Balance2 := 0;
                    Balance := Balance + "G/L Entry".Amount;
                    Balance2 := Balance + FirstBalance;
                    ShowHeader := FALSE;

                    IF ShowDayAmt OR (TheDate = 0D) THEN BEGIN
                        TheDate := "G/L Entry"."Posting Date";
                        SumDay[1] := "G/L Entry"."Debit Amount";
                        SumDay[2] := "G/L Entry"."Credit Amount";
                    END
                    ELSE BEGIN
                        SumDay[1] += "G/L Entry"."Debit Amount";
                        SumDay[2] += "G/L Entry"."Credit Amount";
                    END;

                    IF ShowMonthAmt OR (TheDate = 0D) THEN BEGIN
                        SumMonth[1] := "G/L Entry"."Debit Amount";
                        SumMonth[2] := "G/L Entry"."Credit Amount";
                    END
                    ELSE BEGIN
                        SumMonth[1] += "G/L Entry"."Debit Amount";
                        SumMonth[2] += "G/L Entry"."Credit Amount";
                    END;

                    IF ShowYearAmt OR (TheDate = 0D) THEN BEGIN
                        SumYear[1] := "G/L Entry"."Debit Amount";
                        SumYear[2] := "G/L Entry"."Credit Amount";
                    END
                    ELSE BEGIN
                        SumYear[1] += "G/L Entry"."Debit Amount";
                        SumYear[2] += "G/L Entry"."Credit Amount";
                    END;

                    //code from sections
                    //Header2Section
                    //#ESGEW 01 START
                    //G_L_EntryHeader2SectionVisible := (CurrReport.PAGENO = 1);
                    //#ESGEW 01 END

                    IF FirstBalance < 0 THEN BEGIN
                        FirstBalanceDirection := TEXT002;
                        FirstBalanceShow := -FirstBalance;
                    END
                    ELSE IF FirstBalance = 0 THEN BEGIN
                        FirstBalanceDirection := TEXT003;
                        FirstBalanceShow := 0;
                    END
                    ELSE BEGIN
                        FirstBalanceDirection := TEXT001;
                        FirstBalanceShow := FirstBalance;
                    END;
                    //Body3Section
                    IF Balance2 < 0 THEN BEGIN
                        Balance2Show := -Balance2;
                        Balance2Direction := TEXT002;
                    END
                    ELSE IF Balance2 = 0 THEN BEGIN
                        Balance2Direction := TEXT003;
                        Balance2Show := 0;
                    END
                    ELSE BEGIN
                        Balance2Direction := TEXT001;
                        Balance2Show := Balance2;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("G/L Account No.");

                    GLAccount.RESET;
                    IF "G/L Account"."No." <> '' THEN
                        GLAccount.SETFILTER(GLAccount."No.", "G/L Account"."No.");

                    GLAccount.SETRANGE(GLAccount."Date Filter", 0D, (NORMALDATE("G/L Entry".GETRANGEMIN("Posting Date")) - 1));
                    GLAccount.SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("G/L Account"."Global Dimension 1 Filter"));

                    IF GLAccount.FIND('-') THEN BEGIN
                        GLAccount.CALCFIELDS(GLAccount."Balance at Date");
                        FirstBalance := FirstBalance + GLAccount."Balance at Date";
                    END;

                    GLAccount.RESET;

                    IF "G/L Account"."No." <> '' THEN
                        GLAccount.SETFILTER(GLAccount."No.", "G/L Account"."No.");
                    GLAccount.SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("G/L Account"."Global Dimension 1 Filter"));

                    GLAccount.SETRANGE(GLAccount."Date Filter", MinDate, MaxDate);
                    IF GLAccount.FIND('-') THEN BEGIN
                        GLAccount.CALCFIELDS(GLAccount."Net Change", GLAccount."Debit Amount", GLAccount."Credit Amount");
                        SumMonth[3] += FirstBalance + GLAccount."Net Change";
                    END;

                    GLAccount.RESET;

                    IF "G/L Account"."No." <> '' THEN
                        GLAccount.SETFILTER(GLAccount."No.", "G/L Account"."No.");
                    GLAccount.SETFILTER("Global Dimension 1 Filter", "G/L Account".GETFILTER("G/L Account"."Global Dimension 1 Filter"));

                    GLAccount.SETRANGE("Date Filter", CALCDATE('CY-1Y+1D', "G/L Entry".GETRANGEMAX("Posting Date")),
                                       "G/L Entry".GETRANGEMAX("Posting Date"));

                    IF GLAccount.FIND('-') THEN BEGIN
                        GLAccount.CALCFIELDS(GLAccount."Balance at Date", GLAccount."Debit Amount", GLAccount."Credit Amount");
                        SumYear[3] += GLAccount."Balance at Date";
                    END;

                    CurrDocNo := '';
                    SumDay[1] := 0;
                    SumDay[2] := 0;
                    SumDay[3] := 0;
                    Balance := 0;

                    "G/L Entry".SETFILTER("Global Dimension 1 Code", "G/L Account".GETFILTER("G/L Account"."Global Dimension 1 Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            begin
                FirstBalance := 0;
                Balance := 0;

                FOR i := 1 TO 3 DO BEGIN
                    SumDay[i] := 0;
                    SumMonth[i] := 0;
                    SumYear[i] := 0;
                END;

                MyEntry.RESET;
                MyEntry.SETRANGE(MyEntry."Posting Date", MinDate, MaxDate);
                MyEntry.SETFILTER(MyEntry."G/L Account No.", "G/L Account"."No.");
                IF NOT MyEntry.FIND('-') THEN
                    CurrReport.SKIP;

                AccountDesc := "G/L Account".Name;
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
        //#ESGEW01 START
        //REPORT.RUNMODAL(REPORT::"Create Month for G/L Entry");
        //#ESGEW01 END
    end;

    trigger OnPreReport()
    begin
        ShowHeader := TRUE;

        MinDate := NORMALDATE("G/L Entry".GETRANGEMIN("G/L Entry"."Posting Date"));
        MaxDate := NORMALDATE("G/L Entry".GETRANGEMAX("G/L Entry"."Posting Date"));

        CompanyInfo.FIND('-');
        ComName := CompanyInfo.Name;
    end;

    var
        G_L_EntryHeader2SectionVisible: Boolean;
        SumSectionBody1SectionVisible: Boolean;
        SumSectionBody2SectionVisible: Boolean;
        CaptionLbl: Label '明细帐';
        Caption_Control1000000152Lbl: Label '年';
        Caption_Control1000000154Lbl: Label '月';
        Caption_Control1000000156Lbl: Label '日';
        Caption_Control1000000169Lbl: Label '会计科目';
        Page__CaptionLbl: Label '页号(Page)';
        MCaptionLbl: Label 'M';
        DCaptionLbl: Label 'D';
        Caption_Control1000000176Lbl: Label '凭证号';
        VoucherCaptionLbl: Label 'Voucher';
        S________CaptionLbl: Label '摘        要';
        ExplanationCaptionLbl: Label 'Explanation';
        Caption_Control1000000180Lbl: Label '借方';
        DebitCaptionLbl: Label 'Debit';
        Caption_Control1000000182Lbl: Label '贷方';
        CreditCaptionLbl: Label 'Credit';
        Caption_Control1000000184Lbl: Label '余额';
        BalanceCaptionLbl: Label 'Balance';
        CHSCaptionLbl: Label '方向';
        DirCaptionLbl: Label 'Dir';
        S__CaptionLbl: Label '--';
        Caption_Control1000000202Lbl: Label '期初余额';
        Integer_CaptionLbl: Label '本月合计 Integer';
        Integer_Caption_Control1000000143Lbl: Label '本年累计 Integer';
        LastFieldNo: Integer;
        Balance: Decimal;
        MyEntry: Record "G/L Entry";
        Balance2: Decimal;
        CurrDocNo: Code[20];
        GLAccount: Record "G/L Account";
        AccountDesc: Text[200];
        ShowHeader: Boolean;
        FirstBalance: Decimal;
        SumDay: array[3] of Decimal;
        SumMonth: array[3] of Decimal;
        SumYear: array[3] of Decimal;
        MinDate: Date;
        MaxDate: Date;
        TEXT001: Label '借';
        TEXT002: Label '贷';
        TEXT003: Label '平';
        FirstBalanceDirection: Text[2];
        Balance2Direction: Text[2];
        Balance2Show: Decimal;
        FirstBalanceShow: Decimal;
        ComName: Text[50];
        CompanyInfo: Record "Company Information";
        ShowDayAmt: Boolean;
        ShowMonthAmt: Boolean;
        ShowYearAmt: Boolean;
        i: Integer;
        TheDate: Date;
}

