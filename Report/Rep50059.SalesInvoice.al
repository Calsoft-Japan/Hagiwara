report 50059 "Sales Invoice"
{
    ProcessingOnly = true;
    Caption = 'Export Sales Invoiced';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "Posting Date";
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE(Quantity = FILTER(> 0));

                trigger OnAfterGetRecord()
                begin




                    IF "Sales Invoice Header"."Currency Factor" <> 0 THEN BEGIN
                        gDecBaseAmountLcy := ROUND(Amount / "Sales Invoice Header"."Currency Factor", 0.01);
                        gDecInclVATAmountLcy := ROUND("Amount Including VAT" / "Sales Invoice Header"."Currency Factor", 0.01);
                    END
                    ELSE BEGIN
                        gDecBaseAmountLcy := Amount;
                        gDecInclVATAmountLcy := "Amount Including VAT"
                    END;

                    gRcdItemLdgEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
                    gRcdItemLdgEntry.SETRANGE("Document No.", "Shipment No.");
                    gRcdItemLdgEntry.SETRANGE("Document Type", 1);
                    gRcdItemLdgEntry.SETRANGE("Document Line No.", "Shipment Line No.");

                    IF gRcdItemLdgEntry.FIND('-') THEN BEGIN
                        gRcdItemLdgEntry.CALCFIELDS("Cost Amount (Actual)");
                        gDecCOSAmount := gRcdItemLdgEntry."Cost Amount (Actual)";
                    END;
                    gDecCOSAmountSub += gDecCOSAmount;
                    gDecBaseAmountLcySub += gDecBaseAmountLcy;
                    gDecInclVATAmountLcySub += gDecInclVATAmountLcy;
                    gDecCOSAmountTTL += gDecCOSAmount;
                    gDecBaseAmountLcyTTL += gDecBaseAmountLcy;
                    gDecInclVATAmountLcyTTL += gDecInclVATAmountLcy;

                    RowNo += 1;
                    EnterCell(RowNo, 1, FORMAT("Sales Invoice Header"."Posting Date"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
                    EnterCell(RowNo, 2, "Sales Invoice Header"."Bill-to Customer No.", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 3, "Sales Invoice Header"."Bill-to Name", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 4, "Sales Invoice Header"."Currency Code", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 5, "Document No.", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 6, FORMAT("Line No."), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 7, "No.", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 8, Description, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 9, "Unit of Measure", FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                    EnterCell(RowNo, 10, FORMAT(Quantity), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 11, FORMAT("Sales Invoice Line"."Unit Price"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 12, FORMAT(Amount), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 13, FORMAT("Amount Including VAT"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 14, FORMAT(gDecBaseAmountLcy), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 15, FORMAT(gDecInclVATAmountLcy), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                    EnterCell(RowNo, 16, FORMAT(gDecCOSAmount), FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
                end;

                trigger OnPreDataItem()
                begin

                    gDecBaseAmountLcySub := 0;
                    gDecInclVATAmountLcySub := 0;
                    gDecCOSAmountSub := 0;
                end;
            }

            trigger OnPreDataItem()
            begin

                LastFieldNo := FIELDNO("No.");
                RowNo := 1;
                RowNo := 1;
                EnterCell(RowNo, 1, 'Posting Date', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 2, GETFILTER("Posting Date"), FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                RowNo += 1;
                EnterCell(RowNo, 1, 'Posting Date', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 2, 'Bill-to Customer No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 3, 'Bill-to Name', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 4, 'Currency Code', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 5, 'Document No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 6, 'Line No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 7, 'Item No.', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 8, 'Description', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 9, 'Unit of Measure', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 10, 'Quantity', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 11, 'Unit Price', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 12, 'Amount', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 13, 'Amount Including VAT', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 14, 'Amount(LCY)', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 15, 'Amount Including VAT(LCY)', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
                EnterCell(RowNo, 16, 'COST(CGOS)', FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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
        //ExcelBuf.CreateBookAndOpenExcel('','Sales Invoice','Sales Invoice',COMPANYNAME,USERID);
        ExcelBuf.CreateNewBook('Sales Invoice');
        ExcelBuf.WriteSheet('Sales Invoice', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.SetFriendlyFilename('Export Sales Invoiced');
        ExcelBuf.OpenExcel();
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        gDecBaseAmountLcy: Decimal;
        gDecInclVATAmountLcy: Decimal;
        gDecCOSAmount: Decimal;
        gDecBaseAmountLcySub: Decimal;
        gDecInclVATAmountLcySub: Decimal;
        gDecCOSAmountSub: Decimal;
        gDecBaseAmountLcyTTL: Decimal;
        gDecInclVATAmountLcyTTL: Decimal;
        gDecCOSAmountTTL: Decimal;
        gRcdItemLdgEntry: Record "Item Ledger Entry";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GBLN_ExportFlag: Boolean;
        RowNo: Integer;
        ExcelBuf: Record "Excel Buffer" temporary;

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

