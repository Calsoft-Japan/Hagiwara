page 50100 "Value Entry FCY"
{
    PageType = List;
    SourceTable = "Value Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Value Entries with Foreign Currency';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    //SourceTableView = where("Adjustment" = const(false));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Item No."; Rec."Item No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Item Ledger Entry Type"; Rec."Item Ledger Entry Type") { }
                field("Source No."; Rec."Source No.") { }
                field("Document No."; Rec."Document No.") { }
                field("Description"; Rec."Description") { }
                field("Location Code"; Rec."Location Code") { }
                field("Inventory Posting Group"; Rec."Inventory Posting Group") { }
                field("Source Posting Group"; Rec."Source Posting Group") { }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.") { }
                field("Valued Quantity"; Rec."Valued Quantity") { }
                field("Item Ledger Entry Quantity"; Rec."Item Ledger Entry Quantity") { }
                field("Invoiced Quantity"; Rec."Invoiced Quantity") { }
                field("Cost per Unit"; Rec."Cost per Unit") { }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code") { }
                field("Discount Amount"; Rec."Discount Amount") { }
                field("User ID"; Rec."User ID") { }
                field("Source Code"; Rec."Source Code") { }
                field("Applies-to Entry"; Rec."Applies-to Entry") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Source Type"; Rec."Source Type") { }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)") { }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L") { }
                field("Reason Code"; Rec."Reason Code") { }
                field("Drop Shipment"; Rec."Drop Shipment") { }
                field("Journal Batch Name"; Rec."Journal Batch Name") { }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { }
                field("Document Date"; Rec."Document Date") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Return Reason Code"; Rec."Return Reason Code") { }
                field("Vendor Familiar Name"; Rec."Vendor familiar name") { }
                field("Customer Familiar Name"; Rec."Customer familiar name") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Vendor No."; Rec."Vendor No.") { }
                field("Manufacturer Code"; Rec."Manufacturer Code") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Item Description"; Rec."ItemDesc") { ApplicationArea = all; }
                field("Type"; Rec."Type") { }
                field("Capacity Ledger Entry No."; Rec."Capacity Ledger Entry No.") { }
                field("Average Cost Exception"; Rec."Average Cost Exception") { }
                field("Variant Code"; Rec."Variant Code") { }
                field("Adjustment"; Rec.Adjustment) { }
                field("Job Ledger Entry No."; Rec."Job Ledger Entry No.") { }
                field("Job Task No."; Rec."Job Task No.") { }
                field("Job No."; Rec."Job No.") { }
                field("Dimension Set ID"; Rec."Dimension Set ID") { }
                field("Exp. Cost Posted to G/L (ACY)"; Rec."Exp. Cost Posted to G/L (ACY)") { }
                field("Expected Cost Posted to G/L"; Rec."Expected Cost Posted to G/L") { }
                field("Cost Amount (Non-Invtbl.)(ACY)"; Rec."Cost Amount (Non-Invtbl.)(ACY)") { }
                field("Cost Amount (Expected)(ACY)"; Rec."Cost Amount (Expected) (ACY)") { }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)") { }
                field("Sales Amount (Actual)"; Rec."Sales Amount (Actual)") { }
                field("Sales Amount (Expected)"; Rec."Sales Amount (Expected)") { }
                field("Purchase Amount (Expected)"; Rec."Purchase Amount (Expected)") { }
                field("Purchase Amount (Actual)"; Rec."Purchase Amount (Actual)") { }
                field("Variance Type"; Rec."Variance Type") { }
                field("Inventoriable"; Rec."Inventoriable") { }
                field("Partial Revaluation"; Rec."Partial Revaluation") { }
                field("Valued By Average Cost"; Rec."Valued By Average Cost") { }
                field("Item Charge No."; Rec."Item Charge No.") { }
                field("Order Type"; Rec."Order Type") { }
                field("Cost Per Unit (ACY)"; Rec."Cost Per Unit (ACY)") { }
                field("Cost Posted to G/L (ACY)"; Rec."Cost Posted to G/L (ACY)") { }
                field("Cost Amount (Actual)(ACY)"; Rec."Cost Amount (Actual) (ACY)") { }

                // Virtual calculated fields
                field("Currency Code"; CurrencyCode)
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code';
                }
                field("Unit Cost (LCY)"; UnitCostLCY)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Cost (LCY)';
                }
                field("Unit Price (LCY)"; UnitPriceLCY)
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price (LCY)';
                }
                field("Amount (FCY)"; AmountFCY)
                {
                    ApplicationArea = All;
                    Caption = 'Amount (FCY)';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(CurrencyCode);
        Clear(UnitCostLCY);
        Clear(UnitPriceLCY);
        Clear(AmountFCY);

        case Rec."Document Type" of
            Enum::"Item Ledger Document Type"::"Purchase Invoice":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Vendor then begin
                        if PurchInvHeader.Get(Rec."Document No.") then begin
                            CurrencyCode := PurchInvHeader."Currency Code";
                            if PurchInvLine.Get(Rec."Document No.", Rec."Document Line No.") then begin
                                UnitCostLCY := PurchInvLine."Direct Unit Cost";
                                UnitPriceLCY := PurchInvLine."Direct Unit Cost";
                                if not Rec.Adjustment then
                                    AmountFCY := PurchInvLine."Line Amount";
                            end;
                        end;
                    end;
                end;

            Enum::"Item Ledger Document Type"::"Purchase Credit Memo":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Vendor then begin
                        if PurchCrMemoHeader.Get(Rec."Document No.") then
                            CurrencyCode := PurchCrMemoHeader."Currency Code";

                        if PurchCrMemoLine.Get(Rec."Document No.", Rec."Document Line No.") then begin
                            UnitCostLCY := PurchCrMemoLine."Unit Cost (LCY)";
                            UnitPriceLCY := PurchCrMemoLine."Unit Price (LCY)";
                            if not Rec.Adjustment then
                                AmountFCY := PurchCrMemoLine."Line Amount";
                        end;
                    end;
                end;

            Enum::"Item Ledger Document Type"::"Sales Invoice":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Customer then begin
                        if PostedSalesInvHdr.Get(Rec."Document No.") then
                            CurrencyCode := PostedSalesInvHdr."Currency Code";

                        if PostedSalesInvLine.Get(Rec."Document No.", Rec."Document Line No.") then begin
                            UnitCostLCY := PostedSalesInvLine."Unit Cost";
                            if PostedSalesInvHdr."Currency Factor" <> 0 then
                                UnitPriceLCY := PostedSalesInvLine."Unit Price" / PostedSalesInvHdr."Currency Factor"
                            else
                                UnitPriceLCY := PostedSalesInvLine."Unit Price";

                            if not Rec.Adjustment then
                                AmountFCY := PostedSalesInvLine."Line Amount";
                        end;
                    end;
                end;

            Enum::"Item Ledger Document Type"::"Sales Credit Memo":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Customer then begin
                        if SalesCrMemoHeader.Get(Rec."Document No.") then begin
                            CurrencyCode := SalesCrMemoHeader."Currency Code";
                            if SalesCrMemoLine.Get(Rec."Document No.", Rec."Document Line No.") then begin
                                UnitCostLCY := SalesCrMemoLine."Unit Cost (LCY)";
                                if SalesCrMemoHeader."Currency Factor" <> 0 then
                                    UnitPriceLCY := SalesCrMemoLine."Unit Price" / SalesCrMemoHeader."Currency Factor"
                                else
                                    UnitPriceLCY := SalesCrMemoLine."Unit Price";

                                if not Rec.Adjustment then
                                    AmountFCY := SalesCrMemoLine."Line Amount";
                            end;
                        end;
                    end;
                end;
        end;
    end;

    var
        CurrencyCode: Code[10];
        UnitCostLCY: Decimal;
        UnitPriceLCY: Decimal;
        AmountFCY: Decimal;
        PostedSalesInvHdr: Record "Sales Invoice Header";
        PostedSalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
}