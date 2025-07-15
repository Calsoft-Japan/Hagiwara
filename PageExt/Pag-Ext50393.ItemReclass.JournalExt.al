pageextension 50393 ItemReclassJournalExt extends "Item Reclass. Journal"
{
    layout
    {
        addafter("Document No.")
        {

            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Item No.")
        {
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Rank"; Rec."RANK")
            {
                ApplicationArea = all;
            }
            field("Parts No."; Rec."Parts No.")
            {
                ApplicationArea = all;
            }
        }
    }
}