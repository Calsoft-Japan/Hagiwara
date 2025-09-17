tableextension 50121 "Purch. Rcpt. Line Ext" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "Receipt Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Posting Date" WHERE("No." = FIELD("Document No.")));
            Description = 'HG10.00.02 NJ 01/06/2017';
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
            // cleaned
        }
        field(50016; "SO No."; Code[30])
        {
            // cleaned
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50500; "Receipt Seq. No."; Integer)
        {
            Editable = false;
        }
        field(50502; "CO No."; Code[6])
        {
            Description = '//20101009';
            Editable = true;

            trigger OnValidate()
            begin

                IF (Type = Type::Item) AND (xRec."CO No." <> "CO No.") THEN BEGIN
                    IF "Message Status" <> "Message Status"::"Ready to Collect" THEN BEGIN
                        IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                            'Ready to Collect') THEN BEGIN
                            "Message Status" := "Message Status"::"Ready to Collect";
                            "Update Date" := TODAY;
                            "Update Time" := TIME;
                            "Update By" := USERID;
                            Edition := TRUE;
                            IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                                PurchRcptHeader."Message Collected On(Incoming)" := 0D;
                                PurchRcptHeader."Message Status(Incoming)" := PurchRcptHeader."Message Status(Incoming)"::"Ready to Collect";
                                PurchRcptHeader.MODIFY;
                            END;
                        END;
                    END;
                END;

                //Update 'CO No.' in Purchase Line
                IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                    rec_PurchLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    IF rec_PurchLine.GET(rec_PurchLine."Document Type"::Order, PurchRcptHeader."Order No.", "Line No.") THEN BEGIN
                        IF (xRec."CO No." <> "CO No.") THEN BEGIN
                            IF CONFIRM(Text011, TRUE, FIELDCAPTION("CO No.")) THEN BEGIN
                                rec_PurchLine."CO No." := "CO No.";
                                rec_PurchLine.MODIFY;
                            END;
                        END;
                    END;
                END;

            end;

        }
        field(50503; "Item Supplier Source"; Option)
        {
            Description = '//20110118';
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

            trigger OnValidate()
            begin

                //SH 20111105 - To allow Msg Status change to Ready to collect when the field is changed from space to 'Renesas'
                IF Type = Type::Item THEN
                    Item.get("No.");

                IF (Type = Type::Item) AND (xRec."Item Supplier Source" <> xRec."Item Supplier Source"::Renesas) THEN BEGIN
                    IF "Item Supplier Source" = "Item Supplier Source"::Renesas THEN BEGIN
                        IF (Item."Item Supplier Source" = Item."Item Supplier Source"::" ") THEN BEGIN
                            ERROR(Text004);
                        END ELSE BEGIN
                            IF ("Message Status" <> "Message Status"::"Ready to Collect") THEN BEGIN
                                IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                                    'Ready to Collect') THEN BEGIN
                                    "Message Status" := "Message Status"::"Ready to Collect";
                                    "Update Date" := TODAY;
                                    "Update Time" := TIME;
                                    "Update By" := USERID;
                                    Edition := TRUE;
                                    IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                                        PurchRcptHeader."Message Collected On(Incoming)" := 0D;
                                        PurchRcptHeader."Message Status(Incoming)" := PurchRcptHeader."Message Status(Incoming)"::"Ready to Collect";
                                        PurchRcptHeader.MODIFY;
                                    END;
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

                //Update Purchase Line Record
                IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                    rec_PurchLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    IF rec_PurchLine.GET(rec_PurchLine."Document Type"::Order, PurchRcptHeader."Order No.", "Line No.") THEN BEGIN
                        IF (xRec."Item Supplier Source" <> "Item Supplier Source") THEN BEGIN
                            IF CONFIRM(Text011, TRUE, FIELDCAPTION("Item Supplier Source")) THEN BEGIN
                                rec_PurchLine."Item Supplier Source" := "Item Supplier Source";
                                rec_PurchLine.MODIFY;
                            END;
                        END;
                    END;
                END;
            end;

        }
        field(50510; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;

            trigger OnValidate()
            begin

                //SH 20111105 - For PSI Data Maintenance check
                IF Type = Type::Item THEN
                    item.get("No.");

                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Collected) THEN BEGIN
                //      IF  "Message Status" <> "Message Status"::Collected THEN BEGIN
                //          ERROR(Text006);
                //     END;
                //END;

                //SH 20141115 To resolve Pasting record problem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" = "Message Status"::Sent THEN BEGIN
                //           ERROR(Text007);
                //      END;
                //END;


                //SH 20141115 To resolve Pasting record problem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" = "Message Status"::" " THEN BEGIN
                //           ERROR(Text007);
                //      END;
                //END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::"Ready to Collect" THEN BEGIN
                        IF CONFIRM(Text003, TRUE, FIELDCAPTION("Message Status"), xRec."Message Status",
                            'Ready to Collect') THEN BEGIN
                            PurchRcptHeader.GET("Document No.");
                            PurchRcptHeader."Message Collected On(Incoming)" := 0D;
                            PurchRcptHeader."Message Status(Incoming)" :=
                                             PurchRcptHeader."Message Status(Incoming)"::"Ready to Collect";
                            PurchRcptHeader.MODIFY;
                        END ELSE BEGIN
                            "Message Status" := xRec."Message Status";
                        END;
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Collected) THEN BEGIN
                    IF "Message Status" <> "Message Status"::Collected THEN BEGIN
                        ERROR(Text012);
                    END;
                END;


                //SH 20141115 To resolve Pasting record problem
                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" = "Message Status"::Collected THEN BEGIN
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

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                    IF "Message Status" = "Message Status"::" " THEN BEGIN
                        IF Item."Item Supplier Source" = Item."Item Supplier Source"::Renesas THEN BEGIN
                            ERROR(Text009);
                        END;
                    END;
                END;


                //SH 20141115 To resolve Pasting record problem
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
        field(50514; "Save Posting Date"; Date)
        {
            Editable = false;
        }
        field(50515; "Next Receipt Seq. No."; Integer)
        {
            // cleaned
        }
        field(50517; "Post Shipment Collect Flag"; Integer)
        {
            // cleaned
        }
        field(50520; Insertion; Boolean)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';

            trigger OnValidate()
            begin

                IF ((Type = Type::" ") AND (Description = ' ')) THEN BEGIN
                    "Message Status" := "Message Status"::" ";
                    Insertion := FALSE;
                END;
            end;

        }
        field(50521; Edition; Boolean)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50522; "Original Quantity"; Decimal)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50523; "Prev Quantity"; Decimal)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50524; "Edit Count"; Integer)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50525; "Receipt Collection Date"; Date)
        {
            // cleaned
        }
        field(50527; "Purchaser Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanced';
        }
        field(50528; "External Document No."; Code[35])
        {
            FieldClass = FlowField;
            CalcFormula = Max("Value Entry"."External Document No." WHERE("Document No." = FIELD("Document No."),
                                                                          "Document Type" = CONST("Purchase Receipt"),
                                                                          Adjustment = CONST(FALSE)));
            Description = '//CS077';
        }
        field(50617; "Country/Region of Origin Code"; Code[10])
        {
            // cleaned
        }

        modify(Description)
        {

            trigger OnAfterValidate()
            begin


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
                        END;
                    END;
                END;

                //Update 'Description' in Purchase Line
                IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                    rec_PurchLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    IF rec_PurchLine.GET(rec_PurchLine."Document Type"::Order, PurchRcptHeader."Order No.", "Line No.") THEN BEGIN
                        IF (xRec.Description <> Description) THEN BEGIN
                            IF CONFIRM(Text011, TRUE, FIELDCAPTION(Description)) THEN BEGIN
                                rec_PurchLine.Description := Description;
                                rec_PurchLine.MODIFY;
                            END;
                        END;
                    END;
                END;
            end;
        }
    }

    trigger OnBeforeInsert()
    begin


        //SH 04 Nov 12 - Improve PSI Data Mantenance
        //Manual Insert Shipment Line Qty must be Zero since it is not linked to Sales Order

        //Quantity := 0; //BC Upgrade
        Insertion := FALSE;
        Edition := FALSE;
        //Correction := FALSE; //BC Upgrade

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

        "Receipt Collection Date" := 0D;

        IF ((Type = Type::Item) AND (Description <> ' ')) THEN BEGIN
            IF PurchRcptHeader.GET("Document No.") THEN BEGIN
                PurchRcptHeader."Message Collected On(Incoming)" := 0D;
                PurchRcptHeader."Message Status(Incoming)" := PurchRcptHeader."Message Status(Incoming)"::"Ready to Collect";
                PurchRcptHeader.MODIFY;
            END;
        END;
    end;

    trigger OnBeforeModify()
    begin

        //Update Purch. Line Record
        rec_PurchLine.GET(rec_PurchLine."Document Type"::Order, "Order No.", "Line No.");
        rec_PurchLine."CO No." := "CO No.";
        rec_PurchLine."Item Supplier Source" := "Item Supplier Source";
        rec_PurchLine.MODIFY;

    end;

    trigger OnBeforeDelete()
    begin
        //PSI Maintenance
        IF "Message Status" = "Message Status"::Collected THEN
            ERROR(Text010);
        IF "Message Status" = "Message Status"::Sent THEN
            ERROR(Text010);

    end;


    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        rec_PurchLine: Record "Purchase Line";
        Item: Record Item;
        Text002: Label 'Do you really want to insert a new Shipment Line?';
        Text003: Label 'Do you really want to change  current line  %1 from %2 to %3';
        Text004: Label 'This is not Renesas''s Item';
        Text005: Label 'This is Renesas''s Item';
        Text006: Label 'Change not allowed - PSI Data collected but not sent yet!';
        Text007: Label 'The Message Status can only be updated by system!';
        Text008: Label 'You cannot change the Message Status to Collect!';
        Text009: Label 'You can only choose Ready to Collect (not Space) for this is Renesas Item ';
        Text010: Label 'Deletion of this record in not allow - JJ data already collected/sent';
        Text011: Label 'Do you want to update %1 in correesponding Purchase Order Line also?';
        Text012: Label 'Sned Message not done yet';
}
