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
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
        }

        // 2.4.2	Remaining Sales Order Sheet
        dataitem(RemainingSalesOrder; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Document Type" = CONST(Order));
            //RequestFilterFields = "Document Type", "Outstanding Quantity";
            RequestFilterHeading = 'Remaining Sales Orders';
            column(DocumentType; "Document Type")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(SelltoCustomerNo; "Sell-to Customer No.")
            {
            }
            column(Type; "Type")
            {
            }
            column(No; "No.")
            {
            }
            column(CustomerItemNo; "Customer Item No.")
            {
            }
            column(PartsNo; "Parts No.")
            {
            }
            column(Rank; Rank)
            {
            }
            column(Products; "Products")
            {
            }
            column(OEMNo; "OEM No.")
            {
            }
            column(OrderDate; OrderDate)
            {
            }
            column(PromisedDeliveryDate1; "Promised Delivery Date_1")
            {
            }
            column(RequestedDeliveryDate1; "Requested Delivery Date_1")
            {
            }
            column(Description; "Description")
            {
            }
            column(CustomerOrderNo; "Customer Order No.")
            {
            }
            column(LocationCode; "Location Code")
            {
            }
            column(Reserve; "Reserve")
            {
            }
            column(Quantity; "Quantity")
            {
            }
            column(ReservedQtyBase; "Reserved Qty. (Base)")
            {
            }
            column(FullyReserved; "Fully Reserved")
            {
            }
            column(UnitofMeasureCode; "Unit of Measure Code")
            {
            }
            column(UnitPriceExcl_VAT; "Unit Price")
            {
            }
            column(UnitCost; "Unit Cost")
            {
            }
            column(UnitCost_LCY; "Unit Cost (LCY)")
            {
            }
            column(LineAmountExclVAT; "Line Amount")
            {
            }
            column(LineAmountExclVATLCY; RemainingSOAmountLCY)
            {
                //ToDo
                //should be LCY Amount.
            }
            column(ShipmentDate; "Shipment Date")
            {
            }
            column(OutstandingQuantity; "Outstanding Quantity")
            {
            }
            column(OutstandingQtyBase; "Outstanding Qty. (Base)")
            {
            }
            column(Calculated; "Unit Price" * "Outstanding Quantity")
            {
            }
            column(CustomerPostingGroup; CustPostingGroup)
            {
            }

            trigger OnPreDataItem()
            begin
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
            column(ShipmentDate111; "Shipment Date")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(No111; "No.")
            {
            }
            column(CustomerNo; "Sell-to Customer No.")
            {
            }
            column(Customer; "Sell-to Customer Name")
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(OEMNo111; "OEM No.")
            {
            }
            column(OEMName; "OEM Name")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(Amount; "Amount")
            {
            }
            column(AmountLCY; "Amount")
            {
                //ToDo
                //should be LCY Amount.
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(RemainingAmount; "Remaining Amount")
            {
            }
            column(LocationCode111; "Location Code")
            {
            }
            column(PrintedNo; "No. Printed")
            {
            }
            column(Closed; "Closed")
            {
            }
            column(Cancelled; "Cancelled")
            {
            }
            column(Corrective; "Corrective")
            {
            }
            column(ShipmentMethodCode; "Shipment Method Code")
            {
            }
            column(CustomerGroupCode; CustomerGroupCode)
            {
            }
            column(CustomerPostingGroup111; "Customer Posting Group")
            {
                Caption = 'Customer Posting Group';
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
            end;

        }

        // 2.4.4	Sales Order Balance Sheet
        dataitem(SalesOrderBalanceSheet; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            //RequestFilterFields = "Order Date", "Customer Posting Group", "Posting Date";
            RequestFilterHeading = 'Sales Order - Balance';
            column(ShipmentDate222222; "Shipment Date")
            {
            }
            column(PostingDate222; "Posting Date")
            {
            }
            column(DocumentDate222; "Document Date")
            {
            }
            column(No222; "No.")
            {
            }
            column(CustomerNo222; "Sell-to Customer No.")
            {
            }
            column(Customer222; "Sell-to Customer Name")
            {
            }
            column(OrderNo222; "Order No.")
            {
            }
            column(OEMNo222; "OEM No.")
            {
            }
            column(OEMName222; "OEM Name")
            {
            }
            column(CurrencyCode222; "Currency Code")
            {
            }
            column(DueDate222; "Due Date")
            {
            }
            column(Amount222; "Amount")
            {
            }
            column(AmountLCY222; "Amount")
            {
                //ToDo
                //should be LCY Amount.
            }
            column(AmountIncludingVAT222; "Amount Including VAT")
            {
            }
            column(ExternalDocumentNo222; "External Document No.")
            {
            }
            column(RemainingAmount222; "Remaining Amount")
            {
            }
            column(LocationCode222; "Location Code")
            {
            }
            column(PrintedNo222; "No. Printed")
            {
            }
            column(Closed222; "Closed")
            {
            }
            column(Cancelled222; "Cancelled")
            {
            }
            column(Corrective222; "Corrective")
            {
            }
            column(ShipmentMethodCode222; "Shipment Method Code")
            {
            }
            column(CustomerGroupCode222; CustomerGroupCode)
            {
            }
            column(CustomerPostingGroup222; "Customer Posting Group")
            {
            }

            trigger OnPreDataItem()
            begin
                SalesOrderBalanceSheet.SETFILTER("Order Date", '..%1', EndDate);
                SalesOrderBalanceSheet.SETFILTER("Customer Posting Group", '%1|%2', '3RD TRAD', 'GROUP TRAD');
                SalesOrderBalanceSheet.SETFILTER("Posting Date", '%1..', StartDate);
            end;

        }

        // 2.4.5	Customer Sheet
        dataitem(CustomerSheet; "Customer")
        {
            DataItemTableView = SORTING("No.");
            column(No333; "No.")
            {
            }
            column(FamiliarName; "Familiar Name")
            {
            }
            column(Name; "Name")
            {
            }
            column(CountryRegionCode; "Country/Region Code")
            {
            }
            column(County; "County")
            {
            }
            column(CustomerPostingGroup333; "Customer Posting Group")
            {
            }
            column(ShipmentMethodCode333; "Shipment Method Code")
            {
            }
            column(ShippingAgentCode; "Shipping Agent Code")
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

    var
        StartDate: Date;
        EndDate: Date;
        CustPostingGroup: Code[20];
        CustomerGroupCode: Code[20];
        OrderDate: Date;
        RemainingSOAmountLCY: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";

}
