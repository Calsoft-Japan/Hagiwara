codeunit 50179 "Renesas PO Interface (Update)"
{

    //CS062 Shawn 2023/09/22 - Change QTY without reopen PO manually.


    trigger OnRun()
    begin
        rec_PurchPayableSetup.GET;
        g_Qty := 0;//sanjeev20.05.2020 from DE
        IF rec_PurchPayableSetup."Update Renesas PO Error Code" = '1' THEN BEGIN
            ERROR(Text002);
            EXIT;
        END;

        IF rec_PurchPayableSetup."Update Renesas PO Status" <> '2' THEN BEGIN
            ERROR(Text001);
            EXIT;
        END;


        LastFieldNo := rec_POInt.FIELDNO("Vendor Customer Code");

        rec_POInt.RESET;
        rec_POInt.SETRANGE(ProcFlag, '0');
        rec_POInt.SETFILTER(Quantity, '<%1', 0);
        if rec_POInt.FindSet() then
            repeat

                rec_PurchLine.SETCURRENTKEY("CO No.");
                rec_PurchLine.SETRANGE(rec_PurchLine."CO No.", rec_POInt."CO No.");
                rec_PurchLine.SETFILTER(rec_PurchLine."CO No.", '=%1', rec_POInt."CO No.");
                IF rec_PurchLine.FIND('-') THEN BEGIN
                    g_PONo := rec_PurchLine."Document No.";
                    g_LineNo := rec_PurchLine."Line No.";
                    g_ItemNo := rec_PurchLine."No.";
                    g_Qty := rec_PurchLine.Quantity + rec_POInt.Quantity;
                    //CS062 Begin
                    rec_PurchHeader.GET(rec_PurchLine."Document Type", rec_PurchLine."Document No.");
                    g_POStatus_Org := rec_PurchHeader.Status;
                    rec_PurchHeader.Status := rec_PurchHeader.Status::Open;
                    rec_PurchHeader.MODIFY;
                    //CS062 End
                    rec_PurchLine.VALIDATE(Quantity, g_Qty);
                    rec_PurchLine."Previous Document Date" := rec_POInt."Document Date";
                    rec_PurchLine.MODIFY;

                    //CS062 Begin
                    rec_PurchHeader.Status := g_POStatus_Org;
                    rec_PurchHeader.MODIFY;
                    //CS062 End
                END ELSE BEGIN
                    g_ItemNo := '***';
                    g_PONo := '***';
                END;
                rec_POInt.ProcFlag := '1';
                rec_POInt.MODIFY;

            until rec_POInt.Next() = 0;



        rec_PurchPayableSetup.GET;
        rec_PurchPayableSetup."Update Renesas PO Status" := '3';
        rec_PurchPayableSetup.MODIFY;


    end;


    var
        rec_PurchPayableSetup: Record "Purchases & Payables Setup";
        rec_POInt: Record "Renesas PO Interface";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Text001: Label 'Correction Renesas PO Interface data must be printed first and must not have any error! ';
        g_ItemNo: Code[20];
        rec_PurchLine: Record "Purchase Line";
        g_COError: Text[2];
        g_PONo: Code[20];
        g_Qty: Decimal;
        Text002: Label 'Renesas PO Interface data error detected, no updating of Renesas Purchase Order Quantity is allowed!   ';
        g_LineNo: Integer;
        Renesas_PO_Interface__Update_CaptionLbl: Label 'Renesas PO Interface (Update)';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        CO_No_CaptionLbl: Label 'CO No.';
        Cur_CodeCaptionLbl: Label 'Cur Code';
        Item_No_CaptionLbl: Label 'Item No.';
        Line_No_CaptionLbl: Label 'Line No.';
        PO_No_CaptionLbl: Label 'PO No.';
        rec_PurchHeader: Record "Purchase Header";
        g_POStatus_Org: Enum "Purchase Document Status";

}