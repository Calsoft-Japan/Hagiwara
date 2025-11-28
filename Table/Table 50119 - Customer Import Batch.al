//CS092 2025/11/25 N014 Customer Import Batch
table 50119 "Customer Import Batch"
{
    fields
    {
        field(1; "Name"; Code[20])
        {
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
    begin

        recApprSetup.Get();
        if recApprSetup.Customer then begin
            rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;

    end;

}
