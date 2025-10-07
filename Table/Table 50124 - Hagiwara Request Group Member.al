table 50124 "Hagiwara Request Group Member"
{

    fields
    {
        field(1; "Request Group Code"; Code[30])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }

        field(3; Data; Enum "Hagiwara Approval Data")
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Hagiwara Request Group".Data where(Code = field("Request Group Code")));
        }
        field(4; "Request User Name"; Code[50])
        {
            NotBlank = true;
            TableRelation = "User Setup"."User ID";
        }

    }

    keys
    {
        key(Key1; "Request Group Code", "Request User Name")
        {
        }
    }

}

