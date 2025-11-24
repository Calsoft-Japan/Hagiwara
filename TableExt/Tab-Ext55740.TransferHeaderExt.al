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
    }

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        recLocation: Record Location;
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;

            //check if location is approval target.
            if (xRec."Transfer-from Code" <> Rec."Transfer-from Code") or (xRec."Transfer-to Code" <> Rec."Transfer-to Code") then begin
                Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;

                if (recLocation.Get(Rec."Transfer-from Code")) and (not recLocation."Approval Target")
                and (recLocation.Get(Rec."Transfer-to Code")) and (not recLocation."Approval Target") then begin

                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
                end;
            end;

            /*
            if (xRec."Transfer-from Code" <> Rec."Transfer-from Code") then begin
                if (Rec."Transfer-from Code" <> '')
                and (recLocation.Get(Rec."Transfer-from Code"))
                and (not recLocation."Approval Target") then begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
                end else begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
                end;
            end;

            if (xRec."Transfer-to Code" <> Rec."Transfer-to Code") then begin
                if (Rec."Transfer-to Code" <> '')
                and (recLocation.Get(Rec."Transfer-to Code"))
                and (not recLocation."Approval Target") then begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
                end else begin
                    Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
                end;
            end;
            */
        end;

        //N005 End

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
        end;
        //N005 End

    end;

    trigger OnAfterInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        recLocation: Record Location;
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."Transfer Order") then begin

            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;

            //check if location is approval target.
            if (recLocation.Get(Rec."Transfer-from Code")) and (not recLocation."Approval Target")
            and (recLocation.Get(Rec."Transfer-to Code")) and (not recLocation."Approval Target") then begin

                Rec."Approval Status" := Enum::"Hagiwara Approval Status"::"Auto Approved";
            end;
        end;
        //N005 End

        Modify();
    end;
}
