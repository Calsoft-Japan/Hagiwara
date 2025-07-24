report 50057 "Purchase Invoice HS"
{
    // CS092 FDD R052 Bobby.Ji 2025/7/22 - Upgade to the BC version
    ProcessingOnly = true;
    Caption = 'Export Purchase Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Posting Date";
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(> 0));

                trigger OnAfterGetRecord()
                begin

                    IF "Purch. Inv. Header"."Currency Factor" <> 0 THEN BEGIN
                        gDecBaseAmountLcy := ROUND(Amount / "Purch. Inv. Header"."Currency Factor", 0.01);
                        gDecInclVATAmountLcy := ROUND("Amount Including VAT" / "Purch. Inv. Header"."Currency Factor", 0.01);
                    END
                    ELSE BEGIN
                        gDecBaseAmountLcy := Amount;
                        gDecInclVATAmountLcy := "Amount Including VAT"
                    END;

                    gDecBaseAmountLcySub += gDecBaseAmountLcy;
                    gDecInclVATAmountLcySub += gDecInclVATAmountLcy;
                    gDecBaseAmountLcyTTL += gDecBaseAmountLcy;
                    gDecInclVATAmountLcyTTL += gDecInclVATAmountLcy;

                    RowNo += 1;
                    EnterCell(RowNo, 1, FORMAT("Purch. Inv. Header"."Posting Date"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                    EnterCell(RowNo, 2, "Purch. Inv. Header"."Pay-to Vendor No.", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 3, "Purch. Inv. Header"."Pay-to Name", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 4, "Purch. Inv. Header"."Currency Code", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 5, "Document No.", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 6, FORMAT("Line No."), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 7, "No.", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 8, Description, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 9, "Unit of Measure", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 10, FORMAT(Quantity), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 11, FORMAT("Direct Unit Cost"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 12, FORMAT(Amount), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 13, FORMAT("Amount Including VAT"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 14, FORMAT(gDecBaseAmountLcy), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 15, FORMAT(gDecInclVATAmountLcy), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                end;
            }

            trigger OnPreDataItem()
            begin

                RowNo := 1;
                EnterCell(RowNo, 1, 'Posting Date', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 2, GETFILTER("Posting Date"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                RowNo += 1;
                EnterCell(RowNo, 1, 'Posting Date', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 2, 'Pay-to Vendor No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 3, 'Pay-to Name', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 4, 'Currency Code', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 5, 'Document No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 6, 'Line No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 7, 'Item No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 8, 'Description', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 9, 'Unit of Measure', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 10, 'Quantity', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 11, 'Direct Unit Cost', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 12, 'Amount', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 13, 'Amount Including VAT', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 14, 'Amount(LCY)', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 15, 'Amount Including VAT(LCY)', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('','Purchase Invoice','Purchase Invoice',COMPANYNAME,USERID);
        ExcelBuf.CreateNewBook('Purchase Invoice');
        ExcelBuf.WriteSheet('Purchase Invoice', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('Purchase Invoice HS');
        ExcelBuf.OpenExcel();
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        RowNo: Integer;
        gDecBaseAmountLcy: Decimal;
        gDecInclVATAmountLcy: Decimal;
        gDecBaseAmountLcySub: Decimal;
        gDecInclVATAmountLcySub: Decimal;
        gDecBaseAmountLcyTTL: Decimal;
        gDecInclVATAmountLcyTTL: Decimal;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GBLN_ExportFlag: Boolean;

    local procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30]; CellType: Option)
    begin
        //RowNo:=RowNo+1;
        ExcelBuf.INIT;
        ExcelBuf.VALIDATE("Row No.", RowNo);
        ExcelBuf.VALIDATE("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf."Cell Type" := CellType;
        ExcelBuf.INSERT;
    end;
}

