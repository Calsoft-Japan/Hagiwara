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
        field(26; "Item Import Batch Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(27; "Customer Import Batch Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(28; "Vendor Import Batch Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(29; "Price List Import Batch Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(30; "Environment URL"; Text[200])
        {
            ToolTip = 'The Environment URL for On-Premise server. Format: http://servername:portname/BCInstanceName/. e.g. http://52.175.19.235:8080/HSUpgrade/';
        }

        field(51; "Inprogress Item"; Boolean)
        {

        }
        field(52; "Inprogress Customer"; Boolean)
        {

        }
        field(53; "Inprogress Vendor"; Boolean)
        {

        }
        field(54; "Inprogress Price List"; Boolean)
        {

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
