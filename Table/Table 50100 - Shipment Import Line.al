table 50100 "Shipment Import Line"
{
    fields
    {
        field(1; "Group Key"; Integer)
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; "Customer No."; Code[20])
        {
        }
        field(4; "Item No."; Code[20])
        {

        }
        field(5; "Item Description"; Text[100])
        {
        }
        field(6; "Customer Item No."; Code[20])
        {

        }
        field(7; "Customer Order No."; Text[35])
        {
        }
        field(8; "Shipped Quantity"; Decimal)
        {
        }
        field(9; "Unit Price"; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(10; "Currency Code"; Code[10])
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Pending,Error,Processed,OK';
            OptionMembers = Pending,Error,Processed,OK;
        }
        field(12; "Error Description"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Group Key", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
