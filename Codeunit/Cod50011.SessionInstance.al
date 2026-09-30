codeunit 50011 "Session Instance"
{
    SingleInstance = true;

    var
        RenesasPOIFProcessing: Boolean;

    procedure SetRenesasPOIF()
    begin
        RenesasPOIFProcessing := true;
    end;

    procedure ClearRenesasPOIF()
    begin
        RenesasPOIFProcessing := false;
    end;

    procedure IsRenesasPOIF(): Boolean
    begin
        exit(RenesasPOIFProcessing);
    end;
}
