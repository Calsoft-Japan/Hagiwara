pageextension 50653 "InterComSetupExt" extends "Intercompany Setup"
{

    layout
    {
        addafter("IC Inbox Details")
        {
            field("IC Transaction Approver"; Rec."IC Transaction Approver")
            {
                ApplicationArea = all;
            }

        }
    }
}
