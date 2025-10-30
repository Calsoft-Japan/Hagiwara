//CS092 2025/10/14 N009 PO Import
table 50116 "PO Import"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Grouping Key"; Integer)
        {
        }
        field(3; "Vendor No."; Code[20])
        {
        }
        field(4; "Order Date"; Date)
        {
        }
        field(5; "Requested Receipt Date"; Date)
        {
        }
        field(6; "CO No."; Code[6])
        {
        }
        field(7; "Item No."; Code[20])
        {
        }
        field(8; Quantity; Decimal)
        {
        }
        field(9; "Insert Comment Line"; Boolean)
        {
            InitValue = false;
        }
        field(10; "Document No."; Code[20])
        {
        }
        field(11; "Line No."; Integer)
        {
        }
        field(12; Status; Option)
        {
            OptionCaption = 'Pending,Error,Validated,Completed';
            OptionMembers = Pending,Error,Validated,Completed;
        }
        field(13; "Error Description"; Text[250])
        {
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Grouping Key")
        {
        }
    }
}
