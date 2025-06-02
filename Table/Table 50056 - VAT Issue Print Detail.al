table 50056 "VAT Issue Print Detail"
{
    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(2; "Tax Invoice No."; Code[20])
        {
            // cleaned
        }
        field(3; "Document Type"; Option)
        {
            OptionCaption = 'Sales Invoice,Sales Credit Memo,Service Invoice,Service Credit Memo,Manual';
            OptionMembers = SalesInvoice,SalesCrecitMemo,ServiceInvoice,ServiceCreditMemo,Manual;
        }
        field(4; "Document No."; Code[20])
        {
            // cleaned
        }
        field(5; "Document Line No."; Integer)
        {
            // cleaned
        }
        field(6; "Line No."; Integer)
        {
            // cleaned
        }
        field(7; Quantity; Decimal)
        {
            // cleaned
        }
        field(8; "Unit of Measure Code"; Code[10])
        {
            // cleaned
        }
        field(9; "Unit Price"; Decimal)
        {
            // cleaned
        }
        field(10; "Base Amount"; Decimal)
        {
            // cleaned
        }
        field(11; "Tax Amount"; Decimal)
        {
            // cleaned
        }
        field(12; Description; Text[100])
        {
            // cleaned
        }
    }
}
