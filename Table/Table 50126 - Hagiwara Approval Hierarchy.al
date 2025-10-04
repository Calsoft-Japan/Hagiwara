table 50126 "Hagiwara Approval Hierarchy"
{

    fields
    {
        field(1; "Approval Group Code"; Code[30])
        {
            TableRelation = "Hagiwara Approval Group".Code;
        }
        field(3; "Sequence No."; Integer)
        {
            NotBlank = true;
        }
        field(4; "Approver User Name"; Code[50])
        {
            NotBlank = true;
            TableRelation = user."User Name";
        }

    }

    keys
    {
        key(Key1; "Approval Group Code", "Sequence No.")
        {
        }
    }

}

