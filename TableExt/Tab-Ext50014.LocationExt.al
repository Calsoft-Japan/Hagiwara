tableextension 50014 "Location Ext" extends "Location"
{
    fields
    {
        field(50000; "Vat Registration No."; Text[50])
        {
            Caption = 'VAT Registration No.';
            Description = 'BBN.01';
        }
        field(50001; "Fiscal Representative"; Text[250])
        {
            Description = 'CS038';
        }
        field(59001; Attention1; Text[20])
        {
            // cleaned
        }
        field(59002; Attention2; Text[20])
        {
            // cleaned
        }
        field(59003; CC; Text[20])
        {
            // cleaned
        }
        field(59004; "Use As FCA In-Transit"; Boolean)
        {
            Description = 'CS084';
        }
    }
}
