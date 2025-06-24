pageextension 50000 Pag-Ext50042.SalesOrderExtExt extends "Pag-Ext50042.SalesOrderExt"
{
    layout
    {
        addlast(Content)
        {
                field("To"; Rec."TO") 
                {
                    ApplicationArea = all;
                }
                field("From"; Rec."FROM") 
                {
                    ApplicationArea = all;
                }
        }
    }
}