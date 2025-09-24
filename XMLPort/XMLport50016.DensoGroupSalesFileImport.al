xmlport 50016 "Denso Group Sales File Import"
{
    // HG10.00.03 NJ 26/12/2017 - New XMLPort Created
    // HG10.00.06 NJ 12/03/2018 - Added code to created different sales order for different customer order no.
    // HG10.00.11 NJ 16/04/2018 - Added check whether there are same DO No. is existing or not
    // CS092 FDD IE021 Channing.Zhou 8/7/2025 - upgrade to BC version

    Caption = 'TRMI Sales Import';
    Direction = Import;
    Format = VariableText;
    TableSeparator = '<<NewLine><NewLine>>';
    UseRequestPage = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Sales File Import Buffer"; "Sales File Import Buffer")
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'SalesFileImportBuffer';
                UseTemporary = true;
                fieldelement(A; "Sales File Import Buffer"."Supplier Code")
                {
                }
                fieldelement(B; "Sales File Import Buffer"."Buyer Part Number")
                {
                }
                fieldelement(C; "Sales File Import Buffer"."Buyer Part Description")
                {
                }
                fieldelement(D; "Sales File Import Buffer"."Supplier Part Number")
                {
                }
                fieldelement(E; "Sales File Import Buffer"."Supplier Part Description")
                {
                }
                fieldelement(F; "Sales File Import Buffer".UOM)
                {
                }
                fieldelement(G; "Sales File Import Buffer"."Delivery Order")
                {
                }
                fieldelement(H; "Sales File Import Buffer".Urgent)
                {
                }
                fieldelement(I; "Sales File Import Buffer"."Purchase Order Number")
                {
                }
                fieldelement(J; "Sales File Import Buffer"."Ship To")
                {
                }
                fieldelement(K; "Sales File Import Buffer"."Ship Date")
                {
                }
                fieldelement(L; "Sales File Import Buffer"."Ship Time")
                {
                }
                fieldelement(M; "Sales File Import Buffer"."Due Date")
                {
                }
                fieldelement(N; "Sales File Import Buffer"."Due Time")
                {
                }
                fieldelement(O; "Sales File Import Buffer"."D.A.R Date")
                {
                }
                fieldelement(P; "Sales File Import Buffer"."Qty Due")
                {
                }
                fieldelement(Q; "Sales File Import Buffer"."D.A.R Qty")
                {
                }
                fieldelement(R; "Sales File Import Buffer"."Change From Last")
                {
                }
                fieldelement(S; "Sales File Import Buffer"."Qty Shipped to Date")
                {
                }
                fieldelement(T; "Sales File Import Buffer"."Net Due")
                {
                }
                fieldelement(U; "Sales File Import Buffer"."Dock No")
                {
                }
                fieldelement(V; "Sales File Import Buffer".Warehouse)
                {
                }
                fieldelement(W; "Sales File Import Buffer".Status)
                {
                }
                fieldelement(X; "Sales File Import Buffer"."Date Type")
                {
                }
                fieldelement(Y; "Sales File Import Buffer".Route)
                {
                }
                fieldelement(Z; "Sales File Import Buffer"."Special Instructions")
                {
                }
                fieldelement(AA; "Sales File Import Buffer"."Buyer/Planner Name")
                {
                }
                fieldelement(AB; "Sales File Import Buffer"."Planner Phone")
                {
                }
                fieldelement(AC; "Sales File Import Buffer"."Units per Box")
                {
                }
                fieldelement(AD; "Sales File Import Buffer"."Units per Pallet")
                {
                }
                fieldelement(AE; "Sales File Import Buffer"."Creation Date")
                {
                }
                fieldelement(AF; "Sales File Import Buffer"."Horizon Start Date")
                {
                }
                fieldelement(AG; "Sales File Import Buffer"."Horizon End Date")
                {
                }
                fieldelement(AH; "Sales File Import Buffer"."Range Minimum")
                {
                }
                fieldelement(AI; "Sales File Import Buffer"."Range Maximum")
                {
                }
                fieldelement(AJ; "Sales File Import Buffer"."A Part")
                {
                }
                fieldelement(AK; "Sales File Import Buffer"."Tag Slip Remark #1")
                {
                }
                fieldelement(AL; "Sales File Import Buffer"."Tag Slip Remark #2")
                {
                }
                fieldelement(AM; "Sales File Import Buffer"."Tag Slip Remark #3")
                {
                }
                fieldelement(AN; "Sales File Import Buffer"."Schedule Issuer Name")
                {
                }
                fieldelement(AO; "Sales File Import Buffer"."Schedule Issuer Address 1")
                {
                }
                fieldelement(AP; "Sales File Import Buffer"."Schedule Issuer Address 2")
                {
                }
                fieldelement(AQ; "Sales File Import Buffer"."Schedule Issuer Address 3")
                {
                }
                fieldelement(AR; "Sales File Import Buffer"."Schedule Type")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    ImportCounter := ImportCounter + 1;
                    InsertDataInTemp;
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

    trigger OnPostXmlPort()
    var
        RecItem: Record Item;
    begin
        ImportCounter := 0;
        RecTEMPSalesFileImportBuffer.RESET;
        //HG10.00.06 NJ 12/03/2018 -->
        //TEMPSalesFileImportBuffer.SETCURRENTKEY(Status,"Ship To");
        RecTEMPSalesFileImportBuffer.SETCURRENTKEY(Status, "Ship To", "Delivery Order");
        RecTEMPSalesFileImportBuffer.SETRANGE(Status, RecTEMPSalesFileImportBuffer.Status::Planned);
        //HG10.00.06 NJ 12/03/2018 <--
        IF RecTEMPSalesFileImportBuffer.FINDSET THEN BEGIN
            REPEAT

                IF (Status <> RecTEMPSalesFileImportBuffer.Status) OR (ShipTo <> RecTEMPSalesFileImportBuffer."Ship To") OR (SalesHeaderCreated = false) THEN BEGIN
                    Status := RecTEMPSalesFileImportBuffer.Status;
                    ShipTo := RecTEMPSalesFileImportBuffer."Ship To";
                    SalesHeaderCreated := FALSE;
                    LineNo := 0;
                    IF CreateSalesHeader(RecItem) THEN
                        SalesHeaderCreated := TRUE;
                END;

                IF SalesHeaderCreated THEN begin
                    CreateSalesLine(RecItem);
                end
                ELSE begin
                    //InsertDataInBuffer(ErrorMsg);
                end;

            UNTIL RecTEMPSalesFileImportBuffer.NEXT = 0;

        END;

        //HG10.00.06 NJ 12/03/2018 -->
        RecTEMPSalesFileImportBuffer.SETRANGE(Status, RecTEMPSalesFileImportBuffer.Status::Firm);
        IF RecTEMPSalesFileImportBuffer.FINDSET THEN BEGIN
            REPEAT

                IF (Status <> RecTEMPSalesFileImportBuffer.Status) OR (ShipTo <> RecTEMPSalesFileImportBuffer."Ship To") OR (DeliveryOrder <> RecTEMPSalesFileImportBuffer."Delivery Order") OR (SalesHeaderCreated = false) THEN BEGIN
                    Status := RecTEMPSalesFileImportBuffer.Status;
                    ShipTo := RecTEMPSalesFileImportBuffer."Ship To";
                    DeliveryOrder := RecTEMPSalesFileImportBuffer."Delivery Order";
                    SalesHeaderCreated := FALSE;
                    LineNo := 0;

                    IF CreateSalesHeader(RecItem) THEN
                        SalesHeaderCreated := TRUE;
                END;

                IF SalesHeaderCreated THEN begin
                    CreateSalesLine(RecItem);
                end
                ELSE begin
                    //InsertDataInBuffer(ErrorMsg);
                end;

            UNTIL RecTEMPSalesFileImportBuffer.NEXT = 0;

        END;
        //HG10.00.06 NJ 12/03/2018 <--

        RecTEMPSalesFileImportBuffer.DELETEALL;

        //PAGE.RUN(PAGE::"Denso Gr Sales File Imp Errors");
    end;

    var
        ImportCounter: Integer;
        RecTEMPSalesFileImportBuffer: Record "Sales File Import Buffer" temporary;
        RecSalesHeader: Record "Sales Header";
        RecSalesLine: Record "Sales Line";
        LineNo: Integer;
        Status: Integer;
        ShipTo: Code[20];
        SalesHeaderCreated: Boolean;
        ErrorMsg: Text[100];
        DeliveryOrder: Code[35];
        Text001: Label 'DO No. %1 already exists. Do you want to add this DO?';
        SameDOAnswer: Boolean;

    local procedure InsertDataInTemp()
    var
    //FileManagement: Codeunit 419;
    begin
        RecTEMPSalesFileImportBuffer.INIT;
        RecTEMPSalesFileImportBuffer."Entry No." := ImportCounter;
        RecTEMPSalesFileImportBuffer."Supplier Code" := "Sales File Import Buffer"."Supplier Code";
        RecTEMPSalesFileImportBuffer."Buyer Part Number" := "Sales File Import Buffer"."Buyer Part Number";
        RecTEMPSalesFileImportBuffer."Buyer Part Description" := "Sales File Import Buffer"."Buyer Part Description";
        RecTEMPSalesFileImportBuffer."Supplier Part Number" := "Sales File Import Buffer"."Supplier Part Number";
        RecTEMPSalesFileImportBuffer."Supplier Part Description" := "Sales File Import Buffer"."Supplier Part Description";
        RecTEMPSalesFileImportBuffer.UOM := "Sales File Import Buffer".UOM;
        RecTEMPSalesFileImportBuffer."Delivery Order" := "Sales File Import Buffer"."Delivery Order";
        RecTEMPSalesFileImportBuffer.Urgent := "Sales File Import Buffer".Urgent;
        RecTEMPSalesFileImportBuffer."Purchase Order Number" := "Sales File Import Buffer"."Purchase Order Number";
        RecTEMPSalesFileImportBuffer."Ship To" := "Sales File Import Buffer"."Ship To";
        RecTEMPSalesFileImportBuffer."Ship Date" := "Sales File Import Buffer"."Ship Date";
        RecTEMPSalesFileImportBuffer."Ship Time" := "Sales File Import Buffer"."Ship Time";
        RecTEMPSalesFileImportBuffer."Due Date" := "Sales File Import Buffer"."Due Date";
        RecTEMPSalesFileImportBuffer."Due Time" := "Sales File Import Buffer"."Due Time";
        RecTEMPSalesFileImportBuffer."D.A.R Date" := "Sales File Import Buffer"."D.A.R Date";
        RecTEMPSalesFileImportBuffer."Qty Due" := "Sales File Import Buffer"."Qty Due";
        RecTEMPSalesFileImportBuffer."D.A.R Qty" := "Sales File Import Buffer"."D.A.R Qty";
        RecTEMPSalesFileImportBuffer."Change From Last" := "Sales File Import Buffer"."Change From Last";
        RecTEMPSalesFileImportBuffer."Qty Shipped to Date" := "Sales File Import Buffer"."Qty Shipped to Date";
        RecTEMPSalesFileImportBuffer."Net Due" := "Sales File Import Buffer"."Net Due";
        RecTEMPSalesFileImportBuffer."Dock No" := "Sales File Import Buffer"."Dock No";
        RecTEMPSalesFileImportBuffer.Warehouse := "Sales File Import Buffer".Warehouse;
        RecTEMPSalesFileImportBuffer.Status := "Sales File Import Buffer".Status;
        RecTEMPSalesFileImportBuffer."Date Type" := "Sales File Import Buffer"."Date Type";
        RecTEMPSalesFileImportBuffer.Route := "Sales File Import Buffer".Route;
        RecTEMPSalesFileImportBuffer."Special Instructions" := "Sales File Import Buffer"."Special Instructions";
        RecTEMPSalesFileImportBuffer."Buyer/Planner Name" := "Sales File Import Buffer"."Buyer/Planner Name";
        RecTEMPSalesFileImportBuffer."Planner Phone" := "Sales File Import Buffer"."Planner Phone";
        RecTEMPSalesFileImportBuffer."Units per Box" := "Sales File Import Buffer"."Units per Box";
        RecTEMPSalesFileImportBuffer."Units per Pallet" := "Sales File Import Buffer"."Units per Pallet";
        RecTEMPSalesFileImportBuffer."Creation Date" := "Sales File Import Buffer"."Creation Date";
        RecTEMPSalesFileImportBuffer."Horizon Start Date" := "Sales File Import Buffer"."Horizon Start Date";
        RecTEMPSalesFileImportBuffer."Horizon End Date" := "Sales File Import Buffer"."Horizon End Date";
        RecTEMPSalesFileImportBuffer."Range Minimum" := "Sales File Import Buffer"."Range Minimum";
        RecTEMPSalesFileImportBuffer."Range Maximum" := "Sales File Import Buffer"."Range Maximum";
        RecTEMPSalesFileImportBuffer."A Part" := "Sales File Import Buffer"."A Part";
        RecTEMPSalesFileImportBuffer."Tag Slip Remark #1" := "Sales File Import Buffer"."Tag Slip Remark #1";
        RecTEMPSalesFileImportBuffer."Tag Slip Remark #2" := "Sales File Import Buffer"."Tag Slip Remark #2";
        RecTEMPSalesFileImportBuffer."Tag Slip Remark #3" := "Sales File Import Buffer"."Tag Slip Remark #3";
        RecTEMPSalesFileImportBuffer."Schedule Issuer Name" := "Sales File Import Buffer"."Schedule Issuer Name";
        RecTEMPSalesFileImportBuffer."Schedule Issuer Address 1" := "Sales File Import Buffer"."Schedule Issuer Address 1";
        RecTEMPSalesFileImportBuffer."Schedule Issuer Address 2" := "Sales File Import Buffer"."Schedule Issuer Address 2";
        RecTEMPSalesFileImportBuffer."Schedule Issuer Address 3" := "Sales File Import Buffer"."Schedule Issuer Address 3";
        RecTEMPSalesFileImportBuffer."Schedule Type" := "Sales File Import Buffer"."Schedule Type";
        //RecTEMPSalesFileImportBuffer."File Name" := FileManagement.GetFileName(currXMLport.FILENAME);
        RecTEMPSalesFileImportBuffer."File Name" := currXMLport.FILENAME;
        RecTEMPSalesFileImportBuffer."Row No." := ImportCounter;
        RecTEMPSalesFileImportBuffer.INSERT;
    end;

    local procedure InsertDataInBuffer(ErrorDesc: Text)
    var
        RecSalesFileImportBuffer: Record "Sales File Import Buffer";
        entryNo: Integer;
    begin
        RecSalesFileImportBuffer.Reset();
        if RecSalesFileImportBuffer.FindLast() then begin
            entryNo := RecSalesFileImportBuffer."Entry No.";
        end
        else begin
            entryNo := 0;
        end;
        entryNo += 1;
        RecSalesFileImportBuffer.INIT;
        RecSalesFileImportBuffer := RecTEMPSalesFileImportBuffer;
        RecSalesFileImportBuffer."Entry No." := entryNo;
        RecSalesFileImportBuffer."Error Description" := ErrorDesc;
        RecSalesFileImportBuffer."Date Imported" := TODAY;
        RecSalesFileImportBuffer."User ID Imported" := USERID;
        RecSalesFileImportBuffer."Denso Group" := TRUE;
        RecSalesFileImportBuffer.INSERT(TRUE);
    end;

    local procedure CreateSalesHeader(var RecItem: Record Item): Boolean
    var
        RecCustomer: Record Customer;
        SalesHeaderError: Boolean;
    begin

        RecCustomer.SETRANGE("Import File Ship To", RecTEMPSalesFileImportBuffer."Ship To");
        IF NOT RecCustomer.FINDFIRST THEN BEGIN
            ErrorMsg := 'Customer Not Found';
            InsertDataInBuffer(ErrorMsg);
            EXIT(FALSE);
        END;

        RecItem.Reset();
        RecItem.SETRANGE("Customer No.", RecCustomer."No.");
        RecItem.SETRANGE("Customer Item No.", RecTEMPSalesFileImportBuffer."Buyer Part Number");
        IF NOT RecItem.FINDFIRST THEN BEGIN
            ErrorMsg := 'Item Not Found';
            InsertDataInBuffer(ErrorMsg);
            EXIT(FALSE);
        END;

        IF RecTEMPSalesFileImportBuffer."Qty Due" = 0 THEN BEGIN
            ErrorMsg := 'Qty is 0';
            InsertDataInBuffer(ErrorMsg);
            EXIT(FALSE);
        END;

        //HG10.00.11 NJ 16/04/2018
        //CS092 Channing.Zhou 15/9/2025 move to here to prevent the confirmation message shows before the import data valiation-->
        IF RecTEMPSalesFileImportBuffer.Status = RecTEMPSalesFileImportBuffer.Status::Firm THEN BEGIN
            SameDOAnswer := TRUE;
            RecSalesHeader.RESET;
            RecSalesHeader.SETRANGE("Document Type", RecSalesHeader."Document Type"::Order);
            RecSalesHeader.SETRANGE("External Document No.", RecTEMPSalesFileImportBuffer."Delivery Order");
            IF RecSalesHeader.FINDFIRST THEN BEGIN
                IF NOT CONFIRM(STRSUBSTNO(Text001, RecTEMPSalesFileImportBuffer."Delivery Order"), FALSE) THEN BEGIN
                    SameDOAnswer := FALSE;
                END;
            END;
            IF NOT SameDOAnswer THEN BEGIN
                EXIT(FALSE);
            END;
        END;
        //HG10.00.11 NJ 16/04/2018
        //CS092 Channing.Zhou 15/9/2025 move to here to prevent the confirmation message shows before the import data valiation <--

        IF RecTEMPSalesFileImportBuffer.Status = RecTEMPSalesFileImportBuffer.Status::Planned THEN BEGIN
            RecSalesHeader.RESET;
            RecSalesHeader.SETRANGE("Document Type", RecSalesHeader."Document Type"::Quote);
            RecSalesHeader.SETRANGE("Sell-to Customer No.", RecCustomer."No.");
            IF RecSalesHeader.FINDSET THEN
                RecSalesHeader.DELETEALL(TRUE);
        END;

        RecSalesHeader.INIT;
        RecSalesHeader.SetHideValidationDialog(TRUE);
        IF RecTEMPSalesFileImportBuffer.Status = RecTEMPSalesFileImportBuffer.Status::Firm THEN
            RecSalesHeader.VALIDATE("Document Type", RecSalesHeader."Document Type"::Order)
        ELSE
            RecSalesHeader.VALIDATE("Document Type", RecSalesHeader."Document Type"::Quote);
        RecSalesHeader."No." := '';
        IF NOT RecSalesHeader.INSERT(TRUE) THEN BEGIN
            ErrorMsg := GETLASTERRORTEXT;
            InsertDataInBuffer(ErrorMsg);
            EXIT(FALSE);
        END;

        RecSalesHeader.VALIDATE("Posting Date", TODAY);
        RecSalesHeader.VALIDATE("Order Date", TODAY);
        RecSalesHeader.VALIDATE("Sell-to Customer No.", RecCustomer."No.");
        RecSalesHeader.VALIDATE("Bill-to Customer No.", RecCustomer."No.");
        IF RecSalesHeader."Document Type" = RecSalesHeader."Document Type"::Order THEN BEGIN
            RecSalesHeader.VALIDATE("External Document No.", RecTEMPSalesFileImportBuffer."Delivery Order");
            RecSalesHeader.VALIDATE("Your Reference", RecTEMPSalesFileImportBuffer."Delivery Order");
            RecSalesHeader.VALIDATE("Requested Delivery Date", RecTEMPSalesFileImportBuffer."Due Date");
        END;
        IF NOT RecSalesHeader.MODIFY(TRUE) THEN BEGIN
            ErrorMsg := GETLASTERRORTEXT;
            InsertDataInBuffer(ErrorMsg);
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    local procedure CreateSalesLine(var RecItem: Record Item): Boolean
    begin
        LineNo := LineNo + 10000;

        RecSalesLine.INIT;
        RecSalesLine.SetHideValidationDialog(TRUE);
        RecSalesLine.VALIDATE("Document Type", RecSalesHeader."Document Type");
        RecSalesLine.VALIDATE("Document No.", RecSalesHeader."No.");
        RecSalesLine.VALIDATE("Line No.", LineNo);
        RecSalesLine.VALIDATE(Type, RecSalesLine.Type::Item);
        RecSalesLine.VALIDATE("No.", RecItem."No.");
        RecSalesLine.VALIDATE(Quantity, RecTEMPSalesFileImportBuffer."Qty Due");
        RecSalesLine.VALIDATE("Customer Item No.", RecTEMPSalesFileImportBuffer."Buyer Part Number");
        IF RecSalesHeader."Document Type" = RecSalesHeader."Document Type"::Order THEN
            RecSalesLine.VALIDATE("Customer Order No.", RecTEMPSalesFileImportBuffer."Delivery Order");
        RecSalesLine.VALIDATE("Requested Delivery Date", RecTEMPSalesFileImportBuffer."Due Date");
        RecSalesLine.VALIDATE("Promised Delivery Date", RecTEMPSalesFileImportBuffer."Due Date");
        IF RecTEMPSalesFileImportBuffer."Ship Date" <> 0D THEN
            RecSalesLine.VALIDATE("Shipment Date", RecTEMPSalesFileImportBuffer."Ship Date")
        ELSE
            RecSalesLine.VALIDATE("Shipment Date", CALCDATE('<-5D>', RecTEMPSalesFileImportBuffer."Due Date"));
        RecSalesLine.VALIDATE("Requested Delivery Date_1", RecTEMPSalesFileImportBuffer."Due Date");
        RecSalesLine.VALIDATE("Promised Delivery Date_1", RecTEMPSalesFileImportBuffer."Due Date");
        IF NOT RecSalesLine.INSERT(TRUE) THEN BEGIN
            ErrorMsg := GETLASTERRORTEXT;
            InsertDataInBuffer(ErrorMsg);
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;
}

