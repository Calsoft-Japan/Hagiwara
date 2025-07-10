pageextension 50001 "CompanyInfoExt" extends "Company Information"
{

    layout
    {
        addlast(General)
        {
            field("Register Type"; Rec."Register Type")
            {
                ApplicationArea = all;
            }
            field("Bank ABA"; rec."Bank ABA")
            {
                ApplicationArea = all;
            }
        }
    }
}