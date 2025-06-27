pageextension 50000 Pag-Ext50131.PostedSalesShpt.SubformExtExt extends "Pag-Ext50131.PostedSalesShpt.SubformExt"
{
    layout
    {
        addlast(Content)
        {
                field("Rank"; Rec."RANK") 
                {
                    ApplicationArea = all;
                }
                field("Products"; Rec."PRODUCTS") 
                {
                    ApplicationArea = all;
                }
                field("Edition"; Rec."EDITION") 
                {
                    ApplicationArea = all;
                }
                field("Insertion"; Rec."INSERTION") 
                {
                    ApplicationArea = all;
                }
                field("Correction"; Rec."CORRECTION") 
                {
                    ApplicationArea = all;
                }
        }
    }
}