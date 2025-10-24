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
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Document Type" = CONST(Order),
                                          Type = CONST(Item));

                trigger OnAfterGetRecord()
                var
                    SalesTargetDate: Date;
                    SalesHeader: Record "Sales Header";
                    PriceList_perCust: Record "Price List Line";
                    PriceList_allCust: Record "Price List Line";
                    Cnt_perCust: Integer;
                    Cnt_allCust: Integer;
                    HeaderStatus: Enum "Sales Document Status";
                begin
                    Window.UPDATE(2, "Document No.");

                    UnitPrice := 0;
                    IsPriceUpdate := false;
                    SalesTargetDate := ReqTargetDate;
                    Cnt_perCust := 0;
                    Cnt_allCust := 0;

                    IF "Quantity Invoiced" <> Quantity THEN BEGIN

                        SalesHeader.get("Sales Line"."Document Type", "Sales Line"."Document No.");
                        Customer.get("Sales Line"."Sell-to Customer No.");
                        if Customer."Update SO Price Target Date" = Customer."Update SO Price Target Date"::"Shipment Date" then begin
                            SalesTargetDate := "Sales Line"."Shipment Date";
                        end;
                        if Customer."Update SO Price Target Date" = Customer."Update SO Price Target Date"::"Order Date" then begin
                            SalesTargetDate := SalesHeader."Order Date";
                        end;

                        PriceList_perCust.Reset();
                        PriceList_perCust.SetRange("Asset Type", PriceList_perCust."Asset Type"::Item);
                        PriceList_perCust.SETRANGE("Asset No.", "No.");
                        PriceList_perCust.SetRange("Source Type", PriceList_perCust."Source Type"::Customer);
                        PriceList_perCust.SetRange("Source No.", "Sales Line"."Sell-to Customer No.");
                        PriceList_perCust.SetRange(Status, PriceList_perCust.Status::Active);
                        PriceList_perCust.SETRANGE("Starting Date", 0D, SalesTargetDate);
                        PriceList_perCust.SETFILTER("Ending Date", '%1|>=%2', 0D, SalesTargetDate);
                        PriceList_perCust.SETFILTER("Unit Price", '<>%1', 0);
                        Cnt_perCust := PriceList_perCust.Count;

                        PriceList_allCust.Reset();
                        PriceList_allCust.SetRange("Asset Type", PriceList_allCust."Asset Type"::Item);
                        PriceList_allCust.SETRANGE("Asset No.", "No.");
                        PriceList_allCust.SetRange("Source Type", PriceList_allCust."Source Type"::"All Customers");
                        PriceList_allCust.SetRange(Status, PriceList_allCust.Status::Active);
                        PriceList_allCust.SETRANGE("Starting Date", 0D, SalesTargetDate);
                        PriceList_allCust.SETFILTER("Ending Date", '%1|>=%2', 0D, SalesTargetDate);
                        PriceList_allCust.SETFILTER("Unit Price", '<>%1', 0);
                        Cnt_allCust := PriceList_allCust.Count;

                        IF (Cnt_perCust + Cnt_allCust) > 1 THEN begin

                            WriteSOPOLog("Sales Line", SalesTargetDate, "Unit Price", 0, TextMsgDuplicate);
                            CntError := CntError + 1;
                        end else if (Cnt_perCust + Cnt_allCust) = 1 then begin

                            IF PriceList_perCust.FINDFIRST THEN BEGIN
                                UnitPrice := PriceList_perCust."Unit Price";
                            END else if PriceList_allCust.FINDFIRST THEN BEGIN
                                UnitPrice := PriceList_allCust."Unit Price";
                            END;

                            IF (UnitPrice <> 0) and ("Unit Price" <> UnitPrice) THEN BEGIN

                                WriteSOPOLog("Sales Line", SalesTargetDate, "Unit Price", UnitPrice, '');

                                HeaderStatus := SalesHeader.Status;
                                if HeaderStatus <> SalesHeader.Status::Open then begin
                                    SalesHeader.Status := SalesHeader.Status::Open;
                                    SalesHeader.Modify();
                                end;

                                VALIDATE("Unit Price", UnitPrice);
                                MODIFY;

                                if HeaderStatus <> SalesHeader.Status::Open then begin
                                    SalesHeader.Status := HeaderStatus;
                                    SalesHeader.Modify();
                                end;

                                CntUpdated := CntUpdated + 1;

                            end;
                        end; // if (Cnt_perCust + Cnt_allCust) = 1
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Sales Line".SetFilter("Unit Price", '<>%1', 0);
                    "Sales Line".SetRange("Price Target Update", true);

                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Document Type" = CONST(Order),
                                          Type = CONST(Item));

                trigger OnAfterGetRecord()
                var
                    PurchTargetDate: Date;
                    PurchHeader: Record "Purchase Header";
                    PriceList_perVend: Record "Price List Line";
                    PriceList_allVend: Record "Price List Line";
                    Cnt_perVend: Integer;
                    Cnt_allVend: Integer;
                    HeaderStatus: enum "Purchase Document Status";
                begin
                    Window.UPDATE(2, "Document No.");

                    DirectUnitCost := 0;
                    IsPriceUpdate := false;
                    PurchTargetDate := ReqTargetDate;
                    Cnt_perVend := 0;
                    Cnt_allVend := 0;

                    IF "Quantity Invoiced" <> Quantity THEN BEGIN
                        PurchHeader.get("Purchase Line"."Document Type", "Purchase Line"."Document No.");
                        Vendor.get("Purchase Line"."Buy-from Vendor No.");
                        if Vendor."Update PO Price Target Date" = Vendor."Update PO Price Target Date"::"Expected Receipt Date" then begin
                            PurchTargetDate := "Purchase Line"."Expected Receipt Date";
                        end;

                        if Vendor."Update PO Price Target Date" = Vendor."Update PO Price Target Date"::"Order Date" then begin
                            PurchTargetDate := PurchHeader."Order Date";
                        end;

                        PriceList_perVend.Reset();
                        PriceList_perVend.SetRange("Asset Type", PriceList_perVend."Asset Type"::Item);
                        PriceList_perVend.SETRANGE("Asset No.", "No.");
                        PriceList_perVend.SetRange("Source Type", PriceList_perVend."Source Type"::Vendor);
                        PriceList_perVend.SetRange("Source No.", "Purchase Line"."Buy-from Vendor No.");
                        PriceList_perVend.SetRange(Status, PriceList_perVend.Status::Active);
                        PriceList_perVend.SETRANGE("Starting Date", 0D, PurchTargetDate);
                        PriceList_perVend.SETFILTER("Ending Date", '%1|>=%2', 0D, PurchTargetDate);
                        PriceList_perVend.SETFILTER("Direct Unit Cost", '<>%1', 0);
                        Cnt_perVend := PriceList_perVend.Count;

                        PriceList_allVend.Reset();
                        PriceList_allVend.SetRange("Asset Type", PriceList_allVend."Asset Type"::Item);
                        PriceList_allVend.SETRANGE("Asset No.", "No.");
                        PriceList_allVend.SetRange("Source Type", PriceList_allVend."Source Type"::"All Vendors");
                        PriceList_allVend.SetRange(Status, PriceList_allVend.Status::Active);
                        PriceList_allVend.SETRANGE("Starting Date", 0D, PurchTargetDate);
                        PriceList_allVend.SETFILTER("Ending Date", '%1|>=%2', 0D, PurchTargetDate);
                        PriceList_allVend.SETFILTER("Direct Unit Cost", '<>%1', 0);
                        Cnt_allVend := PriceList_allVend.Count;

                        IF (Cnt_perVend + Cnt_allVend) > 1 THEN begin
                            WriteSOPOLog("Purchase Line", PurchTargetDate, "Direct Unit Cost", 0, TextMsgDuplicate);
                            CntError := CntError + 1;
                        end else if (Cnt_perVend + Cnt_allVend) = 1 THEN begin

                            IF PriceList_perVend.FINDFIRST THEN BEGIN
                                DirectUnitCost := PriceList_perVend."Direct Unit Cost";
                            END else IF PriceList_allVend.FINDFIRST THEN BEGIN
                                DirectUnitCost := PriceList_allVend."Direct Unit Cost";
                            END;

                            IF (DirectUnitCost <> 0) and ("Direct Unit Cost" <> DirectUnitCost) THEN BEGIN
                                WriteSOPOLog("Purchase Line", PurchTargetDate, "Direct Unit Cost", DirectUnitCost, '');

                                HeaderStatus := PurchHeader.Status;
                                if HeaderStatus <> PurchHeader.Status::Open then begin
                                    PurchHeader.Status := PurchHeader.Status::Open;
                                    PurchHeader.Modify();
                                end;

                                VALIDATE("Direct Unit Cost", DirectUnitCost);
                                MODIFY;

                                if HeaderStatus <> PurchHeader.Status::Open then begin
                                    PurchHeader.Status := HeaderStatus;
                                    PurchHeader.Modify();
                                end;

                                CntUpdated := CntUpdated + 1;

                            end;
                        end; //if (Cnt_perVend + Cnt_allVend) = 1
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Purchase Line".SetFilter("Direct Unit Cost", '<>%1', 0);
                    "Purchase Line".SetRange("Price Target Update", true);
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
                        ApplicationArea = All;
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

    trigger OnInitReport()

    begin
        SOPOEntryNo := 0;
        if SOPOPrice.FindLast() then begin
            SOPOEntryNo := SOPOPrice."Entry No.";
        end;

        CurDateTime := System.CurrentDateTime;
    end;


    var
        ItemFilter: Text;
        ReqTargetDate: Date;
        CurDateTime: DateTime;
        Window: Dialog;
        Text001: Label 'Updating Price...\\';
        Text002: Label 'Item No. #1####################\';
        Text003: Label 'Order No. #2####################\';

        UnitPrice: Decimal;
        DirectUnitCost: Decimal;
        Text004: Label 'More than one %1 exist for item %2.';
        CustomerNo: Code[20];
        VendorNo: Code[20];
        Customer: Record Customer;
        Vendor: Record Vendor;
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
        RecSOPOPrice."Log DateTime" := CurDateTime;
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
        RecSOPOPrice."Log DateTime" := CurDateTime;
        RecSOPOPrice."User ID" := Database.UserId;

        RecSOPOPrice.Insert();

    end;
}

