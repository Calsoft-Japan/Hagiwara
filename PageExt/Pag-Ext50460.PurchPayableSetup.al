pageextension 50460 PurchPayableSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Create Renesas PO Status"; Rec."Create Renesas PO Status")
            {
                ApplicationArea = all;
            }
            field("Update Renesas PO Status"; Rec."Update Renesas PO Status")
            {
                ApplicationArea = all;
            }
            field("Create Renesas PO Error Code"; Rec."Create Renesas PO Error Code")
            {
                ApplicationArea = all;
            }
            field("Update Renesas PO Error Code"; Rec."Update Renesas PO Error Code")
            {
                ApplicationArea = all;
            }
            field("Posted Sales E-Sig."; Rec."Posted Sales E-Sig.")
            {
                ApplicationArea = all;
                Visible = false; //TODO TBD
            }
        }
    }
}