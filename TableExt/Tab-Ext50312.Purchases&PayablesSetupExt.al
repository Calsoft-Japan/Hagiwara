tableextension 50312 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50001; "Purch. Inv. Interface Vendor"; Code[20])
        {
            // cleaned
        }
        field(50002; "Create Renesas PO Status"; Code[1])
        {
            // cleaned
        }
        field(50003; "Update Renesas PO Status"; Code[1])
        {
            // cleaned
        }
        field(50004; "Create Renesas PO Error Code"; Code[1])
        {
            // cleaned
        }
        field(50005; "Update Renesas PO Error Code"; Code[1])
        {
            // cleaned
        }
        field(50006; "Maintain Release No."; Boolean)
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }

        /*Only for Sales & Receiable Setup
        field(50007; "Posted Sales E-Sig."; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        */
    }
}
