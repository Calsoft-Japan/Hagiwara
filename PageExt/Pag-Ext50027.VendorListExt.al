pageextension 50000 Pag-Ext50027.VendorListExtExt extends "Pag-Ext50027.VendorListExt"
{
    layout
    {
        addlast(Content)
        {
                field("Address"; Rec."ADDRESS") 
                {
                    ApplicationArea = all;
                }
                field("County"; Rec."COUNTY") 
                {
                    ApplicationArea = all;
                }
                field("City"; Rec."CITY") 
                {
                    ApplicationArea = all;
                }
        }
    }
}