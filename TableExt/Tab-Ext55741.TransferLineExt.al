tableextension 55741 "Transfer Line Ext" extends "Transfer Line"
{
    fields
    {
        field(50010; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Description = '//ms fon';
        }

        field(50101; "Approved Quantity"; Decimal)
        {
            //N005
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50103; "Approval History Exists"; Boolean)
        {
            //N005
            Editable = false;
        }

        modify("Item No.")
        {

            trigger OnBeforeValidate()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                recApprSetup.Get();
                if recApprSetup."Transfer Order" then begin

                    if Rec."Approval History Exists" then begin
                        if ("Item No." <> xRec."Item No.") then begin
                            Error('Can''t edit this field because of it''s been fully approved once.');
                        end;
                    end;
                end;
                //N005 End

            end;
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

            if TransferHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"] then begin
                if Rec."Approval History Exists" then begin
                    if (Quantity <> xRec.Quantity)
                    or ("Unit of Measure Code" <> xRec."Unit of Measure Code") then begin

                        Error('Can''t edit this data because of it''s approved.');
                    end;
                end;
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

            if "Approval History Exists" then begin
                Error('Can''t edit this data because of it''s approved.');
            end;
        end;
        //N005 End

    end;

}
