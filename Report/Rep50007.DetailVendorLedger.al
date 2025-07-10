report 50007 "Detail Vendor Ledger"
{
    // Error to set myEntry as Temporary table which will only include the structure of table, not data.
    // 
    // #ESGEW01  20031026
    //   Update the field Month No of the table G/L Entry,set it to the month of the field posting date.
    // CS092 Bobby.Ji 2025/6/17 - Upgade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/DetailVendorLedger.rdlc';

    Caption = 'Detail Vendor Ledger';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //PaperSize = A4 210 x 297 mm;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(Vendor__No___23; "No.")
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(For__Curr__Caption; For__Curr__CaptionLbl)
            {
            }
            column(ExplanationCaption; ExplanationCaptionLbl)
            {
            }
            column(VoucherCaption; VoucherCaptionLbl)
            {
            }
            column(DCaption; DCaptionLbl)
            {
            }
            column(MCaption; MCaptionLbl)
            {
            }
            column(Caption; CaptionLbl)
            {
            }
            column(CHSCaption; CHSCaptionLbl)
            {
            }
            column(DirCaption; DirCaptionLbl)
            {
            }
            column(Credit_Caption; Credit_CaptionLbl)
            {
            }
            column(Debit_Caption; Debit_CaptionLbl)
            {
            }
            column(S________Caption; S________CaptionLbl)
            {
            }
            column(Caption_Control1000000098; Caption_Control1000000098Lbl)
            {
            }
            column(Caption_Control1000000102; Caption_Control1000000102Lbl)
            {
            }
            column(Caption_Control1000000103; Caption_Control1000000103Lbl)
            {
            }
            column(Vendor_Name; Vendor.Name)
            {
            }
            column(VendorCaption; VendorCaptionLbl)
            {
            }
            column(Page__Caption; Page__CaptionLbl)
            {
            }
            column(Caption_Control1000000112; Caption_Control1000000102Lbl)
            {
            }
            column(FORMAT_MaxDate_0__Day__; FORMAT(MaxDate, 0, '<Day>'))
            {
            }
            column(Caption_Control1000000114; Caption_Control1000000103Lbl)
            {
            }
            column(FORMAT_MaxDate_0__Month_2__; FORMAT(MaxDate, 0, '<Month,2>'))
            {
            }
            column(Caption_Control1000000119; Caption_Control1000000104Lbl)
            {
            }
            column(FORMAT_MaxDate_0__Year4__; FORMAT(MaxDate, 0, '<Year4>'))
            {
            }
            column(S_Caption; S_CaptionLbl)
            {
            }
            column(Caption_Control1000000142; Caption_Control1000000102Lbl)
            {
            }
            column(FORMAT_MinDate_0__Day__; FORMAT(MinDate, 0, '<Day>'))
            {
            }
            column(Caption_Control1000000144; Caption_Control1000000103Lbl)
            {
            }
            column(FORMAT_MinDate_0__Month_2__; FORMAT(MinDate, 0, '<Month,2>'))
            {
            }
            column(Caption_Control1000000146; Caption_Control1000000104Lbl)
            {
            }
            column(FORMAT_MinDate_0__Year4__; FORMAT(MinDate, 0, '<Year4>'))
            {
            }
            column(CompanyName; Company_Name)
            {
            }
            column(Caption_Control1000000151; Caption_Control1000000151Lbl)
            {
            }
            column(DeptName; DeptName)
            {
            }
            column(Caption_Control1000000153; Caption_Control1000000153Lbl)
            {
            }
            column(GLAccountNo; GLAccountNo)
            {
            }
            column(G_L_AccountCaption; G_L_AccountCaptionLbl)
            {
            }
            column(Caption_Control1000000012; Caption_Control1000000012Lbl)
            {
            }
            column(Exc__Rt_Caption; Exc__Rt_CaptionLbl)
            {
            }
            column(Amt_Caption; Amt_CaptionLbl)
            {
            }
            column(For__Curr__Caption_Control1000000038; For__Curr__CaptionLbl)
            {
            }
            column(Amt_Caption_Control1000000039; Amt_CaptionLbl)
            {
            }
            column(Caption_Control1000000045; Caption_Control1000000045Lbl)
            {
            }
            column(Curr_Caption; Curr_CaptionLbl)
            {
            }
            column(GLAccountName; GLAccountName)
            {
            }
            column(SumYear_2_; SumYear[2])
            {
                DecimalPlaces = 2 : 2;
            }
            column(SumYear_1_; SumYear[1])
            {
                DecimalPlaces = 2 : 2;
            }
            column(Balance1; Balance1)
            {
                DecimalPlaces = 2 : 2;
            }
            column(Caption_Control1000000093; Caption_Control1000000093Lbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                DataItemTableView = SORTING("Vendor No.", "Posting Date", "Currency Code");
                RequestFilterFields = "Posting Date";
                column(Vendor_Ledger_Entry__Vendor_No___25; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry__Posting_Date__25; "Posting Date")
                {
                }
                column(Vendor_Ledger_Entry__Currency_Code__25; "Currency Code")
                {
                }
                column(Vendor_Ledger_EntryHeader1SectionVisible; Vendor_Ledger_EntryHeader1SectionVisible)
                {
                }
                column(Caption_Control1000000029; Caption_Control1000000029Lbl)
                {
                }
                column(FirstBalance; FirstBalance)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(FirstStatus; FirstStatus)
                {
                }
                column(Credit_Amount__LCY___; "Credit Amount (LCY)")
                {
                }
                column(Debit_Amount__LCY___; "Debit Amount (LCY)")
                {
                }
                column(Desc; Desc)
                {
                }
                column(VoucherNo; VoucherNo)
                {
                }
                column(FORMAT__Posting_Date__0__Day__; FORMAT("Posting Date", 0, '<Day>'))
                {
                }
                column(FORMAT__Posting_Date__0__Month__; FORMAT("Posting Date", 0, '<Month>'))
                {
                }
                column(Balance1_Control1000000133; Balance1)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(BalanceStatus; BalanceStatus)
                {
                }
                column(DAmt; DAmt)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(CAmt; CAmt)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(ExRate; ExRate)
                {
                    DecimalPlaces = 0 : 4;
                }
                column(Vendor_Ledger_Entry___Currency_Code__; "Vendor Ledger Entry"."Currency Code")
                {

                }
                column(Caption_Control1000000007; Caption_Control1000000007Lbl)
                {
                }
                column(Debit_Amount__LCY____Control1000000008; "Debit Amount (LCY)")
                {
                }
                column(Credit_Amount__LCY____Control1000000009; "Credit Amount (LCY)")
                {
                }
                column(Balance1_Control1000000010; Balance1)
                {
                    DecimalPlaces = 2 : 2;
                }

                trigger OnAfterGetRecord()
                begin
                    //Balance2:=0;
                    //Balance:=Balance+"Vendor Ledger Entry".Amount;

                    "Vendor Ledger Entry".CALCFIELDS("Amount (LCY)", "Debit Amount", "Credit Amount");

                    IF "Vendor Ledger Entry"."Currency Code" <> '' THEN BEGIN
                        DAmt := "Vendor Ledger Entry"."Debit Amount";
                        CAmt := "Vendor Ledger Entry"."Credit Amount";

                        IF DAmt <> 0 THEN
                            ExRate := "Vendor Ledger Entry"."Debit Amount (LCY)" / DAmt
                        ELSE
                            IF CAmt <> 0 THEN
                                ExRate := "Vendor Ledger Entry"."Credit Amount (LCY)" / CAmt;
                    END
                    ELSE BEGIN
                        DAmt := 0;
                        CAmt := 0;
                        ExRate := 0;
                    END;


                    IF GLAccountNo <> '' THEN BEGIN
                        GLEntry.RESET;
                        GLEntry.SETRANGE("Entry No.", "Vendor Ledger Entry"."Entry No.");
                        GLEntry.SETFILTER("G/L Account No.", GLAccountNo + '*');
                        IF GLEntry.FIND('-') THEN
                            Balance2 := Balance2 + "Vendor Ledger Entry"."Amount (LCY)"
                        ELSE
                            CurrReport.SKIP;
                    END
                    ELSE
                        Balance2 := Balance2 + "Vendor Ledger Entry"."Amount (LCY)";

                    /*
                    MyEntry.RESET;
                    IF "Vendor Ledger Entry"."Entry No."<>0 THEN
                    MyEntry.SETFILTER(MyEntry."Entry No.",'%1',"Vendor Ledger Entry"."Entry No.");
                    MyEntry.SETRANGE("Date Filter",MinDate,"Vendor Ledger Entry"."Posting Date");
                    IF MyEntry.FIND('-') THEN
                    //REPEAT
                    MyEntry.Amount:=0;
                    MyEntry.CALCFIELDS(MyEntry.Amount,MyEntry."Debit Amount",MyEntry."Credit Amount");
                    "Vendor Ledger Entry".CALCFIELDS("Vendor Ledger Entry".Amount);
                    Balance2:=Balance2+ "Vendor Ledger Entry".Amount;
                    //UNTIL MyEntry.NEXT=0;
                    */

                    IF Balance2 > 0 THEN
                        BalanceStatus := '借';
                    IF Balance2 < 0 THEN
                        BalanceStatus := '贷';
                    IF Balance2 = 0 THEN
                        BalanceStatus := '平';

                    Balance1 := ABS(Balance2);

                    //ShowHeader:=FALSE;

                    Desc := Description;
                    IF "External Document No." <> '' THEN
                        Desc := Desc + '(' + "External Document No." + ')';

                    //˜íŠŸó–Ž´ñŠ•
                    GLEntry.RESET;
                    IF GLEntry.GET("Entry No.") THEN
                        VoucherNo := GLEntry."Document No.";

                    //code from sections
                    //Header1Section
                    // Vendor_Ledger_EntryHeader1SectionVisible:= (CurrReport.PAGENO = 1);
                    FirstBalance := ABS(FirstBalance);
                    //Body2Section
                    //Balance1:=Balance1+"Vendor Ledger Entry".Amount;

                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FIELDNO("Vendor No.");



                    IF SelectDept <> '' THEN
                        "Vendor Ledger Entry".SETFILTER("Vendor Ledger Entry"."Global Dimension 1 Code", SelectDept);

                    MyEntry.RESET;
                    IF Vendor."No." <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Vendor No.", Vendor."No.");
                    IF SelectDept <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Global Dimension 1 Code", SelectDept);
                    MyEntry.SETRANGE(MyEntry."Date Filter", 0D, (NORMALDATE("Vendor Ledger Entry".GETRANGEMIN("Posting Date")) - 1));

                    IF MyEntry.FIND('-') THEN
                        REPEAT
                            MyEntry.CALCFIELDS(MyEntry."Amount (LCY)", MyEntry."Debit Amount (LCY)", MyEntry."Credit Amount (LCY)");

                            //©í¯±‹ßŒ––”
                            IF GLAccountNo <> '' THEN BEGIN
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Entry No.", MyEntry."Entry No.");
                                GLEntry.SETFILTER("G/L Account No.", GLAccountNo + '*');
                                IF GLEntry.FIND('-') THEN
                                    FirstBalance := FirstBalance + MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)"
                            END
                            ELSE
                                FirstBalance := FirstBalance + MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)";
                        UNTIL MyEntry.NEXT = 0;


                    MyEntry.RESET;
                    IF Vendor."No." <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Vendor No.", Vendor."No.");
                    IF SelectDept <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Global Dimension 1 Code", SelectDept);
                    MyEntry.SETRANGE("Date Filter", CALCDATE('CY-1Y+1D', "Vendor Ledger Entry".GETRANGEMAX("Posting Date")),
                                       "Vendor Ledger Entry".GETRANGEMAX("Posting Date"));
                    IF MyEntry.FIND('-') THEN
                        REPEAT
                            MyEntry.CALCFIELDS(MyEntry."Amount (LCY)", MyEntry."Debit Amount (LCY)", MyEntry."Credit Amount (LCY)");

                            IF GLAccountNo <> '' THEN BEGIN
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Entry No.", MyEntry."Entry No.");
                                GLEntry.SETFILTER("G/L Account No.", GLAccountNo + '*');
                                IF GLEntry.FIND('-') THEN BEGIN
                                    SumYear[3] += MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)";
                                    SumYear[2] += MyEntry."Credit Amount (LCY)";
                                    SumYear[1] += MyEntry."Debit Amount (LCY)";
                                END
                            END
                            ELSE BEGIN
                                SumYear[3] += MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)";
                                SumYear[2] += MyEntry."Credit Amount (LCY)";
                                SumYear[1] += MyEntry."Debit Amount (LCY)";
                            END;
                        UNTIL MyEntry.NEXT = 0;


                    /*
                     ¸óš¬šŒ
                    MyVendor.RESET;
                    IF Vendor."No."<>'' THEN
                    MyVendor.SETFILTER(MyVendor."No.",Vendor."No.");
                    IF SelectDept<>'' THEN
                      MyVendor.SETFILTER(MyVendor."Global Dimension 1 Filter", SelectDept);
                    MyVendor.SETRANGE(MyVendor."Date Filter",0D,(NORMALDATE("Vendor Ledger Entry".GETRANGEMIN("Posting Date"))-1));
                    IF MyVendor.FIND('-') THEN
                    REPEAT
                    MyVendor.CALCFIELDS(MyVendor.Balance,MyVendor."Debit Amount",MyVendor."Credit Amount");
                    FirstBalance:=FirstBalance+MyVendor."Debit Amount" - MyVendor."Credit Amount";
                    UNTIL MyVendor.NEXT=0;
                    
                    MyVendor.RESET;
                    IF Vendor."No."<>'' THEN
                    MyVendor.SETFILTER(MyVendor."No.",Vendor."No.");
                    MyVendor.SETRANGE(MyVendor."Date Filter",MinDate,MaxDate);
                    //MESSAGE(FORMAT(CALCDATE('CM-1M+1D',MaxDate)));
                    IF MyVendor.FIND('-') THEN
                    REPEAT
                    MyVendor.CALCFIELDS(MyVendor."Net Change",MyVendor."Debit Amount",MyVendor."Credit Amount");
                    SumMonth[3]+=FirstBalance+MyVendor."Net Change";
                    SumMonth[2]+=MyVendor."Credit Amount";
                    SumMonth[1]+=MyVendor."Debit Amount";
                    UNTIL MyVendor.NEXT=0  ;
                    
                    MyVendor.RESET;
                    IF Vendor."No."<>'' THEN
                    MyVendor.SETFILTER(MyVendor."No.",Vendor."No.");
                    IF SelectDept<>'' THEN
                      MyVendor.SETFILTER(MyVendor."Global Dimension 1 Filter", SelectDept);
                    MyVendor.SETRANGE("Date Filter",CALCDATE('CY-1Y+1D',"Vendor Ledger Entry".GETRANGEMAX("Posting Date")),
                                       "Vendor Ledger Entry".GETRANGEMAX("Posting Date"));
                    IF MyVendor.FIND('-') THEN
                    REPEAT
                    MyVendor.CALCFIELDS(MyVendor.Balance,MyVendor."Debit Amount",MyVendor."Credit Amount");
                    SumYear[3]+=MyVendor."Debit Amount" - MyVendor."Credit Amount";
                    SumYear[2]+= MyVendor."Credit Amount";
                    SumYear[1]+=MyVendor."Debit Amount";
                    UNTIL MyVendor.NEXT=0;
                    
                    //MyEntry.SETCURRENTKEY(MyEntry."Document No.",MyEntry."Posting Date");
                    CurrDocNo:='';
                    SumDay[1]:=0;
                    SumDay[2]:=0;
                    SumDay[3]:=0;
                    //IF GLAccount.GET("G/L Account"."No.") THEN
                    //AccountDesc:="G/L Entry".GetDescChinese("G/L Account"."No.");
                    //"G/L Entry".SETRANGE("G/L Entry"."Posting Date",MinDate,MaxDate);
                    //"G/L Entry".Amount:=0;
                    //Balance:=0;
                    ¸óšßš°
                    */

                    Balance2 := Balance2 + FirstBalance;
                    //MESSAGE('%1',Balance2);

                    IF FirstBalance > 0 THEN
                        FirstStatus := '借';
                    IF FirstBalance < 0 THEN
                        FirstStatus := '贷';
                    IF FirstBalance = 0 THEN
                        FirstStatus := '平';

                end;
            }

            trigger OnAfterGetRecord()
            begin
                FirstBalance := 0;
                SumMonth[3] := 0;
                SumMonth[2] := 0;
                SumMonth[1] := 0;
                Balance := 0;
                Balance1 := 0;
                Balance2 := 0;
                SumYear[3] := 0;
                SumYear[2] := 0;
                SumYear[1] := 0;
                MyBalance := 0;

                MyEntry.RESET;
                MyEntry.SETRANGE(MyEntry."Posting Date", MinDate, MaxDate);
                IF SelectDept <> '' THEN
                    MyEntry.SETRANGE(MyEntry."Global Dimension 1 Code", SelectDept);
                MyEntry.SETFILTER(MyEntry."Vendor No.", Vendor."No.");
                IF NOT MyEntry.FIND('-') THEN
                    CurrReport.SKIP;

                IF GLAccountNo <> '' THEN BEGIN
                    IF MyEntry.FIND('-') THEN
                        REPEAT
                            MyEntry.CALCFIELDS(MyEntry."Amount (LCY)", MyEntry."Debit Amount (LCY)", MyEntry."Credit Amount (LCY)");

                            GLEntry.RESET;
                            GLEntry.SETRANGE("Entry No.", MyEntry."Entry No.");
                            GLEntry.SETFILTER("G/L Account No.", GLAccountNo + '*');
                            IF GLEntry.FIND('-') THEN
                                MyBalance := MyBalance + MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)"
                        UNTIL MyEntry.NEXT = 0;
                    IF MyBalance = 0 THEN
                        CurrReport.SKIP;
                END;

                CompanyInformation.RESET;
                IF CompanyInformation.FIND('-') THEN
                    Company_Name := CompanyInformation.Name;

                IF SelectDept <> '' THEN BEGIN
                    DimensionValue.SETRANGE(Code, SelectDept);
                    IF DimensionValue.FIND('-') THEN
                        DeptName := DimensionValue.Name;
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
                    field(GLAccountNo; GLAccountNo)
                    {
                        Caption = '会计科目';
                        TableRelation = "G/L Account";
                    }
                }
            }
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
        IF GLAccountNo = '' THEN
            ERROR('Please select Account Payable at option tab.');

        ShowHeader := TRUE;

        MinDate := NORMALDATE("Vendor Ledger Entry".GETRANGEMIN("Vendor Ledger Entry"."Posting Date"));
        MaxDate := NORMALDATE("Vendor Ledger Entry".GETRANGEMAX("Vendor Ledger Entry"."Posting Date"));
        //DeptCode:="Vendor Ledger Entry".GETRANGEMIN("Vendor Ledger Entry"."Global Dimension 1 Code");
        //DeptCode1:="Vendor Ledger Entry".GETRANGEMAX("Vendor Ledger Entry"."Global Dimension 1 Code");
        //MESSAGE('%1,%2',DeptCode,DeptCode1);


        //IF DeptCode=DeptCode1 THEN
        //  SelectDept:=TRUE;

        IF GLAccountNo <> '' THEN BEGIN
            GLAccount.SETRANGE("No.", GLAccountNo);
            IF GLAccount.FIND('-') THEN
                GLAccountName := GLAccount."L. Name";
        END;
    end;

    var
        Vendor_Ledger_EntryHeader1SectionVisible: Boolean;
        BalanceCaptionLbl: Label 'Balance';
        For__Curr__CaptionLbl: Label '外币 For. Curr.';
        ExplanationCaptionLbl: Label 'Explanation';
        VoucherCaptionLbl: Label 'Voucher';
        DCaptionLbl: Label 'D';
        MCaptionLbl: Label 'M';
        CaptionLbl: Label '余额';
        CHSCaptionLbl: Label '方向';
        DirCaptionLbl: Label 'Dir';
        Credit_CaptionLbl: Label '贷方 Credit';
        Debit_CaptionLbl: Label '借方 Debit';
        S________CaptionLbl: Label '摘        要';
        Caption_Control1000000098Lbl: Label '凭证号';
        Caption_Control1000000102Lbl: Label '日';
        Caption_Control1000000103Lbl: Label '月';
        Caption_Control1000000104Lbl: Label '年';
        VendorCaptionLbl: Label 'Vendor';
        Page__CaptionLbl: Label '页号(Page)';
        S_CaptionLbl: Label '-';
        Caption_Control1000000151Lbl: Label '供应商明细帐';
        Caption_Control1000000153Lbl: Label '余额';
        G_L_AccountCaptionLbl: Label 'G/L Account';
        Caption_Control1000000012Lbl: Label '汇率';
        Exc__Rt_CaptionLbl: Label 'Exc. Rt.';
        Amt_CaptionLbl: Label '本币  Amt';
        Caption_Control1000000045Lbl: Label '外币';
        Curr_CaptionLbl: Label 'Curr.';
        Caption_Control1000000093Lbl: Label '本年累计';
        Caption_Control1000000029Lbl: Label '期初余额';
        Caption_Control1000000007Lbl: Label '本月合计';
        LastFieldNo: Integer;
        Balance: Decimal;
        Balance1: Decimal;
        MyEntry: Record "Vendor Ledger Entry";
        Balance2: Decimal;
        CurrDocNo: Code[20];
        MyVendor: Record Vendor;
        AccountDesc: Text[200];
        ShowHeader: Boolean;
        FirstBalance: Decimal;
        SumDay: array[3] of Decimal;
        SumMonth: array[3] of Decimal;
        SumYear: array[3] of Decimal;
        MinDate: Date;
        MaxDate: Date;
        Desc: Text[60];
        DeptCode: Text[30];
        DeptCode1: Text[30];
        SelectDept: Text[30];
        CompanyInformation: Record "Company Information";
        Company_Name: Text[50];
        DeptName: Text[30];
        DimensionValue: Record "Dimension Value";
        BalanceStatus: Text[30];
        FirstStatus: Text[30];
        GLEntry: Record "G/L Entry";
        VoucherNo: Text[30];
        GLAccountNo: Text[30];
        GLAccount: Record "G/L Account";
        GLAccountName: Text[60];
        MyBalance: Decimal;
        DAmt: Decimal;
        CAmt: Decimal;
        ExRate: Decimal;
}

