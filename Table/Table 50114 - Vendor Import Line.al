table 50114 "Vendor Import Line"
{
    fields
    {
        field(1; "Batch Name"; Code[20])
        {
            Editable = false;
        }
        field(2; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(3; "No."; Code[20])
        {
        }
        field(4; "Name"; Text[100])
        {
        }
        field(5; "Search Name"; Code[100])
        {
        }
        field(6; "Name 2"; Text[50])
        {
        }
        field(7; "Address"; Text[100])
        {
        }
        field(8; "Address 2"; Text[50])
        {
        }
        field(9; "City"; Text[30])
        {
        }
        field(10; "Contact"; Text[100])
        {
        }
        field(11; "Phone No."; Text[30])
        {
        }
        field(12; "Our Account No."; Text[20])
        {
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
        }
        field(14; "Global Dimension 2 Code"; Code[20])
        {
        }
        field(15; "Vendor Posting Group"; Code[20])
        {
        }
        field(16; "Currency Code"; Code[10])
        {
        }
        field(17; "Language Code"; Code[10])
        {
        }
        field(18; "Statistics Group"; Integer)
        {
        }
        field(19; "Payment Terms Code"; Code[10])
        {
        }
        field(20; "Fin. Charge Terms Code"; Code[10])
        {
        }
        field(21; "Purchaser Code"; Code[20])
        {
        }
        field(22; "Shipment Method Code"; Code[10])
        {
        }
        field(23; "Shipping Agent Code"; Code[10])
        {
        }
        field(24; "Invoice Disc. Code"; Code[20])
        {
        }
        field(25; "Country/Region Code"; Code[10])
        {
        }
        field(26; "Pay-to Vendor No."; Code[20])
        {
        }
        field(27; "Payment Method Code"; Code[10])
        {
        }
        field(28; "Application Method"; Option)
        {
            OptionCaption = 'Manual, Apply to Oldest';
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(29; "Prices Including VAT"; Boolean)
        {
        }
        field(30; "Fax No."; Text[30])
        {

        }
        field(31; "VAT Registration No."; Text[20])
        {
        }
        field(32; "Gen. Bus. Posting Group"; Code[20])
        {
        }
        field(33; "GLN"; Code[13])
        {
        }
        field(34; "Post Code"; Code[20])
        {
        }
        field(35; "County"; Text[30])
        {
        }
        field(36; "E-Mail"; Text[80])
        {
        }
        field(37; "Home Page"; Text[80])
        {
        }
        field(38; "No. Series"; Code[20])
        {
        }
        field(39; "Tax Area Code"; Code[20])
        {
        }
        field(40; "Tax Liable"; Boolean)
        {
        }
        field(41; "VAT Bus. Posting Group"; Code[10])
        {
        }
        field(42; "Block Payment Tolerance"; Boolean)
        {
        }
        field(43; "IC Partner Code"; Code[20])
        {
        }
        field(44; "Prepayment %"; Decimal)
        {
        }
        field(45; "Partner Type"; Option)
        {
            OptionCaption = 'Company, Person, Government';
            OptionMembers = Company,Person,Government;
        }
        field(46; "Creditor No."; Code[20])
        {
        }
        field(47; "Preferred Bank Account Code"; Code[10])
        {
        }
        field(48; "Cash Flow Payment Terms Code"; Code[10])
        {
        }
        field(49; "Primary Contact No."; Code[20])
        {
        }
        field(50; "Responsibility Center"; Code[10])
        {
        }
        field(51; "Location Code"; Code[10])
        {
        }
        field(52; "Lead Time Calculation"; DateFormula)
        {
        }
        field(53; "ID No."; Text[13])
        {
        }
        field(54; "Shipping Terms"; Text[100])
        {
        }
        field(55; "Incoterm Code"; Code[20])
        {
        }
        field(56; "Incoterm Location"; Text[50])
        {
        }
        field(57; "Manufacturer Code"; Code[10])
        {
        }
        field(58; "ORE Reverse Routing Address"; Code[40])
        {
        }
        field(59; "Excluded in ORE Collection"; Boolean)
        {
        }
        field(60; "ORE Reverse Routing Address SD"; Code[40])
        {
        }
        field(61; "Hagiwara Group"; Code[10])
        {
        }
        field(62; "Familiar Name"; Code[20])
        {
        }
        field(63; "Pay-to Address"; Text[50])
        {
        }
        field(64; "Pay-to Address 2"; Text[50])
        {
        }
        field(65; "Pay-to City"; Text[30])
        {
        }
        field(66; "Pay-to Post Code"; Code[20])
        {
        }
        field(67; "Pay-to County"; Text[30])
        {
        }
        field(68; "Pay-to Country/Region Code"; Code[10])
        {
        }
        field(69; "Exclude Check"; Boolean)
        {
        }
        field(70; "Update PO Price Target Date"; Option)
        {
            OptionCaption = 'Order Date, Expected Receipt Date';
            OptionMembers = "Order Date","Expected Receipt Date";
        }
        field(71; "IRS 1099 Code"; Code[10])
        {
        }
        field(72; "Blocked"; Option)
        {
            OptionCaption = 'Ship, Invoice, All';
            OptionMembers = Ship,Invoice,All;
        }
        field(73; "Status"; Option)
        {
            OptionCaption = 'Pending, Error, Validated, Completed';
            OptionMembers = Pending,Error,Validated,Completed;
        }
        field(74; "Error Description"; Text[250])
        {
        }
        field(75; "Action"; Option)
        {
            OptionCaption = ' , Create, Update';
            OptionMembers = " ",Create,Update;
        }
    }

    keys
    {
        key(Key1; "Batch Name", "Entry No.")
        {
        }
    }
}
