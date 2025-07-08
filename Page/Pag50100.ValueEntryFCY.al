page 50100 "Value Entry FCY"
{
    PageType = List;
    SourceTable = "Value Entry";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Value Entries with Foreign Currency';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                // All fields from Value Entry (FDD Section 2.4.1)
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
                field("Adjustment"; Rec."Adjustment") { }
                field("Return Reason Code"; Rec."Return Reason Code") { }
                field("Customer Item No."; Rec."Customer Item No.") { }

                // Custom runtime-calculated virtual fields
                field("Currency Code"; CurrencyCode) { }
                field("Unit Cost (LCY)"; UnitCostLCY) { }
                field("Unit Price (LCY)"; UnitPriceLCY) { }
                field("Amount (FCY)"; AmountFCY) { }
            }
        }
    }

    var
        CurrencyCode: Code[10];
        UnitCostLCY: Decimal;
        UnitPriceLCY: Decimal;
        AmountFCY: Decimal;

        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";

    trigger OnAfterGetRecord()
    begin
        // Reset calculated fields before applying logic
        Clear(CurrencyCode);
        Clear(UnitCostLCY);
        Clear(UnitPriceLCY);
        Clear(AmountFCY);

        case Rec."Document Type" of

            // Case 1: Purchase Invoice
            Enum::"Item Ledger Document Type"::"Purchase Invoice":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Vendor then begin
                        if PurchHeader.Get(PurchHeader."Document Type"::Invoice, Rec."Document No.") then
                            CurrencyCode := PurchHeader."Currency Code";

                        if PurchLine.Get(PurchLine."Document Type"::Invoice, Rec."Document No.", Rec."Document Line No.") then begin
                            UnitCostLCY := PurchLine."Direct Unit Cost";
                            UnitPriceLCY := PurchLine."Direct Unit Cost";
                            if not Rec.Adjustment then
                                AmountFCY := PurchLine."Line Amount";
                        end;
                    end;
                end;

            // Case 2: Purchase Credit Memo
            Enum::"Item Ledger Document Type"::"Purchase Credit Memo":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Vendor then begin
                        if PurchHeader.Get(PurchHeader."Document Type"::"Credit Memo", Rec."Document No.") then
                            CurrencyCode := PurchHeader."Currency Code";

                        if PurchLine.Get(PurchLine."Document Type"::"Credit Memo", Rec."Document No.", Rec."Document Line No.") then begin
                            UnitCostLCY := PurchLine."Direct Unit Cost";
                            UnitPriceLCY := PurchLine."Direct Unit Cost";
                            if not Rec.Adjustment then
                                AmountFCY := PurchLine."Line Amount";
                        end;
                    end;
                end;

            // Case 3: Sales Invoice
            Enum::"Item Ledger Document Type"::"Sales Invoice":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Customer then begin
                        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, Rec."Document No.") then
                            CurrencyCode := SalesHeader."Currency Code";

                        if SalesLine.Get(SalesLine."Document Type"::Invoice, Rec."Document No.", Rec."Document Line No.") then begin
                            UnitCostLCY := SalesLine."Unit Cost";
                            if SalesHeader."Currency Factor" <> 0 then
                                UnitPriceLCY := SalesLine."Unit Price" / SalesHeader."Currency Factor"
                            else
                                UnitPriceLCY := SalesLine."Unit Price";

                            if not Rec.Adjustment then
                                AmountFCY := SalesLine."Line Amount";
                        end;
                    end;
                end;

            // Case 4: Sales Credit Memo
            Enum::"Item Ledger Document Type"::"Sales Credit Memo":
                begin
                    if Rec."Source Type" = Rec."Source Type"::Customer then begin
                        if SalesHeader.Get(SalesHeader."Document Type"::"Credit Memo", Rec."Document No.") then
                            CurrencyCode := SalesHeader."Currency Code";

                        if SalesLine.Get(SalesLine."Document Type"::"Credit Memo", Rec."Document No.", Rec."Document Line No.") then begin
                            UnitCostLCY := SalesLine."Unit Cost";
                            if SalesHeader."Currency Factor" <> 0 then
                                UnitPriceLCY := SalesLine."Unit Price" / SalesHeader."Currency Factor"
                            else
                                UnitPriceLCY := SalesLine."Unit Price";

                            if not Rec.Adjustment then
                                AmountFCY := SalesLine."Line Amount";
                        end;
                    end;
                end;
        end;
    end;
}