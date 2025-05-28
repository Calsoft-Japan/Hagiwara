tableextension 50037 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "Vendor Item Number"; Text[40])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50010; "Customer Order No."; Text[35])
        {
            Description = '//30';
        }
        field(50011; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50012; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50013; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50020; "OEM No."; Code[20])
        {

        }
        field(50021; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50500; "Shipment Seq. No."; Integer)
        {
            Editable = true;
        }
        field(50501; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = true;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

        }
        field(50502; "Post Shipment Collect Flag"; Integer)
        {
            // cleaned
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
        field(50514; "Next Shipment Seq. No."; Integer)
        {
            Editable = true;
        }
        field(50515; "Save Customer Order No."; Text[35])
        {
            Description = '//30//';
            Editable = false;
        }
        field(50516; "Save Posting Date"; Date)
        {
            // cleaned
        }
        field(50517; "Serial No."; Integer)
        {
            BlankZero = true;
        }
        field(50518; "Booking No."; Code[20])
        {
            Editable = true;

        }
        field(50519; "No. Series"; Code[10])
        {
            // cleaned
        }
        field(50520; "Shipped Quantity"; Decimal)
        {
            // cleaned
        }
        field(50521; "Date Filter"; Date)
        {
            // cleaned
        }
        field(50522; "JC Collection Date"; Date)
        {
            // cleaned
        }
        field(50523; "Outstanding Quantity (Actual)"; Decimal)
        {
            // cleaned
        }
        field(50524; "Actual Customer No."; Code[20])
        {
            // cleaned
        }
        field(50525; "Vendor Cust. Code"; Code[13])
        {
            // cleaned
        }
        field(50526; "PSI Process Date"; Date)
        {
            Description = '//20121103 SiakHui - use for combining 2 PSI Init jobs to 1 job enhancement';
        }
        field(50527; "Qty to Ship (2nd UOM)"; Decimal)
        {
            Caption = 'Qty tp Ship (2nd UOM)';
            DecimalPlaces = 0 : 0;
        }
        field(50528; Remarks; Text[30])
        {
            Caption = 'Remarks';
        }
        field(50535; "JA Collection Date"; Date)
        {
            // cleaned
        }
        field(50537; Revised; Code[1])
        {
            Description = '//20121114 SiakHui - use for revising JC PSI';
        }
        field(50538; "Message Status (JC)"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(50539; "Salesperson Code"; Code[10])
        {
            // cleaned
        }
        field(50540; "Original Doc. No."; Code[20])
        {
            Description = '//20121215 Siakhui 0 used to store FIFO SO / SQ No.';
        }
        field(50541; Blocked; Boolean)
        {
            // cleaned
        }
        field(50542; "Original Booking No."; Code[20])
        {
            // cleaned
        }
        field(50543; "Original Line No."; Integer)
        {
            // cleaned
        }
        field(50544; "Promised Delivery Date_1"; Date)
        {
            // cleaned
        }
        field(50545; "Requested Delivery Date_1"; Date)
        {
            // cleaned
        }
        field(50546; "EDI_Lineshipment Date"; Date)
        {
            // cleaned
        }
        field(50547; "Fully Reserved"; Boolean)
        {
            Description = 'CS018';
            Editable = false;
            NotBlank = true;
        }
        field(50548; "Manufacturer Code"; Code[10])
        {
            Description = 'CS033';
        }
        field(50550; "Line Amount to ship"; Decimal)
        {
            Caption = 'Line Amount to ship';
            Description = 'SKHE20121220';
            Editable = true;

        }
        field(50551; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            Description = 'SKHE20140210';
            Editable = false;
        }
        field(50564; "Shipped Not Invoiced Cost(LCY)"; Decimal)
        {
            Caption = 'Shipper Not Invoiced Cost (LCY)';
            Description = '50524';
            Editable = false;
        }
        field(50565; "2nd Unit of Measure Code"; Code[10])
        {
            Caption = '2nd Unit of Measure';

        }
        field(50566; "2nd Unit of Measure"; Text[10])
        {
            Editable = false;
        }
    }
}
