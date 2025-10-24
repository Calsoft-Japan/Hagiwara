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
}
