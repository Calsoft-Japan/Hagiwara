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
            field("Posted Purch. E-Sig."; Rec."Posted Purch. E-Sig.")
            {
                ApplicationArea = all;
            }
        }
    }
}