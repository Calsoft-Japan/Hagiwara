table 50004 "Message Setup"
{
    fields
    {
        field(1; ID; Option)
        {
            OptionCaption = ' ,JA,JB,JC,JD,JJ';
            OptionMembers = " ",JA,JB,JC,JD,JJ;
        }
        field(10; Description; Text[50])
        {
            // cleaned
        }
        field(20; Cycle; Option)
        {
            OptionCaption = 'Daily,Monthly';
            OptionMembers = Daily,Monthly;
        }
        field(30; Combine; Boolean)
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; ID)
        {
        }
        key(Key2; Cycle)
        {
        }
        key(Key3; Combine)
        {
        }
    }

    fieldgroups
    {
    }
}
