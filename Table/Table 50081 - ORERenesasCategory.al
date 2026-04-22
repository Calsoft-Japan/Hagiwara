table 50081 "ORE Renesas Category"
{
    // CS116 Shawn 2025/12/29 One Renesas EDI V2


    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

