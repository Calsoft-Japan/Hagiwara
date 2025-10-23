tableextension 55741 "Transfer Line Ext" extends "Transfer Line"
{
    fields
    {
        field(50010; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = '//ms fon';
        }
    }

    trigger OnBeforeModify()
    var
        TransferHeader: Record "Transfer Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin
            TransferHeader := Rec.GetTransferHeader();
            if TransferHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeInsert()
    var
        TransferHeader: Record "Transfer Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin
            TransferHeader := Rec.GetTransferHeader();
            if TransferHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        TransferHeader: Record "Transfer Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin
            TransferHeader := Rec.GetTransferHeader();
            if TransferHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

}
