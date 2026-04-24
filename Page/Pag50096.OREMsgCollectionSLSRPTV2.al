page 50096 "ORE Msg Collection SLSRPT V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "ORE Msg Collection SLSRPT V2";

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
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Type Code"; Rec."Transaction Type Code")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer ORE Name"; Rec."Sell-to Customer ORE Name")
                {
                }
                field("Sell-to Cust. ORE Address 1"; Rec."Sell-to Cust. ORE Address 1")
                {
                }
                field("Sell-to Cust. ORE Address 2"; Rec."Sell-to Cust. ORE Address 2")
                {
                }
                field("Sell-to ORE City"; Rec."Sell-to ORE City")
                {
                }
                field("Sell-to ORE State/Province"; Rec."Sell-to ORE State/Province")
                {
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Sell-to ORE Country"; Rec."Sell-to ORE Country")
                {
                }
                field("Sell-to Customer SCM Code"; Rec."Sell-to Customer SCM Code")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Sub Line No."; Rec."Sub Line No.")
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
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Inventory Unit Cost"; Rec."Inventory Unit Cost")
                {
                }
                field("ORE DBC Cost"; Rec."ORE DBC Cost")
                {
                }
                field("OEM No."; Rec."OEM No.")
                {
                }
                field("OEM ORE Name"; Rec."OEM ORE Name")
                {
                }
                field("OEM ORE Address 1"; Rec."OEM ORE Address 1")
                {
                }
                field("OEM ORE Address 2"; Rec."OEM ORE Address 2")
                {
                }
                field("OEM ORE City"; Rec."OEM ORE City")
                {
                }
                field("OEM ORE State/Province"; Rec."OEM ORE State/Province")
                {
                }
                field("OEM Post Code"; Rec."OEM Post Code")
                {
                }
                field("OEM Country/Region Code"; Rec."OEM Country/Region Code")
                {
                }
                field("OEM ORE Country"; Rec."OEM ORE Country")
                {
                }
                field("OEM SCM Code"; Rec."OEM SCM Code")
                {
                }
                field("Sold-to Code"; Rec."Sold-to Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Purchase Currency Code"; Rec."Purchase Currency Code")
                {
                }
                field("Reverse Routing Address"; Rec."Reverse Routing Address")
                {
                }
                field("Original Document No."; Rec."Original Document No.")
                {
                }
                field("Original Document Line No."; Rec."Original Document Line No.")
                {
                }
                field("Renesas Report Unit Price"; Rec."Renesas Report Unit Price")
                {
                }
                field("Renesas Report Unit Price Cur."; Rec."Renesas Report Unit Price Cur.")
                {
                }
                field("Original Item No."; Rec."Original Item No.")
                {
                }
                field("Original Document Sub Line No."; Rec."Original Document Sub Line No.")
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

