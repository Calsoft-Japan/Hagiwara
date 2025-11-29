codeunit 50186 "Clear Renesas PO Interface Rec"
{

    trigger OnRun()
    begin

        IF CONFIRM(Text001, TRUE) THEN BEGIN
            rec_RenesasPOInterface.DELETEALL;
            rec_RenesasPOInterface.RESET;

            rec_PurchPayableSetup.GET;
            rec_PurchPayableSetup."Create Renesas PO Status" := '0';
            rec_PurchPayableSetup."Update Renesas PO Status" := '0';
            rec_PurchPayableSetup."Create Renesas PO Error Code" := '0';
            rec_PurchPayableSetup."Update Renesas PO Error Code" := '0';
            rec_PurchPayableSetup.MODIFY;
        END;

    end;


    var
        rec_RenesasPOInterface: Record "Renesas PO Interface";
        rec_PurchPayableSetup: Record "Purchases & Payables Setup";
        Text001: Label 'Do you really want to clear all Renesas PO Interface Data?';

}