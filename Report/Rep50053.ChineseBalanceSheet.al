report 50053 ChineseBalanceSheet
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Chinese Balance Sheet.rdlc';
    Caption = 'Chinese Balance Sheet';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Acc. Schedule Line"; "Acc. Schedule Line")
        {
            RequestFilterFields = "Date Filter", "Dimension 1 Filter", "Dimension 2 Filter", "Business Unit Filter";

            trigger OnPreDataItem()
            begin
                IF NOT AccScheduleName.GET('CHS-ASSETS') THEN
                    ERROR(Text001);
                AccScheduleLine.COPYFILTERS("Acc. Schedule Line");
                AccScheduleLine.SETRANGE("Schedule Name", 'CHS-ASSETS');
                AccScheduleLine.SETFILTER("Row No.", '=%1', FORMAT(AccScheduleName."Right Start Line Number"));
                IF AccScheduleLine.FIND('-') THEN
                    RightColStartLineNo := AccScheduleLine."Line No."
            end;
        }
        dataitem(BalanceSheetLine; Integer)
        {
            DataItemTableView = SORTING(Number)
                                ORDER(Ascending);
            column(CompanyInfo_Name; companyinfo.Name)
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
            column(txtDescription; txtDescription)
            {
            }
            column(RowNumber; RowNumber)
            {
            }
            column(LColAmount; LColAmount)
            {
            }
            column(LColAmount2; LColAmount2)
            {
            }
            column(txtDescription2; txtDescription2)
            {
            }
            column(RowNumber2; RowNumber2)
            {
            }
            column(RColAmount; RColAmount)
            {
            }
            column(RColAmount2; RColAmount2)
            {
            }
            column(Balance_SheetCaption; Balance_SheetCaptionLbl)
            {
            }
            column(Unit_OrganizationCaption; Unit_OrganizationCaptionLbl)
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
            column(Enterprise_01_TableCaption; Enterprise_01_TableCaptionLbl)
            {
            }
            column(Unit_____RMBCaption; Unit_____RMBCaptionLbl)
            {
            }
            column(AssetCaption; AssetCaptionLbl)
            {
            }
            column(LineCaption; LineCaptionLbl)
            {
            }
            column(Beginning_BalanceCaption; Beginning_BalanceCaptionLbl)
            {
            }
            column(Balance_at_DateCaption; Balance_at_DateCaptionLbl)
            {
            }
            column(Liabilities_and_CapitalCaption; Liabilities_and_CapitalCaptionLbl)
            {
            }
            column(LineCaption_Control1000000016; LineCaption_Control1000000016Lbl)
            {
            }
            column(Beginning_BalanceCaption_Control1000000017; Beginning_BalanceCaption_Control1000000017Lbl)
            {
            }
            column(Balance_at_DateCaption_Control1000000018; Balance_at_DateCaption_Control1000000018Lbl)
            {
            }
            column(BalanceSheetLine_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin

                IF Number = 1 THEN BEGIN
                    AccLine1.FIND('-');
                    AccLine2.FIND('-');
                END ELSE BEGIN
                    IF Number <= LeftRaws THEN
                        AccLine1.NEXT;
                    IF Number <= RightRaws THEN
                        AccLine2.NEXT;
                    /*
                   IF AccLine1."New Page" = TRUE THEN
                       CurrReport.NEWPAGE;
                     */
                END;
                //Get Left Side
                IF (Number <= LeftRaws) THEN BEGIN
                    IF "Use Description 2" THEN
                        txtDescription := AccLine1."Description 2"
                    ELSE
                        txtDescription := AccLine1.Description;
                    RowNumber := AccLine1."Row No.";
                    LColAmount := AccSchMgt.CalcCell(AccLine1, TempColumn1, FALSE);
                    LColAmount2 := AccSchMgt.CalcCell(AccLine1, TempColumn2, FALSE);
                END ELSE BEGIN
                    txtDescription := '';
                    RowNumber := '';
                    LColAmount := 0;
                    LColAmount2 := 0;
                END;
                //Get Right Side
                IF (Number <= RightRaws) THEN BEGIN
                    IF "Use Description 2" THEN
                        txtDescription2 := AccLine2."Description 2"
                    ELSE
                        txtDescription2 := AccLine2.Description;
                    RowNumber2 := AccLine2."Row No.";
                    RColAmount := AccSchMgt.CalcCell(AccLine2, TempColumn1, FALSE);
                    RColAmount2 := AccSchMgt.CalcCell(AccLine2, TempColumn2, FALSE);
                END ELSE BEGIN
                    txtDescription2 := '';
                    RowNumber2 := '';
                    RColAmount := 0;
                    RColAmount2 := 0;
                END;
            end;

            trigger OnPreDataItem()
            begin

                IF NOT ChineseReportSetup.GET('CHS-ASSETS') THEN
                    ERROR(Text50000);

                TempColumn1.SETRANGE("Column Layout Name", 'CHSBS');
                //#1-1 Begin
                //TempColumn1.SETRANGE("Column No.",'beginbal');
                TempColumn1.SETRANGE("Column Type", TempColumn1."Column Type"::"Beginning Balance");
                //#1-1 END
                IF NOT TempColumn1.FIND('-') THEN
                    ERROR(Text50012, 'beginbal');

                TempColumn2.SETRANGE("Column Layout Name", 'CHSBS');
                //#1-2 Begin
                //TempColumn2.SETRANGE("Column No.",'endbal');
                //ACWSH2.00-->2009.02.17
                //TempColumn2.SETRANGE("Column Type",TempColumn2."Column Type"::"Year to Date");
                TempColumn2.SETRANGE("Column Type", TempColumn2."Column Type"::"Balance at Date");
                //<--ACWSH2.00
                //#1-2 END
                IF NOT TempColumn2.FIND('-') THEN
                    ERROR(Text50012, 'endbal');

                AccLine1.COPYFILTERS("Acc. Schedule Line");
                AccLine1.SETRANGE("Schedule Name", 'CHS-ASSETS');
                AccLine1.SETRANGE(Show, AccLine1.Show::Yes);
                AccLine1.SETRANGE("Line No.", ChineseReportSetup."Left Start Line Number", ChineseReportSetup."Left End Line Number");

                AccLine2.COPYFILTERS("Acc. Schedule Line");
                AccLine2.SETRANGE("Schedule Name", 'CHS-ASSETS');
                AccLine2.SETRANGE(Show, AccLine2.Show::Yes);
                AccLine2.SETRANGE("Line No.", ChineseReportSetup."Right Start Line Number", ChineseReportSetup."Right End Line Number");

                LeftRaws := AccLine1.COUNT;
                RightRaws := AccLine2.COUNT;
                IF RightRaws > LeftRaws THEN
                    BalanceSheetLine.SETRANGE(Number, 1, RightRaws)
                ELSE
                    BalanceSheetLine.SETRANGE(Number, 1, LeftRaws);
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
        IF "Acc. Schedule Line".GETFILTER("Date Filter") = '' THEN
            ERROR(Text002);
        DateFilterMax := "Acc. Schedule Line".GETRANGEMAX("Date Filter");
        companyinfo.GET;
    end;

    var
        Text001: Label 'You have not defined the Balance Sheet Report in Account Schedule';
        Text002: Label 'You have not defined Date Filter.';
        Text003: Label 'CN Report Column Layout or %1 Column has not been defined.';
        "CompanyInfo-old": Record "Company Information";
        AccScheduleName: Record "Acc. Schedule Name";
        ColumnLayout1: Record "Column Layout";
        ColumnLayout2: Record "Column Layout";
        AccScheduleLine: Record "Acc. Schedule Line";
        AccScheduleLine1: Record "Acc. Schedule Line";
        AccScheduleLine2: Record "Acc. Schedule Line";
        RightColStartLineNo: Integer;
        txtDescription: Text[80];
        txtDescription2: Text[80];
        RowNumber: Code[10];
        RowNumber2: Code[10];
        LeftRowNumber: Integer;
        RightRowNumber: Integer;
        "DateFilterMax-old": Date;
        "Print Description 2": Boolean;
        Balance_SheetCaptionLbl: Label '资 产 负 债 表';
        Unit_OrganizationCaptionLbl: Label 'Unit_OrganizationCaptionLbl:';
        YearCaptionLbl: Label '年';
        MonthCaptionLbl: Label '月';
        DayCaptionLbl: Label '日';
        Enterprise_01_TableCaptionLbl: Label '会企01表';
        Unit_____RMBCaptionLbl: Label 'Unit_____RMBCaptionLbl';
        AssetCaptionLbl: Label '资产';
        LineCaptionLbl: Label '行';
        Beginning_BalanceCaptionLbl: Label '年初数';
        Balance_at_DateCaptionLbl: Label '期末数';
        Liabilities_and_CapitalCaptionLbl: Label '负债所有者权益';
        LineCaption_Control1000000016Lbl: Label '行';
        Beginning_BalanceCaption_Control1000000017Lbl: Label '年初数';
        Balance_at_DateCaption_Control1000000018Lbl: Label '期末数';
        "Grcd_Localization Setup": Record "Markup & Added Value";
        "--New": Integer;
        ChineseReportSetup: Record "Acc. Schedule Name";
        TempColumn1: Record "Column Layout";
        TempColumn2: Record "Column Layout";
        AccLine1: Record "Acc. Schedule Line";
        AccLine2: Record "Acc. Schedule Line";
        LColAmount: Decimal;
        LColAmount2: Decimal;
        RColAmount: Decimal;
        RColAmount2: Decimal;
        vDescription: Text[80];
        vDescription2: Text[80];
        vRaw: Code[10];
        vRaw2: Code[10];
        LeftRaws: Integer;
        RightRaws: Integer;
        AccSchMgt: Codeunit AccSchedManagement;
        DateFilterMax: Date;
        "Use Description 2": Boolean;
        companyinfo: Record "Company Information";
        Text50000: Label 'Missing ''CHS-PL'' in Acc. Schedule Name setup';
        Text50010: Label 'Date filter is not valid';
        Text50012: Label 'Column %1 is missing';
}

