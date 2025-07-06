table 50064 "Hagiwara Group"
{
    fields
    {
        field(1; "Code"; Code[10])
        {
            // cleaned
        }
        field(2; Company; Text[30])
        {
            TableRelation = Company.Name;
            // cleaned
        }
    }
}
