pageextension 50000 Pag-Ext50498.ReservationExtExt extends "Pag-Ext50498.ReservationExt"
{
    layout
    {
        addlast(Content)
        {
                field("Products"; Rec."PRODUCTS") 
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