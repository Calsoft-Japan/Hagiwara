table 50045 "VAT Credit Card"
{
    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Credit Card No."; Text[19])
        {
            Caption = 'Credit Card No.';
        }
        field(3; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; Use; Boolean)
        {
            Caption = 'Use';
        }
        field(6; "Expiry Date"; Code[4])
        {
            Caption = 'Expiry Date';
            NotBlank = true;

        }
        field(7; "Card Holder Name"; Text[50])
        {
            Caption = 'Card Holder Name';
            NotBlank = true;
        }
        field(8; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            NotBlank = true;

        }
        field(9; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            NotBlank = true;

        }
        field(10; "Cvc No."; Integer)
        {
            Caption = 'Cvc No.';
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}
