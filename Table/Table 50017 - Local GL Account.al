table 50017 "Local G/L Account"
{
    fields
    {
        field(1; "Local Main G/L Account No."; Code[20])
        {
            Caption = 'Local Main G/L Account No.';
        }
        field(2; "Local Detail G/L Account No."; Code[20])
        {
            Caption = 'Local Detail G/L Account No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Corporate G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'Corporate G/L Account No.';
        }
        field(5; "Center Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            CaptionClass = '1,1,1';
            Caption = 'Cost Center';
        }
    }
}
