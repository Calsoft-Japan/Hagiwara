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

            field("Commercial Register"; rec."Commercial Register")
            {
                ApplicationArea = all;
            }
            field("CEO 1"; rec."CEO 1")
            {
                ApplicationArea = all;
            }
            field("CEO 2"; rec."CEO 2")
            {
                ApplicationArea = all;
            }

        }
    }
}