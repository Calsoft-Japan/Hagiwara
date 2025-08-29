report 50087 "PO Post Receive"
{
    // CS054 Kenya 2023/05/28 - Change to Set Quantity to Receive at Receive
    // CS079 Shawn 2024/06/01 - Check and Logic Change. (CO No. => PO No.+Line No. as well)
    // CS095 Kenya 2025/02/06 - Add Unit Cost in Import File

    ProcessingOnly = true;

    dataset
    {
        dataitem("Purch. Receipt Import Staging"; "Purch. Receipt Import Staging")
        {
            DataItemTableView = SORTING("Batch No.", "Entry No.")
                                ORDER(Ascending)
                                WHERE(Received = FILTER(false));

            trigger OnAfterGetRecord()
            var
                PurchFound: Boolean;
                PurchaseLine: Record "Purchase Line";
            begin
                //IF DIALOG.CONFIRM('Do You Want To Receive', TRUE) THEN BEGIN

                //CS054 Begin
                PurchReceiptImportStaging2.RESET;
                PurchReceiptImportStaging2.SETRANGE("PO No.", "PO No.");
                IF PurchReceiptImportStaging2.FINDSET THEN BEGIN
                    REPEAT
                        PurchFound := FALSE;
                        PurchaseLine.RESET;
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                        //PurchaseLine.SETRANGE("CO No.",PurchReceiptImportStaging2."CO No.");//CS079
                        //CS079 Begin
                        IF (PurchReceiptImportStaging2."PO No." <> '') AND (PurchReceiptImportStaging2."Line No." <> 0) THEN BEGIN
                            PurchaseLine.SETRANGE("Document No.", PurchReceiptImportStaging2."PO No."); //Naoto Fixed
                            PurchaseLine.SETRANGE("Line No.", PurchReceiptImportStaging2."Line No.");
                        END ELSE BEGIN
                            PurchaseLine.SETRANGE("CO No.", PurchReceiptImportStaging2."CO No.");
                        END;
                        //CS079 End
                        PurchaseLine.SETCURRENTKEY("Outstanding Quantity");
                        PurchaseLine.SETASCENDING("Outstanding Quantity", TRUE);
                        IF PurchaseLine.FINDSET THEN BEGIN
                            REPEAT
                                IF NOT (PurchFound) AND (PurchaseLine."Outstanding Quantity" >= PurchReceiptImportStaging2."Received Qty.") THEN BEGIN
                                    PurchaseLine."Goods Arrival Date" := PurchReceiptImportStaging2."Arrival Date";
                                    PurchaseLine.VALIDATE("Qty. to Receive", PurchReceiptImportStaging2."Received Qty.");
                                    IF PurchReceiptImportStaging2."Unit Cost" > 0 THEN //CS095
                                        PurchaseLine.VALIDATE("Direct Unit Cost", PurchReceiptImportStaging2."Unit Cost"); //CS095
                                    PurchaseLine.MODIFY;
                                    PurchFound := TRUE;
                                END;
                            UNTIL PurchaseLine.NEXT = 0;
                        END;
                    UNTIL PurchReceiptImportStaging2.NEXT = 0;
                END;
                //CS054 End

                PurchaseHeader.RESET;
                CLEAR(PurchPost);
                PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, "PO No.");
                IF PurchaseHeader.FIND THEN BEGIN
                    PurchaseHeader.Invoice := FALSE;
                    PurchaseHeader.Receive := TRUE;
                    PurchaseHeader."Posting Date" := TODAY;
                    PurchaseHeader.VALIDATE("Document Date", PurchaseHeader."Goods Arrival Date");
                    PurchaseHeader.VALIDATE("Vendor Invoice No.", '');

                    //PurchaseHeader.Invoice :=TRUE;
                    PurchaseHeader.MODIFY;
                    PurchaseHeader2.RESET;
                    PurchaseHeader2.GET(PurchaseHeader."Document Type"::Order, "PO No.");
                    PurchPost.RUN(PurchaseHeader2);
                    //PurchPost.RUN(PurchaseHeader);

                    PurchReceiptImportStaging.RESET;
                    PurchReceiptImportStaging.SETRANGE("PO No.", "PO No.");
                    IF PurchReceiptImportStaging.FINDSET THEN BEGIN
                        REPEAT
                            PurchReceiptImportStaging.Received := TRUE;
                            //PurchReceiptImportStaging.MODIFY;
                            PurchReceiptImportStaging.DELETE;
                        UNTIL PurchReceiptImportStaging.NEXT = 0;

                    END
                END
                ELSE
                    EXIT;
                // END;
                // MESSAGE('Recevied Sucessfully');
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

    var
        PurchPost: Codeunit "Purch.-Post";
        PurchaseHeader: Record "Purchase Header";
        PurchReceiptImportStaging: Record "Purch. Receipt Import Staging";
        PurchaseHeader2: Record "Purchase Header";
        PurchReceiptImportStaging2: Record "Purch. Receipt Import Staging";
}

