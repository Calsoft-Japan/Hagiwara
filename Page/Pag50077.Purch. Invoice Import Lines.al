page 50077 "Purch. Invoice Import Lines"
{
    // HG10.00.12 NJ 02/05/2018 - New Page Created
    // CS023 Kenya 2021/07/28 - Roll-out Renesas Receipt/Invoice Upload
    // CS079 Shawn 2024/06/01 - Check and Logic Change. (CO No. => PO No.+Line No. as well)

    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    SourceTable = "Purch. Receipt Import Staging";
    SourceTableView = WHERE(Received = FILTER(true));

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
                    Caption = 'Invoice Date';
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
                    Caption = 'Invoice No.';
                }
                field("Error Description"; REC."Error Description")
                {
                    ApplicationArea = all;
                }
                field("Item No."; REC."Item No.")
                {
                    Caption = 'NAV Item No.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; REC."Unit Cost")
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
                    begin
                        cduImporter.SetInvoice(true);
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
                        Staging: Record "PURCH. RECEIPT IMPORT STAGING";
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
                                    //CS079 Begin
                                    /*
                                    IF PurchaseLine2.FINDFIRST THEN PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,PurchaseLine2."Document No.");
                                    Staging."PO No." := PurchaseLine2."Document No.";
                                    Staging.MODIFY;
                                    */
                                    IF PurchaseLine2.FINDFIRST THEN BEGIN
                                        PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchaseLine2."Document No.");
                                        Staging."PO No." := PurchaseLine2."Document No.";
                                        Staging.MODIFY;
                                    END;
                                    //CS079 End
                                    //CS023 End
                                    //CS079 Begin
                                END ELSE BEGIN
                                    PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, Staging."PO No.");
                                END;
                                //CS079 End
                                //PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,Staging."PO No."); //CS023
                                PurchaseHeader.VALIDATE("Posting Date", Staging."Closed Date");
                                //PurchaseHeader.VALIDATE("Goods Arrival Date",Staging."Arrival Date");
                                //PurchaseHeader.VALIDATE("Vendor Order No.",Staging."Proforma Invoice");//contact@splendidinfotech.com
                                //PurchaseHeader.VALIDATE("Vendor Shipment No.",Staging."Proforma Invoice");//contact@splendidinfotech.com
                                PurchaseHeader.VALIDATE("Vendor Invoice No.", Staging."Proforma Invoice");//contact@splendidinfotech.com
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

                                        PurchaseLine2.VALIDATE("Qty. to Invoice", 0);

                                        PurchaseLine2.MODIFY;

                                    UNTIL PurchaseLine2.NEXT = 0;
                                END;

                                PurchaseLine.RESET;
                                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                PurchaseLine.SETRANGE("Document No.", Staging."PO No.");
                                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                                //PurchaseLine.SETRANGE("No.",Staging."Item No.");
                                //PurchaseLine.SETRANGE("CO No.",Staging."CO No.");//CS079
                                //CS079 Begin
                                IF (Staging."PO No." <> '') AND (Staging."Line No." <> 0) THEN BEGIN
                                    PurchaseLine.SETRANGE("Line No.", Staging."Line No.");
                                END ELSE BEGIN
                                    PurchaseLine.SETRANGE("CO No.", Staging."CO No.");
                                END;
                                //CS079 End
                                IF PurchaseLine.FINDSET THEN BEGIN
                                    REPEAT
                                        PurchaseLine."Goods Arrival Date" := Staging."Arrival Date";
                                        //PurchaseLine."Qty. to Receive" := Staging."Received Qty.";
                                        // PurchaseLine.VALIDATE("Qty. to Receive",Staging."Received Qty.");
                                        //PurchaseLine.VALIDATE("Qty. to Invoice",Staging."Qty. To Invoice");//contact@splendidinfotech.com
                                        // PurchaseLine.VALIDATE("Qty. to Invoice",Staging."Qty. To Invoice");//contact@splendidinfotech.com//
                                        PurchaseLine.MODIFY;
                                    UNTIL PurchaseLine.NEXT = 0;
                                END;
                                /* ELSE BEGIN
                                 PurchaseLine.VALIDATE("Qty. to Invoice",0);//contact@splendidinfotech.com
                                 PurchaseLine.MODIFY;*/
                                //END;

                                Staging1.GET(Staging."Batch No.", Staging."Entry No.");
                                Staging1.Status := Staging1.Status::Processed;
                                Staging1.MODIFY;

                            UNTIL Staging.NEXT = 0;

                        MESSAGE('Validation & Process Completed.');

                        //process ends here

                    end;
                }

                action("Post Invoice")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Purchheader7: Record "PURCHASE HEADER";
                    begin
                        // added to clear posting no 12.07.20

                        Purchheader7.RESET;
                        Purchheader7.SETFILTER("Posting No.", '<>%1', '');
                        IF Purchheader7.FINDSET THEN BEGIN
                            REPEAT
                                Purchheader7."Posting No." := '';
                                Purchheader7.MODIFY;

                            UNTIL Purchheader7.NEXT = 0;
                        END;


                        // end 12.07.20



                        IF DIALOG.CONFIRM('Do You Want To Invoice?', TRUE) THEN BEGIN
                            PurchReceiptImportStaging.RESET;
                            PurchReceiptImportStaging.SETRANGE("Batch No.", Rec."Batch No.");
                            PurchReceiptImportStaging.SETRANGE(Status, PurchReceiptImportStaging.Status::Processed);

                            IF PurchReceiptImportStaging.FINDSET THEN BEGIN
                                //IF ("Batch No." <> 0) AND (Status = Status::Processed) THEN BEGIN

                                IF (PurchReceiptImportStaging."Batch No." <> 0) THEN BEGIN
                                    REPORT.RUNMODAL(Report::"PO Post Invoice", FALSE);
                                    MESSAGE('Invoiced Sucessfully.');
                                END ELSE
                                    MESSAGE('Nothing to post.');
                            END ELSE
                                MESSAGE('Nothing to post.');

                        END;
                    end;
                }
                action("Delete Complete Batch")
                {
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "PURCH. RECEIPT IMPORT STAGING";
                    begin
                        IF CONFIRM('Do you want to delete batches?', TRUE) THEN BEGIN
                            Staging.SETCURRENTKEY(Status, "Batch No.");
                            //Staging.SETFILTER(Status,'<>%1',Status::Processed);
                            Staging.SETRANGE("Batch No.", Rec."Batch No.");
                            IF Staging.FINDFIRST THEN
                                Staging.DELETEALL;
                        END
                    end;
                }
                action("Delete Only Error Lines")
                {
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "PURCH. RECEIPT IMPORT STAGING";
                    begin
                        Staging.SETCURRENTKEY(Status, "Batch No.");
                        Staging.SETFILTER(Status, '=%1', Staging.Status::Error);
                        Staging.SETRANGE("Batch No.", Rec."Batch No.");
                        IF Staging.FINDFIRST THEN
                            Staging.DELETEALL;
                    end;
                }
            }
        }
    }

    var
        PurchReceiptImportStaging: Record "PURCH. RECEIPT IMPORT STAGING";
        PurchaseLine: Record "PURCHASE LINE";
        Staging: Record "PURCH. RECEIPT IMPORT STAGING";
        Staging1: Record "PURCH. RECEIPT IMPORT STAGING";
        PurchaseHeader: Record "PURCHASE HEADER";
        PurchaseLine2: Record "PURCHASE LINE";

    procedure CheckError(p_Staging: Record "PURCH. RECEIPT IMPORT STAGING")
    var
        Item: Record "Item";
        ItemNo: Code[20];
        PurchaseHeader: Record "PURCHASE HEADER";
        PurchaseLine: Record "PURCHASE LINE";
        ErrorDesc1: Text;
        ErrorDesc2: Text;
        ErrorDesc3: Text;
        ErrorDesc4: Text;
        ErrorDesc5: Text;
        Staging: Record "PURCH. RECEIPT IMPORT STAGING";
        Text001: Label 'Entry No. %1 contains contradictory data. Do you want to proceed.';
        ErrorDesc6: Text;
        ErrorDesc7: Text;
        ErrorDesc8: Text;
        ErrorDesc9: Text;
        ErrorQty: Boolean;
        ErrorDesc10: Text;
    begin
        Item.RESET;
        //Item.SETRANGE(Description,p_Staging."Imported Item No.");
        Item.SETRANGE(Description, p_Staging.Description);
        IF Item.FINDFIRST THEN
            ItemNo := Item."No."
        ELSE BEGIN
            Item.RESET;
            Item.SETRANGE("Customer Item No.", p_Staging."Imported Item No.");
            IF Item.FINDFIRST THEN
                ItemNo := Item."No."
            ELSE BEGIN
                //Arpit-22-May-Start
                Item.RESET;
                Item.SETRANGE("Vendor Item No.", p_Staging."Imported Item No.");
                IF Item.FINDFIRST THEN
                    ItemNo := Item."No.";
                //ELSE
                //Arpit-22-May-Stop
                //  ErrorDesc1 := ',Item Not Found';
            END
        END;

        //Arpit-28.06.2018-START
        IF ItemNo = '' THEN BEGIN
            Item.RESET;
            Item.SETRANGE(Description, p_Staging.LPN);
            IF Item.FINDFIRST THEN
                ItemNo := Item."No."
            ELSE BEGIN
                Item.RESET;
                Item.SETRANGE("Customer Item No.", p_Staging.LPN);
                IF Item.FINDFIRST THEN
                    ItemNo := Item."No."
                ELSE BEGIN
                    //Arpit-22-May-Start
                    Item.RESET;
                    Item.SETRANGE("Vendor Item No.", p_Staging.LPN);
                    IF Item.FINDFIRST THEN
                        ItemNo := Item."No."
                    ELSE
                        //Arpit-22-May-Stop
                        ErrorDesc1 := ',Item Not Found.';
                END;
            END;
        END;
        //Arpit-28.06.2018-STOP

        //CS079 Del Begin
        /*
        //CS023 Begin
        IF p_Staging."CO No." = '' THEN
          ErrorDesc2 := ',CO No. Must Have Value'
        ELSE BEGIN
          PurchaseLine.RESET;
          PurchaseLine.SETRANGE("Document Type",PurchaseLine."Document Type"::Order);
          PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
          PurchaseLine.SETRANGE("CO No.",p_Staging."CO No.");
          IF (NOT PurchaseLine.FINDFIRST) THEN
            ErrorDesc3 := ',Purchase Order Not Found'
          //CS023 End
          ELSE BEGIN
            //IF p_Staging."Arrival Date" = 0D THEN ErrorDesc5 := ',Arrival Date Must Have Value';//12.01.20
            //IF p_Staging."Arrival Date" = 0D THEN ErrorDesc5 := ',';  //CS023
            IF p_Staging."Arrival Date" = 0D THEN ErrorDesc5 := ',Invoice Date Must Have Value';  //CS023
            IF p_Staging."Proforma Invoice" = '' THEN ErrorDesc6 := ',Invoice No. Must Have Value';  //CS023
            IF p_Staging."Closed Date" = 0D THEN ErrorDesc9 := ',Posting Date Must Have Value';  //CS023
        
            IF ItemNo <> '' THEN BEGIN
              //PurchaseLine.SETRANGE("Document No.",p_Staging."PO No."); //CS023
              PurchaseLine.SETFILTER(Type,'%1',2);
             // PurchaseLine.SETRANGE("No.",Item."No.");
              PurchaseLine.SETRANGE("CO No.",p_Staging."CO No.");
        
              //IF NOT PurchaseLine.FINDFIRST THEN
              ErrorQty := TRUE;
              IF PurchaseLine.FINDSET THEN BEGIN //CS023
              //IF NOT PurchaseLine.GET(PurchaseHeader."Document Type"::Order,p_Staging."PO No.",Item."No.") THEN
              //  ErrorDesc3 := ',Purchase Order Line Not Found'
              //ELSE BEGIN
                REPEAT  //CS023
               // MESSAGE(FORMAT(p_Staging."Received Qty."));
                  IF PurchaseLine."Customer Item No." <> p_Staging."Imported Item No." THEN
                  ErrorDesc7 := ',Customer item is wrong.';
        
                  IF PurchaseLine.Description <> p_Staging.Description THEN
                  ErrorDesc8 := ',Description is wrong.';
        
                  IF PurchaseLine."Direct Unit Cost" <> p_Staging."Unit Cost" THEN
                  ErrorDesc8 := ',Unit cost is wrong.';
        
                //CS023 Begin
                  //IF PurchaseLine."Quantity Received" >= p_Staging."Qty. To Invoice" THEN
                  IF (PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced") >= p_Staging."Qty. To Invoice" THEN
                    ErrorQty := FALSE;
                UNTIL PurchaseLine.NEXT = 0;
                IF ErrorQty THEN
                  ErrorDesc4 := ',Invoiced  Qty. is more than Qty. Received';
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
                IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order, p_Staging."PO No.", p_Staging."Line No.") THEN
                    ErrorDesc10 := ',Purchase Line Not Found.';

            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
            IF (p_Staging."PO No." <> '') AND (p_Staging."Line No." <> 0) THEN BEGIN
                PurchaseLine.SETRANGE("Document No.", p_Staging."PO No.");
                PurchaseLine.SETRANGE("Line No.", p_Staging."Line No.");
            END ELSE BEGIN
                PurchaseLine.SETRANGE("CO No.", p_Staging."CO No.");
            END;
            IF (PurchaseLine.ISEMPTY) THEN BEGIN
                IF ErrorDesc10 = '' THEN
                    ErrorDesc3 := ',Purchase Order Not Found.'
            END ELSE BEGIN
                IF p_Staging."Arrival Date" = 0D THEN ErrorDesc5 := ',Invoice Date Must Have Value.';
                IF p_Staging."Proforma Invoice" = '' THEN ErrorDesc6 := ',Invoice No. Must Have Value.';
                IF p_Staging."Closed Date" = 0D THEN ErrorDesc9 := ',Posting Date Must Have Value.';

                IF ItemNo <> '' THEN BEGIN
                    ErrorQty := TRUE;
                    IF PurchaseLine.FINDSET THEN BEGIN
                        REPEAT
                            IF PurchaseLine."Customer Item No." <> p_Staging."Imported Item No." THEN
                                ErrorDesc7 := ',Customer item is wrong.';

                            IF LowerCase(PurchaseLine.Description) <> LowerCase(p_Staging.Description) THEN
                                ErrorDesc8 := ',Description is wrong.';

                            IF PurchaseLine."Direct Unit Cost" <> p_Staging."Unit Cost" THEN
                                ErrorDesc8 := ',Unit cost is wrong.';

                            IF (PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced") >= p_Staging."Qty. To Invoice" THEN
                                ErrorQty := FALSE;
                        UNTIL PurchaseLine.NEXT = 0;
                        IF ErrorQty THEN
                            ErrorDesc4 := ',Invoiced  Qty. is more than Qty. Received.';
                    END;
                END;
            END;
        END;
        //CS079 Add End

        Staging.GET(p_Staging."Batch No.", p_Staging."Entry No.");
        IF ItemNo <> '' THEN BEGIN
            Staging."Item No." := ItemNo;
        END;

        //CS079 Begin
        //IF (ErrorDesc1 <> '') OR (ErrorDesc2 <> '') OR (ErrorDesc3 <> '') OR (ErrorDesc4 <> '') OR (ErrorDesc5 <> '') OR (ErrorDesc6 <>'') OR (ErrorDesc7 <>'') OR (ErrorDesc8 <>'') OR (ErrorDesc9 <>'')THEN BEGIN
        IF (ErrorDesc1 <> '') OR (ErrorDesc2 <> '') OR (ErrorDesc3 <> '') OR (ErrorDesc4 <> '') OR (ErrorDesc5 <> '') OR (ErrorDesc6 <> '') OR (ErrorDesc7 <> '') OR (ErrorDesc8 <> '') OR (ErrorDesc9 <> '') OR (ErrorDesc10 <> '') THEN BEGIN
            //CS079 End
            Staging.GET(p_Staging."Batch No.", p_Staging."Entry No.");
            IF ItemNo <> '' THEN
                Staging."Item No." := ItemNo;
            //CS079 Begin
            //Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4 + ErrorDesc5+ErrorDesc6+ErrorDesc7+ErrorDesc8+ErrorDesc9,2);
            Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4 + ErrorDesc5 + ErrorDesc6 + ErrorDesc7 + ErrorDesc8 + ErrorDesc9 + ErrorDesc10, 2);
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

