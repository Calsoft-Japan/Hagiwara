table 50107 "Price List Import Line"
{
    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Editable = false;
        }
        field(2; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(11; "Starting Date "; Date)
        {
        }
        field(12; "Ending Date "; Date)
        {
        }
        field(13; "Product Type"; Enum "Price Asset Type")
        {
        }
        field(14; "Product No."; Code[20])
        {
        }
        field(15; "Description"; Text[100])
        {
        }
        field(16; "Customer No."; Code[20])
        {
        }
        field(17; "Sales Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(18; "Unit Price"; Decimal)
        {
        }
        field(19; "Unit Price (LCY)"; Decimal)
        {
        }
        field(20; "Margin%"; Decimal)
        {
        }
        field(21; "Direct Unit Cost"; Decimal)
        {
        }
        field(22; "Direct Unit Cost (LCY)"; Decimal)
        {
        }
        field(23; "Purchase Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(24; "Vendor No."; Code[20])
        {
        }
        field(25; "Unit of Measure Code"; Code[10])
        {
        }
        field(26; "Minimum Quantity"; Decimal)
        {
        }
        field(27; "Defines"; Enum "Price Amount Type")
        {
        }
        field(28; "Renesas Report Unit Price Cur."; Code[10])
        {
            TableRelation = Currency;
        }
        field(29; "Renesas Report Unit Price"; Decimal)
        {
        }
        field(30; "ORE Debit Cost"; Decimal)
        {
        }
        field(31; "Ship&Debit Flag"; Boolean)
        {
        }
        field(32; "PC. Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(33; "PC. Direct Unit Cost"; Decimal)
        {
        }
        field(34; "PC. Update Price"; Boolean)
        {
        }
        field(35; "Allow Line Disc."; Boolean)
        {
        }
        field(36; "Line Discount %"; Decimal)
        {
        }
        field(37; "Allow Invoice Disc. "; Boolean)
        {
        }
        field(38; "Price Includes VAT"; Boolean)
        {
        }
        field(39; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(40; "Price Line Status"; Enum "Price Status")
        {
        }
        field(41; "Status"; Option)
        {
            OptionCaption = 'Pending,Error,Validated,Completed';
            OptionMembers = Pending,Error,Validated,Completed;
        }
        field(42; "Error Description"; Text[250])
        {
        }
        field(43; "Action"; Option)
        {
            OptionCaption = ' , Create,Update';
            OptionMembers = " ",Create,Update;
        }

    }

    keys
    {
        key(Key1; "Batch Name", "Entry No.")
        {
        }
    }
}
