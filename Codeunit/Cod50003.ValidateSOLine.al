codeunit 50003 ValidateSOLine
{
    // CS061 Leon 2023/09/08 - SO Post Upload (Salese Shipment/Invoice)


    trigger OnRun()
    begin

        IF TransType = TransType::Ship THEN BEGIN
            //RecRef.OPEN(DATABASE::"Sales Ship Import Line");
            ValidateShipment();
        END
        ELSE IF TransType = TransType::Invoice THEN BEGIN
            //RecRef.OPEN(DATABASE::"Sales Invoice Import Line");
            VlidateInvoice();
        END
        ELSE IF TransType = TransType::ShipInvoice THEN BEGIN
            //RecRef.OPEN(DATABASE::"Sales Invoice Import Line");
            VlidateShipInvoice();
        END;
    end;

    var
        TransType: Option Ship,Invoice,ShipInvoice;
        RecRef: RecordRef;
        ColumnNMAE: Text;
        MyInt: Integer;
        MyDec: Decimal;
        MyDate: Date;
        SOLine: Record "Sales Line";
        SOHeader: Record "Sales Header";
        Cust: Record Customer;
        ShipAgt: Record "Shipping Agent";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        ShipMethod: Record "Shipment Method";

    procedure SetTransType(Type: Option Ship,Invoice; RecordRef: RecordRef; FieldName: Text)
    begin
        TransType := Type;
        RecRef := RecordRef;
        ColumnNMAE := FieldName;
    end;

    local procedure ValidateShipment()
    var
        ShipLine: Record "Sales Ship Import Line";
        ShipLine2: Record "Sales Ship Import Line";
    begin
        CLEARLASTERROR;

        //ShipLine.GET(RecRef.FIELD(ShipLine.FIELDNO("Order No.")),RecRef.FIELD(ShipLine.FIELDNO("Posting Date")),
        //      RecRef.FIELD(ShipLine.FIELDNO("Shipment Method Code")),RecRef.FIELD(ShipLine.FIELDNO("Shipping Agent Code")),
        //      RecRef.FIELD(ShipLine.FIELDNO("Package Tracking No.")),RecRef.FIELD(ShipLine.FIELDNO("Line No.")));//Order No. & LINE NO.
        ShipLine.GET(RecRef.FIELD(ShipLine.FIELDNO("Entry No.")));

        IF NOT SOHeader.GET(SOHeader."Document Type"::Order, ShipLine."Order No.") THEN;
        IF NOT SOLine.GET(SOHeader."Document Type"::Order, ShipLine."Order No.", ShipLine."Line No.") THEN;

        IF SOHeader.Status <> SOHeader.Status::Open THEN
            ReleaseSalesDoc.PerformManualReopen(SOHeader);
        /*
        ShipLine2.RESET;
        ShipLine2.SETRANGE("Order No.", ShipLine."Order No.");
        ShipLine2.SETRANGE("Line No.", ShipLine."Line No.");
        ShipLine2.SETRANGE("Posting Date", ShipLine."Posting Date");
        ShipLine2.SETRANGE("Qty. to Ship", ShipLine."Qty. to Ship");
        ShipLine2.SETRANGE("Shipment Method Code", ShipLine."Shipment Method Code");
        ShipLine2.FINDSET();
        IF ShipLine2.COUNT > 1 THEN
          ERROR('The same data exists in "Document No", "Line No.", "Qty.to Ship", "Posting Date", and "Shipping Method Code”.');
        
        IF NOT SOHeader.GET(SOHeader."Document Type"::Order, ShipLine."Order No.") THEN
          ERROR('"Document No." does not exist.');
        
        IF NOT SOLine.GET(SOHeader."Document Type"::Order, ShipLine."Order No.",ShipLine."Line No.") THEN
          ERROR('Combination of "Document No." and "Line No." does not exist.');*/

        CASE ColumnNMAE OF
            /*'Order No.':
                SOHeader.GET(SOHeader."Document Type"::Order, ShipLine."Order No.");
            'Line No.':
                SOLine.GET(SOHeader."Document Type"::Order, ShipLine."Order No.",ShipLine."Line No.");*/
            'Posting Date':
                SOHeader.VALIDATE(SOHeader."Posting Date", ShipLine."Posting Date");
            'Document Date':
                SOHeader.VALIDATE(SOHeader."Document Date", ShipLine."Document Date");
            'Customer No.':
                //SOHeader.VALIDATE(SOHeader."Sell-to Customer No.", ShipLine."Customer No.");
                IF SOHeader."Sell-to Customer No." <> ShipLine."Customer No." THEN
                    ERROR('Customer No. is wrong.');
            'Item No.':
                IF SOLine."No." <> ShipLine."Item No." THEN
                    ERROR('Item No. is wrong.');
            'Qty. to Ship':
                IF SOLine."Outstanding Quantity" < ShipLine."Qty. to Ship" THEN
                    ERROR('"Qty. to Ship" is more than "Outstanding Qty".')
                ELSE
                    SOLine.VALIDATE("Qty. to Ship", ShipLine."Qty. to Ship");
            'Shipment Method Code':
                //SOHeader.VALIDATE(SOHeader."Shipment Method Code", ShipLine."Shipment Method Code");
                IF (ShipLine."Shipment Method Code" <> '') AND (NOT ShipMethod.GET(ShipLine."Shipment Method Code")) THEN
                    ERROR('Shipment Method Code does not exist in Shipment Methods.');
            'Shipping Agent Code':
                //SOHeader.VALIDATE(SOHeader."Shipping Agent Code", ShipLine."Shipping Agent Code");
                IF (ShipLine."Shipping Agent Code" <> '') AND (NOT ShipAgt.GET(ShipLine."Shipping Agent Code")) THEN
                    ERROR('Shipping Agent Code does not exist in Shipping Agents.');
            'Package Tracking No.':
                SOHeader.VALIDATE(SOHeader."Package Tracking No.", ShipLine."Package Tracking No.");
        END;


    end;

    local procedure VlidateInvoice()
    var
        InvoiceLine: Record "Sales Invoice Import Line";
        InvoiceLine2: Record "Sales Invoice Import Line";
    begin
        CLEARLASTERROR;

        //InvoiceLine.GET(RecRef.FIELD(InvoiceLine.FIELDNO("Order No.")),RecRef.FIELD(InvoiceLine.FIELDNO("Posting Date")),
        //  RecRef.FIELD(InvoiceLine.FIELDNO("Line No.")));//Order No. & LINE NO.
        InvoiceLine.GET(RecRef.FIELD(InvoiceLine.FIELDNO("Entry No.")));

        IF NOT SOHeader.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.") THEN;
        IF NOT SOLine.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.", InvoiceLine."Line No.") THEN;

        IF SOHeader.Status <> SOHeader.Status::Open THEN
            ReleaseSalesDoc.PerformManualReopen(SOHeader);
        /*
        InvoiceLine2.RESET;
        InvoiceLine2.SETRANGE("Order No.", InvoiceLine."Order No.");
        InvoiceLine2.SETRANGE("Line No.", InvoiceLine."Line No.");
        InvoiceLine2.SETRANGE("Posting Date", InvoiceLine."Posting Date");
        InvoiceLine2.SETRANGE("Qty. to Invoice", InvoiceLine."Qty. to Invoice");
        InvoiceLine2.SETRANGE("Shipment Method Code", InvoiceLine."Shipment Method Code");
        InvoiceLine2.FINDSET();
        IF InvoiceLine2.COUNT > 1 THEN
          ERROR('The same data exists in "Document No", "Line No.", "Qty.to Ship", "Posting Date", and "Shipping Method Code”.');
        
        IF NOT SOHeader.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.") THEN
          ERROR('"Document No." does not exist.');
        
        IF NOT SOLine.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.",InvoiceLine."Line No.") THEN
          ERROR('Combination of "Document No." and "Line No." does not exist.');
        */
        CASE ColumnNMAE OF
            /*'Order No.':
                SOHeader.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.");
            'Line No.':
                SOLine.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.",InvoiceLine."Line No.");*/
            'Posting Date':
                SOHeader.VALIDATE(SOHeader."Posting Date", InvoiceLine."Posting Date");
            'Document Date':
                SOHeader.VALIDATE(SOHeader."Document Date", InvoiceLine."Document Date");
            'Customer No.':
                //SOHeader.VALIDATE(SOHeader."Sell-to Customer No.", InvoiceLine."Customer No.");
                IF SOHeader."Sell-to Customer No." <> InvoiceLine."Customer No." THEN
                    ERROR('Customer No. is wrong.');
            'Item No.':
                IF SOLine."No." <> InvoiceLine."Item No." THEN
                    ERROR('Item No. is wrong.');
            'Qty. to Invoice':
                IF SOLine."Qty. Shipped Not Invoiced" < InvoiceLine."Qty. to Invoice" THEN
                    ERROR('"Qty. to Invoice" is more than Qty. Shipped not Invoiced.')
                ELSE
                    SOLine.VALIDATE("Qty. to Invoice", InvoiceLine."Qty. to Invoice");
            'Shipment Method Code':
                //SOHeader.VALIDATE(SOHeader."Shipment Method Code", InvoiceLine."Shipment Method Code");
                IF (InvoiceLine."Shipment Method Code" <> '') AND (NOT ShipMethod.GET(InvoiceLine."Shipment Method Code")) THEN
                    ERROR('Shipment Method Code does not exist in Shipment Methods.');
            'Shipping Agent Code':
                //SOHeader.VALIDATE(SOHeader."Shipping Agent Code", InvoiceLine."Shipping Agent Code");
                IF (InvoiceLine."Shipping Agent Code" <> '') AND (NOT ShipAgt.GET(InvoiceLine."Shipping Agent Code")) THEN
                    ERROR('Shipping Agent Code does not exist in Shipping Agents.');
            'Package Tracking No.':
                SOHeader.VALIDATE(SOHeader."Package Tracking No.", InvoiceLine."Package Tracking No.");
            'Unit Price':
                IF SOLine."Unit Price" <> InvoiceLine."Unit Price" THEN
                    ERROR('"Unit Price" is wrong.');
            'Due Date':
                SOHeader.VALIDATE(SOHeader."Due Date", InvoiceLine."Due Date");
        END;

    end;

    local procedure VlidateShipInvoice()
    var
        InvoiceLine: Record "Sales Invoice Import Line";
        InvoiceLine2: Record "Sales Invoice Import Line";
    begin
        CLEARLASTERROR;

        //InvoiceLine.GET(RecRef.FIELD(InvoiceLine.FIELDNO("Order No.")),RecRef.FIELD(InvoiceLine.FIELDNO("Posting Date")),
        //  RecRef.FIELD(InvoiceLine.FIELDNO("Line No.")));//Order No. & LINE NO.
        InvoiceLine.GET(RecRef.FIELD(InvoiceLine.FIELDNO("Entry No.")));

        IF NOT SOHeader.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.") THEN;
        IF NOT SOLine.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.", InvoiceLine."Line No.") THEN;

        IF SOHeader.Status <> SOHeader.Status::Open THEN
            ReleaseSalesDoc.PerformManualReopen(SOHeader);
        /*
        InvoiceLine2.RESET;
        InvoiceLine2.SETRANGE("Order No.", InvoiceLine."Order No.");
        InvoiceLine2.SETRANGE("Line No.", InvoiceLine."Line No.");
        InvoiceLine2.SETRANGE("Posting Date", InvoiceLine."Posting Date");
        InvoiceLine2.SETRANGE("Qty. to Invoice", InvoiceLine."Qty. to Invoice");
        InvoiceLine2.SETRANGE("Shipment Method Code", InvoiceLine."Shipment Method Code");
        InvoiceLine2.FINDSET();
        IF InvoiceLine2.COUNT > 1 THEN
          ERROR('The same data exists in "Document No", "Line No.", "Qty.to Ship", "Posting Date", and "Shipping Method Code”.');
        
        IF NOT SOHeader.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.") THEN
          ERROR('"Document No." does not exist.');
        
        IF NOT SOLine.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.",InvoiceLine."Line No.") THEN
          ERROR('Combination of "Document No." and "Line No." does not exist.');
        */
        CASE ColumnNMAE OF
            /*'Order No.':
                SOHeader.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.");
            'Line No.':
                SOLine.GET(SOHeader."Document Type"::Order, InvoiceLine."Order No.",InvoiceLine."Line No.");*/
            'Posting Date':
                SOHeader.VALIDATE(SOHeader."Posting Date", InvoiceLine."Posting Date");
            'Document Date':
                SOHeader.VALIDATE(SOHeader."Document Date", InvoiceLine."Document Date");
            'Customer No.':
                //SOHeader.VALIDATE(SOHeader."Sell-to Customer No.", InvoiceLine."Customer No.");
                IF SOHeader."Sell-to Customer No." <> InvoiceLine."Customer No." THEN
                    ERROR('Customer No. is wrong.');
            'Item No.':
                IF SOLine."No." <> InvoiceLine."Item No." THEN
                    ERROR('Item No. is wrong.');
            'Qty. to Invoice':
                begin
                    //since Ship & Invoice will be done at the same time, 
                    //the check logic should be as same as Ship validate, not Invoice validate.
                    //then set the imported "Qty. to Invoice" to "Qty. to Ship".
                    IF SOLine."Outstanding Quantity" < InvoiceLine."Qty. to Invoice" THEN
                        ERROR('"Qty. to Ship" is more than "Outstanding Qty".')
                    ELSE
                        SOLine.VALIDATE("Qty. to Ship", InvoiceLine."Qty. to Invoice");
                end;
            'Shipment Method Code':
                //SOHeader.VALIDATE(SOHeader."Shipment Method Code", InvoiceLine."Shipment Method Code");
                IF (InvoiceLine."Shipment Method Code" <> '') AND (NOT ShipMethod.GET(InvoiceLine."Shipment Method Code")) THEN
                    ERROR('Shipment Method Code does not exist in Shipment Methods.');
            'Shipping Agent Code':
                //SOHeader.VALIDATE(SOHeader."Shipping Agent Code", InvoiceLine."Shipping Agent Code");
                IF (InvoiceLine."Shipping Agent Code" <> '') AND (NOT ShipAgt.GET(InvoiceLine."Shipping Agent Code")) THEN
                    ERROR('Shipping Agent Code does not exist in Shipping Agents.');
            'Package Tracking No.':
                SOHeader.VALIDATE(SOHeader."Package Tracking No.", InvoiceLine."Package Tracking No.");
            'Unit Price':
                IF SOLine."Unit Price" <> InvoiceLine."Unit Price" THEN
                    ERROR('"Unit Price" is wrong.');
            'Due Date':
                SOHeader.VALIDATE(SOHeader."Due Date", InvoiceLine."Due Date");
        END;

    end;
}

