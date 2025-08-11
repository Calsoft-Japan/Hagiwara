page 50095 "ORE Message Collection SLSRPT"
{
    // CS060 Shawn 2024/03/09 - Fields added.
    // CS073 Shawn 2024/08/09 - Field added: ORE Reverse Routing Address
    // CS060 Shawn 2024/10/02 - CR30. SLSRPT: Original Document No., Original Document Line No.
    // CS089 Naoto 2024/12/22 - One Renesas EDI Modification

    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Message Collection SLSRPT";

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
                field("Document Type"; REC."Transaction Type")
                {
                }
                field("Document Type Code"; REC."Transaction Type Code")
                {
                }
                field("Document No."; REC."Transaction No.")
                {
                }
                field("Posting Date"; REC."Transaction Date")
                {
                }
                field("External Document No."; REC."External Document No.")
                {
                }
                field("Sell-to Customer No."; REC."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer ORE Name"; REC."Sell-to Customer ORE Name")
                {
                }
                field("Sell-to Cust. ORE Address 1"; REC."Sell-to Cust. ORE Address 1")
                {
                }
                field("Sell-to Cust. ORE Address 2"; REC."Sell-to Cust. ORE Address 2")
                {
                }
                field("Sell-to ORE City"; REC."Sell-to ORE City")
                {
                }
                field("Sell-to ORE State/Province"; REC."Sell-to ORE State/Province")
                {
                }
                field("Sell-to Post Code"; REC."Sell-to Post Code")
                {
                }
                field("Sell-to Country/Region Code"; REC."Sell-to Country/Region Code")
                {
                }
                field("Sell-to ORE Country"; REC."Sell-to ORE Country")
                {
                }
                field("Sell-to Customer SCM Code"; REC."Sell-to Customer SCM Code")
                {
                }
                field("Sales Currency Code"; REC."Currency Code")
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
                field("Unit Price"; REC."Unit Price")
                {
                }
                field("Unit Cost"; REC."ORE Debit Cost")
                {
                }
                field("ORE DBC Cost"; REC."ORE DBC Cost")
                {
                }
                field("OEM No."; REC."OEM No.")
                {
                }
                field("OEM ORE Name"; REC."OEM ORE Name")
                {
                }
                field("OEM ORE Address 1"; REC."OEM ORE Address 1")
                {
                }
                field("OEM ORE Address 2"; REC."OEM ORE Address 2")
                {
                }
                field("OEM ORE City"; REC."OEM ORE City")
                {
                }
                field("OEM ORE State/Province"; REC."OEM ORE State/Province")
                {
                }
                field("OEM Post Code"; REC."OEM Post Code")
                {
                }
                field("OEM Country/Region Code"; REC."OEM Country/Region Code")
                {
                }
                field("OEM ORE Country"; REC."OEM ORE Country")
                {
                }
                field("OEM SCM Code"; REC."OEM SCM Code")
                {
                }
                field("Sold-to Code"; REC."Sold-to Code")
                {
                }
                field("Vendor No."; REC."Vendor No.")
                {
                }
                field("Purchase Currency Code"; REC."Purchase Currency Code")
                {
                }
                field("Original Document No."; REC."Original Document No.")
                {
                }
                field("Original Document Line No."; REC."Original Document Line No.")
                {
                }
                field("Renesas Report Unit Price"; REC."Renesas Report Unit Price")
                {
                }
                field("Renesas Report Unit Price Cur."; REC."Renesas Report Unit Price Cur.")
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

