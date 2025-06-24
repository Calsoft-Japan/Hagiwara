pageextension 50000 Pag-Ext59305.SalesOrderListExtExt extends "Pag-Ext59305.SalesOrderListExt"
{
    layout
    {
        addlast(Content)
        {
                field("Ship"; Rec."SHIP") 
                {
                    ApplicationArea = all;
                }
                field("Amount_LCY"; Rec."AMOUNT_ L C Y") 
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