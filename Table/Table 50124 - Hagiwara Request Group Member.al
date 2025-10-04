table 50124 "Hagiwara Request Group Member"
{

    fields
    {
        field(1; "Request Group Code"; Code[30])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }

        field(3; Data; Option)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Hagiwara Request Group".Data where(Code = field("Request Group Code")));
            OptionMembers = "","Customer","Vendor","Item","G/L Account","Price List","Sales Order","Purchase Order","Sales Credit Memo","Purchase Credit Memo","Sales Return Order","Purchase Return Order","Item Reclass Journal","Transfer Order","Item Journal","Assembly Order";
        }
        field(4; "Request User Name"; Code[50])
        {
            NotBlank = true;
            TableRelation = user."User Name";
        }

    }

    keys
    {
        key(Key1; "Request Group Code", "Request User Name")
        {
        }
    }

}

