report 50122 "ORE Col Msg Auto (Monthly) V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2

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

    var
        OREMessageSetup: Record "ORE Message Setup";
        ORECollectMessage: Codeunit "ORE Collect Message V2";
}

