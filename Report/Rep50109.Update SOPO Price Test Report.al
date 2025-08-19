report 50109 "Update SO/PO Price Test Report"
{

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Update SOPO Price Test Report.rdlc';

    Caption = 'Update SO/PO Price Test Report';

    dataset
    {
        dataitem(UpdateSOPOPriceTest; "Update SOPO Price")
        {
            UseTemporary = true;

            column(ReportName; 'Update SO/PO Price Test Report') { }
            column(CompanyName; Database.CompanyName) { }
            column(DocumentType; Format("Document Type")) { }
            column(DocumentNo; "Document No.") { }
            column(LineNo; "Line No.") { }
            column(ItemNo; "Item No.") { }
            column(ItemDescription; "Item Description") { }
            column(OldPrice; "Old Price") { }
            column(NewPrice; "New Price") { }
            column(QuantityInvoiced; "Quantity Invoiced") { }
            column(Quantity; "Quantity") { }
            column(ErrorMessage; "Error Message") { }
            column(UpdateTargetDate; 'Update Target Date    ' + FORMAT(ReqTargetDate, 0, 4)) { }
            column(LblDocumentType; LblDocumentType) { }
            column(LblDocumentNo; LblDocumentNo) { }
            column(LblLineNo; LblLineNo) { }
            column(LblItemNo; LblItemNo) { }
            column(LblItemDescription; LblItemDescription) { }
            column(LblOldPrice; LblOldPrice) { }
            column(LblNewPrice; LblNewPrice) { }
            column(LblQuantityInvoiced; LblQuantityInvoiced) { }
            column(LblQuantity; LblQuantity) { }
            column(LblErrorMessage; LblErrorMessage) { }

            trigger OnPreDataItem()
            var
                myInt: Integer;
            begin

                RepUpdateSOPOPrice.UseRequestPage := false;
                RepUpdateSOPOPrice.SetTargetDate(ReqTargetDate);
                RepUpdateSOPOPrice.SetRunForTestReport(true);
                RepUpdateSOPOPrice.Run();
                RepUpdateSOPOPrice.GetTestReportData(UpdateSOPOPriceTest);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ReqTargetDate; ReqTargetDate)
                    {
                        Caption = 'Target Date';
                        NotBlank = true;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ReqTargetDate := WORKDATE;
        end;
    }

    trigger OnPreReport()
    begin
        IF ReqTargetDate = 0D THEN
            ReqTargetDate := WORKDATE;

    end;

    var
        RepUpdateSOPOPrice: Report "Update SO/PO Price";
        ReqTargetDate: Date;
        LblDocumentType: Label 'Document Type';
        LblDocumentNo: Label 'Document No.';
        LblLineNo: Label 'Line No.';
        LblItemNo: Label 'Item No.';
        LblItemDescription: Label 'Item Description';
        LblOldPrice: Label 'Old Price';
        LblNewPrice: Label 'New Price';
        LblQuantityInvoiced: Label 'Quantity Invoiced';
        LblQuantity: Label 'Quantity';
        LblErrorMessage: Label 'Error Message';

}

