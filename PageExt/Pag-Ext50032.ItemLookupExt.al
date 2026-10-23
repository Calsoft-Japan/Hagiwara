pageextension 50032 ItemLookupExt extends "Item Lookup"
{

    layout
    {
        addafter(Description)
        {
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
