table 50001 TempDO
{
    fields
    {
        field(1; "Item No."; Code[20])
        {
            // cleaned
        }
        field(2; "Shipment Date"; Date)
        {
            // cleaned
        }
        field(3; "Document No."; Code[20])
        {
            // cleaned
        }
        field(4; "Line No."; Integer)
        {
            // cleaned
        }
        field(6; Quantity; Decimal)
        {
            // cleaned
        }
        field(7; "Reserved Qty"; Decimal)
        {
            // cleaned
        }
        field(8; "Assigned Qty"; Decimal)
        {
            // cleaned
        }
        field(9; Location; Code[10])
        {
            // cleaned
        }
        field(10; ProcFlag; Integer)
        {
            // cleaned
        }
        field(11; "Available Qty"; Decimal)
        {
            // cleaned
        }
    }
    keys
    {
        key(Key1; "Item No.", "Shipment Date", "Document No.", "Line No.")
        {

        }
    }

    fieldgroups
    {
    }
}
