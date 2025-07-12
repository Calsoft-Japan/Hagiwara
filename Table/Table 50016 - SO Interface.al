table 50016 "SO Interface"
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
        field(4; "Sell-to Customer No."; Code[20])
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
        field(7; "Requested Delivery Date"; Date)
        {
            // cleaned
        }
        field(8; "Promised Delivery Date"; Date)
        {
            // cleaned
        }
        field(9; "Posting Date"; Date)
        {
            // cleaned
        }
        field(10; "OEM No."; Code[20])
        {
            // cleaned
        }
        field(11; "External Document No."; Code[35])
        {
            Description = '//20';
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
            OptionMembers = " ",Renesas;
        }
        field(15; "Message Status(Booking)"; Option)
        {
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(16; "Message Collected By(Booking)"; Code[20])
        {
            // cleaned
        }
        field(17; "Message Collected On(Booking)"; Date)
        {
            // cleaned
        }
        field(18; "Salesperson Code"; Code[10])
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
        field(23; "Line No."; Integer)
        {
            // cleaned
        }
        field(24; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(25; "No."; Code[20])
        {
            // cleaned
        }
        field(26; "Location Code (SL)"; Code[10])
        {
            // cleaned
        }
        field(27; "Outstanding Quantity"; Decimal)
        {
            // cleaned
        }
        field(28; "Unit Price Excl. VAT"; Decimal)
        {
            // cleaned
        }
        field(29; "Shortcut Dimension 1 Code (SL)"; Code[20])
        {
            // cleaned
        }
        field(30; "Shortcut Dimension 2 Code (SL)"; Code[20])
        {
            // cleaned
        }
        field(31; "Salesperson Code (SL)"; Code[10])
        {
            // cleaned
        }
        field(32; "Requested Delivery Date (SL)"; Date)
        {
            // cleaned
        }
        field(33; "Promised Delivery Date (SL)"; Date)
        {
            // cleaned
        }
        field(34; "Planned Delivery Date"; Date)
        {
            // cleaned
        }
        field(35; "Planned Shipped Date"; Date)
        {
            // cleaned
        }
        field(36; "Customer Order No."; Text[35])
        {
            Description = '//30';
        }
        field(37; "Currency Code (SL)"; Code[10])
        {
            // cleaned
        }
        field(38; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(39; "Part No."; Code[40])
        {
            // cleaned
        }
        field(40; "OEM No. (SL)"; Code[20])
        {
            // cleaned
        }
        field(41; Products; Text[20])
        {
            // cleaned
        }
        field(42; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(43; "Next Shipment Seq. No."; Integer)
        {
            // cleaned
        }
        field(44; "Booking No. (SL)"; Code[20])
        {
            // cleaned
        }
        field(45; "No. Series"; Code[10])
        {
            // cleaned
        }
        field(46; "JA Collection Date"; Date)
        {
            // cleaned
        }
        field(47; "JC Collection Date"; Date)
        {
            // cleaned
        }
        field(48; "Message Status (JC)"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(50; "Line Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(51; "Shipment Date"; Date)
        {
            // cleaned
        }
        field(52; "Shipment Seq. No."; Integer)
        {
            // cleaned
        }
        field(60; ProcFlag; Code[1])
        {
            // cleaned
        }
        field(61; "Shipment Date (SH)"; Date)
        {
            // cleaned
        }
        field(62; "Due Date"; Date)
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
    }

    fieldgroups
    {
    }
}
