report 50082 "PO Post Invoice"
{
    // CS023 Kenya 2021/07/28 - Roll-out Renesas Receipt/Invoice Upload
    // CS079 Shawn 2024/06/01 - Check and Logic Change. (CO No. => PO No.+Line No. as well)

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Purch. Receipt Import Staging1"; "Purch. Receipt Import Staging")
        {
            DataItemTableView = SORTING("Proforma Invoice", "Batch No.", "Entry No.")
                                ORDER(Ascending)
                                WHERE(Received = FILTER(true),
                                      "Proforma Invoice" = FILTER(<> ''),
                                      Status = FILTER(Processed));
            dataitem("Purch. Receipt Import Staging"; "Purch. Receipt Import Staging")
            {
                DataItemLink = "Proforma Invoice" = FIELD("Proforma Invoice");
                DataItemTableView = SORTING("Batch No.", "Entry No.")
                                    ORDER(Ascending)
                                    WHERE(Received = FILTER(true),
                                          Posted = FILTER(false),
                                          Status = FILTER(Processed));

                trigger OnAfterGetRecord()
                var
                    PurchFound: Boolean;
                begin
                    PurchFound := FALSE;  //CS023
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE("Document No.", "Purch. Receipt Import Staging"."PO No.");
                    PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                    //PurchaseLine.SETRANGE("CO No.","Purch. Receipt Import Staging"."CO No.");//CS079
                    //CS079 Begin
                    IF ("Purch. Receipt Import Staging"."PO No." <> '') AND ("Purch. Receipt Import Staging"."Line No." <> 0) THEN BEGIN
                        PurchaseLine.SETRANGE("Line No.", "Purch. Receipt Import Staging"."Line No.");
                    END ELSE BEGIN
                        PurchaseLine.SETRANGE("CO No.", "Purch. Receipt Import Staging"."CO No.");
                    END;
                    //CS079 End
                    //CS023 Begin
                    PurchaseLine.SETCURRENTKEY("Quantity Received");
                    PurchaseLine.SETASCENDING("Quantity Received", TRUE);
                    //IF PurchaseLine.FINDFIRST THEN BEGIN
                    IF PurchaseLine.FINDSET THEN BEGIN
                        REPEAT
                            IF NOT (PurchFound) AND
                               (PurchaseLine."Quantity Received" >= "Purch. Receipt Import Staging"."Qty. To Invoice") AND
                               ((PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced") >= "Purch. Receipt Import Staging"."Qty. To Invoice") THEN BEGIN
                                PurchaseLine."Goods Arrival Date" := "Purch. Receipt Import Staging"."Arrival Date";
                                PurchaseLine.VALIDATE("Qty. to Invoice", "Purch. Receipt Import Staging"."Qty. To Invoice");//sp
                                PurchaseLine.MODIFY;
                                PurchFound := TRUE;
                            END;
                        UNTIL PurchaseLine.NEXT = 0;
                    END;
                    //CS023 End
                end;

                trigger OnPostDataItem()
                var
                    ErrMsg: Text;
                begin
                    CLEAR(ErrMsg);
                    CLEARLASTERROR;

                    //IF DIALOG.CONFIRM('Do You Want To Receive And Invoice', TRUE) THEN BEGIN
                    PurchaseHeader.RESET;
                    CLEAR(PurchPost);
                    if PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, "Purch. Receipt Import Staging"."PO No.") then begin
                        //PurchaseHeader.Receive :=TRUE;
                        PurchaseHeader.Invoice := TRUE;
                        PurchaseHeader."Posting No." := '';//22.05.2020
                        //PurchaseHeader."Posting Date" :=TODAY;
                        PurchaseHeader.VALIDATE("Posting Date", "Purch. Receipt Import Staging"."Closed Date");
                        PurchaseHeader.VALIDATE("Document Date", "Purch. Receipt Import Staging"."Arrival Date");
                        PurchaseHeader.VALIDATE("Vendor Invoice No.", "Purch. Receipt Import Staging"."Proforma Invoice");
                        PurchaseHeader.MODIFY;
                        //110220


                        //110220

                        // BC Upgrade
                        Commit();

                        PurchaseHeader2.RESET;
                        PurchaseHeader2.GET(PurchaseHeader."Document Type"::Order, "Purch. Receipt Import Staging"."PO No.");
                        //PurchaseHeader2.SETRANGE("Vendor Invoice No.",PurchaseHeader."Vendor Invoice No.");
                        //PurchPost.RUN(PurchaseHeader2); // BC Upgrade

                        if not PurchPost.RUN(PurchaseHeader2) then begin

                            ErrMsg := GETLASTERRORTEXT;
                            IsError := true;

                        end;
                        // BC Upgrade

                        // BC Upgrade
                        /*
                        PurchReceiptImportStaging.RESET;
                        PurchReceiptImportStaging.SETRANGE("PO No.", "Purch. Receipt Import Staging"."PO No.");
                        PurchReceiptImportStaging.SETRANGE("Proforma Invoice", "Purch. Receipt Import Staging"."Proforma Invoice");
                        //PurchReceiptImportStaging.SETRANGE("CO No.","Purch. Receipt Import Staging"."CO No.");

                        IF PurchReceiptImportStaging.FINDSET THEN BEGIN
                            REPEAT
                                //PurchReceiptImportStaging.Posted := TRUE;
                                //PurchReceiptImportStaging.MODIFY;
                                PurchReceiptImportStaging.DELETE;
                            UNTIL PurchReceiptImportStaging.NEXT = 0;
                        END
                        */

                        // BC Upgrade
                        PurchReceiptImportStaging.RESET;
                        PurchReceiptImportStaging.SETRANGE("PO No.", "Purch. Receipt Import Staging"."PO No.");
                        IF PurchReceiptImportStaging.FindSet() THEN
                            REPEAT
                                IF IsError THEN BEGIN
                                    if ErrMsg = '' then
                                        ErrMsg := 'Error detail can not be shown, please check your setup or data.';
                                    PurchReceiptImportStaging."Error Description" := ErrMsg;
                                    PurchReceiptImportStaging.Status := PurchReceiptImportStaging.Status::PostError;
                                END
                                ELSE BEGIN
                                    PurchReceiptImportStaging.Status := PurchReceiptImportStaging.Status::OK;
                                    PurchReceiptImportStaging."Error Description" := '';
                                END;

                                PurchReceiptImportStaging.MODIFY();
                            UNTIL PurchReceiptImportStaging.NEXT() = 0;

                        // BC Upgrade

                        // MESSAGE('Invoiced Sucessfully');
                    END

                    ELSE
                        EXIT;
                    //END;
                    // MESSAGE('Invoiced Sucessfully');
                end;
            }
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

    var
        PurchPost: Codeunit "Purch.-Post";
        PurchaseHeader: Record "Purchase Header";
        PurchReceiptImportStaging: Record "Purch. Receipt Import Staging";
        PurchaseHeader2: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        IsError: Boolean;
}

