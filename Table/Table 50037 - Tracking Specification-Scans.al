table 50037 "Tracking Specification-Scans"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item;
            // cleaned
        }
        field(4; "Quantity (Base)"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(8; "Creation Date"; Date)
        {
            // cleaned
        }
        field(10; "Source Type"; Integer)
        {
            // cleaned
        }
        field(11; "Source Subtype"; Option)
        {
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            // cleaned
        }
        field(13; "Source Batch Name"; Code[10])
        {
            // cleaned
        }
        field(15; "Source Ref. No."; Integer)
        {
            // cleaned
        }
        field(29; "Qty. per Unit of Measure"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(40; "Warranty Date"; Date)
        {
            // cleaned
        }
        field(41; "Expiration Date"; Date)
        {
            // cleaned
        }
        field(100; "User ID"; Code[20])
        {
            // cleaned
        }
        field(5400; "Lot No."; Code[20])
        {

        }
        field(50000; "Scanned Item No."; Code[30])
        {

        }
        field(50001; "Scanned Rank"; Code[10])
        {

        }
        field(50002; "Total Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Tracking Specification-Scans"."Quantity (Base)" WHERE("Source ID" = FIELD("Source ID"),
                                                                                     "Source Type" = FIELD("Source Type"),
                                                                                     "Source Subtype" = FIELD("Source Subtype"),
                                                                                     "Source Batch Name" = FIELD("Source Batch Name"),
                                                                                     "Source Ref. No." = FIELD("Source Ref. No.")));
            Description = 'flow field for totals';
        }
        field(50003; "Qty Scanned"; Text[14])
        {

        }
        field(50004; "Scanned Customer Item No."; Code[40])
        {

        }
        field(50005; "2D Bar Code"; Boolean)
        {
            // cleaned
        }
        field(50006; BadItemScan; Boolean)
        {
            // cleaned
        }
        field(50007; BadRankScan; Boolean)
        {
            // cleaned
        }
        field(50008; BadCustomerItemScan; Boolean)
        {
            // cleaned
        }
    }
}
