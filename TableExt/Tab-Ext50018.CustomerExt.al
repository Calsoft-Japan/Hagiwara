tableextension 50018 "Customer Ext" extends "Customer"
{
    fields
    {
        field(50010; "Customer Type"; Option)
        {
            OptionMembers = Standard,OEM,Trading;

        }
        field(50011; "NEC OEM Code"; Code[10])
        {

        }
        field(50012; "NEC OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50020; "Shipping Mark1"; Text[50])
        {
            // cleaned
        }
        field(50021; "Shipping Mark2"; Text[50])
        {
            // cleaned
        }
        field(50022; "Shipping Mark3"; Text[50])
        {
            // cleaned
        }
        field(50023; "Shipping Mark4"; Text[50])
        {
            // cleaned
        }
        field(50024; "Shipping Mark5"; Text[50])
        {
            // cleaned
        }
        field(50025; Remarks1; Text[50])
        {
            // cleaned
        }
        field(50026; Remarks2; Text[50])
        {
            // cleaned
        }
        field(50027; Remarks3; Text[50])
        {
            // cleaned
        }
        field(50028; Remarks4; Text[50])
        {
            // cleaned
        }
        field(50029; Remarks5; Text[50])
        {
            // cleaned
        }
        field(50030; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50031; "Vendor Cust. Code"; Code[13])
        {
            Description = '//20101009';
        }
        field(50032; "Ship From Name"; Text[50])
        {
            // cleaned
        }
        field(50033; "Ship From Address"; Text[50])
        {
            // cleaned
        }
        field(50034; HQType; Text[30])
        {
            // cleaned
        }
        field(50035; "Default Country/Region of Org"; Option)
        {
            Caption = 'Default Country/Region of Origin';
            Description = 'CS016';
            OptionMembers = " ","Front-end","Back-end";
        }
        field(50049; "Update SO Price Target Date"; Option)
        {
            Caption = 'Price Update Target Date';
            OptionMembers = "Order Date","Shipment Date";
        }
        field(50050; "ORE Customer Name"; Text[35])
        {
            Description = 'CS060';
        }
        field(50051; "ORE Address"; Text[35])
        {
            Description = 'CS060';
        }
        field(50052; "ORE Address 2"; Text[35])
        {
            Description = 'CS060';
        }
        field(50053; "ORE City"; Text[35])
        {
            Description = 'CS060';
        }
        field(50054; "ORE State/Province"; Text[9])
        {
            Caption = 'ORE State/Province';
            Description = 'CS060,CS089';
        }
        field(50055; "Excluded in ORE Collection"; Boolean)
        {
            Description = 'CS060';
        }
        field(50056; "ORE Country"; Code[3])
        {
            Description = 'CS089';
        }
        field(50057; "ORE Post Code"; Code[20])
        {
            Description = 'CS097';
        }
        field(60000; "Customer Group"; Text[30])
        {
            Caption = 'Customer Group';
            Description = 'HG10.00.01 NJ 20/03/2017';
        }
        field(60001; "Familiar Name"; Code[20])
        {
            Caption = 'Familiar Name';
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = true;
        }
        field(60002; "Import File Ship To"; Code[20])
        {
            Description = 'HG10.00.03 NJ 26/12/2017';
        }
        field(60003; "Receiving Location"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(FALSE));
            Caption = 'Receiving Location';
            Description = 'CS006';
        }
        field(60004; "Days for Auto Inv. Reservation"; Integer)
        {
            Description = 'CS018';
            MaxValue = 999;
            MinValue = 0;
        }
    }
}
