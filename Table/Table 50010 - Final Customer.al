table 50010 "Final Customer"
{
    fields
    {
        field(1; "Final Customer No."; Code[20])
        {
            // cleaned
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer;
            // cleaned
        }
        field(3; "Final Customer Name"; Text[50])
        {
            // cleaned
        }
    }
}
