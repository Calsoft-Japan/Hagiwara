pageextension 50030 ItemCardExtextends extends "Item Card"
{
    layout
    {
        addafter("Costs & Posting")
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                field("Shortcut Dimension Code 1"; Rec."Shortcut Dimension Code 1")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Group';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = const('CUSTOMERGROUP'));
                }

                field("Shortcut Dimension Code 2"; Rec."Shortcut Dimension Code 2")
                {
                    ApplicationArea = All;
                    Caption = 'Base Currency';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = const('BASECURRENCY'));
                }

                field("Shortcut Dimension Code 3"; Rec."Shortcut Dimension Code 3")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Group';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = const('VENDORGROUP'));
                }

                field("Shortcut Dimension Code 4"; Rec."Shortcut Dimension Code 4")
                {
                    ApplicationArea = All;
                    Caption = 'Item Group';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = const('ITEMGROUP'));
                }

                field("Shortcut Dimension Code 5"; Rec."Shortcut Dimension Code 5")
                {
                    ApplicationArea = All;
                    Caption = 'Team';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = const('TEAM'));
                }

                field("Shortcut Dimension Code 6"; Rec."Shortcut Dimension Code 6")
                {
                    ApplicationArea = All;
                    Caption = '';

                }

                field("Shortcut Dimension Code 7"; Rec."Shortcut Dimension Code 7")
                {
                    ApplicationArea = All;
                    Caption = '';

                }

                field("Shortcut Dimension Code 8"; Rec."Shortcut Dimension Code 8")
                {
                    ApplicationArea = All;
                    Caption = '';

                }
            }
        }
        addafter("No.")
        {

            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
        }

        addafter(Description)
        {

            field("Parts No."; Rec."Parts No.")
            {
                ApplicationArea = all;
            }
            field(Rank; Rec.Rank)
            {
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No.(Plain)"; Rec."Customer Item No.(Plain)")
            {
                ApplicationArea = all;
            }
            field("OEM No."; Rec."OEM No.")
            {
                ApplicationArea = all;
            }
            field(Products; Rec.Products)
            {
                ApplicationArea = all;
            }
        }

        addafter("Last Date Modified")
        {
            field("Last Time Modified"; Rec."Last Time Modified")
            {
                ApplicationArea = all;
            }
            field(SBU; Rec.SBU)
            {
                ApplicationArea = all;
            }
            field("Planning Receipt (Qty.)"; Rec."Planning Receipt (Qty.)")
            {
                ApplicationArea = all;
            }
            field("Planned Order Receipt (Qty.)"; Rec."Planned Order Receipt (Qty.)")
            {
                ApplicationArea = all;
            }

        }

        addafter(GTIN)
        {


            field(EOL; Rec.EOL)
            {
                ApplicationArea = all;
            }
            field("Order Deadline Date"; Rec."Order Deadline Date")
            {
                ApplicationArea = all;
            }
            field("Service Parts"; Rec."Service Parts")
            {
                ApplicationArea = all;
            }
            field(Memo; Rec.Memo)
            {
                ApplicationArea = all;
            }
            field(EDI; Rec.EDI)
            {
                ApplicationArea = all;
            }
            field("Manufacturer 2 Code"; Rec."Manufacturer 2 Code")
            {
                ApplicationArea = all;
            }
            field("Car Model"; Rec."Car Model")
            {
                ApplicationArea = all;
            }
            field(SOP; Rec.SOP)
            {
                ApplicationArea = all;
            }
            field("MP-Volume(pcs/M)"; Rec."MP-Volume(pcs/M)")
            {
                ApplicationArea = all;
            }
            field(Apl; Rec.Apl)
            {
                ApplicationArea = all;
            }
        }

        addafter("Item Category Code")
        {

            field("Item Group Code"; Rec."Item Group Code")
            {
                ApplicationArea = all;
            }

            field("Message Collected On"; Rec."Message Collected On")
            {
                ApplicationArea = all;
            }
            field("Scheduled Receipt (Qty.)"; Rec."Scheduled Receipt (Qty.)")
            {
                ApplicationArea = all;
            }
        }

        addafter(Inventory)
        {


            field("Inventory Balance"; Rec.Inventory)
            {
                ApplicationArea = all;
                Caption = 'Inventory Balance';
            }
            field(Hold; Rec.Hold)
            {
                ApplicationArea = all;
            }
            field("FCA In-Transit"; Rec."FCA In-Transit")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Available Inventory Balance"; Rec.Inventory - Rec.Hold - Rec."FCA In-Transit")
            {
                ApplicationArea = all;
                Caption = 'Available Inventory Balance';
                DecimalPlaces = 0 : 5;
                Editable = false;
                Lookup = true;
            }
        }

        addafter("Qty. on Purch. Order")
        {


            field("Qty. on Purch. Quote"; Rec."Qty. on Purch. Quote")
            {
                ApplicationArea = all;
            }
            field("Qty. on P. O. (Req Rec Date)"; Rec."Qty. on P. O. (Req Rec Date)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 0;
            }
            field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Quote"; Rec."Qty. on Sales Quote")
            {
                ApplicationArea = all;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit Price")
        {

            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = all;
            }
        }

        addafter("Overhead Rate")
        {


            field("Inventory Shipped"; Rec."Inventory Shipped")
            {
                ApplicationArea = all;
                Caption = 'Inventory Shipped';
            }
            field("Inventory Neg Adj"; Rec."Inventory Neg Adj")
            {
                ApplicationArea = all;
                Caption = 'Inventory Neg Adj.';
            }
            field("Initial Blocked"; Rec."Initial Blocked")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Original Item No."; Rec."Original Item No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("Net Invoiced Qty.")
        {

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Vendor No.")
        {


            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
            }
            field("One Renesas EDI"; Rec."One Renesas EDI")
            {
                ApplicationArea = all;
            }
            field("Excluded in Inventory Report"; Rec."Excluded in Inventory Report")
            {
                ApplicationArea = all;
            }
            field("Purch. Order Quantity Limit"; Rec."Purch. Order Quantity Limit")
            {
                ApplicationArea = all;
            }
            field(PKG; Rec.PKG)
            {
                ApplicationArea = all;
            }
            field("Inventory Receipt"; Rec."Inventory Receipt")
            {
                ApplicationArea = all;
                Caption = 'Inventory Receipt';
            }
            field("Inventory Pos Adj"; Rec."Inventory Pos Adj")
            {
                ApplicationArea = all;
                Caption = 'Inventory Pos Adj.';
            }
        }

        addafter("Lot Size")
        {

            field("Update Date"; Rec."Update Date")
            {
                ApplicationArea = all;
                Caption = 'Last Update Date';
            }
            field("Update Time"; Rec."Update Time")
            {
                ApplicationArea = all;
                Caption = 'Last Update Time';
            }
            field("Update By"; Rec."Update By")
            {
                ApplicationArea = all;
                Caption = 'Last Update By';
            }
            field("Update Doc. No."; Rec."Update Doc. No.")
            {
                ApplicationArea = all;
                Caption = 'Last Update Doc. No.';
            }
        }

    }


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        //CS028 Begin
        //IF CurrPage.EDITABLE THEN BEGIN  //CS058
        //CS058 Begin
        //IF "Item Supplier Source" = "Item Supplier Source"::Renesas THEN
        //  IF "OEM No." = '' THEN ERROR(Text001);
        Rec.TESTFIELD("Customer No.");
        Rec.TESTFIELD("OEM No.");
        Rec.TESTFIELD("Manufacturer Code");
        //CS058 End
        //END;  //CS058
        //CS028 End
    end;
}