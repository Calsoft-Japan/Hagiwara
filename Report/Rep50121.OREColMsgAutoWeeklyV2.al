report 50121 "ORE Col Msg Auto (Weekly) V2"
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
    begin
        OREMessageSetup.RESET;
        OREMessageSetup.SETRANGE(Cycle, OREMessageSetup.Cycle::Weekly);
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
                            ORECollectMessage."Collect Message_INVRPT(Weekly)"();
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
        ORECollectMessage: Codeunit "ORE Collect Message V2";
}

