tableextension 55700 "Stockkeeping Unit Ext" extends "Stockkeeping Unit"
{
    fields
    {
        field(50084;"Qty. on Purch. Quote";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(50085;"Qty. on Sales Quote";Decimal)
        {
            DecimalPlaces = 0:5;
        }
    }
}
