report 50046 "ExportTransferOrder"
{
    // CS092 2026/03/05 Bobby N004 Export Delivery Order List(Transfer Order)
    ProcessingOnly = true;


    Caption = 'Export Delivery Order List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";

            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Transfer-from Code" = FIELD("Transfer-from Code"),
                                "Transfer-to Code" = FIELD("Transfer-to Code");
                DataItemTableView = SORTING("Shipment Date")
                                    WHERE("Outstanding Quantity" = FILTER(> 0));
                RequestFilterFields = "Shipment Date";
                RequestFilterHeading = 'Transfer Line';



                trigger OnAfterGetRecord()
                var
                    TempDO: Record TempDO;
                begin
                    ItemRec.RESET;
                    IF "Transfer Line"."Document No." <> '' THEN BEGIN
                        ItemRec.GET("Transfer Line"."Item No.");
                        //ItemType := ItemRec."Item Group Code";
                        ItemType := ItemRec.Products;
                        PartsNo := ItemRec."Parts No.";
                        CustomerItemNo := ItemRec."Customer Item No.";
                        Rank := ItemRec.Rank;
                        CustomerRec.Get(ItemRec."OEM No.");
                        OEMName := CustomerRec.Name;

                        CountryOfOrigin := ItemRec."Country/Region of Org Cd (FE)";
                    END;

                    //IF "Transfer Line".Type = "Transfer Line".Type::Item THEN BEGIN
                    ShortageFlag := FALSE;
                    Shortage := '';
                    //QtyToShip := "Transfer Line".Quantity - "Transfer Line"."Quantity Shipped"; //N005
                    QtyToShip := "Transfer Line"."Approved Quantity" - "Transfer Line"."Quantity Shipped";
                    //QtyAvailable := CheckQty("Sales Line"."No.", "Sales Line"."Location Code", "Sales Line"."Document No.");
                    //  TempDO.INIT;
                    TempDO.SETRANGE(TempDO."Document No.", "Transfer Line"."Document No.", "Transfer Line"."Document No.");
                    //  tempdo.setfilter(TempDo."Line No.", "Sales Line"."Line No.", "Sales Line"."Line No.");
                    TempDO.SETRANGE(TempDO."Line No.", "Transfer Line"."Line No.", "Transfer Line"."Line No.");

                    IF TempDO.FIND('-') THEN BEGIN
                        QtyAvailable := TempDO."Assigned Qty";
                        IF QtyAvailable < QtyToShip THEN BEGIN
                            QtyToShip := QtyAvailable;
                            ShortageFlag := TRUE;
                            Shortage := '*'
                        END;
                    END;
                    //END;
                    // YUKA for Hagiwara 20041127 - END

                    //TotalQtyToShip += QtyToShip;
                    /*
                                        IF PrintToExcel THEN BEGIN
                                            IF (CustNo <> Customer."No.") THEN BEGIN
                                                CustNo := Customer."No.";
                                                MakeExcelBodyHeader;
                                            END;
                                            MakeExcelDataBody;
                                        END;
                    */
                    LineNo += 1;
                    CSVBuffer.InsertEntry(LineNo, 1, "Transfer Header"."Transfer-from Code");
                    CSVBuffer.InsertEntry(LineNo, 2, '"' + Attn1.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 3, '"' + Attn2.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 4, '"' + CC.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 5, '"' + TransfertoName.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 6, '"' + TransfertoAdd1.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 7, '"' + TransfertoAdd2.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 8, '"' + TransfertoCity.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 9, '"' + TransfertoPostCode + '"');
                    CSVBuffer.InsertEntry(LineNo, 10, '"' + TransfertoAttn.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 11, '"' + TransfertoTel.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 12, '"' + TransfertoFax.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 13, Format("Transfer Line"."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'));
                    CSVBuffer.InsertEntry(LineNo, 14, '"' + ItemType.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 15, '"' + PartsNo.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 16, Rank);
                    CSVBuffer.InsertEntry(LineNo, 17, CountryOfOrigin);
                    CSVBuffer.InsertEntry(LineNo, 18, CustomerItemNo);
                    CSVBuffer.InsertEntry(LineNo, 19, "Transfer Line"."Item No.");
                    CSVBuffer.InsertEntry(LineNo, 20, '"' + Format("Transfer Line"."Approved Quantity" - "Transfer Line"."Quantity Shipped") + '"');
                    CSVBuffer.InsertEntry(LineNo, 21, '"' + Format(QtyToShip) + Shortage + '"');
                    CSVBuffer.InsertEntry(LineNo, 22, '"' + OEMName.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 23, Format("Transfer Line"."Receipt Date"));
                    CSVBuffer.InsertEntry(LineNo, 24, "Transfer Line"."Document No.");
                    CSVBuffer.InsertEntry(LineNo, 25, Format("Transfer Line"."Line No."));
                    CSVBuffer.InsertEntry(LineNo, 26, '"' + TransfertoName.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 27, '"' + TransfertoCounty.replace('"', '""') + '"');
                    CSVBuffer.InsertEntry(LineNo, 28, TransfertoCountryRegion);
                    CSVBuffer.InsertEntry(LineNo, 29, "Transfer Header"."Shipment Method Code");
                    CSVBuffer.InsertEntry(LineNo, 30, '"' + CompanyInfo.Name.replace('"', '""') + '"');
                end;




            }

            trigger OnAfterGetRecord()
            begin

                // YUKA for Hagiwara 20041127
                Attn1 := '';
                Attn2 := '';
                CC := '';
                TransfertoName := '';
                TransfertoAdd1 := '';
                TransfertoAdd2 := '';
                TransfertoCity := '';
                TransfertoPostCode := '';
                TransfertoTel := '';
                TransfertoFax := '';
                TransfertoCounty := '';
                IF "Transfer Header"."Transfer-from Code" <> '' THEN BEGIN
                    Location.Reset();
                    Location.SETRANGE(Code, "Transfer Header"."Transfer-from Code");
                    IF Location.FIND('-') THEN begin
                        Attn1 := Location.Attention1;
                        Attn2 := Location.Attention2;
                        CC := Location.CC;
                    end;
                end;

                IF "Transfer Header"."Transfer-to Code" <> '' THEN BEGIN
                    TransfertoName := "Transfer Header"."Transfer-to Name";
                    TransfertoAdd1 := "Transfer Header"."Transfer-to Address";
                    TransfertoAdd2 := "Transfer Header"."Transfer-to Address 2" + ' ' + "Transfer Header"."Transfer-to City" + ' ' + "Transfer Header"."Transfer-to Post Code";
                    //TransfertoCity := "Transfer Header"."Transfer-to City";
                    //TransfertoPostCode := "Transfer Header"."Transfer-to Post Code";
                    TransfertoAttn := "Transfer Header"."Transfer-to Contact";
                    Location.Reset();
                    Location.SETRANGE(Code, "Transfer Header"."Transfer-to Code");
                    IF Location.FIND('-') THEN begin
                        TransfertoTel := Location."Phone No.";
                        TransfertoFax := Location."Fax No.";
                        //TransfertoCounty := Location.County;
                    end;
                END;

            end;

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



    var
        CustomerRec: Record Customer;
        LineNo: Integer;
        CSVBuffer: record "CSV Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        InStream: instream;
        fileName: text;
        Location: Record Location;
        ItemType: Text[30];
        ItemRec: Record Item;
        Attn1: Text[40];
        Attn2: Text[40];
        CC: Text[40];
        TransfertoAdd1: Text[100];
        TransfertoAdd2: Text[100];
        TransfertoAttn: Text[100];
        TransfertoTel: Text[30];
        TransfertoFax: Text[30];
        TransfertoName: Text[100];
        TransfertoCity: Text[30];
        TransfertoPostCode: Code[20];
        TransfertoCounty: Text[30];
        TransfertoCountryRegion: Code[10];
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        CustList: List of [text];
        SetCustList: Text;
        ListText: Text;
        PartsNo: Text[40];
        CustomerItemNo: Code[20];
        Rank: Code[15];
        OEMName: Text[100];
        SalesLineFilter: Text[250];
        PeriodText: Text[30];
        CountryOfOrigin: Code[10];
        QtyToShip: Decimal;
        QtyRsv: Decimal;
        QtyAvailable: Decimal;
        ShortageFlag: Boolean;
        Shortage: Text[2];

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        LineNo := 1;
        CSVBuffer.DeleteAll();
    end;



    trigger OnPreReport()
    begin
        AddCSVHeader(CSVBuffer, LineNo);
    end;


    local procedure AddCSVHeader(var CSVBuffer: Record "CSV Buffer"; var LineNo: Integer)
    begin
        CSVBuffer.InsertEntry(LineNo, 1, 'Transfer-from Code');
        CSVBuffer.InsertEntry(LineNo, 2, 'Attention1');
        CSVBuffer.InsertEntry(LineNo, 3, 'Attention2');
        CSVBuffer.InsertEntry(LineNo, 4, 'CC');
        CSVBuffer.InsertEntry(LineNo, 5, 'Transfer-to Name');
        CSVBuffer.InsertEntry(LineNo, 6, 'Transfer-to Address');
        CSVBuffer.InsertEntry(LineNo, 7, 'Transfer-to Address2');
        CSVBuffer.InsertEntry(LineNo, 8, 'Transfer-to City');
        CSVBuffer.InsertEntry(LineNo, 9, 'Transfer-to Post Code');
        CSVBuffer.InsertEntry(LineNo, 10, 'Transfer-to Contact');
        CSVBuffer.InsertEntry(LineNo, 11, 'Transfer-to Phone No.');
        CSVBuffer.InsertEntry(LineNo, 12, 'Transfer-to Fax No.');
        CSVBuffer.InsertEntry(LineNo, 13, 'Due Date');
        CSVBuffer.InsertEntry(LineNo, 14, 'Item Type');
        CSVBuffer.InsertEntry(LineNo, 15, 'Product Name');
        CSVBuffer.InsertEntry(LineNo, 16, 'Rank');
        CSVBuffer.InsertEntry(LineNo, 17, 'C/O');
        CSVBuffer.InsertEntry(LineNo, 18, 'Customer P/N');
        CSVBuffer.InsertEntry(LineNo, 19, 'Item No.');
        CSVBuffer.InsertEntry(LineNo, 20, 'O/S Qty.');
        CSVBuffer.InsertEntry(LineNo, 21, 'Qty. to Ship');
        CSVBuffer.InsertEntry(LineNo, 22, 'OEM');
        CSVBuffer.InsertEntry(LineNo, 23, 'Req. Del. Date');
        CSVBuffer.InsertEntry(LineNo, 24, 'TO No.');
        CSVBuffer.InsertEntry(LineNo, 25, 'Line No.');
        CSVBuffer.InsertEntry(LineNo, 26, 'Transfer-to Name');
        CSVBuffer.InsertEntry(LineNo, 27, 'Transfer-to County');
        CSVBuffer.InsertEntry(LineNo, 28, 'Transfer-to Country/Region Code');
        CSVBuffer.InsertEntry(LineNo, 29, 'Transfer-to Shipment Method Code');
        CSVBuffer.InsertEntry(LineNo, 30, 'Company Name');
    end;

}

