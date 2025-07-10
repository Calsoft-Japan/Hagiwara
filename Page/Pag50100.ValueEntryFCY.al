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
                // Define the fields to be displayed in the list
                field("Document Type"; Rec."Document Type") { }
                field("Source Type"; Rec."Source Type") { }
                field("Entry Type"; Rec."Entry Type") { }
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
                field("Customer Item No."; Rec."Customer Item No.") { }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Document Date"; Rec."Document Date") { }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)") { }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L") { }
                field("Cost Amount (Non-Invtbl.)"; Rec."Cost Amount (Non-Invtbl.)") { }
                field("Expected Cost"; Rec."Expected Cost") { }
                field("Document Line No."; Rec."Document Line No.") { }
                field("Order No."; Rec."Order No.") { }
                field("Order Line No."; Rec."Order Line No.") { }
                field("Reason Code"; Rec."Reason Code") { }
                field("Drop Shipment"; Rec."Drop Shipment") { }
                field("Journal Batch Name"; Rec."Journal Batch Name") { }
                field("Valuation Date"; Rec."Valuation Date") { }
                field("Vendor familiar name"; Rec."Vendor familiar name") { }
                field("Customer familiar name"; Rec."Customer familiar name") { }
                field("Vendor Name"; Rec."Vendor Name") { }
                field("Vendor No."; Rec."Vendor No.") { }
                field("Manufacturer Code"; Rec."Manufacturer Code") { }
                field("Customer Name"; Rec."Customer Name") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Item Description"; ItemDescription) { }
                field("Return Reason Code"; Rec."Return Reason Code") { }
                field("No."; Rec."No.") { }
                field("Type"; Rec."Type") { }
                field("Capacity Ledger Entry No."; Rec."Capacity Ledger Entry No.") { }
                field("Average Cost Exception"; Rec."Average Cost Exception") { }
                field("Variant Code"; Rec."Variant Code") { }
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
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { }
            }
        }
    }

    var
        CurrencyCode: Code[10];
        UnitCostLCY: Decimal;
        UnitPriceLCY: Decimal;
        AmountFCY: Decimal;
        Item: Record Item;
        ItemDescription: Text[100];

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

        // Set Item Description
        if Rec."Item No." <> '' then
            if Item.Get(Rec."Item No.") then
                ItemDescription := Item.Description;

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