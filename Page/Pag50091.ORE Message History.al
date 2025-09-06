page 50091 "ORE Message History"
{
    // CS073 Shawn 2024/08/09 - Field added: ORE Reverse Routing Address (SD)

    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Message History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; REC."Entry No.")
                {
                }
                field("Running No."; REC."Running No.")
                {
                }
                field("Report Start Date"; REC."Report Start Date")
                {
                }
                field("Report End Date"; REC."Report End Date")
                {
                }
                field("Message Name"; REC."Message Name")
                {
                }
                field("Reverse Routing Address"; REC."Reverse Routing Address")
                {
                }
                field("Reverse Routing Address (SD)"; REC."Reverse Routing Address (SD)")
                {
                }
                field("Message Status"; REC."Message Status")
                {
                }
                field("Collected By"; REC."Collected By")
                {
                }
                field("Collected On"; REC."Collected On")
                {
                }
                field("Cancelled By"; REC."Cancelled By")
                {
                }
                field("Cancelled On"; REC."Cancelled On")
                {
                }
                field("File Sent By"; REC."File Sent By")
                {
                }
                field("File Sent On"; REC."File Sent On")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(History)
            {
                Caption = 'History';
                Image = Confirm;
                action("Collect Message")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Collect Message';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CheckDataCode: Boolean;
                    begin
                        CheckDataCode := FALSE;
                        Selection := STRMENU(TEXT000, 1);
                        IF Selection = 0 THEN
                            EXIT;
                        CASE Selection OF
                            1:
                                BEGIN
                                    ORECollectMessage."Collect Message_ORDERS"();
                                    MESSAGE('Collect message ORDERS completed.');
                                END;
                            2:
                                BEGIN
                                    ORECollectMessage."Collect Message_ORDCHG"();
                                    MESSAGE('Collect message ORDCHG completed.');
                                END;
                            3:
                                BEGIN

                                    CheckDataCode := ORECollectMessage.CheckData('INVRPTHEAD', '', 0, '', '');
                                    IF CheckDataCode THEN BEGIN
                                        IF NOT CONFIRM(Text003, FALSE) THEN
                                            EXIT;
                                    END;
                                    ORECollectMessage."Collect Message_INVRPT"();
                                    MESSAGE('Collect message INVRPT completed.');
                                END;
                            4:
                                BEGIN
                                    CheckDataCode := ORECollectMessage.CheckData('SLSRPTHEAD', '', 0, '', '');
                                    IF CheckDataCode THEN BEGIN
                                        IF NOT CONFIRM(Text004, FALSE) THEN
                                            EXIT;
                                    END;
                                    ORECollectMessage."Collect Message_SLSRPT"();
                                    MESSAGE('Collect message SLSRPT completed.');
                                END;
                            5:
                                BEGIN

                                    CheckDataCode := ORECollectMessage.CheckData('INVRPTHEAD', '', 0, '', '');
                                    IF CheckDataCode THEN BEGIN
                                        IF NOT CONFIRM(Text005, FALSE) THEN
                                            EXIT;
                                    END;
                                    ORECollectMessage."Collect Message_INVRPT(Monthly)"();
                                    MESSAGE('Collect message INVRPT completed.');
                                END;
                        END;
                    end;
                }
                action("Send Message")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Message';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ORESendMessage: Codeunit "ORE Send Message";
                    begin
                        CASE Rec."Message Name" OF
                            'ORDERS':
                                BEGIN
                                    ORESendMessage."Send Message_ORDERS"();
                                    MESSAGE('Send message ORDERS completed.');
                                END;
                            'ORDCHG':
                                BEGIN
                                    ORESendMessage."Send Message_ORDCHG"();
                                    MESSAGE('Send message ORDCHG completed.');
                                END;
                            'INVRPT':
                                BEGIN
                                    ORESendMessage."Send Message_INVRPT"();
                                    MESSAGE('Send message INVRPT completed.');
                                END;
                            'SLSRPT':
                                BEGIN
                                    ORESendMessage."Send Message_SLSRPT"();
                                    MESSAGE('Send message SLSRPT  completed.');
                                END;
                        END;
                    end;
                }
                action("Cancel Message")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Message';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CASE Rec."Message Name" OF
                            'ORDERS':
                                BEGIN
                                    IF NOT CONFIRM(Text001, FALSE) THEN
                                        EXIT;
                                    OREMessageCollectionORDERS.RESET;
                                    OREMessageCollectionORDERS.SETRANGE("History Entry No.", Rec."Entry No.");
                                    IF OREMessageCollectionORDERS.FIND('-') THEN BEGIN
                                        REPEAT
                                            PurchaseLine.RESET;
                                            PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDERS."Line No.");
                                            PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDERS."Order No.");
                                            PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                                            PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                            PurchaseLine.SETFILTER("ORE Message Status", '=2|3');
                                            IF PurchaseLine.FIND('-') THEN BEGIN
                                                REPEAT
                                                    PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::"Ready to Collect";
                                                    PurchaseLine.MODIFY(TRUE);
                                                UNTIL PurchaseLine.NEXT = 0;
                                            END;
                                            OREMessageCollectionORDERS."Message Status" := OREMessageCollectionORDERS."Message Status"::Cancelled;
                                            OREMessageCollectionORDERS.MODIFY(TRUE);
                                        UNTIL OREMessageCollectionORDERS.NEXT = 0;
                                    END;
                                END;
                            'ORDCHG':
                                BEGIN
                                    IF NOT CONFIRM(Text002, FALSE) THEN
                                        EXIT;
                                    OREMessageCollectionORDCHG.RESET;
                                    OREMessageCollectionORDCHG.SETRANGE("History Entry No.", Rec."Entry No.");
                                    IF OREMessageCollectionORDCHG.FIND('-') THEN BEGIN
                                        REPEAT
                                            PurchaseLine.RESET;
                                            PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDCHG."Line No.");
                                            PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDCHG."Order No.");
                                            PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                                            PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                                            PurchaseLine.SETFILTER("ORE Change Status", '=2|3');
                                            IF PurchaseLine.FIND('-') THEN BEGIN
                                                REPEAT
                                                    PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Changed;
                                                    PurchaseLine.MODIFY(TRUE);
                                                UNTIL PurchaseLine.NEXT = 0;
                                            END;
                                            OREMessageCollectionORDCHG."Message Status" := OREMessageCollectionORDCHG."Message Status"::Cancelled;
                                            OREMessageCollectionORDCHG.MODIFY(TRUE);
                                        UNTIL OREMessageCollectionORDCHG.NEXT = 0;
                                    END;
                                END;
                            'INVRPT':
                                BEGIN
                                    OREMessageCollectionINVRPT.RESET;
                                    OREMessageCollectionINVRPT.SETRANGE("History Entry No.", Rec."Entry No.");
                                    IF OREMessageCollectionINVRPT.FIND('-') THEN BEGIN
                                        REPEAT
                                            OREMessageCollectionINVRPT."Message Status" := OREMessageCollectionINVRPT."Message Status"::Cancelled;
                                            OREMessageCollectionINVRPT.MODIFY(TRUE);
                                        UNTIL OREMessageCollectionINVRPT.NEXT = 0;
                                    END;
                                END;
                            'SLSRPT':
                                BEGIN
                                    OREMessageCollectionSLSRPT.RESET;
                                    OREMessageCollectionSLSRPT.SETRANGE("History Entry No.", Rec."Entry No.");
                                    IF OREMessageCollectionSLSRPT.FIND('-') THEN BEGIN
                                        REPEAT
                                            OREMessageCollectionSLSRPT."Message Status" := OREMessageCollectionINVRPT."Message Status"::Cancelled;
                                            OREMessageCollectionSLSRPT.MODIFY(TRUE);
                                        UNTIL OREMessageCollectionSLSRPT.NEXT = 0;
                                    END;
                                END;

                        END;
                        Rec."Message Status" := Rec."Message Status"::Cancelled;
                        Rec."Cancelled By" := USERID;
                        Rec."Cancelled On" := CURRENTDATETIME;
                        Rec.MODIFY(TRUE);
                        CurrPage.UPDATE();
                    end;
                }
                action("Open Message Collection")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Open Message Collection';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CASE Rec."Message Name" OF
                            'ORDERS':
                                BEGIN
                                    OREMessageCollectionORDERS.RESET;
                                    OREMessageCollectionORDERS.SETRANGE("History Entry No.", Rec."Entry No.");
                                    OREMessageCollectionORDERS.FINDFIRST();
                                    PAGE.RUN(50092, OREMessageCollectionORDERS);
                                END;
                            'ORDCHG':
                                BEGIN
                                    OREMessageCollectionORDCHG.RESET;
                                    OREMessageCollectionORDCHG.SETRANGE("History Entry No.", Rec."Entry No.");
                                    OREMessageCollectionORDCHG.FINDFIRST();
                                    PAGE.RUN(50093, OREMessageCollectionORDCHG);
                                END;
                            'INVRPT':
                                BEGIN
                                    OREMessageCollectionINVRPT.RESET;
                                    OREMessageCollectionINVRPT.SETRANGE("History Entry No.", Rec."Entry No.");
                                    OREMessageCollectionINVRPT.FINDFIRST();
                                    PAGE.RUN(50094, OREMessageCollectionINVRPT);
                                END;
                            'SLSRPT':
                                BEGIN
                                    OREMessageCollectionSLSRPT.RESET;
                                    OREMessageCollectionSLSRPT.SETRANGE("History Entry No.", Rec."Entry No.");
                                    OREMessageCollectionSLSRPT.FINDFIRST();
                                    PAGE.RUN(50095, OREMessageCollectionSLSRPT);
                                END;
                        END;
                    end;
                }
            }
        }
    }

    var
        Selection: Integer;
        ORECollectMessage: Codeunit "ORE Collect Message";
        TEXT000: Label 'ORDERS,ORDCHG,INVRPT,SLSRPT,INVRPT(Monthly)';
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";
        PurchaseLine: Record "Purchase Line";
        Text001: Label '"One Renesas EDI Message Status" in related purchase order lines from "Collected" or "Sent" to "Ready to Collect".';
        Text002: Label '"One Renesas EDI Change Status" in related purchase order lines from "Collected" or "Sent" to "Changed". ';
        OREMessageCollectionORDCHG: Record "ORE Message Collection ORDCHG";
        OREMessageCollectionINVRPT: Record "ORE Message Collection INVRPT";
        OREMessageCollectionSLSRPT: Record "ORE Message Collection SLSRPT";
        Text003: Label 'Clicking again will automatically add the "INVRPT End Date (Weekly)"';
        Text004: Label 'Clicking again will automatically add the "SLSRPT Start Date" and "SLSRPT End Dat"';
        OREMessageHistory: Record "ORE Message History";
        Text005: Label 'Clicking again will automatically add the "INVRPT End Date (Monthly)"';
}

