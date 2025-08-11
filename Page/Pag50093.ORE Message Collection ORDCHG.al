page 50093 "ORE Message Collection ORDCHG"
{
    // CS073 Shawn 2024/08/09 - Field added: ORE Reverse Routing Address

    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Message Collection ORDCHG";

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
                field("Action Type"; REC."Action Type")
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
                field("Requested Receipt Date"; REC."Requested Receipt Date")
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

