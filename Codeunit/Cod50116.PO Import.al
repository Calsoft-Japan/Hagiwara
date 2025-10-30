//CS092 2025/10/14 Bobby N009 PO Import
codeunit 50116 "PO Import"
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
        UploadDialogCaption: Label 'Please Choose the PO Import Excel file.';
        NoFileFoundMsg: Label 'No PO Import Excel file found!';
        ExcelImportSucess: Label 'PO Excel file import finished.';
        ExcelFileEmptyError: Label 'The Excel file do not contains any record Lines.';
        ExcelColNoError: Label 'The column number is not matching.';
        EntryNoNotValid: Label 'The Entry No. is not valid.';
        EntryNoDuplicated: Label 'The Entry No. is duplicated.';
        GroupKeyNotValid: Label 'Group Key is not valid.';
        VendorNoRequested: Label 'Vendor No. is requested, can''t be empty.';
        OrderDateNotValid: Label 'Order Date is not valid.';
        RequestedReceiptDateNotValid: Label 'Requested Receipt Date is not valid.';
        ShipmentDateNotValid: Label 'Shipment Date is not valid.';
        ItemNoRequested: Label 'Item No. is requested, can''t be empty.';
        QuantityNotValid: Label 'Quantity is not valid.';
        QuantityRequested: Label 'Quantity is requested, can''t be empty.';
        InsertCommentLineNotValid: Label 'Quantity is requested, can''t be empty.';
        LineNoNotValid: Label 'Line No. is not valid.';

    local procedure UploadAndReadExcelFile()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[250];
    begin
        UploadIntoStream(UploadDialogCaption, '', 'Excel files (*.xlsx)|*.xlsx', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := ImportExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        ImportExcelBuffer.Reset();
        ImportExcelBuffer.SetReadDateTimeInUtcDate(true);
        ImportExcelBuffer.DeleteAll();
        ImportExcelBuffer.OpenBookStream(IStream, SheetName);
        ImportExcelBuffer.ReadSheet();
    end;

    [TryFunction]
    local procedure ImportExcelData()
    var
        RecPOImportInsert: Record "PO Import";
        RecPOImportCheck: Record "PO Import";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        MaxColNo: Integer;
        EntryNoStr: Text;
        EntryNo: Integer;
        GroupKeyStr: Text;
        GroupKey: Integer;
        VendorNoStr: Text;
        OrderDateStr: Text;
        OrderDate: Date;
        RequestedReceiptDateStr: Text;
        RequestedReceiptDate: Date;
        CONoStr: Text;
        ItemNoStr: Text;
        QuantityStr: Text;
        Quantity: Decimal;
        InsertCommentLineStr: Text;
        InsertCommentLine: Boolean;
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

        if MaxColNo <> 11 then begin
            Error(ExcelColNoError);
        end;

        for RowNo := 2 to MaxRowNo do begin
            RecPOImportInsert.Init();
            EntryNoStr := GetValueAtCell(RowNo, 1).Trim();
            GroupKeyStr := GetValueAtCell(RowNo, 2).Trim();
            VendorNoStr := GetValueAtCell(RowNo, 3).Trim();
            OrderDateStr := GetValueAtCell(RowNo, 4).Trim();
            RequestedReceiptDateStr := GetValueAtCell(RowNo, 5).Trim();
            CONoStr := GetValueAtCell(RowNo, 6).Trim();
            ItemNoStr := GetValueAtCell(RowNo, 7).Trim();
            QuantityStr := GetValueAtCell(RowNo, 8).Trim();
            InsertCommentLineStr := GetValueAtCell(RowNo, 9).Trim();
            DocumentNoStr := GetValueAtCell(RowNo, 10).Trim();
            LineNoStr := GetValueAtCell(RowNo, 11).Trim();

            Clear(GroupKey);
            Clear(OrderDate);
            Clear(RequestedReceiptDate);
            Clear(Quantity);
            Clear(InsertCommentLine);
            Clear(LineNo);

            if ((EntryNoStr = '') or (not Evaluate(EntryNo, EntryNoStr))) then begin
                Error(EntryNoNotValid);
            end;
            RecPOImportCheck.Reset();
            RecPOImportCheck.SetRange("Entry No.", EntryNo);
            if not RecPOImportCheck.IsEmpty() then begin
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
                if ((GroupKeyStr = '') or (not Evaluate(GroupKey, GroupKeyStr))) then begin
                    Error(GroupKeyNotValid);
                end;

                if (VendorNoStr = '') then begin
                    Error(VendorNoRequested);
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

            if ((OrderDateStr <> '') and (not Evaluate(OrderDate, OrderDateStr))) then begin
                Error(OrderDateNotValid);
            end;

            if ((RequestedReceiptDateStr <> '') and (not Evaluate(RequestedReceiptDate, RequestedReceiptDateStr))) then begin
                Error(RequestedReceiptDateNotValid);
            end;

            if ((InsertCommentLineStr <> '') and (not Evaluate(InsertCommentLine, InsertCommentLineStr))) then begin
                Error(InsertCommentLineNotValid);
            end;

            RecPOImportInsert."Entry No." := EntryNo;
            RecPOImportInsert."Grouping Key" := GroupKey;
            RecPOImportInsert."Vendor No." := VendorNoStr;
            RecPOImportInsert."Order Date" := OrderDate;
            RecPOImportInsert."Requested Receipt Date" := RequestedReceiptDate;
            RecPOImportInsert."Item No." := ItemNoStr;
            RecPOImportInsert."Quantity" := Quantity;
            RecPOImportInsert."Insert Comment Line" := InsertCommentLine;
            RecPOImportInsert."Document No." := DocumentNoStr;
            RecPOImportInsert."Line No." := LineNo;
            RecPOImportInsert.Status := RecPOImportInsert.Status::Pending;
            RecPOImportInsert."Error Description" := '';
            RecPOImportInsert.Insert();
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
        RecPOImportInsert: record "PO Import";
        RecTmpPOImportInsert: record "PO Import" temporary;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        NoSeriesMgt: Codeunit "No. Series";
        RecPurchaseHeader: Record "Purchase Header";
        RecPurchaseLine: Record "Purchase Line";
        RecItem: Record Item;
        RecPurchaseLineNo: Integer;
        tmpHeaderAppSta: Enum "Hagiwara Approval Status";
        TmpReqRecDate1: Date;
    begin
        RecPOImportInsert.Reset();
        if RecPOImportInsert.IsEmpty() then begin
            exit;
        end;
        if RecPOImportInsert.FindSet() then begin
            repeat
                if (RecPOImportInsert."Document No." <> '') then begin //Update Case
                    RecPurchaseHeader.Reset();
                    RecPurchaseHeader.SetRange("No.", RecPOImportInsert."Document No.");
                    RecPurchaseHeader.SetRange("Document Type", RecPurchaseHeader."Document Type"::Order);
                    if RecPurchaseHeader.FindFirst() then begin
                        if RecPurchaseHeader.Status = RecPurchaseHeader.Status::Released then
                            ReleasePurchDoc.PerformManualReopen(RecPurchaseHeader);
                        tmpHeaderAppSta := RecPurchaseHeader."Approval Status";
                        RecPurchaseHeader."Approval Status" := RecPurchaseHeader."Approval Status"::Required;
                        RecPurchaseHeader.Modify();

                        RecPurchaseLine.Reset();
                        RecPurchaseLine.SetRange("Document Type", RecPurchaseLine."Document Type"::Order);
                        RecPurchaseLine.SetRange("Document No.", RecPOImportInsert."Document No.");
                        RecPurchaseLine.SetRange("Line No.", RecPOImportInsert."Line No.");
                        if RecPurchaseLine.FindFirst() then begin
                            TmpReqRecDate1 := 0D;
                            if RecPurchaseLine."Requested Receipt Date_1" <> 0D then begin
                                TmpReqRecDate1 := RecPurchaseLine."Requested Receipt Date_1";
                            end;
                            RecPurchaseLine.Validate("No.", RecPurchaseLine."No.");
                            RecPurchaseLine.Validate(Quantity, RecPOImportInsert.Quantity);
                            if (RecPOImportInsert."Requested Receipt Date" <> 0D) then begin
                                RecPurchaseLine.Validate("Requested Receipt Date_1", RecPOImportInsert."Requested Receipt Date");
                            end
                            else if (TmpReqRecDate1 <> 0D) then begin
                                RecPurchaseLine.Validate("Requested Receipt Date_1", TmpReqRecDate1);//The data
                            end;
                            RecPurchaseLine.Modify();
                        end;
                        RecPurchaseHeader."Approval Status" := tmpHeaderAppSta;
                        RecPurchaseHeader.Modify();

                        RecPOImportInsert.Status := RecPOImportInsert.Status::Completed;
                        RecPOImportInsert.Modify();
                    end;
                end else begin //Insert Case
                    RecTmpPOImportInsert.Reset();
                    RecTmpPOImportInsert.SetRange("Grouping Key", RecPOImportInsert."Grouping Key");
                    if not RecTmpPOImportInsert.FindFirst() then begin
                        RecPurchaseHeader.Init();
                        RecPurchaseHeader.SetHideValidationDialog(true);
                        RecPurchaseHeader."Document Type" := RecPurchaseHeader."Document Type"::Order;
                        RecPurchaseHeader.TestNoSeries();
                        RecPurchaseHeader."No." := NoSeriesMgt.GetNextNo(RecPurchaseHeader.GetNoSeriesCode(), WorkDate());
                        RecPurchaseHeader.Validate("Buy-from Vendor No.", RecPOImportInsert."Vendor No.");
                        if (RecPOImportInsert."Order Date" <> 0D) then begin
                            RecPurchaseHeader.Validate("Order Date", RecPOImportInsert."Order Date");
                        end
                        else begin
                            RecPurchaseHeader."Order Date" := WorkDate();
                        end;
                        /*RecPurchaseHeader."Posting Date" := WorkDate();
                        RecPurchaseHeader."Document Date" := WorkDate();
                        RecPurchaseHeader."Due Date" := CalcDate('<30D>', WorkDate());*/
                        if (RecPOImportInsert."Requested Receipt Date" <> 0D) then begin
                            RecPurchaseHeader.Validate("Requested Receipt Date", RecPOImportInsert."Requested Receipt Date");
                        end;
                        RecPurchaseHeader."Approval Status" := RecPurchaseHeader."Approval Status"::"Auto Approved";
                        RecPurchaseHeader.Insert();

                        RecTmpPOImportInsert.Reset();
                        RecTmpPOImportInsert.Init();
                        RecTmpPOImportInsert.TransferFields(RecPOImportInsert);
                        RecTmpPOImportInsert.Insert();
                    end;
                    RecPurchaseLine.Reset();
                    RecPurchaseLine.SetRange("Document Type", RecPurchaseLine."Document Type"::Order);
                    RecPurchaseLine.SetRange("Document No.", RecPurchaseHeader."No.");
                    if RecPurchaseLine.FindLast() then begin
                        RecPurchaseLineNo := RecPurchaseLine."Line No.";
                    end else begin
                        RecPurchaseLineNo := 0;
                    end;
                    RecPurchaseLineNo += 10000;
                    RecPurchaseLine.Init();
                    RecPurchaseLine."Document Type" := RecPurchaseHeader."Document Type";
                    RecPurchaseLine."Document No." := RecPurchaseHeader."No.";
                    RecPurchaseLine.Validate("Buy-from Vendor No.", RecPOImportInsert."Vendor No.");
                    RecPurchaseLine.Validate("CO No.", RecPOImportInsert."CO No.");
                    RecPurchaseLine.Type := RecPurchaseLine.Type::Item;
                    RecPurchaseLine.Validate("No.", RecPOImportInsert."Item No.");
                    RecPurchaseLine.Validate(Quantity, RecPOImportInsert.Quantity);
                    RecPurchaseLine."Line No." := RecPurchaseLineNo;
                    if (RecPOImportInsert."Requested Receipt Date" <> 0D) then begin
                        RecPurchaseLine.Validate("Requested Receipt Date_1", RecPOImportInsert."Requested Receipt Date");
                    end;
                    RecPurchaseLine.Insert();

                    if RecPOImportInsert."Insert Comment Line" then begin
                        RecItem.Get(RecPOImportInsert."Item No.");
                        RecPurchaseLine.Init();
                        RecPurchaseLine."Document Type" := RecPurchaseHeader."Document Type";
                        RecPurchaseLine."Document No." := RecPurchaseHeader."No.";
                        RecPurchaseLine.Validate("Buy-from Vendor No.", RecPOImportInsert."Vendor No.");
                        RecPurchaseLine.Type := RecPurchaseLine.Type::" ";
                        RecPurchaseLine.Description := 'CO:' + RecItem."Country/Region of Origin Code";
                        RecPurchaseLine."Attached to Line No." := RecPurchaseLineNo;
                        RecPurchaseLineNo := RecPurchaseLineNo + 10000;
                        RecPurchaseLine."Line No." := RecPurchaseLineNo;
                        RecPurchaseLine.Insert();
                    end;
                    RecPOImportInsert.Status := RecPOImportInsert.Status::Completed;
                    RecPOImportInsert.Modify();
                end;
            until RecPOImportInsert.Next() = 0;
            RecPOImportInsert.DeleteAll();
        end;
    end;
}