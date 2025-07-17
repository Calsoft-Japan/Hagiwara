report 50077 "Renesas PO Check List"
{
    // v20210226 Kenya - Operations for Vendor Managed Inventory (VMI) CS006
    // CS031 Kenya 2021/11/27 - Negative Qty by Update PO in Renesas PO Interface
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/Renesas PO Check List.rdlc';

    Caption = 'Renesas PO Check List';

    dataset
    {
        dataitem(DataItem4964; "Renesas PO Interface")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = "Document Date", "OEM No.", "Currency Code", "Vendor Customer Code", Quantity;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Renesas_PO_Interface__OEM_No__; "OEM No.")
            {
            }
            column(g_NoCustomer; g_NoCustomer)
            {
            }
            column(Renesas_PO_Interface__Document_Date_; "Document Date")
            {
            }
            column(Renesas_PO_Interface__Vendor_Customer_Code_; "Vendor Customer Code")
            {
            }
            column(Renesas_PO_Interface__Item_Description_; "Item Description")
            {
            }
            column(Renesas_PO_Interface__CO_No__; "CO No.")
            {
            }
            column(Renesas_PO_Interface__Demand_Date_; "Demand Date")
            {
            }
            column(Renesas_PO_Interface_Quantity; Quantity)
            {
                DecimalPlaces = 0 : 0;
            }
            column(Renesas_PO_Interface__Currency_Code_; "Currency Code")
            {
            }
            column(g_POQty; g_POQty)
            {
                DecimalPlaces = 0 : 0;
            }
            column(Renesas_PO_Interface_Price; Price)
            {
            }
            column(Renesas_PO_Interface_Amount; Amount)
            {
            }
            column(Renesas_PO_Interface_ProcFlag; ProcFlag)
            {
            }
            column(g_PONo; g_PONo)
            {
            }
            column(g_ItemNo; g_ItemNo)
            {
            }
            column(g_DupRec; g_DupRec)
            {
            }
            column(Renesas_PO_Interface__Entry_No__; "Entry No.")
            {
            }
            column(g_DupEntryNo; g_DupEntryNo)
            {
            }
            column(g_POLineNo; g_POLineNo)
            {
            }
            column(Renesas_PO_InterfaceCaption; Renesas_PO_InterfaceCaptionLbl)
            {
            }
            column(Page_Caption; Page_CaptionLbl)
            {
            }
            column(Renesas_PO_Interface__OEM_No__Caption; FIELDCAPTION("OEM No."))
            {
            }
            column(Doc_DateCaption; Doc_DateCaptionLbl)
            {
            }
            column(Renesas_PO_Interface__Vendor_Customer_Code_Caption; FIELDCAPTION("Vendor Customer Code"))
            {
            }
            column(Renesas_PO_Interface__Item_Description_Caption; FIELDCAPTION("Item Description"))
            {
            }
            column(Renesas_PO_Interface__CO_No__Caption; FIELDCAPTION("CO No."))
            {
            }
            column(Demand_ByCaption; Demand_ByCaptionLbl)
            {
            }
            column(Renesas_PO_Interface_QuantityCaption; FIELDCAPTION(Quantity))
            {
            }
            column(CURCaption; CURCaptionLbl)
            {
            }
            column(Supplier_PriceCaption; Supplier_PriceCaptionLbl)
            {
            }
            column(ProcessCaption; ProcessCaptionLbl)
            {
            }
            column(Org_PO_QtyCaption; Org_PO_QtyCaptionLbl)
            {
            }
            column(PO_No_Caption; PO_No_CaptionLbl)
            {
            }
            column(Renesas_PO_Interface_AmountCaption; FIELDCAPTION(Amount))
            {
            }
            column(Item_No_Caption; Item_No_CaptionLbl)
            {
            }
            column(DupliacateCaption; DupliacateCaptionLbl)
            {
            }
            column(Renesas_PO_Interface__Entry_No__Caption; FIELDCAPTION("Entry No."))
            {
            }
            column(P__EntryCaption; P__EntryCaptionLbl)
            {
            }
            column(PO_LineCaption; PO_LineCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                g_ItemNo := '    ';
                g_PONo := ' ';
                g_POQty := 0;
                g_Price := 0;
                g_PriceMark := '';
                g_DupRec := '     ';
                ind_Error := '0';
                g_DupEntryNo := 0;
                g_NoCustomer := ''; //v20210226

                //---------------------------------------------------------------//
                //                SEARCHING FOR RELEVANT ITEM NO.                //
                //---------------------------------------------------------------//
                rec_Item.SETCURRENTKEY(Description, "OEM No.", "Vendor No.");
                rec_Item.SETRANGE(rec_Item.Description, "Item Description");
                rec_Item.SETFILTER("Item Supplier Source", '=%1', rec_Item."Item Supplier Source"::Renesas);
                rec_Item.SETFILTER("OEM No.", '=%1', "OEM No.");
                rec_Item.SETFILTER(Description, '=%1', "Item Description");
                rec_Item.SETFILTER(Blocked, '=%1', FALSE);
                IF Quantity > 0 THEN BEGIN
                    IF rec_Item.FIND('-') THEN BEGIN
                        g_ItemNo := rec_Item."No.";
                    END ELSE BEGIN
                        g_ItemNo := '****';
                        g_CreErr := g_CreErr + 1;
                        ind_Error := '1';
                    END;
                END;

                //---------------------------------------------------------------//
                //       COMPARE SUPPLIER UNIT PRICE AND SETUP UNIT PRICE        //
                //---------------------------------------------------------------//
                //IF Quantity > 0 THEN BEGIN
                // rec_PurchasePrice.SETCURRENTKEY("Item No.",
                //   "Vendor No.","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity");
                //  rec_PurchasePrice.SETRANGE(rec_PurchasePrice."Vendor No.",'V00010');
                //  rec_PurchasePrice.SETRANGE(rec_PurchasePrice."Item No.",g_ItemNo);
                //  rec_PurchasePrice.SETFILTER(rec_PurchasePrice."Ending Date",'%1|>=%2',0D,"Document Date");
                //  rec_PurchasePrice.SETFILTER(rec_PurchasePrice."Starting Date",'>=%1',"Document Date");
                //  rec_PurchasePrice.SETFILTER(rec_PurchasePrice."Starting Date",'<=%1',"Document Date");
                //  rec_PurchasePrice.SETFILTER(rec_PurchasePrice."Currency Code",'=%1',"Currency Code");
                //  IF rec_PurchasePrice.FIND('-') THEN BEGIN
                //     IF Price <> rec_PurchasePrice."Direct Unit Cost" THEN BEGIN
                //        IF  rec_PurchasePrice."Minimum Quantity" > Quantity THEN BEGIN
                //        END ELSE BEGIN
                //            g_Price :=  rec_PurchasePrice."Direct Unit Cost";
                //            g_PriceMark := '*';
                //            ind_Error := '1';
                //            g_CreErr := g_CreErr + 1;
                //        END;
                //     END;
                //  END;
                //END;

                //v20210226 Start
                //---------------------------------------------------------------//
                //                SEARCHING FOR RELEVANT CUSTOMER                //
                //---------------------------------------------------------------//
                IF NOT rec_Customer.GET("OEM No.") THEN BEGIN
                    g_NoCustomer := '**';
                    g_CreErr := g_CreErr + 1;
                    ind_Error := '1';
                END;
                //v20210226 End

                //CS031 Start
                //---------------------------------------------------------------//
                //                SEARCHING FOR DUPLICATE CO NO.                 //
                //---------------------------------------------------------------//
                IF Quantity < 0 THEN BEGIN
                    g_DupCnt := 0;
                    rec_RenPOInt.RESET;
                    rec_RenPOInt.SETRANGE(rec_RenPOInt.ProcFlag, '0');
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."CO No.", '=%1', "CO No.");
                    IF rec_RenPOInt.FINDSET THEN BEGIN
                        REPEAT
                            g_POQty := g_POQty + rec_RenPOInt.Quantity;
                            g_DupCnt := g_DupCnt + 1;
                        UNTIL rec_RenPOInt.NEXT = 0;
                    END;

                    rec_PurchLine.RESET;
                    rec_PurchLine.SETRANGE(rec_PurchLine."CO No.", "CO No.");
                    rec_PurchLine.SETFILTER(rec_PurchLine."CO No.", '=%1', "CO No.");
                    IF rec_PurchLine.FINDSET THEN BEGIN
                        REPEAT
                            g_POQty := g_POQty + rec_PurchLine.Quantity;  //Existing PO
                        UNTIL rec_RenPOInt.NEXT = 0;
                    END;

                    IF g_POQty < 0 THEN BEGIN
                        g_DupRec := 'Error';
                        ind_Error := '1';
                        g_UpdErr := g_UpdErr + 1;
                    END
                    ELSE BEGIN
                        IF g_DupCnt > 1 THEN BEGIN
                            g_DupRec := 'Warning';
                            g_UpdWar := g_UpdWar + 1;
                        END;
                    END;
                END;
                //CS031 End

                //---------------------------------------------------------------//
                //  SEARCHING FOR DUPLICATE RECORD IN RENESAS PO INTERFACE TABLE //
                //---------------------------------------------------------------//
                IF Quantity > 0 THEN BEGIN
                    rec_RenPOInt.SETCURRENTKEY("Document Date", "OEM No.", "Currency Code", "Vendor Customer Code");
                    rec_RenPOInt.SETRANGE(rec_RenPOInt.ProcFlag, '1');
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Document Date", '=%1', "Document Date");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Demand Date", '=%1', "Demand Date");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."OEM No.", '=%1', "OEM No.");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Currency Code", '=%1', "Currency Code");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt.Quantity, '=%1', Quantity);
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Vendor Customer Code", '=%1', "Vendor Customer Code");
                    IF rec_RenPOInt.FIND('-') THEN BEGIN
                        IF rec_RenPOInt."Item Description" = "Item Description" THEN BEGIN
                            g_DupEntryNo := rec_RenPOInt."Entry No.";
                            g_DupRec := 'Error';
                            ind_Error := '1';
                            g_CreErr := g_CreErr + 1;
                        END;
                    END;
                END;

                //---------------------------------------------------------------//
                //  SEARCHING FOR DUPLICATE RECORD IN RENESAS PO INTERFACE TABLE //
                //---------------------------------------------------------------//
                IF Quantity < 0 THEN BEGIN
                    rec_RenPOInt.SETCURRENTKEY("Document Date", "OEM No.", "Currency Code", "Vendor Customer Code");
                    rec_RenPOInt.SETRANGE(rec_RenPOInt.ProcFlag, '1');
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Document Date", '=%1', "Document Date");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Demand Date", '=%1', "Demand Date");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."OEM No.", '=%1', "OEM No.");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Currency Code", '=%1', "Currency Code");
                    rec_RenPOInt.SETFILTER(rec_RenPOInt.Quantity, '=%1', Quantity);
                    rec_RenPOInt.SETFILTER(rec_RenPOInt."Vendor Customer Code", '=%1', "Vendor Customer Code");
                    IF rec_RenPOInt.FIND('-') THEN BEGIN
                        //    IF  rec_RenPOInt.Quantity = Quantity THEN BEGIN
                        g_DupEntryNo := rec_RenPOInt."Entry No.";
                        g_DupRec := 'Error';
                        ind_Error := '1';
                        g_UpdErr := g_UpdErr + 1;
                    END;
                    //END;
                END;

                //---------------------------------------------------------------//
                //     SEARCHING FOR DUPLICATE RECORD IN PURCHASE LINE TABLE     //
                //---------------------------------------------------------------//
                IF Quantity > 0 THEN BEGIN
                    rec_PurchLine.SETCURRENTKEY("CO No.");
                    rec_PurchLine.SETRANGE(rec_PurchLine."CO No.", "CO No.");
                    rec_PurchLine.SETFILTER(rec_PurchLine."CO No.", '=%1', "CO No.");
                    IF rec_PurchLine.FIND('-') THEN BEGIN
                        g_PONo := rec_PurchLine."Document No.";
                        g_POLineNo := rec_PurchLine."Line No.";
                        g_DupRec := 'ERROR';
                        ind_Error := '1';
                        g_CreErr := g_CreErr + 1;
                    END;
                END;

                //---------------------------------------------------------------//
                //     SEARCHING FOR DUPLICATE RECORD IN PURCHASE LINE TABLE     //
                //               WHEN DOCUMENT DATE IS THE SAME                  //
                //---------------------------------------------------------------//
                //IF Quantity < 0 THEN BEGIN
                //   rec_PurchLine.SETCURRENTKEY("CO No.");
                //   rec_PurchLine.SETRANGE(rec_PurchLine."CO No.","CO No.");
                //   rec_PurchLine.SETFILTER(rec_PurchLine."CO No.",'=%1',"CO No.");
                //   rec_PurchLine.SETFILTER(rec_PurchLine."Previous Document Date",'=%1',"Document Date");
                //   IF rec_PurchLine.FIND('-') THEN BEGIN
                ////    IF rec_PurchLine."Previous Document Date" = "Document Date" THEN BEGIN
                //         g_PONo := rec_PurchLine."Document No.";
                //         g_POLineNo := rec_PurchLine."Line No.";
                //         g_DupRec :='ERROR';
                //         ind_Error := '1';
                //         g_UpdErr := g_UpdErr + 1;
                //      END;
                //// END;
                //END;

                //---------------------------------------------------------------//
                //       SEARCHING FOR RELATED PURCHASE LINE USING CO NO.        //
                //---------------------------------------------------------------//
                g_POQty := 0;
                IF Quantity < 0 THEN BEGIN
                    rec_PurchLine.SETCURRENTKEY("CO No.");
                    rec_PurchLine.SETRANGE(rec_PurchLine."CO No.", "CO No.");
                    // rec_PurchLine.SETFILTER(rec_PurchLine."CO No.",'=%1',"CO No.");
                    IF rec_PurchLine.FIND('-') THEN BEGIN
                        g_PONo := rec_PurchLine."Document No.";
                        g_POLineNo := rec_PurchLine."Line No.";
                        g_POQty := rec_PurchLine.Quantity;
                        g_ItemNo := rec_PurchLine."No.";
                    END ELSE BEGIN
                        g_PONo := '***';
                        g_ItemNo := '****';
                        g_UpdErr := g_UpdErr + 1;
                        ind_Error := '1';
                    END;
                END;

                IF ind_Error = '0' THEN BEGIN
                    IF Quantity > 0 THEN BEGIN
                        g_CreRec := g_CreRec + 1;
                    END ELSE BEGIN
                        g_UpdRec := g_UpdRec + 1;
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("Vendor Customer Code");
                SETRANGE(ProcFlag, '0');
                //SETFILTER(Quantity,'>%1',0);
                IF NOT rec_RenPOInt.FIND('-') THEN BEGIN
                    MESSAGE('No Data to Process');
                    EXIT;
                END;
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
        g_CreRec := 0;
        g_UpdRec := 0;
        g_CreErr := 0;
        g_UpdErr := 0;
        g_UpdWar := 0;  //CS031

        rec_PurchPayableSetup.GET;
        IF ((rec_PurchPayableSetup."Create Renesas PO Status" = '2') OR
            (rec_PurchPayableSetup."Update Renesas PO Status" = '2'))
            THEN BEGIN
            IF CONFIRM(Text001, TRUE) THEN BEGIN
                ;
            END ELSE BEGIN
                ERROR(Text002);
                EXIT;
            END;
        END;

        IF ((rec_PurchPayableSetup."Create Renesas PO Status" = '3') AND
            (rec_PurchPayableSetup."Update Renesas PO Status" = '0'))
            THEN BEGIN
            ERROR(Text003);
            EXIT;
        END;

        IF ((rec_PurchPayableSetup."Create Renesas PO Status" = '0') AND
            (rec_PurchPayableSetup."Update Renesas PO Status" = '3'))
            THEN BEGIN
            ERROR(Text003);
            EXIT;
        END;

        IF ((rec_PurchPayableSetup."Create Renesas PO Status" = '3') AND
            (rec_PurchPayableSetup."Update Renesas PO Status" = '3'))
            THEN BEGIN
            ERROR(Text003);
            EXIT;
        END;
    end;

    trigger OnPostReport()
    begin
        rec_PurchPayableSetup.GET;

        IF g_CreErr = 0 THEN BEGIN
            IF g_CreRec > 0 THEN BEGIN
                rec_PurchPayableSetup."Create Renesas PO Status" := '2';
                rec_PurchPayableSetup."Create Renesas PO Error Code" := '0';
                rec_PurchPayableSetup.MODIFY;
            END ELSE BEGIN
            END;
        END;

        IF g_CreErr <> 0 THEN BEGIN
            rec_PurchPayableSetup."Create Renesas PO Error Code" := '1';
            rec_PurchPayableSetup.MODIFY;
        END ELSE BEGIN
            rec_PurchPayableSetup."Create Renesas PO Error Code" := '0';
            rec_PurchPayableSetup.MODIFY;
        END;

        IF g_UpdErr = 0 THEN BEGIN
            IF g_UpdRec > 0 THEN BEGIN
                rec_PurchPayableSetup."Update Renesas PO Status" := '2';
                rec_PurchPayableSetup."Update Renesas PO Error Code" := '0';
                rec_PurchPayableSetup.MODIFY;
            END ELSE BEGIN
            END;
        END;

        IF g_UpdErr <> 0 THEN BEGIN
            rec_PurchPayableSetup."Update Renesas PO Error Code" := '1';
            rec_PurchPayableSetup.MODIFY;
        END ELSE BEGIN
            rec_PurchPayableSetup."Update Renesas PO Error Code" := '0';
            rec_PurchPayableSetup.MODIFY;
        END;

        IF ((g_CreErr <> 0) OR
        // (g_UpdErr <> 0)) THEN  //CS031
           (g_UpdErr <> 0) OR (g_UpdWar <> 0)) THEN //CS031
            MESSAGE(Text004);
    end;

    var
        rec_PurchPayableSetup: Record "Purchases & Payables Setup";
        rec_RenPOInt: Record "Renesas PO Interface";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        g_ItemNo: Code[20];
        rec_Item: Record Item;
        rec_PurchLine: Record "Purchase Line";
        g_PONo: Code[20];
        g_POQty: Decimal;
        g_PriceMark: Text[1];
        rec_PurchasePrice: Record "Purchase Price";
        g_Price: Decimal;
        g_DupRec: Text[7];
        g_CreRec: Integer;
        g_UpdRec: Integer;
        g_CreErr: Integer;
        g_UpdErr: Integer;
        ind_Error: Code[1];
        Text001: Label 'Renesas PO Interface Input Check List was already printed, do you want to pirnt again?';
        Text002: Label 'The Job is aborted!';
        Text003: Label 'There is no fresh imported data to print!';
        Text004: Label 'Please check report for Error! ';
        g_DupEntryNo: Integer;
        g_POLineNo: Integer;
        Renesas_PO_InterfaceCaptionLbl: Label 'Renesas PO Interface';
        Page_CaptionLbl: Label 'Page:';
        Doc_DateCaptionLbl: Label 'Doc Date';
        Demand_ByCaptionLbl: Label 'Demand By';
        CURCaptionLbl: Label 'CUR';
        Supplier_PriceCaptionLbl: Label 'Supplier Price';
        ProcessCaptionLbl: Label 'Process';
        Org_PO_QtyCaptionLbl: Label 'Org PO Qty';
        PO_No_CaptionLbl: Label 'PO No.';
        Item_No_CaptionLbl: Label 'Item No.';
        DupliacateCaptionLbl: Label 'Dupliacate';
        P__EntryCaptionLbl: Label 'P. Entry';
        PO_LineCaptionLbl: Label 'PO Line';
        rec_Customer: Record Customer;
        g_NoCustomer: Text;
        g_UpdWar: Integer;
        g_DupCnt: Integer;
}

