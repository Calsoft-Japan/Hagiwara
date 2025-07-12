pageextension 50021 CustomerCardExt extends "Customer Card"
{
    layout
    {

        addafter("No.")
        {

            field("Familiar Name"; Rec."Familiar Name")
            {
            }
        }

        addafter("Name 2")
        {

            field("ORE Customer Name"; Rec."ORE Customer Name")
            {
            }
            field("ORE Address"; Rec."ORE Address")
            {
            }
            field("ORE Address 2"; Rec."ORE Address 2")
            {
            }
            field("Customer Group"; Rec."Customer Group")
            {
            }
        }
        addafter("Post Code")
        {

            field("ORE Post Code"; Rec."ORE Post Code")
            {
            }

        }
        addafter(City)
        {

            field("ORE City"; Rec."ORE City")
            {
            }
        }

        addafter(County)
        {

            field("ORE State/Province"; Rec."ORE State/Province")
            {
            }
        }
        addafter("Country/Region Code")
        {

            field("ORE Country"; Rec."ORE Country")
            {
            }
        }

        addafter(ContactName)
        {

            field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
            {

                trigger OnValidate()
                begin
                    //CS028 Begin
                    IF (Rec."Vendor Cust. Code" <> '') AND (STRLEN(Rec."Vendor Cust. Code") <> 10) THEN ERROR(Text003);
                    //CS028 End
                end;
            }
        }

        addafter("Language Code")
        {

            field("Customer Type"; Rec."Customer Type")
            {
            }
            field("NEC OEM Code"; Rec."NEC OEM Code")
            {
            }
            field("NEC OEM Name"; Rec."NEC OEM Name")
            {
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
            }
            field("Excluded in ORE Collection"; Rec."Excluded in ORE Collection")
            {
            }
        }

        addafter("Registration Number")
        {

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
            }
        }

        addafter("Customer Posting Group")
        {

            field("Import File Ship To"; Rec."Import File Ship To")
            {
                Visible = false;
            }
        }

        addafter("Customized Calendar")
        {

            field("Ship From Name"; Rec."Ship From Name")
            {
            }
            field("Ship From Address"; Rec."Ship From Address")
            {
            }
            field("Default Country/Region of Org"; Rec."Default Country/Region of Org")
            {
            }
            group("Shipping Marks/Remarks")
            {
                field("Shipping Mark1"; Rec."Shipping Mark1")
                {
                }
                field("Shipping Mark2"; Rec."Shipping Mark2")
                {
                }
                field("Shipping Mark3"; Rec."Shipping Mark3")
                {
                }
                field("Shipping Mark4"; Rec."Shipping Mark4")
                {
                }
                field("Shipping Mark5"; Rec."Shipping Mark5")
                {
                }
                field(Remarks1; Rec.Remarks1)
                {
                }
                field(Remarks2; Rec.Remarks2)
                {
                }
                field(Remarks3; Rec.Remarks3)
                {
                }
                field(Remarks4; Rec.Remarks4)
                {
                }
                field(Remarks5; Rec.Remarks5)
                {
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        //CS028 Begin
        //IF CurrPage.EDITABLE THEN BEGIN  //CS058
        IF Rec."Item Supplier Source" = Rec."Item Supplier Source"::Renesas THEN
            IF Rec."Vendor Cust. Code" = '' THEN ERROR(Text001);
        IF Rec."Vendor Cust. Code" <> '' THEN
            IF Rec."Item Supplier Source" = Rec."Item Supplier Source"::" " THEN ERROR(Text002);
        Rec.TESTFIELD(Rec."Familiar Name");  //CS058
        //END;  //CS058
        //CS028 End

    end;

    var
        Text001: Label 'Vendor Cust. code must have a value when Item Supplier Source equals to "Renesas".';
        Text002: Label 'Item Supplier Source must equal to "Renesas" when Vendor Cust. Code is not blank.';
        Text003: Label 'Vendor Cust. Code must have 10 digits.';

}