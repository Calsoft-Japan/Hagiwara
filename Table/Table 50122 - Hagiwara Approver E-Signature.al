table 50122 "Hagiwara Approver E-Signature"
{

    fields
    {
        field(1; "User Name"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Sign Picture"; Media)
        {
        }
        field(3; "E-Signature"; Blob)
        {
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(Key1; "User Name")
        {
        }
    }

}

