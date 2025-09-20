report 50064 "SO Post Ship"
{
    // CS061 Leon 2023/09/08 - SO Post Upload (Salese Shipment/Invoice)

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(DataItem1120082000; "Sales Ship Import Line")
        {
            DataItemTableView = SORTING("Order No.", "Posting Date", "Document Date", "Shipment Method Code", "Shipping Agent Code", "Package Tracking No.", "Line No.")
                                WHERE(Status = FILTER(Processed | PostError));

            trigger OnAfterGetRecord()
            var
                TransType: Option Ship,Invoice;
                ErrMsg: Text;
                SOLine: Record "Sales Line";
                SOHeader: Record "Sales Header";
                SOPost: Codeunit "Sales-Post";
                ReleaseSalesDoc: Codeunit "Release Sales Document";
            begin
                CLEAR(ErrMsg);
                CLEARLASTERROR;

                //CurLineCount += 1;

                //Sort by Order No.,Posting Date,Document Date,Shipment Method Code,Shipping Agent Code,Package Tracking No.
                IF (PreviouslyOrdNo = "Order No.") AND (PSTDate = "Posting Date") AND (DocDate = "Document Date")
                AND (ShpMtd = "Shipment Method Code") AND (ShpAgt = "Shipping Agent Code")
                AND (PkgTrkNo = "Package Tracking No.") THEN // AND (CurLineCount < TotalLineCount)
                    CurrReport.SKIP();

                IF (PreviouslyOrdNo <> "Order No.") OR (PSTDate <> "Posting Date") OR (DocDate <> "Document Date")
                OR (ShpMtd <> "Shipment Method Code") OR (ShpAgt <> "Shipping Agent Code")
                OR (PkgTrkNo <> "Package Tracking No.") THEN BEGIN // OR (CurLineCount = TotalLineCount)
                    PreviouslyOrdNo := "Order No.";
                    PSTDate := "Posting Date";
                    DocDate := "Document Date";
                    ShpMtd := "Shipment Method Code";
                    ShpAgt := "Shipping Agent Code";
                    PkgTrkNo := "Package Tracking No.";

                    SOHeader.GET(SOHeader."Document Type"::Order, "Order No.");//PreviouslyOrdNo);

                    IF SOHeader.Status <> SOHeader.Status::Open THEN
                        ReleaseSalesDoc.PerformManualReopen(SOHeader);

                    //Process in the 1st ship line to Update all the order line QTY = 0, THEN ship line qty = qty. to ship
                    SOLine.RESET;
                    SOLine.SETRANGE("Document Type", SOLine."Document Type"::Order);
                    SOLine.SETRANGE("Document No.", "Order No.");
                    IF SOLine.FIND('-') THEN
                        REPEAT
                            SOLine.VALIDATE("Qty. to Ship", 0);
                            SOLine.VALIDATE("Qty. to Invoice", 0);
                            SOLine.MODIFY();
                        UNTIL SOLine.NEXT() = 0;
                    //==================================================================
                    SOShipLine.RESET;
                    SOShipLine.SETRANGE("Order No.", "Order No.");
                    SOShipLine.SETRANGE("Posting Date", "Posting Date");
                    SOShipLine.SETRANGE("Document Date", "Document Date");
                    SOShipLine.SETRANGE("Shipment Method Code", "Shipment Method Code");
                    SOShipLine.SETRANGE("Shipping Agent Code", "Shipping Agent Code");
                    SOShipLine.SETRANGE("Package Tracking No.", "Package Tracking No.");
                    IF SOShipLine.FIND('-') THEN
                        REPEAT
                            SOLine.RESET;
                            SOLine.SETRANGE("Document Type", SOLine."Document Type"::Order);
                            SOLine.SETRANGE("Document No.", SOShipLine."Order No.");
                            SOLine.SETRANGE("Line No.", SOShipLine."Line No.");
                            IF SOLine.FIND('-') THEN BEGIN
                                SOLine.VALIDATE("Qty. to Ship", SOShipLine."Qty. to Ship");

                                SOLine.MODIFY();
                            END;
                        UNTIL SOShipLine.NEXT() = 0;
                    //Process in the 1st ship line to Update all the order line QTY = 0, THEN ship line qty = qty. to ship

                    SOHeader.VALIDATE("Posting Date", "Posting Date");
                    SOHeader.VALIDATE("Document Date", "Document Date");
                    SOHeader.VALIDATE("Shipment Method Code", "Shipment Method Code");
                    SOHeader.VALIDATE("Shipping Agent Code", "Shipping Agent Code");
                    SOHeader.VALIDATE("Package Tracking No.", "Package Tracking No.");
                    SOHeader.MODIFY();

                    COMMIT;

                    SOHeader.Ship := TRUE;
                    SOHeader.Invoice := FALSE; //Post Only for Shipment

                    IF NOT SOPost.RUN(SOHeader) THEN begin
                        ErrMsg := GETLASTERRORTEXT;
                        IsError := true;
                    end;

                    //SOShipLine.RESET;
                    //SOShipLine.SETRANGE("Order No.", PreviouslyOrdNo);
                    IF SOShipLine.FIND('-') THEN
                        REPEAT
                            IF ErrMsg <> '' THEN BEGIN
                                SOShipLine."Error Description" := ErrMsg;
                                SOShipLine.Status := SOShipLine.Status::PostError;
                            END
                            ELSE BEGIN
                                SOShipLine.Status := SOShipLine.Status::OK;
                                SOShipLine."Error Description" := '';
                            END;

                            SOShipLine.MODIFY();
                        UNTIL SOShipLine.NEXT() = 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                //TotalLineCount := "Sales Ship Import Line".COUNT;
                //CurLineCount := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if IsError then begin
            MESSAGE('Posting Error.');
        end else begin
            MESSAGE('Posting Done.');
        end;
    end;

    trigger OnPreReport()
    begin
        CLEAR(PreviouslyOrdNo);
        CLEAR(PSTDate);
        CLEAR(DocDate);
        CLEAR(ShpMtd);
        CLEAR(ShpAgt);
        CLEAR(PkgTrkNo);
    end;

    var
        PreviouslyOrdNo: Text;
        SOShipLine: Record "Sales Ship Import Line";
        PSTDate: Date;
        ShpMtd: Code[20];
        ShpAgt: Code[10];
        PkgTrkNo: Text;
        CurLineCount: Integer;
        TotalLineCount: Integer;
        DocDate: Date;
        IsError: Boolean;
}

