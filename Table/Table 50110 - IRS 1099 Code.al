table 50110 "IRS 1099 Code"
{
    DataClassification = ToBeClassified;
    LookupPageId = "IRS 1099 Code";//Link to source page (2025-08-08)

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
