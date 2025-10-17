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
        }
        field(4; "Approval Status"; Enum "Hagiwara Approval Status")
        {
        }
        field(5; "Requester"; Code[50])
        {
        }
        field(6; "Approver"; Code[50])
        {
        }
    }
    keys
    {
        key(Key1; Name)
        {
        }
    }
}
