page 50076 "Purch. Rcpt. & Inv. Imp. Lines"
{
    //BC Upgrade create new.

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
                    Caption = 'Invoice Date';
                }
                field("Closed Date"; REC."Closed Date")
                {
                    ApplicationArea = all;
                }
                field("Imported Item No."; REC."Imported Item No.")
                {
                    ApplicationArea = all;
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
                    ApplicationArea = all;
                    Caption = 'Invoice No.';
                }
                field("Error Description"; REC."Error Description")
                {
                    ApplicationArea = all;
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
                        TransType: Option Receipt,Invoice,ReceiptInvoice;
                    begin
                        cduImporter.SetTransType(TransType::ReceiptInvoice);
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
                        Staging1: Record "PURCH. RECEIPT IMPORT STAGING";
                        PurchFound: Boolean;
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        Staging.SETCURRENTKEY("Batch No.");
                        Staging.SETFILTER(Staging.Status, '<>%1', Staging.Status::Processed);
                        Staging.SETRANGE(Staging."Batch No.", Rec."Batch No.");
                        IF Staging.FINDFIRST THEN
                            REPEAT
                                CheckError(Staging);
                            UNTIL Staging.NEXT = 0;

                        //BC upgrade N005 Begin
                        recApprSetup.Get();
                        if recApprSetup."Purchase Order" then begin
                            Staging.SETCURRENTKEY(Status, "Batch No.");
                            Staging.SETFILTER(Staging.Status, '=%1', Staging.Status::OK);
                            Staging.SETRANGE(Staging."Batch No.", Rec."Batch No.");
                            IF Staging.FINDFIRST THEN
                                REPEAT

                                    IF (Staging."PO No." = '') OR (Staging."Line No." = 0) THEN BEGIN
                                        PurchaseLine2.RESET;
                                        PurchaseLine2.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                        PurchaseLine2.SETRANGE(Type, PurchaseLine.Type::Item);
                                        PurchaseLine2.SETRANGE("CO No.", Staging."CO No.");
                                        IF PurchaseLine2.FINDFIRST THEN BEGIN
                                            PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, PurchaseLine2."Document No.");
                                        END;
                                    END ELSE BEGIN
                                        PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, Staging."PO No.");
                                    END;

                                    if not (PurchaseHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                                        Staging1.GET(Staging."Batch No.", Staging."Entry No.");
                                        Staging1."Error Description" := 'It''s not approved yet. ';
                                        Staging1.Status := Staging1.Status::Error;
                                        Staging1.MODIFY;
                                    end;

                                UNTIL Staging.NEXT = 0;
                        end;
                        //BC upgrade N005 End

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
                action("Post Receive & Invoice")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "Purch. Receipt Import Staging";
                        RptPostInvoice: Report "PO Post Receive & Invoice";
                    begin

                        // BC Upgrade
                        /*
                        IF DIALOG.CONFIRM('Are you sure you want to post the receive and invoice?', TRUE) THEN BEGIN
                            REPORT.RUNMODAL(Report::"PO Post Receive & Invoice");
                            MESSAGE('Posting Done.');
                        END;
                        */

                        Staging.SETFILTER(Staging.Status, '<>%1', Staging.Status::Processed);
                        Staging.SETRANGE(Staging."Batch No.", Rec."Batch No.");
                        if not Staging.IsEmpty() then
                            Error('The status of all records should be Processed.');

                        //BC Upgrade
                        IF not DIALOG.CONFIRM('Are you sure you want to post the receive and invoice?', TRUE) THEN
                            exit;

                        RptPostInvoice.Run();

                        PurchReceiptImportStaging.RESET;
                        PurchReceiptImportStaging.SETRANGE(Status, PurchReceiptImportStaging.Status::OK);
                        IF PurchReceiptImportStaging.FINDSET() THEN
                            PurchReceiptImportStaging.DELETEALL();

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

        //CS079 Add Begin
        IF (p_Staging."CO No." = '')
          AND ((p_Staging."PO No." = '') OR (p_Staging."Line No." = 0)) THEN
            ErrorDesc2 := ',CO No. or (PO No. and Line No.) Must Have Value.'
        ELSE BEGIN
            IF (p_Staging."PO No." <> '') AND (p_Staging."Line No." <> 0) THEN
                IF NOT PurchaseLine1.GET(PurchaseLine1."Document Type"::Order, p_Staging."PO No.", p_Staging."Line No.") THEN
                    ErrorDesc9 := ',Purchase Line Not Found.';

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
                IF p_Staging."Proforma Invoice" = '' THEN ErrorDesc6 := ',Performa Invoice No. Must Have Value.';
                if p_Staging."Receipt No." = '' then ErrorRcptNo := ',Receipt No. Must Have Value.';

                IF ItemNo <> '' THEN BEGIN
                    ErrorQty := TRUE;
                    IF PurchaseLine1.FINDSET THEN BEGIN
                        REPEAT
                            //BC Upgrade (check mandatory when has value)
                            if p_Staging."Imported Item No." <> '' then begin
                                IF PurchaseLine1."Customer Item No." <> p_Staging."Imported Item No." THEN
                                    ErrorDesc7 := ',Customer item is wrong.';
                            end;

                            if p_Staging.Description <> '' then begin
                                IF LowerCase(PurchaseLine1.Description) <> LowerCase(p_Staging.Description) THEN
                                    ErrorDesc8 := ',Description is wrong.';
                            end;

                            if p_Staging."Unit Cost" <> 0 then begin
                                IF PurchaseLine1."Direct Unit Cost" <> p_Staging."Unit Cost" THEN
                                    ErrorDesc8 := ',Unit cost is wrong.';
                            end;
                            //BC Upgrade

                            IF (PurchaseLine1."Outstanding Quantity" >= p_Staging."Received Qty.")
                                and ((PurchaseLine1."Quantity Received" + p_Staging."Received Qty." - PurchaseLine1."Quantity Invoiced") >= p_Staging."Qty. To Invoice") THEN
                                ErrorQty := FALSE;

                        UNTIL PurchaseLine1.NEXT = 0;
                        IF ErrorQty THEN
                            ErrorDesc4 := ',Received Qty. is more than PO Original Qty, or Invoiced  Qty. is more than Qty. Received.';
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
        OR (ErrorDesc6 <> '') OR (ErrorDesc7 <> '') OR (ErrorDesc8 <> '') OR (ErrorDesc9 <> '') OR (ErrorRcptNo <> '') THEN BEGIN
            //CS079 End
            Staging.GET(p_Staging."Batch No.", p_Staging."Entry No.");
            IF ItemNo <> '' THEN
                Staging."Item No." := ItemNo;
            //Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4,2);
            //CS079 Begin
            //Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4 + ErrorDesc5+ErrorDesc6+ErrorDesc7+ErrorDesc8,2);
            Staging."Error Description" := COPYSTR(ErrorDesc1 + ErrorDesc2 + ErrorDesc3 + ErrorDesc4 + ErrorDesc5 + ErrorDesc6 + ErrorDesc7 + ErrorDesc8 + ErrorDesc9 + ErrorRcptNo, 2);
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

