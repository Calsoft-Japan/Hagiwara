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
        EntryNoNotValid: Label 'Entry No. is not valid.';
        EntryNoRequested: Label 'Entry No. is requested, can''t be empty.';
        EntryNoDuplicated: Label 'Entry No. is duplicated.';
        MaximumOrderQuantityNotValid: Label 'Maximum Order Quantity is not valid.';
        ApplicationMethodMsg: Label 'Application Method is not valid.';
        PartnerTypeMsg: Label 'Partner Type is not valid.';
        UpdatePOPriceTargetDateMsg: Label 'Update PO Price Target Date is not valid.';
        BlockedMsg: Label 'Blocked is not valid.';

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
        rec_POInt: Record "Vendor Import Line";
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        EntryNoStr: Text;
        EntryNo: Integer;
        ApplicationMethodStr: Text;
        PartnerTypeStr: Text;
        UpdatePOriceTargetDateStr: Text;
        BlockedStr: Text;
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

            //----------------------Preparing for the check----------------------
            EntryNoStr := GetValueAtCell(RowNo, 1).Trim();
            ApplicationMethodStr := GetValueAtCell(RowNo, 27).Trim();
            PartnerTypeStr := GetValueAtCell(RowNo, 44).Trim();
            UpdatePOriceTargetDateStr := GetValueAtCell(RowNo, 69).Trim();
            BlockedStr := GetValueAtCell(RowNo, 71).Trim();

            //-------------------------------Check-------------------------------
            if (EntryNoStr = '') then begin
                Error(EntryNoRequested);
            end;
            if (not Evaluate(EntryNo, EntryNoStr)) then begin
                Error(EntryNoNotValid);
            end;
            if rec_POInt.get(G_BatchName, EntryNo) then begin
                Error(EntryNoDuplicated);
            end;

            //Option Value Check
            //Application Method
            if (not Evaluate(rec_POInt."Application Method", ApplicationMethodStr)) then begin
                Error(ApplicationMethodMsg);
            end;

            //Partner Type
            if (not Evaluate(rec_POInt."Partner Type", PartnerTypeStr)) then begin
                Error(PartnerTypeMsg);
            end;

            //Update PO Price Target Date
            if (not Evaluate(rec_POInt."Update PO Price Target Date", UpdatePOriceTargetDateStr)) then begin
                Error(UpdatePOPriceTargetDateMsg);
            end;

            //Blocked
            if (not Evaluate(rec_POInt."Blocked", BlockedStr)) then begin
                Error(BlockedMsg);
            end;

            //----------------------Set values for each item----------------------
            rec_POInt."Batch Name" := G_BatchName;
            rec_POInt."Entry No." := EntryNo;
            Evaluate(rec_POInt."No.", GetValueAtCell(RowNo, 2));
            Evaluate(rec_POInt."Name", GetValueAtCell(RowNo, 3));
            Evaluate(rec_POInt."Search Name", GetValueAtCell(RowNo, 4));
            Evaluate(rec_POInt."Name 2", GetValueAtCell(RowNo, 5));
            Evaluate(rec_POInt."Address", GetValueAtCell(RowNo, 6));
            Evaluate(rec_POInt."Address 2", GetValueAtCell(RowNo, 7));
            Evaluate(rec_POInt."City", GetValueAtCell(RowNo, 8));
            Evaluate(rec_POInt."Contact", GetValueAtCell(RowNo, 9));
            Evaluate(rec_POInt."Phone No.", GetValueAtCell(RowNo, 10));
            Evaluate(rec_POInt."Our Account No.", GetValueAtCell(RowNo, 11));
            Evaluate(rec_POInt."Global Dimension 1 Code", GetValueAtCell(RowNo, 12));
            Evaluate(rec_POInt."Global Dimension 2 Code", GetValueAtCell(RowNo, 13));
            Evaluate(rec_POInt."Vendor Posting Group", GetValueAtCell(RowNo, 14));
            Evaluate(rec_POInt."Currency Code", GetValueAtCell(RowNo, 15));
            Evaluate(rec_POInt."Language Code", GetValueAtCell(RowNo, 16));
            Evaluate(rec_POInt."Statistics Group", GetValueAtCell(RowNo, 17));
            Evaluate(rec_POInt."Payment Terms Code", GetValueAtCell(RowNo, 18));
            Evaluate(rec_POInt."Fin. Charge Terms Code", GetValueAtCell(RowNo, 19));
            Evaluate(rec_POInt."Purchaser Code", GetValueAtCell(RowNo, 20));
            Evaluate(rec_POInt."Shipment Method Code", GetValueAtCell(RowNo, 21));
            Evaluate(rec_POInt."Shipping Agent Code", GetValueAtCell(RowNo, 22));
            Evaluate(rec_POInt."Invoice Disc. Code", GetValueAtCell(RowNo, 23));
            Evaluate(rec_POInt."Country/Region Code", GetValueAtCell(RowNo, 24));
            Evaluate(rec_POInt."Pay-to Vendor No.", GetValueAtCell(RowNo, 25));
            Evaluate(rec_POInt."Payment Method Code", GetValueAtCell(RowNo, 26));
            Evaluate(rec_POInt."Application Method", GetValueAtCell(RowNo, 27));
            Evaluate(rec_POInt."Prices Including VAT", GetValueAtCell(RowNo, 28));
            Evaluate(rec_POInt."Fax No.", GetValueAtCell(RowNo, 29));
            Evaluate(rec_POInt."VAT Registration No.", GetValueAtCell(RowNo, 30));
            Evaluate(rec_POInt."Gen. Bus. Posting Group", GetValueAtCell(RowNo, 31));
            Evaluate(rec_POInt."GLN", GetValueAtCell(RowNo, 32));
            Evaluate(rec_POInt."Post Code", GetValueAtCell(RowNo, 33));
            Evaluate(rec_POInt."County", GetValueAtCell(RowNo, 34));
            Evaluate(rec_POInt."E-Mail", GetValueAtCell(RowNo, 35));
            Evaluate(rec_POInt."Home Page", GetValueAtCell(RowNo, 36));
            Evaluate(rec_POInt."No. Series", GetValueAtCell(RowNo, 37));
            Evaluate(rec_POInt."Tax Area Code", GetValueAtCell(RowNo, 38));
            Evaluate(rec_POInt."Tax Liable", GetValueAtCell(RowNo, 39));
            Evaluate(rec_POInt."VAT Bus. Posting Group", GetValueAtCell(RowNo, 40));
            Evaluate(rec_POInt."Block Payment Tolerance", GetValueAtCell(RowNo, 41));
            Evaluate(rec_POInt."IC Partner Code", GetValueAtCell(RowNo, 42));
            Evaluate(rec_POInt."Prepayment %", GetValueAtCell(RowNo, 43));
            Evaluate(rec_POInt."Partner Type", GetValueAtCell(RowNo, 44));
            Evaluate(rec_POInt."Creditor No.", GetValueAtCell(RowNo, 45));
            Evaluate(rec_POInt."Cash Flow Payment Terms Code", GetValueAtCell(RowNo, 46));
            Evaluate(rec_POInt."Primary Contact No.", GetValueAtCell(RowNo, 47));
            Evaluate(rec_POInt."Responsibility Center", GetValueAtCell(RowNo, 48));
            Evaluate(rec_POInt."Location Code", GetValueAtCell(RowNo, 49));
            Evaluate(rec_POInt."Lead Time Calculation", GetValueAtCell(RowNo, 50));
            Evaluate(rec_POInt."ID No.", GetValueAtCell(RowNo, 51));
            Evaluate(rec_POInt."Shipping Terms", GetValueAtCell(RowNo, 52));
            Evaluate(rec_POInt."Incoterm Code", GetValueAtCell(RowNo, 53));
            Evaluate(rec_POInt."Incoterm Location", GetValueAtCell(RowNo, 54));
            Evaluate(rec_POInt."Manufacturer Code", GetValueAtCell(RowNo, 55));
            Evaluate(rec_POInt."ORE Reverse Routing Address", GetValueAtCell(RowNo, 56));
            Evaluate(rec_POInt."Excluded in ORE Collection", GetValueAtCell(RowNo, 57));
            Evaluate(rec_POInt."ORE Reverse Routing Address SD", GetValueAtCell(RowNo, 58));
            Evaluate(rec_POInt."Hagiwara Group", GetValueAtCell(RowNo, 59));
            Evaluate(rec_POInt."Familiar Name", GetValueAtCell(RowNo, 60));
            Evaluate(rec_POInt."Pay-to Address", GetValueAtCell(RowNo, 61));
            Evaluate(rec_POInt."Pay-to Address 2", GetValueAtCell(RowNo, 62));
            Evaluate(rec_POInt."Pay-to City", GetValueAtCell(RowNo, 63));
            Evaluate(rec_POInt."Pay-to Post Code", GetValueAtCell(RowNo, 64));
            Evaluate(rec_POInt."Pay-to County", GetValueAtCell(RowNo, 65));
            Evaluate(rec_POInt."Pay-to Country/Region Code", GetValueAtCell(RowNo, 66));
            Evaluate(rec_POInt."Exclude Check", GetValueAtCell(RowNo, 67));
            Evaluate(rec_POInt."Update PO Price Target Date", GetValueAtCell(RowNo, 68));
            Evaluate(rec_POInt."IRS 1099 Code", GetValueAtCell(RowNo, 69));
            Evaluate(rec_POInt."Blocked", GetValueAtCell(RowNo, 70));

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
