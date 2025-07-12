table 50005 "Message Collection"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(10; "File ID"; Code[2])
        {
            // cleaned
        }
        field(20; "Department Gr Code"; Code[1])
        {
            Description = 'Now Not in Use';
        }
        field(21; "Warehouse Code"; Code[13])
        {
            Description = 'Now Not in Use';
        }
        field(30; "SCM Customer Code"; Code[13])
        {
            // cleaned
        }
        field(40; "End User Code"; Text[13])
        {
            Description = 'Now Not in Use';
        }
        field(50; "Purpose Code"; Text[3])
        {
            Description = 'Now Not in Use';
        }
        field(60; "Supplier Code"; Text[3])
        {
            Description = 'Now Not in Use';
        }
        field(70; "Parts Number"; Code[40])
        {
            // cleaned
        }
        field(71; "Inventory Class"; Code[2])
        {
            // cleaned
        }
        field(72; "CO No"; Code[6])
        {
            // cleaned
        }
        field(73; "Partial Delivery"; Code[3])
        {
            // cleaned
        }
        field(80; "Order Entry Date"; Date)
        {
            // cleaned
        }
        field(90; "Demand Date"; Date)
        {
            // cleaned
        }
        field(91; "Sales Day"; Date)
        {
            // cleaned
        }
        field(100; "Order No"; Code[20])
        {
            // cleaned
        }
        field(200; "Pos/Neg Class"; Text[1])
        {
            // cleaned
        }
        field(300; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(400; "Currency Code"; Code[3])
        {
            // cleaned
        }
        field(401; "Inventory Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(402; "Inventory Amount"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(403; "Inventory Confirmation Date"; Date)
        {
            Description = 'Now Not in Use';
        }
        field(404; "Purchase Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(405; "Purchase Amount"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(406; "Purchase Day"; Date)
        {
            // cleaned
        }
        field(500; "Sales Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Description = 'Now Not in Use';
        }
        field(600; "Sales Amount"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'Now Not in Use';
        }
        field(601; "Backlog Collection Day"; Date)
        {
            // cleaned
        }
        field(602; "Allocated Inv. Class"; Text[1])
        {
            // cleaned
        }
        field(700; "SOLDTO Customer"; Code[20])
        {
            Description = 'Now Not in Use';
        }
        field(800; "SOLDTO Customer2"; Code[20])
        {
            Description = 'Now Not in Use';
        }
        field(900; Comment; Text[30])
        {
            Description = 'Now Not in Use';
        }
        field(901; "Sequence Number"; Code[3])
        {
            // cleaned
        }
        field(1000; Preliminaries; Text[118])
        {
            // cleaned
        }
        field(50000; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready,Cancelled,Sent,Cancelled(After Sent)';
            OptionMembers = " ",Ready,Cancelled,Sent,"Cancelled(After Sent)";
        }
        field(50001; "Source Document No."; Code[20])
        {
            Description = 'NAV Document No';
            Editable = false;
        }
        field(50002; "Source Document Line No."; Integer)
        {
            Description = 'NAV Document Line No';
            Editable = false;
        }
        field(50010; "Collected By"; Code[50])
        {
            Description = '//Sh Extend Length from 20 to 50';
            Editable = false;
        }
        field(50011; "Collected On"; Date)
        {
            Editable = true;
        }
        field(50012; "Cancelled By"; Code[50])
        {
            Description = '//Sh Extend Length from 20 to 50';
            Editable = false;
        }
        field(50013; "Cancelled On"; Date)
        {
            Editable = false;
        }
        field(50020; "File Sent By"; Code[50])
        {
            Description = 'To keep info while creating file //Sh Extend Length from 20 to 50';
            Editable = false;
        }
        field(50021; "File Sent On"; Date)
        {
            Description = 'To keep info while creating file';
            Editable = false;
        }
        field(50022; "Item No."; Code[20])
        {
            Editable = false;
        }
        field(50023; "Update Date"; Date)
        {
            // cleaned
        }
        field(50024; "Update Time"; Time)
        {
            // cleaned
        }
        field(50025; "SO Document Category"; Text[1])
        {
            // cleaned
        }
        field(50026; "SCM Process Code"; Code[2])
        {
            // cleaned
        }
        field(50027; "Agent Internal Key"; Text[40])
        {
            // cleaned
        }
        field(50028; "Shipping Instruction Div"; Code[1])
        {
            Description = 'Now Not in Use';
        }
        field(50029; "Prefix Seq No."; Text[17])
        {
            Description = 'Always Blank';
        }
        field(50030; "Cost Amount (Expected)"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(50031; "Unit Cost"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(50032; "Cost Amount (Actual)"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(50033; "Cost Posted to G/L"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(50034; "Advance Shipped Qty"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50035; "Backlog Qty Incl. Adv Shipment"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50037; "Backlog Qty Excl. Adv Shipment"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(50038; "Booking No."; Code[20])
        {
            // cleaned
        }
        field(50039; "Computed Inventory Amount"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(50040; "Advance Receipt Qty"; Decimal)
        {
            // cleaned
        }
        field(50041; "Item Description"; Text[40])
        {
            // cleaned
        }
        field(50042; Backup; Code[1])
        {
            Description = '//0 = Not backup yet ; 1 =-  Backup already';
        }
        field(50043; "Markup %"; Decimal)
        {
            // cleaned
        }
        field(50044; "Added Value"; Decimal)
        {
            // cleaned
        }
        field(50045; "Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "File ID")
        {
        }
        key(Key2; "Parts Number")
        {
        }
        key(Key3; "Item Description")
        {
        }
        key(Key4; "Collected On", "File ID")
        {
        }
        key(Key5; "Collected On")
        {
        }
    }

    fieldgroups
    {
    }
}
