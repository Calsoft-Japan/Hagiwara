report 50065 "SO Post Invoice"
{
    // CS061 Leon 2023/09/08 - SO Post Upload (Salese Shipment/Invoice)

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(DataItem1120082000; "Sales Invoice Import Line")
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

                //Sort by Order No.,Posting Date,Document Date,Shipment Method Code,Shipping Agent Code,Package Tracking No.
                IF (PreviouslyOrdNo = "Order No.") AND (PSTDate = "Posting Date") AND (DocDate = "Document Date")
                AND (ShpMtd = "Shipment Method Code") AND (ShpAgt = "Shipping Agent Code")
                AND (PkgTrkNo = "Package Tracking No.") THEN
                    CurrReport.SKIP();

                IF (PreviouslyOrdNo <> "Order No.") OR (PSTDate <> "Posting Date") OR (DocDate <> "Document Date")
                OR (ShpMtd <> "Shipment Method Code") OR (ShpAgt <> "Shipping Agent Code")
                OR (PkgTrkNo <> "Package Tracking No.") THEN BEGIN
                    PreviouslyOrdNo := "Order No.";
                    PSTDate := "Posting Date";
                    DocDate := "Document Date";
                    ShpMtd := "Shipment Method Code";
                    ShpAgt := "Shipping Agent Code";
                    PkgTrkNo := "Package Tracking No.";

                    SOHeader.GET(SOHeader."Document Type"::Order, "Order No.");

                    IF SOHeader.Status <> SOHeader.Status::Open THEN
                        ReleaseSalesDoc.PerformManualReopen(SOHeader);

                    SOLine.RESET;
                    SOLine.SETRANGE("Document Type", SOLine."Document Type"::Order);
                    SOLine.SETRANGE("Document No.", "Order No.");
                    IF SOLine.FIND('-') THEN
                        REPEAT
                            SOLine.VALIDATE("Qty. to Ship", 0);
                            SOLine.VALIDATE("Qty. to Invoice", 0);
                            SOLine.MODIFY();
                        UNTIL SOLine.NEXT() = 0;

                    SOINVLine.RESET;
                    SOINVLine.SETRANGE("Order No.", "Order No.");
                    SOINVLine.SETRANGE("Posting Date", "Posting Date");
                    SOINVLine.SETRANGE("Document Date", "Document Date");
                    SOINVLine.SETRANGE("Shipment Method Code", "Shipment Method Code");
                    SOINVLine.SETRANGE("Shipping Agent Code", "Shipping Agent Code");
                    SOINVLine.SETRANGE("Package Tracking No.", "Package Tracking No.");
                    IF SOINVLine.FIND('-') THEN
                        REPEAT
                            SOLine.RESET;
                            SOLine.SETRANGE("Document Type", SOLine."Document Type"::Order);
                            SOLine.SETRANGE("Document No.", SOINVLine."Order No.");
                            SOLine.SETRANGE("Line No.", SOINVLine."Line No.");
                            IF SOLine.FIND('-') THEN BEGIN
                                SOLine.VALIDATE("Unit Price", SOINVLine."Unit Price");
                                SOLine.VALIDATE("Qty. to Invoice", SOINVLine."Qty. to Invoice");

                                SOLine.MODIFY();
                            END;
                        UNTIL SOINVLine.NEXT() = 0;

                    SOHeader.VALIDATE("Posting Date", "Posting Date");
                    SOHeader.VALIDATE("Document Date", "Document Date");
                    SOHeader.VALIDATE("Shipment Method Code", "Shipment Method Code");
                    SOHeader.VALIDATE("Shipping Agent Code", "Shipping Agent Code");
                    SOHeader.VALIDATE("Package Tracking No.", "Package Tracking No.");
                    SOHeader.VALIDATE("Due Date", "Due Date");
                    SOHeader.MODIFY();

                    COMMIT;

                    SOHeader.Ship := FALSE;
                    SOHeader.Invoice := TRUE; //Post Only for Invoice

                    IF NOT SOPost.RUN(SOHeader) THEN
                        ErrMsg := GETLASTERRORTEXT;

                    //SOINVLine.RESET;
                    //SOINVLine.SETRANGE("Order No.", PreviouslyOrdNo);
                    IF SOINVLine.FIND('-') THEN
                        REPEAT
                            IF ErrMsg <> '' THEN BEGIN
                                SOINVLine."Error Description" := ErrMsg;
                                SOINVLine.Status := SOINVLine.Status::PostError;
                            END
                            ELSE BEGIN
                                SOINVLine.Status := SOINVLine.Status::OK;
                                SOINVLine."Error Description" := '';
                            END;

                            SOINVLine.MODIFY();
                        UNTIL SOINVLine.NEXT() = 0;
                END;
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
        MESSAGE('Posting Done.');
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
        SOINVLine: Record "Sales Invoice Import Line";
        PSTDate: Date;
        DocDate: Date;
        ShpMtd: Code[20];
        ShpAgt: Code[10];
        PkgTrkNo: Text;
}

