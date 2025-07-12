table 50044 "Employee Mater"
{
    fields
    {
        field(1; "Emplyee No."; Code[10])
        {
            // cleaned
        }
        field(2; "Employee Name"; Text[30])
        {
            // cleaned
        }
        field(3; "Employee IC"; Code[10])
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Emplyee No.")
        {
        }
        key(Key2; "Employee Name", "Emplyee No.")
        {
        }
    }

    fieldgroups
    {
    }
}
