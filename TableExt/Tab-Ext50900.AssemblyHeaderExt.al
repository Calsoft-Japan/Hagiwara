tableextension 50900 "Assembly Header Ext" extends "Assembly Header"
{
    fields
    {
        field(50001; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(50002; Requester; Code[50])
        {
            Editable = false;
        }
        field(50003; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }
    }

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin
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
        if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin
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
        if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin
            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;
        //N005 End

        Modify();
    end;
}
