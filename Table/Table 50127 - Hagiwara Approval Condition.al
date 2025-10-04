table 50127 "Hagiwara Approval Condition"
{

    fields
    {

        field(1; Data; Option)
        {
            OptionMembers = "","Customer","Vendor","Item","G/L Account","Price List","Sales Order","Purchase Order","Sales Credit Memo","Purchase Credit Memo","Sales Return Order","Purchase Return Order","Item Reclass Journal","Transfer Order","Item Journal","Assembly Order";
        }
        field(2; "Request Group Code"; Code[30])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }
        field(3; "Approval Group Code"; Code[30])
        {
            TableRelation = "Hagiwara Approval Group".Code;
        }
        field(4; "Amount (LCY)"; Decimal)
        {

        }
        field(5; "Start Date"; Date)
        {

        }
        field(6; "End Date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; Data, "Request Group Code", "Approval Group Code", "Amount (LCY)", "Start Date")
        {
        }
    }

}

