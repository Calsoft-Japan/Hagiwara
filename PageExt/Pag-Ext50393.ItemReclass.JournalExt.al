pageextension 50000 Pag-Ext50393.ItemReclass.JournalExtExt extends "Pag-Ext50393.ItemReclass.JournalExt"
{
    layout
    {
        addlast(Content)
        {
                field("Rank"; Rec."RANK") 
                {
                    ApplicationArea = all;
                }
        }
    }
}