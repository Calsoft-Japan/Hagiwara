report 50115 "ORE Collect Msg Auto (Monthly)"
{
    // CS060 Leon 2023/10/18 - One Renesas EDI

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
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
    var
        Day: Integer;
        ToDay2: Integer;
        OREMessageSetup: Record "ORE Message Setup";
        ORECollectMessage: Codeunit "ORE Collect Message";
    begin
        Day := DATE2DMY(WORKDATE, 1);

        IF Day = 1 THEN BEGIN
            OREMessageSetup.RESET;
            OREMessageSetup.SETRANGE(Cycle, OREMessageSetup.Cycle::Monthly);
            IF OREMessageSetup.FIND('-') THEN BEGIN
                REPEAT
                    CASE OREMessageSetup."Message Name" OF
                        OREMessageSetup."Message Name"::ORDERS:
                            BEGIN
                                ORECollectMessage."Collect Message_ORDERS"();
                            END;
                        OREMessageSetup."Message Name"::ORDCHG:
                            BEGIN
                                ORECollectMessage."Collect Message_ORDCHG"();
                            END;
                        OREMessageSetup."Message Name"::INVRPT:
                            BEGIN
                                ORECollectMessage."Collect Message_INVRPT(Monthly)"();
                            END;
                        OREMessageSetup."Message Name"::SLSRPT:
                            BEGIN
                                ORECollectMessage."Collect Message_SLSRPT"();
                            END;
                    END;
                UNTIL OREMessageSetup.NEXT = 0;
            END;
        END;
    end;

    trigger OnPreReport()
    var
        Day: Integer;
        ToDay2: Integer;
    begin
    end;

    var
        Rec_SO: Record "Sales Header";
}

