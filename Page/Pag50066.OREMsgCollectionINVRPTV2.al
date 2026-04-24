page 50066 "ORE Msg Collection INVRPT V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Msg Collection INVRPT V2";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("History Entry No."; Rec."History Entry No.")
                {
                }
                field("Message Status"; FORMAT(Rec."Message Status"))
                {
                    Caption = 'Message Status';
                }
                field("Sold-to Code"; Rec."Sold-to Code")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                }
                field("Ship-to Country"; Rec."Ship-to Country")
                {
                }
                field("Ship-to Address2"; Rec."Ship-to Address2")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Inventory Unit Cost"; Rec."Inventory Unit Cost")
                {
                }
                field("ORE Customer Name"; Rec."ORE Customer Name")
                {
                }
                field("Original Item No."; Rec."Original Item No.")
                {
                }
                field("Reverse Routing Address"; Rec."Reverse Routing Address")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
                {
                }
                field("RRA NULL Flag"; Rec."RRA NULL Flag")
                {
                }
                field("Renesas Category"; Rec."Renesas Category")
                {
                }
                field("Company Category"; Rec."Company Category")
                {
                }
                field("Report Sold-to Code"; Rec."Report Sold-to Code")
                {
                }
                field("ORE CPN"; Rec."ORE CPN")
                {
                }
            }
        }
    }

    actions
    {
    }
}

