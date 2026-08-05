pageextension 50526 PostedSalesInvLInesExt extends "Posted Sales Invoice Lines"
{
    layout
    {

        addafter("Sell-to Customer Name")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }

        addafter("No.")
        {
            field("OEM No."; rec."OEM No.")
            {
                ApplicationArea = all;
            }
            field("OEM Name"; rec."OEM Name")
            {
                ApplicationArea = all;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = all;
            }
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = all;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = all;
            }


        }

        addafter("Unit of Measure")
        {
            field(g_CurrencyCode; g_CurrencyCode)
            {
                ApplicationArea = all;
                Caption = 'Currency Code';
            }
        }

        addbefore("Unit Cost (LCY)")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = all;
            }
        }

        addafter("Unit Cost (LCY)")
        {
            field(g_CurrFactor; g_CurrFactor)
            {
                ApplicationArea = all;
                Caption = 'Currency Factor';
            }
            field("VAT %"; Rec."VAT %")
            {
                ApplicationArea = all;
            }
        }

        addafter("Unit Price")
        {
            field(g_UnitPriceLCY; g_UnitPriceLCY)
            {
                ApplicationArea = all;
                Caption = 'Unit Price Excl. GST (LCY)';
            }
        }

        addafter("Allow Invoice Disc.")
        {
            field("VAT Base Amount"; Rec."VAT Base Amount")
            {
                ApplicationArea = all;
            }
            field("Line Amount"; Rec."Line Amount")
            {
                ApplicationArea = all;
            }

            field("Customer Order No."; rec."Customer Order No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Parts No."; rec."Parts No.")
            {
                ApplicationArea = all;
            }
            field("Rank"; rec."Rank")
            {
                ApplicationArea = all;
            }
            field("Products"; rec."Products")
            {
                ApplicationArea = all;
            }
            field("Salesperson Code"; rec."Salesperson Code")
            {
                ApplicationArea = all;
            }

        }

        modify("Description 2")
        {
            Visible = true;
        }

        modify("Unit of Measure")
        {
            Visible = true;
        }

        modify("Line Discount Amount")
        {
            Visible = true;
        }

        modify("Amount Including VAT")
        {
            Visible = true;
        }

        modify("Allow Invoice Disc.")
        {
            Visible = true;
        }
    }

    var
        SalesInvHdr: Record "Sales Invoice Header";
        g_CurrFactor: Decimal;
        g_UnitPriceLCY: Decimal;
        g_CurrencyCode: Code[10];

    trigger OnAfterGetRecord()
    begin
        ClearAll();

        IF SalesInvHdr.GET(Rec."Document No.") THEN BEGIN
            IF Rec."Unit Cost (LCY)" <> Rec."Unit Cost" THEN BEGIN
                g_CurrencyCode := SalesInvHdr."Currency Code";
                g_CurrFactor := SalesInvHdr."Currency Factor";
                //g_ExchRate := "Unit Cost (LCY)" / "Unit Cost";
                if g_CurrFactor <> 0 then begin
                    g_UnitPriceLCY := Rec."Unit Price" / g_CurrFactor;
                end;
                //g_AmountLCY := Quantity * g_UnitPriceLCY;
                //g_AmountLCY1 := "Amount Including VAT" / g_CurrFactor;
            END ELSE BEGIN
                g_CurrencyCode := SalesInvHdr."Currency Code";
                g_CurrFactor := SalesInvHdr."Currency Factor";
                g_UnitPriceLCY := Rec."Unit Price";
            END;
        END;
    end;
}