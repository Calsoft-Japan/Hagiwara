tableextension 57000 "Price List Header Ext" extends "Price List Header"
{
    fields
    {
        field(50091; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(50092; Requester; Code[50])
        {
            Editable = false;
        }
        field(50093; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }

        modify(Status)
        {
            trigger OnBeforeValidate()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                //N005 Begin
                if xRec.Status <> Rec.Status then begin
                    recApprSetup.Get();
                    if (recApprSetup."Price List") then begin
                        if not (Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                            Error('It is not approved yet.');
                        end;
                    end;
                end;
                //N005 End
            end;
        }
    }

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Price List") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Price List") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnAfterInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Price List") then begin
            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
            Rec.Status := Rec.Status::Draft;
        end;
        //N005 End

        Modify();
    end;
}
