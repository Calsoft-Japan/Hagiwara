report 50052 ChineseIncomeStatement
{
    // CS092 FDD R047 Bobby.ji 2025/7/15 - Upgrade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Chinese Income Statement.rdlc';
    Caption = 'Chinese Income Statement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Acc. Schedule Line"; "Acc. Schedule Line")
        {
            DataItemTableView = SORTING("Schedule Name", "Line No.")
                                ORDER(Ascending);
            RequestFilterFields = "Date Filter", "Dimension 1 Filter", "Dimension 2 Filter", "Business Unit Filter";

            trigger OnPreDataItem()
            begin
                IF "Acc. Schedule Line".GETFILTER("Date Filter") = '' THEN
                    ERROR(Text001);
                DateFilterMax := "Acc. Schedule Line".GETRANGEMAX("Date Filter");
                DateFilterMax := "Acc. Schedule Line".GETRANGEMAX("Date Filter");
                DateFilterMin := "Acc. Schedule Line".GETRANGEMIN("Date Filter");
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending);
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(Title_Caption; Title_CaptionLbl)
            {
            }
            column(FORMAT_DateFilterMax_0___Year4___; FORMAT(DateFilterMax, 0, '<Year4>'))
            {
            }
            column(FORMAT_DateFilterMax_0___Month___; FORMAT(DateFilterMax, 0, '<Month>'))
            {
            }
            column(FORMAT_DateFilterMax_0___Day___; FORMAT(DateFilterMax, 0, '<Day>'))
            {
            }
            column(ColAmount2; ColAmount2)
            {
                DecimalPlaces = 2 : 2;
            }
            column(ColAmount; ColAmount)
            {
                DecimalPlaces = 2 : 2;
            }
            column(Row; Row)
            {
            }
            column(txtDescription; txtDescription)
            {
            }
            column(Company_Name_Caption; Company_Name_CaptionLbl)
            {
            }
            column(Income_Statement_and_Profit_appropritionCaption; Income_Statement_and_Profit_appropritionCaptionLbl)
            {
            }
            column(YearCaption; YearCaptionLbl)
            {
            }
            column(MonthCaption; MonthCaptionLbl)
            {
            }
            column(DayCaption; DayCaptionLbl)
            {
            }
            column(Unit__RMBCaption; Unit__RMBCaptionLbl)
            {
            }
            column(Enterprise_02_TableCaption; Enterprise_02_TableCaptionLbl)
            {
            }
            column(LineCaption; LineCaptionLbl)
            {
            }
            column(ItemsCaption; ItemsCaptionLbl)
            {
            }
            column(Current_MonthCaption; Current_MonthCaptionLbl)
            {
            }
            column(Year_To_DateCaption; Year_To_DateCaptionLbl)
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin


                IF Number = 1 THEN BEGIN
                    AccLine1.FIND('-');
                END ELSE BEGIN
                    IF Number <= LeftRaws THEN
                        AccLine1.NEXT;
                END;

                IF (Number <= LeftRaws) AND (AccLine1.Show = AccLine1.Show::Yes) THEN BEGIN
                    IF "Use Description 2" THEN
                        txtDescription := AccLine1."Description 2"
                    ELSE
                        txtDescription := AccLine1.Description;
                    Row := AccLine1."Row No.";
                    ColAmount := AccSchMgt.CalcCell(AccLine1, TempColumn1, FALSE);
                    ColAmount2 := AccSchMgt.CalcCell(AccLine1, TempColumn2, FALSE);
                END;
            end;

            trigger OnPreDataItem()
            begin

                IF NOT ChineseReportSetup.GET('CHS-PL') THEN
                    ERROR(Text50000);
                TempColumn1.SETRANGE("Column Layout Name", 'chspl');
                //TempColumn1.SETRANGE("Column Header",'net change');
                TempColumn1.SETRANGE("Column Type", TempColumn1."Column Type"::"Net Change");
                IF NOT TempColumn1.FIND('-') THEN
                    ERROR(Text50012, 'net change');
                TempColumn2.SETRANGE("Column Layout Name", 'chspl');
                //TempColumn2.SETRANGE("Column Header",'year to date');
                TempColumn2.SETRANGE("Column Type", TempColumn2."Column Type"::"Year to Date");
                IF NOT TempColumn2.FIND('-') THEN
                    ERROR(Text50012, 'year to date');
                AccLine1.COPYFILTERS("Acc. Schedule Line");
                AccLine1.SETRANGE("Schedule Name", 'CHS-PL');
                AccLine1.SETRANGE(Show, AccLine1.Show::Yes);
                //AccLine1.SETRANGE("Line No.",ChineseReportSetup."Left Starting Line",ChineseReportSetup."Left Ending Line");

                LeftRaws := AccLine1.COUNT;

                Integer.SETRANGE(Number, 1, LeftRaws);
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
                    field("Use Description 2"; "Use Description 2")
                    {
                        Caption = 'Use Description 2';
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        ChineseReportSetup: Record "Acc. Schedule Name";
        TempColumn1: Record "Column Layout";
        TempColumn2: Record "Column Layout";
        AccLine1: Record "Acc. Schedule Line";
        AccSchMgt: Codeunit AccSchedManagement;
        ColAmount: Decimal;
        ColAmount2: Decimal;
        txtDescription: Text[80];
        Row: Code[10];
        Text001: Label 'You must input a Date Filter.';
        Text50000: Label 'Profit & Loss Report(CN RPT-PL) First is not defined in Account Schedule.';
        RowCount: Integer;
        DateFilterMax: Date;
        Text50003: Label 'Month to Date';
        "Use Description 2": Boolean;
        Text50012: Label 'Can not find CN Report Column Layout or %1 Column!';
        Company_Name_CaptionLbl: Label '公司名称:';
        Income_Statement_and_Profit_appropritionCaptionLbl: Label 'Income_Statement_and_Profit_appropritionCaptionLbl';
        Title_CaptionLbl: Label '利 润 及 利 润 分 配 表';
        YearCaptionLbl: Label '年';
        MonthCaptionLbl: Label '月';
        DayCaptionLbl: Label '日';
        Unit__RMBCaptionLbl: Label 'Unit__RMBCaptionLbl';
        Enterprise_02_TableCaptionLbl: Label '会企02表';
        LineCaptionLbl: Label '行次';
        ItemsCaptionLbl: Label '项    目';
        Current_MonthCaptionLbl: Label '本  月';
        Year_To_DateCaptionLbl: Label '本年累计';
        DateFilterMin: Date;
        vDescription: Text[80];
        vRaw: Code[10];
        LeftRaws: Integer;
}

