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
        UploadDialogCaption: Label 'Please Choose the SQ&&SO Import Excel file.';
        NoFileFoundMsg: Label 'No SQ&&SO Import Excel file found!';
        ExcelImportSucess: Label 'SQ&&SO Excel file import finished.';
        ExcelFileEmptyError: Label 'The Excel file do not contains any record Lines.';
        ExcelColNoError: Label 'The column number is not matching.';
        EntryNoNotValid: Label 'The Entry No. is not valid.';
        EntryNoDuplicated: Label 'The Entry No. is duplicated.';
        GroupingKeyNotValid: Label 'Grouping Key is not valid.';
        DocumentTypeNotValid: Label 'Document Type is not valid.';
        CustomerNoRequested: Label 'Customer No. is requested, can''t be empty.';
        CustomerOrderNoRequested: Label 'Customer Order No. is requested, can''t be empty.';
        OrderDateNotValid: Label 'Order Date is not valid.';
        RequestedDeliveryDateNotValid: Label 'Requested Delivery Date is not valid.';
        ShipmentDateNotValid: Label 'Shipment Date is not valid.';
        ItemNoRequested: Label 'Item No. is requested, can''t be empty.';
        QuantityNotValid: Label 'Quantity is not valid.';
        QuantityRequested: Label 'Quantity is requested, can''t be empty.';
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

    [TryFunction]
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

            if DocumentNoStr <> '' then begin
                if ((LineNoStr = '') or (not Evaluate(LineNo, LineNoStr))) then begin
                    Error(LineNoNotValid);
                end;
                if ((QuantityStr <> '') and ((not Evaluate(Quantity, QuantityStr)) or (Quantity < 0))) then begin
                    Error(QuantityNotValid);
                end;
            end
            else begin
                if ((GroupingKeyStr = '') or (not Evaluate(GroupingKey, GroupingKeyStr))) then begin
                    Error(GroupingKeyNotValid);
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
                if (QuantityStr = '') then begin
                    Error(QuantityRequested);
                end;
                if ((not Evaluate(Quantity, QuantityStr)) or (Quantity <= 0)) then begin
                    Error(QuantityNotValid);
                end;
            end;

            if ((DocumentTypeStr = '') or ((DocumentTypeStr <> 'SQ') and (DocumentTypeStr <> 'SO'))) then begin
                Error(DocumentTypeNotValid);
            end;

            if ((OrderDateStr <> '') and (not Evaluate(OrderDate, OrderDateStr))) then begin
                Error(OrderDateNotValid);
            end;

            if ((RequestedDeliveryDateStr <> '') and (not Evaluate(RequestedDeliveryDate, RequestedDeliveryDateStr))) then begin
                Error(RequestedDeliveryDateNotValid);
            end;

            if ((ShipmentDateStr <> '') and (not Evaluate(ShipmentDate, ShipmentDateStr))) then begin
                Error(ShipmentDateNotValid);
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

    [TryFunction]
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
                    Commit();
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
                        RecSalesLine.Validate("No.");
                        if RecSQSOImport.Quantity > 0 then begin
                            RecSalesLine.Validate(Quantity, RecSQSOImport.Quantity);
                        end;
                        if RecSQSOImport."Customer Order No." <> '' then begin
                            RecSalesLine.Validate("Customer Order No.", RecSQSOImport."Customer Order No.");
                        end;
                        if RecSQSOImport."Requested Delivery Date" <> 0D then begin
                            RecSalesLine.Validate("Requested Delivery Date_1", RecSQSOImport."Requested Delivery Date");
                        end;
                        if RecSQSOImport."Shipment Date" <> 0D then begin
                            RecSalesLine.Validate("Shipment Date", RecSQSOImport."Shipment Date");
                        end;
                        RecSalesLine.Modify();
                    end;
                    RecSalesHeader."Approval Status" := tmpHeaderAppSta;
                    RecSalesHeader.Modify();
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
                    RecSalesHeader."Approval Status" := RecSalesHeader."Approval Status"::"Auto Approved";
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
                end;
                RecSalesLine.Insert(true);
                InsertExtendedText(RecSalesLine, true);
                RecSalesHeader."Approval Status" := tmpHeaderAppSta;
                RecSalesHeader.Modify();
                /*RecExtTextHeader.Reset();
                RecExtTextHeader.SetRange("Table Name", RecExtTextHeader."Table Name"::Item);
                RecExtTextHeader.SetRange("No.", RecSQSOImport."Item No.");
                if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                    RecExtTextHeader.SetRange("Sales Quote", true);
                end
                else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                    RecExtTextHeader.SetRange("Sales Order", true);
                end;
                RecExtTextHeader.SetFilter("Starting Date", '<=%1', Today());
                RecExtTextHeader.SetFilter("Ending Date", '>=%1', Today());
                if not RecExtTextHeader.IsEmpty then begin
                    RecExtTextHeader.FindSet();
                    repeat
                        RecExtTextLine.Reset();
                        RecExtTextLine.SetRange("Table Name", RecExtTextLine."Table Name"::Item);
                        RecExtTextLine.SetRange("No.", RecSQSOImport."Item No.");
                        RecExtTextLine.SetRange("Language Code", RecExtTextHeader."Language Code");
                        RecExtTextLine.SetRange("Text No.", RecExtTextHeader."Text No.");
                        if not RecExtTextLine.IsEmpty then begin
                            RecExtTextLine.FindSet();
                            repeat
                                LineNo += 10000;
                                RecSalesLine.Reset();
                                Clear(RecSalesLine);
                                RecSalesLine.SetHideValidationDialog(true);
                                RecSalesLine.Init();
                                if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SQ then begin
                                    RecSalesLine."Document Type" := RecSalesLine."Document Type"::Quote;
                                end
                                else if RecSQSOImport."Document Type" = RecSQSOImport."Document Type"::SO then begin
                                    RecSalesLine."Document Type" := RecSalesLine."Document Type"::Order;
                                end;
                                RecSalesLine."Document No." := RecSQSOImport."Document No.";
                                RecSalesLine."Line No." := LineNo;
                                RecSalesLine.Description := RecExtTextLine.Text;
                                RecSalesLine.Insert();
                            until RecExtTextLine.Next() = 0;
                        end;
                    until RecExtTextHeader.Next() = 0;
                end;*/
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