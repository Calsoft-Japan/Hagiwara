tableextension 50037 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "Vendor Item Number"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Vendor Item No." WHERE("No." = FIELD("No.")));
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

            trigger OnValidate()
            var
                rec_Customer: Record Customer;
            begin
                //SH 20130831
                IF rec_Customer.GET("OEM No.") THEN
                    "OEM Name" := rec_Customer.Name;

            end;
        }
        field(50021; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50101; "Approved Quantity"; Decimal)
        {
            //N005
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50102; "Approved Unit Price"; Decimal)
        {
            //N005
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Editable = false;
        }
        field(50103; "Approval History Exists"; Boolean)
        {
            //N005
            Editable = false;
        }
        field(50201; "Price Target Update"; Boolean)
        {
            InitValue = true;
        }
        field(50500; "Shipment Seq. No."; Integer)
        {
            Editable = true;
        }
        field(50501; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = true;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                //SH 20111105 - To allow Msg Status change to Ready to collect when the field is changed from space to 'Renesas'
                IF Type = Type::Item THEN
                    Item := GetItem();
                IF (Type = Type::Item) AND (xRec."Item Supplier Source" <> xRec."Item Supplier Source"::Renesas) THEN BEGIN
                    IF "Item Supplier Source" = "Item Supplier Source"::Renesas THEN BEGIN
                        IF (Item."Item Supplier Source" = Item."Item Supplier Source"::" ") THEN BEGIN
                            ERROR(Text114);
                        END ELSE BEGIN
                            IF CONFIRM(Text113, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                                'Ready to Collect') THEN BEGIN
                                "Message Status" := "Message Status"::"Ready to Collect";
                                "Update Date" := TODAY;
                                "Update Time" := TIME;
                                "Update By" := USERID;
                            END;
                        END;
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Item Supplier Source" = xRec."Item Supplier Source"::Renesas) THEN BEGIN
                    IF ("Item Supplier Source" = "Item Supplier Source"::" ") THEN BEGIN
                        IF (Item."Item Supplier Source" <> Item."Item Supplier Source"::" ") THEN BEGIN
                            ERROR(Text115);
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
            var
                Item: Record Item;
            begin
                //SH 20111105 - For PSI Data Maintenance check
                IF Type = Type::Item THEN
                    Item := GetItem();

                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Collected) THEN BEGIN
                //      IF  "Message Status" <> "Message Status"::Collected THEN BEGIN
                //           ERROR(Text116);
                //      END;
                //END;

                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Collected) THEN BEGIN
                //      IF  "Message Status" <> "Message Status"::Collected THEN BEGIN
                //           ERROR(Text119);
                //      END;
                //END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                    IF "Message Status" = "Message Status"::Sent THEN BEGIN
                        IF CONFIRM(Text113, TRUE, FIELDCAPTION("Message Status"), xRec."Message Status",
                            'Sent') THEN BEGIN
                        END ELSE BEGIN
                            "Message Status" := xRec."Message Status";
                        END;
                    END;
                END;

                //IF    (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                //      IF  "Message Status" = "Message Status"::Collected THEN BEGIN
                //           ERROR(Text117);
                //      END;
                //END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::"Ready to Collect") THEN BEGIN
                    IF "Message Status" = "Message Status"::" " THEN BEGIN
                        IF Item."Item Supplier Source" = Item."Item Supplier Source"::Renesas THEN BEGIN
                            ERROR(Text118);
                        END;
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::Collected THEN BEGIN
                        ERROR(Text117);
                    END;
                END;

                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::"Ready to Collect" THEN BEGIN
                        IF CONFIRM(Text113, TRUE, FIELDCAPTION("Message Status"), xRec."Message Status",
                            'Ready to Collect') THEN BEGIN
                        END ELSE BEGIN
                            "Message Status" := xRec."Message Status";
                        END;
                    END;
                END;
                IF (Type = Type::Item) AND (xRec."Message Status" = xRec."Message Status"::Sent) THEN BEGIN
                    IF "Message Status" = "Message Status"::" " THEN BEGIN
                        IF Item."Item Supplier Source" = Item."Item Supplier Source"::Renesas THEN BEGIN
                            ERROR(Text118);
                        END;
                    END;
                END;
                IF xRec."Message Status" <> "Message Status" THEN BEGIN
                    "Update Date" := TODAY;
                    "Update Time" := TIME;
                    "Update By" := USERID;
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
        field(50514; "Next Shipment Seq. No."; Integer)
        {
            Editable = true;
        }
        field(50515; "Save Customer Order No."; Text[35])
        {
            Description = '//30//';
            Editable = false;
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
            Editable = true;
            trigger OnValidate()
            var
                InvtSetup: Record "Inventory Setup";
                NoSeriesMgt: codeunit NoSeriesManagement;
            begin
                //Siak Hui 20111124 - Start
                //IF "Booking No." <> xRec."Booking No." THEN BEGIN
                IF "Booking No." = '' THEN BEGIN
                    InvtSetup.get();
                    NoSeriesMgt.TestManual(InvtSetup."Booking Serial Nos.");
                    "No. Series" := '';
                END;
            end;

        }
        field(50519; "No. Series"; Code[10])
        {
            // cleaned
        }
        field(50520; "Shipped Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line".Quantity WHERE("No." = FIELD("No."),
                                                                   "Order No." = FIELD("Document No."),
                                                                   "Line No." = FIELD("Line No."),
                                                                   Type = FIELD(Type),
                                                                   "Location Code" = FIELD("Location Code"),
                                                                   "Posting Date" = FIELD("Date Filter")));
            // cleaned
        }
        field(50521; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            // cleaned
        }
        field(50522; "JC Collection Date"; Date)
        {
            // cleaned
        }
        field(50523; "Outstanding Quantity (Actual)"; Decimal)
        {
            // cleaned
        }
        field(50524; "Actual Customer No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("No." = FIELD("Actual Customer No."));
            // cleaned
        }
        field(50525; "Vendor Cust. Code"; Code[13])
        {
            // cleaned
        }
        field(50526; "PSI Process Date"; Date)
        {
            Description = '//20121103 SiakHui - use for combining 2 PSI Init jobs to 1 job enhancement';
        }
        field(50528; Remarks; Text[30])
        {
            Caption = 'Remarks';
        }
        field(50535; "JA Collection Date"; Date)
        {
            // cleaned
        }
        field(50537; Revised; Code[1])
        {
            Description = '//20121114 SiakHui - use for revising JC PSI';
        }
        field(50538; "Message Status (JC)"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(50539; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            // cleaned
        }
        field(50540; "Original Doc. No."; Code[20])
        {
            Description = '//20121215 Siakhui 0 used to store FIFO SO / SQ No.';
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
        field(50544; "Promised Delivery Date_1"; Date)
        {
            // cleaned
        }
        field(50545; "Requested Delivery Date_1"; Date)
        {
            // cleaned
        }
        field(50546; "EDI_Lineshipment Date"; Date)
        {
            // cleaned
        }
        field(50547; "Fully Reserved"; Boolean)
        {
            Description = 'CS018';
            Editable = false;
            NotBlank = true;
        }
        field(50548; "Manufacturer Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Manufacturer Code" WHERE("No." = FIELD("No.")));
            Description = 'CS033';
        }
        field(50550; "Line Amount to ship"; Decimal)
        {
            Caption = 'Line Amount to ship';
            Description = 'SKHE20121220';
            Editable = true;

        }
        field(50551; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            Description = 'SKHE20140210';
            Editable = false;
        }
        field(50564; "Shipped Not Invoiced Cost(LCY)"; Decimal)
        {
            Caption = 'Shipper Not Invoiced Cost (LCY)';
            Description = '50524';
            Editable = false;
        }
        field(50565; "2nd Unit of Measure Code"; Code[10])
        {
            Caption = '2nd Unit of Measure';

        }
        field(50566; "2nd Unit of Measure"; Text[10])
        {
            Editable = false;
        }
        field(50567; "Qty to Ship (2nd UOM)"; Decimal)
        {
            Caption = 'Qty tp Ship (2nd UOM)';
            DecimalPlaces = 0 : 0;
        }

        modify(Type)
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                // YUKA for Hagiwara 20030408
                SalesHeader := GetSalesHeader();
                "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                // YUKA for Hagiwara 20030408 - END
            end;
        }

        modify("No.")
        {

            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                Item: Record "Item";
                rec_Customer: Record Customer;
                InvtSetup: Record "Inventory Setup";
                NoSeriesMgt: codeunit NoSeriesManagement;
                g_NoSeries: Code[10];
            begin

                CASE Type OF
                    Type::Item:
                        BEGIN

                            SalesHeader := GetSalesHeader();
                            Item := GetItem();
                            // Siak Hui for Hagiwara 20110426
                            "Message Status" := "Message Status"::"Ready to Collect";
                            SalesHeader."Message Status(Booking)" := SalesHeader."Message Status(Booking)"::"Ready to Collect";
                            SalesHeader.MODIFY;
                            "Update Date" := TODAY;
                            "Update Time" := TIME;
                            "Update By" := USERID;
                            Products := Item.Products;
                            IF rec_Customer.GET(Item."OEM No.") THEN BEGIN
                                "Actual Customer No." := Item."OEM No.";
                                "OEM No." := Item."OEM No.";
                                "OEM Name" := rec_Customer.Name;
                                "Vendor Cust. Code" := rec_Customer."Vendor Cust. Code";
                            END ELSE BEGIN
                                IF rec_Customer.GET("Sell-to Customer No.") THEN BEGIN
                                    "Actual Customer No." := "Sell-to Customer No.";
                                    "Vendor Cust. Code" := rec_Customer."Vendor Cust. Code";
                                END;
                            END;
                            //Siak Hui 20111122 - Start
                            //GetSalesHeader;
                            "Serial No." := SalesHeader."Last Serial No." + 1;
                            SalesHeader."Last Serial No." := "Serial No.";
                            SalesHeader.MODIFY;
                            //Siak Hui 20111122 - End
                            //Siak Hui 20111124 - Start
                            IF xRec."Booking No." = '' THEN BEGIN
                                g_NoSeries := 'SN1';
                                //GetInvtSetup;
                                InvtSetup.Get();
                                InvtSetup.TESTFIELD("Booking Serial Nos.");
                                NoSeriesMgt.InitSeries(InvtSetup."Booking Serial Nos.", xRec."No. Series", 0D, "Booking No.", "No. Series");
                            END ELSE BEGIN
                                "Booking No." := xRec."Booking No.";
                            END;
                            //Siak Hui 20111124 - Start
                            //siak Hui for HAgiwara 20111013
                            IF "Document Type" = "Document Type"::Order THEN
                                "Customer Order No." := SalesHeader."External Document No.";
                            // Siak Hui for Hagiwara 20110426 - END

                            // YUKA for Hagiwara 20030226
                            "Customer Item No." := Item."Customer Item No.";
                            "Parts No." := Item."Parts No.";
                            Rank := Item.Rank;
                            // YUKA for Hagiwara 20030226 - END

                            "Item Supplier Source" := Item."Item Supplier Source";//>>
                            "Shipment Seq. No." := 1; //>>
                            "Next Shipment Seq. No." := 1; //>>
                        end;
                end;
            end;
        }

        modify(Quantity)
        {
            /*
            //N005
            trigger OnBeforeValidate()
            var
                SalesHeader: Record "Sales Header";
                recApprSetup: Record "Hagiwara Approval Setup";
                updated: Boolean;
            begin

                if xRec."Quantity" <> Rec."Quantity" then begin
                    recApprSetup.Get();
                    if ((recApprSetup."Sales Order") and (Rec."Document Type" = Rec."Document Type"::Order)
                        or (recApprSetup."Sales Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
                        or (recApprSetup."Sales Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                            ) then begin
                        SalesHeader := Rec.GetSalesHeader();
                        if SalesHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved,
                                Enum::"Hagiwara Approval Status"::"Auto Approved",
                                Enum::"Hagiwara Approval Status"::"Re-Approval Required",
                                Enum::"Hagiwara Approval Status"::"Re-Submitted",
                                Enum::"Hagiwara Approval Status"::"Submitted",
                                Enum::"Hagiwara Approval Status"::"Auto Approved"]
                                then begin
                            Error('Can''t update Quantity because of the current approval status.');
                        end;
                    end;
                end;
            end;
            */

            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
                Item: Record "Item";
                QtyEval: Decimal;
            begin
                IF Type = Type::Item THEN BEGIN
                    // YUKA for Hagiwara
                    IF (Type = Type::Item) AND (Quantity <> 0) THEN BEGIN
                        Item.GET("No.");
                        IF Item."Order Multiple" <> 0 THEN BEGIN
                            QtyEval := Quantity / Item."Order Multiple";
                            QtyEval := ROUND(QtyEval, 1, '>');
                            IF QtyEval <> Quantity / Item."Order Multiple" THEN
                                MESSAGE(text102, FORMAT(Quantity), FORMAT(Item."Order Multiple"), "No.", Item."Familiar Name");
                        END;
                    END;
                    // YUKA for Hagiwara - END
                    //SH 20110504 - For PSI Data JA Maintenmance
                    IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                        //SH 20112012 - To allow Msg Status change when Qty change (Qty = 0 -> Cancel sales Line Order)
                        // IF (Type = Type::Item) AND (Quantity <> 0) AND (xRec.Quantity <> 0) THEN BEGIN
                        IF (Type = Type::Item) AND (xRec.Quantity <> 0) THEN BEGIN
                            IF "Message Status" <> "Message Status"::"Ready to Collect" THEN BEGIN
                                IF CONFIRM(Text113, TRUE, FIELDCAPTION("Message Status"), "Message Status",
                                   'Ready to Collect') THEN BEGIN
                                    "Message Status" := "Message Status"::"Ready to Collect";
                                    "Update Date" := TODAY;
                                    "Update Time" := TIME;
                                    "Update By" := USERID;
                                    SalesHeader := GetSalesHeader();
                                    SalesHeader."Message Status(Booking)" := SalesHeader."Message Status(Booking)"::"Ready to Collect";
                                    SalesHeader.MODIFY;
                                END;
                            END;
                        END;
                    END;
                end;
            end;
        }

        /*
        modify("Unit Price")
        {
            //N005
            trigger OnBeforeValidate()
            var
                SalesHeader: Record "Sales Header";
                recApprSetup: Record "Hagiwara Approval Setup";
                updated: Boolean;
            begin
                if xRec."Unit Price" <> Rec."Unit Price" then begin
                    recApprSetup.Get();
                    if ((recApprSetup."Sales Order") and (Rec."Document Type" = Rec."Document Type"::Order)
                        or (recApprSetup."Sales Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
                        or (recApprSetup."Sales Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                            ) then begin
                        SalesHeader := Rec.GetSalesHeader();
                        if SalesHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved,
                                Enum::"Hagiwara Approval Status"::"Auto Approved",
                                Enum::"Hagiwara Approval Status"::"Re-Approval Required",
                                Enum::"Hagiwara Approval Status"::"Re-Submitted",
                                Enum::"Hagiwara Approval Status"::"Submitted",
                                Enum::"Hagiwara Approval Status"::"Auto Approved"]
                                then begin
                            Error('Can''t update Unit Price because of the current approval status.');
                        end;
                    end;
                end;
            end;
        }
        */

        modify("Reserved Qty. (Base)")
        {
            trigger OnAfterValidate()
            begin
                "Fully Reserved" := Planned; //CS018
            end;
        }
    }

    trigger OnBeforeModify()
    var
        SalesHeader: Record "Sales Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (Rec."Document Type" = Rec."Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                ) then begin
            SalesHeader := Rec.GetSalesHeader();
            if SalesHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;

            if SalesHeader."Approval Cycle No." > 0 then begin
                if (Type <> xRec.Type)
                    or ("No." <> xRec."No.") then begin
                    Error('Can''t edit this field because of it''s been fully approved once.');
                end;
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeInsert()
    var
        SalesHeader: Record "Sales Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (Rec."Document Type" = Rec."Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                ) then begin
            SalesHeader := Rec.GetSalesHeader();
            if SalesHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        SalesHeader: Record "Sales Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Sales Order") and (Rec."Document Type" = Rec."Document Type"::Order)
            or (recApprSetup."Sales Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
            or (recApprSetup."Sales Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                ) then begin
            SalesHeader := Rec.GetSalesHeader();
            if SalesHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnAfterInsert()
    begin

        "Shipment Seq. No." := 1; //>>
        "Next Shipment Seq. No." := 1; //>>
        Modify();
    end;


    var
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        Text031: Label 'You must either specify %1 or %2.';
        Text034: Label 'The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.';
        Text035: Label 'Warehouse ';
        Text036: Label 'Inventory ';
        HideValidationDialog: Boolean;
        Text037: Label 'You cannot change %1 when %2 is %3 and %4 is positive.';
        Text038: Label 'You cannot change %1 when %2 is %3 and %4 is negative.';
        Text039: Label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text040: Label 'You must use form %1 to enter %2, if item tracking is used.';
        Text042: Label 'When posting the Applied to Ledger Entry %1 will be opened first';
        ShippingMoreUnitsThanReceivedErr: Label 'You cannot ship more than the %1 units that you have received for document no. %2.';
        Text044: Label 'cannot be less than %1';
        Text045: Label 'cannot be more than %1';
        Text046: Label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text047: Label 'must be positive when %1 is not 0.';
        Text048: Label 'You cannot use item tracking on a %1 created from a %2.';
        Text049: Label 'cannot be %1.';
        Text051: Label 'You cannot use %1 in a %2.';
        PrePaymentLineAmountEntered: Boolean;
        Text052: Label 'You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text053: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text054: Label 'Cancelled.';
        Text055: Label '%1 must not be greater than the sum of %2 and %3.', Comment = 'Quantity Invoiced must not be greater than the sum of Qty. Assigned and Qty. to Assign.';
        Text056: Label 'You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.';
        Text057: Label 'must have the same sign as the shipment';
        Text058: Label 'The quantity that you are trying to invoice is greater than the quantity in shipment %1.';
        Text059: Label 'must have the same sign as the return receipt';
        Text060: Label 'The quantity that you are trying to invoice is greater than the quantity in return receipt %1.';
        Text101: Label 'Qty. to Ship : %1  must be less than Reserved Qty : %2';
        text102: Label 'Quantity entered : %1  is not multiple of standard pack : %2. Item No. : %3 %4. ';
        Text111: Label 'Shipment Date is before workdate';
        Text112: Label 'Shipment Date is more than 6 month later';
        Text113: Label 'Do you want to change  current line  %1 from %2 to %3';
        Text114: Label 'This item is not a Renesas''s Item ';
        Text115: Label 'Thhis item is Renesas''s Item';
        Text116: Label 'Change not allowed - PSI Data collected but not sent yet  ';
        Text117: Label 'Collected Message Status must be updated by system ';
        Text118: Label 'You can only choose Ready to Collect (not space) for this is a Renesas Item';
        Text119: Label 'Send Message not done yet';
        Text1500000: Label 'ONE';
        Text1500001: Label 'TWO';
        Text1500002: Label 'THREE';
        Text1500003: Label 'FOUR';
        Text1500004: Label 'FIVE';
        Text1500005: Label 'SIX';
        Text1500006: Label 'SEVEN';
        Text1500007: Label 'EIGHT';
        Text1500008: Label 'NINE';
        Text1500009: Label 'TEN';
        Text1500010: Label 'ELEVEN';
        Text1500011: Label 'TWELVE';
        Text1500012: Label 'THIRTEEN';
        Text1500013: Label 'FOURTEEN';
        Text1500014: Label 'FIFTEEN';
        Text1500015: Label 'SIXTEEN';
        Text1500016: Label 'SEVENTEEN';
        Text1500017: Label 'EIGHTEEN';
        Text1500018: Label 'NINETEEN';
        Text1500019: Label 'TWENTY';
        Text1500020: Label 'THIRTY';
        Text1500021: Label 'FORTY';
        Text1500022: Label 'FIFTY';
        Text1500023: Label 'SIXTY';
        Text1500024: Label 'SEVENTY';
        Text1500025: Label 'EIGHTY';
        Text1500026: Label 'NINETY';
        Text1500027: Label 'THOUSAND';
        Text1500028: Label 'MILLION';
        Text1500029: Label 'BILLION';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Text1500030: Label 'NUENG';
        Text1500031: Label 'SAWNG';
        Text1500032: Label 'SARM';
        Text1500033: Label 'SI';
        Text1500034: Label 'HA';
        Text1500035: Label 'HOK';
        Text1500036: Label 'CHED';
        Text1500037: Label 'PAED';
        Text1500038: Label 'KOW';
        Text1500039: Label 'SIB';
        Text1500040: Label 'SIB-ED';
        Text1500041: Label 'SIB-SAWNG';
        Text1500042: Label 'SIB-SARM';
        Text1500043: Label 'SIB-SI';
        Text1500044: Label 'SIB-HA';
        Text1500045: Label 'SIB-HOK';
        Text1500046: Label 'SIB-CHED';
        Text1500047: Label 'SIB-PAED';
        Text1500048: Label 'SIB-KOW';
        Text1500049: Label 'YI-SIB';
        Text1500050: Label 'SARM-SIB';
        Text1500051: Label 'SI-SIB';
        Text1500052: Label 'HA-SIB';
        Text1500053: Label 'HOK-SIB';
        Text1500054: Label 'CHED-SIB';
        Text1500055: Label 'PAED-SIB';
        Text1500056: Label 'KOW-SIB';
        Text1500057: Label 'PHAN';
        Text1500058: Label 'LAAN?';
        Text1500059: Label 'PHAN-LAAN?';
        Text1500060: Label 'HUNDRED';
        Text1500061: Label 'ZERO';
        Text1500062: Label 'AND';


    procedure InitTextVariable()
    begin
        OnesText[1] := Text1500000;
        OnesText[2] := Text1500001;
        OnesText[3] := Text1500002;
        OnesText[4] := Text1500003;
        OnesText[5] := Text1500004;
        OnesText[6] := Text1500005;
        OnesText[7] := Text1500006;
        OnesText[8] := Text1500007;
        OnesText[9] := Text1500008;
        OnesText[10] := Text1500009;
        OnesText[11] := Text1500010;
        OnesText[12] := Text1500011;
        OnesText[13] := Text1500012;
        OnesText[14] := Text1500013;
        OnesText[15] := Text1500014;
        OnesText[16] := Text1500015;
        OnesText[17] := Text1500016;
        OnesText[18] := Text1500017;
        OnesText[19] := Text1500018;

        TensText[1] := '';
        TensText[2] := Text1500019;
        TensText[3] := Text1500020;
        TensText[4] := Text1500021;
        TensText[5] := Text1500022;
        TensText[6] := Text1500023;
        TensText[7] := Text1500024;
        TensText[8] := Text1500025;
        TensText[9] := Text1500026;

        ExponentText[1] := '';
        ExponentText[2] := Text1500027;
        ExponentText[3] := Text1500028;
        ExponentText[4] := Text1500029;

    end;

    procedure InitTextVariableTH()
    begin
        OnesText[1] := Text1500030;
        OnesText[2] := Text1500031;
        OnesText[3] := Text1500032;
        OnesText[4] := Text1500033;
        OnesText[5] := Text1500034;
        OnesText[6] := Text1500035;
        OnesText[7] := Text1500036;
        OnesText[8] := Text1500037;
        OnesText[9] := Text1500038;
        OnesText[10] := Text1500039;
        OnesText[11] := Text1500040;
        OnesText[12] := Text1500041;
        OnesText[13] := Text1500042;
        OnesText[14] := Text1500043;
        OnesText[15] := Text1500044;
        OnesText[16] := Text1500045;
        OnesText[17] := Text1500046;
        OnesText[18] := Text1500047;
        OnesText[19] := Text1500048;

        TensText[1] := '';
        TensText[2] := Text1500049;
        TensText[3] := Text1500050;
        TensText[4] := Text1500051;
        TensText[5] := Text1500052;
        TensText[6] := Text1500053;
        TensText[7] := Text1500054;
        TensText[8] := Text1500055;
        TensText[9] := Text1500056;

        ExponentText[1] := '';
        ExponentText[2] := Text1500057;
        ExponentText[3] := Text1500058;
        ExponentText[4] := Text1500059;
    end;


    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500061)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500060);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500062);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;


    procedure FormatNoTextTH(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500061)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500060);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500062);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;
}
