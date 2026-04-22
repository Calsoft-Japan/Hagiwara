table 50097 "ORE CPN Setup"
{
    // CS116 Shawn 2026/04/05 - One Renesas EDI V2


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;CPN;Text[35])
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

