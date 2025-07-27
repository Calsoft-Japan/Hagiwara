table 50102 "Update SOPO Price"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {

        }
        field(2; "Update Target Date"; Date)
        {

        }
        field(3; "Document Type"; Option)
        {
            OptionMembers = "Sales Order","Purchase Order";

        }
        field(4; "Document No."; Code[20])
        {

        }
        field(5; "Line No."; Integer)
        {

        }
        field(6; "Item No."; Code[20])
        {

        }
        field(7; "Item Description"; Text[100])
        {

        }
        field(8; "Old Price"; Decimal)
        {

        }
        field(9; "New Price"; Decimal)
        {

        }
        field(10; "Quantity Invoiced"; Decimal)
        {

        }
        field(11; Quantity; Decimal)
        {

        }
        field(12; "Error Message"; Text[250])
        {

        }
        field(13; "Log DateTime"; DateTime)
        {

        }
        field(14; "User ID"; Code[50])
        {

        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
