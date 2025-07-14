pageextension 50027 VendorListExt extends "Vendor List"
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

        addafter(Name)
        {

            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
            }
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field(County; Rec.County)
            {
                ApplicationArea = all;
            }
            field("Home Page"; Rec."Home Page")
            {
                ApplicationArea = all;
            }
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = all;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = all;
            }
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }

        }

        addafter("Responsibility Center")
        {

            field("Incoterm Code"; Rec."Incoterm Code")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
        }

        addafter("Location Code")
        {

            field("Incoterm Location"; Rec."Incoterm Location")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
            field("Shipping Terms"; Rec."Shipping Terms")
            {
                ApplicationArea = all;
            }
        }

        addafter("Balance Due (LCY)")
        {

            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
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
