table 50042 "Purchase Price Worksheet"
{
    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item;
            Caption = 'Item No.';
            NotBlank = true;
        }
        field(2; "Sales Code"; Code[20])
        {
            TableRelation = IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group"
            ELSE IF ("Sales Type" = CONST(Customer)) Customer
            ELSE IF ("Sales Type" = CONST(Campaign)) Campaign;
            Caption = 'Sales Code';
        }
        field(3; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
            Caption = 'Currency Code';
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

        }
        field(5; "Current Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Current Unit Price';
            Editable = false;
            MinValue = 0;
        }
        field(6; "New Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'New Unit Price';
            MinValue = 0;
        }
        field(7; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(10; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11; "VAT Bus. Posting Gr. (Price)"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
            Caption = 'VAT Bus. Posting Gr. (Price)';
        }
        field(13; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;

        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;

        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

        }
        field(20; "Item Description"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
        }
        field(21; "Sales Description"; Text[50])
        {
            Caption = 'Sales Description';
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            Caption = 'Unit of Measure Code';
        }
        field(5700; "Variant Code"; Code[10])
        {
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
            Caption = 'Variant Code';
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
    }
}
