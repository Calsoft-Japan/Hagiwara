table 50128 "Hagiwara Approval Substitution"
{

    fields
    {
        field(1; "Approver User Name"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Substitution User Name"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }

        field(3; "Start Date"; Date)
        {
            NotBlank = true;
        }
        field(4; "End Date"; Date)
        {
        }

    }

    keys
    {
        key(Key1; "Approver User Name", "Substitution User Name", "Start Date", "End Date")
        {
        }
    }

}

