//FDD301 page for the NBKAPI INSTOKUCD.
page 50200 "PSI Get Message"
{
    ApplicationArea = All;
    Caption = 'PSI Get Message';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'PSI';
    APIVersion = 'v2.0';
    EntitySetCaption = 'PSIGetMessage';
    EntitySetName = 'PSIGetMessage';
    EntityCaption = 'PSIGetMessage';
    EntityName = 'PSIGetMessage';
    ODataKeyFields = "Entry No.";
    SourceTable = "Send Message Buffer";
    UsageCategory = Administration;
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
                field(ExportText; Rec."Export Text")
                {
                    ApplicationArea = All;
                }
                field(ExportText2; Rec."Export Text 2")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
