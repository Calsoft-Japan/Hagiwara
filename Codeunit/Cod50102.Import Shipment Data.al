codeunit 50102 "Import Shipment Data"
{

    trigger OnRun()
    begin
        ReadExcelSheet();
        ImportExcelData();
    end;


    var
        FileName: Text[250];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';

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
        rec_POStaging: Record "Shipment Import Line";
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
            Evaluate(rec_POStaging."Group Key", GetValueAtCell(RowNo, 1));
            Evaluate(rec_POStaging."Entry No.", GetValueAtCell(RowNo, 2));
            Evaluate(rec_POStaging."Customer No.", GetValueAtCell(RowNo, 3));
            Evaluate(rec_POStaging."Item No.", GetValueAtCell(RowNo, 4));
            Evaluate(rec_POStaging."Item Description", GetValueAtCell(RowNo, 5));
            Evaluate(rec_POStaging."Customer Item No.", GetValueAtCell(RowNo, 6));
            Evaluate(rec_POStaging."Customer Order No.", GetValueAtCell(RowNo, 7));
            if Evaluate(rec_POStaging."Shipped Quantity", GetValueAtCell(RowNo, 8)) then;
            if Evaluate(rec_POStaging."Unit Price", GetValueAtCell(RowNo, 9)) then;
            Evaluate(rec_POStaging."Currency Code", GetValueAtCell(RowNo, 10));

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