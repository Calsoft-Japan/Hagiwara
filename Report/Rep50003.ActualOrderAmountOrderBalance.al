report 50003 "ActualOrderAmountOrderBalance"
{
    ApplicationArea = All;
    Caption = 'Actual Order Amount & Order Balance';
    UsageCategory = ReportsAndAnalysis;

    DefaultRenderingLayout = ExecelLayout;

    dataset
    {
        // 2.4.1	Date Sheet
        dataitem(DateSheet; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(From; StartDate)
            {
            }
            column(To; EndDate)
            {
            }
        }

        // 2.4.2	Remaining Sales Order Sheet
        dataitem(RemainingSalesOrder; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
            //RequestFilterFields = "Document Type", "Outstanding Quantity";
            RequestFilterHeading = 'Remaining Sales Orders';
            column(SO_DocumentType; "Document Type")
            {
            }
            column(SO_DocumentNo; "Document No.")
            {
            }
            column(SO_SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(SO_Type; "Type")
            {
            }
            column(SO_No; "No.")
            {
            }
            column(SO_CustomerItemNo; "Customer Item No.")
            {
            }
            column(SO_PartsNo; "Parts No.")
            {
            }
            column(SO_Rank; Rank)
            {
            }
            column(SO_Products; "Products")
            {
            }
            column(SO_OEMNo; "OEM No.")
            {
            }
            column(SO_OrderDate; OrderDate)
            {
            }
            column(SO_PromisedDeliveryDate1; "Promised Delivery Date_1")
            {
            }
            column(SO_RequestedDeliveryDate1; "Requested Delivery Date_1")
            {
            }
            column(SO_Description; "Description")
            {
            }
            column(SO_CustomerOrderNo; "Customer Order No.")
            {
            }
            column(SO_LocationCode; "Location Code")
            {
            }
            column(SO_Reserve; "Reserve")
            {
            }
            column(SO_Quantity; "Quantity")
            {
            }
            column(SO_ReservedQtyBase; "Reserved Qty. (Base)")
            {
            }
            column(SO_FullyReserved; "Fully Reserved")
            {
            }
            column(SO_UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(SO_UnitPriceExcl_VAT; "Unit Price")
            {
            }
            column(SO_UnitCost; "Unit Cost")
            {
            }
            column(SO_UnitCost_LCY; "Unit Cost (LCY)")
            {
            }
            column(SO_LineAmountExclVAT; "Line Amount")
            {
            }
            column(SO_LineAmountExclVATLCY; RemainingSOAmountLCY)
            {
            }
            column(SO_ShipmentDate; "Shipment Date")
            {
            }
            column(SO_OutstandingQuantity; "Outstanding Quantity")
            {
            }
            column(SO_OutstandingQtyBase; "Outstanding Qty. (Base)")
            {
            }
            column(SO_Calculated; "Unit Price" * "Outstanding Quantity")
            {
            }
            column(SO_CustomerPostingGroup; CustPostingGroup)
            {
            }

            trigger OnPreDataItem()
            begin
                RemainingSalesOrder.SetRange("Document Type", RemainingSalesOrder."Document Type"::Order);
                RemainingSalesOrder.SetFilter("Outstanding Quantity", '>%1', 0);
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                Cust: Record Customer;
                SalesHeader: Record "Sales Header";
            begin
                Cust.get(RemainingSalesOrder."Sell-to Customer No.");
                CustPostingGroup := Cust."Customer Posting Group";

                SalesHeader.get(RemainingSalesOrder."Document Type", RemainingSalesOrder."Document No.");
                OrderDate := SalesHeader."Order Date";

                RemainingSOAmountLCY := CalcRemSOAmountLCY(RemainingSalesOrder);
            end;

        }

        //2.4.3	Sales Order Actual Sheet
        dataitem(SalesOrderActual; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            //RequestFilterFields = "Order Date", "Customer Posting Group";
            RequestFilterHeading = 'Sales Order - Actual';
            column(ACT_ShipmentDate; "Shipment Date")
            {
            }
            column(ACT_PostingDate; "Posting Date")
            {
            }
            column(ACT_DocumentDate; "Document Date")
            {
            }
            column(ACT_No; "No.")
            {
            }
            column(ACT_CustomerNo; "Sell-to Customer No.")
            {
            }
            column(ACT_Customer; "Sell-to Customer Name")
            {
            }
            column(ACT_OrderNo; "Order No.")
            {
            }
            column(ACT_OEMNo; "OEM No.")
            {
            }
            column(ACT_OEMName; "OEM Name")
            {
            }
            column(ACT_CurrencyCode; "Currency Code")
            {
            }
            column(ACT_DueDate; "Due Date")
            {
            }
            column(ACT_Amount; "Amount")
            {
            }
            column(ACT_AmountLCY; InvoiceAmountLCY)
            {
            }
            column(ACT_AmountIncludingVAT; "Amount Including VAT")
            {
            }
            column(ACT_ExternalDocumentNo; "External Document No.")
            {
            }
            column(ACT_RemainingAmount; "Remaining Amount")
            {
            }
            column(ACT_LocationCode; "Location Code")
            {
            }
            column(ACT_PrintedNo; "No. Printed")
            {
            }
            column(ACT_Closed; "Closed")
            {
            }
            column(ACT_Cancelled; "Cancelled")
            {
            }
            column(ACT_Corrective; "Corrective")
            {
            }
            column(ACT_ShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(ACT_CustomerGroupCode; CustomerGroupCode)
            {
            }
            column(ACT_CustomerPostingGroup; "Customer Posting Group")
            {
            }

            trigger OnPreDataItem()
            begin
                SalesOrderActual.SETFILTER("Order Date", '%1..%2', StartDate, EndDate);
                SalesOrderActual.SETFILTER("Customer Posting Group", '%1|%2', '3RD TRAD', 'GROUP TRAD');
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
                Cust: Record Customer;
                SalesInvoiceHeader: Record "Sales Invoice Header";
            begin
                Cust.get(SalesOrderActual."Sell-to Customer No.");
                CustomerGroupCode := Cust."Customer Group";

                InvoiceAmountLCY := CalcInvoiceAmountLCY(SalesOrderActual);
            end;

        }

        // 2.4.4	Sales Order Balance Sheet
        dataitem(SalesOrderBalance; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            //RequestFilterFields = "Order Date", "Customer Posting Group", "Posting Date";
            RequestFilterHeading = 'Sales Order - Balance';
            column(BAL_ShipmentDate; "Shipment Date")
            {
            }
            column(BAL_PostingDate; "Posting Date")
            {
            }
            column(BAL_DocumentDate; "Document Date")
            {
            }
            column(BAL_No; "No.")
            {
            }
            column(BAL_CustomerNo; "Sell-to Customer No.")
            {
            }
            column(BAL_Customer; "Sell-to Customer Name")
            {
            }
            column(BAL_OrderNo; "Order No.")
            {
            }
            column(BAL_OEMNo; "OEM No.")
            {
            }
            column(BAL_OEMName; "OEM Name")
            {
            }
            column(BAL_CurrencyCode; "Currency Code")
            {
            }
            column(BAL_DueDate; "Due Date")
            {
            }
            column(BAL_Amount; "Amount")
            {
            }
            column(BAL_AmountLCY; InvoiceAmountLCY)
            {
            }
            column(BAL_AmountIncludingVAT; "Amount Including VAT")
            {
            }
            column(BAL_ExternalDocumentNo; "External Document No.")
            {
            }
            column(BAL_RemainingAmount; "Remaining Amount")
            {
            }
            column(BAL_LocationCode; "Location Code")
            {
            }
            column(BAL_PrintedNo; "No. Printed")
            {
            }
            column(BAL_Closed; "Closed")
            {
            }
            column(BAL_Cancelled; "Cancelled")
            {
            }
            column(BAL_Corrective; "Corrective")
            {
            }
            column(BAL_ShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(BAL_CustomerGroupCode; CustomerGroupCode)
            {
            }
            column(BAL_CustomerPostingGroup; "Customer Posting Group")
            {
            }

            trigger OnPreDataItem()
            begin
                SalesOrderBalance.SETFILTER("Order Date", '..%1', EndDate);
                SalesOrderBalance.SETFILTER("Customer Posting Group", '%1|%2', '3RD TRAD', 'GROUP TRAD');
                SalesOrderBalance.SETFILTER("Posting Date", '%1..', StartDate);
            end;

            trigger OnAfterGetRecord()
            begin
                InvoiceAmountLCY := CalcInvoiceAmountLCY(SalesOrderBalance);
            end;

        }

        // 2.4.5	Customer Sheet
        dataitem(CustomerSheet; "Customer")
        {
            DataItemTableView = SORTING("No.");
            column(CU_No; "No.")
            {
            }
            column(CU_FamiliarName; "Familiar Name")
            {
            }
            column(CU_Name; "Name")
            {
            }
            column(CU_CountryRegionCode; "Country/Region Code")
            {
            }
            column(CU_County; "County")
            {
            }
            column(CU_CustomerPostingGroup; "Customer Posting Group")
            {
            }
            column(CU_ShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(CU_ShippingAgentCode; "Shipping Agent Code")
            {
            }

            trigger OnPreDataItem()
            begin
                CustomerSheet.SETFILTER(Blocked, '=%1', CustomerSheet.Blocked::" ");
            end;
        }

    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(From; StartDate)
                    {
                        Caption = 'From';
                        NotBlank = true;
                    }
                    field(To; EndDate)
                    {
                        Caption = 'To';
                        NotBlank = true;
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }

        trigger OnOpenPage()
        begin
            StartDate := CALCDATE('<-CM-3M>', WORKDATE);
            EndDate := CALCDATE('<CM-1M>', WORKDATE)
        end;
    }
    rendering
    {
        layout(ExecelLayout)
        {
            Type = Excel;
            LayoutFile = './XLSX/ActualOrderAmountOrderBalance.xlsx';
            ExcelLayoutMultipleDataSheets = true;
        }
    }
    procedure CalcRemSOAmountLCY(pSalesLine: Record "Sales Line"): Decimal
    var
        SalesHeader: Record "Sales Header";
        CurrencyLocal: Record Currency;
        rtnAmountLCY: Decimal;
    begin
        SalesHeader.get(pSalesLine."Document Type", pSalesLine."Document No.");
        CurrencyLocal.InitRoundingPrecision();
        if SalesHeader."Currency Code" <> '' then
            rtnAmountLCY :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  pSalesLine.GetDate(), pSalesLine."Currency Code",
                  pSalesLine."Line Amount", SalesHeader."Currency Factor"),
                CurrencyLocal."Amount Rounding Precision")
        else
            rtnAmountLCY :=
              Round(pSalesLine."Line Amount", CurrencyLocal."Amount Rounding Precision");

        exit(rtnAmountLCY);
    end;

    procedure CalcInvoiceAmountLCY(pSalesInvoiceHeader: Record "Sales Invoice Header"): Decimal
    var
        CurrencyLocal: Record Currency;
        rtnAmountLCY: Decimal;
    begin
        CurrencyLocal.InitRoundingPrecision();
        if pSalesInvoiceHeader."Currency Code" <> '' then
            rtnAmountLCY :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  pSalesInvoiceHeader."Posting Date", pSalesInvoiceHeader."Currency Code",
                  pSalesInvoiceHeader.Amount, pSalesInvoiceHeader."Currency Factor"),
                CurrencyLocal."Amount Rounding Precision")
        else
            rtnAmountLCY :=
              Round(pSalesInvoiceHeader.Amount, CurrencyLocal."Amount Rounding Precision");

        exit(rtnAmountLCY);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        CustPostingGroup: Code[20];
        CustomerGroupCode: Code[20];
        OrderDate: Date;
        RemainingSOAmountLCY: Decimal;
        InvoiceAmountLCY: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";

}
