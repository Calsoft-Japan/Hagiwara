tableextension 50015 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(50001; "CU Account Category"; Option)
        {
            Caption = 'Account Category';
            OptionCaption = 'Asset,Liability,Coomon,Cost,Benifit,Profit & Loss';
            OptionMembers = Asset,Liability,Coomon,Cost,Benifit,"Profit & Loss";
        }
        field(50002; "Foereign Currency"; Code[10])
        {
            TableRelation = Currency.Code;
            Caption = 'Currency';
        }
        field(50003; "Complementary Acc. Type"; Option)
        {
            Caption = 'complementary account type';
            OptionCaption = ' ,Customer Transaction,Supplier Transacrtion, Division Computimg';
            OptionMembers = " ","Customer Transaction","Supplier Transaction"," Division Computimg";
        }
        field(50004; "Account Format"; Option)
        {
            Caption = 'Account Format';
            OptionCaption = 'Jin Ge Se,Wai Bi Jin Ge Se';
            OptionMembers = "Jin Ge Se","Wai Bi Jin Ge Se";
        }
        field(50005; "L. Name"; Text[50])
        {
            // cleaned
        }
        field(50006; Name2; Text[50])
        {
            Description = 'ACWSH';
        }
    }
}
