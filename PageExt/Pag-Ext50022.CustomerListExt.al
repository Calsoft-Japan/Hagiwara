pageextension 50000 Pag-Ext50022.CustomerListExtExt extends "Pag-Ext50022.CustomerListExt"
{
    layout
    {
        addlast(Content)
        {
                field("MARK"; Rec."M A R K") 
                {
                    ApplicationArea = all;
                }
                field("Balance"; Rec."BALANCE") 
                {
                    ApplicationArea = all;
                }
                field("Reserve"; Rec."RESERVE") 
                {
                    ApplicationArea = all;
                }
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