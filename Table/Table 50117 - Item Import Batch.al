table 50117 "Item Import Batch"
{
    fields
    {
        field(1; "Name"; Code[20])
        {
        }
        field(2; "Description"; Text[250])
        {
        }
        field(3; "No. of Items"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Item Import Line" where("Batch Name" = field(Name)));
            Editable = false;
        }
        field(4; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(5; "Requester"; Code[50])
        {
            Editable = false;
        }
        field(6; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }
    }
    keys
    {
        key(Key1; Name)
        {
        }
    }
    trigger OnInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        recApprSetup.Get();
        if recApprSetup."Item" then begin
            rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;

    end;

    trigger OnDelete()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        ItemImportline: Record "Item Import Line";
    begin

        recApprSetup.Get();
        if recApprSetup."Item" then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;

        if Confirm('Do you want to delete Batch ' + Rec.Name + '?. The lines of this Batch will also be deleted.') then begin
            ItemImportline.SetRange("Batch Name", Rec.Name);
            ItemImportline.DeleteAll();
        end;
    end;

    trigger OnRename()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        recApprSetup.Get();
        if recApprSetup."Item" then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;

    end;


}
