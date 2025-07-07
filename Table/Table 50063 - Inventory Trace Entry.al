table 50063 "Inventory Trace Entry"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Item Application Entry No."; Integer)
        {
            // cleaned
        }
        field(3; "Item Ledger Entry No."; Integer)
        {
            // cleaned
        }
        field(4; "Entry Type"; Option)
        {
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        }
        field(5; "Document Type"; Option)
        {
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        }
        field(6; "Document No."; Code[20])
        {
            // cleaned
        }
        field(7; "Document Line No."; Integer)
        {
            // cleaned
        }
        field(8; "Posting Date"; Date)
        {
            // cleaned
        }
        field(9; "Item No"; Code[20])
        {
            // cleaned
        }
        field(10; "Item Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No")));
            Editable = false;
        }
        field(11; "Customer No."; Code[20])
        {
            // cleaned
        }
        field(12; "Customer Name"; Text[50])
        {
            // cleaned
        }
        field(13; "OEM No."; Code[20])
        {
            // cleaned
        }
        field(14; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(15; "SCM Customer Code"; Code[20])
        {
            // cleaned
        }
        field(16; "Vendor No."; Code[20])
        {
            // cleaned
        }
        field(17; "Vendor Name"; Text[50])
        {
            // cleaned
        }
        field(18; "Manufacturer Code"; Code[10])
        {
            // cleaned
        }
        field(19; "Ship&Debit Flag"; Boolean)
        {
            // cleaned
        }
        field(20; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(21; "New Ship&Debit Flag"; Boolean)
        {
            // cleaned
        }
        field(22; "Remaining Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Inventory Trace Entry".Quantity WHERE("Incoming Item Ledger Entry No." = FIELD("Incoming Item Ledger Entry No."),
                                                                     "Item No" = FIELD("Item No"),
                                                                     "Location Code" = FIELD("Location Code")));
            DecimalPlaces = 0 : 5;
        }
        field(23; "Sales Returned Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Inventory Trace Entry".Quantity WHERE("Incoming Item Ledger Entry No." = FIELD("Incoming Item Ledger Entry No."),
                                                                     "Document Type" = CONST("Sales Return Receipt"),
                                                                     "Original Document No." = FIELD("Document No."),
                                                                     "Original Document Line No." = FIELD("Document Line No."),
                                                                     "Item No" = FIELD("Item No"),
                                                                     "Location Code" = FIELD("Location Code")));
            DecimalPlaces = 0 : 5;
        }
        field(24; "Sales Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Inventory Trace Entry".Quantity WHERE("Incoming Item Ledger Entry No." = FIELD("Incoming Item Ledger Entry No."),
                                                                     "Document Type" = CONST("Sales Shipment"),
                                                                     "Item No" = FIELD("Item No"),
                                                                     "Location Code" = FIELD("Location Code")));
            DecimalPlaces = 0 : 5;
        }
        field(31; "Purchase Order No."; Code[20])
        {
            // cleaned
        }
        field(32; "Purch. Item No."; Code[20])
        {
            // cleaned
        }
        field(33; "Purch. Item Vendor No."; Code[20])
        {
            // cleaned
        }
        field(34; "Purch. Item Vendor Name"; Text[50])
        {
            // cleaned
        }
        field(35; "Purch. Item Manufacturer Code"; Code[10])
        {
            // cleaned
        }
        field(36; "Purch. Hagiwara Group"; Code[10])
        {
            // cleaned
        }
        field(37; "Cost Currency"; Code[10])
        {
            // cleaned
        }
        field(38; "Direct Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(39; "New Direct Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(40; "PC. Cost Currency"; Code[10])
        {
            // cleaned
        }
        field(41; "PC. Direct Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(42; "New PC. Direct Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(43; "SLS. Purchase Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(44; "SLS. Purchase Currency"; Code[10])
        {
            // cleaned
        }
        field(45; "New Cost Currency"; Code[10])
        {
            // cleaned
        }
        field(46; "New PC. Cost Currency"; Code[10])
        {
            // cleaned
        }
        field(47; "INV. Purchase Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(48; "INV. Purchase Currency"; Code[10])
        {
            // cleaned
        }
        field(49; "PC. Entry No."; Integer)
        {
            // cleaned
        }
        field(51; "External Document No."; Code[35])
        {
            // cleaned
        }
        field(52; "Booking No."; Code[20])
        {
            // cleaned
        }
        field(53; "Shipment Seq. No."; Integer)
        {
            // cleaned
        }
        field(54; "Sales Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(55; "Sales Amount"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(56; "Sales Currency"; Code[10])
        {
            // cleaned
        }
        field(57; "Original Document No."; Code[20])
        {
            // cleaned
        }
        field(58; "Original Document Line No."; Integer)
        {
            // cleaned
        }
        field(59; "Location Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry"."Location Code" WHERE("Entry No." = FIELD("Item Ledger Entry No.")));
            Caption = 'Location Code';
        }
        field(60; "Incoming Item Ledger Entry No."; Integer)
        {
            // cleaned
        }
        field(61; "Calc. Rem. Qty."; Boolean)
        {
            InitValue = false;
        }
        field(97; "Manually Updated"; Boolean)
        {
            // cleaned
        }
        field(98; Note; Text[250])
        {
            // cleaned
        }
        field(99; Pattern; Text[10])
        {
            // cleaned
        }
    }
}
