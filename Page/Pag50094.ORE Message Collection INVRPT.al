page 50094 "ORE Message Collection INVRPT"
{
    // CS060 Shawn 2024/02/23 - Add field "ORE Customer Name"
    // CS073 Shawn 2024/08/09 - Field added: ORE Reverse Routing Address
    // CS089 Naoto 2024/12/22 - One Renesas EDI Modification

    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Message Collection INVRPT";

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
                field("Message Status"; FORMAT(Rec."Message Status"))
                {
                }
                field("Sold-to Code"; REC."Sold-to Code")
                {
                }
                field("Ship-to Code"; REC."Ship-to Code")
                {
                }
                field("Ship-to Name"; REC."Ship-to Name")
                {
                }
                field("Ship-to Address"; REC."Ship-to Address")
                {
                }
                field("Ship-to Address2"; REC."Ship-to Address2")
                {
                }
                field("Ship-to City"; REC."Ship-to City")
                {
                }
                field("Ship-to County"; REC."Ship-to County")
                {
                }
                field("Ship-to Post Code"; REC."Ship-to Post Code")
                {
                }
                field("Ship-to Country"; REC."Ship-to Country")
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
                field("Cost Amount (Actual)"; REC."Cost Amount (Actual)")
                {
                }
                field("Inventory Unit Cost"; REC."ORE DBC Cost")
                {
                }
                field("ORE Customer Name"; REC."ORE Customer Name")
                {
                }
                field("Original Item No."; REC."Original Item No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

