tableextension 55740 "Transfer Header Ext" extends "Transfer Header"
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
        field(50004; "Approval Cycle No."; Integer)
        {
            //stores the number of completed approval cycles in Hagiwara Approval Entry.
            //(only counts approvals by the final approver; intermediate Reject or Cancel actions are excluded).
            Editable = false;
        }
    }

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        cuApprMgt: Codeunit "Hagiwara Approval Management";
        recLocation: Record Location;
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;

            if "Approval Cycle No." > 0 then begin
                if ("Transfer-from Code" <> xRec."Transfer-from Code")
                    or ("Transfer-from Name" <> xRec."Transfer-from Name")
                    or ("Transfer-to Code" <> xRec."Transfer-to Code")
                    or ("Transfer-to Name" <> xRec."Transfer-to Name") then begin
                    Error('Can''t edit this field because of it''s been fully approved once.');
                end;
            end;

            //check if location changed.
            if (xRec."Transfer-from Code" <> Rec."Transfer-from Code") or (xRec."Transfer-to Code" <> Rec."Transfer-to Code") then begin
                Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
            end;

        end;
        //N005 End
    end;

    trigger OnAfterModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        cuApprMgt: Codeunit "Hagiwara Approval Management";
        recLocation: Record Location;
    begin

        //check if location is approval target.
        if (xRec."Transfer-from Code" <> Rec."Transfer-from Code") or (xRec."Transfer-to Code" <> Rec."Transfer-to Code") then begin
            if (recLocation.Get(Rec."Transfer-from Code")) and (not recLocation."Approval Target")
            and (recLocation.Get(Rec."Transfer-to Code")) and (not recLocation."Approval Target") then begin

                cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Transfer Order", Rec."No.", UserId);
            end;
        end;
    end;

    trigger OnBeforeDelete()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;

            if "Approval Cycle No." > 0 then begin
                Error('Can''t edit this field because of it''s been fully approved once.');
            end;
        end;
        //N005 End

    end;

    trigger OnAfterInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        cuApprMgt: Codeunit "Hagiwara Approval Management";
        recLocation: Record Location;
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin

            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;

            //check if location is approval target.
            if (recLocation.Get(Rec."Transfer-from Code")) and (not recLocation."Approval Target")
            and (recLocation.Get(Rec."Transfer-to Code")) and (not recLocation."Approval Target") then begin

                cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Transfer Order", Rec."No.", UserId);
            end;
        end;
        //N005 End

    end;
}
