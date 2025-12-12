codeunit 50107 "Price List Import"
{
    trigger OnRun()
    begin
        ReadExcelSheet();
        ImportExcelData();
    end;

    var
        FileName: Text[250];
        SheetName: Text[100];
        G_BatchName: Code[20];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Import finished.';
        MaximumOrderQuantityNotValid: Label 'Maximum Order Quantity is not valid.';
        NotValidMsg: Label '%1 is not valid.';

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
        rec_Batch: Record "Price List Import Batch";
        rec_POInt: Record "Price List Import Line";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        EntryNo: Integer;
        ProductTypeStr: Text;
        ShipDebitFlagStr: Text;
        PCUpdatePriceStr: Text;
        PriceLineStatusStr: Text;
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

        if EntryNo = 0 then begin
            rec_POInt.Reset();
            rec_POInt.SetRange("Batch Name", G_BatchName);
            if rec_POInt.FindLast() then begin
                EntryNo := rec_POInt."Entry No.";
            end;
        end;

        for RowNo := 2 to MaxRowNo do begin
            rec_POInt.Init();
            EntryNo += 1;

            //----------------------Preparing for the check----------------------
            ProductTypeStr := GetValueAtCell(RowNo, 3).Trim();
            ShipDebitFlagStr := GetValueAtCell(RowNo, 15).Trim();
            PCUpdatePriceStr := GetValueAtCell(RowNo, 18).Trim();
            PriceLineStatusStr := GetValueAtCell(RowNo, 19).Trim();

            //Option Value Check
            if (not Evaluate(rec_POInt."Product Type", ProductTypeStr)) then begin
                Error(NotValidMsg, rec_POInt.FieldCaption("Product Type"));
            end;

            if (not Evaluate(rec_POInt."Ship&Debit Flag", ShipDebitFlagStr)) then begin
                Error(NotValidMsg, rec_POInt.FieldCaption("Ship&Debit Flag"));
            end;

            if (not Evaluate(rec_POInt."PC. Update Price", PCUpdatePriceStr)) then begin
                Error(NotValidMsg, rec_POInt.FieldCaption("PC. Update Price"));
            end;

            if (not Evaluate(rec_POInt."Price Line Status", PriceLineStatusStr)) then begin
                Error(NotValidMsg, rec_POInt.FieldCaption("Price Line Status"));
            end;

            //----------------------Set values for each item----------------------
            rec_POInt."Batch Name" := G_BatchName;
            rec_POInt."Entry No." := EntryNo;
            Evaluate(rec_POInt."Starting Date ", GetValueAtCell(RowNo, 1));
            Evaluate(rec_POInt."Ending Date ", GetValueAtCell(RowNo, 2));
            Evaluate(rec_POInt."Product Type", GetValueAtCell(RowNo, 3));
            Evaluate(rec_POInt."Product No.", GetValueAtCell(RowNo, 4));
            Evaluate(rec_POInt."Customer No.", GetValueAtCell(RowNo, 5));
            Evaluate(rec_POInt."Sales Currency Code", GetValueAtCell(RowNo, 6));
            Evaluate(rec_POInt."Unit Price", GetValueAtCell(RowNo, 7));
            Evaluate(rec_POInt."Purchase Price (LCY)", GetValueAtCell(RowNo, 8));
            Evaluate(rec_POInt."Purchase Currency Code", GetValueAtCell(RowNo, 9));
            Evaluate(rec_POInt."Vendor No.", GetValueAtCell(RowNo, 10));
            Evaluate(rec_POInt."Unit of Measure Code", GetValueAtCell(RowNo, 11));
            Evaluate(rec_POInt."Renesas Report Unit Price Cur.", GetValueAtCell(RowNo, 12));
            Evaluate(rec_POInt."Renesas Report Unit Price", GetValueAtCell(RowNo, 13));
            Evaluate(rec_POInt."ORE Debit Cost", GetValueAtCell(RowNo, 14));
            Evaluate(rec_POInt."Ship&Debit Flag", GetValueAtCell(RowNo, 15));
            Evaluate(rec_POInt."PC. Currency Code", GetValueAtCell(RowNo, 16));
            Evaluate(rec_POInt."PC. Direct Unit Cost", GetValueAtCell(RowNo, 17));
            Evaluate(rec_POInt."PC. Update Price", GetValueAtCell(RowNo, 18));
            Evaluate(rec_POInt."Price Line Status", GetValueAtCell(RowNo, 19));

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
