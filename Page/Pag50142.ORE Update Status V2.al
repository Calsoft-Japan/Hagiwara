page 50142 "ORE Update Status V2"
{
    Caption = 'ORE Update Status V2';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'HWBC';
    APIVersion = 'v2.0';
    EntitySetCaption = 'OREV2UpdateStatus';
    EntitySetName = 'OREV2UpdateStatus';
    EntityCaption = 'OREV2UpdateStatus';
    EntityName = 'OREV2UpdateStatus';
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
        OREMessageCollectionORDERS: Record "ORE Msg Collection ORDERS V2";
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory1: Record "ORE Message History V2";
        LastHistoryEntryNo: Integer;
    begin

        OREMessageCollectionORDERS.RESET;
        OREMessageCollectionORDERS.SetCurrentKey("Reverse Routing Address");
        OREMessageCollectionORDERS.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        OREMessageCollectionORDERS.SETRANGE("Message Status", OREMessageCollectionORDERS."Message Status"::Ready);
        if OREMessageCollectionORDERS.FindSet() then
            REPEAT
                if LastHistoryEntryNo <> OREMessageCollectionORDERS."History Entry No." then begin

                    OREMessageHistory1.Get(OREMessageCollectionORDERS."History Entry No.");

                    OREMessageHistory1."File Sent By" := USERID;
                    OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                    OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                    OREMessageHistory1.MODIFY(TRUE);

                    LastHistoryEntryNo := OREMessageCollectionORDERS."History Entry No.";

                end;

                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDERS."Line No.");
                PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDERS."Order No.");
                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                IF PurchaseLine.FindSet THEN BEGIN
                    REPEAT
                        PurchaseLine."ORE Message Status" := PurchaseLine."ORE Message Status"::Sent;
                        PurchaseLine.MODIFY(TRUE);
                    UNTIL PurchaseLine.NEXT = 0;
                END;

                OREMessageCollectionORDERS."Message Status" := OREMessageCollectionORDERS."Message Status"::Sent;
                OREMessageCollectionORDERS.MODIFY(TRUE);

            UNTIL OREMessageCollectionORDERS.NEXT = 0;

    END;

    procedure UpdateStatus_ORDCHG()
    var
        OREMessageCollectionORDCHG: Record "ORE Msg Collection ORDCHG V2";
        PurchaseLine: Record "Purchase Line";
        OREMessageHistory1: Record "ORE Message History V2";
        LastHistoryEntryNo: Integer;
    begin


        OREMessageCollectionORDCHG.RESET;
        OREMessageCollectionORDCHG.SetCurrentKey("Reverse Routing Address");
        OREMessageCollectionORDCHG.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        OREMessageCollectionORDCHG.SETRANGE("Message Status", OREMessageCollectionORDCHG."Message Status"::Ready);
        if OREMessageCollectionORDCHG.FindSet() then
            REPEAT
                if LastHistoryEntryNo <> OREMessageCollectionORDCHG."History Entry No." then begin

                    OREMessageHistory1.Get(OREMessageCollectionORDCHG."History Entry No.");

                    OREMessageHistory1."File Sent By" := USERID;
                    OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                    OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                    OREMessageHistory1.MODIFY(TRUE);

                    LastHistoryEntryNo := OREMessageCollectionORDCHG."History Entry No.";

                end;

                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Line No.", OREMessageCollectionORDCHG."Line No.");
                PurchaseLine.SETRANGE("Document No.", OREMessageCollectionORDCHG."Order No.");
                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
                PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
                IF PurchaseLine.FindSet THEN BEGIN
                    REPEAT
                        PurchaseLine."ORE Change Status" := PurchaseLine."ORE Change Status"::Sent;
                        PurchaseLine.MODIFY(TRUE);
                    UNTIL PurchaseLine.NEXT = 0;
                END;

                OREMessageCollectionORDCHG."Message Status" := OREMessageCollectionORDCHG."Message Status"::Sent;
                OREMessageCollectionORDCHG.MODIFY(TRUE);

            UNTIL OREMessageCollectionORDCHG.NEXT = 0;

    END;

    procedure UpdateStatus_INVRPT()
    var
        OREMessageCollectionINVRPT: Record "ORE Msg Collection INVRPT V2";
        OREMessageHistory1: Record "ORE Message History V2";
        LastHistoryEntryNo: Integer;
    begin

        OREMessageCollectionINVRPT.RESET;
        OREMessageCollectionINVRPT.SetCurrentKey("Reverse Routing Address");
        OREMessageCollectionINVRPT.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        OREMessageCollectionINVRPT.SETRANGE("Message Status", OREMessageCollectionINVRPT."Message Status"::Ready);
        if OREMessageCollectionINVRPT.FindSet() then
            REPEAT
                if LastHistoryEntryNo <> OREMessageCollectionINVRPT."History Entry No." then begin

                    OREMessageHistory1.Get(OREMessageCollectionINVRPT."History Entry No.");

                    OREMessageHistory1."File Sent By" := USERID;
                    OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                    OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                    OREMessageHistory1.MODIFY(TRUE);

                    LastHistoryEntryNo := OREMessageCollectionINVRPT."History Entry No.";

                end;

                OREMessageCollectionINVRPT."Message Status" := OREMessageCollectionINVRPT."Message Status"::Sent;
                OREMessageCollectionINVRPT.MODIFY(TRUE);

            UNTIL OREMessageCollectionINVRPT.NEXT = 0;

    END;

    procedure UpdateStatus_SLSRPT()
    var
        OREMessageCollectionSLSRPT: Record "ORE Msg Collection SLSRPT V2";
        OREMessageHistory1: Record "ORE Message History V2";
        LastHistoryEntryNo: Integer;
    begin


        OREMessageCollectionSLSRPT.RESET;
        OREMessageCollectionSLSRPT.SetCurrentKey("Reverse Routing Address");
        OREMessageCollectionSLSRPT.SETRANGE("Reverse Routing Address", Rec."Reverse Routing Address");
        OREMessageCollectionSLSRPT.SETRANGE("Message Status", OREMessageCollectionSLSRPT."Message Status"::Ready);
        if OREMessageCollectionSLSRPT.FindSet() then
            REPEAT
                if LastHistoryEntryNo <> OREMessageCollectionSLSRPT."History Entry No." then begin

                    OREMessageHistory1.Get(OREMessageCollectionSLSRPT."History Entry No.");

                    OREMessageHistory1."File Sent By" := USERID;
                    OREMessageHistory1."File Sent On" := CURRENTDATETIME;
                    OREMessageHistory1."Message Status" := OREMessageHistory1."Message Status"::Sent;
                    OREMessageHistory1.MODIFY(TRUE);

                    LastHistoryEntryNo := OREMessageCollectionSLSRPT."History Entry No.";

                end;

                OREMessageCollectionSLSRPT."Message Status" := OREMessageCollectionSLSRPT."Message Status"::Sent;
                OREMessageCollectionSLSRPT.MODIFY(TRUE);

            UNTIL OREMessageCollectionSLSRPT.NEXT = 0;

    END;

}
