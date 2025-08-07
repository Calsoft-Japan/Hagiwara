table 50110 "IRS 1099 Code"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }

        field(2; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }
}
