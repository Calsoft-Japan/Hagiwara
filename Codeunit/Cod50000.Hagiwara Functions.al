codeunit 50000 "Hagiwara Functions"
{
    // HG10.00.04 NJ 13/02/2018 - New codeunit created


    trigger OnRun()
    begin
    end;

    procedure GetIncotermVisibility(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Show Incoterm Code" THEN
                EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;
}

