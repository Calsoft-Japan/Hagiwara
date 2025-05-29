tableextension 57002 "Sales Price Ext" extends "Sales Price"
{
    fields
    {
        field(50021; "Renesas Report Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Description = 'CS089';
            MinValue = 0;
        }
        field(50022; "Renesas Report Unit Price Cur."; Code[10])
        {
            Description = 'CS089';
        }
    }
}
