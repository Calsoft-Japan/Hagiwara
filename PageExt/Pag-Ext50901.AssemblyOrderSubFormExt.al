pageextension 50901 AssemblyOrderSubFormExt extends "Assembly Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Approved Quantity"; Rec."Approved Quantity")
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
    }

    var
        StyleAppr_Qty: Text;

    trigger OnAfterGetRecord()
    begin

        StyleAppr_Qty := '';
        if Rec.Quantity <> Rec."Approved Quantity" then begin
            StyleAppr_Qty := 'Unfavorable';
        end;

    end;
}
