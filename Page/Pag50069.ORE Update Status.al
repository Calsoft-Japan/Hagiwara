page 50069 "ORE Update Status"
{
    Caption = 'ORE Update Status';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'HWBC';
    APIVersion = 'v2.0';
    EntitySetCaption = 'OREUpdateStatus';
    EntitySetName = 'OREUpdateStatus';
    EntityCaption = 'OREUpdateStatus';
    EntityName = 'OREUpdateStatus';
    ODataKeyFields = "Entry No.";
    SourceTable = "ORE Message Collection Buffer";
    SourceTableTemporary = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(OREMsgHistEntryNo; Rec."ORE Msg Hist Entry No.")
                {
                    ApplicationArea = All;
                }
                field(MessageName; Rec."Message Name")
                {
                    ApplicationArea = All;
                }
                field(ReverseRoutingAddress; Rec."Reverse Routing Address")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        Const_MN_ORDERS: Label 'ORDERS';
        Const_MN_ORDCHG: Label 'ORDCHG';
        Const_MN_INVRPT: Label 'INVRPT';
        Const_MN_SLSRPT: Label 'SLSRPT';

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    begin

        case
        rec."Message Name" of
            Const_MN_ORDERS:
                begin
                    UpdateStatus_ORDERS();
                end;
            Const_MN_ORDCHG:
                begin
                    UpdateStatus_ORDCHG();
                end;
            Const_MN_INVRPT:
                begin
                    UpdateStatus_INVRPT();
                end;
            Const_MN_SLSRPT:
                begin
                    UpdateStatus_SLSRPT();
                end;

        end;

    end;


    procedure UpdateStatus_ORDERS()
    var
        OREMessageCollectionORDERS: Record "ORE Message Collection ORDERS";
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory1: Record "ORE Message History";
    begin

        OREMessageHistory1.RESET;
        OREMessageHistory1.SETRANGE("Message Name", 'ORDERS');
        OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory1."Message Status"::Ready);
        OREMessageHistory1.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        IF OREMessageHistory1.FIND('-') THEN BEGIN
            REPEAT

                OREMessageCollectionORDERS.RESET;
                OREMessageCollectionORDERS.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                IF OREMessageCollectionORDERS.FIND('-') THEN BEGIN
                    REPEAT
                        PurchaseLine.RESET;
                        PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDERS."Line No.");
                        PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDERS."Order No.");
                        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                        IF PurchaseLine.FIND('-') THEN BEGIN
                            REPEAT
                                PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::Sent;
                                PurchaseLine.MODIFY(TRUE);
                            UNTIL PurchaseLine.NEXT = 0;
                        END;
                        OREMessageCollectionORDERS."Message Status" := OREMessageCollectionORDERS."Message Status"::Sent;
                        OREMessageCollectionORDERS.MODIFY(TRUE);

                    UNTIL OREMessageCollectionORDERS.NEXT = 0;
                END;

                OREMessageHistory1."File Sent By" := USERID;
                OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                OREMessageHistory1.MODIFY(TRUE);

            UNTIL OREMessageHistory1.NEXT = 0;

        END;

    END;

    procedure UpdateStatus_ORDCHG()
    var
        OREMessageCollectionORDCHG: Record "ORE Message Collection ORDCHG";
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory1: Record "ORE Message History";
    begin

        OREMessageHistory1.RESET;
        OREMessageHistory1.SETRANGE("Message Name", Const_MN_ORDCHG);
        OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory1."Message Status"::Ready);
        OREMessageHistory1.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        IF OREMessageHistory1.FIND('-') THEN BEGIN
            REPEAT
                OREMessageCollectionORDCHG.RESET;
                OREMessageCollectionORDCHG.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                IF OREMessageCollectionORDCHG.FIND('-') THEN BEGIN
                    REPEAT
                        PurchaseLine.RESET;
                        PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDCHG."Line No.");
                        PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDCHG."Order No.");
                        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                        IF PurchaseLine.FIND('-') THEN BEGIN
                            REPEAT
                                PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Sent;
                                PurchaseLine.MODIFY(TRUE);
                            UNTIL PurchaseLine.NEXT = 0;
                        END;
                        OREMessageCollectionORDCHG."Message Status" := OREMessageCollectionORDCHG."Message Status"::Sent;
                        OREMessageCollectionORDCHG.MODIFY(TRUE);

                    UNTIL OREMessageCollectionORDCHG.NEXT = 0;
                END;

                OREMessageHistory1."File Sent By" := USERID;
                OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                OREMessageHistory1.MODIFY(TRUE);

            UNTIL OREMessageHistory1.NEXT = 0;

        END;
    END;

    procedure UpdateStatus_INVRPT()
    var
        OREMessageCollectionINVRPT: Record "ORE Message Collection INVRPT";
        OREMessageHistory1: Record "ORE Message History";
    begin
        OREMessageHistory1.RESET;
        OREMessageHistory1.SETRANGE("Message Name", Const_MN_INVRPT);
        OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory1."Message Status"::Ready);
        //OREMessageHistory1.SETRANGE("Report End Date", OREMessageHistory1."Report End Date");
        OREMessageHistory1.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        IF OREMessageHistory1.FIND('-') THEN BEGIN
            REPEAT
                OREMessageCollectionINVRPT.RESET;
                OREMessageCollectionINVRPT.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                IF OREMessageCollectionINVRPT.FIND('-') THEN BEGIN
                    REPEAT
                        OREMessageCollectionINVRPT."Message Status" := OREMessageCollectionINVRPT."Message Status"::Sent;
                        OREMessageCollectionINVRPT.MODIFY(TRUE);

                    UNTIL OREMessageCollectionINVRPT.NEXT = 0;
                END;

                OREMessageHistory1."File Sent By" := USERID;
                OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                OREMessageHistory1.MODIFY(TRUE);

            UNTIL OREMessageHistory1.NEXT = 0;

        END;
    END;

    procedure UpdateStatus_SLSRPT()
    var
        OREMessageCollectionSLSRPT: Record "ORE Message Collection SLSRPT";
        OREMessageHistory1: Record "ORE Message History";
    begin
        OREMessageHistory1.RESET;
        OREMessageHistory1.SETRANGE("Message Name", Const_MN_SLSRPT);
        OREMessageHistory1.SETRANGE("Message Status", OREMessageHistory1."Message Status"::Ready);
        OREMessageHistory1.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        IF OREMessageHistory1.FIND('-') THEN BEGIN
            REPEAT
                OREMessageCollectionSLSRPT.RESET;
                OREMessageCollectionSLSRPT.SETRANGE("History Entry No.", OREMessageHistory1."Entry No.");
                IF OREMessageCollectionSLSRPT.FIND('-') THEN BEGIN
                    REPEAT
                        OREMessageCollectionSLSRPT."Message Status" := OREMessageCollectionSLSRPT."Message Status"::Sent;
                        OREMessageCollectionSLSRPT.MODIFY(TRUE);

                    UNTIL OREMessageCollectionSLSRPT.NEXT = 0;

                    OREMessageHistory1."File Sent By" := USERID;
                    OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                    OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                    OREMessageHistory1.MODIFY(TRUE);

                END;
            UNTIL OREMessageHistory1.NEXT = 0;
        END;
    END;

}
