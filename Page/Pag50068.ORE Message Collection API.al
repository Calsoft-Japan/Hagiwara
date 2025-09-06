page 50068 "ORE Message Collection API"
{
    Caption = 'ORE Message Collection API';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'HWBC';
    APIVersion = 'v2.0';
    EntitySetCaption = 'OREGetMessage';
    EntitySetName = 'OREGetMessage';
    EntityCaption = 'OREGetMessage';
    EntityName = 'OREGetMessage';
    ODataKeyFields = "Entry No.";
    SourceTable = "ORE Message Collection Buffer";
    DelayedInsert = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;

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
                field(ReverseRoutingAddress_SD; Rec."Reverse Routing Address (SD)")
                {
                    ApplicationArea = All;
                }
                field(FileName; Rec."File Name")
                {
                    ApplicationArea = All;
                }
                field(Data; DataText)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        DataText := Rec.GetData();
    end;

    var
        DataText: Text;
}
