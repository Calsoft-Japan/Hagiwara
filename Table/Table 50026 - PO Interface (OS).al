table 50026 "PO Interface (OS)"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(2; "Document Type"; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            // cleaned
        }
        field(4; "Buy-From Vendor No."; Code[20])
        {
            // cleaned
        }
        field(5; "Order Date"; Date)
        {
            // cleaned
        }
        field(6; "Document Date"; Date)
        {
            // cleaned
        }
        field(7; "Requested Receipt Date"; Date)
        {
            // cleaned
        }
        field(8; "Promised Receipt Date"; Date)
        {
            // cleaned
        }
        field(9; "Posting Date"; Date)
        {
            // cleaned
        }
        field(10; "Expected Receipt Date"; Date)
        {
            // cleaned
        }
        field(12; "Vendor Customer Code"; Code[13])
        {
            // cleaned
        }
        field(13; "Location Code"; Code[10])
        {
            // cleaned
        }
        field(14; "Item Supplier Source"; Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(15; "Quote No."; Code[20])
        {
            // cleaned
        }
        field(16; "Vendor Order No."; Code[20])
        {
            // cleaned
        }
        field(17; "Vendor Shipment No."; Code[20])
        {
            // cleaned
        }
        field(18; "Purchaser Code"; Code[10])
        {
            // cleaned
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
        {
            // cleaned
        }
        field(20; "Shortcut Dimension 2 Code"; Code[20])
        {
            // cleaned
        }
        field(21; "Currency Code"; Code[10])
        {
            // cleaned
        }
        field(22; "Currency Factor"; Decimal)
        {
            // cleaned
        }
        field(23; "Sell-to Customer No."; Code[20])
        {
            // cleaned
        }
        field(24; "Line No."; Integer)
        {
            // cleaned
        }
        field(25; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(26; "No."; Code[20])
        {
            // cleaned
        }
        field(27; "Buy-From Vendor No. (PL)"; Code[20])
        {
            // cleaned
        }
        field(28; "Unit of Measure Code"; Code[10])
        {
            // cleaned
        }
        field(29; "Unit of Measure"; Code[10])
        {
            // cleaned
        }
        field(30; "Location Code (PL)"; Code[10])
        {
            // cleaned
        }
        field(31; "Direct Unit Cost"; Decimal)
        {
            DecimalPlaces = 2 : 4;
        }
        field(32; "Outstanding Quantity"; Decimal)
        {
            // cleaned
        }
        field(33; "Unit Cost"; Decimal)
        {
            // cleaned
        }
        field(34; "Line Amount"; Decimal)
        {
            // cleaned
        }
        field(35; "Purchaser Code (PL)"; Code[10])
        {
            // cleaned
        }
        field(36; "Shortcut Dimension 1 Code (PL)"; Code[20])
        {
            // cleaned
        }
        field(37; "Shortcut Dimension 2 Code (PL)"; Code[20])
        {
            // cleaned
        }
        field(38; "Requested Receipt Date (PL)"; Date)
        {
            // cleaned
        }
        field(39; "Promised Receipt Date (PL)"; Date)
        {
            // cleaned
        }
        field(40; "Planned Receipt Date (PL)"; Date)
        {
            // cleaned
        }
        field(41; "Expected Receipt Date (PL)"; Date)
        {
            // cleaned
        }
        field(42; "Currency Code (PL)"; Code[10])
        {
            // cleaned
        }
        field(43; "Parts No."; Code[40])
        {
            // cleaned
        }
        field(44; Products; Text[20])
        {
            // cleaned
        }
        field(45; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(46; Rank; Code[15])
        {
            // cleaned
        }
        field(47; "CO No."; Code[6])
        {
            // cleaned
        }
        field(48; "SO No."; Code[20])
        {
            // cleaned
        }
        field(49; "Receipt Seq. No."; Integer)
        {
            // cleaned
        }
        field(50; "Next Receipt Seq. No."; Integer)
        {
            // cleaned
        }
        field(51; "Item Supplier Source (PL)"; Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(55; ProcFlag; Code[1])
        {
            // cleaned
        }
        field(56; "Due Date"; Date)
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Document No.", "Entry No.")
        {
        }
        key(Key3; "Document No.", "Document Date", "Buy-From Vendor No.", "Sell-to Customer No.", "Currency Code")
        {
        }
    }

    fieldgroups
    {
    }
}
