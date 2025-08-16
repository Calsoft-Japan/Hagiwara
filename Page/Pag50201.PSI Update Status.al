//FDD301 page for the NBKAPI INSTOKUCD.
page 50201 "PSI Update Status"
{
    ApplicationArea = All;
    Caption = 'PSI Update Status';
    PageType = API;
    APIPublisher = 'Calsoft';
    APIGroup = 'PSI';
    APIVersion = 'v2.0';
    EntitySetCaption = 'PSIUpdateStatus';
    EntitySetName = 'PSIUpdateStatus';
    EntityCaption = 'PSIUpdateStatus';
    EntityName = 'PSIUpdateStatus';
    ODataKeyFields = "Entry No.";
    SourceTable = "Send Message Buffer";
    SourceTableTemporary = true;
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
            }
        }
    }

    var
        GRec_GLSetup: Record "General Ledger Setup";

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        UpdateGLStatus();
    end;

    local procedure UpdateGLStatus()
    var
        myInt: Integer;
    begin
        GRec_GLSetup.get();
        GRec_GLSetup."PSI Job Status" := '3';
        GRec_GLSetup."Daily PSI Data Collection" := '0';
        GRec_GLSetup."Monthly PSI Data Collection" := '0';
        GRec_GLSetup.MODIFY;
    end;


    local procedure UpdatePSIDataStatus()
    var
        myInt: Integer;
    begin

    end;
}
