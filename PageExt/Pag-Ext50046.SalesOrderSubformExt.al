pageextension 50000 Pag-Ext50046.SalesOrderSubformExtExt extends "Pag-Ext50046.SalesOrderSubformExt"
{
    layout
    {
        addlast(Content)
        {
                field("Products"; Rec."PRODUCTS") 
                {
                    ApplicationArea = all;
                }
                field("Blocked"; Rec."BLOCKED") 
                {
                    ApplicationArea = all;
                }
                field("Rank"; Rec."RANK") 
                {
                    ApplicationArea = all;
                }
        }
    }
}