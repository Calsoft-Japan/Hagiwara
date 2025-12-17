pageextension 50098 PurchaseCrMemoSubformExt extends "Purch. Cr. Memo Subform"
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
            StyleExpr = StyleAppr_UnitPrice;
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

                if Rec."Direct Unit Cost" <> Rec."Approved Unit Cost" then begin
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
        if Rec."Direct Unit Cost" <> Rec."Approved Unit Cost" then begin
            StyleAppr_UnitPrice := 'Unfavorable';
        end;

    end;
}