//CS092 2025/11/25 N014 Customer Import Batch
table 50119 "Customer Import Batch"
{
    fields
    {
        field(1; "Name"; Code[20])
        {
            Editable = false;
        }
        field(2; "Description"; Text[250])
        {
        }
        field(3; "No. of Customers"; Integer)
        {
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
            Editable = false;
        }

    }
    keys
    {
        key(Key1; "Name")
        {
            Clustered = true;
        }

    }

    trigger OnInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        NoSeries: Codeunit "No. Series";
    begin

        recApprSetup.Get();
        if recApprSetup.Customer then begin
            rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;

        recApprSetup.TestField("Customer Import Batch Nos.");
        rec.Name := NoSeries.GetNextNo(recApprSetup."Customer Import Batch Nos.");

    end;

    trigger OnModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
        CustomerImportline: Record "Customer Import Line";
    begin

        recApprSetup.Get();
        if recApprSetup.Customer then begin
            if not (Rec."Approval Status" in [
                Enum::"Hagiwara Approval Status"::Required,
                Enum::"Hagiwara Approval Status"::Cancelled,
                Enum::"Hagiwara Approval Status"::Rejected
                ]) then begin
                Error('You can''t edit this record because approval process already initiated.');
            end;
        end;

    end;
    /*
        trigger OnDelete()
        var
            recApprSetup: Record "Hagiwara Approval Setup";
            CustomerImportline: Record "Customer Import Line";
        begin

            recApprSetup.Get();
            if recApprSetup.Customer then begin
                if not (Rec."Approval Status" in [
                    Enum::"Hagiwara Approval Status"::Required,
                    Enum::"Hagiwara Approval Status"::Cancelled,
                    Enum::"Hagiwara Approval Status"::Rejected
                    ]) then begin
                    Error('You can''t delete this record because approval process already initiated.');
                end;
            end;

            if Confirm('Do you want to delete Batch ' + Rec.Name + '?. The lines of this Batch will also be deleted.') then begin
                CustomerImportline.SetRange("Batch Name", Rec.Name);
                CustomerImportline.DeleteAll();
            end;
        end;
    */
    trigger OnRename()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        recApprSetup.Get();
        if recApprSetup.Customer then begin
            if not (Rec."Approval Status" in [
                Enum::"Hagiwara Approval Status"::Required,
                Enum::"Hagiwara Approval Status"::Cancelled,
                Enum::"Hagiwara Approval Status"::Rejected
                ]) then begin
                Error('You can''t edit this record because approval process already initiated.');
            end;
        end;

    end;


}
