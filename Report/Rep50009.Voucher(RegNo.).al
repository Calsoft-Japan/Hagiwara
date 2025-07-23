report 50009 "Voucher (Reg No.)"
{
    // ´¨‰·€Ó¸Œ…”Œ—³š–Ž´ñ
    // *1 ESGSH.JR.1.0
    // CS092 FDD R050 Bobby.Ji 2025/7/22 - Upgade to the BC version

    //DefaultLayout = RDLC;
    //RDLCLayout = './RDLC/Voucher English.rdlc';
    DefaultRenderingLayout = "Voucher Chinese.rdlc";
    Caption = 'Voucher';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending);
            column(Number; Number)
            {
            }
            column(VOUCHERCaption; VOUCHERCaptionLbl)
            {
            }
            column(VOUCHERCaptionCN; VOUCHERCaptionCNLbl)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyNameCN; CompanyNameCNLbl)
            {
            }
            column(FORMAT_DateFilterMax_0___Year4___; FORMAT(DateFilterYear, 0, '<Year4>'))
            {
            }
            column(FORMAT_DateFilterMax_0___Month___; FORMAT(DateFilterMonth, 0, '<Month>'))
            {
            }
            column(FORMAT_DateFilterMax_0___Day___; FORMAT(DateFilterDay, 0, '<Day>'))
            {
            }
            column(TimeCaption; FORMAT(DateFilterYear, 0, '<Year4>') + '年' + FORMAT(DateFilterMonth, 0, '<Month,2>') + '月' + FORMAT(DateFilterDay, 0, '<Day>') + '日')
            {
            }
            column(Doc__No_Caption; Doc__No_CaptionLbl)
            {
            }
            column(Doc__No_CaptionCN; Doc__No_CaptionCNLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(PageCaptionCN; PageCaptionCNLbl)
            {
            }
            column(Reg__No__Caption; Reg__No__CaptionLbl)
            {
            }
            column(G_L_Entry__Posting_Date_Caption; GLEntry.FIELDCAPTION("Posting Date"))
            {
            }
            column(Amount__LCY_Caption; Amount__LCY_CaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(Account_CodeCaption; Account_CodeCaptionLbl)
            {
            }
            column(GenLegAcct_CodeCaption; GenLegAcct_CodeCaptionLbl)
            {
            }
            column(GenLegAcct_CodeCaptionCN; GenLegAcct_CodeCaptionCNLbl)
            {
            }
            column(ExplanationCaption; ExplanationCaptionLbl)
            {
            }
            column(ExplanationCaptionCN; ExplanationCaptionCNLbl)
            {
            }
            column(For_Cur_Amt_Caption; For_Cur_Amt_CaptionLbl)
            {
            }
            column(For_Cur_Amt_CaptionCN; For_Cur_Amt_CaptionCNLbl)
            {
            }
            column(For_Curr_Caption; For_Curr_CaptionLbl)
            {
            }
            column(For_Curr_CaptionCN; For_Curr_CaptionCNLbl)
            {
            }
            column(Exc_RatCaption; Exc_RatCaptionLbl)
            {
            }
            column(Exc_RatCaptionCN; Exc_RatCaptionCNLbl)
            {
            }
            column(CURCaption; CURCaptionLbl)
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_Caption; GLEntry.FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(G_L_Entry__Document_No___Caption; GLEntry.FIELDCAPTION("Document No."))
            {
            }
            column(G_L_Entry__Document_No__; DocumentNo)
            {
            }
            column(Pages; Pages)
            {
            }
            column(RegNo; RegNo)
            {
            }
            column(G_L_Entry__Posting_Date_; PostingDate)
            {
            }
            column(G_L_Entry_Description_1; Description[1])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_1; GlobalDimCode[1])
            {
            }
            column(G_L_Entry__Account_Description__1; AccountDesc[1])
            {
            }
            column(G_L_Entry__Account_No__1; AccountNo[1])
            {
            }
            column(G_L_Entry__Account_L_Name; ChineseAccountName)
            {
            }
            column(CurrCode_1; CurrCode[1])
            {
            }
            column(ForeignAmt_1; ForeignAmt[1])
            {
            }
            column(ExcRate_1; ExcRate[1])
            {
            }
            column(DebitAmount_1; DebitAmount[1])
            {
            }
            column(CreditAmount_1; CreditAmount[1])
            {
            }
            column(G_L_Entry_Description_2; Description[2])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_2; GlobalDimCode[2])
            {
            }
            column(G_L_Entry__Account_Description__2; AccountDesc[2])
            {
            }
            column(G_L_Entry__Account_No__2; AccountNo[2])
            {
            }
            column(CurrCode_2; CurrCode[2])
            {
            }
            column(ForeignAmt_2; ForeignAmt[2])
            {
            }
            column(ExcRate_2; ExcRate[2])
            {
            }
            column(DebitAmount_2; DebitAmount[2])
            {
            }
            column(CreditAmount_2; CreditAmount[2])
            {
            }
            column(G_L_Entry_Description_3; Description[3])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_3; GlobalDimCode[3])
            {
            }
            column(G_L_Entry__Account_Description__3; AccountDesc[3])
            {
            }
            column(G_L_Entry__Account_No__3; AccountNo[3])
            {
            }
            column(CurrCode_3; CurrCode[3])
            {
            }
            column(ForeignAmt_3; ForeignAmt[3])
            {
            }
            column(ExcRate_3; ExcRate[3])
            {
            }
            column(DebitAmount_3; DebitAmount[3])
            {
            }
            column(CreditAmount_3; CreditAmount[3])
            {
            }
            column(G_L_Entry_Description_4; Description[4])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_4; GlobalDimCode[4])
            {
            }
            column(G_L_Entry__Account_Description__4; AccountDesc[4])
            {
            }
            column(G_L_Entry__Account_No__4; AccountNo[4])
            {
            }
            column(CurrCode_4; CurrCode[4])
            {
            }
            column(ForeignAmt_4; ForeignAmt[4])
            {
            }
            column(ExcRate_4; ExcRate[4])
            {
            }
            column(DebitAmount_4; DebitAmount[4])
            {
            }
            column(CreditAmount_4; CreditAmount[4])
            {
            }
            column(G_L_Entry_Description_5; Description[5])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_5; GlobalDimCode[5])
            {
            }
            column(G_L_Entry__Account_Description__5; AccountDesc[5])
            {
            }
            column(G_L_Entry__Account_No__5; AccountNo[5])
            {
            }
            column(CurrCode_5; CurrCode[5])
            {
            }
            column(ForeignAmt_5; ForeignAmt[5])
            {
            }
            column(ExcRate_5; ExcRate[5])
            {
            }
            column(DebitAmount_5; DebitAmount[5])
            {
            }
            column(CreditAmount_5; CreditAmount[5])
            {
            }
            column(SourceName; SourceName)
            {
            }
            column(G_L_Entry_Description_6; Description[6])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_6; GlobalDimCode[6])
            {
            }
            column(G_L_Entry__Account_Description__6; AccountDesc[6])
            {
            }
            column(G_L_Entry__Account_No__6; AccountNo[6])
            {
            }
            column(CurrCode_6; CurrCode[6])
            {
            }
            column(ForeignAmt_6; ForeignAmt[6])
            {
            }
            column(ExcRate_6; ExcRate[6])
            {
            }
            column(DebitAmount_6; DebitAmount[6])
            {
            }
            column(CreditAmount_6; CreditAmount[6])
            {
            }
            column(G_L_Entry_Description_7; Description[7])
            {
            }
            column(G_L_Entry__Global_Dimension_1_Code_7; GlobalDimCode[7])
            {
            }
            column(G_L_Entry__Account_Description__7; AccountDesc[7])
            {
            }
            column(G_L_Entry__Account_No__7; AccountNo[7])
            {
            }
            column(CurrCode_7; CurrCode[7])
            {
            }
            column(ForeignAmt_7; ForeignAmt[7])
            {
            }
            column(ExcRate_7; ExcRate[7])
            {
            }
            column(DebitAmount_7; DebitAmount[7])
            {
            }
            column(CreditAmount_7; CreditAmount[7])
            {
            }
            column(TotalDebit; TotalDebit2)
            {
            }
            column(TotalCredit; TotalCredit2)
            {
            }
            column(TotalFor___FIELDCAPTION__Document_No___; TotalFor + GLEntry.FIELDCAPTION("Document No."))
            {
            }
            column(TotalFor___FIELDCAPTION__Document_No_CN; '人民币大写金额：   零元整')
            {
            }
            column(User; User)
            {
            }
            column(Manager__Caption; Manager__CaptionLbl)
            {
            }
            column(Manager__CaptionCN; Manager__CaptionCNLbl)
            {
            }
            column(Checked__CaptionCN; Checked__CaptionCNLbl)
            {
            }
            column(Checked__Caption; Checked__CaptionLbl)
            {
            }
            column(Prepared__Caption; Prepared__CaptionLbl)
            {
            }
            column(Prepared__CaptionCN; Prepared__CaptionCNLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                CustLE: Record "Cust. Ledger Entry";
                VendorLE: Record "Vendor Ledger Entry";
                BankLE: Record "Bank Account Ledger Entry";
                GLRegister: Record "G/L Register";
                DimensionValue: Record "Dimension Value";
                DimensionSetEntry: Record "Dimension Set Entry";
                Vendor: Record Vendor;
                Customer: Record Customer;
                Glob1Text: Text[50];
                Glob2Text: Text[50];
                Project: Text[50];
                Employee: Text[50];
                i: Integer;
            begin
                IF Last THEN
                    CurrReport.BREAK;

                PageNo += 1;
                IF NextDoc THEN BEGIN
                    NextDoc := FALSE;
                    TotalDebit := 0;
                    TotalCredit := 0;
                    PageNo := 1;
                    GLEntry.FILTERGROUP(1);
                    GLEntry.SETRANGE("Document No.", GLEntry."Document No.");
                    PageQty := (GLEntry.COUNT DIV 7) + 1;
                    GLEntry.SETRANGE("Document No.");
                    GLEntry.FILTERGROUP(0);
                END;

                CLEAR(Description);
                CLEAR(GlobalDimCode);
                CLEAR(AccountDesc);
                CLEAR(AccountNo);
                CLEAR(CurrCode);
                CLEAR(ForeignAmt);
                CLEAR(ExcRate);
                CLEAR(DebitAmount);
                CLEAR(CreditAmount);
                i := 1;
                DocumentNo := GLEntry."Document No.";
                PostingDate := GLEntry."Posting Date";
                Pages := FORMAT(PageNo) + ' - ' + FORMAT(PageQty);
                GLRegister.RESET;
                GLRegister.SETFILTER("From Entry No.", '<=%1', GLEntry."Entry No.");
                GLRegister.SETFILTER("To Entry No.", '>=%1', GLEntry."Entry No.");
                IF GLRegister.FINDFIRST THEN
                    RegNo := GLRegister."No.";

                REPEAT
                    Glob1Text := '';
                    Glob2Text := '';
                    Employee := '';
                    Project := '';

                    IF DimensionValue.GET('REGION', GLEntry."Global Dimension 1 Code") THEN
                        Glob1Text := DimensionValue.Name;
                    IF DimensionValue.GET('UNIT', GLEntry."Global Dimension 2 Code") THEN
                        Glob2Text := DimensionValue.Name;
                    IF DimensionSetEntry.GET(GLEntry."Dimension Set ID", 'EMPLOYEE') THEN
                        IF DimensionValue.GET('EMPLOYEE', DimensionSetEntry."Dimension Value Code") THEN
                            Employee := DimensionValue.Name;
                    IF DimensionSetEntry.GET(GLEntry."Dimension Set ID", 'PROJECT') THEN
                        IF DimensionValue.GET('PROJECT', DimensionSetEntry."Dimension Value Code") THEN
                            Project := DimensionValue.Name;

                    User := GLEntry."User ID";
                    ForeignAmt[i] := 0;
                    CurrCode[i] := '';
                    ExcRate[i] := 0;
                    ChineseAccountName := GLEntry."Chinese Account Name";
                    //bobby FDDR050 07/23/2025 BEGIN
                    IF GLEntry."Source Type" = GLEntry."Source Type"::Vendor then begin
                        Vendor.Get(GLEntry."Source No.");
                        SourceName := Vendor.Name;
                    end else IF GLEntry."Source Type" = GLEntry."Source Type"::Customer then begin
                        Customer.Get(GLEntry."Source No.");
                        SourceName := Customer.Name;
                    end;
                    //bobby FDDR050 07/23/2025 END
                    IF GLEntry."Bal. Account Type" IN
                      [GLEntry."Bal. Account Type"::Customer, GLEntry."Bal. Account Type"::Vendor, GLEntry."Bal. Account Type"::"Bank Account"]
                    THEN BEGIN
                        CASE GLEntry."Bal. Account Type" OF
                            GLEntry."Bal. Account Type"::Customer:
                                BEGIN
                                    CustLE.RESET;
                                    CustLE.SETRANGE(CustLE."Transaction No.", GLEntry."Transaction No.");
                                    IF CustLE.FINDFIRST THEN
                                        IF CustLE."Currency Code" <> '' THEN BEGIN
                                            CustLE.CALCFIELDS(Amount, "Amount (LCY)");
                                            ForeignAmt[i] := ABS(CustLE.Amount);
                                            CurrCode[i] := CustLE."Currency Code";
                                            ExcRate[i] := CustLE."Amount (LCY)" / CustLE.Amount;
                                        END;
                                END;
                            GLEntry."Bal. Account Type"::Vendor:
                                BEGIN
                                    VendorLE.RESET;
                                    VendorLE.SETRANGE(VendorLE."Transaction No.", GLEntry."Transaction No.");
                                    IF VendorLE.FINDFIRST THEN
                                        IF VendorLE."Currency Code" <> '' THEN BEGIN
                                            VendorLE.CALCFIELDS(Amount, "Amount (LCY)");
                                            ForeignAmt[i] := ABS(VendorLE.Amount);
                                            CurrCode[i] := VendorLE."Currency Code";
                                            ExcRate[i] := VendorLE."Amount (LCY)" / VendorLE.Amount;
                                        END;
                                END;
                            GLEntry."Bal. Account Type"::"Bank Account":
                                BEGIN
                                    BankLE.RESET;
                                    BankLE.SETRANGE(BankLE."Transaction No.", GLEntry."Transaction No.");
                                    IF BankLE.FINDFIRST THEN
                                        IF BankLE."Currency Code" <> '' THEN BEGIN
                                            ForeignAmt[i] := ABS(BankLE.Amount);
                                            CurrCode[i] := BankLE."Currency Code";
                                            ExcRate[i] := BankLE."Amount (LCY)" / BankLE.Amount;
                                        END;
                                END;
                        END;
                    END;

                    Description[i] := GLEntry.Description;
                    GlobalDimCode[i] := GLEntry."Global Dimension 1 Code";
                    AccountDesc[i] := GetChineseDesc(GLEntry."G/L Account No.");
                    AccountNo[i] := GLEntry."G/L Account No." + Glob1Text + Glob2Text + Employee + Project;
                    DebitAmount[i] := GLEntry."Debit Amount";
                    CreditAmount[i] := GLEntry."Credit Amount";
                    TotalDebit += GLEntry."Debit Amount";
                    TotalCredit += GLEntry."Credit Amount";
                    i += 1;
                    IF GLEntry.NEXT = 0 THEN BEGIN
                        Last := TRUE;
                        NextDoc := TRUE;
                    END ELSE
                        IF (GLEntry."Document No." <> DocumentNo) THEN
                            NextDoc := TRUE;
                UNTIL NextDoc OR (i > 7);

                IF NextDoc THEN BEGIN
                    TotalDebit2 := TotalDebit;
                    TotalCredit2 := TotalCredit;
                END ELSE BEGIN
                    TotalDebit2 := 0;
                    TotalCredit2 := 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF NOT GLEntry.FINDSET THEN
                    CurrReport.QUIT;

                NextDoc := TRUE;
            end;
        }
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date");
            RequestFilterFields = "Document No.", "Posting Date";

            trigger OnPreDataItem()
            begin
                CurrReport.BREAK;
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
    rendering
    {
        layout("Voucher Chinese.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Voucher Chinese.rdlc';
            Caption = 'Voucher Chinese';
        }
        layout("Voucher English.rdlc")
        {
            Type = RDLC;
            LayoutFile = './RDLC/Voucher English.rdlc';
            Caption = 'Voucher English';
        }

    }
    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.COPYFILTERS("G/L Entry");
        /*
        DateFilterYear := Date2DMY(PostingDate, 3);
        DateFilterMonth := Date2DMY(PostingDate, 2);
        DateFilterDay := Date2DMY(PostingDate, 1);
        Evaluate(DateFilterDay, CopyStr(PostingDate, 1, 2));
        */
    end;

    var
        CompanyInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        DocumentNo: Code[20];
        Pages: Text;
        PageNo: Integer;
        PageQty: Integer;
        RegNo: Integer;
        PostingDate: Date;
        TotalFor: Label 'Total for ';
        VOUCHERCaptionLbl: Label 'VOUCHER';
        VOUCHERCaptionCNLbl: Label '记帐凭证';
        CompanyNameCNLbl: Label '公司名称';
        Doc__No_CaptionLbl: Label 'Doc. No.';
        Doc__No_CaptionCNLbl: Label '凭证编号:';
        PageCaptionLbl: Label 'Page';
        PageCaptionCNLbl: Label '页数:';
        Reg__No__CaptionLbl: Label 'Reg. No.:';
        Amount__LCY_CaptionLbl: Label 'Amount (LCY)';
        Amount__LCY_CaptionCNLbl: Label '本币金额 Amount (LCY)';
        CreditCaptionLbl: Label 'Credit';
        CreditCaptionCNLbl: Label '贷方';
        DebitCaptionLbl: Label 'Debit';
        DebitCaptionCNLbl: Label '借方';
        GenLegAcct_CodeCaptionLbl: Label 'Gen.Leg.Acct.';
        GenLegAcct_CodeCaptionCNLbl: Label '科目';
        Account_CodeCaptionLbl: Label 'Account Code';
        ExplanationCaptionLbl: Label 'Explanation';
        ExplanationCaptionCNLbl: Label '摘      要';
        For_Curr_CaptionLbl: Label 'For.Curr.';
        For_Curr_CaptionCNLbl: Label '外币';
        For_Cur_Amt_CaptionLbl: Label 'For.Cur Amt.';
        For_Cur_Amt_CaptionCNLbl: Label '外币金额';
        Exc_RatCaptionLbl: Label 'Exc.Rat';
        Exc_RatCaptionCNLbl: Label '汇率';
        CURCaptionLbl: Label 'CUR';
        Manager__CaptionLbl: Label '(Manager):';
        Manager__CaptionCNLbl: Label '会计主管:';
        Checked__CaptionLbl: Label '(Checked):';
        Checked__CaptionCNLbl: Label '复核:';
        Prepared__CaptionLbl: Label '(Prepared):';
        Prepared__CaptionCNLbl: Label '制单:';
        Description: array[7] of Text;
        GlobalDimCode: array[7] of Code[10];
        AccountDesc: array[7] of Text;
        AccountNo: array[7] of Text;
        CurrCode: array[7] of Code[10];
        ForeignAmt: array[7] of Decimal;
        ExcRate: array[7] of Decimal;
        DebitAmount: array[7] of Decimal;
        CreditAmount: array[7] of Decimal;
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        TotalDebit2: Decimal;
        TotalCredit2: Decimal;
        User: Code[20];
        NextDoc: Boolean;
        Last: Boolean;
        DateFilterYear: Date;
        DateFilterMonth: Date;
        DateFilterDay: Date;
        ChineseAccountName: Text[50];
        SourceName: Text[100];

    procedure GetChineseDesc("Account No": Code[20]): Text[100]
    var
        GLAccount: Record "G/L Account";
    begin
        IF "Account No" <> '' THEN BEGIN
            GLAccount.GET("Account No");
            EXIT(GLAccount.Name);
        END;
    end;
}

