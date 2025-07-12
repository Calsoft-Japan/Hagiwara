table 50025 "Sales Invoice Import Line"
{
    fields
    {
        field(1; "Posting Date"; Date)
        {
            // cleaned
        }
        field(2; "Document Date"; Date)
        {
            // cleaned
        }
        field(3; "Customer No."; Code[20])
        {
            // cleaned
        }
        field(4; "Order No."; Code[20])
        {
            // cleaned
        }
        field(5; "Line No."; Integer)
        {
            // cleaned
        }
        field(6; "Item No."; Code[20])
        {
            // cleaned
        }
        field(7; "Qty. to Invoice"; Decimal)
        {
            // cleaned
        }
        field(8; "Shipment Method Code"; Code[20])
        {
            // cleaned
        }
        field(9; "Shipping Agent Code"; Code[10])
        {
            // cleaned
        }
        field(10; "Package Tracking No."; Text[50])
        {
            // cleaned
        }
        field(11; "Unit Price"; Decimal)
        {
            // cleaned
        }
        field(12; "Due Date"; Date)
        {
            // cleaned
        }
        field(13; Status; Option)
        {
            OptionMembers = Pending,Error,Processed,PostError,OK;
        }
        field(14; "Error Description"; Text[250])
        {
            // cleaned
        }
        field(15; "Entry No."; Integer)
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Order No.", "Posting Date", "Document Date", "Shipment Method Code", "Shipping Agent Code", "Package Tracking No.", "Line No.")
        {
        }
        key(Key3; "Shipment Method Code")
        {
        }
        key(Key4; "Unit Price")
        {
        }
    }

    fieldgroups
    {
    }
}
