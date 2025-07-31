report 50009 "Voucher Chinese"
{

    // 中国标准的记帐凭证
    // #01   Esg-Andy   2006-04-17
    // #02 ALF 2008-07-24
    // CS092 FDD R050 Bobby.Ji 2025/7/22 - Upgade to the BC version

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Voucher Chinese.rdlc';

    Caption = 'Voucher Chinese';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Document No.", "Posting Date");
            RequestFilterFields = "Document No.", "Posting Date";
            column(G_L_Entry__Posting_Date__17; "Posting Date")
            {
            }
            column(G_L_EntryGroupHeader3SectionVisible; G_L_EntryGroupHeader3SectionVisible)
            {
            }
            column(G_L_EntryGroupHeader4SectionVisible; G_L_EntryGroupHeader4SectionVisible)
            {
            }
            column(G_L_EntryGroupHeader5SectionVisible; G_L_EntryGroupHeader5SectionVisible)
            {
            }
            column(G_L_EntryBody6SectionVisible; G_L_EntryBody6SectionVisible)
            {
            }
            column(G_L_EntryBody7SectionVisible; G_L_EntryBody7SectionVisible)
            {
            }
            column(G_L_EntryGroupFooter8SectionVisible; G_L_EntryGroupFooter8SectionVisible)
            {
            }
            column(G_L_EntryGroupFooter9SectionVisible; G_L_EntryGroupFooter9SectionVisible)
            {
            }
            column(Caption; CaptionLbl)
            {
            }
            column(FORMAT__Posting_Date__0__Year4__; FORMAT("Posting Date", 0, '<Year4>'))
            {
            }
            column(Caption_Control1000000013; Caption_Control1000000013Lbl)
            {
            }
            column(FORMAT__Posting_Date__0__Month__; FORMAT("Posting Date", 0, '<Month>'))
            {
            }
            column(Caption_Control1000000031; Caption_Control1000000031Lbl)
            {
            }
            column(FORMAT__Posting_Date__0__Day__; FORMAT("Posting Date", 0, '<Day>'))
            {
            }
            column(Date__Caption; Date__CaptionLbl)
            {
            }
            column(S_Caption; S_CaptionLbl)
            {
            }
            column(Document_No___; "Document No.")
            {
            }
            column(Caption_Control1000000069; Caption_Control1000000069Lbl)
            {
            }
            column(ComName; ComName)
            {
            }
            column(S_Caption_Control1000000091; S_Caption_Control1000000091Lbl)
            {
            }
            column(Pno; Pno)
            {
            }
            column(Reg__No__Caption; Reg__No__CaptionLbl)
            {
            }
            column(RegNo; RegNo)
            {
            }
            column(Amount__LCY__Caption; Amount__LCY__CaptionLbl)
            {
            }
            column(Credit_Caption; Credit_CaptionLbl)
            {
            }
            column(Debit_Caption; Debit_CaptionLbl)
            {
            }
            column(Caption_Control1000000052; Caption_Control1000000052Lbl)
            {
            }
            column(Caption_Control1000000055; Caption_Control1000000055Lbl)
            {
            }
            column(Caption_Control1000000059; Caption_Control1000000059Lbl)
            {
            }
            column(S_________Caption; S_________CaptionLbl)
            {
            }
            column(ExplanationCaption; ExplanationCaptionLbl)
            {
            }
            column(Gen_Leg_Acct_Caption; Gen_Leg_Acct_CaptionLbl)
            {
            }
            column(For_Cur_Amt_Caption; For_Cur_Amt_CaptionLbl)
            {
            }
            column(Exc_RatCaption; Exc_RatCaptionLbl)
            {
            }
            column(Caption_Control1000000078; Caption_Control1000000078Lbl)
            {
            }
            column(For_Curr_Caption; For_Curr_CaptionLbl)
            {
            }
            column(Document_No____Control1000000008; "Document No.")
            {
            }
            column(Document_No___Caption; FIELDCAPTION("Document No."))
            {
            }
            column(Debit_Amount__; "Debit Amount")
            {
            }
            column(Credit_Amount__; "Credit Amount")
            {
            }
            column(ExcRate; ExcRate)
            {
                DecimalPlaces = 4 : 4;
            }
            column(ForeignAmt; ForeignAmt)
            {
                DecimalPlaces = 2 : 2;
            }
            column(CurrCode; CurrCode)
            {
            }
            column(GetChineseDesc__G_L_Account_No___; GetChineseDesc("G/L Account No."))
            {
            }
            column(G_L_Account_No___Glob1Text_Glob2Text_Employee_Project_; "G/L Account No." + Glob1Text + Glob2Text + Employee + Project)
            {
            }
            column(Description_ItemInfo; Description + ItemInfo)
            {
            }
            column(VName; V_Name)
            {
            }
            column(Description_ItemInfo_Control1117700000; Description + ItemInfo)
            {
            }
            column(Debit_Amount___Control1117700004; "Debit Amount")
            {
            }
            column(Credit_Amount___Control1117700005; "Credit Amount")
            {
            }
            column(ExcRate_Control1117700006; ExcRate)
            {
                DecimalPlaces = 4 : 4;
            }
            column(ForeignAmt_Control1117700008; ForeignAmt)
            {
                DecimalPlaces = 2 : 2;
            }
            column(CurrCode_Control1117700010; CurrCode)
            {
            }
            column(GetChineseDesc__G_L_Account_No____Control1117700012; GetChineseDesc("G/L Account No."))
            {
            }
            column(G_L_Account_No___Glob1Text_Glob2Text_Employee_Project__Control1117700013; "G/L Account No." + Glob1Text + Glob2Text + Employee + Project)
            {
            }
            column(TotalFor___FIELDCAPTION__Document_No___; TotalFor + FIELDCAPTION("Document No."))
            {
            }
            column(Debit_Amount___Control1000000029; "Debit Amount")
            {
            }
            column(Credit_Amount___Control1000000030; "Credit Amount")
            {
            }
            column(S_Caption_Control1000000011; S_Caption_Control1000000011Lbl)
            {
            }
            column(S_Caption_Control1000000012; S_Caption_Control1000000012Lbl)
            {
            }
            column(S_Caption_Control1000000038; S_Caption_Control1000000038Lbl)
            {
            }
            column(Manager___Caption; Manager___CaptionLbl)
            {
            }
            column(Checked___Caption; Checked___CaptionLbl)
            {
            }
            column(Prepared___Caption; Prepared___CaptionLbl)
            {
            }
            column(User; User)
            {
            }
            column(No2ChineseAmount_ABS__G_L_Entry___Debit_Amount___; No2ChineseAmount(ABS("G/L Entry"."Debit Amount")))
            {
            }
            column(Caption_Control1117700018; Caption_Control1117700018Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Glob1Text := '';
                Glob2Text := '';
                Employee := '';
                Project := '';

                IF DimensionValue.GET('REGION', "G/L Entry"."Global Dimension 1 Code") THEN
                    Glob1Text := DimensionValue.Name;
                IF DimensionValue.GET('UNIT', "G/L Entry"."Global Dimension 2 Code") THEN
                    Glob2Text := DimensionValue.Name;
                // SWPUP.PAM-
                // IF DimensionEntry.GET(17,"G/L Entry"."Entry No.",'EMPLOYEE') THEN
                //  IF DimensionValue.GET('EMPLOYEE',DimensionEntry."Dimension Value Code") THEN
                IF DimensionSetEntry.GET("G/L Entry"."Dimension Set ID", 'EMPLOYEE') THEN
                    IF DimensionValue.GET('EMPLOYEE', DimensionSetEntry."Dimension Value Code") THEN
                        // SWPUP.PAM+
                        Employee := DimensionValue.Name;
                // SWPUP.PAM-
                IF DimensionSetEntry.GET("G/L Entry"."Dimension Set ID", 'PROJECT') THEN
                    IF DimensionValue.GET('PROJECT', DimensionSetEntry."Dimension Value Code") THEN
                        // SWPUP.PAM+
                        Project := DimensionValue.Name;
                User := "G/L Entry"."User ID";

                ForeignAmt := 0;
                CurrCode := '';
                ExcRate := 0;

                //#02  AND ("Source Type"="Source Type"::Vendor)
                IF ("Value Entry No." <> 0) THEN
                    IF ValueEntry.GET("Value Entry No.") THEN
                        ItemInfo := ' 物料' + FORMAT(ValueEntry."Item No.") + ' 数量' + FORMAT(ValueEntry."Valued Quantity")
                    ELSE
                        ItemInfo := ''
                ELSE
                    ItemInfo := '';
                //#02

                //***** ESg Andy 2006/04/21
                IF "G/L Entry"."Source Type" IN ["G/L Entry"."Source Type"::Customer, "G/L Entry"."Source Type"::Vendor,
                                                       "G/L Entry"."Source Type"::"Bank Account"] THEN BEGIN
                    CASE "G/L Entry"."Source Type" OF
                        "G/L Entry"."Source Type"::Customer:
                            BEGIN
                                CustLE.RESET;
                                CustLE.SETRANGE("Entry No.", "G/L Entry"."Entry No.");
                                IF CustLE.FIND('-') THEN
                                    IF CustLE."Currency Code" <> '' THEN BEGIN
                                        CustLE.CALCFIELDS(Amount, "Amount (LCY)");
                                        ForeignAmt := ABS(CustLE.Amount);
                                        CurrCode := CustLE."Currency Code";
                                        IF CustLE.Amount <> 0 THEN
                                            ExcRate := CustLE."Amount (LCY)" / CustLE.Amount;
                                    END;
                            END;
                        "G/L Entry"."Source Type"::Vendor:
                            BEGIN
                                VendorLE.RESET;
                                VendorLE.SETRANGE(VendorLE."Entry No.", "G/L Entry"."Entry No.");
                                IF VendorLE.FIND('-') THEN
                                    IF VendorLE."Currency Code" <> '' THEN BEGIN
                                        VendorLE.CALCFIELDS(Amount, "Amount (LCY)");
                                        ForeignAmt := ABS(VendorLE.Amount);
                                        CurrCode := VendorLE."Currency Code";
                                        IF VendorLE.Amount <> 0 THEN
                                            ExcRate := VendorLE."Amount (LCY)" / VendorLE.Amount;
                                    END;
                            END;
                        "G/L Entry"."Source Type"::"Bank Account":
                            BEGIN
                                BankLE.RESET;
                                BankLE.SETRANGE(BankLE."Entry No.", "G/L Entry"."Entry No.");
                                IF BankLE.FIND('-') THEN
                                    IF BankLE."Currency Code" <> '' THEN BEGIN
                                        ForeignAmt := ABS(BankLE.Amount);
                                        CurrCode := BankLE."Currency Code";
                                        IF BankLE.Amount <> 0 THEN
                                            ExcRate := BankLE."Amount (LCY)" / BankLE.Amount;
                                    END;
                            END;
                    END;
                END;

                GLRegister.RESET;
                GLRegister.SETFILTER(GLRegister."From Entry No.", '<=%1', "G/L Entry"."Entry No.");
                GLRegister.SETFILTER(GLRegister."To Entry No.", '>=%1', "G/L Entry"."Entry No.");
                IF GLRegister.FIND('-') THEN
                    RegNo := GLRegister."No.";

                //*****


                //#01--Start
                IF "Source Type" IN ["Source Type"::Vendor, "Source Type"::Customer] THEN BEGIN
                    IF ("Source Type" = "Source Type"::Vendor) AND ("Source No." <> '') THEN BEGIN
                        Vendor.GET("G/L Entry"."Source No.");
                        V_Name := Vendor.Name
                    END
                    ELSE IF ("Source Type" = "Source Type"::Customer) AND ("Source No." <> '') THEN BEGIN
                        Customer.GET("G/L Entry"."Source No.");
                        V_Name := Customer.Name
                    END;
                END;
                //#01--End

                //code from sections
                //Header1Section
                Pno += 1;
                //GroupHeader3Section
                GroupTotalsRecRef.GETTABLE("G/L Entry");
                ProcessGroupHeaderSectionCode(GroupTotalsRecRef, "G/L Entry".FIELDNO("Document No."), G_L_Entry_Document_No____GroupHeaderExec);
                IF G_L_Entry_Document_No____GroupHeaderExec THEN BEGIN
                    G_L_EntryGroupHeader3SectionVisible := FALSE;
                    // FooterPrinted;
                    //FooterPrinted := FALSE;
                END;
                //GroupHeader4Section
                GroupTotalsRecRef.GETTABLE("G/L Entry");
                ProcessGroupHeaderSectionCode(GroupTotalsRecRef, "G/L Entry".FIELDNO("Document No."), G_L_Entry_Document_No____GroupHeaderExec);
                IF G_L_Entry_Document_No____GroupHeaderExec THEN BEGIN
                    //Pno:=0;
                    G_L_EntryGroupHeader4SectionVisible := FALSE;
                    //  G_L_Entry_Document_No____GroupHeaderExec;
                END;
                //GroupHeader5Section
                GroupTotalsRecRef.GETTABLE("G/L Entry");
                ProcessGroupHeaderSectionCode(GroupTotalsRecRef, "G/L Entry".FIELDNO("Document No."), G_L_Entry_Document_No____GroupHeaderExec);
                IF G_L_Entry_Document_No____GroupHeaderExec THEN BEGIN
                    G_L_EntryGroupHeader5SectionVisible := FALSE;
                    //  CurrReport.TOTALSCAUSEDBY = LastFieldNo;
                END;
                //Body6Section
                G_L_EntryBody6SectionVisible := ("Source Type" IN ["Source Type"::Customer, "Source Type"::Vendor]);
                //Body7Section
                G_L_EntryBody7SectionVisible := (NOT ("Source Type" IN ["Source Type"::Customer, "Source Type"::Vendor]));
                //GroupFooter8Section
                GroupTotalsRecRef.GETTABLE("G/L Entry");
                ProcessGroupFooterSectionCode(GroupTotalsRecRef, "G/L Entry".FIELDNO("Document No."), G_L_Entry_Document_No____GroupFooterExec);
                IF G_L_Entry_Document_No____GroupFooterExec THEN BEGIN
                    //IF NOT FooterPrinted THEN
                    //LastFieldNo := CurrReport.TOTALSCAUSEDBY;
                    G_L_EntryGroupFooter8SectionVisible := FALSE;// NOT FooterPrinted;
                                                                 //FooterPrinted := TRUE;
                END;
                //GroupFooter9Section
                GroupTotalsRecRef.GETTABLE("G/L Entry");
                ProcessGroupFooterSectionCode(GroupTotalsRecRef, "G/L Entry".FIELDNO("Document No."), G_L_Entry_Document_No____GroupFooterExec);
                IF G_L_Entry_Document_No____GroupFooterExec THEN BEGIN

                    G_L_EntryGroupFooter9SectionVisible :=
                      G_L_Entry_Document_No____GroupFooterExec;
                    Pno := 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Posting Date");
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
        CompanyInfo.FIND('-');
        ComName := CompanyInfo.Name;
    end;

    var
        G_L_Entry_Document_No____GroupHeaderExec: Boolean;
        G_L_Entry_Document_No____GroupFooterExec: Boolean;
        GroupTotalsRecRef: RecordRef;
        G_L_EntryGroupHeader3SectionVisible: Boolean;
        G_L_EntryGroupHeader4SectionVisible: Boolean;
        G_L_EntryGroupHeader5SectionVisible: Boolean;
        G_L_EntryBody6SectionVisible: Boolean;
        G_L_EntryBody7SectionVisible: Boolean;
        G_L_EntryGroupFooter8SectionVisible: Boolean;
        G_L_EntryGroupFooter9SectionVisible: Boolean;
        CaptionLbl: Label '记帐凭证';
        Caption_Control1000000013Lbl: Label '年';
        Caption_Control1000000031Lbl: Label '月';
        Date__CaptionLbl: Label '日';
        S_CaptionLbl: Label '凭证编号:';
        Caption_Control1000000069Lbl: Label '公司名称';
        S_Caption_Control1000000091Lbl: Label '页数:';
        Reg__No__CaptionLbl: Label 'Reg. No.:';
        Amount__LCY__CaptionLbl: Label '本币金额 Amount (LCY)';
        Credit_CaptionLbl: Label '贷方 Credit';
        Debit_CaptionLbl: Label '借方 Debit';
        Caption_Control1000000052Lbl: Label '汇率';
        Caption_Control1000000055Lbl: Label '外币金额';
        Caption_Control1000000059Lbl: Label '科目';
        S_________CaptionLbl: Label '摘         要';
        ExplanationCaptionLbl: Label 'Explanation';
        Gen_Leg_Acct_CaptionLbl: Label 'Gen.Leg.Acct.';
        For_Cur_Amt_CaptionLbl: Label 'For.Cur Amt.';
        Exc_RatCaptionLbl: Label 'Exc.Rat';
        Caption_Control1000000078Lbl: Label '外币';
        For_Curr_CaptionLbl: Label 'For.Curr.';
        S_Caption_Control1000000011Lbl: Label '制单:';
        S_Caption_Control1000000012Lbl: Label '复核:';
        S_Caption_Control1000000038Lbl: Label '会计主管:';
        Manager___CaptionLbl: Label '(Manager):';
        Checked___CaptionLbl: Label '(Checked):';
        Prepared___CaptionLbl: Label '(Prepared):';
        Caption_Control1117700018Lbl: Label '人民币大写金额：';
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total for ';
        Glob1Text: Text[50];
        Glob2Text: Text[50];
        DimensionValue: Record "Dimension Value";
        Project: Text[50];
        Employee: Text[50];
        User: Code[20];
        Pno: Integer;
        ComName: Text[50];
        CompanyInfo: Record "Company Information";
        ForeignAmt: Decimal;
        ExcRate: Decimal;
        CurrCode: Code[10];
        CustLE: Record "Cust. Ledger Entry";
        VendorLE: Record "Vendor Ledger Entry";
        BankLE: Record "Bank Account Ledger Entry";
        RegNo: Integer;
        GLRegister: Record "G/L Register";
        Vendor: Record Vendor;
        Customer: Record Customer;
        V_Name: Text[50];
        ValueEntry: Record "Value Entry";
        ItemInfo: Text[50];
        DimensionSetEntry: Record "Dimension Set Entry";
        Text001: Label '%1 / %2';
        TextFull: Label '整';


    procedure No2ChineseAmount(ChangeMoney: Decimal): Text[100]
    var
        String1: Text[30];
        String2: Text[30];
        String3: Text[100];
        String4: Text[100];
        StringTemp: Text[100];
        i: Integer;
        J: Integer;
        CH1: Text[100];
        CH2: Text[100];
        Zero: Integer;
        ReturnValue: Text[100];
        No: Integer;
        Int: Integer;
        Text001: Label '零壹贰叁肆伍陆柒捌玖';
        Text002: Label '万仟佰拾亿仟佰拾万仟佰拾元角分';
        Text00: Label '零';
        Text01: Label '亿';
        Text02: Label '万';
        Text03: Label '元';
        Text04: Label '整';
        Text06: Label '仟仟';
        Text07: Label '佰佰';
        Text08: Label '零元';
        Text09: Label '零万';
        Text10: Label '零亿';
        Text11: Label '零整';
        Text12: Label '零佰';
        Text13: Label '零仟';
        Text14: Label '元元';
        "--New": Integer;
        TempStr: Text[50];
        LeftStr: Text[30];
        RightStr: Text[10];
        Pos: Integer;
        Len: Integer;
    begin




        TempStr := FORMAT(ChangeMoney, 0, '<Integer><Decimals>');

        Len := STRLEN(TempStr);
        Pos := STRPOS(TempStr, '.');

        IF Pos > 0 THEN BEGIN
            LeftStr := COPYSTR(TempStr, 1, Pos - 1);
            RightStr := COPYSTR(TempStr, Pos + 1, Len - Pos);
        END ELSE
            LeftStr := TempStr;

        TempStr := '';

        Len := STRLEN(LeftStr);
        IF Len > 9 THEN EXIT('CHSAmountFormat()不能处理超亿位数字');

        Pos := 0;
        REPEAT
            CASE Pos OF
                0:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '元';
                1:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '拾' + TempStr;
                2:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '佰' + TempStr;
                3:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '仟' + TempStr;
                4:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '万' + TempStr;
                5:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '拾' + TempStr;
                6:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '佰' + TempStr;
                7:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '仟' + TempStr;
                8:
                    TempStr := NumToChs(COPYSTR(LeftStr, Len - Pos, 1)) + '亿' + TempStr;
            END;
            Pos := Pos + 1;
        UNTIL Pos = Len;

        IF RightStr <> '' THEN BEGIN
            Len := STRLEN(RightStr);
            Pos := 1;
            REPEAT
                CASE Pos OF
                    1:
                        TempStr := TempStr + NumToChs(COPYSTR(RightStr, Pos, 1)) + '角';
                    2:
                        TempStr := TempStr + NumToChs(COPYSTR(RightStr, Pos, 1)) + '分';
                END;
                Pos := Pos + 1;
            UNTIL ((Pos > 2) OR (Pos > Len));
        END ELSE
            TempStr := TempStr + TextFull;

        EXIT(TempStr);


        EXIT;
        String1 := Text001;    //Chinese Number
        String2 := Text002;    //Chinese Unit

        EVALUATE(Int, FORMAT(ChangeMoney * 100));
        String4 := FORMAT(Int);

        J := STRLEN(String4);

        // SWPUP.ROS-
        // String2 := COPYSTR(String2,(STRLEN(String2) - J * 2 + 1));
        String2 := COPYSTR(String2, (STRLEN(String2) - J + 1));
        // SWPUP.ROS+

        i := 1;

        WHILE i <= J DO BEGIN
            String3 := COPYSTR(String4, i, 1);    //Get Chinese Number
            EVALUATE(No, String3);    //Get Chinese Unit

            IF String3 <> '0' THEN BEGIN
                CH1 := COPYSTR(String1, No * 2 + 1, 2);
                CH2 := COPYSTR(String2, i * 2 - 1, 2);
                Zero := 0;
            END ELSE BEGIN
                IF (Zero = 0) OR (i = J - 9) OR (i = J - 5) OR (i = J - 1) THEN
                    CH1 := Text00
                ELSE
                    CH1 := '';

                Zero := Zero + 1;

                CH2 := '';

                IF i = J - 10 THEN BEGIN
                    CH2 := Text01;
                    Zero := 0;
                END;

                IF i = J - 6 THEN BEGIN
                    CH2 := Text02;
                    Zero := 0;
                END;

                IF i = J - 2 THEN BEGIN
                    CH2 := Text03;
                    Zero := 0;
                END;

                IF i = J THEN
                    CH2 := Text04;

            END;

            ReturnValue := ReturnValue + CH1 + CH2;

            i := i + 1;
        END;

        //At last, delete the zero which is unwanted
        IF STRPOS(ReturnValue, Text06) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text06), 2);

        IF STRPOS(ReturnValue, Text07) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text07), 2);

        IF STRPOS(ReturnValue, Text08) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text08), 2);

        IF STRPOS(ReturnValue, Text09) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text09), 2);

        IF STRPOS(ReturnValue, Text10) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text10), 2);

        IF STRPOS(ReturnValue, Text11) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text11), 2);

        IF STRPOS(ReturnValue, Text12) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text12), 2);

        IF STRPOS(ReturnValue, Text13) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text13), 2);

        IF STRPOS(ReturnValue, Text14) <> 0 THEN
            ReturnValue := DELSTR(ReturnValue, STRPOS(ReturnValue, Text14), 2);

        EXIT(ReturnValue);
    end;


    procedure GetChineseDesc("Account No": Code[20]): Text[100]
    var
        "G/L Account": Record "G/L Account";
    begin
        IF "Account No" <> '' THEN BEGIN
            "G/L Account".GET("Account No");
            EXIT("G/L Account"."L. Name");
        END;
    end;

    local procedure ProcessGroupHeaderSectionCode(var pGroupTotalsRecRef: RecordRef; GroupFieldNo: Integer; var GroupHeaderExec: Boolean)
    var
        LastRecRef: RecordRef;
    begin
        GroupHeaderExec := FALSE;

        IF pGroupTotalsRecRef.NEXT(-1) = 0 THEN
            GroupHeaderExec := TRUE
        ELSE BEGIN
            LastRecRef := pGroupTotalsRecRef.DUPLICATE;
            pGroupTotalsRecRef.NEXT;

            IF pGroupTotalsRecRef.FIELD(GroupFieldNo).VALUE <> LastRecRef.FIELD(GroupFieldNo).VALUE THEN
                GroupHeaderExec := TRUE;
        END;
    end;

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


    procedure NumToChs(InCHR: Text[1]): Text[2]
    begin


        CASE InCHR OF
            '0':
                EXIT('零');
            '9':
                EXIT('玖');
            '8':
                EXIT('捌');
            '7':
                EXIT('柒');
            '6':
                EXIT('陆');
            '5':
                EXIT('伍');
            '4':
                EXIT('肆');
            '3':
                EXIT('叁');
            '2':
                EXIT('贰');
            '1':
                EXIT('壹');
            ELSE
                EXIT('??');
        END;
    end;
}

