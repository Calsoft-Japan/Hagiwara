pageextension 56641 PurchaseRtnOrdSubformExt extends "Purchase Return Order Subform"
{
    layout
    {
        addafter("Direct Unit Cost")
        {
            field("Approved Quantity"; Rec."Approved Quantity")
            {
                ApplicationArea = all;
            }
            field("Approved Unit Cost"; Rec."Approved Unit Cost")
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

        modify("Direct Unit Cost")
        {
            StyleExpr = StyleAppr_UnitCost;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

                if Rec."Unit Cost" <> Rec."Approved Unit Cost" then begin
                    StyleAppr_UnitCost := 'Unfavorable';
                end else begin
                    StyleAppr_UnitCost := '';
                end;

            end;
        }

    }



    var
        StyleAppr_Qty: Text;
        StyleAppr_UnitCost: Text;

    trigger OnAfterGetRecord()
    begin

        StyleAppr_Qty := '';
        StyleAppr_UnitCost := '';
        if Rec.Quantity <> Rec."Approved Quantity" then begin
            StyleAppr_Qty := 'Unfavorable';
        end;
        if Rec."Direct Unit Cost" <> Rec."Approved Unit Cost" then begin
            StyleAppr_UnitCost := 'Unfavorable';
        end;

    end;
}