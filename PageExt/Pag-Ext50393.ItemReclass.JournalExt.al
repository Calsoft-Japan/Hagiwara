pageextension 50393 ItemReclassJournalExt extends "Item Reclass.Journal"
{
    layout
    {
        addlast(Content)
        {
            field("Rank"; Rec."RANK")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
            field("Entry Type"; Rec."Entry Type")
            {
                ApplicationArea = all;
            }
        }
    }
}