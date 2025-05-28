table 50050 "ORE Message Setup"
{
    fields
    {
        field(1;"Code";Code[10])
        {
            // cleaned
        }
        field(10;"Message Name";Option)
        {
            OptionCaption = 'ORDERS,ORDCHG,INVRPT,SLSRPT';
            OptionMembers = ORDERS,ORDCHG,INVRPT,SLSRPT;
        }
        field(11;Description;Text[250])
        {
            // cleaned
        }
        field(12;Cycle;Option)
        {
            OptionCaption = 'Daily,Weekly,Monthly';
            OptionMembers = Daily,Weekly,Monthly;
        }
    }
}
