tableextension 50318 "Tax Area Ext" extends "Tax Area"
{
    fields
    {
        field(50001; Address; Text[100])
        {
            Caption = 'Address';
            Description = 'SKLV6.0';
        }
        field(50002; "Address 2"; Text[100])
        {
            Caption = 'Address 2';
            Description = 'SKLV6.0';
        }
        field(50003; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            Description = 'SKLV6.0';
        }
        field(50004; City; Text[30])
        {
            Caption = 'City';
            Description = 'SKLV6.0';
        }
        field(50005; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'SKLV6.0';
        }
        field(50006; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            Description = 'SKLV6.0';
        }
        field(50007; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            Description = 'SKLV6.0';
        }
        field(50008; Email; Text[80])
        {
            Caption = 'Email';
            Description = 'SKLV6.0';
        }
        field(50009; "VAT Registration No."; Text[30])
        {
            Caption = 'VAT Registration No.';
            Description = 'SKLV6.0';

        }
        field(50010; "Owner Name"; Text[50])
        {
            Caption = 'Owner Name';
            Description = 'SKLV6.0';
        }
        field(50011; "Business Type"; Text[30])
        {
            Caption = 'Business Type';
            Description = 'SKLV6.0';
        }
        field(50012; "Business Class"; Text[30])
        {
            Caption = 'Business Class';
            Description = 'SKLV6.0';
        }
        field(50013; "Corp. Registration No."; Text[30])
        {
            Caption = 'Corp. Registration No.';
            Description = 'SKLV6.0';

        }
        field(50014; "ID No."; Text[30])
        {
            Caption = 'ID No.';
            Description = 'SKLV6.0';
        }
        field(50015; "Gov. Tax Office Code"; Code[10])
        {
            Caption = 'Gov. Tax Office Code';
            Description = 'SKLV6.0';

        }
        field(50016; "Gov. Tax Office Name"; Text[30])
        {
            Caption = 'Gov. Tax Office Name';
            Description = 'SKLV6.0';
        }
        field(50017; "Alcoholic Wholesale Code"; Option)
        {
            Caption = 'Alcoholic Wholesale Code';
            Description = 'SKLV6.0';
            OptionMembers = "0","1","2","3","4","5","6","7";
        }
        field(50018; "Alcoholic Retail Code"; Option)
        {
            Caption = 'Alcoholic Retail Code';
            Description = 'SKLV6.0';
            OptionMembers = "0","1","2","3","4","5","6","7";
        }
        field(50019; "Tax Invoice Line"; Option)
        {
            Caption = 'Tax Invoice Line';
            Description = 'SKLV6.0';
            OptionCaption = '1,2,3,4';
            OptionMembers = "1","2","3","4";
        }
        field(50020; "Print Deal Statement"; Boolean)
        {
            Caption = 'Print Deal Statement';
            Description = 'SKLV6.0';
        }
        field(50021; "Opening Date"; Date)
        {
            Caption = 'Opening Date';
            Description = 'SKLV6.0';
        }
        field(50022; Seal; BLOB)
        {
            Caption = 'Seal';
            Description = 'SKLV6.0';
        }
        field(50023; "Corp Seal"; BLOB)
        {
            Caption = 'Official Seal';
            Description = 'SKLV6.0';
        }
    }
}
