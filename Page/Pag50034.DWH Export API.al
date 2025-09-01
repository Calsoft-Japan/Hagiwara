page 50034 "DWH Export API"
{
    Caption = 'DWHExport';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'DWH';
    APIVersion = 'v2.0';
    EntitySetCaption = 'DWHExport';
    EntitySetName = 'DWHExport';
    EntityCaption = 'DWHExport';
    EntityName = 'DWHExport';
    ODataKeyFields = "Entry No.";
    SourceTable = "DWH Export Buffer";
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
                field(DataName; Rec."Data Name")
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
