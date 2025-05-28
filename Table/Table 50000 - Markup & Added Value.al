table 50000 "Markup & Added Value"
{
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; "Markup %"; Decimal)
        {
            Caption = 'Markup %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(4; "Added Value"; Decimal)
        {
            Caption = 'Added Value';
            DataClassification = ToBeClassified;
            DecimalPlaces = 4 : 4;
        }
    }
}
