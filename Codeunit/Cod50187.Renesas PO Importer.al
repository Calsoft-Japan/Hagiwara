codeunit 50187 "Renesas PO Importer"
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
        rec_POInt: Record "Renesas PO Interface";
        RowNo: Integer;
        ColNo: Integer;
        LastEntryNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LastEntryNo := 0;
        rec_POInt.Reset();
        if rec_POInt.FindLast() then
            LastEntryNo := rec_POInt."Entry No.";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            LastEntryNo := LastEntryNo + 1;
            rec_POInt.Init();
            rec_POInt."Entry No." := LastEntryNo;
            Evaluate(rec_POInt."Document Date", GetValueAtCell(RowNo, 1));
            Evaluate(rec_POInt."OEM No.", GetValueAtCell(RowNo, 2));
            Evaluate(rec_POInt."Vendor Customer Code", GetValueAtCell(RowNo, 3));
            Evaluate(rec_POInt."Customer Name", GetValueAtCell(RowNo, 4));
            Evaluate(rec_POInt."Item Description", GetValueAtCell(RowNo, 5));
            Evaluate(rec_POInt."Product", GetValueAtCell(RowNo, 6));
            Evaluate(rec_POInt."CO No.", GetValueAtCell(RowNo, 7));
            Evaluate(rec_POInt."Demand Date", GetValueAtCell(RowNo, 8));
            Evaluate(rec_POInt."Quantity", GetValueAtCell(RowNo, 9));
            Evaluate(rec_POInt."Currency Code", GetValueAtCell(RowNo, 10));
            Evaluate(rec_POInt."Price", GetValueAtCell(RowNo, 11));
            Evaluate(rec_POInt."Amount", GetValueAtCell(RowNo, 12));
            rec_POInt.ProcFlag := '0';

            rec_POInt.Insert();
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