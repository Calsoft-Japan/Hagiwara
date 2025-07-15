pageextension 55703 LocationCardExt extends "Location Card"
{
    layout
    {

        addafter(Contact)
        {
            field("County"; Rec."COUNTY")
            {
                ApplicationArea = all;
            }

            field("Attention1"; Rec."ATTENTION1")
            {
                ApplicationArea = all;
            }
            field("Attention2"; Rec."ATTENTION2")
            {
                ApplicationArea = all;
            }
        }

        addafter("Use As In-Transit")
        {

            field("Use As FCA In-Transit"; Rec."Use As FCA In-Transit")
            {
                ApplicationArea = all;
            }

        }
    }
}