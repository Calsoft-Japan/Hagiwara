codeunit 50105 "Imp. Purch. Rcpt. & Inv. Data"
{

    trigger OnRun()
    begin
        ReadExcelSheet();
        ImportExcelData();
    end;


    var
        TransType: Option Receipt,Invoice,ReceiptInvoice;

        FileName: Text[250];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel import finished.';

    procedure SetTransType(pType: Option Ship,Invoice,ReceiptInvoice)
    begin
        TransType := pType;
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        rec_POStaging: Record "Purch. Receipt Import Staging";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            rec_POStaging.Init();
            Evaluate(rec_POStaging."Batch No.", GetValueAtCell(RowNo, 1));
            Evaluate(rec_POStaging."Entry No.", GetValueAtCell(RowNo, 2));
            Evaluate(rec_POStaging."CO No.", GetValueAtCell(RowNo, 3));
            Evaluate(rec_POStaging."PO No.", GetValueAtCell(RowNo, 4));
            Evaluate(rec_POStaging."Line No.", GetValueAtCell(RowNo, 5));
            Evaluate(rec_POStaging."Arrival Date", GetValueAtCell(RowNo, 6));
            Evaluate(rec_POStaging."Closed Date", GetValueAtCell(RowNo, 7));

            if TransType = TransType::Receipt then begin
                Evaluate(rec_POStaging."Received Qty.", GetValueAtCell(RowNo, 8));
                Evaluate(rec_POStaging."Imported Item No.", GetValueAtCell(RowNo, 10));
                Evaluate(rec_POStaging."Receipt No.", GetValueAtCell(RowNo, 13));
            end;

            if TransType = TransType::Invoice then begin
                Evaluate(rec_POStaging."Qty. To Invoice", GetValueAtCell(RowNo, 9));
                Evaluate(rec_POStaging."Imported Item No.", GetValueAtCell(RowNo, 10));
                Evaluate(rec_POStaging."Description", GetValueAtCell(RowNo, 12));
                Evaluate(rec_POStaging."Proforma Invoice", GetValueAtCell(RowNo, 14));
                if StrLen(GetValueAtCell(RowNo, 15)) > 0 then begin
                    Evaluate(rec_POStaging."Unit Cost", GetValueAtCell(RowNo, 15));
                end;
            end;

            if TransType = TransType::ReceiptInvoice then begin
                Evaluate(rec_POStaging."Received Qty.", GetValueAtCell(RowNo, 8));
                Evaluate(rec_POStaging."Qty. To Invoice", GetValueAtCell(RowNo, 9));
                Evaluate(rec_POStaging."Imported Item No.", GetValueAtCell(RowNo, 10));
                Evaluate(rec_POStaging."LPN", GetValueAtCell(RowNo, 11));
                Evaluate(rec_POStaging."Description", GetValueAtCell(RowNo, 12));
                Evaluate(rec_POStaging."Receipt No.", GetValueAtCell(RowNo, 13));
                Evaluate(rec_POStaging."Proforma Invoice", GetValueAtCell(RowNo, 14));
                if StrLen(GetValueAtCell(RowNo, 15)) > 0 then begin
                    Evaluate(rec_POStaging."Unit Cost", GetValueAtCell(RowNo, 15));
                end;
            end;

            rec_POStaging."Import Date" := Today;
            rec_POStaging."Import User ID" := database.UserId;

            if TransType = TransType::Invoice then begin
                rec_POStaging.Received := true; //BC upgrade. (Received is set true while using configuration package in NAV2017.)
            end;

            rec_POStaging.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}