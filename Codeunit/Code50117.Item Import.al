codeunit 50117 "Item Import"
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
        ExcelImportSucess: Label 'Import finished.';
        G_BatchName: Code[20];

    procedure SetBatchName(pBatchName: Code[20])
    begin
        G_BatchName := pBatchName;
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
        rec_POInt: Record "Item Import Line";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        rec_POInt.Reset();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        if MaxRowNo <= 1 then begin
            Error('There is no record to import.');
        end;

        for RowNo := 2 to MaxRowNo do begin
            rec_POInt.Init();
            rec_POInt."Batch Name" := G_BatchName;
            Evaluate(rec_POInt."Entry No.", GetValueAtCell(RowNo, 1));
            if Evaluate(rec_POInt."Type", GetValueAtCell(RowNo, 2)) then;
            Evaluate(rec_POInt."Item No.", GetValueAtCell(RowNo, 3));
            if Evaluate(rec_POInt."Familiar Name", GetValueAtCell(RowNo, 4)) then;
            if Evaluate(rec_POInt."Description", GetValueAtCell(RowNo, 5)) then;
            if Evaluate(rec_POInt."Description 2", GetValueAtCell(RowNo, 6)) then;
            Evaluate(rec_POInt."Base Unit of Measure", GetValueAtCell(RowNo, 7));
            if Evaluate(rec_POInt."Sales Unit of Measure", GetValueAtCell(RowNo, 8)) then;
            if Evaluate(rec_POInt."Purchase Unit of Measure", GetValueAtCell(RowNo, 9)) then;
            if Evaluate(rec_POInt."Price/Profit Calculation", GetValueAtCell(RowNo, 10)) then;
            if Evaluate(rec_POInt."Lead Time Calculation", GetValueAtCell(RowNo, 11)) then;
            if Evaluate(rec_POInt."Tariff No.", GetValueAtCell(RowNo, 12)) then;
            if Evaluate(rec_POInt."Reserve", GetValueAtCell(RowNo, 13)) then;
            if Evaluate(rec_POInt."Stockout Warning", GetValueAtCell(RowNo, 14)) then;
            if Evaluate(rec_POInt."Prevent Negative Inventory", GetValueAtCell(RowNo, 15)) then;
            if Evaluate(rec_POInt."Replenishment System", GetValueAtCell(RowNo, 16)) then;
            if Evaluate(rec_POInt."Item Tracking Code", GetValueAtCell(RowNo, 17)) then;
            if Evaluate(rec_POInt."Manufacture Code", GetValueAtCell(RowNo, 18)) then;
            if Evaluate(rec_POInt."Item Category Code", GetValueAtCell(RowNo, 19)) then;
            if Evaluate(rec_POInt."Original Item No.", GetValueAtCell(RowNo, 20)) then;
            if Evaluate(rec_POInt."Country/Region of Origin Code", GetValueAtCell(RowNo, 21)) then;
            if Evaluate(rec_POInt."Country/Region of Org Cd (FE)", GetValueAtCell(RowNo, 22)) then;
            if Evaluate(rec_POInt."Product Group Code", GetValueAtCell(RowNo, 23)) then;
            if Evaluate(rec_POInt."Products", GetValueAtCell(RowNo, 24)) then;
            if Evaluate(rec_POInt."Parts No.", GetValueAtCell(RowNo, 25)) then;
            if Evaluate(rec_POInt."PKG", GetValueAtCell(RowNo, 26)) then;
            if Evaluate(rec_POInt."Rank", GetValueAtCell(RowNo, 27)) then;
            if Evaluate(rec_POInt."SBU", GetValueAtCell(RowNo, 28)) then;
            if Evaluate(rec_POInt."Car Model", GetValueAtCell(RowNo, 29)) then;
            if Evaluate(rec_POInt."SOP", GetValueAtCell(RowNo, 30)) then;
            if Evaluate(rec_POInt."MP-Volume(pcs/M)", GetValueAtCell(RowNo, 31)) then;
            if Evaluate(rec_POInt."Apl", GetValueAtCell(RowNo, 32)) then;
            if Evaluate(rec_POInt."Service Parts", GetValueAtCell(RowNo, 33)) then;
            if Evaluate(rec_POInt."Order Deadline Date", GetValueAtCell(RowNo, 34)) then;
            if Evaluate(rec_POInt."EOL", GetValueAtCell(RowNo, 35)) then;
            if Evaluate(rec_POInt."Memo", GetValueAtCell(RowNo, 36)) then;
            if Evaluate(rec_POInt."EDI", GetValueAtCell(RowNo, 37)) then;
            if Evaluate(rec_POInt."Customer No.", GetValueAtCell(RowNo, 38)) then;
            if Evaluate(rec_POInt."Customer Item No.", GetValueAtCell(RowNo, 39)) then;
            if Evaluate(rec_POInt."Customer Item No. (Plain)", GetValueAtCell(RowNo, 40)) then;
            if Evaluate(rec_POInt."OEM No.", GetValueAtCell(RowNo, 41)) then;
            if Evaluate(rec_POInt."Vendor No.", GetValueAtCell(RowNo, 42)) then;
            if Evaluate(rec_POInt."Item Supplier Source", GetValueAtCell(RowNo, 43)) then;
            if Evaluate(rec_POInt."Vendor Item No.", GetValueAtCell(RowNo, 44)) then;
            if Evaluate(rec_POInt."Lot Size", GetValueAtCell(RowNo, 45)) then;
            if Evaluate(rec_POInt."Minimum Order Quantity", GetValueAtCell(RowNo, 46)) then;
            if Evaluate(rec_POInt."Order Multiple", GetValueAtCell(RowNo, 47)) then;
            if Evaluate(rec_POInt."Maximum Order Quantity", GetValueAtCell(RowNo, 48)) then;
            if Evaluate(rec_POInt."Markup%", GetValueAtCell(RowNo, 49)) then;
            if Evaluate(rec_POInt."Markup%(Sales Price)", GetValueAtCell(RowNo, 50)) then;
            if Evaluate(rec_POInt."Markup%(Purchase Price)", GetValueAtCell(RowNo, 51)) then;
            if Evaluate(rec_POInt."One Renesas EDI", GetValueAtCell(RowNo, 52)) then;
            if Evaluate(rec_POInt."Excluded in Inventory Report", GetValueAtCell(RowNo, 53)) then;
            if Evaluate(rec_POInt."Gen. Prod. Posting Group", GetValueAtCell(RowNo, 54)) then;
            if Evaluate(rec_POInt."Inventory Posting Group", GetValueAtCell(RowNo, 55)) then;
            if Evaluate(rec_POInt."VAT Prod. Posting Group", GetValueAtCell(RowNo, 56)) then;
            if Evaluate(rec_POInt."Customer Group Code", GetValueAtCell(RowNo, 57)) then;
            if Evaluate(rec_POInt."Base Currency Code", GetValueAtCell(RowNo, 58)) then;
            if Evaluate(rec_POInt."Blocked", GetValueAtCell(RowNo, 59)) then;
            if Evaluate(rec_POInt."Status", GetValueAtCell(RowNo, 60)) then;
            if Evaluate(rec_POInt."Error Description", GetValueAtCell(RowNo, 61)) then;
            if Evaluate(rec_POInt."Action", GetValueAtCell(RowNo, 62)) then;
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
