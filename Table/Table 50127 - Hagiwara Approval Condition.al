table 50127 "Hagiwara Approval Condition"
{

    fields
    {

        field(1; Data; Enum "Hagiwara Approval Data")
        {
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

