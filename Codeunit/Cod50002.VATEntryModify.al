codeunit 50002 VATEntryModify
{
    // CS092 FDD SG01 Bobby.ji 2025/9/2 - Upgrade to the BC version
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VAT Entry - Edit", OnBeforeVATEntryModify, '', false, false)]
    local procedure "VAT Entry - Edit_OnBeforeVATEntryModify"(var VATEntry: Record "VAT Entry"; FromVATEntry: Record "VAT Entry")
    begin
        VATEntry."GST Rate" := FromVATEntry."GST Rate";
        VATEntry.From := FromVATEntry.From;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnInsertVATOnAfterAssignVATEntryFields, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnInsertVATOnAfterAssignVATEntryFields"(GenJnlLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry"; CurrExchRate: Record "Currency Exchange Rate")
    begin
        VATEntry."GST Rate" := GenJnlLine."GST Rate";
    end;


}

