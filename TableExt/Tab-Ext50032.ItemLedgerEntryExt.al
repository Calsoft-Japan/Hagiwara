tableextension 50032 "Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50000; "Cust. / Vend. No."; Code[20])
        {
            Caption = 'Customer / Vendor No.';
            Description = 'BBN.01';
        }
        field(50001; "CO No."; Code[6])
        {
            Description = '//SiakHui:To print CO No. in Posted Purchase Receipt Report ID:50018';
        }
        field(50002; "Salespers./Purch. Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Salespers./Purch. Code';
            Description = '//20121203 Enhancements';
        }
        field(50003; "Sales Order No."; Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50004; "Purchase Order No."; Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50015; "Sales / Purch. Order No."; Code[20])
        {
            Caption = 'Sales / Purchase Order No.';
            Description = 'BBN.01';
        }
        field(50016; "Excel Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(50017; "Excel Product"; Text[20])
        {
            Caption = 'Product';
        }
        field(50018; "Excel OEM No."; Code[20])
        {
            Caption = 'OEM No.';
        }
        field(50019; "Excel SBU"; Code[10])
        {
            Caption = 'SBU';
        }
        /*field(50035; "Item Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Editable = false;
        }*/

        // Fields for dimensions(N002)
        field(50021; "Shortcut Dimension 1 Code"; Code[20]) { }
        field(50022; "Shortcut Dimension 2 Code"; Code[20]) { }
        // field(50023; "Shortcut Dimension 3 Code"; Code[20]) { }
        // field(50024; "Shortcut Dimension 4 Code"; Code[20]) { }
        // field(50025; "Shortcut Dimension 5 Code"; Code[20]) { }
        // field(50026; "Shortcut Dimension 6 Code"; Code[20]) { }
        // field(50027; "Shortcut Dimension 7 Code"; Code[20]) { }
        // field(50028; "Shortcut Dimension 8 Code"; Code[20]) { }
        field(50036; "Customer Item No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Customer Item No." WHERE("No." = FIELD("Item No.")));
            Description = 'CS034';
        }
        field(50040; "FCA In-Transit"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Location."Use As FCA In-Transit" WHERE(Code = FIELD("Location Code")));
            Description = 'CS084';
        }
        field(50050; "ITE Collected"; Boolean)
        {
            Description = 'CS082';
        }
        field(50051; "ITE Manually"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Inventory Trace Entry" WHERE("Item Ledger Entry No." = FIELD("Entry No."),
                                                              "Manually Updated" = CONST(TRUE)));
            Description = 'CS082';
        }
        field(50052; "Manufacturer Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Manufacturer Code" WHERE("No." = FIELD("Item No.")));
            Description = 'CS082';
        }
        field(90012; "Parts No."; Code[50])
        {
            Caption = 'Parts No.';
            Description = 'BBN.01';
        }
    }


    procedure GetTrackingDate(): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        //HG10.00.09 NJ 05/04/2018 -->
        IF "Document Type" = "Document Type"::"Sales Shipment" THEN BEGIN
            IF SalesShipmentHeader.GET("Document No.") THEN
                EXIT(SalesShipmentHeader."Shipment Tracking Date");
        END;
        IF "Document Type" = "Document Type"::"Purchase Receipt" THEN BEGIN
            IF PurchRcptHeader.GET("Document No.") THEN
                EXIT(PurchRcptHeader."Goods Arrival Date");
        END;
        EXIT(0D);
        //HG10.00.09 NJ 05/04/2018 <--
    end;

}
