tableextension 50111 "Sales Shipment Line Ext" extends "Sales Shipment Line"
{

    fields
    {
        field(50000; "Order Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Shipment Header"."Order Date" WHERE("No." = FIELD("Document No.")));
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50010; "Customer Order No."; Text[35])
        {
            Description = '//30';
        }
        field(50011; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50012; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50013; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50020; "OEM No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("Customer Type" = CONST(OEM));
            // cleaned
        }
        field(50021; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50500; "Shipment Seq. No."; Integer)
        {
            Editable = false;
        }
        field(50501; "Item Supplier Source"; Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

            trigger OnValidate()
            begin

                //SH 4 Nov 2012 - Start
                //Provide option to update Shipment Line 'Message Status' to 'Ready to Collect' for future message collection
                //Provide option to update 'Item Supplier Source' and 'Message Status' in related Sales Order Line

                IF Type = Type::Item THEN
                    Item.get("No.");

                IF (Type = Type::Item) AND (xRec."Item Supplier Source" <> xRec."Item Supplier Source"::Renesas) THEN BEGIN
                    IF "Item Supplier Source" = "Item Supplier Source"::Renesas THEN BEGIN
                        IF (Item."Item Supplier Source" = Item."Item Supplier Source"::" ") THEN BEGIN
                            ERROR(Text004);
                        END ELSE BEGIN
                            IF "Message Status" <> "Message Status"::"Ready to Collect" THEN BEGIN
                                IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                                    'Ready to Collect') THEN BEGIN
                                    "Message Status" := "Message Status"::"Ready to Collect";
                                    "Update Date" := TODAY;
                                    "Update Time" := TIME;
                                    "Update By" := USERID;
                                    Edition := TRUE;
                                    SalesShptHeader.GET("Document No.");
                                    SalesShptHeader."Message Collected On(Shipment)" := TODAY;
                                    SalesShptHeader."Message Status(Shipment)" :=
                                                     SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                                    SalesShptHeader.MODIFY;
                                END;
                            END;
                        END;
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Item Supplier Source" = xRec."Item Supplier Source"::Renesas) THEN BEGIN
                    IF ("Item Supplier Source" = "Item Supplier Source"::" ") THEN BEGIN
                        IF (Item."Item Supplier Source" <> Item."Item Supplier Source"::" ") THEN BEGIN
                            ERROR(Text005);
                        END;
                    END;
                END;

                //Update Sales Line Record
                IF SalesShptHeader.GET("Document No.") THEN BEGIN
                    rec_SalesLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    IF rec_SalesLine.GET(rec_SalesLine."Document Type"::Order, SalesShptHeader."Order No.", "Line No.") THEN BEGIN
                        IF (xRec."Item Supplier Source" <> "Item Supplier Source") THEN BEGIN
                            IF CONFIRM(Text011, TRUE, FIELDCAPTION("Item Supplier Source")) THEN BEGIN
                                rec_SalesLine."Item Supplier Source" := "Item Supplier Source";
                                IF (rec_SalesLine."Message Status" <> rec_SalesLine."Message Status"::"Ready to Collect")
                                      THEN BEGIN
                                    IF CONFIRM(Text010, TRUE, FIELDCAPTION("Message Status"), rec_SalesLine."Message Status",
                                          'Ready to Collect') THEN BEGIN
                                        rec_SalesLine."Message Status" := "Message Status"::"Ready to Collect";
                                        rec_SalesLine."Update Date" := TODAY;
                                        rec_SalesLine."Update Time" := TIME;
                                        rec_SalesLine."Update By" := USERID;
                                    END;
                                END;
                                rec_SalesLine.MODIFY;
                            END;
                        END;
                    END;
                END;
            end;

        }
        field(50502; "Post Shipment Collect Flag"; Integer)
        {
            // cleaned
        }
        field(50510; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;

            trigger OnValidate()
            begin

                //SH 20111105 - For PSI Data Maintenance check
                IF Type = Type::Item THEN
                    Item.get("No.");
                //SH 20141115 - To resolve Pasting record prooblem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" ="Message Status"::Sent THEN BEGIN
                //           ERROR(Text007);
                //      END;
                //END;

                //SH 20141115 - To resolve Pasting record prooblem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" ="Message Status"::" " THEN BEGIN
                //           ERROR(Text007);
                //      END;
                //END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::"Ready to Collect" THEN BEGIN
                        IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), xRec."Message Status",
                            'Ready to Collect') THEN BEGIN
                            SalesShptHeader.GET("Document No.");
                            SalesShptHeader."Message Collected On(Shipment)" := 0D;
                            SalesShptHeader."Message Status(Shipment)" :=
                                             SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                            SalesShptHeader.MODIFY;
                        END ELSE BEGIN
                            "Message Status" := xRec."Message Status";
                        END;
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Collected) THEN BEGIN
                    IF "Message Status" <> "Message Status"::Collected THEN BEGIN
                        ERROR(Text013);
                    END;
                END;

                //SH 20141115 - To resolve Pasting record prooblem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" ="Message Status"::Collected THEN BEGIN
                //           ERROR(Text007);
                //      END;
                //END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                    IF "Message Status" = "Message Status"::" " THEN BEGIN
                        IF Item."Item Supplier Source" = Item."Item Supplier Source"::Renesas THEN BEGIN
                            ERROR(Text009);
                        END;
                    END;
                END;

                //SH 20141115 - To resolve Pasting record prooblem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::" ") THEN BEGIN
                //      IF  "Message Status" <> xRec."Message Status" THEN BEGIN
                //           ERROR(Text007);
                //      END;
                //END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::Collected THEN BEGIN
                        ERROR(Text008);
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::" " THEN BEGIN
                        IF Item."Item Supplier Source" = Item."Item Supplier Source"::Renesas THEN BEGIN
                            ERROR(Text009);
                        END;
                    END;
                END;

                IF xRec."Message Status" <> "Message Status" THEN BEGIN
                    "Update Date" := TODAY;
                    "Update Time" := TIME;
                    "Update By" := USERID;
                    Edition := TRUE;
                END;

            end;

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
        field(50516; "Save Posting Date"; Date)
        {
            // cleaned
        }
        field(50517; "Serial No."; Integer)
        {
            BlankZero = true;
        }
        field(50518; "Booking No."; Code[20])
        {
            // cleaned
        }
        field(50519; "No. Series"; Code[10])
        {
            // cleaned
        }
        field(50527; "Salespersonm Code"; Code[10])
        {
            // cleaned
        }
        field(50528; Remarks; Text[30])
        {
            Caption = 'Remarks';
        }
        field(50530; Insertion; Boolean)
        {
            Description = '//20111104 for PSI JA Maintenance';

            trigger OnValidate()
            begin

                //
                IF ((Type = Type::" ") AND (Description = ' ')) THEN BEGIN
                    "Message Status" := "Message Status"::" ";
                    Insertion := FALSE;
                END;

                IF ((Type = Type::Item) AND (Description <> ' ')) THEN BEGIN
                    IF SalesShptHeader.GET("Document No.") THEN BEGIN
                        SalesShptHeader."Message Collected On(Shipment)" := 0D;
                        SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                        SalesShptHeader.MODIFY;
                    END;
                END;

            end;

        }
        field(50531; Edition; Boolean)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50532; "Original Quantity"; Decimal)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50533; "Edit Count"; Integer)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50534; "Prev Quantity"; Decimal)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50536; "Shipment Collection Date"; Date)
        {
            // cleaned
        }
        field(50539; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanceents';
        }
        field(50540; "Original Doc. No."; Code[20])
        {
            // cleaned
        }
        field(50541; Blocked; Boolean)
        {
            // cleaned
        }
        field(50542; "Original Booking No."; Code[20])
        {
            // cleaned
        }
        field(50543; "Original Line No."; Integer)
        {
            // cleaned
        }
        field(50544; "External Document No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = Max("Value Entry"."External Document No." WHERE("Document No." = FIELD("Document No."),
                                                                          "Document Type" = CONST("Sales Shipment"),
                                                                          Adjustment = CONST(FALSE)));
            Description = '//CS077';
        }
        field(50565; "2nd Unit of Measure Code"; Code[10])
        {
            Caption = '2nd Unit of Measure';
        }
        field(50566; "2nd Unit of Measure"; Text[10])
        {
            // cleaned
        }
        field(50567; "Qty to Ship (2nd UOM)"; Decimal)
        {
            Caption = 'Qty tp Ship (2nd UOM)';
            DecimalPlaces = 0 : 0;
            Editable = false;
        }

        modify("Shipment Date")
        {

            trigger OnAfterValidate()
            begin
                //SH 04 Nov 12 - Improve PSI Data Mantenance

                IF (xRec."Shipment Date" <> "Shipment Date") THEN BEGIN
                    IF ("Message Status" <> "Message Status"::"Ready to Collect") AND (Type = Type::Item)
                              THEN BEGIN
                        IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                                 'Ready to Collect') THEN BEGIN
                            "Message Status" := "Message Status"::"Ready to Collect";
                            "Update Date" := TODAY;
                            "Update Time" := TIME;
                            "Update By" := USERID;
                            Edition := TRUE;
                            IF SalesShptHeader.GET("Document No.") THEN BEGIN
                                SalesShptHeader."Message Collected On(Shipment)" := 0D;
                                SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                                SalesShptHeader.MODIFY;
                            END;
                        END;
                    END;
                END;



                //Update Sales Line Record
                IF SalesShptHeader.GET("Document No.") THEN BEGIN
                    rec_SalesLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    IF rec_SalesLine.GET(rec_SalesLine."Document Type"::Order, SalesShptHeader."Order No.", "Line No.") THEN BEGIN
                        IF (xRec."Shipment Date" <> "Shipment Date") THEN BEGIN
                            IF CONFIRM(Text011, TRUE, FIELDCAPTION("Shipment Date")) THEN BEGIN
                                rec_SalesLine."Shipment Date" := "Shipment Date";
                                IF (rec_SalesLine."Message Status" <> rec_SalesLine."Message Status"::"Ready to Collect")
                                      THEN BEGIN
                                    IF CONFIRM(Text010, FALSE, FIELDCAPTION("Message Status"), rec_SalesLine."Message Status",
                                          'Ready to Collect') THEN BEGIN
                                        rec_SalesLine."Message Status" := "Message Status"::"Ready to Collect";
                                        rec_SalesLine."Update Date" := TODAY;
                                        rec_SalesLine."Update Time" := TIME;
                                        rec_SalesLine."Update By" := USERID;
                                    END;
                                END;
                                rec_SalesLine.MODIFY;
                            END;
                        END;
                    END;
                END;
            end;
        }


        modify(Description)
        {

            trigger OnAfterValidate()
            begin
                //
                IF (xRec.Description <> Description) THEN BEGIN
                    IF ("Message Status" <> "Message Status"::"Ready to Collect") AND (Type = Type::Item)
                              THEN BEGIN
                        IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                                 'Ready to Collect') THEN BEGIN
                            "Message Status" := "Message Status"::"Ready to Collect";
                            "Update Date" := TODAY;
                            "Update Time" := TIME;
                            "Update By" := USERID;
                            Edition := TRUE;
                            IF SalesShptHeader.GET("Document No.") THEN BEGIN
                                SalesShptHeader."Message Collected On(Shipment)" := 0D;
                                SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                                SalesShptHeader.MODIFY;
                            END;
                        END;
                    END;
                END;

                //Update Sales Line Record
                IF SalesShptHeader.GET("Document No.") THEN BEGIN
                    rec_SalesLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    IF rec_SalesLine.GET(rec_SalesLine."Document Type"::Order, SalesShptHeader."Order No.", "Line No.") THEN BEGIN
                        IF (xRec.Description <> Description) THEN BEGIN
                            IF CONFIRM(Text011, TRUE, FIELDCAPTION(Description)) THEN BEGIN
                                rec_SalesLine.Description := Description;
                                IF (rec_SalesLine."Message Status" <> rec_SalesLine."Message Status"::"Ready to Collect")
                                      THEN BEGIN
                                    IF CONFIRM(Text010, FALSE, FIELDCAPTION("Message Status"), rec_SalesLine."Message Status",
                                          'Ready to Collect') THEN BEGIN
                                        rec_SalesLine."Message Status" := "Message Status"::"Ready to Collect";
                                        rec_SalesLine."Update Date" := TODAY;
                                        rec_SalesLine."Update Time" := TIME;
                                        rec_SalesLine."Update By" := USERID;
                                    END;
                                END;
                                rec_SalesLine.MODIFY;
                            END;
                        END;
                    END;
                END;
            end;

        }

        modify(Correction)
        {

            trigger OnAfterValidate()
            begin

                //
                IF ((Type = Type::Item) AND (Quantity = 0)) THEN BEGIN
                    Correction := FALSE;
                END;
            end;
        }

    }

    trigger OnBeforeInsert()
    begin

        //SH 04 Nov 12 - Improve PSI Data Mantenance
        //Manual Insert Shipment Line Qty must be Zero since it is not linked to Sales Order

        Quantity := 0;
        Insertion := FALSE;
        Edition := FALSE;
        Correction := FALSE;

        IF ((Type = Type::" ") AND (Description = ' ')) THEN BEGIN
            "Message Status" := "Message Status"::" ";
            Insertion := FALSE;
        END;

        IF ((Type = Type::" ") AND (Description <> ' ')) THEN BEGIN
            "Message Status" := "Message Status"::" ";
            Insertion := TRUE;
        END;

        IF ((Type <> Type::" ") AND (Description <> ' ')) THEN BEGIN
            "Message Status" := "Message Status"::"Ready to Collect";
            "Update Date" := TODAY;
            "Update Time" := TIME;
            "Update By" := USERID;
            Insertion := TRUE;
        END;

        "Shipment Collection Date" := 0D;

        // Move this part to Codeunit, because of Sales Shipment Header modification permission.
        /*
        IF ((Type = Type::Item) AND (Description <> ' ')) THEN BEGIN
            IF SalesShptHeader.GET("Document No.") THEN BEGIN
                SalesShptHeader."Message Collected On(Shipment)" := 0D;
                SalesShptHeader."Message Status(Shipment)" := SalesShptHeader."Message Status(Shipment)"::"Ready to Collect";
                SalesShptHeader.MODIFY;
            END;
        END;
        */

    end;

    trigger OnBeforeDelete()
    begin

        //SH 13 Nov 2012 - PSI Maintenance
        IF "Message Status" = "Message Status"::Collected THEN
            ERROR(Text012);
        IF "Message Status" = "Message Status"::Sent THEN
            ERROR(Text012);


    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
        rec_SalesLine: Record "Sales Line";
        Item: Record Item;
        Text002: Label 'Do you really want to insert a new Shipment Line?';
        Text003: Label 'Do you want to change  current line  %1 from %2 to %3';
        Text004: Label 'This is not Renesas''s Item ';
        Text005: Label 'This is Renesas''s Item';
        Text006: Label 'Change not allowed - PSI Data collected but not sent yet';
        Text007: Label 'The Message Status can only be updated by system';
        Text008: Label 'Collected Message Option can only updated by system';
        Text009: Label 'You can only choose Ready to Collect (not Space) for this is a Renesas Item ';
        Text010: Label 'Do you want to change corresponding Sales Line %1 from %2 to %3\WARNING: THIS MAY AFFECT JA COLLECTION RESULT! ';
        Text011: Label 'Do you want to update %1 in corresponding Sales Order Line also?';
        Text012: Label 'Deleteion of this record is not allowed - JB PSI was already collected/sent';
        Text013: Label 'Send Message not done yet';
}
