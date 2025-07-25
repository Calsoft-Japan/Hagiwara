report 50044 "Delivery Order List"
{
    // HG1.00 - Upgrade from Nav 3.60 to Nav Dynamics 5.00 (SG)
    // HG2.00  - Adding Export to Excel feature
    // v20210126 Kenya - Improve Inventory Reservation and Delivery Order (CS005)
    // CS016 Kenya 2021/5/26 - Country of Origin Code
    // CS025 Kenya 2021/08/13 - Qty to Ship with Different Location

    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Delivery Order List.rdlc';

    Caption = 'Delivery Order List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Priority, "Salesperson Code";
            column(Customer__Location_Code_; "Location Code")
            {
            }
            column(Customer__Shipping_Mark1_; "Shipping Mark1")
            {
            }
            column(Customer__Shipping_Mark2_; "Shipping Mark2")
            {
            }
            column(Customer__Shipping_Mark3_; "Shipping Mark3")
            {
            }
            column(Customer__Shipping_Mark4_; "Shipping Mark4")
            {
            }
            column(Customer__Shipping_Mark5_; "Shipping Mark5")
            {
            }
            column(Customer_Remarks1; Remarks1)
            {
            }
            column(Customer_Remarks2; Remarks2)
            {
            }
            column(Customer_Remarks3; Remarks3)
            {
            }
            column(Customer_Remarks4; Remarks4)
            {
            }
            column(Customer_Remarks5; Remarks5)
            {
            }
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(Attn1; Attn1)
            {
            }
            column(Attn2; Attn2)
            {
            }
            column(CC; CC)
            {
            }
            column(ShiptoName; ShiptoName)
            {
            }
            column(ShiptoAdd1; ShiptoAdd1)
            {
            }
            column(ShiptoAdd2; ShiptoAdd2)
            {
            }
            column(ShiptoAttn; ShiptoAttn)
            {
            }
            column(ShiptoTel; ShiptoTel)
            {
            }
            column(ShiptoFax; ShiptoFax)
            {
            }
            column(FORMAT_TODAY_0___Closing__Year___Month_2___Day_2___; FORMAT(TODAY, 0, '<Closing><Year>/<Month,2>/<Day,2>'))
            {
            }
            column(FORMAT_TIME_0___Hours12_2___Minutes_2___Seconds_2___; FORMAT(TIME, 0, '<Hours12,2>:<Minutes,2>:<Seconds,2>'))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(Delivery_Order_ListCaption; Delivery_Order_ListCaptionLbl)
            {
            }
            column(ToCaption; ToCaptionLbl)
            {
            }
            column(AttnCaption; AttnCaptionLbl)
            {
            }
            column(CcCaption; CcCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000045; EmptyStringCaption_Control1000000045Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000046; EmptyStringCaption_Control1000000046Lbl)
            {
            }
            column(Tax_Invoice__issued_by_Hagiwara_Caption; Tax_Invoice__issued_by_Hagiwara_CaptionLbl)
            {
            }
            column(Packing_List__issued_by_NECLS_Caption; Packing_List__issued_by_NECLS_CaptionLbl)
            {
            }
            column(Delivery_Order__issued_by_Hagiwara_Caption; Delivery_Order__issued_by_Hagiwara_CaptionLbl)
            {
            }
            column(Customer_P_N_LablesCaption; Customer_P_N_LablesCaptionLbl)
            {
            }
            column(Other__Caption; Other__CaptionLbl)
            {
            }
            column(Delivery_To_Caption; Delivery_To_CaptionLbl)
            {
            }
            column(Attn_Caption; Attn_CaptionLbl)
            {
            }
            column(Shipping_Mark_Caption; Shipping_Mark_CaptionLbl)
            {
            }
            column(Outer_Box_Packing__Caption; Outer_Box_Packing__CaptionLbl)
            {
            }
            column(Export_Standard_CartonCaption; Export_Standard_CartonCaptionLbl)
            {
            }
            column(Simple_PackingCaption; Simple_PackingCaptionLbl)
            {
            }
            column(Delivery_Date__Caption; Delivery_Date__CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000052; EmptyStringCaption_Control1000000052Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000053; EmptyStringCaption_Control1000000053Lbl)
            {
            }
            column(Remarks_Caption; Remarks_CaptionLbl)
            {
            }
            column(Issued_Date__Caption; Issued_Date__CaptionLbl)
            {
            }
            column(Tel_Caption; Tel_CaptionLbl)
            {
            }
            column(Fax_Caption; Fax_CaptionLbl)
            {
            }
            column(Delivery_Order_listCaption_Control1000000068; Delivery_Order_listCaption_Control1000000068Lbl)
            {
            }
            column(Singapore_Hagiwara_Pte__Ltd_Caption; Singapore_Hagiwara_Pte__Ltd_CaptionLbl)
            {
            }
            column(CompanyInfo_1; CompanyInfo.Name)
            {
            }
            column(Page__Caption; Page__CaptionLbl)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            column(Customer_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Bill-to Customer No." = FIELD("No."),
                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Document Type", "Sell-to Customer No.", "Parts No.", "Shipment Date", "Customer Order No.")
                                    WHERE("Document Type" = CONST(Order),
                                          "Outstanding Quantity" = FILTER(> 0));
                RequestFilterFields = Blocked, "Shipment Date", "OEM No.";
                RequestFilterHeading = 'Sales Order Line';
                column(Sales_Line__Sell_to_Customer_No__; "Sell-to Customer No.")
                {
                }
                column(Customer_Name; Customer.Name)
                {
                }
                column(Sales_Line__Parts_No__; "Parts No.")
                {
                }
                column(Sales_Line__Customer_Item_No__; "Customer Item No.")
                {
                }
                column(QtyToShip; QtyToShip)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Sales_Line__Customer_Order_No__; "Customer Order No.")
                {
                }
                column(Sales_Line__Shipment_Date_; "Shipment Date")
                {
                }
                column(CountryOfOrigin; CountryOfOrigin)
                {
                }
                column(ItemType; ItemType)
                {
                }
                column(Shortage; Shortage)
                {
                }
                column(Sales_Line__Outstanding_Quantity_; "Outstanding Quantity")
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Sales_Line_Rank; Rank)
                {
                }
                column(Sales_Line__OEM_Name_; "OEM Name")
                {
                }
                column(QtyToShip_Control1000000074; QtyToShip)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Customer_P_O_No_Caption; Customer_P_O_No_CaptionLbl)
                {
                }
                column(Product_NameCaption; Product_NameCaptionLbl)
                {
                }
                column(Customer_P_NCaption; Customer_P_NCaptionLbl)
                {
                }
                column(RankCaption; RankCaptionLbl)
                {
                }
                column(Qty_to_ShipCaption; Qty_to_ShipCaptionLbl)
                {
                }
                column(Due_DateCaption; Due_DateCaptionLbl)
                {
                }
                column(C_OCaption; C_OCaptionLbl)
                {
                }
                column(Item_TypeCaption; Item_TypeCaptionLbl)
                {
                }
                column(OEMCaption; OEMCaptionLbl)
                {
                }
                column(OutStanding_QtyCaption; OutStanding_QtyCaptionLbl)
                {
                }
                column(Quantity_AmountCaption; Quantity_AmountCaptionLbl)
                {
                }
                column(Sales_Line_Document_Type; "Document Type")
                {
                }
                column(Sales_Line_Document_No_; "Document No.")
                {
                }
                column(Sales_Line_Line_No_; "Line No.")
                {
                }
                column(Sales_Line_Bill_to_Customer_No_; "Bill-to Customer No.")
                {
                }
                column(Sales_Line_Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
                {
                }
                column(Sales_Line_Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
                {
                }
                column(Out_qty; "Sales Line"."Outstanding Quantity")
                {
                }

                trigger OnAfterGetRecord()
                var
                    TempDO: Record TempDO;
                begin
                    //MESSAGE(FORMAT("Sales Line"."Outstanding Quantity"));
                    // MESSAGE(FORMAT("Quantity Shipped"));

                    //Quantity-

                    // YUKA for Hagiwara 20030219
                    /*
                    NewOrder := "Document No." <> SalesHeader."No.";
                    IF NewOrder THEN
                      SalesHeader.GET(1,"Document No.");
                    IF "Shipment Date" <= WORKDATE THEN
                      BackOrderQty := "Outstanding Quantity"
                    ELSE
                      BackOrderQty := 0;
                    SalesOrderAmount := ROUND("Outstanding Quantity" * Amount / Quantity);
                    SalesOrderAmountLCY := SalesOrderAmount;
                    IF SalesHeader."Currency Code" <> '' THEN BEGIN
                      IF SalesHeader."Currency Factor" <> 0 THEN
                        SalesOrderAmountLCY :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              WORKDATE,SalesHeader."Currency Code",
                              SalesOrderAmountLCY,SalesHeader."Currency Factor"));
                      IF PrintAmountsInLCY THEN BEGIN
                        "Unit Price" :=
                          ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(
                              WORKDATE,SalesHeader."Currency Code",
                              "Unit Price",SalesHeader."Currency Factor"));
                        SalesOrderAmount := SalesOrderAmountLCY;
                      END;
                    END;
                    
                    CurrencyCode2 := SalesHeader."Currency Code";
                    IF PrintAmountsInLCY THEN
                      CurrencyCode2 := '';
                    CurrencyTotalBuffer.UpdateTotal(
                      CurrencyCode2,
                      SalesOrderAmount,
                      Counter1,
                      Counter1);
                    */
                    // YUKA for Hagiwara 20030219 - END
                    ItemRec.RESET;
                    IF "Sales Line"."No." <> '' THEN BEGIN
                        ItemRec.GET("Sales Line"."No.");
                        //ItemType := ItemRec."Product Group Code";
                        ItemType := ItemRec."Item Group Code";
                        //CS016 Begin
                        SalesHeader.GET(SalesHeader."Document Type"::Order, "Sales Line"."Document No.");
                        CustomerRec.GET(SalesHeader."Sell-to Customer No.");
                        IF CustomerRec."Default Country/Region of Org" = CustomerRec."Default Country/Region of Org"::"Front-end" THEN
                            CountryOfOrigin := ItemRec."Country/Region of Org Cd (FE)"
                        ELSE
                            CountryOfOrigin := ItemRec."Country/Region of Origin Code";
                        //CS016 End
                    END;
                    // YUKA for Hagiwara 20041127
                    /*
                    ShiptoName:='';
                    ShiptoAdd1 :='';
                    ShiptoAdd2 :='';
                    ShiptoCity :='';
                    ShiptoPostCode := '';
                    ShiptoTel :='';
                    ShiptoFax := '';
                    SalesHeader.SETRANGE(SalesHeader."No.","Sales Line"."Document No.");
                    SalesHeader.FIND('-');
                    //SalesHeader.FIND;
                    IF SalesHeader."Ship-to Code" <> '' THEN BEGIN
                      Shipto.SETRANGE(Shipto.Code, SalesHeader."Ship-to Code");
                      Shipto.FIND('-');
                      //Shipto.FIND;
                      ShiptoName:= Shipto.Name;
                      ShiptoAdd1 :=Shipto.Address;
                      ShiptoAdd2 :=Shipto."Address 2" + ' ' + Shipto.City + ' ' + Shipto."Post Code";
                      ShiptoCity := Shipto.City;
                      ShiptoPostCode := Shipto."Post Code";
                      ShiptoAttn :=Shipto.Contact;
                      ShiptoTel :=Shipto."Phone No.";
                      ShiptoFax := Shipto."Fax No.";
                    END;
                    */
                    IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
                        ShortageFlag := FALSE;
                        Shortage := '';
                        QtyToShip := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";
                        //QtyAvailable := CheckQty("Sales Line"."No.", "Sales Line"."Location Code", "Sales Line"."Document No.");
                        //  TempDO.INIT;
                        TempDO.SETRANGE(TempDO."Document No.", "Sales Line"."Document No.", "Sales Line"."Document No.");
                        //  tempdo.setfilter(TempDo."Line No.", "Sales Line"."Line No.", "Sales Line"."Line No.");
                        TempDO.SETRANGE(TempDO."Line No.", "Sales Line"."Line No.", "Sales Line"."Line No.");

                        IF TempDO.FIND('-') THEN BEGIN
                            QtyAvailable := TempDO."Assigned Qty";
                            IF QtyAvailable < QtyToShip THEN BEGIN
                                QtyToShip := QtyAvailable;
                                ShortageFlag := TRUE;
                                Shortage := '*'
                            END;
                        END;
                    END;
                    // YUKA for Hagiwara 20041127 - END

                    TotalQtyToShip += QtyToShip;

                    IF PrintToExcel THEN BEGIN
                        IF (CustNo <> Customer."No.") THEN BEGIN
                            CustNo := Customer."No.";
                            MakeExcelBodyHeader;
                        END;
                        MakeExcelDataBody;
                    END;

                end;

                trigger OnPostDataItem()
                begin
                    IF PrintToExcel THEN BEGIN
                        IF CustNo <> '' THEN BEGIN
                            CustNo := '';
                            MakeExcelFooter1;
                        END;
                        MakeExcelFooter2;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CREATETOTALS(SalesOrderAmountLCY,SalesOrderAmount);
                    //CurrReport.CREATETOTALS("Qty. to Ship");
                    //CurrReport.CREATETOTALS(QtyToShip);

                    TotalQtyToShip := 0;

                    IF PrintToExcel THEN
                        MakeExcelDataHeader;
                end;
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = FILTER(1 ..));

                trigger OnAfterGetRecord()
                begin
                    IF Number = 1 THEN
                        OK := CurrencyTotalBuffer.FIND('-')
                    ELSE
                        OK := CurrencyTotalBuffer.NEXT <> 0;
                    IF NOT OK THEN
                        CurrReport.BREAK;

                    CurrencyTotalBuffer2.UpdateTotal(
                      CurrencyTotalBuffer."Currency Code",
                      CurrencyTotalBuffer."Total Amount",
                      Counter1,
                      Counter1);
                end;

                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DELETEALL;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                // YUKA for Hagiwara 20041127
                Attn1 := '';
                Attn2 := '';
                CC := '';
                IF Customer."Location Code" <> '' THEN BEGIN
                    Location.SETRANGE(Code, Customer."Location Code", Customer."Location Code");
                    IF Location.FIND('-') THEN
                        Attn1 := Location.Attention1;
                    Attn2 := Location.Attention2;
                    CC := Location.CC;
                END;
                // YUKA for Hagiwara 20041127 - END
                // YUKA for Hagiwara 20050404
                ShiptoName := '';
                ShiptoAdd1 := '';
                ShiptoAdd2 := '';
                ShiptoCity := '';
                ShiptoPostCode := '';
                ShiptoTel := '';
                ShiptoFax := '';
                Shipto.SETRANGE(Shipto."Customer No.", Customer."No.");
                IF Shipto.FIND('-') THEN BEGIN
                    ShiptoName := Shipto.Name;
                    ShiptoAdd1 := Shipto.Address;
                    ShiptoAdd2 := Shipto."Address 2" + ' ' + Shipto.City + ' ' + Shipto."Post Code";
                    ShiptoCity := Shipto.City;
                    ShiptoPostCode := Shipto."Post Code";
                    ShiptoAttn := Shipto.Contact;
                    ShiptoTel := Shipto."Phone No.";
                    ShiptoFax := Shipto."Fax No.";
                END;
                // YUKA for Hagiwara 20050404
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                //CurrReport.CREATETOTALS(SalesOrderAmountLCY);
            end;
        }
        dataitem(Integer2; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));

            trigger OnAfterGetRecord()
            begin
                IF Number = 1 THEN
                    OK := CurrencyTotalBuffer2.FIND('-')
                ELSE
                    OK := CurrencyTotalBuffer2.NEXT <> 0;
                IF NOT OK THEN
                    CurrReport.BREAK;
            end;

            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DELETEALL;
            end;
        }
    }

    requestpage
    {

        layout
        {
            /*area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                    }
                }
            }*/
        }

        actions
        {
        }

    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    trigger OnPostReport()
    begin
        //HG2.00
        IF PrintToExcel THEN
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
        SalesLineFilter := "Sales Line".GETFILTERS;
        PeriodText := "Sales Line".GETFILTER("Shipment Date");
        CalcQtyAvailable;
        /* bobby
                //HG2.00
                IF PrintToExcel THEN
                    MakeExcelInfo();
                //HG2.00
                */
    end;

    var
        Text000: Label 'Shipment Date: %1';
        Text001: Label 'Sales Order Line: %1';
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
        CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
        SalesHeader: Record "Sales Header";
        CustFilter: Text[250];
        SalesLineFilter: Text[250];
        SalesOrderAmount: Decimal;
        SalesOrderAmountLCY: Decimal;
        PrintAmountsInLCY: Boolean;
        PeriodText: Text[30];
        PrintOnlyOnePerPage: Boolean;
        BackOrderQty: Decimal;
        NewOrder: Boolean;
        OK: Boolean;
        Counter1: Integer;
        CurrencyCode2: Code[10];
        ItemType: Text[30];
        ItemRec: Record Item;
        Attn1: Text[30];
        Attn2: Text[30];
        CC: Text[30];
        Location: Record Location;
        CustLoc: Text[30];
        Shipto: Record "Ship-to Address";
        ShiptoAdd1: Text[50];
        ShiptoAdd2: Text[100];
        ShiptoAttn: Text[30];
        ShiptoTel: Text[30];
        ShiptoFax: Text[30];
        ShiptoName: Text[50];
        ShiptoCity: Text[30];
        ShiptoPostCode: Code[20];
        QtyToShip: Decimal;
        QtyRsv: Decimal;
        QtyAvailable: Decimal;
        ShortageFlag: Boolean;
        Shortage: Text[2];
        DocNo: Code[20];
        TotalPage: Decimal;
        CountryOfOrigin: Code[10];
        "-EXPORT EXCEL -": Integer;
        PrintToExcel: Boolean;
        ExcelBuf: Record "Excel Buffer" temporary;
        Text011: Label 'Data';
        Text012: Label 'Delivery Order List';
        Text013: Label 'Company Name';
        Text014: Label 'Report No.';
        Text015: Label 'Report Name';
        Text016: Label 'User ID';
        Text017: Label 'Date';
        Text018: Label 'Customer Filters';
        Text019: Label 'Sales Order Line Filters';
        Delivery_Order_ListCaptionLbl: Label 'Delivery Order List';
        ToCaptionLbl: Label 'To';
        AttnCaptionLbl: Label 'Attn';
        CcCaptionLbl: Label 'Cc';
        EmptyStringCaptionLbl: Label ':';
        EmptyStringCaption_Control1000000045Lbl: Label ':';
        EmptyStringCaption_Control1000000046Lbl: Label ':';
        Tax_Invoice__issued_by_Hagiwara_CaptionLbl: Label 'Tax Invoice (issued by Hagiwara)';
        Packing_List__issued_by_NECLS_CaptionLbl: Label 'Packing List (issued by NECLS)';
        Delivery_Order__issued_by_Hagiwara_CaptionLbl: Label 'Delivery Order (issued by Hagiwara)';
        Customer_P_N_LablesCaptionLbl: Label 'Customer P/N Lables';
        Other__CaptionLbl: Label 'Other :';
        Delivery_To_CaptionLbl: Label 'Delivery To:';
        Attn_CaptionLbl: Label 'Attn:';
        Shipping_Mark_CaptionLbl: Label 'Shipping Mark:';
        Outer_Box_Packing__CaptionLbl: Label 'Outer Box Packing :';
        Export_Standard_CartonCaptionLbl: Label 'Export Standard Carton';
        Simple_PackingCaptionLbl: Label 'Simple Packing';
        Delivery_Date__CaptionLbl: Label 'Delivery Date :';
        EmptyStringCaption_Control1000000052Lbl: Label '/';
        EmptyStringCaption_Control1000000053Lbl: Label '/';
        Remarks_CaptionLbl: Label 'Remarks:';
        Issued_Date__CaptionLbl: Label 'Issued Date :';
        Tel_CaptionLbl: Label 'Tel:';
        Fax_CaptionLbl: Label 'Fax:';
        Delivery_Order_listCaption_Control1000000068Lbl: Label 'Delivery Order list';
        Singapore_Hagiwara_Pte__Ltd_CaptionLbl: Label 'Singapore Hagiwara Pte. Ltd.';
        Page__CaptionLbl: Label 'Page :';
        Customer_P_O_No_CaptionLbl: Label 'Customer P/O No.';
        Product_NameCaptionLbl: Label 'Product Name';
        Customer_P_NCaptionLbl: Label 'Customer P/N';
        RankCaptionLbl: Label 'Rank';
        Qty_to_ShipCaptionLbl: Label 'Qty to Ship';
        Due_DateCaptionLbl: Label 'Due Date';
        C_OCaptionLbl: Label 'C/O';
        Item_TypeCaptionLbl: Label 'Item Type';
        OEMCaptionLbl: Label 'OEM';
        OutStanding_QtyCaptionLbl: Label 'OutStanding Qty';
        Quantity_AmountCaptionLbl: Label 'Quantity Amount';
        CustNo: Code[20];
        TotalQtyToShip: Decimal;
        CompanyInfo: Record "Company Information";
        CustomerRec: Record Customer;

    procedure CheckQty(ItemCd: Code[20]; LocCd: Code[10]) OnHandQty: Decimal
    var
        ItemLedg: Record "Item Ledger Entry";
        Qty: Decimal;
        RsvRec: Record "Reservation Entry";
        WorkRec3: Record TempDO;
    begin
        // YUKA for Hagiwara 20041127
        IF LocCd <> '' THEN
            ItemLedg.SETFILTER(ItemLedg."Item No.", ItemCd, ItemCd, ItemLedg."Location Code", LocCd, LocCd)
        ELSE
            ItemLedg.SETRANGE(ItemLedg."Item No.", ItemCd, ItemCd);

        ItemLedg.SETFILTER("Location Code", '<>%1&%2', 'HOLD', LocCd); //CS025
        IF ItemLedg.FIND('-') THEN BEGIN
            REPEAT
                Qty := Qty + ItemLedg."Remaining Quantity";
            UNTIL ItemLedg.NEXT = 0;
        END;

        QtyRsv := 0;  //v20210126
        RsvRec.SETFILTER(RsvRec."Item No.", ItemCd, ItemCd);
        RsvRec.SETFILTER(RsvRec."Location Code", LocCd, LocCd); //CS025
        IF RsvRec.FIND('-') THEN BEGIN
            REPEAT
                //    IF (RsvRec."Source ID" <> DocNo) AND (RsvRec."Source Type" = 37) THEN
                IF (RsvRec."Source Type" = 37) AND
                   (RsvRec."Reservation Status" = RsvRec."Reservation Status"::Reservation) THEN  //v20210126
                                                                                                  //QtyRsv := RsvRec.Quantity;
                    QtyRsv += RsvRec.Quantity;  //v20210126
            UNTIL RsvRec.NEXT = 0;
        END;
        Qty := Qty + QtyRsv;  //qty rsv is always negative value
        IF Qty < 0 THEN
            Qty := 0;

        //v20210126 Start (moved)
        // Yuka add for checking 20050627
        WorkRec3.INIT;
        WorkRec3.SETRANGE(WorkRec3."Item No.", ItemCd, ItemCd);
        WorkRec3.SETRANGE(WorkRec3.Location, LocCd, LocCd); //CS025
        IF WorkRec3.FIND('-') THEN BEGIN
            WorkRec3."Available Qty" := Qty;
            WorkRec3.MODIFY;
        END;
        //v20210126 End (moved)

        OnHandQty := Qty;
    end;

    procedure CalcQtyAvailable()
    var
        WorkRec: Record TempDO;
        WorkRec2: Record TempDO;
        pItemCd: Text[20];
        pLocCd: Text[10];
        RsvRec: Record "Reservation Entry";
        RsvQty: Decimal;
        QtyUnassigned: Decimal;
    begin
        WorkRec.DELETEALL;
        IF "Sales Line".FIND('-') THEN BEGIN
            REPEAT
                IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
                    WorkRec."Item No." := "Sales Line"."No.";
                    WorkRec."Shipment Date" := "Sales Line"."Shipment Date";
                    WorkRec."Document No." := "Sales Line"."Document No.";
                    WorkRec."Line No." := "Sales Line"."Line No.";
                    WorkRec.Quantity := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";
                    WorkRec.Location := "Sales Line"."Location Code";
                    //v20210126 Start
                    RsvQty := 0;
                    RsvRec.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                    RsvRec.SETRANGE("Source ID", "Sales Line"."Document No.");
                    RsvRec.SETRANGE("Source Ref. No.", "Sales Line"."Line No.");
                    RsvRec.SETRANGE("Source Type", 37);
                    RsvRec.SETRANGE("Source Subtype", "Sales Line"."Document Type");
                    RsvRec.SETRANGE("Reservation Status", RsvRec."Reservation Status"::Reservation);
                    IF RsvRec.FIND('-') THEN BEGIN
                        REPEAT
                            RsvQty += RsvRec.Quantity * (-1);
                        UNTIL RsvRec.NEXT = 0;
                    END;
                    //WorkRec."Reserved Qty" := "Sales Line"."Reserved Quantity";
                    WorkRec."Reserved Qty" := RsvQty;
                    //IF "Sales Line"."Reserved Quantity" <> 0 THEN BEGIN
                    IF RsvQty <> 0 THEN BEGIN
                        //WorkRec."Assigned Qty" := "Sales Line"."Reserved Quantity";
                        WorkRec."Assigned Qty" := RsvQty;
                        IF RsvQty = WorkRec.Quantity THEN
                            WorkRec.ProcFlag := 1
                        ELSE
                            WorkRec.ProcFlag := 0;
                    END
                    ELSE BEGIN
                        WorkRec."Assigned Qty" := 0;
                        WorkRec.ProcFlag := 0;
                    END;
                    //v20210126 End
                    WorkRec.INSERT;
                    WorkRec.MODIFY;
                END;
            UNTIL "Sales Line".NEXT = 0;
        END;
        // Yuka 20060329 - Modified
        WorkRec2.RESET;
        IF WorkRec2.FIND('-') THEN BEGIN
            REPEAT
                IF (pItemCd <> WorkRec2."Item No.") OR (pLocCd <> WorkRec2.Location) THEN BEGIN
                    pItemCd := WorkRec2."Item No.";
                    pLocCd := WorkRec2.Location;
                    QtyAvailable := 0;
                    QtyAvailable := CheckQty(pItemCd, pLocCd);
                END;
            UNTIL WorkRec2.NEXT = 0;
        END;
        WorkRec2.RESET;
        WorkRec2.SETFILTER(WorkRec2."Available Qty", '> 0');
        IF WorkRec2.FIND('-') THEN BEGIN
            REPEAT
                //  IF (pItemCd <>  WorkRec2."Item No.") OR (pLocCd <> WorkRec2.Location) THEN BEGIN
                pItemCd := WorkRec2."Item No.";
                pLocCd := WorkRec2.Location;
                QtyAvailable := WorkRec2."Available Qty";
                WorkRec.RESET;
                WorkRec.SETRANGE(WorkRec."Item No.", pItemCd, pItemCd);
                WorkRec.SETRANGE(WorkRec.Location, pLocCd, pLocCd);
                IF WorkRec.FIND('-') THEN BEGIN
                    REPEAT
                        IF WorkRec.ProcFlag = 0 THEN BEGIN
                            //v20210126 Start
                            QtyUnassigned := WorkRec.Quantity - WorkRec."Assigned Qty";
                            //IF WorkRec.Quantity <= QtyAvailable THEN BEGIN
                            IF QtyUnassigned <= QtyAvailable THEN BEGIN
                                WorkRec."Assigned Qty" := WorkRec.Quantity;
                                //QtyAvailable := QtyAvailable - WorkRec.Quantity;
                                QtyAvailable := QtyAvailable - QtyUnassigned;
                            END ELSE BEGIN
                                //WorkRec."Assigned Qty" := QtyAvailable;
                                WorkRec."Assigned Qty" += QtyAvailable;
                                //v20210126 End
                                QtyAvailable := 0;
                            END;
                            WorkRec.ProcFlag := 1;
                            WorkRec.MODIFY;
                        END;
                    UNTIL WorkRec.NEXT = 0;
                END;
            //  END;
            UNTIL WorkRec2.NEXT = 0;
        END;
    end;

    procedure "---EXPORT EXCEL---"()
    begin
    end;

    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel('', Text011, Text012, COMPANYNAME, USERID);
        ExcelBuf.CreateNewBook(Text011);
        ExcelBuf.WriteSheet(Text012, CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        ERROR('');
    end;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(FORMAT(Text013), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text015), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(FORMAT(Text012), FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text014), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(REPORT::"Delivery Order List", FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text016), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(USERID, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text017), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(TODAY, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text018), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn(Customer.GETFILTERS, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(FORMAT(Text019), FALSE, TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddInfoColumn("Sales Line".GETFILTERS, FALSE, FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.ClearNewRow;
    end;

    procedure MakeExcelDataHeader()
    begin

        ExcelBuf.NewRow;
        //ExcelBuf.Custom_FontSize(18);
        ExcelBuf.AddColumn(FORMAT(Text012), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        MakeBlankColumn();
        MakeBlankColumn();
        ExcelBuf.AddColumn('Delivery To:', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        ExcelBuf.AddColumn('Issued Date : ' + FORMAT(TODAY, 0, 4), FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuf."Cell Type"::Text);


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('To:', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(':' + Location.Code,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(Location.Code, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ShiptoName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Attn:', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(':' + Attn1,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(Attn1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ShiptoAdd1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        ExcelBuf.AddColumn('Delivery Date :    /   /    ', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuf."Cell Type"::Date);


        ExcelBuf.NewRow;
        MakeBlankColumn();
        //ExcelBuf.AddColumn(':' + Attn2,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(Attn2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(ShiptoAdd2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        ExcelBuf.AddColumn('Remarks: ', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);


        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Cc:', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn(':' + CC,FALSE,'',FALSE,FALSE,FALSE,'');
        ExcelBuf.AddColumn(CC, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Attn: ' + ShiptoAttn, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outer Box Packing :', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Remarks1, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        MakeBlankColumn();
        MakeBlankColumn();
        ExcelBuf.AddColumn('Tel: ' + ShiptoTel, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Export Standard Carton', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Remarks2, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        MakeBlankColumn();
        MakeBlankColumn();
        ExcelBuf.AddColumn('Fax: ' + ShiptoFax, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Simple Packing', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Remarks3, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);


        ExcelBuf.NewRow;
        MakeBlankColumn();
        ExcelBuf.AddColumn('Tax Invoice (Issued by Hagiwara)', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Shipping Mark:', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        ExcelBuf.AddColumn(Customer.Remarks4, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        MakeBlankColumn();
        ExcelBuf.AddColumn('Packing List (Issued by NECLS)', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Shipping Mark1", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        ExcelBuf.AddColumn(Customer.Remarks5, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        MakeBlankColumn();
        ExcelBuf.AddColumn('Delivery Order (Issued by Hagiwara)', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Shipping Mark2", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        MakeBlankColumn();

        ExcelBuf.NewRow;
        MakeBlankColumn();
        ExcelBuf.AddColumn('Customer P/N Lables', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Shipping Mark3", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        MakeBlankColumn();

        ExcelBuf.NewRow;
        MakeBlankColumn();
        ExcelBuf.AddColumn('Other', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer."Shipping Mark4", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        MakeBlankColumn();

        ExcelBuf.NewRow;
        MakeBlankColumn();
        MakeBlankColumn();
        ExcelBuf.AddColumn(Customer."Shipping Mark5", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        MakeBlankColumn();
        MakeBlankColumn();
    end;

    procedure MakeExcelBodyHeader()
    begin
        MakeExcel_Line();

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Due Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Item Type', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer P/O No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Product Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Rank', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('C/O', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer P/N', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Outstanding Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Qty to Ship', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('OEM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Line"."Sell-to Customer No.", FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn("Sales Line"."Shipment Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(ItemType, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Customer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Parts No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line".Rank, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(CountryOfOrigin, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Customer Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."Outstanding Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(QtyToShip, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(Shortage, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Sales Line"."OEM Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelFooter1()
    begin
        MakeExcel_Line();

        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Quantity Amount', FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn("Sales Line"."Outstanding Quantity",FALSE,'',FALSE,FALSE,TRUE,'');
        ExcelBuf.AddColumn(TotalQtyToShip, FALSE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeBlankColumn()
    begin
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelFooter2()
    var
        intLoop: Integer;
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(FORMAT(TODAY, 0, '<Closing><Year>/<Month,2>/<Day,2>'), FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(FORMAT(TIME, 0, '<Hours12,2>:<Minutes,2>:<Seconds,2>'), FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuf."Cell Type"::Time);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Delivery Order list', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow;
        FOR intLoop := 1 TO 10 DO BEGIN
            MakeBlankColumn();
        END;
        ExcelBuf.AddColumn('Singapore Hagiwara Pte. Ltd.', FALSE, '', TRUE, TRUE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelFooter3()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Page :' + FORMAT(CurrReport.PAGENO), TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', TRUE, '', TRUE, TRUE, TRUE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'');
    end;

    procedure MakeExcel_Line()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
    end;
}

