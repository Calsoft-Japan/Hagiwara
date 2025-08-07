report 50032 "Inventory Valuation HA"
{
    // CS092 FDD S001 Bobby.ji 2025/8/7 - Upgrade to the BC version

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Inventory Valuation HA.rdlc';
    Caption = 'Inventory Valuation With Location And Date';
    EnableHyperlinks = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Inventory Posting Group")
                                WHERE(Type = CONST(Inventory));
            RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group";
            column(BoM_Text; BoM_TextLbl)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_; STRSUBSTNO('%1: %2', TABLECAPTION, ItemFilter))
            {
            }
            column(STRSUBSTNO_Text005_StartDateText_; STRSUBSTNO(Text005, StartDateText))
            {
            }
            column(STRSUBSTNO_Text005_FORMAT_EndDate__; STRSUBSTNO(Text005, FORMAT(EndDate)))
            {
            }
            column(ShowExpected; ShowExpected)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(Inventory_ValuationCaption; Inventory_ValuationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_report_includes_entries_that_have_been_posted_with_expected_costs_Caption; This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl)
            {
            }
            column(ItemNoCaption; ValueEntry.FIELDCAPTION("Item No."))
            {
            }
            column(ItemDescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(IncreaseInvoicedQtyCaption; IncreaseInvoicedQtyCaptionLbl)
            {
            }
            column(DecreaseInvoicedQtyCaption; DecreaseInvoicedQtyCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(ValueCaption; ValueCaptionLbl)
            {
            }
            column(QuantityCaption_Control31; QuantityCaption_Control31Lbl)
            {
            }
            column(QuantityCaption_Control40; QuantityCaption_Control40Lbl)
            {
            }
            column(InvCostPostedToGL_Control53Caption; InvCostPostedToGL_Control53CaptionLbl)
            {
            }
            column(QuantityCaption_Control58; QuantityCaption_Control58Lbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Expected_Cost_IncludedCaption; Expected_Cost_IncludedCaptionLbl)
            {
            }
            column(Expected_Cost_Included_TotalCaption; Expected_Cost_Included_TotalCaptionLbl)
            {
            }
            column(Expected_Cost_TotalCaption; Expected_Cost_TotalCaptionLbl)
            {
            }
            column(GetUrlForReportDrilldown; GetUrlForReportDrilldown("No."))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(ItemDescription; Description)
            {
            }
            column(ItemBaseUnitofMeasure; "Base Unit of Measure")
            {
            }
            column(Item_Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            column(StartingInvoicedValue; StartingInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingInvoicedQty; StartingInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(StartingExpectedValue; StartingExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingExpectedQty; StartingExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseInvoicedValue; IncreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseInvoicedQty; IncreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseExpectedValue; IncreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseExpectedQty; IncreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseInvoicedValue; DecreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseInvoicedQty; DecreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseExpectedValue; DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseExpectedQty; DecreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(EndingInvoicedValue; StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue)
            {
            }
            column(EndingInvoicedQty; StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty)
            {
            }
            column(EndingExpectedValue; StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(EndingExpectedQty; StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty)
            {
            }
            column(CostPostedToGL; CostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(InvCostPostedToGL; InvCostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(ExpCostPostedToGL; ExpCostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(PostingDateCaptionLbl; PostingDateCaptionLbl)
            {
            }
            column(LocationCaptionLbl; LocationCaptionLbl)
            {
            }
            dataitem(ItemLocation; Integer)
            {
                column(TempItemNo; TempItemLedgerEntry."Item No.")
                {
                }
                column(LocationCode; TempItemLedgerEntry."Location Code")
                {
                }
                column(PostingDate; FORMAT(TempItemLedgerEntry."Posting Date", 0, '<Month>/<Day>/<Year4>'))
                {
                }
                column(TempStartingInvoicedQty; TempItemLedgerEntry.StartingInvoicedQty)
                {
                }
                column(TempStartingInvoicedValue; TempItemLedgerEntry.StartingInvoicedValue)
                {
                }
                column(TempIncreaseInvoicedQty; TempItemLedgerEntry.IncreaseInvoicedQty)
                {
                }
                column(TempIncreaseInvoicedValue; TempItemLedgerEntry.IncreaseInvoicedValue)
                {
                }
                column(TempDecreaseInvoicedQty; TempItemLedgerEntry.DecreaseInvoicedQty)
                {
                }
                column(TempDecreaseInvoicedValue; TempItemLedgerEntry.DecreaseInvoicedValue)
                {
                }
                column(TempEndingInvoicedQty; TempItemLedgerEntry.StartingInvoicedQty + TempItemLedgerEntry.IncreaseInvoicedQty - TempItemLedgerEntry.DecreaseInvoicedQty)
                {
                }
                column(TempEndingInvoicedValue; TempItemLedgerEntry.StartingInvoicedValue + TempItemLedgerEntry.IncreaseInvoicedValue - TempItemLedgerEntry.DecreaseInvoicedValue)
                {
                }
                column(TempSumStartingInvoicedValue; TempItemLedgerEntry.SumStartingInvoicedValue)
                {
                }
                column(TempSumStartingExpectedValue; TempItemLedgerEntry.SumStartingExpectedValue)
                {
                }
                column(TempSumIncreaseInvoicedValue; TempItemLedgerEntry.SumIncreaseInvoicedValue)
                {
                }
                column(TempSumIncreaseExpectedValue; TempItemLedgerEntry.SumIncreaseExpectedValue)
                {
                }
                column(TempSumDecreaseInvoicedValue; TempItemLedgerEntry.SumDecreaseInvoicedValue)
                {
                }
                column(TempSumDecreaseExpectedValue; TempItemLedgerEntry.SumDecreaseExpectedValue)
                {
                }
                column(TempSumInvCostPostedToGL; TempItemLedgerEntry.SumInvCostPostedToGL)
                {
                }
                column(TempSumExpCostPostedToGL; TempItemLedgerEntry.SumExpCostPostedToGL)
                {
                }
                column(TempSumCostPostedToGL; TempItemLedgerEntry.SumCostPostedToGL)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //CS090 begin
                    IF Number = 1 THEN
                        TempItemLedgerEntry.FIND('-')
                    ELSE
                        TempItemLedgerEntry.NEXT;
                    //CS090 end
                end;

                trigger OnPreDataItem()
                begin
                    //CS090 begin
                    SETRANGE(Number, 1, TempItemLedgerEntry.COUNT);
                    //CS090 end
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Assembly BOM");

                IF EndDate = 0D THEN
                    EndDate := DMY2DATE(31, 12, 9999);

                StartingInvoicedValue := 0;
                StartingExpectedValue := 0;
                StartingInvoicedQty := 0;
                StartingExpectedQty := 0;
                IncreaseInvoicedValue := 0;
                IncreaseExpectedValue := 0;
                IncreaseInvoicedQty := 0;
                IncreaseExpectedQty := 0;
                DecreaseInvoicedValue := 0;
                DecreaseExpectedValue := 0;
                DecreaseInvoicedQty := 0;
                DecreaseExpectedQty := 0;
                InvCostPostedToGL := 0;
                CostPostedToGL := 0;
                ExpCostPostedToGL := 0;


                IsEmptyLine := TRUE;
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item No.", "No.");
                ValueEntry.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
                ValueEntry.SETFILTER("Location Code", GETFILTER("Location Filter"));
                ValueEntry.SETFILTER("Global Dimension 1 Code", GETFILTER("Global Dimension 1 Filter"));
                ValueEntry.SETFILTER("Global Dimension 2 Code", GETFILTER("Global Dimension 2 Filter"));

                IF StartDate > 0D THEN BEGIN
                    ValueEntry.SETRANGE("Posting Date", 0D, CALCDATE('<-1D>', StartDate));
                    ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                    AssignAmounts(ValueEntry, StartingInvoicedValue, StartingInvoicedQty, StartingExpectedValue, StartingExpectedQty, 1);
                    IsEmptyLine := IsEmptyLine AND ((StartingInvoicedValue = 0) AND (StartingInvoicedQty = 0));
                    IF ShowExpected THEN
                        IsEmptyLine := IsEmptyLine AND ((StartingExpectedValue = 0) AND (StartingExpectedQty = 0));
                END;

                ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                ValueEntry.SETFILTER(
                  "Item Ledger Entry Type", '%1|%2|%3|%4',
                  ValueEntry."Item Ledger Entry Type"::Purchase,
                  ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                  ValueEntry."Item Ledger Entry Type"::Output,
                  ValueEntry."Item Ledger Entry Type"::"Assembly Output");
                ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);

                ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                ValueEntry.SETFILTER(
                  "Item Ledger Entry Type", '%1|%2|%3|%4',
                  ValueEntry."Item Ledger Entry Type"::Sale,
                  ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                  ValueEntry."Item Ledger Entry Type"::Consumption,
                  ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");
                ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1);

                ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Transfer);
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        IF TRUE IN [ValueEntry."Valued Quantity" < 0, NOT GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.")] THEN
                            AssignAmounts(ValueEntry, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1)
                        ELSE
                            AssignAmounts(ValueEntry, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);
                    UNTIL ValueEntry.NEXT = 0;

                IsEmptyLine := IsEmptyLine AND ((IncreaseInvoicedValue = 0) AND (IncreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine AND ((DecreaseInvoicedValue = 0) AND (DecreaseInvoicedQty = 0));
                IF ShowExpected THEN BEGIN
                    IsEmptyLine := IsEmptyLine AND ((IncreaseExpectedValue = 0) AND (IncreaseExpectedQty = 0));
                    IsEmptyLine := IsEmptyLine AND ((DecreaseExpectedValue = 0) AND (DecreaseExpectedQty = 0));
                END;

                ValueEntry.SETRANGE("Posting Date", 0D, EndDate);
                ValueEntry.SETRANGE("Item Ledger Entry Type");
                ValueEntry.CALCSUMS("Cost Posted to G/L", "Expected Cost Posted to G/L");
                ExpCostPostedToGL += ValueEntry."Expected Cost Posted to G/L";
                InvCostPostedToGL += ValueEntry."Cost Posted to G/L";

                StartingExpectedValue += StartingInvoicedValue;
                IncreaseExpectedValue += IncreaseInvoicedValue;
                DecreaseExpectedValue += DecreaseInvoicedValue;
                CostPostedToGL := ExpCostPostedToGL + InvCostPostedToGL;

                //SumStartingInvoicedValue := SumStartingInvoicedValue + StartingInvoicedValue;
                //SumStartingExpectedValue := SumStartingExpectedValue + StartingExpectedValue;
                //SumIncreaseInvoicedValue := SumIncreaseInvoicedValue + IncreaseInvoicedValue;
                //SumIncreaseExpectedValue := SumIncreaseExpectedValue + IncreaseExpectedValue;
                //SumDecreaseInvoicedValue := SumDecreaseInvoicedValue + DecreaseInvoicedValue;
                //SumDecreaseExpectedValue := SumDecreaseExpectedValue + DecreaseExpectedValue;
                //SumExpCostPostedToGL := SumExpCostPostedToGL + ExpCostPostedToGL;
                //SumInvCostPostedToGL := SumInvCostPostedToGL + InvCostPostedToGL;
                //SumCostPostedToGL := SumCostPostedToGL + CostPostedToGL;
                IF IsEmptyLine THEN
                    CurrReport.SKIP;

                //CS090 begin
                TempItemLedgerEntry.DELETEALL();
                CLEAR(QItemLedgerEntry);
                QItemLedgerEntry.SETRANGE(Posting_Date, 0D, EndDate);
                QItemLedgerEntry.SETRANGE(ItemNo, "No.");
                QItemLedgerEntry.OPEN;
                TempItemLedgerEntryNo := 0;
                WHILE QItemLedgerEntry.READ() DO BEGIN
                    IF QItemLedgerEntry.Sum_Quantity > 0 THEN BEGIN
                        TempItemLedgerEntry.RESET();
                        TempItemLedgerEntry.SETRANGE("Item No.", QItemLedgerEntry.Item_No);
                        IF TempItemLedgerEntry.FINDFIRST() THEN BEGIN
                            SumStartingInvoicedValue := 0;
                            SumStartingExpectedValue := 0;
                            SumIncreaseInvoicedValue := 0;
                            SumIncreaseExpectedValue := 0;
                            SumDecreaseInvoicedValue := 0;
                            SumDecreaseExpectedValue := 0;
                            SumExpCostPostedToGL := 0;
                            SumInvCostPostedToGL := 0;
                            SumCostPostedToGL := 0;
                        END
                        ELSE BEGIN
                            SumStartingInvoicedValue := StartingInvoicedValue;
                            SumStartingExpectedValue := StartingExpectedValue;
                            SumIncreaseInvoicedValue := IncreaseInvoicedValue;
                            SumIncreaseExpectedValue := IncreaseExpectedValue;
                            SumDecreaseInvoicedValue := DecreaseInvoicedValue;
                            SumDecreaseExpectedValue := DecreaseExpectedValue;
                            SumExpCostPostedToGL := ExpCostPostedToGL;
                            SumInvCostPostedToGL := InvCostPostedToGL;
                            SumCostPostedToGL := CostPostedToGL;
                        END;

                        TempItemLedgerEntry.INIT();
                        TempItemLedgerEntry."Entry No." := TempItemLedgerEntryNo;
                        TempItemLedgerEntry."Item No." := QItemLedgerEntry.Item_No;
                        TempItemLedgerEntry."Location Code" := QItemLedgerEntry.Location_Code;
                        //TempItemLedgerEntry.Quantity := QItemLedgerEntry.Sum_Quantity;

                        ItemLedgerEntry.RESET();
                        ItemLedgerEntry.SETRANGE("Item No.", TempItemLedgerEntry."Item No.");
                        ItemLedgerEntry.SETRANGE("Location Code", TempItemLedgerEntry."Location Code");
                        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Posting Date");
                        ItemLedgerEntry.SETFILTER(Quantity, '>0');
                        ItemLedgerEntry.ASCENDING(FALSE);
                        IF ItemLedgerEntry.FINDFIRST() THEN BEGIN
                            TempItemLedgerEntry."Posting Date" := ItemLedgerEntry."Posting Date";
                        END;

                        ValueEntry.RESET();
                        ValueEntry.SETRANGE("Item No.", TempItemLedgerEntry."Item No.");
                        ValueEntry.SETFILTER("Variant Code", GETFILTER("Variant Filter"));
                        ValueEntry.SETFILTER("Location Code", TempItemLedgerEntry."Location Code");
                        ValueEntry.SETFILTER("Global Dimension 1 Code", GETFILTER("Global Dimension 1 Filter"));
                        ValueEntry.SETFILTER("Global Dimension 2 Code", GETFILTER("Global Dimension 2 Filter"));

                        IF StartDate > 0D THEN BEGIN
                            ValueEntry.SETRANGE("Posting Date", 0D, CALCDATE('<-1D>', StartDate));
                            ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");

                            TempItemLedgerEntry.StartingInvoicedQty += ValueEntry."Invoiced Quantity";
                            TempItemLedgerEntry.StartingInvoicedValue += ValueEntry."Cost Amount (Actual)";
                        END;

                        ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        ValueEntry.SETFILTER(
                          "Item Ledger Entry Type", '%1|%2|%3|%4',
                          ValueEntry."Item Ledger Entry Type"::Purchase,
                          ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                          ValueEntry."Item Ledger Entry Type"::Output,
                          ValueEntry."Item Ledger Entry Type"::"Assembly Output");
                        ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                        TempItemLedgerEntry.IncreaseInvoicedQty += ValueEntry."Invoiced Quantity";
                        TempItemLedgerEntry.IncreaseInvoicedValue += ValueEntry."Cost Amount (Actual)";

                        ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        ValueEntry.SETFILTER(
                          "Item Ledger Entry Type", '%1|%2|%3|%4',
                          ValueEntry."Item Ledger Entry Type"::Sale,
                          ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                          ValueEntry."Item Ledger Entry Type"::Consumption,
                          ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");
                        ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                        //AssignAmounts(ValueEntry,DecreaseInvoicedValue,DecreaseInvoicedQty,DecreaseExpectedValue,DecreaseExpectedQty,-1);
                        TempItemLedgerEntry.DecreaseInvoicedQty += ValueEntry."Invoiced Quantity" * -1;
                        TempItemLedgerEntry.DecreaseInvoicedValue += ValueEntry."Cost Amount (Actual)" * -1;

                        ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Transfer);
                        IF ValueEntry.FINDSET THEN
                            REPEAT
                                IF TRUE IN [ValueEntry."Valued Quantity" < 0, NOT GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.")] THEN BEGIN
                                    TempItemLedgerEntry.DecreaseInvoicedQty += ValueEntry."Invoiced Quantity" * -1;
                                    TempItemLedgerEntry.DecreaseInvoicedValue += ValueEntry."Cost Amount (Actual)" * -1;
                                END
                                ELSE BEGIN
                                    TempItemLedgerEntry.IncreaseInvoicedQty += ValueEntry."Invoiced Quantity";
                                    TempItemLedgerEntry.IncreaseInvoicedValue += ValueEntry."Cost Amount (Actual)";
                                END;
                            UNTIL ValueEntry.NEXT = 0;

                        TempItemLedgerEntry.SumStartingInvoicedValue := SumStartingInvoicedValue;
                        TempItemLedgerEntry.SumStartingExpectedValue := SumStartingExpectedValue;
                        TempItemLedgerEntry.SumIncreaseInvoicedValue := SumIncreaseInvoicedValue;
                        TempItemLedgerEntry.SumIncreaseExpectedValue := SumIncreaseExpectedValue;
                        TempItemLedgerEntry.SumDecreaseInvoicedValue := SumDecreaseInvoicedValue;
                        TempItemLedgerEntry.SumDecreaseExpectedValue := SumDecreaseExpectedValue;
                        TempItemLedgerEntry.SumInvCostPostedToGL := SumInvCostPostedToGL;
                        TempItemLedgerEntry.SumExpCostPostedToGL := SumExpCostPostedToGL;
                        TempItemLedgerEntry.SumCostPostedToGL := SumCostPostedToGL;

                        TempItemLedgerEntry.INSERT();
                        TempItemLedgerEntryNo := TempItemLedgerEntryNo + 1;
                    END
                    ELSE BEGIN
                        TempItemLedgerEntry.RESET();
                        TempItemLedgerEntry.SETRANGE("Item No.", QItemLedgerEntry.Item_No);
                        IF TempItemLedgerEntry.FINDFIRST() THEN BEGIN
                            SumStartingInvoicedValue := 0;
                            SumStartingExpectedValue := 0;
                            SumIncreaseInvoicedValue := 0;
                            SumIncreaseExpectedValue := 0;
                            SumDecreaseInvoicedValue := 0;
                            SumDecreaseExpectedValue := 0;
                            SumExpCostPostedToGL := 0;
                            SumInvCostPostedToGL := 0;
                            SumCostPostedToGL := 0;
                        END
                        ELSE BEGIN
                            SumStartingInvoicedValue := StartingInvoicedValue;
                            SumStartingExpectedValue := StartingExpectedValue;
                            SumIncreaseInvoicedValue := IncreaseInvoicedValue;
                            SumIncreaseExpectedValue := IncreaseExpectedValue;
                            SumDecreaseInvoicedValue := DecreaseInvoicedValue;
                            SumDecreaseExpectedValue := DecreaseExpectedValue;
                            SumExpCostPostedToGL := ExpCostPostedToGL;
                            SumInvCostPostedToGL := InvCostPostedToGL;
                            SumCostPostedToGL := CostPostedToGL;
                        END;

                        TempItemLedgerEntry.INIT();
                        TempItemLedgerEntry."Entry No." := TempItemLedgerEntryNo;
                        TempItemLedgerEntry."Item No." := QItemLedgerEntry.Item_No;
                        TempItemLedgerEntry."Location Code" := '';

                        TempItemLedgerEntry.SumStartingInvoicedValue := SumStartingInvoicedValue;
                        TempItemLedgerEntry.SumStartingExpectedValue := SumStartingExpectedValue;
                        TempItemLedgerEntry.SumIncreaseInvoicedValue := SumIncreaseInvoicedValue;
                        TempItemLedgerEntry.SumIncreaseExpectedValue := SumIncreaseExpectedValue;
                        TempItemLedgerEntry.SumDecreaseInvoicedValue := SumDecreaseInvoicedValue;
                        TempItemLedgerEntry.SumDecreaseExpectedValue := SumDecreaseExpectedValue;
                        TempItemLedgerEntry.SumInvCostPostedToGL := SumInvCostPostedToGL;
                        TempItemLedgerEntry.SumExpCostPostedToGL := SumExpCostPostedToGL;
                        TempItemLedgerEntry.SumCostPostedToGL := SumCostPostedToGL;

                        TempItemLedgerEntry.INSERT();
                        TempItemLedgerEntryNo := TempItemLedgerEntryNo + 1;
                    END;

                END;
                QItemLedgerEntry.CLOSE();

                //CS090 end
            end;

            trigger OnPreDataItem()
            begin
                /*CurrReport.CREATETOTALS(
                  StartingExpectedQty, IncreaseExpectedQty, DecreaseExpectedQty,
                  StartingInvoicedQty, IncreaseInvoicedQty, DecreaseInvoicedQty);
                CurrReport.CREATETOTALS(
                  StartingExpectedValue, IncreaseExpectedValue, DecreaseExpectedValue,
                  StartingInvoicedValue, IncreaseInvoicedValue, DecreaseInvoicedValue,
                  CostPostedToGL, ExpCostPostedToGL, InvCostPostedToGL);
                  */
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
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(IncludeExpectedCost; ShowExpected)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Expected Cost';
                        ToolTip = 'Specifies if you want the report to also show entries that only have expected costs.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF (StartDate = 0D) AND (EndDate = 0D) THEN
                EndDate := WORKDATE;
        end;
    }

    labels
    {
        Inventory_Posting_Group_NameCaption = 'Inventory Posting Group Name';
        Expected_CostCaption = 'Expected Cost';
    }

    trigger OnPreReport()
    begin
        IF (StartDate = 0D) AND (EndDate = 0D) THEN
            EndDate := WORKDATE;

        IF StartDate IN [0D, 00000101D] THEN
            StartDateText := ''
        ELSE
            StartDateText := FORMAT(StartDate - 1);

        ItemFilter := Item.GETFILTERS;
    end;

    var
        Text005: Label 'As of %1';
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempItemLedgerEntry: Record "Inventory Valuation HA" temporary;
        QItemLedgerEntry: Query "Inventory Valuation HA";
        StartDate: Date;
        EndDate: Date;
        ShowExpected: Boolean;
        ItemFilter: Text;
        StartDateText: Text[10];
        StartingInvoicedValue: Decimal;
        StartingExpectedValue: Decimal;
        StartingInvoicedQty: Decimal;
        StartingExpectedQty: Decimal;
        IncreaseInvoicedValue: Decimal;
        IncreaseExpectedValue: Decimal;
        IncreaseInvoicedQty: Decimal;
        IncreaseExpectedQty: Decimal;
        DecreaseInvoicedValue: Decimal;
        DecreaseExpectedValue: Decimal;
        DecreaseInvoicedQty: Decimal;
        DecreaseExpectedQty: Decimal;
        BoM_TextLbl: Label 'Base UoM';
        Inventory_ValuationCaptionLbl: Label 'Inventory Valuation';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl: Label 'This report includes entries that have been posted with expected costs.';
        IncreaseInvoicedQtyCaptionLbl: Label 'Increases (LCY)';
        DecreaseInvoicedQtyCaptionLbl: Label 'Decreases (LCY)';
        QuantityCaptionLbl: Label 'Quantity';
        ValueCaptionLbl: Label 'Value';
        QuantityCaption_Control31Lbl: Label 'Quantity';
        QuantityCaption_Control40Lbl: Label 'Quantity';
        InvCostPostedToGL_Control53CaptionLbl: Label 'Cost Posted to G/L';
        QuantityCaption_Control58Lbl: Label 'Quantity';
        TotalCaptionLbl: Label 'Total';
        Expected_Cost_Included_TotalCaptionLbl: Label 'Expected Cost Included Total';
        Expected_Cost_TotalCaptionLbl: Label 'Expected Cost Total';
        Expected_Cost_IncludedCaptionLbl: Label 'Expected Cost Included';
        InvCostPostedToGL: Decimal;
        CostPostedToGL: Decimal;
        ExpCostPostedToGL: Decimal;
        SumStartingInvoicedValue: Decimal;
        SumStartingExpectedValue: Decimal;
        SumIncreaseInvoicedValue: Decimal;
        SumIncreaseExpectedValue: Decimal;
        SumDecreaseInvoicedValue: Decimal;
        SumDecreaseExpectedValue: Decimal;
        SumExpCostPostedToGL: Decimal;
        SumInvCostPostedToGL: Decimal;
        SumCostPostedToGL: Decimal;
        IsEmptyLine: Boolean;
        PostingDateCaptionLbl: Label 'Posting Date';
        LocationCaptionLbl: Label 'Location';
        TempItemLedgerEntryNo: Integer;
        TempItemNo: Code[20];
        BufferValue1: Decimal;

    local procedure AssignAmounts(ValueEntry: Record "Value Entry"; var InvoicedValue: Decimal; var InvoicedQty: Decimal; var ExpectedValue: Decimal; var ExpectedQty: Decimal; Sign: Decimal)
    begin
        InvoicedValue += ValueEntry."Cost Amount (Actual)" * Sign;
        InvoicedQty += ValueEntry."Invoiced Quantity" * Sign;
        ExpectedValue += ValueEntry."Cost Amount (Expected)" * Sign;
        ExpectedQty += ValueEntry."Item Ledger Entry Quantity" * Sign;
    end;

    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ItemApplnEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntryNo);
        IF NOT ItemApplnEntry.FINDFIRST THEN
            EXIT(TRUE);

        ItemLedgEntry.SETRANGE("Item No.", Item."No.");
        ItemLedgEntry.SETFILTER("Variant Code", Item.GETFILTER("Variant Filter"));
        ItemLedgEntry.SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
        ItemLedgEntry.SETFILTER("Global Dimension 1 Code", Item.GETFILTER("Global Dimension 1 Filter"));
        ItemLedgEntry.SETFILTER("Global Dimension 2 Code", Item.GETFILTER("Global Dimension 2 Filter"));
        ItemLedgEntry."Entry No." := ItemApplnEntry."Outbound Item Entry No.";
        EXIT(NOT ItemLedgEntry.FIND);
    end;

    procedure SetStartDate(DateValue: Date)
    begin
        StartDate := DateValue;
    end;

    procedure SetEndDate(DateValue: Date)
    begin
        EndDate := DateValue;
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewShowExpected: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        ShowExpected := NewShowExpected;
    end;

    local procedure GetUrlForReportDrilldown(ItemNumber: Code[20]): Text
    begin
        // Generates a URL to the report which sets tab "Item" and field "Field1" on the request page, such as
        // dynamicsnav://hostname:port/instance/company/runreport?report=5801<&Tenant=tenantId>&filter=Item.Field1:1100.
        // TODO
        // Eventually leverage parameters 5 and 6 of GETURL by adding ",Item,TRUE)" and
        // use filter Item.SETFILTER("No.",'=%1',ItemNumber);.
        EXIT(GETURL(CURRENTCLIENTTYPE, COMPANYNAME, OBJECTTYPE::Report, REPORT::"Invt. Valuation - Cost Spec.") +
          STRSUBSTNO('&filter=Item.Field1:%1', ItemNumber));
    end;
}

