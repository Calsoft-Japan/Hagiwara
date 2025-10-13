pageextension 55742 TransferOrdersExt extends "Transfer Orders"
{
    layout
    {



    }
    actions
    {


        addafter("&Print")
        {
            action("DeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Delivery Order List';
                Image = PrintDocument;
                Scope = Repeater;
                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                begin

                    TransferHeader.Reset;
                    TransferHeader.SetRange("No.", Rec."No.");
                    Report.Run(50045, TRUE, FALSE, TransferHeader);


                end;
            }
            action("ExportDeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Export Delivery Order List';
                Image = Export;
                Scope = Repeater;

                trigger OnAction()
                var
                    //DeliveryOrderList: Report DeliveryOrderListTransferOrder;
                    TempDO: Record TempDO;
                    ItemRec: Record Item;
                    TransferHeader: Record "Transfer Header";
                    TempTransferHeader: Record "Transfer Header" temporary;
                    TransferLine: Record "Transfer Line";
                    ItemType: Text[30];
                    CountryOfOrigin: Code[10];
                    CustomerRec: Record Customer;
                    ShortageFlag: Boolean;
                    Shortage: Text[2];
                    QtyToShip: Decimal;
                    QtyAvailable: Decimal;
                    TotalQtyToShip: Decimal;
                    InStream: instream;
                    fileName: text;
                    CSVBuffer: record "CSV Buffer" temporary;
                    LineNo: Integer;
                    Location: Record Location;
                    Attn1: Text[40];
                    Attn2: Text[40];
                    CC: Text[40];
                    TempBlob: Codeunit "Temp Blob";
                    TransfertoAdd1: Text[50];
                    TransfertoAdd2: Text[100];
                    TransfertoAttn: Text[50];
                    TransfertoTel: Text[30];
                    TransfertoFax: Text[30];
                    TransfertoName: Text[50];
                    TransfertoCity: Text[30];
                    TransfertoPostCode: Code[20];
                    TransfertoCounty: Text[30];
                    Customer: Record Customer;
                    CompanyInfo: Record "Company Information";
                    CustList: List of [text];
                    SetCustList: Text;
                    ListText: Text;
                    PartsNo: Text[20];
                    CustomerItemNo: Code[20];
                    Rank: Code[15];
                    OEMName: Text[100];
                begin

                    CompanyInfo.Get();
                    LineNo := 1;

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

                    TransferHeader.Reset();
                    if TransferHeader.FindSet() then begin
                        repeat
                            TempTransferHeader.Reset();
                            TempTransferHeader.SetRange("Transfer-from Code", TransferHeader."Transfer-from Code");
                            TempTransferHeader.SetRange("Transfer-to Code", TransferHeader."Transfer-to Code");
                            if not TempTransferHeader.FindFirst() then begin
                                TempTransferHeader.Init();
                                TempTransferHeader := TransferHeader;
                                TempTransferHeader.Insert();
                            end;
                        until TransferHeader.Next() = 0;
                    end;

                    TempTransferHeader.Reset();
                    if TempTransferHeader.FindFirst() then begin
                        repeat
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
                            IF TempTransferHeader."Transfer-from Code" <> '' THEN BEGIN
                                Location.Reset();
                                Location.SETRANGE(Code, TempTransferHeader."Transfer-from Code");
                                IF Location.FIND('-') THEN begin
                                    Attn1 := Location.Attention1;
                                    Attn2 := Location.Attention2;
                                    CC := Location.CC;
                                end;
                            end;

                            IF TempTransferHeader."Transfer-to Code" <> '' THEN BEGIN
                                Location.Reset();
                                Location.SETRANGE(Code, TempTransferHeader."Transfer-from Code");
                                IF Location.FIND('-') THEN begin
                                    TransfertoName := Location.Name;
                                    TransfertoAdd1 := Location.Address;
                                    TransfertoAdd2 := Location."Address 2" + ' ' + Location.City + ' ' + Location."Post Code";
                                    TransfertoCity := Location.City;
                                    TransfertoPostCode := Location."Post Code";
                                    TransfertoAttn := Location.Contact;
                                    TransfertoTel := Location."Phone No.";
                                    TransfertoFax := Location."Fax No.";
                                    TransfertoCounty := Location.County;
                                end;
                            END;
                            // YUKA for Hagiwara 20050404

                            TransferLine.Reset();
                            TransferLine.SetRange("Transfer-from Code", TempTransferHeader."Transfer-from Code");
                            TransferLine.SetRange("Transfer-to Code", TempTransferHeader."Transfer-to Code");
                            TransferLine.SetFilter("Outstanding Quantity", '>0');

                            //SalesLine.SetRange("Shortcut Dimension 1 Code", Customer."Global Dimension 1 Filter");
                            //SalesLine.SetRange("Shortcut Dimension 2 Code", Customer."Global Dimension 2 Filter");

                            if TransferLine.FindFirst() then begin
                                repeat
                                    // YUKA for Hagiwara 20030219 - END
                                    ItemRec.RESET;
                                    IF TransferLine."Document No." <> '' THEN BEGIN
                                        ItemRec.GET(TransferLine."Item No.");
                                        //ItemType := ItemRec."Product Group Code";
                                        ItemType := ItemRec.Products;
                                        PartsNo := ItemRec."Parts No.";
                                        CustomerItemNo := ItemRec."Customer Item No.";
                                        Rank := ItemRec.Rank;
                                        CustomerRec.Get(ItemRec."OEM No.");
                                        OEMName := CustomerRec.Name;

                                        CountryOfOrigin := ItemRec."Country/Region of Org Cd (FE)";
                                    END;
                                    // YUKA for Hagiwara 20041127

                                    //IF TransferLine.Type = TransferLine.Type::Item THEN BEGIN
                                    ShortageFlag := FALSE;
                                    Shortage := '';
                                    QtyToShip := TransferLine.Quantity - TransferLine."Quantity Shipped";
                                    //QtyAvailable := CheckQty(SalesLine."No.", SalesLine."Location Code", SalesLine."Document No.");
                                    //  TempDO.INIT;
                                    TempDO.SETRANGE(TempDO."Document No.", TransferLine."Document No.", TransferLine."Document No.");
                                    //  tempdo.setfilter(TempDo."Line No.", SalesLine."Line No.", SalesLine."Line No.");
                                    TempDO.SETRANGE(TempDO."Line No.", TransferLine."Line No.", TransferLine."Line No.");

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

                                    TotalQtyToShip += QtyToShip;



                                    LineNo += 1;
                                    CSVBuffer.InsertEntry(LineNo, 1, TempTransferHeader."Transfer-from Code");
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
                                    CSVBuffer.InsertEntry(LineNo, 13, Format(TransferLine."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'));
                                    CSVBuffer.InsertEntry(LineNo, 14, '"' + ItemType.replace('"', '""') + '"');
                                    CSVBuffer.InsertEntry(LineNo, 15, '"' + PartsNo.replace('"', '""') + '"');
                                    CSVBuffer.InsertEntry(LineNo, 16, Rank);
                                    CSVBuffer.InsertEntry(LineNo, 17, CountryOfOrigin);
                                    CSVBuffer.InsertEntry(LineNo, 18, CustomerItemNo);
                                    CSVBuffer.InsertEntry(LineNo, 19, TransferLine."Item No.");
                                    CSVBuffer.InsertEntry(LineNo, 20, '"' + Format(TransferLine."Outstanding Quantity") + '"');
                                    CSVBuffer.InsertEntry(LineNo, 21, '"' + Format(QtyToShip) + Shortage + '"');
                                    CSVBuffer.InsertEntry(LineNo, 22, '"' + OEMName.replace('"', '""') + '"');
                                    CSVBuffer.InsertEntry(LineNo, 23, Format(TransferLine."Receipt Date"));
                                    CSVBuffer.InsertEntry(LineNo, 24, TransferLine."Document No.");
                                    CSVBuffer.InsertEntry(LineNo, 25, Format(TransferLine."Line No."));
                                    CSVBuffer.InsertEntry(LineNo, 26, '"' + TransfertoName.replace('"', '""') + '"');
                                    CSVBuffer.InsertEntry(LineNo, 27, '"' + TransfertoCounty.replace('"', '""') + '"');
                                    CSVBuffer.InsertEntry(LineNo, 28, CountryOfOrigin);
                                    CSVBuffer.InsertEntry(LineNo, 29, TempTransferHeader."Shipment Method Code");
                                    CSVBuffer.InsertEntry(LineNo, 30, '"' + CompanyInfo.Name.replace('"', '""') + '"');


                                until TransferLine.Next() = 0;
                            end;

                        until TempTransferHeader.Next() = 0;
                    end;
                    CSVBuffer.SaveDataToBlob(TempBlob, ',');
                    TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
                    fileName := 'Delivery Order List Export_' + format(Today, 0, '<Year4><Month,2><Day,2>') + '.csv';
                    DownloadFromStream(InStream, '', '', '', fileName);
                end;
            }

        }

        addafter("&Print_Promoted")
        {
            actionref("DeliveryOrderList_Promoted"; DeliveryOrderList)
            {
            }
            actionref("ExportDeliveryOrderList_Promoted"; ExportDeliveryOrderList)
            {
            }
        }
    }
    var
        Amount_LCY: Decimal;

    trigger OnAfterGetRecord()
    begin
        /*
                //SiakHui  20141001 Start
                IF rec."Currency Factor" > 0 THEN BEGIN
                    Amount_LCY := ROUND(rec.Amount / rec."Currency Factor");
                END ELSE BEGIN
                    Amount_LCY := rec.Amount;
                END;
                //SiakHui  20141001 Start
        */
    end;

}
