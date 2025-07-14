table 50013 "Forecast Line"
{
    fields
    {
        field(1; "Forecast No."; Integer)
        {
            Caption = 'Forecast No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Document Detail Type"; Text[100])
        {
            // cleaned
        }
        field(4; "Sequence No."; Text[100])
        {
            // cleaned
        }
        field(5; "Item No."; Text[100])
        {
            // cleaned
        }
        field(6; Category; Text[100])
        {
            // cleaned
        }
        field(7; "Planner No."; Text[100])
        {
            // cleaned
        }
        field(8; "PO No."; Text[100])
        {
            // cleaned
        }
        field(9; "Denso Barcelona"; Text[100])
        {
            // cleaned
        }
        field(10; "Order Lot"; Text[100])
        {
            // cleaned
        }
        field(11; Quantity; Text[100])
        {
            // cleaned
        }
        field(12; Each; Text[100])
        {
            // cleaned
        }
        field(13; "Due Date"; Text[100])
        {
            // cleaned
        }
        field(14; Confirm; Text[100])
        {
            // cleaned
        }
        field(15; Weekly; Text[100])
        {
            // cleaned
        }
        field(16; "Confirmed Quantity"; Text[100])
        {
            // cleaned
        }
        field(17; Monday; Text[100])
        {
            // cleaned
        }
        field(18; Tuesday; Text[100])
        {
            // cleaned
        }
        field(19; Wednesday; Text[100])
        {
            // cleaned
        }
        field(20; Thursday; Text[100])
        {
            // cleaned
        }
        field(21; Friday; Text[100])
        {
            // cleaned
        }
        field(22; Saturday; Text[100])
        {
            // cleaned
        }
        field(23; "Demand Date (Forecast)"; Text[100])
        {
            // cleaned
        }
        field(24; Forecast; Text[100])
        {
            // cleaned
        }
        field(25; "Demand Quantity"; Text[100])
        {
            // cleaned
        }
        field(26; Type; Integer)
        {
            // cleaned
        }
        field(27; "To Line No."; Integer)
        {
            // cleaned
        }
        field(28; Status; Option)
        {
            OptionMembers = " ",Processed;
        }
        field(29; "Request Receipt Date"; Text[30])
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Forecast No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}
