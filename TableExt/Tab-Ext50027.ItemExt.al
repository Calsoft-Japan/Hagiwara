tableextension 50027 "Item Ext" extends "Item"
{
    fields
    {
        field(50000; "Inventory L1"; Decimal)
        {
            Caption = 'Inventory L1';
            DecimalPlaces = 0 : 0;
        }
        field(50002; "Inventory L2"; Decimal)
        {
            Caption = 'Inventory L2';
            DecimalPlaces = 0 : 0;
        }
        field(50010; "Customer No."; Code[20])
        {

        }
        field(50011; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50012; "OEM No."; Code[20])
        {
            // cleaned
        }
        field(50013; Products; Text[20])
        {
            // cleaned
        }
        field(50015; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50016; Rank; Code[15])
        {
            // cleaned
        }
        field(50020; SBU; Code[10])
        {
            // cleaned
        }
        field(50084; "Qty. on Purch. Quote"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(50085; "Qty. on Sales Quote"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50086; "Purch. Order Quantity Limit"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(50087; "Qty. on P. O. (Req Rec Date)"; Decimal)
        {
            Description = 'CS013';
            Editable = false;
        }
        field(50088; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

        }
        field(50089; "Cost Amount (Actual)"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Description = '//20101009';
            Editable = false;
        }
        field(50090; "Message Collected On"; Date)
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50091; "Message Collected By"; Code[50])
        {
            Description = '//20101009 //20140715';
            Editable = false;
        }
        field(50100; "Update Date"; Date)
        {
            // cleaned
        }
        field(50101; "Update Time"; Time)
        {
            // cleaned
        }
        field(50102; "Update By"; Code[50])
        {
            Description = '//sh20140715';
        }
        field(50103; "Update Doc. No."; Code[20])
        {
            // cleaned
        }
        field(50104; "CU Last Time Modified"; Time)
        {
            Caption = 'Last Time Modified';
        }
        field(50105; "Creation Date"; Date)
        {
            // cleaned
        }
        field(50106; PKG; Code[20])
        {
            // cleaned
        }
        field(50107; "Cost Amount (Expected)"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Description = '//20111102';
        }
        field(50108; "Cost Posted to G/L"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(50109; "Inventory Shipped"; Decimal)
        {
            Caption = 'Inventory Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50110; "Inventory Receipt"; Decimal)
        {
            Caption = 'Inventory Receipt';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50111; "Inventory Neg Adj"; Decimal)
        {
            Caption = 'Inventory Neg Adj';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50112; "Inventory Pos Adj"; Decimal)
        {
            Caption = 'Inventory Pos Adj';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50113; "Qty on Sales Order (OSQ)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(50114; "Original Item No."; Code[20])
        {
            // cleaned
        }
        field(50115; "Initial Blocked"; Boolean)
        {
            // cleaned
        }
        field(50116; "Expected Receipt Date Flag"; Boolean)
        {
            // cleaned
        }
        field(50117; "Country/Region of Org Cd (FE)"; Code[10])
        {
            Caption = 'Country/Region of Origin Code (Front-end)';
            Description = 'CS016';
        }
        field(50120; Hold_L1; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(50121; Hold_L2; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(50122; Office_L; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(50125; "Inventory Shipped Not Inv"; Decimal)
        {
            Caption = 'Inventory Shipped Not Invd';
        }
        field(50126; "Shipped Not Invoiced Cost(LCY)"; Decimal)
        {
            Caption = 'Shipper Not Invoiced Cost (LCY)';
        }
        field(50130; "Service Parts"; Boolean)
        {
            Description = 'CS058';
        }
        field(50131; "Order Deadline Date"; Date)
        {
            Description = 'CS059';
        }
        field(50140; "One Renesas EDI"; Boolean)
        {
            Description = 'CS060';
        }
        field(50141; "Excluded in Inventory Report"; Boolean)
        {
            Description = 'CS098';
        }
        field(50150; "Customer Item No.(Plain)"; Code[20])
        {
            Description = 'CS080';
        }
        field(50151; "Markup%"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'CS080';
        }
        field(50152; "Markup%(Sales Price)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'CS087';
        }
        field(50153; "Markup%(Purchase Price)"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Description = 'CS087';
        }
        field(50160; "FCA In-Transit"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'CS084';
        }
        field(60000; Hold; Decimal)
        {
            Caption = 'Hold';
            DecimalPlaces = 0 : 5;
            Description = 'HG10.00.01 NJ 20/03/2017';
            Editable = false;
        }
        field(60001; EOL; Boolean)
        {
            Caption = 'EOL';
            Description = 'HG10.00.01 NJ 20/03/2017';
        }
        field(60002; Memo; Text[50])
        {
            Caption = 'Memo';
            Description = 'HG10.00.01 NJ 20/03/2017';
        }
        field(60003; "Familiar Name"; Code[20])
        {
            Caption = 'Familiar Name';
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = true;
        }
        field(60004; "Manufacturer 2 Code"; Text[50])
        {
            Caption = 'Manufacturer 2 Code';
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(60005; "Vendor Name"; Text[50])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(60006; EDI; Boolean)
        {
            Description = 'HG10.00.02 SS 15/03/2018';
        }
        field(60050; "Car Model"; Text[20])
        {
            // cleaned
        }
        field(60051; SOP; Text[15])
        {
            // cleaned
        }
        field(60052; "MP-Volume(pcs/M)"; Decimal)
        {
            // cleaned
        }
        field(60053; Apl; Text[5])
        {
            // cleaned
        }
    }
}
