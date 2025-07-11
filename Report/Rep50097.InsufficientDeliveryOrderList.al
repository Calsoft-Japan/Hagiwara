report 50097 "InsuffICIENT DO List"
{
    // HG1.00 - Upgrade from Nav 3.60 to Nav Dynamics 5.00 (SG)
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Insufficient Delivery Order List.rdlc';

    Caption = 'Insufficient Delivery Order List';

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Priority;
            column(CompanyName; COMPANYNAME)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(FORMAT_TODAY_0___Closing__Year___Month_2___Day_2___; FORMAT(TODAY, 0, '<Closing><Year>/<Month,2>/<Day,2>'))
            {
            }
            column(FORMAT_TIME_0___Hours12_2___Minutes_2___Seconds_2___; FORMAT(TIME, 0, '<Hours12,2>:<Minutes,2>:<Seconds,2>'))
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport.PAGENO)
            {
            }
            column(Insufficient_Delivery_Order_ListCaption; Insufficient_Delivery_Order_ListCaptionLbl)
            {
            }
            column(ToCaption; ToCaptionLbl)
            {
            }
            column(Insufficient_Delivery_Order_listCaption_Control1000000068; Insufficient_Delivery_Order_listCaption_Control1000000068Lbl)
            {
            }
            column(Singapore_Hagiwara_Pte__Ltd_Caption; Singapore_Hagiwara_Pte__Ltd_CaptionLbl)
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
                DataItemTableView = SORTING("Sell-to Customer No.", "Parts No.", "Shipment Date", "Document Type", "Customer Order No.")
                                    WHERE("Outstanding Quantity" = FILTER(> 0));
                RequestFilterFields = "Shipment Date";
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
                column(UnitPrice; UnitPrice)
                {
                    DecimalPlaces = 4 : 4;
                }
                column(Sales_Line__Customer_Order_No__; "Customer Order No.")
                {
                }
                column(Sales_Line__Shipment_Date_; FORMAT("Shipment Date"))
                {
                }
                column(ItemType; ItemType)
                {
                }
                column(Qty; Qty)
                {
                    DecimalPlaces = 0 : 0;
                }
                column(Sales_Line_Rank; Rank)
                {
                }
                column(OrderDate; FORMAT(OrderDate))
                {
                }
                column(Sales_Line__Promised_Delivery_Date_; FORMAT("Promised Delivery Date"))
                {
                }
                column(Sales_Line__Document_Type_; "Document Type")
                {
                }
                column(Qty_Control1000000074; Qty)
                {
                    DecimalPlaces = 4 : 4;
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
                column(Due_DateCaption; Due_DateCaptionLbl)
                {
                }
                column(Item_TypeCaption; Item_TypeCaptionLbl)
                {
                }
                column(Insuff_QtyCaption; Insuff_QtyCaptionLbl)
                {
                }
                column(Pro_Del_DateCaption; Pro_Del_DateCaptionLbl)
                {
                }
                column(BK_DateCaption; BK_DateCaptionLbl)
                {
                }
                column(Doc_TypeCaption; Doc_TypeCaptionLbl)
                {
                }
                column(U_Price__USD_Caption; U_Price__USD_CaptionLbl)
                {
                }
                column(Customer_Insufficient_QtyCaption; Customer_Insufficient_QtyCaptionLbl)
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

                trigger OnAfterGetRecord()
                var
                    TempDO: Record TempDO;
                begin
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
                        ItemType := ItemRec."Item Category Code";
                        CountryOfOrigin := ItemRec."Country/Region of Origin Code";
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
                    //Yuka 20060213
                    SalesHeader.SETRANGE(SalesHeader."No.", "Sales Line"."Document No.");
                    SalesHeader.FIND('-');
                    OrderDate := SalesHeader."Order Date";
                    // Yuka 20060213 End

                    IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
                        ShortageFlag := FALSE;
                        Shortage := '';
                        QtyToShip := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";
                        //QtyAvailable := CheckQty("Sales Line"."No.", "Sales Line"."Location Code", "Sales Line"."Document No.");
                        //  TempDO.INIT;
                        TempDO.SETRANGE(TempDO."Document No.", "Sales Line"."Document No.", "Sales Line"."Document No.");
                        //  tempdo.setfilter(TempDo."Line No.", "Sales Line"."Line No.", "Sales Line"."Line No.");
                        TempDO.SETRANGE(TempDO."Line No.", "Sales Line"."Line No.", "Sales Line"."Line No.");

                        //IF TempDO.FIND('-') THEN BEGIN
                        IF TempDO.FindFirst() THEN BEGIN
                            QtyAvailable := TempDO."Assigned Qty";
                            IF QtyAvailable < QtyToShip THEN BEGIN
                                QtyToShip := QtyAvailable;
                                ShortageFlag := TRUE;
                                Shortage := '*'
                            END;
                        END;
                        // Yuka 20060213
                        UnitPrice := ROUND(
                              CurrExchRate.ExchangeAmtFCYToLCY(
                                WORKDATE, SalesHeader."Currency Code",
                                "Unit Price", SalesHeader."Currency Factor"), 0.0001);
                        Qty := ("Sales Line".Quantity - "Sales Line"."Quantity Shipped") - QtyAvailable;
                        Amount := UnitPrice * Qty;
                        // Yuka 20060213 End
                    END;
                    // YUKA for Hagiwara 20041127 - END

                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CREATETOTALS(SalesOrderAmountLCY,SalesOrderAmount);
                    //CurrReport.CREATETOTALS("Qty. to Ship");
                    //CurrReport.CREATETOTALS(QtyToShip);
                    //CurrReport.CREATETOTALS(Amount);
                    //CurrReport.CREATETOTALS(Qty,Amount);
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
                //IF Shipto.FIND('-') THEN BEGIN
                IF Shipto.FindFirst() THEN BEGIN
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
                //REP:TABLE
                //REP:LAYOUTRECT

                //CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                //CurrReport.CREATETOTALS(SalesOrderAmountLCY);
                //CurrReport.CREATETOTALS(Amount);
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
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
        SalesLineFilter := "Sales Line".GETFILTERS;
        PeriodText := "Sales Line".GETFILTER("Shipment Date");
        CalcQtyAvailable();
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
        UnitPrice: Decimal;
        Amount: Decimal;
        OrderDate: Date;
        Qty: Decimal;
        Insufficient_Delivery_Order_ListCaptionLbl: Label 'Insufficient Delivery Order List';
        ToCaptionLbl: Label 'To';
        Insufficient_Delivery_Order_listCaption_Control1000000068Lbl: Label 'Insufficient Delivery Order list';
        Singapore_Hagiwara_Pte__Ltd_CaptionLbl: Label 'Singapore Hagiwara Pte. Ltd.';
        Page__CaptionLbl: Label 'Page :';
        Customer_P_O_No_CaptionLbl: Label 'Customer P/O No.';
        Product_NameCaptionLbl: Label 'Product Name';
        Customer_P_NCaptionLbl: Label 'Customer P/N';
        RankCaptionLbl: Label 'Rank';
        Due_DateCaptionLbl: Label 'Due Date';
        Item_TypeCaptionLbl: Label 'Item Type';
        Insuff_QtyCaptionLbl: Label 'Insuff Qty';
        Pro_Del_DateCaptionLbl: Label 'Pro Del Date';
        BK_DateCaptionLbl: Label 'BK Date';
        Doc_TypeCaptionLbl: Label 'Doc Type';
        U_Price__USD_CaptionLbl: Label 'U/Price';
        Customer_Insufficient_QtyCaptionLbl: Label 'Customer Insufficient Qty';


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

        //IF ItemLedg.FIND('-') THEN BEGIN
        IF not ItemLedg.IsEmpty() THEN BEGIN
            ItemLedg.FindSet();
            REPEAT
                Qty := Qty + ItemLedg."Remaining Quantity";
            UNTIL ItemLedg.NEXT = 0;
        END;

        // Yuka add for checking 20050627
        //WorkRec3.INIT;
        WorkRec3.Reset();
        WorkRec3.SETRANGE(WorkRec3."Item No.", ItemCd, ItemCd);
        //IF WorkRec3.FIND('-') THEN BEGIN
        IF WorkRec3.FindFirst() THEN BEGIN
            WorkRec3."Available Qty" := Qty;
            WorkRec3.MODIFY;
        END;

        RsvRec.SETFILTER(RsvRec."Item No.", ItemCd, ItemCd);
        //IF RsvRec.FIND('-') THEN BEGIN
        IF not RsvRec.IsEmpty() THEN BEGIN
            RsvRec.FindSet();
            REPEAT
                //    IF (RsvRec."Source ID" <> DocNo) AND (RsvRec."Source Type" = 37) THEN
                IF (RsvRec."Source Type" = 37) THEN
                    QtyRsv := RsvRec.Quantity;
            UNTIL RsvRec.NEXT = 0;
        END;
        Qty := Qty + QtyRsv;  //qty rsv is always negative value
        IF Qty < 0 THEN
            Qty := 0;
        OnHandQty := Qty;
    end;


    procedure CalcQtyAvailable()
    var
        WorkRec: Record TempDO;
        WorkRec2: Record TempDO;
        pItemCd: Text[20];
        pLocCd: Text[10];
    begin
        WorkRec.DELETEALL;
        //IF "Sales Line".FIND('-') THEN BEGIN
        IF not "Sales Line".IsEmpty() THEN BEGIN
            "Sales Line".FindSet();
            REPEAT
                IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
                    WorkRec.Init();
                    WorkRec."Item No." := "Sales Line"."No.";
                    WorkRec."Shipment Date" := "Sales Line"."Shipment Date";
                    WorkRec."Document No." := "Sales Line"."Document No.";
                    WorkRec."Line No." := "Sales Line"."Line No.";
                    WorkRec.Quantity := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";
                    WorkRec.Location := "Sales Line"."Location Code";
                    WorkRec."Reserved Qty" := "Sales Line"."Reserved Quantity";
                    IF "Sales Line"."Reserved Quantity" <> 0 THEN BEGIN
                        WorkRec."Assigned Qty" := "Sales Line"."Reserved Quantity";
                        WorkRec.ProcFlag := 1;
                    END;
                    if not WorkRec.INSERT then WorkRec.MODIFY;
                END;
            UNTIL "Sales Line".NEXT = 0;
        END;

        // Yuka 20060331 - Modified
        WorkRec2.RESET;
        //IF WorkRec2.FIND('-') THEN BEGIN
        IF not WorkRec2.IsEmpty() THEN BEGIN
            WorkRec2.FindSet();
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
        //IF WorkRec2.FIND('-') THEN BEGIN
        IF not WorkRec2.IsEmpty() THEN BEGIN
            WorkRec2.FindSet();
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
                            IF WorkRec.Quantity <= QtyAvailable THEN BEGIN
                                WorkRec."Assigned Qty" := WorkRec.Quantity;
                                QtyAvailable := QtyAvailable - WorkRec.Quantity;
                            END ELSE BEGIN
                                WorkRec."Assigned Qty" := QtyAvailable;
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

        // Yuka - Comment out on 20060331
        /*
        WorkRec2.INIT;
        IF WorkRec2.FIND('-') THEN BEGIN
          REPEAT
        //  IF WorkRec2.ProcFlag = 0 THEN BEGIN
            QtyAvailable := 0;
            QtyAvailable := CheckQty(WorkRec2."Item No.", WorkRec2.Location);
            WorkRec.INIT;
            WorkRec.SETRANGE(WorkRec."Item No.", WorkRec2."Item No.", WorkRec2."Item No.");
            WorkRec.SETRANGE(WorkRec.Location, WorkRec2.Location, WorkRec2.Location);
            IF WorkRec.FIND('-') THEN BEGIN
              REPEAT
                IF WorkRec.ProcFlag = 0 THEN BEGIN
                  IF WorkRec.Quantity <= QtyAvailable THEN BEGIN
                    WorkRec."Assigned Qty" := WorkRec.Quantity;
                    QtyAvailable := QtyAvailable - WorkRec.Quantity;
                  END ELSE BEGIN
                    WorkRec."Assigned Qty" := QtyAvailable;
                    QtyAvailable := 0;
                  END;
                  WorkRec.ProcFlag :=1;
                  WorkRec.MODIFY;
                END;
              UNTIL WorkRec.NEXT = 0;
            END;
        //    WorkRec2.ProcFlag := 1;
        //    WorkRec2.MODIFY;
        //  END;
          UNTIL WorkRec2.NEXT = 0;
        END;   */

    end;
}

