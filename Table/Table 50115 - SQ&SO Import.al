//CS092 2025/10/09 Channing.Zhou N008 SQ&SO Import
table 50115 "SQ&SO Import"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Grouping Key"; Integer)
        {
        }
        field(3; "Document Type"; Option)
        {
            OptionCaption = 'SQ,SO';
            OptionMembers = SQ,SO;
        }
        field(4; "Customer No."; Code[20])
        {
        }
        field(5; "Customer Order No."; Code[35])
        {
        }
        field(6; "Order Date"; Date)
        {
        }
        field(7; "Requested Delivery Date"; Date)
        {
        }
        field(8; "Shipment Date"; Date)
        {
        }
        field(9; "Item No."; Code[20])
        {
        }
        field(10; Quantity; Decimal)
        {
        }
        field(11; "Document No."; Code[20])
        {
        }
        field(12; "Line No."; Integer)
        {
        }
        field(13; Status; Option)
        {
            OptionCaption = 'Pending,Error,Validated,Completed';
            OptionMembers = Pending,Error,Validated,Completed;
        }
        field(14; "Error Description"; Text[250])
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
