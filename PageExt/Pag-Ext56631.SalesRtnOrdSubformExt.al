pageextension 56631 SalesRtnOrdSubformExt extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Approved Quantity"; Rec."Approved Quantity")
            {
                ApplicationArea = all;
            }
            field("Approved Unit Price"; Rec."Approved Unit Price")
            {
                ApplicationArea = all;
            }
            field("Approval History Exists"; Rec."Approval History Exists")
            {
                ApplicationArea = all;
            }
        }

        modify(Quantity)
        {
            StyleExpr = StyleAppr_Qty;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

                if Rec.Quantity <> Rec."Approved Quantity" then begin
                    StyleAppr_Qty := 'Unfavorable';
                end else begin
                    StyleAppr_Qty := '';
                end;

            end;
        }

        modify("Unit Price")
        {
            StyleExpr = StyleAppr_UnitPrice;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

                if Rec."Unit Price" <> Rec."Approved Unit Price" then begin
                    StyleAppr_UnitPrice := 'Unfavorable';
                end else begin
                    StyleAppr_UnitPrice := '';
                end;

            end;
        }


    }

    var
        StyleAppr_Qty: Text;
        StyleAppr_UnitPrice: Text;

    trigger OnAfterGetRecord()
    begin

        StyleAppr_Qty := '';
        StyleAppr_UnitPrice := '';
        if Rec.Quantity <> Rec."Approved Quantity" then begin
            StyleAppr_Qty := 'Unfavorable';
        end;
        if Rec."Unit Price" <> Rec."Approved Unit Price" then begin
            StyleAppr_UnitPrice := 'Unfavorable';
        end;

    end;
}