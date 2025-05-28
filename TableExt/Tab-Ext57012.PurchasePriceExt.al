tableextension 57012 "Purchase Price Ext" extends "Purchase Price"
{
    fields
    {
        field(50000;"ORE Debit Cost";Decimal)
        {
            DecimalPlaces = 0:3;
            Description = 'CS060';
        }
        field(50001;"Ship&Debit Flag";Boolean)
        {
            Caption = 'Ship&&Debit Flag';
            Description = 'CS060';
        }
        field(50002;"One Renesas EDI";Boolean)
        {
            Description = 'CS085';
        }
        field(50003;"PC. Direct Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Description = 'CS082';
        }
        field(50004;"PC. Currency Code";Code[10])
        {
            Description = 'CS082';
        }
        field(50005;"PC. Update Price";Boolean)
        {
            Description = 'CS082';
        }
    }
}
