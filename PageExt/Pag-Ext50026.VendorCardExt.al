pageextension 50026 VendorCardExt extends "Vendor Card"
{
    layout
    {


        addafter("No.")
        {

            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
        }

        addafter("Responsibility Center")
        {

            field("Shipping Terms"; Rec."Shipping Terms")
            {
                ApplicationArea = all;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
            field("ORE Ship-to Code"; Rec."ORE Ship-to Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("ORE Reverse Routing Address"; Rec."ORE Reverse Routing Address")
            {
                ApplicationArea = all;
            }
            field("ORE Reverse Routing Address SD"; Rec."ORE Reverse Routing Address SD")
            {
                ApplicationArea = all;
            }
            field("Excluded in ORE Collection"; Rec."Excluded in ORE Collection")
            {
                ApplicationArea = all;
            }
            field("Hagiwara Group"; Rec."Hagiwara Group")
            {
                ApplicationArea = all;
                TableRelation = "Hagiwara Group".Code;
            }
        }

        addafter("Vendor Posting Group")
        {

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Customized Calendar")
        {

            field("Incoterm Code"; Rec."Incoterm Code")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
            field("Incoterm Location"; Rec."Incoterm Location")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
        }
    }

    trigger OnOpenPage()
    begin


        IncotermVisibility := HagiwaraFunctions.GetIncotermVisibility; //HG10.00.04 NJ 13/02/2018
    end;

    var
        IncotermVisibility: Boolean;
        HagiwaraFunctions: Codeunit "Hagiwara Functions";
}