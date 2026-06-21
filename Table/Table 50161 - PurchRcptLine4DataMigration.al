table 50161 "PurchRcptLine4DataMigration"
{
    fields
    {
        field(50000; "Document No."; Code[20])
        {

        }
        field(50001; "Line No."; Integer)
        {

        }
        field(50010; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50011; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50012; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50016; "SO No."; Code[30])
        {
            // cleaned
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50500; "Receipt Seq. No."; Integer)
        {
        }
        field(50502; "CO No."; Code[6])
        {

        }
        field(50503; "Item Supplier Source"; Option)
        {
            Description = '//20110118';
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

        }
        field(50510; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;

        }
        field(50511; "Update Date"; Date)
        {
            // cleaned
        }
        field(50512; "Update Time"; Time)
        {
            // cleaned
        }
        field(50513; "Update By"; Code[50])
        {
            Description = '//20';
        }
        field(50514; "Save Posting Date"; Date)
        {
        }
        field(50515; "Next Receipt Seq. No."; Integer)
        {
            // cleaned
        }
        field(50517; "Post Shipment Collect Flag"; Integer)
        {
            // cleaned
        }
        field(50520; Insertion; Boolean)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';

        }
        field(50521; Edition; Boolean)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50522; "Original Quantity"; Decimal)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50523; "Prev Quantity"; Decimal)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50524; "Edit Count"; Integer)
        {
            Description = '//20101104 - Improve PSI Data Maintenance';
        }
        field(50525; "Receipt Collection Date"; Date)
        {
            // cleaned
        }
        field(50527; "Purchaser Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanced';
        }
        field(50617; "Country/Region of Origin Code"; Code[10])
        {
            // cleaned
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

}
