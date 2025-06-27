pageextension 50000 Pag-Ext55703.LocationCardExtExt extends "Pag-Ext55703.LocationCardExt"
{
    layout
    {
        addlast(Content)
        {
                field("Attention2"; Rec."ATTENTION2") 
                {
                    ApplicationArea = all;
                }
                field("Attention1"; Rec."ATTENTION1") 
                {
                    ApplicationArea = all;
                }
                field("County"; Rec."COUNTY") 
                {
                    ApplicationArea = all;
                }
        }
    }
}