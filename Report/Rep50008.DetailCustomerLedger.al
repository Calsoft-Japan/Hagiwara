report 50008 "Detail Customer Ledger"
{
    // Error to set myEntry as Temporary table which will only include the structure of table, not data.
    // 
    // #ESGEW01  20031026
    //   Update the field Month No of the table G/L Entry,set it to the month of the field posting date.
    // CS092 Bobby.Ji 2025/6/18 - Upgade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/DetailCustomerLedger.rdlc';

    Caption = 'Detail Customer Ledger';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //PaperSize = A4 210 x 297 mm;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(Customer__No___18; "No.")
            {
            }
            column(CustomerGroupFooter2SectionVisible; CustomerGroupFooter2SectionVisible)
            {
            }
            column(DeptName; DeptName)
            {
            }
            column(Page__Caption; Page__CaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(Caption; CaptionLbl)
            {
            }
            column(Caption_Control1000000107; Caption_Control1000000107Lbl)
            {
            }
            column(GLAccountName; GLAccountName)
            {
            }
            column(LCY_Caption; LCY_CaptionLbl)
            {
            }
            column(Credit_Caption; Credit_CaptionLbl)
            {
            }
            column(Caption_Control1000000113; Caption_Control1000000113Lbl)
            {
            }
            column(Caption_Control1000000116; Caption_Control1000000116Lbl)
            {
            }
            column(FORMAT_MaxDate_0__Day__; FORMAT(MaxDate, 0, '<Day>'))
            {
            }
            column(Caption_Control1000000119; Caption_Control1000000119Lbl)
            {
            }
            column(LCY_Caption_Control1000000136; LCY_CaptionLbl)
            {
            }
            column(Debit_Caption; Debit_CaptionLbl)
            {
            }
            column(FORMAT_MaxDate_0__Month_2__; FORMAT(MaxDate, 0, '<Month,2>'))
            {
            }
            column(Caption_Control1000000139; Caption_Control1000000139Lbl)
            {
            }
            column(FORMAT_MaxDate_0__Year4__; FORMAT(MaxDate, 0, '<Year4>'))
            {
            }
            column(G_L_AccountCaption; G_L_AccountCaptionLbl)
            {
            }
            column(ExplanationCaption; ExplanationCaptionLbl)
            {
            }
            column(S________Caption; S________CaptionLbl)
            {
            }
            column(S_Caption; S_CaptionLbl)
            {
            }
            column(Caption_Control1000000146; Caption_Control1000000113Lbl)
            {
            }
            column(FORMAT_MinDate_0__Day__; FORMAT(MinDate, 0, '<Day>'))
            {
            }
            column(Customer__No__; Customer."No.")
            {
            }
            column(Caption_Control1000000149; Caption_Control1000000119Lbl)
            {
            }
            column(FORMAT_MinDate_0__Month_2__; FORMAT(MinDate, 0, '<Month,2>'))
            {
            }
            column(Customer_Name; Customer.Name)
            {
            }
            column(Caption_Control1000000152; Caption_Control1000000139Lbl)
            {
            }
            column(FORMAT_MinDate_0__Year4__; FORMAT(MinDate, 0, '<Year4>'))
            {
            }
            column(CHSCaption; CHSCaptionLbl)
            {
            }
            column(DirCaption; DirCaptionLbl)
            {
            }
            column(CUTCaption; CUTCaptionLbl)
            {
            }
            column(CompanyName; Company_Name)
            {
            }
            column(VoucherCaption; VoucherCaptionLbl)
            {
            }
            column(Caption_Control1000000158; Caption_Control1000000158Lbl)
            {
            }
            column(DCaption; DCaptionLbl)
            {
            }
            column(Caption_Control1000000161; Caption_Control1000000113Lbl)
            {
            }
            column(CustomerCaption; CustomerCaptionLbl)
            {
            }
            column(MCaption; MCaptionLbl)
            {
            }
            column(Caption_Control1000000165; Caption_Control1000000119Lbl)
            {
            }
            column(GLAccountNo; GLAccountNo)
            {
            }
            column(For__Curr__Caption; For__Curr__CaptionLbl)
            {
            }
            column(For__Curr__Caption_Control1000000175; For__Curr__CaptionLbl)
            {
            }
            column(Caption_Control1000000176; Caption_Control1000000176Lbl)
            {
            }
            column(Caption_Control1000000177; Caption_Control1000000177Lbl)
            {
            }
            column(Ex__Rt_Caption; Ex__Rt_CaptionLbl)
            {
            }
            column(Curr_Caption; Curr_CaptionLbl)
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
            column(Caption_Control1000000083; Caption_Control1000000083Lbl)
            {
            }

            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");
                RequestFilterFields = "Posting Date";
                column(Entry_No__; "Entry No.")
                {
                }
                column(Cust__Ledger_Entry__Customer_No___21; "Customer No.")
                {
                }
                column(Cust__Ledger_Entry__Posting_Date__21; "Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Currency_Code__21; "Currency Code")
                {
                }
                column(Cust__Ledger_EntryHeader1SectionVisible; Cust__Ledger_EntryHeader1SectionVisible)
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
                column(Cust__Ledger_Entry___Currency_Code__; "Cust. Ledger Entry"."Currency Code")
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
                    //Balance:=Balance+"Customer Ledger Entry".Amount;

                    "Cust. Ledger Entry".CALCFIELDS("Amount (LCY)", "Debit Amount", "Credit Amount");

                    IF "Cust. Ledger Entry"."Currency Code" <> '' THEN BEGIN
                        DAmt := "Cust. Ledger Entry"."Debit Amount";
                        CAmt := "Cust. Ledger Entry"."Credit Amount";

                        IF DAmt <> 0 THEN
                            ExRate := "Cust. Ledger Entry"."Debit Amount (LCY)" / DAmt
                        ELSE
                            IF CAmt <> 0 THEN
                                ExRate := "Cust. Ledger Entry"."Credit Amount (LCY)" / CAmt;
                    END
                    ELSE BEGIN
                        DAmt := 0;
                        CAmt := 0;
                        ExRate := 0;
                    END;



                    IF GLAccountNo <> '' THEN BEGIN
                        GLEntry.RESET;
                        GLEntry.SETRANGE("Entry No.", "Cust. Ledger Entry"."Entry No.");
                        GLEntry.SETFILTER("G/L Account No.", GLAccountNo + '*');
                        IF GLEntry.FIND('-') THEN
                            Balance2 := Balance2 + "Cust. Ledger Entry"."Amount (LCY)"
                        ELSE
                            CurrReport.SKIP;
                    END
                    ELSE
                        Balance2 := Balance2 + "Cust. Ledger Entry"."Amount (LCY)";

                    /*
                    MyEntry.RESET;
                    IF "Cust. Ledger Entry"."Entry No."<>0 THEN
                    MyEntry.SETFILTER(MyEntry."Entry No.",'%1',"Cust. Ledger Entry"."Entry No.");
                    MyEntry.SETRANGE("Date Filter",MinDate,"Cust. Ledger Entry"."Posting Date");
                    IF MyEntry.FIND('-') THEN
                    //REPEAT
                    MyEntry.Amount:=0;
                    MyEntry.CALCFIELDS(MyEntry.Amount,MyEntry."Debit Amount",MyEntry."Credit Amount");
                    "Cust. Ledger Entry".CALCFIELDS("Cust. Ledger Entry".Amount);
                    Balance2:=Balance2+ "Cust. Ledger Entry".Amount;
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

                    DepartName := '';
                    Responsibility.SETRANGE(Responsibility.Code, "Cust. Ledger Entry"."Global Dimension 1 Code");
                    IF Responsibility.FIND('-') THEN
                        DepartName := Responsibility.Name;

                    //code from sections
                    //Header1Section
                    //Cust__Ledger_EntryHeader1SectionVisible := (CurrReport.PAGENO = 1);
                    FirstBalance := ABS(FirstBalance);
                    //Body2Section
                    //Balance1:=Balance1+"Cust. Ledger Entry".Amount;
                    //code from sections
                    //GroupFooter2Section
                    GroupTotalsRecRef.GETTABLE(Customer);
                    ProcessGroupFooterSectionCode(GroupTotalsRecRef, Customer.FIELDNO("No."), Customer_No____GroupFooterExec);
                    IF Customer_No____GroupFooterExec THEN BEGIN
                        IF (SumYear[1] = 0) AND (SumYear[2] = 0) AND (Balance1 = 0) THEN
                            CustomerGroupFooter2SectionVisible := (FALSE)
                        ELSE
                            CustomerGroupFooter2SectionVisible := (TRUE);
                    END;

                end;

                trigger OnPreDataItem()
                begin
                    TempCustLedgerEntry.SETRANGE(TempCustLedgerEntry."Customer No.", Customer."No.");
                    IF SelectDept <> '' THEN
                        TempCustLedgerEntry.SETRANGE(TempCustLedgerEntry."Global Dimension 1 Code", SelectDept);
                    DateFilter := "Cust. Ledger Entry".GETFILTER("Cust. Ledger Entry"."Posting Date");
                    TempCustLedgerEntry.SETFILTER(TempCustLedgerEntry."Posting Date", DateFilter);
                    IF NOT TempCustLedgerEntry.FIND('-') THEN
                        IsPrint := FALSE;

                    LastFieldNo := FIELDNO("Customer No.");
                    //message(LastFieldNo);
                    //CurrReport.CREATETOTALS(Balance2);

                    IF SelectDept <> '' THEN
                        "Cust. Ledger Entry".SETFILTER("Cust. Ledger Entry"."Global Dimension 1 Code", SelectDept);

                    MyEntry.RESET;
                    IF Customer."No." <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Customer No.", Customer."No.");
                    IF SelectDept <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Global Dimension 1 Code", SelectDept);
                    MyEntry.SETRANGE(MyEntry."Date Filter", 0D, (NORMALDATE("Cust. Ledger Entry".GETRANGEMIN("Posting Date")) - 1));
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
                                //ELSE
                                // FirstBalance:=FirstBalance;
                            END
                            ELSE
                                FirstBalance := FirstBalance + MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)";
                        UNTIL MyEntry.NEXT = 0;


                    MyEntry.RESET;
                    IF Customer."No." <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Customer No.", Customer."No.");
                    IF SelectDept <> '' THEN
                        MyEntry.SETFILTER(MyEntry."Global Dimension 1 Code", SelectDept);
                    MyEntry.SETRANGE("Date Filter", CALCDATE('CY-1Y+1D', "Cust. Ledger Entry".GETRANGEMAX("Posting Date")),
                                       "Cust. Ledger Entry".GETRANGEMAX("Posting Date"));
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
                                //ELSE
                                //message('ok');
                            END
                            ELSE BEGIN
                                SumYear[3] += MyEntry."Debit Amount (LCY)" - MyEntry."Credit Amount (LCY)";
                                SumYear[2] += MyEntry."Credit Amount (LCY)";
                                SumYear[1] += MyEntry."Debit Amount (LCY)";
                            END;
                        UNTIL MyEntry.NEXT = 0;


                    /*
                    MyCustomer.RESET;
                    IF Customer."No."<>'' THEN
                    MyCustomer.SETFILTER(MyCustomer."No.",Customer."No.");
                    IF SelectDept<>'' THEN
                      MyCustomer.SETFILTER(MyCustomer."Global Dimension 1 Filter", SelectDept);
                    MyCustomer.SETRANGE(MyCustomer."Date Filter",0D,(NORMALDATE("Cust. Ledger Entry".GETRANGEMIN("Posting Date"))-1));
                    IF MyCustomer.FIND('-') THEN
                    REPEAT
                    MyCustomer.CALCFIELDS(MyCustomer.Balance,MyCustomer."Debit Amount",MyCustomer."Credit Amount");
                    FirstBalance:=FirstBalance+MyCustomer."Debit Amount" - MyCustomer."Credit Amount";
                    UNTIL MyCustomer.NEXT=0;
                    
                    MyCustomer.RESET;
                    IF Customer."No."<>'' THEN
                    MyCustomer.SETFILTER(MyCustomer."No.",Customer."No.");
                    MyCustomer.SETRANGE(MyCustomer."Date Filter",MinDate,MaxDate);
                    //MESSAGE(FORMAT(CALCDATE('CM-1M+1D',MaxDate)));
                    IF MyCustomer.FIND('-') THEN
                    REPEAT
                    MyCustomer.CALCFIELDS(MyCustomer."Net Change",MyCustomer."Debit Amount",MyCustomer."Credit Amount");
                    SumMonth[3]+=FirstBalance+MyCustomer."Net Change";
                    SumMonth[2]+=MyCustomer."Credit Amount";
                    SumMonth[1]+=MyCustomer."Debit Amount";
                    UNTIL MyCustomer.NEXT=0  ;
                    
                    MyCustomer.RESET;
                    IF Customer."No."<>'' THEN
                    MyCustomer.SETFILTER(MyCustomer."No.",Customer."No.");
                    IF SelectDept<>'' THEN
                      MyCustomer.SETFILTER(MyCustomer."Global Dimension 1 Filter", SelectDept);
                    MyCustomer.SETRANGE("Date Filter",CALCDATE('CY-1Y+1D',"Cust. Ledger Entry".GETRANGEMAX("Posting Date")),
                                       "Cust. Ledger Entry".GETRANGEMAX("Posting Date"));
                    IF MyCustomer.FIND('-') THEN
                    REPEAT
                    MyCustomer.CALCFIELDS(MyCustomer.Balance,MyCustomer."Debit Amount",MyCustomer."Credit Amount");
                    SumYear[3]+=MyCustomer."Debit Amount" - MyCustomer."Credit Amount";
                    SumYear[2]+= MyCustomer."Credit Amount";
                    SumYear[1]+=MyCustomer."Debit Amount";
                    UNTIL MyCustomer.NEXT=0;
                    
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
                    */

                    Balance2 := Balance2 + FirstBalance;

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
                IsPrint := TRUE;

                MyEntry.RESET;
                MyEntry.SETRANGE(MyEntry."Posting Date", MinDate, MaxDate);
                IF SelectDept <> '' THEN
                    MyEntry.SETRANGE(MyEntry."Global Dimension 1 Code", SelectDept);
                MyEntry.SETFILTER(MyEntry."Customer No.", Customer."No.");
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

                IF GLAccountNo <> '' THEN BEGIN
                    TempGLAccountNo := COPYSTR(GLAccountNo, 1, 4);
                    TempGLAccount.SETRANGE(TempGLAccount."No.", TempGLAccountNo);
                    IF TempGLAccount.FIND('-') THEN
                        GLAccountName := TempGLAccount.Name;
                    GLAccount.SETRANGE("No.", GLAccountNo);
                    IF GLAccount.FIND('-') THEN
                        GLAccountName := GLAccountName + '-' + GLAccount.Name;
                END;
            end;

            trigger OnPreDataItem()
            begin
                //IF SelectDept<>'' THEN
                //  Customer.SETFILTER(Customer."Global Dimension 1 Filter", SelectDept);
            end;
        }
    }

    requestpage
    {

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
            ERROR('Please select Account Receivable at option tab.');

        ShowHeader := TRUE;

        MinDate := NORMALDATE("Cust. Ledger Entry".GETRANGEMIN("Cust. Ledger Entry"."Posting Date"));
        MaxDate := NORMALDATE("Cust. Ledger Entry".GETRANGEMAX("Cust. Ledger Entry"."Posting Date"));
        //DeptCode:="Vendor Ledger Entry".GETRANGEMIN("Vendor Ledger Entry"."Global Dimension 1 Code");
        //DeptCode1:="Vendor Ledger Entry".GETRANGEMAX("Vendor Ledger Entry"."Global Dimension 1 Code");
        //MESSAGE('%1,%2',DeptCode,DeptCode1);

        //•¨†Ÿ®¨žÃ©í¯±“•
        //MyEntry.RESET;
        //IF "Cust. Ledger Entry"."Entry No."<>0 THEN
        //MyEntry.SETFILTER(MyEntry."Entry No.",'%1',"Cust. Ledger Entry"."Entry No.");
        //MyEntry.SETRANGE("Date Filter",MinDate,MaxDate);
        //IF MyEntry.FIND('-') THEN
        //REPEAT
        //  Deptcode:=Myentry."Global Dimension 1 Code";
        //  if deptcode<>deptcode1 then
        //     selectdept=true;
        //  deptcode1:=deptcode;
        //UNTIL MyEntry.NEXT=0;

        //IF DeptCode=DeptCode1 THEN
        //  SelectDept:=TRUE;
    end;

    var
        Customer_No____GroupFooterExec: Boolean;
        GroupTotalsRecRef: RecordRef;
        CustomerGroupFooter2SectionVisible: Boolean;
        Cust__Ledger_EntryHeader1SectionVisible: Boolean;
        Page__CaptionLbl: Label '页号(Page)';
        BalanceCaptionLbl: Label 'Balance';
        CaptionLbl: Label '余额';
        Caption_Control1000000107Lbl: Label '余额';
        CHSCaptionLbl: Label '方向';
        DirCaptionLbl: Label 'Dir';
        LCY_CaptionLbl: Label '本币 LCY';
        Credit_CaptionLbl: Label '贷方 Credit';
        Caption_Control1000000113Lbl: Label '日';
        Caption_Control1000000116Lbl: Label '客户明细帐';
        Caption_Control1000000119Lbl: Label '月';
        Debit_CaptionLbl: Label '借方 Debit';
        Caption_Control1000000139Lbl: Label '年';
        G_L_AccountCaptionLbl: Label 'G/L Account';
        ExplanationCaptionLbl: Label 'Explanation';
        S________CaptionLbl: Label '摘        ­要';
        S_CaptionLbl: Label '-';
        CUTCaptionLbl: Label '编号';
        VoucherCaptionLbl: Label 'Voucher';
        Caption_Control1000000158Lbl: Label '凭证号';
        DCaptionLbl: Label 'D';
        CustomerCaptionLbl: Label 'Customer';
        MCaptionLbl: Label 'M';
        For__Curr__CaptionLbl: Label '外币 For. Curr.';
        Caption_Control1000000176Lbl: Label '外币­';
        Caption_Control1000000177Lbl: Label '汇率';
        Ex__Rt_CaptionLbl: Label 'Ex. Rt.';
        Curr_CaptionLbl: Label 'Curr.';
        Caption_Control1000000083Lbl: Label '本年累计';
        Caption_Control1000000029Lbl: Label '期初余额';
        Caption_Control1000000007Lbl: Label '本月合计';
        LastFieldNo: Integer;
        Balance: Decimal;
        Balance1: Decimal;
        MyEntry: Record "Cust. Ledger Entry";
        Balance2: Decimal;
        CurrDocNo: Code[20];
        MyCustomer: Record Customer;
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
        Company_Name: Text[30];
        DeptName: Text[30];
        DimensionValue: Record "Dimension Value";
        BalanceStatus: Text[30];
        FirstStatus: Text[30];
        GLEntry: Record "G/L Entry";
        VoucherNo: Text[30];
        GLAccountNo: Text[30];
        GLAccountName: Text[60];
        GLAccount: Record "G/L Account";
        MyBalance: Decimal;
        DepartName: Text[30];
        Responsibility: Record "Responsibility Center";
        TempCustLedgerEntry: Record "Cust. Ledger Entry";
        DateFilter: Text[100];
        IsPrint: Boolean;
        TempGLAccountNo: Text[30];
        TempGLAccount: Record "G/L Account";
        CAmt: Decimal;
        DAmt: Decimal;
        ExRate: Decimal;

    local procedure ProcessGroupFooterSectionCode(var pGroupTotalsRecRef: RecordRef; GroupFieldNo: Integer; var GroupFooterExec: Boolean)
    var
        NextRecRef: RecordRef;
    begin
        GroupFooterExec := FALSE;

        IF pGroupTotalsRecRef.NEXT = 0 THEN
            GroupFooterExec := TRUE
        ELSE BEGIN
            NextRecRef := pGroupTotalsRecRef.DUPLICATE;
            pGroupTotalsRecRef.NEXT(-1);

            IF pGroupTotalsRecRef.FIELD(GroupFieldNo).VALUE <> NextRecRef.FIELD(GroupFieldNo).VALUE THEN
                GroupFooterExec := TRUE;
        END;
    end;
}

