//CS092 2025/10/09 Channing.Zhou N008 SQ&SO Import
codeunit 50115 "SQ&SO Import"
{

    trigger OnRun()
    begin
        UploadAndReadExcelFile();
        ImportExcelData();
    end;


    var
        FileName: Text[250];
        SheetName: Text[100];

        ImportExcelBuffer: Record "Excel Buffer" temporary;
        UploadDialogCaption: Label 'Please choose the Excel file.';
        NoFileFoundMsg: Label 'No SQ&&SO Import Excel file found!';
        ExcelImportSucess: Label 'SQ&&SO Excel file import finished.';
        ExcelFileEmptyError: Label 'The Excel file do not contains any record Lines.';
        ExcelColNoError: Label 'The column number is not matching.';
        EntryNoNotValid: Label 'The Entry No. is not valid.';
        EntryNoDuplicated: Label 'The Entry No. is duplicated.';
        GroupingKeyNotValid: Label 'Grouping Key is not valid.';
        GroupingKeyRequested: Label 'Grouping Key is requested.';
        GroupingKeyCoexisted: Label 'The Grouping Key is coexisted.';
        DocumentTypeNotValid: Label 'Document Type is not valid.';
        CustomerNoRequested: Label 'Customer No. is requested.';
        CustomerOrderNoRequested: Label 'Customer Order No. is requested.';
        OrderDateNotValid: Label 'Order Date is not valid.';
        RequestedDeliveryDateNotValid: Label 'Requested Delivery Date is not valid.';
        ShipmentDateNotValid: Label 'Shipment Date is not valid.';
        ShipmentDateRequested: Label 'Shipment Date is requested.';
        ItemNoRequested: Label 'Item No. is requested.';
        QuantityNotValid: Label 'Quantity is not valid.';

        /*2025/1/15 Channing.Zhou changed based on FDDV1.1 allow the quantity set to 0 for insert case start*/
        //QuantityRequested: Label 'Quantity is requested.';
        /*2025/1/15 Channing.Zhou changed based on FDDV1.1 Shipment Date is required for modify case end*/
        LineNoNotValid: Label 'Line No. is not valid.';

    local procedure UploadAndReadExcelFile()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[250];
    begin
        if UploadIntoStream(UploadDialogCaption, '', 'Excel files (*.xlsx)|*.xlsx', FromFile, IStream) then begin
            if FromFile <> '' then begin
                FileName := FileMgt.GetFileName(FromFile);
                SheetName := ImportExcelBuffer.SelectSheetsNameStream(IStream);
                ImportExcelBuffer.Reset();
                ImportExcelBuffer.SetReadDateTimeInUtcDate(true);
                ImportExcelBuffer.DeleteAll();
                ImportExcelBuffer.OpenBookStream(IStream, SheetName);
                ImportExcelBuffer.ReadSheet();
            end else
                Error(NoFileFoundMsg);
        end;
    end;

    local procedure ImportExcelData()
    var
        RecSQSOImportInsert: Record "SQ&SO Import";
        RecSQSOImportCheck: Record "SQ&SO Import";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        MaxColNo: Integer;
        EntryNoStr: Text;
        EntryNo: Integer;
        GroupingKeyStr: Text;
        GroupingKey: Integer;
        DocumentTypeStr: Text;
        CustomerNoStr: Text;
        CustomerOrderNoStr: Text;
        OrderDateStr: Text;
        OrderDate: Date;
        RequestedDeliveryDateStr: Text;
        RequestedDeliveryDate: Date;
        ShipmentDateStr: Text;
        ShipmentDate: Date;
        ItemNoStr: Text;
        QuantityStr: Text;
        Quantity: Decimal;
        DocumentNoStr: Text;
        LineNoStr: Text;
        LineNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        MaxColNo := 0;
        ImportExcelBuffer.Reset();
        if ImportExcelBuffer.FindLast() then begin
            MaxRowNo := ImportExcelBuffer."Row No.";
        end;
        ImportExcelBuffer.Reset();
        ImportExcelBuffer.SetCurrentKey("Column No.");
        if ImportExcelBuffer.FindLast() then begin
            MaxColNo := ImportExcelBuffer."Column No.";
        end;

        if MaxRowNo <= 1 then begin
            Error(ExcelFileEmptyError);
        end;

        if MaxColNo <> 12 then begin
            Error(ExcelColNoError);
        end;

        for RowNo := 2 to MaxRowNo do begin
            RecSQSOImportInsert.Init();
            EntryNoStr := GetValueAtCell(RowNo, 1).Trim();
            GroupingKeyStr := GetValueAtCell(RowNo, 2).Trim();
            DocumentTypeStr := GetValueAtCell(RowNo, 3).Trim().ToUpper();
            CustomerNoStr := GetValueAtCell(RowNo, 4).Trim();
            CustomerOrderNoStr := GetValueAtCell(RowNo, 5).Trim();
            OrderDateStr := GetValueAtCell(RowNo, 6).Trim();
            RequestedDeliveryDateStr := GetValueAtCell(RowNo, 7).Trim();
            ShipmentDateStr := GetValueAtCell(RowNo, 8).Trim();
            ItemNoStr := GetValueAtCell(RowNo, 9).Trim();
            QuantityStr := GetValueAtCell(RowNo, 10).Trim();
            DocumentNoStr := GetValueAtCell(RowNo, 11).Trim();
            LineNoStr := GetValueAtCell(RowNo, 12).Trim();

            Clear(GroupingKey);
            Clear(OrderDate);
            Clear(RequestedDeliveryDate);
            Clear(ShipmentDate);
            Clear(Quantity);
            Clear(LineNo);

            if ((EntryNoStr = '') or (not Evaluate(EntryNo, EntryNoStr))) then begin
                Error(EntryNoNotValid);
            end;
            RecSQSOImportCheck.Reset();
            RecSQSOImportCheck.SetRange("Entry No.", EntryNo);
            if not RecSQSOImportCheck.IsEmpty() then begin
                Error(EntryNoDuplicated);
            end;

            if ((DocumentTypeStr = '') or ((DocumentTypeStr <> 'SQ') and (DocumentTypeStr <> 'SO'))) then begin
                Error(DocumentTypeNotValid);
            end;

            if DocumentNoStr <> '' then begin
                if ((LineNoStr = '') or (not Evaluate(LineNo, LineNoStr))) then begin
                    Error(LineNoNotValid);
                end;
                if ((QuantityStr <> '') and ((not Evaluate(Quantity, QuantityStr)) or (Quantity < 0))) then begin
                    Error(QuantityNotValid);
                end;
                /*2025/1/15 Channing.Zhou changed based on FDDV1.1 Shipment Date is required for modify case start*/
                if (ShipmentDateStr = '') then begin
                    Error(ShipmentDateRequested);
                end;
                if (not Evaluate(ShipmentDate, ShipmentDateStr)) then begin
                    Error(ShipmentDateNotValid);
                end;
                /*2025/1/15 Channing.Zhou changed based on FDDV1.1 Shipment Date is required for modify case end*/
            end
            else begin
                if (GroupingKeyStr = '') then begin
                    Error(GroupingKeyRequested);
                end;
                if (not Evaluate(GroupingKey, GroupingKeyStr)) then begin
                    Error(GroupingKeyNotValid);
                end;
                RecSQSOImportCheck.Reset();
                RecSQSOImportCheck.SetRange("Document No.", '');
                RecSQSOImportCheck.SetRange("Grouping Key", GroupingKey);
                if DocumentTypeStr = 'SQ' then begin
                    RecSQSOImportCheck.SetRange("Document Type", RecSQSOImportCheck."Document Type"::SO);
                end
                else begin
                    RecSQSOImportCheck.SetRange("Document Type", RecSQSOImportCheck."Document Type"::SQ);
                end;
                if not RecSQSOImportCheck.IsEmpty() then begin
                    Error(GroupingKeyCoexisted);
                end;
                if (CustomerNoStr = '') then begin
                    Error(CustomerNoRequested);
                end;
                if (CustomerOrderNoStr = '') then begin
                    Error(CustomerOrderNoRequested);
                end;
                if (ItemNoStr = '') then begin
                    Error(ItemNoRequested);
                end;
                /*2025/1/15 Channing.Zhou changed based on FDDV1.1 allow the quantity set to 0 for insert case start*/
                /*if (QuantityStr = '') then begin
                    Error(QuantityRequested);
                end;*/
                if ((QuantityStr <> '') and (not Evaluate(Quantity, QuantityStr))) then begin
                    Error(QuantityNotValid);
                end;
                /*2025/1/15 Channing.Zhou changed based on FDDV1.1 allow the quantity set to 0 for insert case end*/
                if (ShipmentDateStr = '') then begin
                    Error(ShipmentDateRequested);
                end;
                if (not Evaluate(ShipmentDate, ShipmentDateStr)) then begin
                    Error(ShipmentDateNotValid);
                end;
            end;

            if ((OrderDateStr <> '') and (not Evaluate(OrderDate, OrderDateStr))) then begin
                Error(OrderDateNotValid);
            end;

            if ((RequestedDeliveryDateStr <> '') and (not Evaluate(RequestedDeliveryDate, RequestedDeliveryDateStr))) then begin
                Error(RequestedDeliveryDateNotValid);
            end;

            RecSQSOImportInsert."Entry No." := EntryNo;
            RecSQSOImportInsert."Grouping Key" := GroupingKey;
            Evaluate(RecSQSOImportInsert."Document Type", DocumentTypeStr);
            RecSQSOImportInsert."Customer No." := CustomerNoStr;
            RecSQSOImportInsert."Customer Order No." := CustomerOrderNoStr;
            RecSQSOImportInsert."Order Date" := OrderDate;
            RecSQSOImportInsert."Requested Delivery Date" := RequestedDeliveryDate;
            RecSQSOImportInsert."Shipment Date" := ShipmentDate;
            RecSQSOImportInsert."Item No." := ItemNoStr;
            RecSQSOImportInsert."Quantity" := Quantity;
            RecSQSOImportInsert."Document No." := DocumentNoStr;
            RecSQSOImportInsert."Line No." := LineNo;
            RecSQSOImportInsert.Status := RecSQSOImportInsert.Status::Pending;
            RecSQSOImportInsert."Error Description" := '';
            RecSQSOImportInsert.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        ImportExcelBuffer.Reset();
        If ImportExcelBuffer.Get(RowNo, ColNo) then
            exit(ImportExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    procedure ProcessAllData()
    var
        RecSQSOImport: Record "SQ&SO Import";
        RecSQSOImportCheck: Record "SQ&SO Import";
        RecTmpSQSOImportInsert: record "SQ&SO Import" temporary;
        RecSalesHeader: Record "Sales Header";
        RecSalesLine: Record "Sales Line";
        RecPriceListHeader: Record "Price List Header";
        RecCustomer: Record Customer;
        RecItem: Record Item;
        RecExtTextHeader: Record "Extended Text Header";
        RecExtTextLine: Record "Extended Text Line";
        LineNo: Integer;
        tmpHeaderAppSta: Enum "Hagiwara Approval Status";
        NoSeriesMgt: Codeunit "No. Series";
        SalesHeaderIsReleased: Boolean;
        ReleaseSalDoc: Codeunit "Release Sales Document";
    begin
        RecSQSOImport.Reset();
        if RecSQSOImport.IsEmpty() then begin
            exit;
        end;
        RecSQSOImport.FindSet();
        repeat
            if RecSQSOImport."Document No." <> '' then begin //Update Case
                RecSalesLine.Reset();
                if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                    RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Quote);
                end
                else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                    RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                end;
                RecSalesLine.SetRange("Document No.", RecSQSOImport."Document No.");
                RecSalesLine.SetRange("Line No.", RecSQSOImport."Line No.");
                if RecSalesLine.FindFirst() then begin
                    RecSalesHeader.Reset();
                    RecSalesHeader.Get(RecSalesLine."Document Type", RecSalesLine."Document No.");
                    tmpHeaderAppSta := RecSalesHeader."Approval Status";
                    RecSalesHeader."Approval Status" := RecSalesHeader."Approval Status"::Required;
                    RecSalesHeader.Modify();
                    /*2025/1/15 Channing.Zhou changed based on FDDV1.1 reopen the sales header if the status is released on udate case start*/
                    SalesHeaderIsReleased := false;
                    RecSalesHeader.Reset();
                    RecSalesHeader.Get(RecSalesLine."Document Type", RecSalesLine."Document No.");
                    if RecSalesHeader.Status = RecSalesHeader.Status::Released then begin
                        SalesHeaderIsReleased := true;
                        ReleaseSalDoc.PerformManualReopen(RecSalesHeader);
                    end;
                    /*2025/1/15 Channing.Zhou changed based on FDDV1.1 reopen the sales header if the status is released on udate case end*/
                    //Commit();
                    RecSalesLine.Reset();
                    if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                        RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Quote);
                    end
                    else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                        RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                    end;
                    RecSalesLine.SetRange("Document No.", RecSQSOImport."Document No.");
                    RecSalesLine.SetRange("Line No.", RecSQSOImport."Line No.");
                    if RecSalesLine.FindFirst() then begin
                        //RecSalesLine.Validate("No."); //why need this Validation? Error occured after partial-post, comment this line.
                        //if RecSQSOImport.Quantity > 0 then begin
                        RecSalesLine.Validate(Quantity, RecSQSOImport.Quantity);
                        //end;
                        if RecSQSOImport."Customer Order No." <> '' then begin
                            RecSalesLine.Validate("Customer Order No.", RecSQSOImport."Customer Order No.");
                        end;
                        if RecSQSOImport."Requested Delivery Date" <> 0D then begin
                            RecSalesLine.Validate("Requested Delivery Date_1", RecSQSOImport."Requested Delivery Date");
                        end;
                        if RecSQSOImport."Shipment Date" <> 0D then begin
                            RecSalesLine.Validate("Shipment Date", RecSQSOImport."Shipment Date");
                        end;
                        if RecSalesLine."Document Type" = RecSalesLine."Document Type"::Order then begin
                            RecSalesLine."Approved Quantity" := RecSalesLine.Quantity;
                            RecSalesLine."Approved Unit Price" := RecSalesLine."Unit Price";
                            RecSalesLine."Approval History Exists" := true;
                        end;
                        RecSalesLine.Modify();
                    end;
                    /*2025/1/15 Channing.Zhou changed based on FDDV1.1 set the sales header back to released if the status is reopened on udate case start*/
                    RecSalesHeader.Reset();
                    RecSalesHeader.Get(RecSalesLine."Document Type", RecSalesLine."Document No.");
                    if SalesHeaderIsReleased then begin
                        ReleaseSalDoc.PerformManualRelease(RecSalesHeader);
                    end;
                    /*2025/1/15 Channing.Zhou changed based on FDDV1.1 set the sales header back to released if the status is reopened on udate case end*/
                    RecSalesHeader.Reset();
                    RecSalesHeader.Get(RecSalesLine."Document Type", RecSalesLine."Document No.");
                    RecSalesHeader."Approval Status" := tmpHeaderAppSta;
                    RecSalesHeader.Modify();
                    //Commit();
                    RecSQSOImport.Status := RecSQSOImport.Status::Completed;
                    RecSQSOImport.Modify();
                end;
            end
            else begin //Insert Case
                RecTmpSQSOImportInsert.Reset();
                RecTmpSQSOImportInsert.SetRange("Grouping Key", RecSQSOImport."Grouping Key");
                if not RecTmpSQSOImportInsert.FindFirst() then begin
                    RecSalesHeader.Reset();
                    Clear(RecSalesHeader);
                    RecSalesHeader.Init();
                    RecSalesHeader.SetHideValidationDialog(true);
                    if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                        RecSalesHeader.Validate("Document Type", RecSalesHeader."Document Type"::Quote);
                    end
                    else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                        RecSalesHeader.Validate("Document Type", RecSalesHeader."Document Type"::Order);
                    end;
                    RecSalesHeader.VALIDATE("Posting Date", WorkDate());
                    RecSalesHeader.TestNoSeries();
                    RecSalesHeader."No. Series" := RecSalesHeader.GetNoSeriesCode();
                    RecSalesHeader."No." := NoSeriesMgt.GetNextNo(RecSalesHeader."No. Series", RecSalesHeader."Posting Date");
                    //RecSalesHeader.Insert(true);
                    RecSalesHeader.Validate("Sell-to Customer No.", RecSQSOImport."Customer No.");
                    RecSalesHeader.Validate("Bill-to Customer No.", RecSQSOImport."Customer No.");
                    RecSalesHeader.Validate("External Document No.", RecSQSOImport."Customer Order No.");
                    RecSalesHeader.Validate("Your Reference", RecSQSOImport."Customer Order No.");
                    if (RecSQSOImport."Order Date" <> 0D) then begin
                        RecSalesHeader.Validate("Order Date", RecSQSOImport."Order Date");
                    end
                    else begin
                        RecSalesHeader."Order Date" := WorkDate();
                    end;
                    if (RecSQSOImport."Requested Delivery Date" <> 0D) then begin
                        RecSalesHeader.Validate("Requested Delivery Date", RecSQSOImport."Requested Delivery Date");
                    end;
                    IF RecSalesHeader."Document Type" = RecSalesHeader."Document Type"::Order THEN BEGIN
                        if (RecSQSOImport."Shipment Date" <> 0D) then begin
                            RecSalesHeader.Validate("Shipment Date", RecSQSOImport."Shipment Date");
                        end;
                    END;
                    RecSalesHeader."Approval Status" := RecSalesHeader."Approval Status"::"Auto Approved";
                    //RecSalesHeader.Modify(true);
                    RecSalesHeader.Insert();
                    RecTmpSQSOImportInsert.Reset();
                    RecTmpSQSOImportInsert.Init();
                    RecTmpSQSOImportInsert.TransferFields(RecSQSOImport);
                    RecTmpSQSOImportInsert."Document No." := RecSalesHeader."No.";
                    RecTmpSQSOImportInsert.Insert();
                end;
                RecSalesHeader.Reset();
                Clear(RecSalesHeader);
                RecSalesLine.Reset();
                if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                    RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Quote);
                    RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Quote);
                end
                else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                    RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
                    RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                end;
                RecSalesHeader.SetRange("No.", RecTmpSQSOImportInsert."Document No.");
                RecSalesLine.SetRange("Document No.", RecTmpSQSOImportInsert."Document No.");
                if RecSalesLine.FindLast() then begin
                    LineNo := RecSalesLine."Line No.";
                end
                else begin
                    LineNo := 0;
                end;
                LineNo += 10000;
                RecSalesHeader.FindFirst();
                tmpHeaderAppSta := RecSalesHeader."Approval Status";
                RecSalesHeader."Approval Status" := RecSalesHeader."Approval Status"::Required;
                RecSalesHeader.Modify();
                //Commit();
                RecSalesLine.Reset();
                Clear(RecSalesLine);
                RecSalesLine.Init();
                RecSalesLine.SetHideValidationDialog(true);
                if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                    RecSalesLine.Validate("Document Type", RecSalesLine."Document Type"::Quote);
                end
                else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                    RecSalesLine.Validate("Document Type", RecSalesLine."Document Type"::Order);
                end;
                RecSalesLine.Validate("Document No.", RecTmpSQSOImportInsert."Document No.");
                RecSalesLine.Validate("Line No.", LineNo);
                RecSalesLine.Validate(Type, RecSalesLine.Type::Item);
                RecSalesLine.Validate("No.", RecSQSOImport."Item No.");
                RecSalesLine.Validate(Quantity, RecSQSOImport.Quantity);
                if (RecSQSOImport."Requested Delivery Date" <> 0D) then begin
                    RecSalesLine.Validate("Requested Delivery Date_1", RecSQSOImport."Requested Delivery Date");
                end;
                if (RecSQSOImport."Shipment Date" <> 0D) then begin
                    RecSalesLine.Validate("Shipment Date", RecSQSOImport."Shipment Date");
                end;
                if RecSalesLine."Document Type" = RecSalesLine."Document Type"::Order then begin
                    RecSalesLine.Validate("Customer Order No.", RecSQSOImport."Customer Order No.");
                    RecSalesLine."Approved Quantity" := RecSalesLine.Quantity;
                    RecSalesLine."Approved Unit Price" := RecSalesLine."Unit Price";
                    RecSalesLine."Approval History Exists" := true;
                end;
                RecSalesLine.Insert(true);
                InsertExtendedText(RecSalesLine, true);
                RecSalesHeader.Reset();
                Clear(RecSalesHeader);
                if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                    RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Quote);
                end
                else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                    RecSalesHeader.SetRange("Document Type", RecSalesHeader."Document Type"::Order);
                end;
                RecSalesHeader.SetRange("No.", RecTmpSQSOImportInsert."Document No.");
                RecSalesHeader.FindFirst();
                RecSalesHeader."Approval Status" := tmpHeaderAppSta;
                RecSalesHeader.Modify();
                //Commit();
                RecSQSOImport.Status := RecSQSOImport.Status::Completed;
                RecSQSOImport.Modify();
            end;
        until RecSQSOImport.Next() = 0;
        RecSQSOImport.DeleteAll();
    end;

    procedure InsertExtendedText(var
                                     RecSalesLine: record "Sales Line";
                                     Unconditionally: Boolean): Boolean
    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(RecSalesLine, Unconditionally) then begin
            Commit();
            TransferExtendedText.InsertSalesExtText(RecSalesLine);
            if TransferExtendedText.MakeUpdate() then begin
                exit(true);
            end;
        end;
        exit(false);
    end;
}
