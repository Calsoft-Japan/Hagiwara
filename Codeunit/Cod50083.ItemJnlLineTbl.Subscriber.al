codeunit 50083 "ItemJnlLineTbl Subscriber"
{

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", OnAfterCopyItemJnlLineFromPurchLine, '', false, false)]
    local procedure DoOnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")

    begin

        //Siak 25112012 capture 'CO No.' to print in Posted Purch. Receipt Report ID 50018
        ItemJnlLine."CO No." := PurchLine."CO No.";
        //Siak 25112012 - END

    end;

}