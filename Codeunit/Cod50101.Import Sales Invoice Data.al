codeunit 50101 "Import Sales Invoice Data"
{

    trigger OnRun()
    begin
        ReadExcelSheet();
        ImportExcelData();
    end;


    var
        IsInvoice: Boolean;
        FileName: Text[250];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel import finished.';

    procedure SetInvoice(pInvoice: Boolean)
    var
        myInt: Integer;
    begin
        IsInvoice := pInvoice;
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
        rec_ImpLine: Record "Sales Invoice Import Line";
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
            rec_ImpLine.Init();
            Evaluate(rec_ImpLine."Entry No.", GetValueAtCell(RowNo, 1));
            Evaluate(rec_ImpLine."Posting Date", GetValueAtCell(RowNo, 2));
            Evaluate(rec_ImpLine."Document Date", GetValueAtCell(RowNo, 3));
            Evaluate(rec_ImpLine."Customer No.", GetValueAtCell(RowNo, 4));
            Evaluate(rec_ImpLine."Order No.", GetValueAtCell(RowNo, 5));
            Evaluate(rec_ImpLine."Line No.", GetValueAtCell(RowNo, 6));
            Evaluate(rec_ImpLine."Item No.", GetValueAtCell(RowNo, 7));
            Evaluate(rec_ImpLine."Qty. to Invoice", GetValueAtCell(RowNo, 8));
            Evaluate(rec_ImpLine."Shipment Method Code", GetValueAtCell(RowNo, 9));
            Evaluate(rec_ImpLine."Shipping Agent Code", GetValueAtCell(RowNo, 10));
            Evaluate(rec_ImpLine."Package Tracking No.", GetValueAtCell(RowNo, 11));
            Evaluate(rec_ImpLine."Unit Price", GetValueAtCell(RowNo, 12));
            Evaluate(rec_ImpLine."Due Date", GetValueAtCell(RowNo, 13));

            rec_ImpLine.Insert();
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