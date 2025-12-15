//CS092 2025/11/25 Channing.Zhou N014 Customer Import Line
table 50120 "Customer Import Line"
{
    fields
    {
        field(1; "Batch Name"; Code[20])
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; "No."; Code[20])
        {
        }
        field(4; Name; Text[100])
        {
        }
        field(5; "Search Name"; Code[100])
        {
        }
        field(6; "Name 2"; Text[50])
        {
        }
        field(7; Address; Text[100])
        {
        }
        field(8; "Address 2"; Text[50])
        {
        }
        field(9; City; Text[30])
        {
        }
        field(10; Contact; Text[100])
        {
        }
        field(11; "Phone No."; Text[30])
        {
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
        }
        field(14; "Customer Posting Group"; Code[20])
        {
        }
        field(15; "Currency Code"; Code[10])
        {
        }
        field(16; "Customer Price Group"; Code[10])
        {
        }
        field(17; "Language Code"; Code[10])
        {
        }
        field(18; "Payment Terms Code"; Code[10])
        {
        }
        field(19; "Fin. Charge Terms Code"; Code[10])
        {
        }
        field(20; "Salesperson Code"; Code[20])
        {
        }
        field(21; "Shipment Method Code"; Code[10])
        {
        }
        field(22; "Shipping Agent Code"; Code[10])
        {
        }
        field(23; "Invoice Disc. Code"; Code[20])
        {
        }
        field(24; "Country/Region Code"; Code[10])
        {
        }
        field(25; "Collection Method"; Code[20])
        {
        }
        field(26; "Print Statements"; Boolean)
        {
        }
        field(27; "Bill-to Customer No."; Code[20])
        {
        }
        field(28; "Payment Method Code"; Code[10])
        {
        }
        field(29; "Application Method"; Option)
        {
            OptionCaption = ',Manual, Apply to Oldest';
            OptionMembers = " ",Manual,"Apply to Oldest";
        }
        field(30; "Prices Including VAT"; Boolean)
        {
        }
        field(31; "Location Code"; Code[10])
        {
        }
        field(32; "Fax No."; Text[30])
        {
        }
        field(33; "VAT Registration No."; Text[20])
        {
        }
        field(34; "Combine Shipments"; Boolean)
        {
        }
        field(35; "Gen. Bus. Posting Group"; Code[20])
        {
        }
        field(36; GLN; Code[13])
        {
        }
        field(37; "Post Code"; Code[20])
        {
        }
        field(38; County; Text[30])
        {
        }
        field(39; "E-Mail"; Text[80])
        {
        }
        field(40; "Home Page"; Text[80])
        {
        }
        field(41; "Reminder Terms Code"; Code[10])
        {
        }
        field(42; "No. Series"; Code[20])
        {
        }
        field(43; "Tax Area Code"; Code[20])
        {
        }
        field(44; "Tax Liable"; Boolean)
        {
        }
        field(45; "VAT Bus. Posting Group"; Code[20])
        {
        }
        field(46; Reserve; Option)
        {
            OptionCaption = 'Never, Optional, Always';
            OptionMembers = Never,Optional,Always;
        }
        field(47; "Block Payment Tolerance"; Boolean)
        {
        }
        field(48; "IC Partner Code"; Code[20])
        {
        }
        field(49; "Prepayment %"; Decimal)
        {
        }
        field(50; "Partner Type"; Option)
        {
            OptionCaption = ' ,Company, Person, Government';
            OptionMembers = " ",Company,Person,Government;
        }
        field(51; "Preferred Bank Account Code"; Code[20])
        {
        }
        field(52; "Cash Flow Payment Terms Code"; Code[10])
        {
        }
        field(53; "Primary Contact No."; Code[20])
        {
        }
        field(54; "Responsibility Center"; Code[10])
        {
        }
        field(55; "Shipping Advice"; Option)
        {
            OptionCaption = ',Partial, Complete';
            OptionMembers = " ",Partial,Complete;
        }
        field(56; "Shipping Time"; DateFormula)
        {
        }
        field(57; "Shipping Agent Service Code"; Code[10])
        {
        }
        field(58; "Service Zone Code"; Code[10])
        {
        }
        field(59; "Contract Gain/Loss Amount"; Decimal)
        {
        }
        field(60; "Allow Line Disc."; Boolean)
        {
        }
        field(61; "Copy Sell-to Addr. to Qte From"; Option)
        {
            OptionCaption = ',Company, Person';
            OptionMembers = " ",Company,Person;
        }
        field(62; "Customer Type"; Option)
        {
            OptionCaption = ',Standard, OEM, Trading';
            OptionMembers = " ",Standard,OEM,Trading;
        }
        field(63; "NEC OEM Code"; Code[10])
        {
        }
        field(64; "NEC OEM Name"; Text[50])
        {
        }
        field(65; "Shipping Mark1"; Text[50])
        {
        }
        field(66; "Shipping Mark2"; Text[50])
        {
        }
        field(67; "Shipping Mark3"; Text[50])
        {
        }
        field(68; "Shipping Mark4"; Text[50])
        {
        }
        field(69; "Shipping Mark5"; Text[50])
        {
        }
        field(70; Remarks1; Text[50])
        {
        }
        field(71; Remarks2; Text[50])
        {
        }
        field(72; Remarks3; Text[50])
        {
        }
        field(73; Remarks4; Text[50])
        {
        }
        field(74; Remarks5; Text[50])
        {
        }
        field(75; "Item Supplier Source"; Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(76; "Vendor Cust. Code"; Code[13])
        {
        }
        field(77; "Ship From Name"; Text[50])
        {
        }
        field(78; "Ship From Address"; Text[50])
        {
        }
        field(79; HQType; Text[30])
        {
        }
        field(80; "Default Country/Region of Org"; Option)
        {
            OptionCaption = ' ,Back-end, Front-end';
            OptionMembers = " ","Back-end","Front-end";
        }
        field(81; "Price Update Target Date"; Option)
        {
            OptionCaption = ' ,Order Date, Shipment Date';
            OptionMembers = " ","Order Date","Shipment Date";
        }
        field(82; "ORE Customer Name"; Text[35])
        {
        }
        field(83; "ORE Address"; Text[35])
        {
        }
        field(84; "ORE Address 2"; Text[35])
        {
        }
        field(85; "ORE City"; Text[35])
        {
        }
        field(86; "ORE State/Province"; Text[9])
        {
        }
        field(87; "Excluded in ORE Collection"; Boolean)
        {
        }
        field(88; "ORE Country"; Code[3])
        {
        }
        field(89; "ORE Post Code"; Code[20])
        {
        }
        field(90; "Customer Group"; Text[30])
        {
        }
        field(91; "Familiar Name"; Code[20])
        {
        }
        field(92; "Import File Ship To"; Code[20])
        {
        }
        field(93; "Receiving Location"; Code[10])
        {
        }
        field(94; "Days for Auto Inv. Reservation"; Integer)
        {
        }
        field(95; Blocked; Option)
        {
            OptionCaption = ' , Ship, Invoice, All';
            OptionMembers = " ",Ship,Invoice,All;
        }
        field(96; Status; Option)
        {
            OptionCaption = 'Pending, Error, Validated, Completed';
            OptionMembers = Pending,Error,Validated,Completed;
        }
        field(97; "Error Description"; Text[250])
        {

        }
        field(98; "Action"; Option)
        {
            OptionCaption = ' , Create, Update';
            OptionMembers = " ",Create,Update;
        }
    }
    keys
    {
        key(Key1; "Batch Name", "Entry No.")
        {
            Clustered = true;
        }
    }
}
