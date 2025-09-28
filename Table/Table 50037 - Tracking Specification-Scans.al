table 50037 "Tracking Specification-Scans"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item;
            // cleaned
        }
        field(4; "Quantity (Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(8; "Creation Date"; Date)
        {
            // cleaned
        }
        field(10; "Source Type"; Integer)
        {
            // cleaned
        }
        field(11; "Source Subtype"; Option)
        {
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            // cleaned
        }
        field(13; "Source Batch Name"; Code[10])
        {
            // cleaned
        }
        field(15; "Source Ref. No."; Integer)
        {
            // cleaned
        }
        field(29; "Qty. per Unit of Measure"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(40; "Warranty Date"; Date)
        {
            // cleaned
        }
        field(41; "Expiration Date"; Date)
        {
            // cleaned
        }
        field(100; "User ID"; Code[20])
        {
            // cleaned
        }
        field(5400; "Lot No."; Code[20])
        {
            trigger OnValidate()
            begin
                IF (COPYSTR("Lot No.", 1, 2) = '1T') OR (COPYSTR("Lot No.", 1, 2) = '1t') THEN
                    "Lot No." := COPYSTR("Lot No.", 3);
            end;

        }
        field(50000; "Scanned Item No."; Code[30])
        {

            trigger OnValidate()
            var
                Loop: Integer;
            begin
                BadItemScan := FALSE;
                NewScannedItem := '';
                IF (COPYSTR("Scanned Item No.", 1, 1) = 'P') OR (COPYSTR("Scanned Item No.", 1, 1) = 'p')
                  THEN
                    "Scanned Item No." := COPYSTR("Scanned Item No.", 2);
                IF (COPYSTR("Scanned Item No.", 1, 2) = '1P') OR (COPYSTR("Scanned Item No.", 1, 2) = '1p')
                  THEN
                    "Scanned Item No." := COPYSTR("Scanned Item No.", 3);

                scanneditemlen := STRLEN("Scanned Item No.");
                scanneditempos := 1;
                REPEAT
                    IF COPYSTR("Scanned Item No.", scanneditempos, 1) = '+' THEN BEGIN
                        IF LeftFlag = FALSE THEN BEGIN
                            NewScannedItem := NewScannedItem + '(';
                            LeftFlag := TRUE;
                        END
                        ELSE BEGIN
                            NewScannedItem := NewScannedItem + ')';
                            LeftFlag := FALSE;
                        END;
                    END
                    ELSE
                        NewScannedItem := NewScannedItem + COPYSTR("Scanned Item No.", scanneditempos, 1);
                    scanneditempos := scanneditempos + 1;
                UNTIL scanneditempos > scanneditemlen;

                "Scanned Item No." := NewScannedItem;

                Item.GET("Item No.");

                IF "Scanned Item No." <> Item."Vendor Item No." THEN BEGIN
                    ItemCrossRef.RESET;
                    ItemCrossRef.SETRANGE("Item No.", "Item No.");
                    ItemCrossRef.SETRANGE("Reference No.", "Scanned Item No.");
                    ok := ItemCrossRef.FIND('-');
                    IF NOT (ok) THEN BEGIN
                        //Console.Beep(1000, 1000); //BC Upgrade
                        ok := CONFIRM('INVALID SCAN FOR THIS ITEM. CONTINUE?');
                        "Scanned Item No." := '';
                        BadItemScan := TRUE;
                    END;
                END;
            end;

        }
        field(50001; "Scanned Rank"; Code[10])
        {

            trigger OnValidate()
            begin
                IF (COPYSTR("Scanned Rank", 1, 1) = 'Z') OR (COPYSTR("Scanned Rank", 1, 1) = 'z')
                  THEN
                    "Scanned Rank" := COPYSTR("Scanned Rank", 2);


                Item.GET("Item No.");
                CLEAR(ValidRanks);
                loop := 1;
                IF Item."No. 2" <> '' THEN BEGIN
                    IF COPYSTR(Item."No. 2", STRLEN(Item."No. 2"), 1) = ',' THEN
                        Item."No. 2" := COPYSTR(Item."No. 2", 1, STRLEN(Item."No. 2") - 1);
                    REPEAT
                        ;
                        x := STRPOS(Item."No. 2", ',');
                        IF x = 0 THEN BEGIN
                            ValidRanks[loop] := Item."No. 2";
                            Item."No. 2" := '';
                        END
                        ELSE BEGIN
                            ValidRanks[loop] := COPYSTR(Item."No. 2", 1, x - 1);
                            Item."No. 2" := COPYSTR(Item."No. 2", x + 1);
                        END;
                        loop := loop + 1;
                    UNTIL Item."No. 2" = '';
                END;

                //check array
                ok := FALSE;
                FOR x := 1 TO loop - 1 DO BEGIN
                    IF "Scanned Rank" = ValidRanks[x] THEN ok := TRUE;
                END;
            end;

        }
        field(50002; "Total Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Tracking Specification-Scans"."Quantity (Base)" WHERE("Source ID" = FIELD("Source ID"),
                                                                                     "Source Type" = FIELD("Source Type"),
                                                                                     "Source Subtype" = FIELD("Source Subtype"),
                                                                                     "Source Batch Name" = FIELD("Source Batch Name"),
                                                                                     "Source Ref. No." = FIELD("Source Ref. No.")));
            Description = 'flow field for totals';
        }
        field(50003; "Qty Scanned"; Text[14])
        {
            trigger OnValidate()
            begin
                IF "Scanned Customer Item No." = '' THEN ERROR('YOU MUST SCAN CUSTOMER ITEM NUMBER');
                IF (COPYSTR("Qty Scanned", 1, 1) = 'Q') OR (COPYSTR("Qty Scanned", 1, 1) = 'q') THEN "Qty Scanned" := COPYSTR("Qty Scanned", 2);
                EVALUATE("Quantity (Base)", "Qty Scanned");
            end;
        }
        field(50004; "Scanned Customer Item No."; Code[40])
        {
            trigger OnValidate()
            var
                customeritemcheckline: Record "Sales Line";
                INVALIDSCAN: Boolean;
                FamiliarItemNo: Code[20];
            begin
                IF (COPYSTR("Scanned Customer Item No.", 1, 1) = 'P') OR (COPYSTR("Scanned Customer Item No.", 1, 1) = 'p')
                  THEN
                    "Scanned Customer Item No." := COPYSTR("Scanned Customer Item No.", 2);
                IF (COPYSTR("Scanned Customer Item No.", 1, 2) = '1P') OR (COPYSTR("Scanned Customer Item No.", 1, 2) = '1p')
                  THEN
                    "Scanned Customer Item No." := COPYSTR("Scanned Customer Item No.", 3);

                INVALIDSCAN := FALSE;
                IF NOT (customeritemcheckline.GET(customeritemcheckline."Document Type"::Order, "Source ID", "Source Ref. No."))
                 THEN
                    INVALIDSCAN := TRUE;

                Item.GET(customeritemcheckline."No.");
                FamiliarItemNo := Item."Familiar Name";

                IF customeritemcheckline."Item Reference No." <> ''
                 THEN
                    IF "Scanned Customer Item No." <> customeritemcheckline."Item Reference No."
                 THEN
                        INVALIDSCAN := TRUE;
                IF customeritemcheckline."Item Reference No." = ''
                 THEN
                    IF "Scanned Customer Item No." <> FamiliarItemNo
                 THEN
                        INVALIDSCAN := TRUE;
                IF INVALIDSCAN THEN BEGIN
                    //Console.Beep(1000, 1000); //BC Upgrade
                    ERROR('INVALID CUSTOMER ITEM NUMBER FOR THIS ITEM.');
                END;
            end;

        }
        field(50005; "2D Bar Code"; Boolean)
        {
            // cleaned
        }
        field(50006; BadItemScan; Boolean)
        {
            // cleaned
        }
        field(50007; BadRankScan; Boolean)
        {
            // cleaned
        }
        field(50008; BadCustomerItemScan; Boolean)
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "User ID", "Entry No.")
        {
        }
        key(Key2; "Source ID", "Source Type", "Source Subtype", "Source Batch Name", "Source Ref. No.")
        {
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Quantity (Base)";
        }
        key(Key3; "Lot No.")
        {
        }
        key(Key4; "Source ID", "Source Ref. No.", "Lot No.")
        {
        }
    }

    fieldgroups
    {
    }
    var
        Item: Record Item;
        ItemCrossRef: Record "Item Reference";
        ok: Boolean;
        ValidRanks: array[40] of Text[40];
        loop: Integer;
        x: Integer;
        scanneditemlen: Integer;
        scanneditempos: Integer;
        LeftFlag: Boolean;
        NewScannedItem: Code[40];
        "2Ddatascannedin": Code[250];
        "2DParseStartPos": Integer;
        "2DParseLen": Integer;
    //Console: DotNet Console; //BC Upgrade

}
