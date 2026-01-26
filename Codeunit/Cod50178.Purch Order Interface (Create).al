codeunit 50178 "Purch Order Interface (Create)"
{

    // HG1.00 - Upgrade from Nav 3.60 to Nav Dynamics 5.00 (SG)
    // v20210226 Kenya - Operations for Vendor Managed Inventory (VMI) CS006


    trigger OnRun()
    begin
        rec_PurchPayableSetup.GET;
        IN_setup.GET;

        //MESSAGE(IN_setup."Supplier Item Source");

        /*
        IF  rec_PurchPayableSetup."Create Renesas PO Error Code" = '1' THEN
            BEGIN
               ERROR(Text002);
               EXIT;
            END;*/
        /*
    IF  rec_PurchPayableSetup."Create Renesas PO Status" <> '2' THEN
        BEGIN
            ERROR(Text001);
            EXIT;
        END;*/
        g_Error := 0;


        //MESSAGE('PO Data interface Start');
        rec_PurchSetup.GET;

        rec_POInt.RESET;
        rec_POInt.SETCURRENTKEY("Document Date", "OEM No.", "Currency Code", "Vendor Customer Code", "Entry No.");
        rec_POInt.SETRANGE(rec_POInt.ProcFlag, '0');
        rec_POInt.SETFILTER(rec_POInt.Quantity, '>%1', 0);

        IF NOT rec_POInt.FINDFIRST THEN BEGIN
            MESSAGE('No Record to Process');
            EXIT;
        END ELSE
            rec_TemBuff.DELETEALL;
        InsertIntoTemBuff;
        rec_TemBuff.RESET;
        IF rec_TemBuff.FINDFIRST THEN
            REPEAT
                rec_PurchHeader.INIT;
                rec_PurchHeader."Document Type" := rec_PurchHeader."Document Type"::Order;
                // Vendor Code is hardcoded to V00010
                //GlobalPONbr := vNoSeriesMgt.GetNextNo(rec_PurchSetup."Order Nos.", TODAY, TRUE); //BC Upgrade
                GlobalPONbr := NoSeries.GetNextNo(rec_PurchSetup."Order Nos.", Today);
                rec_PurchHeader."No." := GlobalPONbr;
                rec_PurchHeader.INSERT(TRUE);
                //rec_PurchHeader.VALIDATE("Buy-from Vendor No.", 'V00010');//sanjeev 10/14/2018

                rec_PurchHeader.VALIDATE("Buy-from Vendor No.", IN_setup."Supplier Item Source");

                rec_PurchHeader.VALIDATE("Customer No.", rec_TemBuff."OEM No.");
                rec_PurchHeader.VALIDATE("Sell-to Customer No.", rec_TemBuff."OEM No.");
                rec_PurchHeader.VALIDATE("Posting Date", rec_TemBuff."Document Date");
                rec_PurchHeader.VALIDATE("Document Date", rec_TemBuff."Document Date");
                rec_PurchHeader.VALIDATE("Order Date", rec_TemBuff."Document Date");
                rec_PurchHeader.VALIDATE("Currency Code", rec_TemBuff."Currency Code");
                rec_PurchHeader."Vendor Cust. Code" := rec_TemBuff."Vendor Customer Code";
                rec_Vendor.GET(rec_PurchHeader."Buy-from Vendor No.");
                IF rec_InvtSetup.GET THEN BEGIN
                    IF rec_InvtSetup."Supplier Item Source" = rec_PurchHeader."Buy-from Vendor No." THEN BEGIN
                        rec_PurchHeader."Item Supplier Source" := rec_PurchHeader."Item Supplier Source"::Renesas;
                    END ELSE BEGIN
                        rec_PurchHeader."Item Supplier Source" := rec_PurchHeader."Item Supplier Source"::" ";
                    END;
                END;
                //v20210226 Start
                rec_Customer.GET(rec_PurchHeader."Customer No.");
                IF rec_Customer."Receiving Location" <> '' THEN BEGIN
                    rec_PurchHeader.VALIDATE("Location Code", rec_Customer."Receiving Location");
                END;
                //v20210226 End

                //BC upgrade N005 Begin
                recApprSetup.Get();
                if recApprSetup."Purchase Order" then begin
                    rec_PurchHeader."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
                end;
                //BC upgrade N005 End

                rec_PurchHeader.MODIFY;

                iLine := 10000;
                rec_POInt1.RESET;
                rec_POInt1.SETRANGE(rec_POInt1.ProcFlag, '0');
                rec_POInt1.SETFILTER(rec_POInt1.Quantity, '>%1', 0);
                rec_POInt1.SETCURRENTKEY("Document Date", "OEM No.", "Currency Code", "Vendor Customer Code");
                rec_POInt1.SETRANGE("Document Date", rec_TemBuff."Document Date");
                rec_POInt1.SETFILTER("OEM No.", '=%1', rec_TemBuff."OEM No.");
                rec_POInt1.SETFILTER("Currency Code", '=%1', rec_TemBuff."Currency Code");
                rec_POInt1.SETFILTER("Vendor Customer Code", '=%1', rec_TemBuff."Vendor Customer Code");
                IF rec_POInt1.FINDFIRST THEN
                    REPEAT
                        //  MESSAGE('Record found in TemBuff');
                        rec_PurchLine.INIT;
                        rec_PurchLine."Document Type" := rec_PurchLine."Document Type"::Order;
                        rec_PurchLine."Document No." := GlobalPONbr;
                        rec_PurchLine."Line No." := iLine;
                        rec_PurchLine.VALIDATE(Type, rec_PurchLine.Type::Item);
                        iLine += 10000;
                        rec_PurchLine."Line Discount %" := 0;
                        rec_PurchLine.INSERT;
                        rec_PurchLine.VALIDATE("Buy-from Vendor No.", rec_PurchHeader."Buy-from Vendor No.");
                        rec_PurchLine.VALIDATE("Order Date", rec_PurchHeader."Order Date");
                        rec_PurchLine."CO No." := rec_POInt1."CO No.";
                        //  rec_PurchLine.Products := rec_POInt1.Product;
                        //-----------------------------------------------------
                        //Use OEM No. and Description to search for Item record
                        //-----------------------------------------------------
                        rec_Item.SETCURRENTKEY(Description, "OEM No.", "Vendor No.");
                        rec_Item.SETRANGE(Description, rec_POInt1."Item Description");
                        rec_Item.SETFILTER("Item Supplier Source", '=%1', rec_Item."Item Supplier Source"::Renesas);
                        rec_Item.SETFILTER("OEM No.", '=%1', rec_PurchHeader."Customer No.");
                        //rec_Item.SETFILTER("Vendor No.",'=%1','V00010');//sanjeev 10/14/2018

                        rec_Item.SETFILTER("Vendor No.", '=%1', IN_setup."Supplier Item Source");
                        //Siak .. 15/12/13
                        rec_Item.SETFILTER(Blocked, '=%1', FALSE);
                        //Siak .. 15/12/13 END
                        IF rec_Item.FIND('-') THEN BEGIN
                            rec_PurchLine.VALIDATE(Type, rec_PurchLine.Type::Item);
                            rec_PurchLine.VALIDATE("No.", rec_Item."No.");
                            rec_PurchLine.VALIDATE("Customer Item No.", rec_Item."Customer Item No.");
                            rec_PurchLine.VALIDATE(Quantity, rec_POInt1.Quantity);
                            rec_PurchLine.VALIDATE("Line Amount", rec_POInt1.Amount);
                            rec_PurchLine.VALIDATE("Outstanding Amount", rec_POInt1.Amount);
                            "OS Amount (LCY)" := rec_PurchLine."Unit Cost (LCY)" * rec_POInt1.Quantity;
                            rec_PurchLine.VALIDATE("Outstanding Amount (LCY)", "OS Amount (LCY)");
                            rec_PurchLine.VALIDATE("Qty. to Receive", 0);
                            rec_PurchLine.VALIDATE("Qty. to Invoice", 0);
                            rec_PurchLine.VALIDATE("Item Supplier Source", rec_Item."Item Supplier Source");
                            rec_PurchLine."Parts No." := rec_Item."Parts No.";
                            rec_PurchLine.VALIDATE("Expected Receipt Date", rec_POInt1."Demand Date");
                            //rec_PurchLine.VALIDATE("Requested Receipt Date", rec_POInt1."Demand Date");//sanjeev
                            rec_PurchLine.VALIDATE("Requested Receipt Date_1", rec_POInt1."Demand Date");
                            rec_PurchLine.VALIDATE("CO No.", rec_POInt1."CO No.");
                            rec_PurchLine."Line Discount Amount" := 0;
                            rec_PurchLine."Line Discount %" := 0;
                            //     rec_PurchLine.VALIDATE(Products, rec_POInt1.Product);
                        END ELSE BEGIN
                            rec_PurchLine.VALIDATE(Type, 0);
                            rec_PurchLine.Description := 'ERROR ITEM NOT FOUND IN MASTER';
                            ERROR(Text003, rec_POInt1."Item Description");
                            g_Error := 1;
                            //CurrReport.QUIT;
                        END;
                        //-----------------------------------------------------
                        IF rec_PurchLine.Type = rec_PurchLine.Type::Item THEN BEGIN
                            rec_PurchLine."Update Date" := TODAY;
                            rec_PurchLine."Update Time" := TIME;
                            rec_PurchLine."Update By" := USERID;
                            rec_PurchLine.VALIDATE("Receipt Seq. No.", 1);
                            rec_PurchLine.VALIDATE("Next Receipt Seq. No.", 1);
                            rec_PurchLine.MODIFY;
                        END;

                        IF rec_PurchLine."Line Amount" = 0 THEN BEGIN
                            rec_PurchLine."Line Amount" := ROUND(rec_PurchLine.Quantity * rec_PurchLine."Direct Unit Cost");
                            rec_PurchLine.MODIFY;
                            IF rec_PurchHeader."Currency Code" = '' THEN BEGIN
                                rec_PurchLine."Outstanding Amount" := ROUND(rec_PurchLine."Outstanding Quantity" * rec_PurchLine."Direct Unit Cost");
                                rec_PurchLine."Outstanding Amount (LCY)" := ROUND(rec_PurchLine."Outstanding Quantity" * rec_PurchLine."Direct Unit Cost");
                                rec_PurchLine.MODIFY;
                            END ELSE BEGIN
                                rec_PurchLine."Outstanding Amount" := ROUND(rec_PurchLine."Outstanding Quantity" * rec_PurchLine."Direct Unit Cost");
                                rec_PurchLine."Outstanding Amount (LCY)" := ROUND(rec_PurchLine."Outstanding Amount" / rec_PurchHeader."Currency Factor");
                                rec_PurchLine.MODIFY;
                            END;
                        END;

                        IF rec_PurchLine."VAT Prod. Posting Group" = 'GST7' THEN BEGIN
                            rec_PurchLine."Outstanding Amount" := ROUND(rec_PurchLine."Outstanding Amount" * 1.07);
                            rec_PurchLine."Outstanding Amount (LCY)" := ROUND(rec_PurchLine."Outstanding Amount (LCY)" * 1.07);
                            rec_PurchLine.MODIFY;
                        END;

                        //BC upgrade N005 Begin
                        recApprSetup.Get();
                        if recApprSetup."Purchase Order" then begin
                            rec_PurchLine."Approved Quantity" := rec_PurchLine.Quantity;
                            rec_PurchLine."Approved Unit Cost" := rec_PurchLine."Direct Unit Cost";
                            rec_PurchLine.Modify();
                        end;
                        //BC upgrade N005 End

                        //To  insert Standard Text on Purch. Line Type = ' '
                        rec_PurchLine.INIT;
                        rec_PurchLine."Document Type" := rec_PurchLine."Document Type"::Order;
                        rec_PurchLine."Document No." := GlobalPONbr;
                        rec_PurchLine."Line No." := iLine;
                        rec_PurchLine.VALIDATE(Type, rec_PurchLine.Type::" ");
                        iLine += 10000;
                        rec_PurchLine.INSERT;
                        rec_ExtText.SETRANGE(rec_ExtText."Table Name", rec_ExtText."Table Name"::Item);
                        rec_ExtText.SETFILTER(rec_ExtText."No.", '=%1', rec_Item."No.");
                        IF rec_ExtText.FIND('-') THEN BEGIN
                            rec_PurchLine."Buy-from Vendor No." := ' ';
                            rec_PurchLine.Description := rec_ExtText.Text;
                            rec_PurchLine.MODIFY;
                        END;
                        // Update Process Flag
                        rec_POInt1.ProcFlag := '1';
                        rec_POInt1.MODIFY;
                    UNTIL rec_POInt1.NEXT = 0;

            UNTIL rec_TemBuff.NEXT = 0;

        MESSAGE('Renesas PO Data interface Completed!');

        rec_PurchPayableSetup.GET;
        rec_PurchPayableSetup."Create Renesas PO Status" := '3';
        rec_PurchPayableSetup.MODIFY;

    end;


    procedure DeleteForecast()
    begin
        rec_PurchHeader.RESET;
        rec_PurchLine.RESET;
    end;

    procedure InsertIntoTemBuff()
    begin
        rec_TemBuff.DELETEALL;
        rec_POInt.SETFILTER(rec_POInt.Quantity, '>%1', 0);
        rec_POInt.FINDFIRST;
        REPEAT
            rec_TemBuff.RESET;
            rec_TemBuff.SETCURRENTKEY("Document Date", "OEM No.", "Currency Code", "Vendor Customer Code");
            rec_TemBuff.SETRANGE("Document Date", rec_POInt."Document Date");
            rec_TemBuff.SETFILTER("OEM No.", '=%1', rec_POInt."OEM No.");
            rec_TemBuff.SETFILTER("Currency Code", '=%1', rec_POInt."Currency Code");
            rec_TemBuff.SETFILTER("Vendor Customer Code", '=%1', rec_POInt."Vendor Customer Code");
            IF NOT rec_TemBuff.FINDFIRST THEN BEGIN
                rec_TemBuff.INIT;
                IF rec_temp1.FIND('+') THEN
                    rec_TemBuff."Entry No." := rec_temp1."Entry No." + 1
                ELSE
                    rec_TemBuff."Entry No." := 1;
                rec_TemBuff."Document Date" := rec_POInt."Document Date";
                rec_TemBuff."OEM No." := rec_POInt."OEM No.";
                rec_TemBuff."Currency Code" := rec_POInt."Currency Code";
                rec_TemBuff."Vendor Customer Code" := rec_POInt."Vendor Customer Code";
                rec_TemBuff.INSERT;
                //MESSAGE('Record in TemBuff Inserted');
            END;
        UNTIL rec_POInt.NEXT = 0;
    end;

    var
        rec_PurchPayableSetup: Record "Purchases & Payables Setup";
        rec_PurchHeader: Record "Purchase Header";
        rec_PurchLine: Record "Purchase Line";
        rec_POInt: Record "Renesas PO Interface";
        rec_Item: Record Item;
        ExtDocNo: Text[30];
        iYYYY: Integer;
        iMM: Integer;
        iDD: Integer;
        iLine: Integer;
        pType: Integer;
        rec_Customer: Record Customer;
        //vNoSeriesMgt: Codeunit NoSeriesManagement; //BC Upgrade
        NoSeries: Codeunit "No. Series";
        rec_PurchSetup: Record "Purchases & Payables Setup";
        GlobalPONbr: Code[20];
        rec_POInt1: Record "Renesas PO Interface";
        rec_TemBuff: Record "Tembuff";
        rec_temp1: Record "Tembuff";
        rec_Vendor: Record Vendor;
        rec_InvtSetup: Record "Inventory Setup";
        rec_ExtText: Record "Extended Text Line";
        "OS Amount (LCY)": Decimal;
        Text001: Label 'New Renesas PO Interface data must be printed first and must not have any error! ';
        Text002: Label 'Renesas PO Interface data error detected, no creation of Renesas Purchase Order is allowed!   ';
        Text003: Label 'Record Not Found, Item Description = ''%1''';
        g_Error: Integer;
        IN_setup: Record "Inventory Setup";
        IN_setup_vendor_No: Code[20];

        recApprSetup: Record "Hagiwara Approval Setup";

}