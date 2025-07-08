tableextension 50079 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50000; "CEO 1"; Text[50])
        {
            Caption = 'CEO 1';
            Description = 'BBN.01';
        }
        field(50001; "CEO 2"; Text[50])
        {
            Caption = 'CEO 2';
            Description = 'BBN.01';
        }
        field(50002; "CEO 3"; Text[50])
        {
            Caption = 'CEO 3';
            Description = 'BBN.01';
        }
        field(50003; "Commercial Register"; Text[50])
        {
            Caption = 'Commercial Register';
            Description = 'BBN.01';
        }
        field(50004; "Accounting Manager"; Text[30])
        {
            Description = '//ACW1.01';
        }
        field(50005; "Account Name"; Text[250])
        {
            Description = '//ACW1.01';
        }
        field(50006; "Use China Localization Pack"; Boolean)
        {
            Description = '//ACW1.01';
        }
        field(50010; "Signature Name"; Text[50])
        {
            // cleaned
        }
        field(50011; "Register Type"; Text[30])
        {
            // cleaned
        }
        field(50012; "Bank ABA"; Code[30])
        {
            // cleaned
        }
    }
}
