report 50088 "ITE Update Price"
{
    //T20250508.0050 Shawn 2025/05/10
    //CS112 Mei 2025/7/30 UpdatePrice logic changed

    ProcessingOnly = true;

    dataset
    {
        dataitem("Inventory Trace Entry"; "Inventory Trace Entry")
        {
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin

        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        RecPurchasePrice: Record "Price List Line";
        RecInventoryTraceEntry: Record "Inventory Trace Entry";
        RecInventorySetup: Record "Inventory Setup";
    begin

        //CS112 Begin
        RecInventorySetup.GET();
        IteEndDateForUpdatePrice := RecInventorySetup."ITE End Date for Update Price";
        IF IteEndDateForUpdatePrice = 0D THEN BEGIN
            EXIT;
        END;
        //CS112 End

        RecGeneralLedgerSetup.GET();
        RecItem.RESET();
        RecItem.SETRANGE(Blocked, FALSE);
        IF RecItem.FINDSET() THEN BEGIN
            REPEAT
                RecPurchasePrice.RESET();
                RecPurchasePrice.SETRANGE("Price Type", RecPurchasePrice."Price Type"::Purchase);
                RecPurchasePrice.SETRANGE(Status, RecPurchasePrice.Status::Active);
                RecPurchasePrice.SETRANGE("Asset No.", RecItem."No.");
                //CS112 Begin
                //RecPurchasePrice.SETFILTER("Starting Date",'>=%1',StartingDate);
                RecPurchasePrice.SETFILTER("Starting Date", '<=%1', IteEndDateForUpdatePrice);
                //CS112 End
                RecPurchasePrice.SETCURRENTKEY("Starting Date");
                RecPurchasePrice.ASCENDING(FALSE);
                IF RecPurchasePrice.FINDFIRST THEN BEGIN
                    RecInventoryTraceEntry.RESET();
                    //T20250508 Begin
                    //RecInventoryTraceEntry.SETRANGE("Purch. Item No.",RecItem."No.");
                    RecInventoryTraceEntry.SETRANGE("Item No", RecItem."No.");
                    //T20250508 End
                    //RecInventoryTraceEntry.SETFILTER("Posting Date",'<%1',StartingDate); //CS112
                    IF RecInventoryTraceEntry.FINDSET() THEN BEGIN
                        REPEAT
                            IF (RecInventoryTraceEntry."New Ship&Debit Flag" OR RecPurchasePrice."Ship&Debit Flag") THEN BEGIN

                                RecInventoryTraceEntry."New Ship&Debit Flag" := RecPurchasePrice."Ship&Debit Flag";

                                IF RecPurchasePrice."PC. Update Price" THEN BEGIN
                                    IF RecPurchasePrice."PC. Direct Unit Cost" > 0 THEN BEGIN
                                        RecInventoryTraceEntry."New PC. Cost Currency" := RecPurchasePrice."PC. Currency Code";
                                        RecInventoryTraceEntry."New PC. Direct Unit Cost" := RecPurchasePrice."PC. Direct Unit Cost";
                                        RecInventoryTraceEntry."INV. Purchase Currency" := RecPurchasePrice."PC. Currency Code";
                                        RecInventoryTraceEntry."INV. Purchase Price" := RecPurchasePrice."PC. Direct Unit Cost";

                                        IF RecPurchasePrice."PC. Currency Code" = '' THEN BEGIN
                                            RecInventoryTraceEntry."New PC. Cost Currency" := RecGeneralLedgerSetup."LCY Code";
                                            RecInventoryTraceEntry."INV. Purchase Currency" := RecGeneralLedgerSetup."LCY Code";
                                        END;
                                    END;
                                END ELSE BEGIN
                                    IF RecPurchasePrice."Direct Unit Cost" > 0 THEN BEGIN
                                        RecInventoryTraceEntry."New Cost Currency" := RecPurchasePrice."Currency Code";
                                        RecInventoryTraceEntry."New Direct Unit Cost" := RecPurchasePrice."Direct Unit Cost";
                                        RecInventoryTraceEntry."INV. Purchase Currency" := RecPurchasePrice."Currency Code";
                                        RecInventoryTraceEntry."INV. Purchase Price" := RecPurchasePrice."Direct Unit Cost";

                                        IF RecPurchasePrice."Currency Code" = '' THEN BEGIN
                                            RecInventoryTraceEntry."New Cost Currency" := RecGeneralLedgerSetup."LCY Code";
                                            RecInventoryTraceEntry."INV. Purchase Currency" := RecGeneralLedgerSetup."LCY Code";
                                        END;
                                    END;
                                END;

                                //CS112 Begin
                                IF (RecInventoryTraceEntry."Posting Date" >= RecPurchasePrice."Starting Date") THEN BEGIN
                                    IF RecPurchasePrice."PC. Update Price" THEN BEGIN
                                        RecInventoryTraceEntry."SLS. Purchase Currency" := RecPurchasePrice."PC. Currency Code";
                                        RecInventoryTraceEntry."SLS. Purchase Price" := RecPurchasePrice."PC. Direct Unit Cost";
                                    END ELSE BEGIN
                                        RecInventoryTraceEntry."SLS. Purchase Currency" := RecPurchasePrice."Currency Code";
                                        RecInventoryTraceEntry."SLS. Purchase Price" := RecPurchasePrice."Direct Unit Cost";
                                    END;
                                END;
                                //CS112 End

                                RecInventoryTraceEntry.MODIFY();
                            END;
                        UNTIL RecInventoryTraceEntry.NEXT() = 0;
                    END;
                END;
            UNTIL RecItem.NEXT() = 0;
        END;

        //CS112 Begin
        RecInventorySetup."ITE End Date for Update Price" := IteEndDateForUpdatePrice + 1;
        RecInventorySetup.MODIFY();
        //CS112 End

        MESSAGE('Update Price completed.');
    end;

    var
        RecGeneralLedgerSetup: Record "General Ledger Setup";
        RecItem: Record Item;
        IteEndDateForUpdatePrice: Date;
}

