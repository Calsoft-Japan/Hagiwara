pageextension 50000 Pag-Ext50026.VendorCardExtExt extends "Pag-Ext50026.VendorCardExt"
{
    layout
    {
        addlast(Content)
        {
                field("ShowMapLbl"; Rec."SHOW MAP LBL") 
                {
                    ApplicationArea = all;
                }
                field("ABN"; Rec."A B N") 
                {
                    ApplicationArea = all;
                }
                field("County"; Rec."COUNTY") 
                {
                    ApplicationArea = all;
                }
                field("Registered"; Rec."REGISTERED") 
                {
                    ApplicationArea = all;
                }
        }
    }
}