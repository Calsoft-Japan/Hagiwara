codeunit 50022 "ItemJnlPostLine Subscriber"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure DoOnAfterInitItemLedgEntry(
        var NewItemLedgEntry: Record "Item Ledger Entry";
        var ItemJournalLine: Record "Item Journal Line";
        var ItemLedgEntryNo: Integer)

    var
    begin

        //Siak - 15 Aug 2014 Start
        NewItemLedgEntry."CO No." := ItemJournalLine."CO No.";
        //Siak - 15 Aug 2014 End

        //SH-20121203
        NewItemLedgEntry."Salespers./Purch. Code" := ItemJournalLine."Salespers./Purch. Code";
        //SH-END

        //HG10.00.02 NJ 01/06/2017 -->
        NewItemLedgEntry."Sales Order No." := ItemJournalLine."Sales Order No.";
        NewItemLedgEntry."Purchase Order No." := ItemJournalLine."Purchase Order No.";
        //HG10.00.02 NJ 01/06/2017 <--
    end;

}