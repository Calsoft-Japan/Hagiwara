tableextension 50039 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50000; Remark; Text[100])
        {
            Description = 'king';
        }
        field(50010; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50011; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50012; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Products WHERE("No." = FIELD("No.")));
            // cleaned
        }
        field(50016; "SO No."; Code[30])
        {
            // cleaned
        }
        field(50050; "Auto No."; Code[30])
        {
            Caption = 'Auto No.';
            Editable = false;
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50100; "ORE Message Status"; Option)
        {
            Description = 'CS060';
            OptionCaption = 'Not Applicable,Ready to Collect,Collected,Sent';
            OptionMembers = "Not Applicable","Ready to Collect",Collected,Sent;
        }
        field(50101; "ORE Change Status"; Option)
        {
            Description = 'CS060';
            InitValue = "Not Applicable";
            OptionCaption = 'Not Applicable,Changed,Collected,Sent';
            OptionMembers = "Not Applicable",Changed,Collected,Sent;
        }
        field(50102; "ORE Line No."; Integer)
        {
            Description = 'CS060';
            Editable = false;
        }
        field(50201; "Price Target Update"; Boolean)
        {
            InitValue = true;
        }
        field(50500; "Receipt Seq. No."; Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(50501; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50502; "CO No."; Code[6])
        {
            Description = '//20101009';

            trigger OnValidate()
            begin
                TestStatusOpen();
            end;
        }
        field(50510; "Message Status"; Option)
        {
            Caption = 'Message Status';
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(50511; "Update Date"; Date)
        {
            // cleaned
        }
        field(50512; "Update Time"; Time)
        {
            // cleaned
        }
        field(50513; "Update By"; Code[50])
        {
            Description = '//20';
        }
        field(50514; "Saved Expected Receipt Date"; Date)
        {
            Editable = false;
        }
        field(50515; "Next Receipt Seq. No."; Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(50516; "Save Posting Date"; Date)
        {
            Editable = true;
        }
        field(50527; "Purchaser Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanced';
        }
        field(50530; "Previous Document Date"; Date)
        {
            // cleaned
        }
        field(50531; "Original Document No."; Code[20])
        {
            Description = '//20131215';
        }
        field(50532; Blocked; Boolean)
        {
            // cleaned
        }
        field(50533; "Original Line No."; Integer)
        {
            // cleaned
        }
        field(50534; "Requested Receipt Date_1"; Date)
        {

            trigger OnValidate()
            begin
                IF "Expected Receipt Date" = 0D THEN BEGIN
                    VALIDATE("Reporting Receipt Date", "Requested Receipt Date_1");
                    "Use Expected Receipt Date" := FALSE;
                END;
            end;
        }
        field(50535; "Reporting Receipt Date"; Date)
        {
            Description = 'CS013';
        }
        field(50536; "Use Expected Receipt Date"; Boolean)
        {
            Description = 'CS013';
        }
        field(50550; "Line Amount to receive"; Decimal)
        {
            Caption = 'Line Amount to receive';
            Description = 'SKHE20121011';
            Editable = true;

        }
        field(50617; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
        }

        modify(Type)
        {
            trigger OnAfterValidate()
            begin

                // YUKA for Hagiwara
                PurchHeader := GetPurchHeader;
                "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";

            end;

        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                l_recVendor: Record Vendor;
            begin

                PurchHeader := GetPurchHeader;

                //SH 20121204 - start
                "Purchaser Code" := PurchHeader."Purchaser Code";
                //SH - END

                "Requested Receipt Date_1" := PurchHeader."Expected Receipt Date";//sanjeev

                //CS013 Start
                IF "Expected Receipt Date" = 0D THEN BEGIN
                    VALIDATE("Reporting Receipt Date", "Requested Receipt Date_1");
                    "Use Expected Receipt Date" := FALSE;
                END
                ELSE BEGIN
                    VALIDATE("Reporting Receipt Date", "Expected Receipt Date");
                    "Use Expected Receipt Date" := TRUE;
                END;
                //CS013 End

                if type = type::Item then begin

                    item.get("No.");
                    //Item.TESTFIELD("Item Supplier Source",PurchHeader."Item Supplier Source"); //20101010
                    "Item Supplier Source" := Item."Item Supplier Source";
                    "Receipt Seq. No." := 1; //>>
                    "Next Receipt Seq. No." := 1; //>>

                    // Siak Hui 20110427
                    "Update Date" := TODAY;
                    "Update Time" := TIME;
                    "Update By" := USERID;
                    // Siak Hui - END

                    // YUKA for Hagiwara 20030225
                    "Customer Item No." := Item."Customer Item No.";
                    "Parts No." := Item."Parts No.";
                    Rank := Item.Rank;
                    // YUKA for Hagiwara 20030225 - END
                end;

                // CS060 Begin
                IF l_recVendor.GET(PurchHeader."Buy-from Vendor No.") THEN BEGIN
                    IF NOT l_recVendor."Excluded in ORE Collection" THEN BEGIN
                        "ORE Line No." := xRec."ORE Line No.";
                        IF ("ORE Line No." = 0) AND (Type = Type::Item) AND ("No." <> xRec."No.") AND ("No." <> '') THEN BEGIN
                            item.get("No.");
                            IF Item."One Renesas EDI" THEN BEGIN
                                PurchLine2.RESET;
                                PurchLine2.SETRANGE("Document No.", Rec."Document No.");
                                PurchLine2.SETRANGE("Document Type", Rec."Document Type");
                                PurchLine2.SETRANGE(Type, PurchLine2.Type::Item);
                                PurchLine2.SETCURRENTKEY("ORE Line No.");
                                IF PurchLine2.FINDLAST THEN BEGIN
                                    "ORE Line No." := PurchLine2."ORE Line No." + 1;
                                END
                                ELSE BEGIN
                                    "ORE Line No." := 1;
                                END;
                            END;
                        END;

                        IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                            item.get("No.");
                            IF NOT Item."One Renesas EDI" THEN
                                "ORE Line No." := 0;

                        END;
                    END;
                END;
                // CS060 End

            end;
        }

        modify("Expected Receipt Date")
        {
            trigger OnAfterValidate()
            begin

                //CS013 Start
                IF "Expected Receipt Date" = 0D THEN BEGIN
                    VALIDATE("Reporting Receipt Date", "Requested Receipt Date_1");
                    "Use Expected Receipt Date" := FALSE;
                END
                ELSE BEGIN
                    VALIDATE("Reporting Receipt Date", "Expected Receipt Date");
                    "Use Expected Receipt Date" := TRUE;
                END
                //CS013 End


            end;
        }

        modify("Description 2")
        {
            Caption = 'Release No.';
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                InvtSetup: Record "Inventory Setup";
                Item: Record "Item";
                QtyEval: Decimal;
            begin

                //+HW20091109
                InvtSetup.GET();
                Item := GetItem();
                IF (InvtSetup."Max. PO Quantity Restriction") AND (Item."Purch. Order Quantity Limit" <> 0) THEN BEGIN
                    IF Rec.Quantity > Item."Purch. Order Quantity Limit" THEN
                        IF NOT CONFIRM(Text113, FALSE, Item."Purch. Order Quantity Limit") THEN
                            ERROR('');
                END;
                //-

                // Siak 25Nov2009
                IF (Type = Type::Item) AND (Quantity <> 0) THEN BEGIN
                    IF Item.GET("No.") THEN BEGIN
                        IF Item."Order Multiple" <> 0 THEN BEGIN
                            QtyEval := Quantity / Item."Order Multiple";
                            QtyEval := ROUND(QtyEval, 1, '>');
                            IF QtyEval <> Quantity / Item."Order Multiple" THEN BEGIN
                                MESSAGE(Text102, FORMAT(Quantity), FORMAT(Item."Order Multiple"));
                            END;
                        END;
                    END;
                END;
                // Siak - END

            end;
        }
    }

    trigger OnAfterInsert()
    var
        l_recVendor: Record Vendor;
    begin

        "Receipt Seq. No." := 1; //>>
        "Next Receipt Seq. No." := 1; //>>

        GenerateReleaseNo; //HG10.00.02 NJ 01/06/2017

        PurchHeader := GetPurchHeader;
        "Goods Arrival Date" := PurchHeader."Posting Date";

        //CS060 Begin
        IF l_recVendor.GET(PurchHeader."Buy-from Vendor No.") THEN BEGIN
            IF NOT l_recVendor."Excluded in ORE Collection" THEN BEGIN
                IF Type = Type::Item THEN BEGIN
                    IF Item.GET("No.") THEN BEGIN
                        IF Item."One Renesas EDI" THEN BEGIN
                            PurchLine2.RESET;
                            PurchLine2.SETRANGE("Document No.", Rec."Document No.");
                            PurchLine2.SETRANGE("Document Type", Rec."Document Type");
                            PurchLine2.SETRANGE("ORE Message Status", "ORE Message Status"::Sent);
                            IF PurchLine2.FIND('-') THEN BEGIN
                                //"ORE Message Status" := "ORE Message Status"::Sent;
                                "ORE Message Status" := "ORE Message Status"::"Not Applicable";
                                "ORE Change Status" := "ORE Change Status"::Changed;
                            END ELSE
                                "ORE Message Status" := "ORE Message Status"::"Ready to Collect";

                            PurchLine2.RESET;
                            PurchLine2.SETRANGE("Document No.", Rec."Document No.");
                            PurchLine2.SETRANGE("Document Type", Rec."Document Type");
                            PurchLine2.SETRANGE(Type, PurchLine2.Type::Item);
                            PurchLine2.SETCURRENTKEY("ORE Line No.");
                            IF PurchLine2.FINDLAST THEN BEGIN
                                "ORE Line No." := PurchLine2."ORE Line No." + 1;
                            END
                            ELSE BEGIN
                                "ORE Line No." := 1;
                            END;
                        END;
                    END;
                END;
            END;
        END;
        //CS060 End
    end;

    trigger OnAfterModify()
    var
        l_recVendor: Record Vendor;
    begin

        //CS060 Begin
        IF xRec."ORE Message Status" IN ["ORE Message Status"::Collected, "ORE Message Status"::Sent] THEN BEGIN
            IF xRec."No." <> Rec."No." THEN BEGIN
                ERROR('You can not change record with "Sent" or "Collected" ORE message status');
            END;
        END;

        PurchHeader := GetPurchHeader;
        IF l_recVendor.GET(PurchHeader."Buy-from Vendor No.") THEN BEGIN
            IF NOT l_recVendor."Excluded in ORE Collection" THEN BEGIN
                IF xRec."ORE Message Status" = "ORE Message Status"::Sent THEN BEGIN
                    IF Type = Type::Item THEN BEGIN
                        Item.GET("No.");
                        IF (Item."One Renesas EDI") THEN BEGIN
                            IF (xRec.Quantity <> Rec.Quantity) OR (xRec."Requested Receipt Date_1" <> Rec."Requested Receipt Date_1") THEN BEGIN
                                "ORE Change Status" := "ORE Change Status"::Changed;
                            END;
                        END;
                    END;
                END;

                IF Type = Type::Item THEN BEGIN
                    IF xRec."No." <> Rec."No." THEN BEGIN
                        Item.GET("No.");
                        IF NOT Item."One Renesas EDI" THEN BEGIN
                            "ORE Message Status" := "ORE Message Status"::"Not Applicable";
                            "ORE Change Status" := "ORE Change Status"::"Not Applicable";
                        END ELSE BEGIN

                            PurchLine2.RESET;
                            PurchLine2.SETRANGE("Document No.", Rec."Document No.");
                            PurchLine2.SETRANGE("Document Type", Rec."Document Type");
                            PurchLine2.SETRANGE("ORE Message Status", "ORE Message Status"::Sent);
                            IF PurchLine2.FIND('-') THEN BEGIN
                                "ORE Message Status" := "ORE Message Status"::"Not Applicable";
                                "ORE Change Status" := "ORE Change Status"::Changed;
                            END ELSE BEGIN
                                "ORE Message Status" := "ORE Message Status"::"Ready to Collect";
                                "ORE Change Status" := "ORE Change Status"::"Not Applicable";
                            END;
                        END;
                    END;
                END;
            END;
        END;
        //CS060 End

    end;

    trigger OnBeforeDelete()
    begin
        //CS060
        IF ("ORE Message Status" = "ORE Message Status"::Sent) OR ("ORE Message Status" = "ORE Message Status"::Collected) THEN
            ERROR('You can not delete record with "Sent" ORE message status');
        //CS060
    end;

    local procedure GenerateReleaseNo()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        decReleaseNo: Decimal;
    begin
        //HG10.00.02 NJ 01/06/2017 -->
        PurchSetup.GET;
        IF NOT PurchSetup."Maintain Release No." THEN
            EXIT;

        IF Type = Type::Item THEN BEGIN
            PurchLine2.RESET;
            PurchLine2.SETRANGE("Document Type", "Document Type");
            PurchLine2.SETRANGE("Document No.", "Document No.");
            PurchLine2.SETRANGE(Type, PurchLine2.Type::Item);
            IF PurchLine2.FINDLAST THEN BEGIN
                CLEAR(decReleaseNo);
                IF EVALUATE(decReleaseNo, PurchLine2."Description 2") THEN
                    decReleaseNo += 10;
                "Description 2" := FORMAT(decReleaseNo);
            END ELSE
                "Description 2" := '10';
        END;
        //HG10.00.02 NJ 01/06/2017 <--

    end;

    var
        Item: Record Item;
        PurchHeader: Record "Purchase Header";
        PurchLine2: Record "Purchase Line";

        Text113: Label 'Quantity exceeds the Maximum Purch. Order Quantity Limit : ''%1'', Do you want to proceed?';
        Text102: Label 'Quantity entered : %1  is not multiple of standard pack : %2 ';

}
