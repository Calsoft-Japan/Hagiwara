pageextension 50042 SalesOrderExt extends "Sales Order"
{
    layout
    {
        addlast(Content)
        {
            field("To"; Rec."To")
            {
                ApplicationArea = all;
            }
            field("From"; Rec."From")
            {
                ApplicationArea = all;
            }
        }
    }
}