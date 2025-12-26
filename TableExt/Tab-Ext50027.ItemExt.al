tableextension 50027 "Item Ext" extends "Item"
{
    fields
    {
        field(50000; "Inventory L1"; Decimal)
        {
            Caption = 'Inventory L1';
            DecimalPlaces = 0 : 0;
        }
        field(50002; "Inventory L2"; Decimal)
        {
            Caption = 'Inventory L2';
            DecimalPlaces = 0 : 0;
        }
        field(50010; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(50011; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50012; "OEM No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("Customer Type" = CONST(OEM));
            // cleaned
        }
        field(50013; Products; Text[20])
        {
            // cleaned
        }
        field(50015; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50016; Rank; Code[15])
        {
            // cleaned
        }
        field(50020; SBU; Code[10])
        {
            TableRelation = Manufacturer;
            // cleaned
        }

        // Fields for dimensions(N002)
        field(50021; "Shortcut Dimension 1 Code"; Code[20]) { }
        field(50022; "Shortcut Dimension 2 Code"; Code[20]) { }
        field(50023; "Shortcut Dimension 3 Code"; Code[20]) { }
        field(50024; "Shortcut Dimension 4 Code"; Code[20]) { }
        field(50025; "Shortcut Dimension 5 Code"; Code[20]) { }
        field(50026; "Shortcut Dimension 6 Code"; Code[20]) { }
        field(50027; "Shortcut Dimension 7 Code"; Code[20]) { }
        field(50028; "Shortcut Dimension 8 Code"; Code[20]) { }


        field(50084; "Qty. on Purch. Quote"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Quote),
                                                                              Type = CONST(Item),
                                                                              "No." = FIELD("No."),
                                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Location Code" = FIELD("Location Filter"),
                                                                              "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                              "Variant Code" = FIELD("Variant Filter"),
                                                                              "Bin Code" = FIELD("Bin Filter"),
                                                                              "Expected Receipt Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(50085; "Qty. on Sales Quote"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Quote),
                                                                           Type = CONST(Item),
                                                                           "No." = FIELD("No."),
                                                                           "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                           "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                           "Location Code" = FIELD("Location Filter"),
                                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                           "Variant Code" = FIELD("Variant Filter"),
                                                                           "Bin Code" = FIELD("Bin Filter"),
                                                                           "Shipment Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50086; "Purch. Order Quantity Limit"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(50087; "Qty. on P. O. (Req Rec Date)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                              Type = CONST(Item),
                                                                              "No." = FIELD("No."),
                                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Location Code" = FIELD("Location Filter"),
                                                                              "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                              "Variant Code" = FIELD("Variant Filter"),
                                                                              "Reporting Receipt Date" = FIELD("Date Filter")));
            Description = 'CS013';
            Editable = false;
        }
        field(50088; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

        }
        field(50089; "Cost Amount (Actual)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item No." = FIELD("No."),
                                                                         "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                         "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                         "Location Code" = FIELD("Location Filter"),
                                                                         "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                         "Variant Code" = FIELD("Variant Filter"),
                                                                         "Posting Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 4;
            Description = '//20101009';
            Editable = false;
        }
        field(50090; "Message Collected On"; Date)
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50091; "Message Collected By"; Code[50])
        {
            Description = '//20101009 //20140715';
            Editable = false;
        }
        field(50100; "Update Date"; Date)
        {
            // cleaned
        }
        field(50101; "Update Time"; Time)
        {
            // cleaned
        }
        field(50102; "Update By"; Code[50])
        {
            Description = '//sh20140715';
        }
        field(50103; "Update Doc. No."; Code[20])
        {
            // cleaned
        }
        field(50104; "CU Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
        }
        field(50105; "Creation Date"; Date)
        {
            // cleaned
        }
        field(50106; PKG; Code[20])
        {
            // cleaned
        }
        field(50107; "Cost Amount (Expected)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Amount (Expected)" WHERE("Item No." = FIELD("No."),
                                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                           "Location Code" = FIELD("Location Filter"),
                                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                           "Variant Code" = FIELD("Variant Filter"),
                                                                           "Posting Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 4;
            Description = '//20111102';
        }
        field(50108; "Cost Posted to G/L"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Value Entry"."Cost Posted to G/L" WHERE("Item No." = FIELD("No."),
                                                                       "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                       "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                       "Location Code" = FIELD("Location Filter"),
                                                                       "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                       "Variant Code" = FIELD("Variant Filter"),
                                                                       "Posting Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 4;
        }
        field(50109; "Inventory Shipped"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Location Code" = FIELD("Location Filter"),
                                                                 "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                 "Lot No." = FIELD("Lot No. Filter"),
                                                                 "Serial No." = FIELD("Serial No. Filter"),
                                                                 "Entry Type" = CONST(Sale),
                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Inventory Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50110; "Inventory Receipt"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Location Code" = FIELD("Location Filter"),
                                                                 "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                 "Lot No." = FIELD("Lot No. Filter"),
                                                                 "Serial No." = FIELD("Serial No. Filter"),
                                                                 "Entry Type" = CONST(Purchase),
                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Inventory Receipt';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50111; "Inventory Neg Adj"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Location Code" = FIELD("Location Filter"),
                                                                 "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                 "Lot No." = FIELD("Lot No. Filter"),
                                                                 "Serial No." = FIELD("Serial No. Filter"),
                                                                 "Entry Type" = CONST("Negative Adjmt."),
                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Inventory Neg Adj';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50112; "Inventory Pos Adj"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Location Code" = FIELD("Location Filter"),
                                                                 "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                 "Lot No." = FIELD("Lot No. Filter"),
                                                                 "Serial No." = FIELD("Serial No. Filter"),
                                                                 "Entry Type" = CONST("Positive Adjmt."),
                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Inventory Pos Adj';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50113; "Qty on Sales Order (OSQ)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = CONST(Order),
                                                                        Type = CONST(Item),
                                                                        "No." = FIELD("No."),
                                                                        "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                        "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                        "Location Code" = FIELD("Location Filter"),
                                                                        "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                        "Variant Code" = FIELD("Variant Filter"),
                                                                        "Shipment Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(50114; "Original Item No."; Code[20])
        {
            // cleaned
        }
        field(50115; "Initial Blocked"; Boolean)
        {
            // cleaned
        }
        field(50116; "Expected Receipt Date Flag"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Purchase Line" WHERE("Document Type" = CONST(Order),
                                                      Type = CONST(Item),
                                                      "No." = FIELD("No."),
                                                      "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                      "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                      "Location Code" = FIELD("Location Filter"),
                                                      "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                      "Variant Code" = FIELD("Variant Filter"),
                                                      "Reporting Receipt Date" = FIELD("Date Filter"),
                                                      "Use Expected Receipt Date" = CONST(FALSE)));
            // cleaned
        }
        field(50117; "Country/Region of Org Cd (FE)"; Code[10])
        {
            TableRelation = "Country/Region";
            Caption = 'Country/Region of Origin Code (Front-end)';
            Description = 'CS016';
        }
        field(50120; Hold_L1; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(50121; Hold_L2; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(50122; Office_L; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(50125; "Inventory Shipped Not Inv"; Decimal)
        {
            Caption = 'Inventory Shipped Not Invd';
        }
        field(50126; "Shipped Not Invoiced Cost(LCY)"; Decimal)
        {
            Caption = 'Shipper Not Invoiced Cost (LCY)';
        }
        field(50130; "Service Parts"; Boolean)
        {
            Description = 'CS058';
        }
        field(50131; "Order Deadline Date"; Date)
        {
            Description = 'CS059';
        }
        field(50140; "One Renesas EDI"; Boolean)
        {
            Description = 'CS060';
        }
        field(50141; "Excluded in Inventory Report"; Boolean)
        {
            Description = 'CS098';
        }
        field(50150; "Customer Item No.(Plain)"; Code[20])
        {
            Description = 'CS080';
        }
        field(50151; "Markup%"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'CS080';
        }
        field(50152; "Markup%(Sales Price)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'CS087';
        }
        field(50153; "Markup%(Purchase Price)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'CS087';
        }
        field(50160; "FCA In-Transit"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "FCA In-Transit" = CONST(TRUE)));
            DecimalPlaces = 0 : 5;
            Description = 'CS084';
        }
        field(50170; "Item Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Item Group".Code;
        }
        field(60000; Hold; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 //"Location Code" = CONST('HOLD'), //Upgrade to BC
                                                                 Hold = const(true), //Upgrade to BC
                                                                 "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                 "Variant Code" = FIELD("Variant Filter"),
                                                                 "Lot No." = FIELD("Lot No. Filter"),
                                                                 "Serial No." = FIELD("Serial No. Filter")));
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(60001; EOL; Boolean)
        {
            Caption = 'EOL';
            Description = 'HG10.00.01 NJ 20/03/2017';
        }
        field(60002; Memo; Text[50])
        {
            Caption = 'Memo';
            Description = 'HG10.00.01 NJ 20/03/2017';
        }
        field(60003; "Familiar Name"; Code[20])
        {
            Caption = 'Familiar Name';
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = true;
        }
        field(60004; "Manufacturer 2 Code"; Text[50])
        {
            Caption = 'Manufacturer 2 Code';
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(60005; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(60006; EDI; Boolean)
        {
            Description = 'HG10.00.02 SS 15/03/2018';
        }
        field(60050; "Car Model"; Text[20])
        {
            // cleaned
        }
        field(60051; SOP; Text[15])
        {
            // cleaned
        }
        field(60052; "MP-Volume(pcs/M)"; Decimal)
        {
            // cleaned
        }
        field(60053; Apl; Text[5])
        {
            // cleaned
        }

    }

    trigger OnBeforeInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Item) then begin
            if not recApprSetup."Inprogress Item" then begin
                Error('The Approval setup is active.\The process cannot be completed.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Item) then begin
            if not recApprSetup."Inprogress Item" then begin
                Error('The Approval setup is active.\The process cannot be completed.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Item) then begin
            if not recApprSetup."Inprogress Item" then begin
                Error('The Approval setup is active.\The process cannot be completed.');
            end;
        end;
        //N005 End

    end;
}
