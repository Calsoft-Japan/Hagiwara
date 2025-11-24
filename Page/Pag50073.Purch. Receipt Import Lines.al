page 50073 "Purch. Receipt Import Lines"
{
    // HG10.00.12 NJ 02/05/2018 - New Page Created
    // CS023 Kenya 2021/07/27 - Roll-out Renesas Receipt/Invoice Upload
    // CS054 Kenya 2023/05/28 - Change to Set Quantity to Receive at Receive
    // CS079 Shawn 2024/06/01 - Check and Logic Change. (CO No. => PO No.+Line No. as well)
    // CS095 Kenya 2025/02/06 - Add Unit Cost

    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    SourceTable = "Purch. Receipt Import Staging";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch No."; REC."Batch No.")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; REC."Entry No.")
                {
                    ApplicationArea = all;
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = all;
                }
                field("Receipt No."; REC."Receipt No.")
                {
                    ApplicationArea = all;
                }
                field("PO No."; REC."PO No.")
                {
                    ApplicationArea = all;
                }
                field("Line No."; REC."Line No.")
                {
                    ApplicationArea = all;
                }
                field("CO No."; REC."CO No.")
                {
                    ApplicationArea = all;
                }
                field("Warehouse Ref."; REC."Warehouse Ref.")
                {
                    ApplicationArea = all;
                }
                field("Arrival Date"; REC."Arrival Date")
                {
                    ApplicationArea = all;
                }
                field("Closed Date"; REC."Closed Date")
                {
                    ApplicationArea = all;
                }
                field("Imported Item No."; REC."Imported Item No.")
                {
                    Caption = 'Item No.';
                }
                field("Received Qty."; REC."Received Qty.")
                {
                    ApplicationArea = all;
                }
                field("Qty. To Invoice"; REC."Qty. To Invoice")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; REC."Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Import Date"; REC."Import Date")
                {
                    ApplicationArea = all;
                }
                field("Import User ID"; REC."Import User ID")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Proforma Invoice"; REC."Proforma Invoice")
                {
                    ApplicationArea = all;
                }
                field("Error Description"; REC."Error Description")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Purchase)
            {
                action(Import)
                {
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        cduImporter: Codeunit "Imp. Purch. Rcpt. & Inv. Data";
                        TransType: Option Receipt,Invoice,ReceiptInvoice;
                    begin
                        cduImporter.SetTransType(TransType::Receipt);
                        cduImporter.Run();
                    end;
                }
                action("Validate & Process")
                {
                    Image = ViewCheck;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "Purch. Receipt Import Staging";
                        PurchFound: Boolean;
                    begin
                        Staging.SETCURRENTKEY("Batch No.");
                        Staging.SETFILTER(Staging.Status, '<>%1', Staging.Status::Processed);
                        Staging.SETRANGE(Staging."Batch No.", Rec."Batch No.");
                        IF Staging.FINDFIRST THEN
                            REPEAT
                                CheckError(Staging);
                            UNTIL Staging.NEXT = 0;

                        CurrPage.UPDATE;
                        //MESSAGE('Validation Completed Please Check Status');

                        //process starts here



                        Staging.SETCURRENTKEY(Status, "Batch No.");
                        Staging.SETFILTER(Staging.Status, '=%1', Staging.Status::OK);
                        Staging.SETRANGE(Staging."Batch No.", Rec."Batch No.");
                        IF Staging.FINDFIRST THEN
                            REPEAT

                                IF (Staging."PO No." = '') OR (Staging."Line No." = 0) THEN BEGIN // CS079
                                                                                                  //CS023 Begin
                                    PurchaseLine2.RESET;
                                    PurchaseLine2.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                    PurchaseLine2.SETRANGE(Type, PurchaseLine.Type::Item);
                                    PurchaseLine2.SETRANGE("CO No.", Staging."CO No.");
                                    IF PurchaseLine2.FINDFIRST THEN BEGIN
                                        PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchaseLine2."Document No.");
                                        Staging."PO No." := PurchaseLine2."Document No.";
                                        Staging.MODIFY;
                                    END;
                                    //CS023 End
                                    //CS079 Begin
                                END ELSE BEGIN
                                    PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, Staging."PO No.");
                                END;
                                //CS079 End
                                //PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,Staging."PO No."); //CS023
                                PurchaseHeader.VALIDATE("Posting Date", Staging."Closed Date");
                                PurchaseHeader.VALIDATE("Goods Arrival Date", Staging."Arrival Date");
                                //PurchaseHeader.VALIDATE("Vendor Order No.",Staging."Proforma Invoice");//contact@splendidinfotech.com //CS023
                                //PurchaseHeader.VALIDATE("Vendor Shipment No.", Staging."Proforma Invoice");//contact@splendidinfotech.com
                                //PurchaseHeader.VALIDATE("Vendor Invoice No.",Staging."Proforma Invoice");//contact@splendidinfotech.com
                                PurchaseHeader.Validate("Vendor Shipment No.", Staging."Receipt No."); // BC upgrade

                                PurchaseHeader.MODIFY;

                                PurchaseLine2.RESET;
                                PurchaseLine2.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                PurchaseLine2.SETRANGE(Type, PurchaseLine.Type::Item);
                                PurchaseLine2.SETRANGE("Document No.", Staging."PO No.");
                                //PurchaseLine2.SETRANGE("CO No.",Staging."CO No.");//CS079
                                //CS079 Begin
                                IF (Staging."PO No." <> '') AND (Staging."Line No." <> 0) THEN BEGIN
                                    PurchaseLine2.SETRANGE("Line No.", Staging."Line No.");
                                END ELSE BEGIN
                                    PurchaseLine2.SETRANGE("CO No.", Staging."CO No.");
                                END;
                                //CS079 End
                                IF PurchaseLine2.FINDSET THEN BEGIN
                                    REPEAT
                                        PurchaseLine2.VALIDATE("Qty. to Receive", 0);
                                        // PurchaseLine2.VALIDATE("Qty. to Invoice",0);

                                        PurchaseLine2.MODIFY;

                                    UNTIL PurchaseLine2.NEXT = 0;
                                END;

                                /* //CS054
                                  PurchFound := FALSE;  //CS023

                                  PurchaseLine.RESET;
                                  PurchaseLine.SETRANGE("Document Type",PurchaseLine."Document Type"::Order);
                                  //PurchaseLine.SETRANGE("Document No.",Staging."PO No."); //CS023
                                  PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
                                  //PurchaseLine.SETRANGE("No.",Staging."Item No.");
                                  PurchaseLine.SETRANGE("CO No.",Staging."CO No."); //CS023
                                  PurchaseLine.SETCURRENTKEY("Outstanding Quantity"); //CS023
                                  PurchaseLine.SETASCENDING("Outstanding Quantity", TRUE); //CS023
                                  IF PurchaseLine.FINDSET THEN BEGIN
                                    //CS023 Begin
                                    REPEAT
                                      IF NOT(PurchFound) AND (PurchaseLine."Outstanding Quantity" >= Staging."Received Qty.") THEN BEGIN
                                        PurchaseLine."Goods Arrival Date" := Staging."Arrival Date";
                                        PurchaseLine.VALIDATE("Qty. to Receive",Staging."Received Qty.");
                                        PurchaseLine.MODIFY;
                                        PurchFound := TRUE;
                                      END;
                                    UNTIL PurchaseLine.NEXT = 0;

                                    //PurchaseLine."Goods Arrival Date" := Staging."Arrival Date";
                                    //PurchaseLine."Qty. to Receive" := Staging."Received Qty.";
                                    //PurchaseLine.VALIDATE("Qty. to Receive",Staging."Received Qty.");
                                    //PurchaseLine.VALIDATE("Qty. to Invoice",Staging."Qty. To Invoice");//contact@splendidinfotech.com

                                    //PurchaseLine.MODIFY;
                                    //CS023 End
                                  END;
                                */

                                Staging1.GET(Staging."Batch No.", Staging."Entry No.");
                                Staging1.Status := Staging1.Status::Processed;
                                Staging1.MODIFY;

                            UNTIL Staging.NEXT = 0;


                        PurchaseLine.RESET;
                        PurchReceiptImportStaging.RESET;
                        PurchReceiptImportStaging.SETFILTER(Status, 'Processed');
                        IF PurchReceiptImportStaging.FINDSET THEN BEGIN
                            REPEAT
                                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                                //PurchaseLine.SETRANGE("Document No.",PurchReceiptImportStaging."PO No."); //CS023
                                //PurchaseLine.SETRANGE("No.","Item No.");
                                //PurchaseLine.SETRANGE("CO No.",PurchReceiptImportStaging."CO No.");//CS079
                                //CS079 Begin
                                IF (PurchReceiptImportStaging."PO No." <> '') AND (PurchReceiptImportStaging."Line No." <> 0) THEN BEGIN
                                    PurchaseLine.SETRANGE("Line No.", PurchReceiptImportStaging."Line No.");
                                END ELSE BEGIN
                                    PurchaseLine.SETRANGE("CO No.", PurchReceiptImportStaging."CO No.");
                                END;
                                //CS079 End
                                IF PurchaseLine.FINDSET THEN BEGIN
                                    REPEAT  //CS023
                                            //PurchaseLine.VALIDATE("Qty. to Receive",PurchReceiptImportStaging."Received Qty."); //CS023
                                        PurchaseLine.VALIDATE("Qty. to Invoice", 0);
                                        //PurchaseLine."Qty. to Receive" := "Received Qty.";
                                        PurchaseLine.MODIFY;
                                    UNTIL PurchaseLine.NEXT = 0;  //CS023
                                END

                            UNTIL PurchReceiptImportStaging.NEXT = 0;


                            MESSAGE('Validation & Process Completed.');
                        END

                        // process ends here

                    end;
                }
                action("Post Receive")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RptPostRcpt: Report "PO Post Receive";
                    begin
                        IF not DIALOG.CONFIRM('Are you sure you want to post the receipt?', TRUE) THEN
                            exit;

                        //BC Upgrade
                        RptPostRcpt.Run();

                        PurchReceiptImportStaging.RESET;
                        PurchReceiptImportStaging.SETRANGE(Status, PurchReceiptImportStaging.Status::OK);
                        IF PurchReceiptImportStaging.FINDSET() THEN PurchReceiptImportStaging.DELETEALL();

                        CurrPage.UPDATE();

                        //BC Upgrade
                    end;
                }
                action("Delete All")
                {
                    ApplicationArea = All;
                    Caption = 'Delete All';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Staging: Record "Purch. Receipt Import Staging";
                    begin
                        IF NOT CONFIRM('Do you want to delete all the records?') THEN
                            EXIT;

                        Staging.DELETEALL;
                    end;
                }
            }
        }
    }

    var
        PurchReceiptImportStaging: Record "PURCH. RECEIPT IMPORT STAGING";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine1: Record "Purchase Line";
        Staging1: Record "PURCH. RECEIPT IMPORT STAGING";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine2: Record "Purchase Line";

    procedure CheckError(p_Staging: Record "Purch. Receipt Import Staging")
    var
        Item: Record "Item";
        ItemNo: Code[20];
        PurchaseHeader: Record "PURCHASE HEADER";
        PurchaseLine: Record "PURCHASE LINE";
        ErrorDesc1: Text;
        ErrorDesc2: Text;
        ErrorDesc3: Text;
        ErrorDesc4: Text;
        Staging: Record "PURCH. RECEIPT IMPORT STAGING";
        Text001: Label 'Entry No. %1 contains contradictory data. Do you want to proceed.';
        ErrorDesc5: Text;
        ErrorDesc6: Text;
        ErrorDesc7: Text;
        ErrorDesc8: Text;
        ErrorQty: Boolean;
        ErrorDesc9: Text;
        ErrorRcptNo: Text;
        ErrorDuplCONo: Text;
    begin
        Item.RESET;
        //Item.SETRANGE(Description,p_Staging."Imported Item No.");
        Item.SETRANGE(Description, p_Staging.Description);
        Item.SetRange(Blocked, false);
        IF Item.FINDFIRST THEN
            ItemNo := Item."No."
        ELSE BEGIN
            Item.RESET;
            Item.SETRANGE("Customer Item No.", p_Staging."Imported Item No.");
            Item.SetRange(Blocked, false);
            IF Item.FINDFIRST THEN
                ItemNo := Item."No."
            ELSE BEGIN
                //Arpit-22-May-Start
                Item.RESET;
                Item.SETRANGE("Vendor Item No.", p_Staging."Imported Item No.");
                Item.SetRange(Blocked, false);

                IF Item.FINDFIRST THEN
                    ItemNo := Item."No.";
                //ELSE
                //Arpit-22-May-Stop
                //  ErrorDesc1 := ',Item Not Found';
            END
        END;

        //BC Upgrade
        IF ItemNo = '' THEN begin
            ErrorDesc1 := ',Item Not Found.';
        end;

        /*
        //Arpit-28.06.2018-START
        IF ItemNo = '' THEN BEGIN
            Item.RESET;
            Item.SETRANGE(Description, p_Staging.LPN);
            Item.SetRange(Blocked, false);
            IF Item.FINDFIRST THEN
                ItemNo := Item."No."
            ELSE BEGIN
                Item.RESET;
                Item.SETRANGE("Customer Item No.", p_Staging.LPN);
                Item.SetRange(Blocked, false);
                IF Item.FINDFIRST THEN
                    ItemNo := Item."No."
                ELSE BEGIN
                    //Arpit-22-May-Start
                    Item.RESET;
                    Item.SETRANGE("Vendor Item No.", p_Staging.LPN);
                    Item.SetRange(Blocked, false);
                    IF Item.FINDFIRST THEN
                        ItemNo := Item."No."
                    ELSE
                        //Arpit-22-May-Stop
                        ErrorDesc1 := ',Item Not Found.';
                END;
            END;
        END;
        //Arpit-28.06.2018-STOP
        */
        //BC Upgrade

        //CS079 Del Begin
        /*
        //CS023 Begin
        IF p_Staging."CO No." = '' THEN
          ErrorDesc2 := ',CO No. Must Have Value'
        ELSE BEGIN
          PurchaseLine1.RESET;
          PurchaseLine1.SETRANGE("Document Type",PurchaseLine."Document Type"::Order);
          PurchaseLine1.SETRANGE(Type,PurchaseLine.Type::Item);
          PurchaseLine1.SETRANGE("CO No.",p_Staging."CO No.");
          IF NOT PurchaseLine1.FINDFIRST THEN
          //IF NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,p_Staging."PO No.") THEN
            ErrorDesc3 := ',Purchase Order Not Found'
          //CS023 End
          ELSE BEGIN
            IF p_Staging."Arrival Date" = 0D THEN ErrorDesc5 :=',Arrival Date Must Have Value';
            IF p_Staging."Proforma Invoice" = '' THEN ErrorDesc6 :=',Performa Invoice No. Must Have Value';

            IF ItemNo <> '' THEN BEGIN
              PurchaseLine1.RESET;
              //PurchaseLine1.SETRANGE("Document No.",p_Staging."PO No.");  //CS023
              PurchaseLine1.SETFILTER(Type,'%1',2);
              //PurchaseLine1.SETRANGE("No.",Item."No.");
              PurchaseLine1.SETRANGE("CO No.",p_Staging."CO No.");
              //IF NOT PurchaseLine1.FINDFIRST THEN
              ErrorQty := TRUE; //CS023
              IF PurchaseLine1.FINDSET THEN BEGIN //CS023
              //IF NOT PurchaseLine.GET(PurchaseHeader."Document Type"::Order,p_Staging."PO No.",Item."No.") THEN
                //ErrorDesc3 := ',Purchase Order Line Not Found'
              //ELSE BEGIN
                REPEAT //CS023
                  IF PurchaseLine1."Customer Item No." <> p_Staging."Imported Item No." THEN
                    ErrorDesc7 := ',Customer item is wrong.';

                    IF PurchaseLine1.Description <> p_Staging.Description THEN
                    ErrorDesc8 := ',Description is wrong.';
                //CS023 Begin
                    IF PurchaseLine1."Outstanding Quantity" >= p_Staging."Received Qty." THEN
                      ErrorQty := FALSE;
                UNTIL PurchaseLine1.NEXT = 0;
                IF ErrorQty THEN
                  ErrorDesc4 := ',Received Qty. is more than PO Original Qty.';
                //CS023 End
              END;
            END;
          END;
        END;
        */
        //CS079 Del End

        //CS079 Add Begin
        IF (p_Staging."CO No." = '')
          AND ((p_Staging."PO No." = '') OR (p_Staging."Line No." = 0)) THEN
            ErrorDesc2 := ',CO No. or (PO No. and Line No.) Must Have Value.'
        ELSE BEGIN
            IF (p_Staging."PO No." <> '') AND (p_Staging."Line No." <> 0) THEN
                IF NOT PurchaseLine1.GET(PurchaseLine1."Document Type"::Order, p_Staging."PO No.", p_Staging."Line No.") THEN
                    ErrorDesc9 := ',Purchase Line Not Found.';

            PurchaseLine1.Reset();
            PurchaseLine1.SetRange("CO No.", p_Staging."CO No.");
            if PurchaseLine1.Count > 1 then begin
                ErrorDuplCONo := ',CO No. is not unique. Please enter PO No. and Line No., and keep CO No. empty.';
            end;

            PurchaseLine1.RESET;
            PurchaseLine1.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine1.SETRANGE(Type, PurchaseLine.Type::Item);
            IF (p_Staging."PO No." <> '') AND (p_Staging."Line No." <> 0) THEN BEGIN
                PurchaseLine1.SETRANGE("Document No.", p_Staging."PO No.");
                PurchaseLine1.SETRANGE("Line No.", p_Staging."Line No.");
            END ELSE BEGIN
                PurchaseLine1.SETRANGE("CO No.", p_Staging."CO No.");
            END;
            IF PurchaseLine1.ISEMPTY THEN BEGIN
                IF ErrorDesc9 = '' THEN
                    ErrorDesc3 := ',Purchase Order Not Found.'
            END ELSE BEGIN
                IF p_Staging."Arrival Date" = 0D THEN ErrorDesc5 := ',Arrival Date Must Have Value.';
                //IF p_Staging."Proforma Invoice" = '' THEN ErrorDesc6 := ',Performa Invoice No. Must Have Value.'; //BC Upgrade
                if p_Staging."Receipt No." = '' then ErrorRcptNo := ',Receipt No. Must Have Value';

                IF ItemNo <> '' THEN BEGIN
                    ErrorQty := TRUE;
                    IF PurchaseLine1.FINDSET THEN BEGIN
                        REPEAT
                            IF PurchaseLine1."Customer Item No." <> p_Staging."Imported Item No." THEN
                                ErrorDesc7 := ',Customer item is wrong.';

                            //BC Upgrade
                            /*
                            IF LowerCase(PurchaseLine1.Description) <> LowerCase(p_Staging.Description) THEN
                                ErrorDesc8 := ',Description is wrong.';
                            */

                            //BC Upgrade
                            if p_Staging."Unit Cost" <> 0 then begin
                                IF PurchaseLine1."Direct Unit Cost" <> p_Staging."Unit Cost" THEN
                                    ErrorDesc8 := ',Unit cost is wrong.';
                            end;
                            //BC Upgrade

                            IF PurchaseLine1."Outstanding Quantity" >= p_Staging."Received Qty." THEN
                                ErrorQty := FALSE;
                        UNTIL PurchaseLine1.NEXT = 0;
                        IF ErrorQty THEN
                            ErrorDesc4 := ',Received Qty. is more than PO Original Qty.';
                    END;
                END;
            END;
        END;
        //CS079 Add End

        Staging.GET(p_Staging."Batch No.", p_Staging."Entry No.");
        IF ItemNo <> '' THEN BEGIN
            Staging."Item No." := ItemNo;
        END;

        //IF (ErrorDesc1 <> '') OR (ErrorDesc2 <> '') OR (ErrorDesc3 <> '') OR (ErrorDesc4 <> '') THEN BEGIN
        //CS079 Begin
        //IF (ErrorDesc1 <> '') OR (ErrorDesc2 <> '') OR (ErrorDesc3 <> '') OR (ErrorDesc4 <> '') OR (ErrorDesc5 <> '') OR (ErrorDesc6 <>'') OR (ErrorDesc7 <>'') OR (ErrorDesc8 <>'') THEN BEGIN
        IF (ErrorDesc1 <> '') OR (ErrorDesc2 <> '') OR (ErrorDesc3 <> '') OR (ErrorDesc4 <> '') OR (ErrorDesc5 <> '')
        OR (ErrorDesc6 <> '') OR (ErrorDesc7 <> '') OR (ErrorDesc8 <> '') OR (ErrorDesc9 <> '') OR (ErrorRcptNo <> '')
        OR (ErrorDuplCONo <> '') THEN BEGIN
            //CS079 End
            Staging.GET(p_Staging."Batch No.", p_Staging."Entry No.");
            IF ItemNo <> '' THEN
                Staging."Item No." := ItemNo;
            //Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4,2);
            //CS079 Begin
            //Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4 + ErrorDesc5+ErrorDesc6+ErrorDesc7+ErrorDesc8,2);
            Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4 + ErrorDesc5 + ErrorDesc6 + ErrorDesc7 + ErrorDesc8 + ErrorDesc9 + ErrorRcptNo + ErrorDuplCONo, 2);//BC Upgrade
                                                                                                                                                                                                        //CS079 End
            Staging.Status := Staging.Status::Error;
            Staging.MODIFY;
        END ELSE BEGIN
            Staging.GET(p_Staging."Batch No.", p_Staging."Entry No.");
            IF ItemNo <> '' THEN
                Staging."Item No." := ItemNo;
            Staging."Error Description" := '';
            Staging.Status := Staging.Status::OK;
            Staging.MODIFY;
        END;


    end;
}

