codeunit 50176 "Delete Renesas PO Int (PF=0)"
{

    trigger OnRun()
    begin
        rec_PurchPayableSetup.GET;
        IF ((rec_PurchPayableSetup."Create Renesas PO Status" = '3') AND
            (rec_PurchPayableSetup."Update Renesas PO Status" = '3'))
            THEN BEGIN
            ERROR(Text006);
            EXIT;
        END;

        //IF  ((rec_PurchPayableSetup."Create Renesas PO Status" = '') AND
        //    (rec_PurchPayableSetup."Update Renesas PO Status" = ''))
        //    THEN BEGIN
        //    ERROR(Text006);
        //    EXIT;
        //END;

        //IF  ((rec_PurchPayableSetup."Create Renesas PO Status" = '0') AND
        //    (rec_PurchPayableSetup."Update Renesas PO Status" = '0'))
        //    THEN BEGIN
        //    ERROR(Text006);
        //    EXIT;
        //END;

        //IF  ((rec_PurchPayableSetup."Create Renesas PO Status" = '1') AND
        //    (rec_PurchPayableSetup."Update Renesas PO Status" = '1'))
        //    THEN BEGIN
        IF CONFIRM(Text002, TRUE) THEN BEGIN
        END ELSE BEGIN
            ERROR('The Job is aborted!');
            EXIT;
        END;
        //END;


        g_NoOfRec := 0;
        IF NOT CONFIRM(Text001, FALSE) THEN
            ERROR(Text003);



        g_NoOfRec := 0;
        rec_POInt.RESET;
        rec_POInt.SETRANGE(ProcFlag, '0');
        if rec_POInt.FindSet() then
            repeat
                rec_POInt.DELETE;
                g_NoOfRec := g_NoOfRec + 1;
            until rec_POInt.Next() = 0;



        IF g_NoOfRec > 0 THEN BEGIN
            MESSAGE(Text005, g_NoOfRec);
        END ELSE BEGIN
            MESSAGE(Text006);
        END;

        IF g_NoOfRec > 0 THEN BEGIN
            rec_PurchPayableSetup.GET;
            rec_PurchPayableSetup."Create Renesas PO Status" := '0';
            rec_PurchPayableSetup."Update Renesas PO Status" := '0';
            rec_PurchPayableSetup."Create Renesas PO Error Code" := '0';
            rec_PurchPayableSetup."Update Renesas PO Error Code" := '0';
            rec_PurchPayableSetup.MODIFY;
        END;


    end;


    var
        rec_PurchPayableSetup: Record "Purchases & Payables Setup";
        rec_POInt: Record "Renesas PO Interface";
        Text001: Label 'Do you really want to delete not processed Renesas PO Interface record?';
        Text002: Label 'Please confirm if you realy want to delete all not processed Renesas PO Interface data?';
        Text003: Label 'Renesas PO Interface data Deletion job is aborted!';
        Text004: Label 'Do you want to print the Check List again?';
        g_NoOfRec: Integer;
        Text005: Label 'Renesas PO Interface Record had been deleted: %1 records.';
        Text006: Label 'There is no record to delete.';

}