pageextension 50000 Pag-Ext59800.UsersExtExt extends "Pag-Ext59800.UsersExt"
{
    layout
    {
        addlast(Content)
        {
                field("State"; Rec."STATE") 
                {
                    ApplicationArea = all;
                }
        }
    }
}