pageextension 59305 SalesOrderListExt extends "Sales Order List"
{
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Ship"; Rec."Ship")
                {
                    ApplicationArea = all;
                }
                /*
                field("Amount_LCY"; Rec."Amount_LCYY")
                {
                    ApplicationArea = all;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = all;
                }
                */
            }
        }
    }
}
