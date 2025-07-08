pageextension 55703 LocationCardExt extends "Location Card"
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
            field("Use As FCA In-Transit"; Rec."Use As FCA In-Transit")
            {
                ApplicationArea = all;
            }
            field("CC"; Rec."CC")
            {
                ApplicationArea = all;
            }
        }
    }
}