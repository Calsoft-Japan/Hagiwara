table 50121 "Hagiwara Approval Setup"
{
    Caption = 'Hagiwara Approval Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(11; "Customer"; Boolean)
        {
            InitValue = false;
        }
        field(12; "Vendor"; Boolean)
        {
            InitValue = false;
        }
        field(13; "Item"; Boolean)
        {
            InitValue = false;
        }
        field(14; "G/L Account"; Boolean)
        {
            InitValue = false;
        }
        field(15; "Price List"; Boolean)
        {
            InitValue = false;
        }
        field(16; "Sales Order"; Boolean)
        {
            InitValue = false;
        }
        field(17; "Sales Return Order"; Boolean)
        {
            InitValue = false;
        }
        field(18; "Sales Credit Memo"; Boolean)
        {
            InitValue = false;
        }
        field(19; "Purchase Order"; Boolean)
        {
            InitValue = false;
        }
        field(20; "Purchase Return Order"; Boolean)
        {
            InitValue = false;
        }
        field(21; "Purchase Credit Memo"; Boolean)
        {
            InitValue = false;
        }
        field(22; "Item Journal"; Boolean)
        {
            InitValue = false;
        }
        field(23; "Item Reclass Journal"; Boolean)
        {
            InitValue = false;
        }
        field(24; "Transfer Order"; Boolean)
        {
            InitValue = false;
        }
        field(25; "Assembly Order"; Boolean)
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
