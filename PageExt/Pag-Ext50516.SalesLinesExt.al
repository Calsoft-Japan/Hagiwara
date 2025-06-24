pageextension 50000 Pag-Ext50516.SalesLinesExtExt extends "Pag-Ext50516.SalesLinesExt"
{
    layout
    {
        addlast(Content)
        {
                field("OrderDate"; Rec."ORDER DATE") 
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
                field("LineAmtExclVAT_LCY"; Rec."LINE AMT EXCL V A T_ L C Y") 
                {
                    ApplicationArea = all;
                }
        }
    }
}