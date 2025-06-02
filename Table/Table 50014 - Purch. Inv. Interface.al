table 50014 "Purch. Inv. Interface"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(10; "Hagiwara PO No."; Code[25])
        {
            Description = 'Due to Line No. Ex:PQ2438-01';
        }
        field(20; "Delivery Order No."; Code[50])
        {
            // cleaned
        }
        field(30; "Billing No."; Code[50])
        {
            // cleaned
        }
        field(40; "Billing Date"; Code[10])
        {
            // cleaned
        }
        field(50; "Material Desc"; Code[100])
        {
            // cleaned
        }
        field(60; Quantity; Decimal)
        {
            // cleaned
        }
        field(70; "Unit Price"; Decimal)
        {
            // cleaned
        }
        field(80; "NAV Posted Rcpt No."; Code[20])
        {
            // cleaned
        }
        field(90; "Processed By"; Code[50])
        {
            Description = 'Fields to maintain for creation';
        }
        field(100; "Processed On"; Date)
        {
            Description = 'Fields to maintain for creation';
        }
        field(101; "Processed PI No."; Code[20])
        {
            Description = 'Fields to maintain for creation';
        }
    }
}
