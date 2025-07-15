pageextension 50119 UserSetupExt extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field("Show Incoterm Code"; Rec."Show Incoterm Code")
            {
                ApplicationArea = all;
            }
            field("Allow ITE Collect"; Rec."Allow ITE Collect")
            {
                ApplicationArea = all;
            }
            field("Allow ITE Delete"; Rec."Allow ITE Delete")
            {
                ApplicationArea = all;
            }
            field("Allow Reset ITE Collected Flag"; Rec."Allow Reset ITE Collected Flag")
            {
                ApplicationArea = all;
            }
            field("Allow ITE Update Price"; Rec."Allow ITE Update Price")
            {
                ApplicationArea = all;
            }
            field("Sales Order Post"; Rec."Sales Order Post")
            {
                ApplicationArea = all;
            }
            field("Sales Return Order Post"; Rec."Sales Return Order Post")
            {
                ApplicationArea = all;
            }
            field("Purchase Order Post"; Rec."Purchase Order Post")
            {
                ApplicationArea = all;
            }
            field("Purchase Return Order Post"; Rec."Purchase Return Order Post")
            {
                ApplicationArea = all;
            }
        }
    }
}