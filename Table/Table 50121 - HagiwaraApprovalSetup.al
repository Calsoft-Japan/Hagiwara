table 50121 "Hagiwara Approval Setup"
{
    Caption = 'Hagiwara Approval Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Customer"; Boolean)
        {
            InitValue = false;
        }
        field(3; "Vendor"; Boolean)
        {
            InitValue = false;
        }
        field(4; "Item"; Boolean)
        {
            InitValue = false;
        }
        field(5; "G/L Account"; Boolean)
        {
            InitValue = false;
        }
        field(6; "Price List"; Boolean)
        {
            InitValue = false;
        }
        field(7; "Sales Order"; Boolean)
        {
            InitValue = false;
        }
        field(8; "Sales Return Order"; Boolean)
        {
            InitValue = false;
        }
        field(9; "Sales Credit Memo"; Boolean)
        {
            InitValue = false;
        }
        field(10; "Purchase Order"; Boolean)
        {
            InitValue = false;
        }
        field(11; "Purchase Return Order"; Boolean)
        {
            InitValue = false;
        }
        field(12; "Purchase Credit Memo"; Boolean)
        {
            InitValue = false;
        }
        field(13; "Item Journal"; Boolean)
        {
            InitValue = false;
        }
        field(14; "Item Reclass Journal"; Boolean)
        {
            InitValue = false;
        }
        field(15; "Transfer Order"; Boolean)
        {
            InitValue = false;
        }
        field(16; "Assembly Order"; Boolean)
        {
            InitValue = false;
        }


    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
