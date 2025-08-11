page 50092 "ORE Message Collection ORDERS"
{
    // CS073 Shawn 2024/08/09 - Field added: ORE Reverse Routing Address

    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Message Collection ORDERS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; REC."Entry No.")
                {
                }
                field("History Entry No."; REC."History Entry No.")
                {
                }
                field("ORE Reverse Routing Address"; REC."ORE Reverse Routing Address")
                {
                }
                field("<Message Status>"; FORMAT(Rec."Message Status"))
                {
                }
                field("Order No."; REC."Order No.")
                {
                }
                field("Order Date"; REC."Order Date")
                {
                }
                field("Ship-to Code"; REC."Ship-to Code")
                {
                }
                field("Currency Code"; REC."Currency Code")
                {
                }
                field("Line No."; REC."Line No.")
                {
                }
                field("Item No."; REC."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Direct Unit Cost"; REC."Direct Unit Cost")
                {
                }
                field("Customer No."; REC."Customer No.")
                {
                }
                field("Requested Receipt Date"; REC."Requested Receipt Date")
                {
                }
                field("ORE Customer Name"; REC."ORE Customer Name")
                {
                }
                field("ORE Line No."; REC."ORE Line No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

