codeunit 50186 "Clear Renesas PO Interface Rec"
{

    trigger OnRun()
    begin

        IF CONFIRM(Text001, TRUE) THEN BEGIN
            rec_RenesasPOInterface.DELETEALL;
            rec_RenesasPOInterface.RESET;
        END;
    end;


    var
        rec_RenesasPOInterface: Record "Renesas PO Interface";
        Text001: Label 'Do you really want to clear all Renesas PO Interface Data?';

}