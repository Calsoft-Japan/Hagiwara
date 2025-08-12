report 50032 "Inventory Valuation HA"
{
    // //20250531 Shawn CS090.
    // //20250713 Shawn CS090. Include Location which End Value is not 0 (even quanity is 0).
    // CS092 FDD S001 Bobby.Ji 2025/8/7 - Upgade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Inv Val Rep with Loc & Date.rdlc';

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
            column(StartingInvoicedValue_ForGroup; StartingInvoicedValue_ForGroup)
            {
            }
            column(StartingExpectedValue_ForGroup; StartingExpectedValue_ForGroup)
            {
            }
            column(StartingInvoicedQty_ForGroup; StartingInvoicedQty_ForGroup)
            {
            }
            column(StartingExpectedQty_ForGroup; StartingExpectedQty_ForGroup)
            {
            }
            column(IncreaseInvoicedValue_ForGroup; IncreaseInvoicedValue_ForGroup)
            {
            }
            column(IncreaseExpectedValue_ForGroup; IncreaseExpectedValue_ForGroup)
            {
            }
            column(IncreaseInvoicedQty_ForGroup; IncreaseInvoicedQty_ForGroup)
            {
            }
            column(IncreaseExpectedQty_ForGroup; IncreaseExpectedQty_ForGroup)
            {
            }
            column(DecreaseInvoicedValue_ForGroup; DecreaseInvoicedValue_ForGroup)
            {
            }
            column(DecreaseExpectedValue_ForGroup; DecreaseExpectedValue_ForGroup)
            {
            }
            column(DecreaseInvoicedQty_ForGroup; DecreaseInvoicedQty_ForGroup)
            {
            }
            column(DecreaseExpectedQty_ForGroup; DecreaseExpectedQty_ForGroup)
            {
            }
            column(InvCostPostedToGL_ForGroup; InvCostPostedToGL_ForGroup)
            {
            }
            column(CostPostedToGL_ForGroup; CostPostedToGL_ForGroup)
            {
            }
            column(ExpCostPostedToGL_ForGroup; ExpCostPostedToGL_ForGroup)
            {
            }
            column(EndingInvoicedValue_ForGroup; EndingInvoicedValue_ForGroup)
            {
            }
            column(EndingInvoicedQty_ForGroup; EndingInvoicedQty_ForGroup)
            {
            }
            column(EndingExpectedValue_ForGroup; EndingExpectedValue_ForGroup)
            {
            }
            column(EndingExpectedQty_ForGroup; EndingExpectedQty_ForGroup)
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
                column(TempStartingInvoicedValue_ForGroup; TempItemLedgerEntry.SumStartingInvoicedValue)
                {
                }
                column(TempStartingExpectedValue_ForGroup; TempItemLedgerEntry.SumStartingExpectedValue)
                {
                }
                column(TempIncreaseInvoicedValue_ForGroup; TempItemLedgerEntry.SumIncreaseInvoicedValue)
                {
                }
                column(TempIncreaseExpectedValue_ForGroup; TempItemLedgerEntry.SumIncreaseExpectedValue)
                {
                }
                column(TempDecreaseInvoicedValue_ForGroup; TempItemLedgerEntry.SumDecreaseInvoicedValue)
                {
                }
                column(TempDecreaseExpectedValue_ForGroup; TempItemLedgerEntry.SumDecreaseExpectedValue)
                {
                }
                column(TempEndingInvoicedQty_ForGroup; TempItemLedgerEntry.SumStartingInvoicedQty + TempItemLedgerEntry.SumIncreaseInvoicedQty - TempItemLedgerEntry.SumDecreaseInvoicedQty)
                {
                }
                column(TempEndingInvoicedValue_ForGroup; TempItemLedgerEntry.SumStartingInvoicedValue + TempItemLedgerEntry.SumIncreaseInvoicedValue - TempItemLedgerEntry.SumDecreaseInvoicedValue)
                {
                }
                column(TempEndingExpectedQty_ForGroup; TempItemLedgerEntry.SumStartingExpectedQty + TempItemLedgerEntry.SumIncreaseExpectedQty - TempItemLedgerEntry.SumDecreaseExpectedQty)
                {
                }
                column(TempEndingExpectedValue_ForGroup; TempItemLedgerEntry.SumStartingExpectedValue + TempItemLedgerEntry.SumIncreaseExpectedValue - TempItemLedgerEntry.SumDecreaseExpectedValue)
                {
                }
                column(TempInvCostPostedToGL_ForGroup; TempItemLedgerEntry.SumInvCostPostedToGL)
                {
                }
                column(TempExpCostPostedToGL_ForGroup; TempItemLedgerEntry.SumExpCostPostedToGL)
                {
                }
                column(TempCostPostedToGL_ForGroup; TempItemLedgerEntry.SumCostPostedToGL)
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
                //CS090 BEGIN
                //For those items which has no location detail data.
                StartingInvoicedValue_ForGroup := 0;
                StartingExpectedValue_ForGroup := 0;
                StartingInvoicedQty_ForGroup := 0;
                StartingExpectedQty_ForGroup := 0;
                IncreaseInvoicedValue_ForGroup := 0;
                IncreaseExpectedValue_ForGroup := 0;
                IncreaseInvoicedQty_ForGroup := 0;
                IncreaseExpectedQty_ForGroup := 0;
                DecreaseInvoicedValue_ForGroup := 0;
                DecreaseExpectedValue_ForGroup := 0;
                DecreaseInvoicedQty_ForGroup := 0;
                DecreaseExpectedQty_ForGroup := 0;
                InvCostPostedToGL_ForGroup := 0;
                CostPostedToGL_ForGroup := 0;
                ExpCostPostedToGL_ForGroup := 0;
                EndingInvoicedValue_ForGroup := 0;
                EndingInvoicedQty_ForGroup := 0;
                EndingExpectedValue_ForGroup := 0;
                EndingExpectedQty_ForGroup := 0;
                //CS090 END

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

                IF IsEmptyLine THEN
                    CurrReport.SKIP;


                //CS090 begin
                TempItemLedgerEntry.DELETEALL();
                CLEAR(QValueEntry);
                QValueEntry.SETRANGE(Posting_Date, 0D, EndDate);
                QValueEntry.SETRANGE(ItemNo, "No.");
                QValueEntry.SETFILTER(LocationCode, GETFILTER("Location Filter")); //CS090
                QValueEntry.OPEN;
                TempItemLedgerEntryNo := 0;
                IsItemDetailInserted := FALSE; //CS090
                WHILE QValueEntry.READ() DO BEGIN
                    //IF QValueEntry.Sum_Quantity > 0 THEN BEGIN //CS090
                    IF QValueEntry.Sum_Cost_Actual <> 0 THEN BEGIN
                        /*//CS090
                        TempItemLedgerEntry.RESET();
                        TempItemLedgerEntry.SETRANGE("Item No.",QValueEntry.Item_No);
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
                        */

                        TempItemLedgerEntry.INIT();
                        TempItemLedgerEntry."Entry No." := TempItemLedgerEntryNo;
                        TempItemLedgerEntry."Item No." := QValueEntry.Item_No;
                        TempItemLedgerEntry."Location Code" := QValueEntry.Location_Code;
                        //TempItemLedgerEntry.Quantity := QValueEntry.Sum_Quantity;

                        ItemLedgerEntry.RESET();
                        ItemLedgerEntry.SETRANGE("Item No.", TempItemLedgerEntry."Item No.");
                        //ItemLedgerEntry.SETRANGE("Location Code",TempItemLedgerEntry."Location Code"); //CS090
                        //CS090 BEGIN
                        ItemLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
                        ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                        //CS090 END
                        ItemLedgerEntry.SETCURRENTKEY("Item No.", "Posting Date");
                        //ItemLedgerEntry.SETFILTER(Quantity,'>0'); //CS090
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

                            TempItemLedgerEntry.StartingInvoicedQty := ValueEntry."Invoiced Quantity";
                            TempItemLedgerEntry.StartingInvoicedValue := ValueEntry."Cost Amount (Actual)";
                        END;

                        ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        ValueEntry.SETFILTER(
                          "Item Ledger Entry Type", '%1|%2|%3|%4',
                          ValueEntry."Item Ledger Entry Type"::Purchase,
                          ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                          ValueEntry."Item Ledger Entry Type"::Output,
                          ValueEntry."Item Ledger Entry Type"::"Assembly Output");
                        ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                        TempItemLedgerEntry.IncreaseInvoicedQty := ValueEntry."Invoiced Quantity";
                        TempItemLedgerEntry.IncreaseInvoicedValue := ValueEntry."Cost Amount (Actual)";

                        ValueEntry.SETRANGE("Posting Date", StartDate, EndDate);
                        ValueEntry.SETFILTER(
                          "Item Ledger Entry Type", '%1|%2|%3|%4',
                          ValueEntry."Item Ledger Entry Type"::Sale,
                          ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                          ValueEntry."Item Ledger Entry Type"::Consumption,
                          ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");
                        ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                        //AssignAmounts(ValueEntry,DecreaseInvoicedValue,DecreaseInvoicedQty,DecreaseExpectedValue,DecreaseExpectedQty,-1);
                        TempItemLedgerEntry.DecreaseInvoicedQty := ValueEntry."Invoiced Quantity" * -1;
                        TempItemLedgerEntry.DecreaseInvoicedValue := ValueEntry."Cost Amount (Actual)" * -1;

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

                        //CS090 Begin
                        //Only set one time for one Item.
                        //Otherwise the total on report will be multipled if there are multiple location inventory for one Item.
                        IF NOT IsItemDetailInserted THEN BEGIN

                            TempItemLedgerEntry.SumStartingInvoicedQty := StartingInvoicedQty;
                            TempItemLedgerEntry.SumIncreaseInvoicedQty := IncreaseInvoicedQty;
                            TempItemLedgerEntry.SumDecreaseInvoicedQty := DecreaseInvoicedQty;
                            TempItemLedgerEntry.SumStartingExpectedQty := StartingExpectedQty;
                            TempItemLedgerEntry.SumIncreaseExpectedQty := IncreaseExpectedQty;
                            TempItemLedgerEntry.SumDecreaseExpectedQty := DecreaseExpectedQty;
                            TempItemLedgerEntry.SumStartingInvoicedValue := StartingInvoicedValue;
                            TempItemLedgerEntry.SumStartingExpectedValue := StartingExpectedValue;
                            TempItemLedgerEntry.SumIncreaseInvoicedValue := IncreaseInvoicedValue;
                            TempItemLedgerEntry.SumIncreaseExpectedValue := IncreaseExpectedValue;
                            TempItemLedgerEntry.SumDecreaseInvoicedValue := DecreaseInvoicedValue;
                            TempItemLedgerEntry.SumDecreaseExpectedValue := DecreaseExpectedValue;
                            TempItemLedgerEntry.SumInvCostPostedToGL := InvCostPostedToGL;
                            TempItemLedgerEntry.SumExpCostPostedToGL := ExpCostPostedToGL;
                            TempItemLedgerEntry.SumCostPostedToGL := CostPostedToGL;
                        END;
                        //CS090 End

                        TempItemLedgerEntry.INSERT();
                        TempItemLedgerEntryNo := TempItemLedgerEntryNo + 1;
                        IsItemDetailInserted := TRUE; //CS090
                    END
                    /*//CS090
                      ELSE BEGIN
                        TempItemLedgerEntry.RESET();
                        TempItemLedgerEntry.SETRANGE("Item No.",QValueEntry.Item_No);
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
                        TempItemLedgerEntry."Item No." := QValueEntry.Item_No;
                        TempItemLedgerEntry."Location Code" :='';

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
                        TempItemLedgerEntryNo := TempItemLedgerEntryNo+1;
                      END;
                    */

                END;
                QValueEntry.CLOSE();

                //Only Items has no location data will use these values to summarize.
                IF NOT IsItemDetailInserted THEN BEGIN

                    StartingInvoicedValue_ForGroup := StartingInvoicedValue;
                    StartingExpectedValue_ForGroup := StartingExpectedValue;
                    StartingInvoicedQty_ForGroup := StartingInvoicedQty;
                    StartingExpectedQty_ForGroup := StartingExpectedQty;
                    IncreaseInvoicedValue_ForGroup := IncreaseInvoicedValue;
                    IncreaseExpectedValue_ForGroup := IncreaseExpectedValue;
                    IncreaseInvoicedQty_ForGroup := IncreaseInvoicedQty;
                    IncreaseExpectedQty_ForGroup := IncreaseExpectedQty;
                    DecreaseInvoicedValue_ForGroup := DecreaseInvoicedValue;
                    DecreaseExpectedValue_ForGroup := DecreaseExpectedValue;
                    DecreaseInvoicedQty_ForGroup := DecreaseInvoicedQty;
                    DecreaseExpectedQty_ForGroup := DecreaseExpectedQty;
                    InvCostPostedToGL_ForGroup := InvCostPostedToGL;
                    CostPostedToGL_ForGroup := CostPostedToGL;
                    ExpCostPostedToGL_ForGroup := ExpCostPostedToGL;
                    EndingInvoicedValue_ForGroup := StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue;
                    EndingInvoicedQty_ForGroup := StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty;
                    EndingExpectedValue_ForGroup := StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue;
                    EndingExpectedQty_ForGroup := StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty;

                END;

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
        TempItemLedgerEntry: Record "Inv Val Rep with Loc & Date" temporary;
        QValueEntry: Query "Inv Val Rep with Loc & Date";
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
        TempItemLedgerEntryNo: Integer;
        TempItemNo: Code[20];
        BufferValue1: Decimal;
        IsItemDetailInserted: Boolean;
        ItemLocCnt: Integer;
        StartingInvoicedValue_ForGroup: Decimal;
        StartingExpectedValue_ForGroup: Decimal;
        StartingInvoicedQty_ForGroup: Decimal;
        StartingExpectedQty_ForGroup: Decimal;
        IncreaseInvoicedValue_ForGroup: Decimal;
        IncreaseExpectedValue_ForGroup: Decimal;
        IncreaseInvoicedQty_ForGroup: Decimal;
        IncreaseExpectedQty_ForGroup: Decimal;
        DecreaseInvoicedValue_ForGroup: Decimal;
        DecreaseExpectedValue_ForGroup: Decimal;
        DecreaseInvoicedQty_ForGroup: Decimal;
        DecreaseExpectedQty_ForGroup: Decimal;
        InvCostPostedToGL_ForGroup: Decimal;
        CostPostedToGL_ForGroup: Decimal;
        ExpCostPostedToGL_ForGroup: Decimal;
        EndingInvoicedValue_ForGroup: Decimal;
        EndingInvoicedQty_ForGroup: Decimal;
        EndingExpectedValue_ForGroup: Decimal;
        EndingExpectedQty_ForGroup: Decimal;

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

