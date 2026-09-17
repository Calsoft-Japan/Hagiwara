report 50043 "Export Delivery Order List "
{
    // CS092 2026/02/27 Bobby R041 Export Delivery Order List
    ProcessingOnly = true;


    Caption = 'Export Delivery Order List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Priority, "Salesperson Code";
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Sell-to Customer No." = FIELD("No."),
                               "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                               "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Document Type", "Sell-to Customer No.", "Parts No.", "Shipment Date", "Customer Order No.")
                                    WHERE("Document Type" = CONST(Order),
                                          "Outstanding Quantity" = FILTER(> 0));
                RequestFilterFields = Blocked, "Shipment Date", "OEM No.";
                RequestFilterHeading = 'Sales Order Line';

                trigger OnAfterGetRecord()
                var
                    Location: Record Location;
                    Attn1: Text[40];
                    Attn2: Text[40];
                    CC: Text[40];
                    SalesHeader: Record "Sales Header";
                    TempDO: Record TempDO;
                    Shipto: Record "Ship-to Address";
                    ShiptoAdd1: Text[50];
                    ShiptoAdd2: Text[100];
                    ShiptoAttn: Text[50];
                    ShiptoTel: Text[30];
                    ShiptoFax: Text[30];
                    ShiptoName: Text[50];
                    ShiptoCity: Text[30];
                    ShiptoPostCode: Code[20];
                    ItemRec: Record Item;
                    CustomerRec: Record Customer;
                    //Customer: Record Customer;
                    ItemType: Text[30];
                    CountryOfOrigin: Code[10];
                    ShortageFlag: Boolean;
                    Shortage: Text[2];
                    QtyToShip: Decimal;
                    QtyAvailable: Decimal;
                    TotalQtyToShip: Decimal;
                begin
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
                        ShiptoAdd2 := Shipto."Address 2";
                        ShiptoCity := Shipto.City;
                        ShiptoPostCode := Shipto."Post Code";
                        ShiptoAttn := Shipto.Contact;
                        ShiptoTel := Shipto."Phone No.";
                        ShiptoFax := Shipto."Fax No.";
                    END;
                    // YUKA for Hagiwara 20050404

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

                    IF "Sales Line".Type = "Sales Line".Type::Item THEN BEGIN
                        ShortageFlag := FALSE;
                        Shortage := '';
                        //N005
                        //QtyToShip := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";
                        QtyToShip := "Sales Line"."Approved Quantity" - "Sales Line"."Quantity Shipped";
                        //N005
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



                    LineNo += 1;
                    CSVBuffer.InsertEntry(LineNo, 1, "Sales Line"."Location Code");
                    CSVBuffer.InsertEntry(LineNo, 2, '"' + Attn1.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 3, '"' + Attn2.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 4, '"' + CC.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 5, '"' + ShiptoName.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 6, '"' + ShiptoAdd1.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 7, '"' + ShiptoAdd2.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 8, '"' + ShiptoCity.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 9, '"' + ShiptoPostCode + '"');
                    CSVBuffer.InsertEntry(LineNo, 10, '"' + ShiptoAttn.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 11, '"' + ShiptoTel.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 12, '"' + ShiptoFax.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 13, '"' + Customer."Shipping Mark1".replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 14, '"' + Customer."Shipping Mark2".replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 15, '"' + Customer."Shipping Mark3".replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 16, '"' + Customer."Shipping Mark4".replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 17, '"' + Customer."Shipping Mark5".replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 18, '"' + Customer.Remarks1.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 19, '"' + Customer.Remarks2.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 20, '"' + Customer.Remarks3.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 21, '"' + Customer.Remarks4.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 22, '"' + Customer.Remarks5.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 23, Format("Sales Line"."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'));
                    CSVBuffer.InsertEntry(LineNo, 24, ItemType);
                    CSVBuffer.InsertEntry(LineNo, 25, "Sales Line"."Customer Order No.");
                    CSVBuffer.InsertEntry(LineNo, 26, "Sales Line"."Parts No.");
                    CSVBuffer.InsertEntry(LineNo, 27, "Sales Line".Rank);
                    CSVBuffer.InsertEntry(LineNo, 28, CountryOfOrigin);
                    CSVBuffer.InsertEntry(LineNo, 29, "Sales Line"."Customer Item No.");
                    CSVBuffer.InsertEntry(LineNo, 30, '"' + Format("Sales Line"."No.") + '"');
                    //N005
                    //CSVBuffer.InsertEntry(LineNo, 31, '"' + Format("Sales Line"."Unit Price") + '"');
                    CSVBuffer.InsertEntry(LineNo, 31, '"' + Format("Sales Line"."Approved Unit Price") + '"');
                    //N005
                    //BC Upgrade Begin
                    //CSVBuffer.InsertEntry(LineNo, 32, "Sales Line"."Currency Code");
                    if "Sales Line"."Currency Code" <> '' then begin
                        CSVBuffer.InsertEntry(LineNo, 32, "Sales Line"."Currency Code");
                    end else begin
                        CSVBuffer.InsertEntry(LineNo, 32, recGLSetup."LCY Code");
                    end;
                    //BC Upgrade End
                    //N005 begin
                    //CSVBuffer.InsertEntry(LineNo, 33, '"' + Format("Sales Line"."Outstanding Quantity") + '"');
                    CSVBuffer.InsertEntry(LineNo, 33, '"' + Format("Sales Line"."Approved Quantity" - "Sales Line"."Quantity Shipped") + '"');
                    //N005 end
                    CSVBuffer.InsertEntry(LineNo, 34, '"' + Format(QtyToShip) + Shortage + '"');
                    CSVBuffer.InsertEntry(LineNo, 35, '"' + "Sales Line"."OEM Name" + '"');
                    CSVBuffer.InsertEntry(LineNo, 36, Format("Sales Line"."Requested Delivery Date_1"));
                    CSVBuffer.InsertEntry(LineNo, 37, "Sales Line"."Document No.");
                    CSVBuffer.InsertEntry(LineNo, 38, Format("Sales Line"."Line No."));
                    CSVBuffer.InsertEntry(LineNo, 39, "Sales Line"."Sell-to Customer No.");
                    CSVBuffer.InsertEntry(LineNo, 40, '"' + CustomerRec.Name.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 41, CustomerRec.County);
                    CSVBuffer.InsertEntry(LineNo, 42, CustomerRec."Country/Region Code");
                    CSVBuffer.InsertEntry(LineNo, 43, CustomerRec."Shipment Method Code");
                    CSVBuffer.InsertEntry(LineNo, 44, '"' + CompanyInfo.Name.replace('"', '""') + '"');
                end;
            }


            trigger OnPostDataItem()
            begin
                CSVBuffer.SaveDataToBlob(TempBlob, ',');
                TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
                fileName := 'Delivery Order List Export_' + format(Today, 0, '<Year4><Month,2><Day,2>') + '.csv';
                DownloadFromStream(InStream, '', '', '', fileName);
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        LineNo := 1;
        CSVBuffer.DeleteAll();
        recGLSetup.Get(); //BC Upgrade
    end;



    trigger OnPreReport()
    begin
        CustFilter := Customer.GETFILTERS;
        SalesLineFilter := "Sales Line".GETFILTERS;
        PeriodText := "Sales Line".GETFILTER("Shipment Date");
        CalcQtyAvailable;

        AddCSVHeader(CSVBuffer, LineNo);

    end;

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
                    //N005 Begin
                    //WorkRec.Quantity := "Sales Line".Quantity - "Sales Line"."Quantity Shipped";
                    WorkRec.Quantity := "Sales Line"."Approved Quantity" - "Sales Line"."Quantity Shipped";
                    //N005 End
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

    var
        CustFilter: Text;
        LineNo: Integer;
        Text000: Label 'Customer No. is empty.';
        CompanyInfo: Record "Company Information";
        CSVBuffer: record "CSV Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStream: instream;
        fileName: text;
        SalesLineFilter: Text[250];
        PeriodText: Text[30];
        recGLSetup: Record "General Ledger Setup";
        QtyRsv: Decimal;
        QtyAvailable: Decimal;

    procedure SetCustomer(CustNo: Text)
    begin
        CustFilter := CustNo;
    end;

    procedure GetCustomer(var CustNo: Text): Boolean
    begin
        CustNo := CustFilter;
        exit(true);
    end;

    local procedure AddCSVHeader(var CSVBuffer: Record "CSV Buffer"; var LineNo: Integer)
    begin
        CSVBuffer.InsertEntry(LineNo, 1, 'Location Code');
        CSVBuffer.InsertEntry(LineNo, 2, 'Attention1');
        CSVBuffer.InsertEntry(LineNo, 3, 'Attention2');
        CSVBuffer.InsertEntry(LineNo, 4, 'CC');
        CSVBuffer.InsertEntry(LineNo, 5, 'Customer Name');
        CSVBuffer.InsertEntry(LineNo, 6, 'Customer Address1');
        CSVBuffer.InsertEntry(LineNo, 7, 'Customer Address2');
        CSVBuffer.InsertEntry(LineNo, 8, 'Customer City');
        CSVBuffer.InsertEntry(LineNo, 9, 'Post Code');
        CSVBuffer.InsertEntry(LineNo, 10, 'Customer Contact');
        CSVBuffer.InsertEntry(LineNo, 11, 'Customer Phone No.');
        CSVBuffer.InsertEntry(LineNo, 12, 'Customer Fax No.');
        CSVBuffer.InsertEntry(LineNo, 13, 'Shipping Mark1');
        CSVBuffer.InsertEntry(LineNo, 14, 'Shipping Mark2');
        CSVBuffer.InsertEntry(LineNo, 15, 'Shipping Mark3');
        CSVBuffer.InsertEntry(LineNo, 16, 'Shipping Mark4');
        CSVBuffer.InsertEntry(LineNo, 17, 'Shipping Mark5');
        CSVBuffer.InsertEntry(LineNo, 18, 'Remarks1');
        CSVBuffer.InsertEntry(LineNo, 19, 'Remarks2');
        CSVBuffer.InsertEntry(LineNo, 20, 'Remarks3');
        CSVBuffer.InsertEntry(LineNo, 21, 'Remarks4');
        CSVBuffer.InsertEntry(LineNo, 22, 'Remarks5');
        CSVBuffer.InsertEntry(LineNo, 23, 'Due Date');
        CSVBuffer.InsertEntry(LineNo, 24, 'Item Type');
        CSVBuffer.InsertEntry(LineNo, 25, 'Customer PO/No.');
        CSVBuffer.InsertEntry(LineNo, 26, 'Product Name');
        CSVBuffer.InsertEntry(LineNo, 27, 'Rank');
        CSVBuffer.InsertEntry(LineNo, 28, 'C/O');
        CSVBuffer.InsertEntry(LineNo, 29, 'Customer P/N');
        CSVBuffer.InsertEntry(LineNo, 30, 'Item No.');
        CSVBuffer.InsertEntry(LineNo, 31, 'Unit Price');
        CSVBuffer.InsertEntry(LineNo, 32, 'Currency Code');
        CSVBuffer.InsertEntry(LineNo, 33, 'O/S Qty.');
        CSVBuffer.InsertEntry(LineNo, 34, 'Qty. to Ship');
        CSVBuffer.InsertEntry(LineNo, 35, 'OEM');
        CSVBuffer.InsertEntry(LineNo, 36, 'Req. Del. Date');
        CSVBuffer.InsertEntry(LineNo, 37, 'SO No.');
        CSVBuffer.InsertEntry(LineNo, 38, 'Line No.');
        CSVBuffer.InsertEntry(LineNo, 39, 'Customer No.');
        CSVBuffer.InsertEntry(LineNo, 40, 'Customer Name');
        CSVBuffer.InsertEntry(LineNo, 41, 'Customer County');
        CSVBuffer.InsertEntry(LineNo, 42, 'Customer Country/Region Code');
        CSVBuffer.InsertEntry(LineNo, 43, 'Customer Shipment Method Code');
        CSVBuffer.InsertEntry(LineNo, 44, 'Company Name');
    end;
}

