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
        field(50004; "Approved Quantity"; Decimal)
        {
            //N005
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50005; "Approval Cycle No."; Integer)
        {
            //stores the number of completed approval cycles in Hagiwara Approval Entry.
            //(only counts approvals by the final approver; intermediate Reject or Cancel actions are excluded).
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


            if "Approval Cycle No." > 0 then begin
                if ("Item No." <> xRec."Item No.")
                    or (Description <> xRec.Description) then begin
                    Error('Can''t edit this field because of it''s been fully approved once.');
                end;
            end;

            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"] then begin
                if (Quantity <> xRec.Quantity)
                    or ("Quantity to Assemble" <> xRec."Quantity to Assemble")
                    or ("Location Code" <> xRec."Location Code")
                    or ("Unit of Measure Code" <> xRec."Unit of Measure Code") then begin

                    Error('Can''t edit this data because of it''s approved.');
                end;
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

            if "Approval Cycle No." > 0 then begin
                Error('Can''t edit this field because of it''s been fully approved once.');
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
