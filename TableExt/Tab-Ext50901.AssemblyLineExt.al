tableextension 50901 "Assembly Line Ext" extends "Assembly Line"
{
    trigger OnBeforeModify()
    var
        AssemblyHeader: Record "Assembly Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin
            AssemblyHeader := Rec.GetHeader();
            if AssemblyHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeInsert()
    var
        AssemblyHeader: Record "Assembly Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin
            AssemblyHeader := Rec.GetHeader();
            if AssemblyHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        AssemblyHeader: Record "Assembly Header";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin
            AssemblyHeader := Rec.GetHeader();
            if AssemblyHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

}
