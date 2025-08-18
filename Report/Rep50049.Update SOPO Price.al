report 50049 "Update SO/PO Price"
{
    // HG10.00.07 NJ 21/03/2018 - New report created
    // CS043 Kenya 2022/07/28 - Add Customer/Vendor No. Condition

    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.")
                                WHERE(Blocked = CONST(false));
            RequestFilterFields = "No.";
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", Type, "No.")
                                    WHERE("Document Type" = CONST(Order),
                                          Type = CONST(Item));

                trigger OnAfterGetRecord()
                var
                    SalesTargetDate: Date;
                begin
                    Window.UPDATE(2, "Document No.");

                    UnitPrice := 0;
                    IsPriceUpdate := false;
                    SalesTargetDate := ReqTargetDate;

                    IF "Quantity Invoiced" <> Quantity THEN BEGIN

                        Customer.get("Sales Line"."Sell-to Customer No.");
                        if Customer."Update SO Price Target Date" = Customer."Update SO Price Target Date"::"Shipment Date" then begin
                            SalesTargetDate := "Sales Line"."Shipment Date";
                        end;
                        if Customer."Update SO Price Target Date" = Customer."Update SO Price Target Date"::"Order Date" then begin
                            SalesHeader.get("Sales Line"."Document Type", "Sales Line"."Document No.");
                            SalesTargetDate := SalesHeader."Order Date";
                        end;

                        PriceList.Reset();
                        PriceList.SetRange("Asset Type", PriceList."Asset Type"::Item);
                        PriceList.SETRANGE("Asset No.", "No.");
                        PriceList.SetRange("Source Type", PriceList."Source Type"::Customer);
                        PriceList.SetRange("Source No.", "Sales Line"."Sell-to Customer No.");
                        PriceList.SetRange(Status, PriceList.Status::Active);
                        PriceList.SETRANGE("Starting Date", 0D, SalesTargetDate);
                        PriceList.SETFILTER("Ending Date", '%1|>=%2', 0D, SalesTargetDate);
                        IF PriceList.COUNT > 1 THEN begin
                            WriteSOPOLog("Sales Line", SalesTargetDate, 0, 0, TextMsgDuplicate);
                            CntError := CntError + 1;
                            CurrReport.Break();
                        end;

                        IF PriceList.FINDFIRST THEN BEGIN
                            UnitPrice := PriceList."Unit Price";
                        END;

                        IF "Unit Price" <> UnitPrice THEN BEGIN

                            WriteSOPOLog("Sales Line", SalesTargetDate, "Unit Price", UnitPrice, '');

                            //SuspendStatusCheck(TRUE);
                            VALIDATE("Unit Price", UnitPrice);
                            MODIFY;

                            CntUpdated := CntUpdated + 1;

                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Sales Line".SetFilter("Unit Price", '<>%1', 0);

                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", Type, "No.")
                                    WHERE("Document Type" = CONST(Order),
                                          Type = CONST(Item));

                trigger OnAfterGetRecord()
                var
                    PurchTargetDate: Date;
                begin
                    Window.UPDATE(2, "Document No.");

                    DirectUnitCost := 0;
                    IsPriceUpdate := false;
                    PurchTargetDate := ReqTargetDate;

                    IF "Quantity Invoiced" <> Quantity THEN BEGIN
                        Vendor.get("Purchase Line"."Buy-from Vendor No.");
                        if Vendor."Update PO Price Target Date" = Vendor."Update PO Price Target Date"::"Expected Receipt Date" then begin
                            PurchTargetDate := "Purchase Line"."Expected Receipt Date";
                        end;

                        if Vendor."Update PO Price Target Date" = Vendor."Update PO Price Target Date"::"Order Date" then begin
                            PurchHeader.get("Purchase Line"."Document Type", "Purchase Line"."Document No.");
                            PurchTargetDate := PurchHeader."Order Date";
                        end;

                        PriceList.Reset();
                        PriceList.SetRange("Asset Type", PriceList."Asset Type"::Item);
                        PriceList.SETRANGE("Asset No.", "No.");
                        PriceList.SetRange("Source Type", PriceList."Source Type"::Vendor);
                        PriceList.SetRange("Source No.", "Purchase Line"."Buy-from Vendor No.");
                        PriceList.SetRange(Status, PriceList.Status::Active);
                        PriceList.SETRANGE("Starting Date", 0D, PurchTargetDate);
                        PriceList.SETFILTER("Ending Date", '%1|>=%2', 0D, PurchTargetDate);
                        IF PriceList.COUNT > 1 THEN begin
                            WriteSOPOLog("Purchase Line", PurchTargetDate, 0, 0, TextMsgDuplicate);
                            CntError := CntError + 1;
                            CurrReport.Break();
                        end;

                        IF PriceList.FINDFIRST THEN BEGIN
                            DirectUnitCost := PriceList."Direct Unit Cost";
                        END;

                        IF "Direct Unit Cost" <> DirectUnitCost THEN BEGIN

                            WriteSOPOLog("Purchase Line", PurchTargetDate, "Direct Unit Cost", DirectUnitCost, '');

                            //SuspendStatusCheck(TRUE);
                            VALIDATE("Direct Unit Cost", DirectUnitCost);
                            MODIFY;

                            CntUpdated := CntUpdated + 1;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Purchase Line".SetFilter("Direct Unit Cost", '<>%1', 0);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, "No.");

            end;

            trigger OnPostDataItem()
            begin
                Window.CLOSE;

                Message(TextMsgResult, Format(CntUpdated), Format(CntError));
            end;

            trigger OnPreDataItem()
            var
                RecSalesLine: Record "Sales Line";
                RecPurchLine: Record "Purchase Line";
                UpdSalesLineExists: Boolean;
                UpdPurchLineExists: Boolean;
            begin

                UpdSalesLineExists := false;
                UpdPurchLineExists := false;
                RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                if RecSalesLine.FindSet() then begin
                    repeat
                        if RecSalesLine."Quantity Invoiced" <> RecSalesLine.Quantity then begin
                            UpdSalesLineExists := true;
                            break;
                        end;
                    until RecSalesLine.Next() = 0;
                end;

                if Not UpdSalesLineExists then begin

                    RecPurchLine.SetRange("Document Type", RecPurchLine."Document Type"::Order);
                    if RecPurchLine.FindSet() then begin
                        repeat
                            if RecPurchLine."Quantity Invoiced" <> RecPurchLine.Quantity then begin
                                UpdPurchLineExists := true;
                                break;
                            end;
                        until RecPurchLine.Next() = 0;
                    end;
                end;

                if (Not UpdSalesLineExists) and (Not UpdPurchLineExists) then begin
                    Error(TextErrNoData);

                end;

                Window.OPEN(Text001 + Text002 + Text003);

                SOPOEntryNo := 0;
                if SOPOPrice.FindLast() then begin
                    SOPOEntryNo := SOPOPrice."Entry No.";
                end;
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

    labels
    {
        ItemNoLbl = 'Item No.';
        DescriptionLbl = 'Description';
        CustomerNoLbl = 'Customer No.';
        OEMNoLbl = 'OEM No.';
        DateLbl = 'Date';
        PriceLbl = 'Price';
        CustomerItemNoLbl = 'Customer Item No';
        VendorNoLbl = 'Vendor No';
        PageLbl = 'Page';
        ReportLbl = 'Sales Price List';
    }

    trigger OnPreReport()
    begin
        IF ReqTargetDate = 0D THEN
            ReqTargetDate := WORKDATE;
    end;

    var
        ItemFilter: Text;
        ReqTargetDate: Date;
        Window: Dialog;
        Text001: Label 'Updating Price...\\';
        Text002: Label 'Item No. #1####################\';
        Text003: Label 'Order No. #2####################\';

        PriceList: Record "Price List Line";
        UnitPrice: Decimal;
        DirectUnitCost: Decimal;
        Text004: Label 'More than one %1 exist for item %2.';
        CustomerNo: Code[20];
        VendorNo: Code[20];
        Customer: Record Customer;
        Vendor: Record Vendor;
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        IsPriceUpdate: Boolean;
        SOPOEntryNo: Integer;
        SOPOPrice: Record "Update SOPO Price";
        TextErrNoData: Label 'No lines to process.';
        TextMsgDuplicate: Label 'Duplicate price conditions found.';
        TextMsgResult: Label 'Update completed.\%1 lines updated,\%2 errors occurred.\Please check the result details on the Update SO/PO Price page.';
        CntUpdated: Integer;
        CntError: Integer;

    local procedure WriteSOPOLog(pSalesLine: Record "Sales Line"; pTargetDate: Date; pOldPrice: Decimal; pNewPrice: Decimal; pErrMsg: Text[250])
    var
        myInt: Integer;
        RecSOPOPrice: Record "Update SOPO Price";
    begin
        SOPOEntryNo := SOPOEntryNo + 1;

        RecSOPOPrice.Init();
        RecSOPOPrice."Entry No." := SOPOEntryNo;
        RecSOPOPrice."Update Target Date" := pTargetDate;
        RecSOPOPrice."Document Type" := RecSOPOPrice."Document Type"::"Sales Order";
        RecSOPOPrice."Document No." := pSalesLine."Document No.";
        RecSOPOPrice."Line No." := pSalesLine."Line No.";
        RecSOPOPrice."Item No." := pSalesLine."No.";
        RecSOPOPrice."Item Description" := pSalesLine.Description;
        RecSOPOPrice."Old Price" := pOldPrice;
        RecSOPOPrice."New Price" := pNewPrice;
        RecSOPOPrice."Quantity Invoiced" := pSalesLine."Quantity Invoiced";
        RecSOPOPrice."Quantity" := pSalesLine.Quantity;
        RecSOPOPrice."Error Message" := pErrMsg;
        RecSOPOPrice."Log DateTime" := System.CurrentDateTime;
        RecSOPOPrice."User ID" := Database.UserId;

        RecSOPOPrice.Insert();

    end;

    local procedure WriteSOPOLog(pPurchLine: Record "Purchase Line"; pTargetDate: Date; pOldPrice: Decimal; pNewPrice: Decimal; pErrMsg: Text[250])
    var
        myInt: Integer;
        RecSOPOPrice: Record "Update SOPO Price";
    begin
        SOPOEntryNo := SOPOEntryNo + 1;

        RecSOPOPrice.Init();
        RecSOPOPrice."Entry No." := SOPOEntryNo;
        RecSOPOPrice."Update Target Date" := pTargetDate;
        RecSOPOPrice."Document Type" := RecSOPOPrice."Document Type"::"Purchase Order";
        RecSOPOPrice."Document No." := pPurchLine."Document No.";
        RecSOPOPrice."Line No." := pPurchLine."Line No.";
        RecSOPOPrice."Item No." := pPurchLine."No.";
        RecSOPOPrice."Item Description" := pPurchLine.Description;
        RecSOPOPrice."Old Price" := pOldPrice;
        RecSOPOPrice."New Price" := pNewPrice;
        RecSOPOPrice."Quantity Invoiced" := pPurchLine."Quantity Invoiced";
        RecSOPOPrice."Quantity" := pPurchLine.Quantity;
        RecSOPOPrice."Error Message" := pErrMsg;
        RecSOPOPrice."Log DateTime" := System.CurrentDateTime;
        RecSOPOPrice."User ID" := Database.UserId;

        RecSOPOPrice.Insert();

    end;
}

