pageextension 59305 SalesOrderListExt extends "Sales Order List"
{
    layout
    {

        addafter("No.")
        {
            field("Order Date"; rec."Order Date")
            {

                ApplicationArea = all;
            }

        }

        addafter("Sell-to Customer Name")
        {

            field("Item Supplier Source"; rec."Item Supplier Source")
            {

                ApplicationArea = all;
            }
            field("OEM No."; rec."OEM No.")
            {

                ApplicationArea = all;
            }
            field("OEM Name"; rec."OEM Name")
            {

                ApplicationArea = all;
            }
            field(Ship; rec.Ship)
            {

                ApplicationArea = all;
            }
            field("Order Count"; rec."Order Count")
            {

                ApplicationArea = all;
            }
            field("Full Shipped Count"; rec."Full Shipped Count")
            {

                ApplicationArea = all;
            }
            field("Qty Invoiced"; rec."Qty Invoiced")
            {

                ApplicationArea = all;
            }
            field("Qty Ordered"; rec."Qty Ordered")
            {

                ApplicationArea = all;
            }
            field("Qty Shipped"; rec."Qty Shipped")
            {

                ApplicationArea = all;
            }
            field("Qty Outstanding (Actual)"; rec."Qty Outstanding (Actual)")
            {

                ApplicationArea = all;
            }
            field("Approval Status"; rec."Approval Status")
            {
                ApplicationArea = all;
            }
            field("Approver"; rec."Hagi Approver")
            {
                ApplicationArea = all;
            }
            field("Requester"; rec."Requester")
            {
                ApplicationArea = all;
            }
            field("Approval Cycle No."; rec."Approval Cycle No.")
            {
                ApplicationArea = all;
            }

        }

        addafter("Posting Date")
        {

            field("Amount(LCY)"; Amount_LCY)
            {

                ApplicationArea = all;
            }
            field("Message Status(Booking)"; rec."Message Status(Booking)")
            {

                ApplicationArea = all;
            }
            field("Message Collected On(Booking)"; rec."Message Collected On(Booking)")
            {

                ApplicationArea = all;
            }
        }

        addafter("Package Tracking No.")
        {
            field("Shipment Tracking Date"; rec."Shipment Tracking Date")
            {

                ApplicationArea = all;
            }
        }

    }
    actions
    {

        //hide approve related actions of Base App
        modify("Request Approval")
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }

        modify("Email Confirmation")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
            end;
        }

        modify("Print Confirmation")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
            end;
        }

        modify("AttachAsPDF")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
            end;
        }

        addbefore("P&osting")
        {
            group("Hagiwara Approval")
            {
                action("Submit")
                {

                    ApplicationArea = all;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then
                            Error('This approval request can''t be sent because it''s sent already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Cancel")
                {

                    ApplicationArea = all;
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Approve")
                {

                    ApplicationArea = all;
                    Image = Approve;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Reject")
                {

                    ApplicationArea = all;
                    Image = Reject;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Approval Entries")
                {

                    ApplicationArea = all;
                    Image = Entries;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        recApprEntry: Record "Hagiwara Approval Entry";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Sales Order");
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }


        addafter("AttachAsPDF")
        {
            action("DeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Delivery Order List';
                Image = PrintDocument;
                Scope = Repeater;
                trigger OnAction()
                var
                    Customer: Record Customer;
                begin

                    Customer.Reset;
                    Customer.SetRange("No.", Rec."Sell-to Customer No.");
                    Report.Run(50044, TRUE, FALSE, Customer);

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
                    DeliveryOrderList: Report 50044;
                    TempDO: Record TempDO;
                    ItemRec: Record Item;
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
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
                    Shipto: Record "Ship-to Address";
                    ShiptoAdd1: Text[50];
                    ShiptoAdd2: Text[100];
                    ShiptoAttn: Text[50];
                    ShiptoTel: Text[30];
                    ShiptoFax: Text[30];
                    ShiptoName: Text[50];
                    ShiptoCity: Text[30];
                    ShiptoPostCode: Code[20];
                    Customer: Record Customer;
                    CompanyInfo: Record "Company Information";
                    CustList: List of [text];
                    SetCustList: Text;
                    ListText: Text;
                begin


                    CompanyInfo.Get();
                    LineNo := 1;

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


                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    if SalesHeader.FindFirst() then begin
                        repeat
                            if not CustList.Contains(SalesHeader."Sell-to Customer No.") then begin
                                CustList.Add(SalesHeader."Sell-to Customer No.");
                            end;
                        until SalesHeader.Next() = 0;
                    end;
                    if CustList.Count > 0 then begin
                        foreach ListText in CustList do begin
                            if ListText <> '' then begin


                                Customer.Get(ListText);
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

                                SalesLine.Reset();
                                SalesLine.SetCurrentKey("Document Type", "Sell-to Customer No.", "Parts No.", "Shipment Date", "Customer Order No.");
                                SalesLine.SetRange("Bill-to Customer No.", Rec."Bill-to Customer No.");
                                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetFilter("Outstanding Quantity", '>0');

                                //SalesLine.SetRange("Shortcut Dimension 1 Code", Customer."Global Dimension 1 Filter");
                                //SalesLine.SetRange("Shortcut Dimension 2 Code", Customer."Global Dimension 2 Filter");

                                if SalesLine.FindFirst() then begin
                                    repeat
                                        // YUKA for Hagiwara 20030219 - END
                                        ItemRec.RESET;
                                        IF SalesLine."No." <> '' THEN BEGIN
                                            ItemRec.GET(SalesLine."No.");
                                            //ItemType := ItemRec."Product Group Code";
                                            ItemType := ItemRec."Item Group Code";
                                            //CS016 Begin
                                            SalesHeader.GET(SalesHeader."Document Type"::Order, SalesLine."Document No.");
                                            CustomerRec.GET(SalesHeader."Sell-to Customer No.");
                                            IF CustomerRec."Default Country/Region of Org" = CustomerRec."Default Country/Region of Org"::"Front-end" THEN
                                                CountryOfOrigin := ItemRec."Country/Region of Org Cd (FE)"
                                            ELSE
                                                CountryOfOrigin := ItemRec."Country/Region of Origin Code";
                                            //CS016 End
                                        END;
                                        // YUKA for Hagiwara 20041127

                                        IF SalesLine.Type = SalesLine.Type::Item THEN BEGIN
                                            ShortageFlag := FALSE;
                                            Shortage := '';
                                            QtyToShip := SalesLine.Quantity - SalesLine."Quantity Shipped";
                                            //QtyAvailable := CheckQty(SalesLine."No.", SalesLine."Location Code", SalesLine."Document No.");
                                            //  TempDO.INIT;
                                            TempDO.SETRANGE(TempDO."Document No.", SalesLine."Document No.", SalesLine."Document No.");
                                            //  tempdo.setfilter(TempDo."Line No.", SalesLine."Line No.", SalesLine."Line No.");
                                            TempDO.SETRANGE(TempDO."Line No.", SalesLine."Line No.", SalesLine."Line No.");

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
                                        CSVBuffer.InsertEntry(LineNo, 1, SalesLine."Location Code");
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
                                        CSVBuffer.InsertEntry(LineNo, 23, Format(SalesLine."Shipment Date", 0, '<Day,2>/<Month,2>/<Year4>'));
                                        CSVBuffer.InsertEntry(LineNo, 24, ItemType);
                                        CSVBuffer.InsertEntry(LineNo, 25, SalesLine."Customer Order No.");
                                        CSVBuffer.InsertEntry(LineNo, 26, SalesLine."Parts No.");
                                        CSVBuffer.InsertEntry(LineNo, 27, SalesLine.Rank);
                                        CSVBuffer.InsertEntry(LineNo, 28, CountryOfOrigin);
                                        CSVBuffer.InsertEntry(LineNo, 29, SalesLine."Customer Item No.");
                                        CSVBuffer.InsertEntry(LineNo, 30, SalesLine."No.");
                                        CSVBuffer.InsertEntry(LineNo, 31, '"' + Format(SalesLine."Unit Price") + '"');
                                        CSVBuffer.InsertEntry(LineNo, 32, SalesLine."Currency Code");
                                        CSVBuffer.InsertEntry(LineNo, 33, '"' + Format(SalesLine."Outstanding Quantity") + '"');
                                        CSVBuffer.InsertEntry(LineNo, 34, '"' + Format(QtyToShip) + Shortage + '"');
                                        CSVBuffer.InsertEntry(LineNo, 35, '"' + SalesLine."OEM Name" + '"');
                                        CSVBuffer.InsertEntry(LineNo, 36, Format(SalesLine."Requested Delivery Date_1"));
                                        CSVBuffer.InsertEntry(LineNo, 37, SalesLine."Document No.");
                                        CSVBuffer.InsertEntry(LineNo, 38, Format(SalesLine."Line No."));
                                        CSVBuffer.InsertEntry(LineNo, 39, SalesLine."Sell-to Customer No.");
                                        CSVBuffer.InsertEntry(LineNo, 40, '"' + CustomerRec.Name.replace('"', '""') + '"');
                                        CSVBuffer.InsertEntry(LineNo, 41, CustomerRec.County);
                                        CSVBuffer.InsertEntry(LineNo, 42, CustomerRec."Country/Region Code");
                                        CSVBuffer.InsertEntry(LineNo, 43, CustomerRec."Shipment Method Code");
                                        CSVBuffer.InsertEntry(LineNo, 44, '"' + CompanyInfo.Name.replace('"', '""') + '"');

                                    until SalesLine.Next() = 0;
                                end;
                            end;
                        end;
                    end;
                    CSVBuffer.SaveDataToBlob(TempBlob, ',');
                    TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
                    fileName := 'Delivery Order List Export_' + format(Today, 0, '<Year4><Month,2><Day,2>') + '.csv';
                    DownloadFromStream(InStream, '', '', '', fileName);

                end;
            }
            action("ProformaInvoice")
            {
                ApplicationArea = all;
                Caption = 'Proforma Invoice ';
                Image = PrintDocument;
                Scope = Repeater;

                trigger OnAction()
                var
                    ProformaInvoice: Report "Proforma Invoice";
                begin
                    //Report.Run(50066, TRUE, FALSE, Rec);
                    ProformaInvoice.Run();
                end;
            }
        }

        addafter("AttachAsPDF_Promoted")
        {
            actionref("DeliveryOrderList_Promoted"; DeliveryOrderList)
            {
            }
            actionref("ExportDeliveryOrderList_Promoted"; ExportDeliveryOrderList)
            {
            }
            actionref("ProformaInvoice_Promoted"; ProformaInvoice)
            {
            }
        }
    }
    var
        Amount_LCY: Decimal;

    trigger OnAfterGetRecord()
    begin

        //SiakHui  20141001 Start
        IF rec."Currency Factor" > 0 THEN BEGIN
            Amount_LCY := ROUND(rec.Amount / rec."Currency Factor");
        END ELSE BEGIN
            Amount_LCY := rec.Amount;
        END;
        //SiakHui  20141001 Start

    end;


}
