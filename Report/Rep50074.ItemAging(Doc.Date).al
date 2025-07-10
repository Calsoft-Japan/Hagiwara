report 50074 "Item Aging (Doc. Date)"
{
    // CS092 Bobby.Ji 2025/7/2 - Upgade to the BC version

    Caption = 'Item Aging (Doc. Date)';

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Item Aging (Doc. Date).rdlc';

    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Type = CONST(Inventory));
            RequestFilterFields = Blocked, "No.", "Inventory Posting Group", "Statistics Group", "Location Filter";
            column(TodayFormatted; FORMAT(TODAY, 0, 4))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(ItemTableCaptItemFilter; TABLECAPTION + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(PeriodStartDate21; FORMAT(PeriodStartDate[2] + 1))
            {
            }
            column(PeriodStartDate3; FORMAT(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate31; FORMAT(PeriodStartDate[3] + 1))
            {
            }
            column(PeriodStartDate4; FORMAT(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate41; FORMAT(PeriodStartDate[4] + 1))
            {
            }
            column(PeriodStartDate5; FORMAT(PeriodStartDate[5]))
            {
            }
            column(PrintLine; PrintLine)
            {
            }
            column(InvtValueRTC1; InvtValueRTC[1])
            {
            }
            column(InvtValueRTC2; InvtValueRTC[2])
            {
            }
            column(InvtValueRTC5; InvtValueRTC[5])
            {
            }
            column(InvtValueRTC4; InvtValueRTC[4])
            {
            }
            column(InvtValueRTC3; InvtValueRTC[3])
            {
            }
            column(TotalInvtValueRTC; TotalInvtValueRTC)
            {
            }
            column(InvtValue1_Item; InvtValue[1])
            {
                AutoFormatType = 1;
            }
            column(InvtValue2_Item; InvtValue[2])
            {
                AutoFormatType = 1;
            }
            column(InvtValue3_Item; InvtValue[3])
            {
                AutoFormatType = 1;
            }
            column(InvtValue4_Item; InvtValue[4])
            {
                AutoFormatType = 1;
            }
            column(InvtValue5_Item; InvtValue[5])
            {
                AutoFormatType = 1;
            }
            column(TotalInvtValue_Item; TotalInvtValue_Item)
            {
                AutoFormatType = 1;
            }
            column(ItemAgeCompositionValueCaption; ItemAgeCompositionValueCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(AfterCaption; AfterCaptionLbl)
            {
            }
            column(BeforeCaption; BeforeCaptionLbl)
            {
            }
            column(InventoryValueCaption; InventoryValueCaptionLbl)
            {
            }
            column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
            {
            }
            column(ItemNoCaption; ItemNoCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(NoItem; "No.")
            {
            }
            column(Desc_Item; Description)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }

            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No."),
                               "Location Code" = FIELD("Location Filter"),
                               "Variant Code" = FIELD("Variant Filter"),
                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Item No.", Open)
                                    WHERE(Open = CONST(true));

                trigger OnAfterGetRecord()
                begin
                    IF "Remaining Quantity" = 0 THEN
                        CurrReport.SKIP;
                    PrintLine := TRUE;
                    CalcRemainingQty;

                    IF Item."Costing Method" = Item."Costing Method"::Average THEN BEGIN
                        TotalInvtValue_Item += AverageCost * TotalInvtQty;
                        InvtValue[i] += AverageCost * InvtQty[i];

                        TotalInvtValueRTC += AverageCost * TotalInvtQty;
                        InvtValueRTC[i] += AverageCost * InvtQty[i];
                    END ELSE BEGIN
                        CalcUnitCost;
                        TotalInvtValue_Item += UnitCost * ABS(TotalInvtQty);
                        InvtValue[i] += UnitCost * ABS(InvtQty[i]);

                        TotalInvtValueRTC += UnitCost * ABS(TotalInvtQty);
                        InvtValueRTC[i] += UnitCost * ABS(InvtQty[i]);
                    END
                end;

                trigger OnPreDataItem()
                begin
                    TotalInvtValue_Item := 0;
                    FOR i := 1 TO 5 DO
                        InvtValue[i] := 0;
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(TotalInvtValue_ItemLedgEntry; TotalInvtValue_Item)
                {
                    AutoFormatType = 1;
                }
                column(InvtValue5_ItemLedgEntry; InvtValue[5])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue4_ItemLedgEntry; InvtValue[4])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue3_ItemLedgEntry; InvtValue[3])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue2_ItemLedgEntry; InvtValue[2])
                {
                    AutoFormatType = 1;
                }
                column(InvtValue1_ItemLedgEntry; InvtValue[1])
                {
                    AutoFormatType = 1;
                }
                column(Description_Item; Item.Description)
                {
                }
                column(No_Item; Item."No.")
                {
                }
                column(InvtQty1_ItemLedgEntry; InvtQty[1])
                {
                    DecimalPlaces = 0 : 2;
                }
                column(InvtQty2_ItemLedgEntry; InvtQty[2])
                {
                    DecimalPlaces = 0 : 2;
                }
                column(InvtQty3_ItemLedgEntry; InvtQty[3])
                {
                    DecimalPlaces = 0 : 2;
                }
                column(InvtQty4_ItemLedgEntry; InvtQty[4])
                {
                    DecimalPlaces = 0 : 2;
                }
                column(InvtQty5_ItemLedgEntry; InvtQty[5])
                {
                    DecimalPlaces = 0 : 2;
                }
                column(TotalInvtQty; TotalInvtQty)
                {
                    DecimalPlaces = 0 : 2;
                }
            }
            trigger OnAfterGetRecord()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                IF "Costing Method" = "Costing Method"::Average THEN
                    ItemCostMgt.CalculateAverageCost(Item, AverageCost, AverageCostACY);

                PrintLine := FALSE;

                TotalInvtQty := 0;
                FOR i := 1 TO 5 DO
                    InvtQty[i] := 0;
                //ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
                ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Document Date");//change posting date to Document Date
                ItemLedgEntry.SETRANGE("Item No.", "No.");
                ItemLedgEntry.SETRANGE(Open, TRUE);
                ItemLedgEntry.SETFILTER("Location Code", "Location Filter");
                ItemLedgEntry.SETFILTER("Variant Code", "Variant Filter");
                ItemLedgEntry.SETFILTER("Global Dimension 1 Code", "Global Dimension 1 Filter");
                ItemLedgEntry.SETFILTER("Global Dimension 2 Code", "Global Dimension 2 Filter");
                IF ItemLedgEntry.FINDSET THEN
                    REPEAT
                        PrintLine := TRUE;
                        TotalInvtQty := TotalInvtQty + ItemLedgEntry."Remaining Quantity";
                        FOR i := 1 TO 5 DO
                            IF (ItemLedgEntry."Document Date" > PeriodStartDate[i]) AND (ItemLedgEntry."Document Date" <= PeriodStartDate[i + 1]) THEN       //change posting date to Document Date
                                InvtQty[i] := InvtQty[i] + ItemLedgEntry."Remaining Quantity";
                    UNTIL ItemLedgEntry.NEXT = 0;


                //Document Date

                //Posting Date
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CREATETOTALS(InvtValue, TotalInvtValue_Item);
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
                    field(EndingDate; PeriodStartDate[5])
                    {
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            IF PeriodStartDate[5] = 0D THEN
                                ERROR(Text002);
                        end;
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        Caption = 'Period Length';

                        trigger OnValidate()
                        begin
                            IF FORMAT(PeriodLength) = '' THEN
                                EVALUATE(PeriodLength, '<0D>');
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF PeriodStartDate[5] = 0D THEN
                PeriodStartDate[5] := CALCDATE('<CM>', WORKDATE);
            IF FORMAT(PeriodLength) = '' THEN
                EVALUATE(PeriodLength, '<1M>');
        end;
    }
    labels
    {
    }

    trigger OnPreReport()
    var
        NegPeriodLength: DateFormula;
    begin
        ItemFilter := Item.GETFILTERS;

        PeriodStartDate[6] := 99991231D;
        EVALUATE(NegPeriodLength, STRSUBSTNO('-%1', FORMAT(PeriodLength)));
        FOR i := 1 TO 3 DO
            PeriodStartDate[5 - i] := CALCDATE(NegPeriodLength, PeriodStartDate[6 - i]);
    end;

    var
        Text002: Label 'Enter the ending date';
        ItemCostMgt: Codeunit ItemCostManagement;
        ItemFilter: Text;
        InvtValue: array[6] of Decimal;
        InvtValueRTC: array[6] of Decimal;
        InvtQty: array[6] of Decimal;
        UnitCost: Decimal;
        PeriodStartDate: array[6] of Date;
        PeriodLength: DateFormula;
        i: Integer;
        TotalInvtValue_Item: Decimal;
        TotalInvtValueRTC: Decimal;
        TotalInvtQty: Decimal;
        PrintLine: Boolean;
        AverageCost: Decimal;
        AverageCostACY: Decimal;
        ItemAgeCompositionValueCaptionLbl: Label 'Item Aging (Doc. Date)';
        CurrReportPageNoCaptionLbl: Label 'Page';
        PageNoCaptionLbl: Label 'Page';
        AfterCaptionLbl: Label 'After...';
        BeforeCaptionLbl: Label '...Before';
        InventoryValueCaptionLbl: Label 'Inventory';
        ItemDescriptionCaptionLbl: Label 'Description';
        ItemNoCaptionLbl: Label 'Item No.';
        TotalCaptionLbl: Label 'Total';

    procedure CalcRemainingQty()
    begin
        FOR i := 1 TO 5 DO
            InvtQty[i] := 0;

        TotalInvtQty := "Item Ledger Entry"."Remaining Quantity";
        FOR i := 1 TO 5 DO
            IF ("Item Ledger Entry"."Document Date" > PeriodStartDate[i]) AND
               //change posting date to Document Date
               ("Item Ledger Entry"."Document Date" <= PeriodStartDate[i + 1])
            THEN
                IF "Item Ledger Entry"."Remaining Quantity" <> 0 THEN BEGIN
                    InvtQty[i] := "Item Ledger Entry"."Remaining Quantity";
                    EXIT;
                END;
    end;

    procedure CalcUnitCost()
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
        UnitCost := 0;

        IF ValueEntry.FIND('-') THEN
            REPEAT
                IF ValueEntry."Partial Revaluation" THEN
                    SumUnitCost(UnitCost, ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)", ValueEntry."Valued Quantity")
                ELSE
                    SumUnitCost(UnitCost, ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)", "Item Ledger Entry".Quantity);
            UNTIL ValueEntry.NEXT = 0;
    end;

    local procedure SumUnitCost(var UnitCost: Decimal; CostAmount: Decimal; Quantity: Decimal)
    begin
        UnitCost := UnitCost + CostAmount / ABS(Quantity);
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewPeriodLength: DateFormula)
    begin
        PeriodStartDate[5] := NewEndingDate;
        PeriodLength := NewPeriodLength;
    end;
}

