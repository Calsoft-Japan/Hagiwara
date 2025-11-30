tableextension 50901 "Assembly Line Ext" extends "Assembly Line"
{
    fields
    {

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

        modify(Type)
        {

            trigger OnBeforeValidate()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                recApprSetup.Get();
                if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin

                    if Rec."Approval History Exists" then begin
                        if (Type <> xRec.Type) then begin
                            Error('Can''t edit this field because of it''s been fully approved once.');
                        end;
                    end;
                end;
                //N005 End

            end;
        }

        modify("No.")
        {

            trigger OnBeforeValidate()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin

                //N005 Begin
                recApprSetup.Get();
                if (recApprSetup."Assembly Order") and (Rec."Document Type" = Rec."Document Type"::Order) then begin

                    if Rec."Approval History Exists" then begin
                        if ("No." <> xRec."No.") then begin
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

            if AssemblyHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"] then begin
                if Rec."Approval History Exists" then begin
                    if (Quantity <> xRec.Quantity)
                    or ("Quantity per" <> xRec."Quantity per")
                    or ("Unit of Measure Code" <> xRec."Unit of Measure Code")
                    or ("Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure")
                    or ("Location Code" <> xRec."Location Code") then begin

                        Error('Can''t edit this data because of it''s approved.');
                    end;
                end;
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

            if "Approval History Exists" then begin
                Error('Can''t edit this data because of it''s approved.');
            end;
        end;
        //N005 End

    end;

}
