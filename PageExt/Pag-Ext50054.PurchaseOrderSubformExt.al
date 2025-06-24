pageextension 50000 Pag-Ext50054.PurchaseOrderSubformExtExt extends "Pag-Ext50054.PurchaseOrderSubformExt"
{
    layout
    {
        addlast(Content)
        {
                field("Blocked"; Rec."BLOCKED") 
                {
                    ApplicationArea = all;
                }
                field("Products"; Rec."PRODUCTS") 
                {
                    ApplicationArea = all;
                }
                field("Rank"; Rec."RANK") 
                {
                    ApplicationArea = all;
                }
                field("Amount"; Rec."AMOUNT") 
                {
                    ApplicationArea = all;
                }
        }
    }
}