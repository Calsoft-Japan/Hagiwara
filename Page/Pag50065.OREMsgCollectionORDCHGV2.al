page 50065 "ORE Msg Collection ORDCHG V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Msg Collection ORDCHG V2";

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
                field("Action Type"; Rec."Action Type")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Line No."; Rec."Line No.")
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
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("ORE Line No."; Rec."ORE Line No.")
                {
                }
                field("Reverse Routing Address"; Rec."Reverse Routing Address")
                {
                }
                field("Sold-to Code"; Rec."Sold-to Code")
                {
                }
                field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
                {
                }
                field("RRA NULL Flag"; Rec."RRA NULL Flag")
                {
                }
                field("Renesas Category Code"; Rec."Renesas Category Code")
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

