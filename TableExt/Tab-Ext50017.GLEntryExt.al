tableextension 50017 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(50000; "FC Amount"; Decimal)
        {
            Description = 'ACW1.01CHP1.00';
        }
        field(50001; "Value Entry No."; Integer)
        {
            // cleaned
        }
        field(50002; "Currency Code"; Code[10])
        {
            TableRelation = Currency.Code;
            Description = 'ACW1.01CHP1.00';
        }
        field(50003; "FC Debit Amount"; Decimal)
        {
            Description = 'ACW1.01CHP1.00';
        }
        field(50004; "FC Credit Amount"; Decimal)
        {
            Description = 'ACW1.01CHP1.00';
        }
        field(50101; "Journal Creator"; Code[50])
        {
            Description = 'ACW1.01';
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(50102; "Journal Assessor"; Code[50])
        {
            Description = 'ACW1.01';
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(50103; Excerpta; Text[100])
        {
            Description = 'ACW1.01';
        }
        field(50105; "Chinese Account Name"; Text[50])
        {
            Caption = 'Chinese Account Name';
            Description = 'ACW1.01';
        }
        field(50106; "No. of Attachment"; Integer)
        {
            Description = 'ACW1.01';
        }
        field(50107; "Reference No."; Code[20])
        {
            Description = 'ACW1.01';
        }
        field(50108; "Payment Method"; Option)
        {
            Caption = 'Payment Method';
            Description = 'ACW1.01';
            OptionCaption = ' ,Telegraphic Transfer,Check,Cash,Credit,Bank Draft';
            OptionMembers = " ","Telegraphic Transfer",Check,Cash,Credit,"Bank Draft";
        }
        field(50109; "FC Factor"; Decimal)
        {
            Description = 'ACW1.01CHP1.00';
        }
    }
}
