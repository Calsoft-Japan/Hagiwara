report 50113 "ORE Collect Msg Auto (Daily)"
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
    begin
        OREMessageSetup.RESET;
        OREMessageSetup.SETRANGE(Cycle, OREMessageSetup.Cycle::Daily);
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
                            ORECollectMessage."Collect Message_INVRPT"();
                        END;
                    OREMessageSetup."Message Name"::SLSRPT:
                        BEGIN
                            ORECollectMessage."Collect Message_SLSRPT"();
                        END;
                END;
            UNTIL OREMessageSetup.NEXT = 0;
        END;
    end;

    var
        OREMessageSetup: Record "ORE Message Setup";
        ORECollectMessage: Codeunit "ORE Collect Message";
}

