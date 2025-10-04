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

        field(3; Data; Option)
        {
            NotBlank = true;
            OptionMembers = "","Customer","Vendor","Item","G/L Account","Price List","Sales Order","Purchase Order","Sales Credit Memo","Purchase Credit Memo","Sales Return Order","Purchase Return Order","Item Reclass Journal","Transfer Order","Item Journal","Assembly Order";
        }
    }

    keys
    {
        key(Key1; Code)
        {
        }
    }

}

