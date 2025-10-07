table 50123 "Hagiwara Request Group"
{

    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; "Description"; Text[250])
        {

        }

        field(3; Data; Enum "Hagiwara Approval Data")
        {
            NotBlank = true;
        }
    }

    keys
    {
        key(Key1; Code)
        {
        }
    }

}

