table 50122 "Hagiwara Approver E-Signature"
{

    fields
    {
        field(1; "User Name"; Code[50])
        {
            TableRelation = user."User Name";
        }
        field(2; "E-Signature"; Blob)
        {

        }
    }

    keys
    {
        key(Key1; "User Name")
        {
        }
    }

}

