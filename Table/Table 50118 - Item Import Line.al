table 50118 "Item Import Line"
{
    fields
    {
        field(1; "Batch Name"; Code[20])
        {

        }
        field(2; "Entry No."; Integer)
        {

        }
        field(3; "Type"; Option)
        {
            OptionCaption = 'Inventory, Service, Non-Inventory';
            OptionMembers = Inventory,Service,"Non-Inventory";
        }
        field(4; "Item No."; Code[20])
        {

        }
        field(5; "Familiar Name"; Code[20])
        {

        }
        field(6; "Description"; Code[20])
        {

        }
        field(7; "Description 2"; Text[50])
        {

        }
        field(8; "Base Unit of Measure"; Code[10])
        {

        }
        field(9; "Sales Unit of Measure"; Code[10])
        {

        }
        field(10; "Purchase Unit of Measure"; Code[10])
        {

        }
        field(11; "Price/Profit Calculation"; Option)
        {
            OptionCaption = 'Profit=Price-Cost, Price=Cost+Profit, No Relationship';
            OptionMembers = "Profit=Price-Cost","Price=Cost+Profit","No Relationship";
        }
        field(12; "Lead Time Calculation"; DateFormula)
        {

        }
        field(13; "Tariff No."; Code[20])
        {

        }
        field(14; "Reserve"; Enum "Reserve Method")
        {
        }
        field(15; "Stockout Warning"; Option)
        {
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(16; "Prevent Negative Inventory"; Option)
        {
            OptionCaption = 'Default,No,Yes';
            OptionMembers = Default,No,Yes;
        }
        field(17; "Replenishment System"; Enum "Replenishment System")
        {
        }
        field(18; "Item Tracking Code"; Code[10])
        {

        }
        field(19; "Manufacture Code"; Code[10])
        {

        }
        field(20; "Item Category Code"; Code[20])
        {

        }
        field(21; "Original Item No."; Code[20])
        {

        }
        field(22; "Country/Region of Origin Code"; Code[10])
        {

        }
        field(23; "Country/Region of Org Cd (FE)"; Code[10])
        {

        }
        field(24; "Product Group Code"; Code[10])
        {

        }
        field(25; "Products"; Text[20])
        {

        }
        field(26; "Parts No."; Code[40])
        {

        }
        field(27; "PKG"; Code[20])
        {

        }
        field(28; "Rank"; Code[15])
        {

        }
        field(29; "SBU"; Code[10])
        {

        }
        field(30; "Car Model"; Text[20])
        {

        }
        field(31; "SOP"; Text[15])
        {

        }
        field(32; "MP-Volume(pcs/M)"; Decimal)
        {

        }
        field(33; "Apl"; Text[5])
        {

        }
        field(34; "Service Parts"; Boolean)
        {

        }
        field(35; "Order Deadline Date"; Date)
        {

        }
        field(36; "EOL"; Boolean)
        {

        }
        field(37; "Memo"; Text[50])
        {

        }
        field(38; "EDI"; Boolean)
        {

        }
        field(39; "Customer No."; Code[20])
        {

        }
        field(40; "Customer Item No."; Code[20])
        {

        }
        field(41; "Customer Item No. (Plain)"; Code[20])
        {

        }
        field(42; "OEM No."; Code[20])
        {

        }
        field(43; "Vendor No."; Code[20])
        {

        }
        field(44; "Item Supplier Source"; Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(45; "Vendor Item No."; Text[50])
        {

        }
        field(46; "Lot Size"; Decimal)
        {

        }
        field(47; "Minimum Order Quantity"; Decimal)
        {

        }
        field(48; "Order Multiple"; Decimal)
        {

        }
        field(49; "Maximum Order Quantity"; Decimal)
        {

        }
        field(50; "Markup%"; Decimal)
        {

        }
        field(51; "Markup%(Sales Price)"; Decimal)
        {

        }
        field(52; "Markup%(Purchase Price)"; Decimal)
        {

        }
        field(53; "One Renesas EDI"; Boolean)
        {

        }
        field(54; "Excluded in Inventory Report"; Boolean)
        {

        }
        field(55; "Gen. Prod. Posting Group"; Code[20])
        {

        }
        field(56; "Inventory Posting Group"; Code[20])
        {

        }
        field(57; "VAT Prod. Posting Group"; Code[20])
        {

        }
        field(58; "Customer Group Code"; Code[20])
        {

        }
        field(59; "Base Currency Code"; Code[20])
        {

        }
        field(60; "Blocked"; Boolean)
        {

        }
        field(61; "Status"; Option)
        {
            OptionCaption = 'Pending, Error, Validated, Completed';
            OptionMembers = Pending,Error,Validated,Completed;
        }
        field(62; "Error Description"; Text[250])
        {

        }
        field(63; "Action"; Option)
        {
            OptionCaption = ', Create, Update';
            OptionMembers = "",Create,Update;
        }
    }

    keys
    {
        key(Key1; "Batch Name")
        {
        }
        key(Key2; "Entry No.")
        {
        }
    }
}
