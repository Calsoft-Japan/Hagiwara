tableextension 57001 "Price List Line Ext" extends "Price List Line"
{
    fields
    {
        field(50000; "ORE Debit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'CS060';
        }
        field(50001; "Ship&Debit Flag"; Boolean)
        {
            Caption = 'Ship&&Debit Flag';
            Description = 'CS060';
        }
        field(50002; "One Renesas EDI"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."One Renesas EDI" WHERE("No." = FIELD("Asset No.")));
            Description = 'CS085';
        }
        field(50003; "PC. Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Description = 'CS082';
        }
        field(50004; "PC. Currency Code"; Code[10])
        {
            TableRelation = Currency.Code;
            Description = 'CS082';
        }
        field(50005; "PC. Update Price"; Boolean)
        {
            Description = 'CS082';
        }
        field(50021; "Renesas Report Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Description = 'CS089';
            MinValue = 0;
        }
        field(50022; "Renesas Report Unit Price Cur."; Code[10])
        {
            TableRelation = Currency.Code;
            Description = 'CS089';
        }
    }
}
