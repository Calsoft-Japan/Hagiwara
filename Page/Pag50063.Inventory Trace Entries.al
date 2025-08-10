page 50063 "Inventory Trace Entries"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Maintenance,Revision';
    Permissions = TableData "Item Ledger Entry" = rimd;
    SourceTable = "Inventory Trace Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Item Application Entry No."; Rec."Item Application Entry No.")
                {
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Item No"; Rec."Item No")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("OEM No."; Rec."OEM No.")
                {
                }
                field("OEM Name"; Rec."OEM Name")
                {
                }
                field("SCM Customer Code"; Rec."SCM Customer Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                }
                field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
                {
                }
                field("New Ship&Debit Flag"; Rec."New Ship&Debit Flag")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Remaining Quantity"; RemainingQty)
                {
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Importance = Promoted;
                    Visible = false;
                }
                field("Sales Quantity"; SalesQty)
                {
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Importance = Promoted;
                    Visible = false;
                }
                field("Sales Returned Quantity"; SalesRtnQty)
                {
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Importance = Promoted;
                    Visible = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                }
                field("Purch. Item No."; Rec."Purch. Item No.")
                {
                }
                field("Purch. Item Vendor No."; Rec."Purch. Item Vendor No.")
                {
                }
                field("Purch. Item Vendor Name"; Rec."Purch. Item Vendor Name")
                {
                }
                field("Purch. Item Manufacturer Code"; Rec."Purch. Item Manufacturer Code")
                {
                }
                field("Purch. Hagiwara Group"; Rec."Purch. Hagiwara Group")
                {
                }
                field("Cost Currency"; Rec."Cost Currency")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                }
                field("New Cost Currency"; Rec."New Cost Currency")
                {
                }
                field("New Direct Unit Cost"; Rec."New Direct Unit Cost")
                {
                }
                field("PC. Cost Currency"; Rec."PC. Cost Currency")
                {
                }
                field("PC. Direct Unit Cost"; Rec."PC. Direct Unit Cost")
                {
                }
                field("PC. Entry No."; Rec."PC. Entry No.")
                {
                }
                field("New PC. Cost Currency"; Rec."New PC. Cost Currency")
                {
                }
                field("New PC. Direct Unit Cost"; Rec."New PC. Direct Unit Cost")
                {
                }
                field("SLS. Purchase Price"; Rec."SLS. Purchase Price")
                {
                }
                field("SLS. Purchase Currency"; Rec."SLS. Purchase Currency")
                {
                }
                field("INV. Purchase Price"; Rec."INV. Purchase Price")
                {
                }
                field("INV. Purchase Currency"; Rec."INV. Purchase Currency")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Booking No."; Rec."Booking No.")
                {
                }
                field("Shipment Seq. No."; Rec."Shipment Seq. No.")
                {
                }
                field("Sales Price"; Rec."Sales Price")
                {
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                }
                field("Sales Currency"; Rec."Sales Currency")
                {
                }
                field("Original Document No."; Rec."Original Document No.")
                {
                }
                field("Original Document Line No."; Rec."Original Document Line No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Manually Updated"; Rec."Manually Updated")
                {
                }
                field(Note; Rec.Note)
                {
                    Importance = Promoted;
                    QuickEntry = false;
                    Visible = false;
                }
                field(Pattern; Rec.Pattern)
                {
                }
                field("Incoming Item Ledger Entry No."; Rec."Incoming Item Ledger Entry No.")
                {
                }
                field("Calc. Rem. Qty."; Rec."Calc. Rem. Qty.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("ITE Process")
            {
                Image = Confirm;
                action("Update Price")
                {
                    ApplicationArea = Basic, Suite;
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Report "ITE Update Price";
                    Visible = ShowUpdatePrice;

                    trigger OnAction()
                    begin
                    end;
                }
                action(Collect)
                {
                    ApplicationArea = Basic, Suite;
                    Image = ItemTracing;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowCollect;

                    trigger OnAction()
                    var
                        InvTraceMgt: Codeunit "Inventory Trace Management";
                        RecInventorySetup: Record "Inventory Setup";
                    begin

                        RecInventorySetup.GET();
                        IF NOT RecInventorySetup."Enable Inventory Trace" THEN
                            EXIT;

                        IF NOT CONFIRM('This will collect Inventory Trace Entries.') THEN
                            EXIT;

                        IF RecInventorySetup."ITE Start Date" = 0D THEN
                            IF NOT CONFIRM('ITE Start Date is blank.\All the data will be created, which will be a long time.\Are you sure to continue?') THEN
                                EXIT;

                        InvTraceMgt.BatchCreateInvTraceEntry();

                        MESSAGE('Inventory Trace Entries collection completed.');
                    end;
                }
                action(Delete)
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowDelete;

                    trigger OnAction()
                    var
                        RecInventorySetup: Record "Inventory Setup";
                        RecITE: Record "Inventory Trace Entry";
                    begin
                        RecInventorySetup.INIT();
                        RecInventorySetup.GET();
                        IF NOT CONFIRM('This will delete all the Inventory Trace Entries.\Are you sure to continue?') THEN
                            EXIT;

                        IF RecInventorySetup."ITE Start Date" = 0D THEN
                            IF NOT CONFIRM('ITE Start Date is blank.\All the data will be deleted.\Are you sure to continue?') THEN
                                EXIT;

                        RecITE.RESET();
                        RecITE.SETRANGE("Manually Updated", FALSE);
                        RecITE.SETFILTER("Posting Date", '%1..', RecInventorySetup."ITE Start Date");
                        IF RecInventorySetup."ITE End Date" <> 0D THEN
                            RecITE.SETFILTER("Posting Date", '%1..%2', RecInventorySetup."ITE Start Date", RecInventorySetup."ITE End Date");
                        IF RecInventorySetup."ITE Item No. Filter" <> '' THEN
                            RecITE.SETFILTER("Item No", RecInventorySetup."ITE Item No. Filter");
                        IF RecInventorySetup."ITE Manufacturer Code Filter" <> '' THEN
                            RecITE.SETFILTER("Manufacturer Code", RecInventorySetup."ITE Manufacturer Code Filter");

                        WHILE NOT RecITE.ISEMPTY() DO BEGIN
                            RecITE.FINDFIRST();
                            RecITE.DELETE();
                        END;

                        RecITE.RESET();
                        CurrPage.UPDATE();

                        MESSAGE('Inventory Trace Entries Deleted.');
                    end;
                }
                action("Reset Collected Flag")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowResetCollectedFlag;

                    trigger OnAction()
                    var
                        RecInventorySetup: Record "Inventory Setup";
                        RecItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        RecInventorySetup.INIT();
                        RecInventorySetup.GET();

                        IF NOT CONFIRM('This will reset ITE Collected flag of Item Ledger Entries.') THEN
                            EXIT;

                        IF RecInventorySetup."ITE Start Date" = 0D THEN
                            IF NOT CONFIRM('ITE Start Date is blank.\All the data will be reset.\Are you sure to continue?') THEN
                                EXIT;

                        RecItemLedgerEntry.RESET();
                        RecItemLedgerEntry.SETRANGE("ITE Collected", TRUE);
                        RecItemLedgerEntry.SETRANGE("ITE Manually", FALSE);
                        RecItemLedgerEntry.SETFILTER("Posting Date", '%1..', RecInventorySetup."ITE Start Date");
                        IF RecInventorySetup."ITE End Date" <> 0D THEN
                            RecItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', RecInventorySetup."ITE Start Date", RecInventorySetup."ITE End Date");
                        IF RecInventorySetup."ITE Item No. Filter" <> '' THEN
                            RecItemLedgerEntry.SETFILTER("Item No.", RecInventorySetup."ITE Item No. Filter");
                        IF RecInventorySetup."ITE Manufacturer Code Filter" <> '' THEN
                            RecItemLedgerEntry.SETFILTER("Manufacturer Code", RecInventorySetup."ITE Manufacturer Code Filter");

                        RecItemLedgerEntry.MODIFYALL("ITE Collected", FALSE);

                        MESSAGE('Inventory Trace Entries Collected Flag reset completed.');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        RecItemLedgerEntry: Record "Item Ledger Entry";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecPurchRcptHeader: Record "Purch. Rcpt. Header";
        RecGeneralLedgerSetup: Record "General Ledger Setup";
        RecSalesShipmentLine: Record "Sales Shipment Line";
        RecReturnReceiptLine: Record "Return Receipt Line";
        RecSalesShipmentHeader: Record "Sales Shipment Header";
        RecReturnReceiptHeader: Record "Return Receipt Header";
    begin
        // //Only Purchase Receipt and Positive Adjustment are considered as having remaining quantity.
        // RemainingQty := 0;
        // IF (("Document Type" = "Document Type"::"Purchase Receipt") AND ("Entry Type" = "Entry Type"::Purchase))
        //  OR
        //   (("Document Type" = "Document Type"::" ") AND ("Entry Type" = "Entry Type"::Purchase))
        //  OR
        //  (("Document Type" = "Document Type"::" ") AND ("Entry Type" = "Entry Type"::"Positive Adjmt.")) THEN BEGIN
        //
        //  CALCFIELDS("Remaining Quantity");
        //  RemainingQty := "Remaining Quantity";
        // END;

        //Only Purchase Receipt and Positive Adjustment are considered as having remaining quantity.
        RemainingQty := 0;
        IF (Rec."Calc. Rem. Qty." = TRUE) THEN BEGIN
            Rec.CALCFIELDS("Remaining Quantity");
            //BG018
            //RemainingQty := "Remaining Quantity";
            IF Rec."Remaining Quantity" > Rec.Quantity THEN BEGIN
                RemainingQty := Rec.Quantity;
            END ELSE BEGIN
                RemainingQty := Rec."Remaining Quantity";
            END;
            //BG018
        END;

        //Only Sales Shipment is considered as having Sales Returned Quantity.
        SalesRtnQty := 0;
        IF (Rec."Document Type" = Rec."Document Type"::"Sales Shipment") THEN BEGIN

            Rec.CALCFIELDS("Sales Returned Quantity");
            SalesRtnQty := Rec."Sales Returned Quantity";
        END;

        //Only Sales Shipment is considered as having Sales Quantity.
        SalesQty := 0;
        IF (Rec."Document Type" = Rec."Document Type"::"Sales Shipment") THEN BEGIN

            Rec.CALCFIELDS("Sales Quantity");
            SalesQty := Rec."Sales Quantity";
        END;
    end;

    trigger OnInit()
    begin
        // Permission
        ShowCollect := FALSE;
        ShowDelete := FALSE;
        ShowResetCollectedFlag := FALSE;
        ShowUpdatePrice := FALSE;
    end;

    trigger OnOpenPage()
    begin
        // Permission
        IF UserSetup.GET(USERID) THEN BEGIN
            ShowCollect := UserSetup."Allow ITE Collect";
            ShowDelete := UserSetup."Allow ITE Delete";
            ShowResetCollectedFlag := UserSetup."Allow Reset ITE Collected Flag";
            ShowUpdatePrice := UserSetup."Allow ITE Update Price";
        END;
    end;

    var
        RemainingQty: Decimal;
        SalesRtnQty: Decimal;
        SalesQty: Decimal;
        ShowCollect: Boolean;
        ShowDelete: Boolean;
        ShowResetCollectedFlag: Boolean;
        ShowUpdatePrice: Boolean;
        UserSetup: Record "User Setup";
}

