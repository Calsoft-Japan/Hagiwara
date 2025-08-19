query 50012 "BI Vendor Ledger Entry"
{
    // FDD
    Caption = 'BI Vendor Ledger Entry';
    QueryType = API;
    //QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Vendor_Ledger_Entry';
    EntitySetName = 'BIVendorLedgerEntries';
    //DelayedInsert = false;

    elements
    {
        dataitem(VLE; "Vendor Ledger Entry")
        {
            // Fields per FDD
            column(PostingDate; "Posting Date") { }
            column(DocumentType; "Document Type") { }
            column(DocumentNo; "Document No.") { }
            column(ExternalDocumentNo; "External Document No.") { }
            column(VendorNo; "Vendor No.") { }
            column(MessageToRecipient; "Message to Recipient") { }
            column(Description; Description) { }
            column(CurrencyCode; "Currency Code") { }
            column(PaymentMethodCode; "Payment Method Code") { }
            column(PaymentReference; "Payment Reference") { }
            column(CreditorNo; "Creditor No.") { }
            column(OriginalAmount; "Original Amount") { }

            column(AppliesToDocType; "Applies-to Doc. Type") { }
            column(AppliesToDocNo; "Applies-to Doc. No.") { }
            column(Amount; Amount) { }
            column(RemainingAmount; "Remaining Amount") { }
            column(RemainingAmtLCY; "Remaining Amt. (LCY)") { }
            column(DocumentDate; "Document Date") { }
            column(DueDate; "Due Date") { }
            column(PmtDiscountDate; "Pmt. Discount Date") { }
            column(PmtDiscToleranceDate; "Pmt. Disc. Tolerance Date") { }
            column(OriginalPmtDiscPossible; "Original Pmt. Disc. Possible") { }
            column(RemainingPmtDiscPossible; "Remaining Pmt. Disc. Possible") { }
            column(MaxPaymentTolerance; "Max. Payment Tolerance") { }
            column(Open; Open) { }
            column(OnHold; "On Hold") { }
            column(EntryNo; "Entry No.") { }
            column(ExportedToPaymentFile; "Exported to Payment File") { }
            column(AmountLCY; "Amount (LCY)") { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(BalAccountType; "Bal. Account Type") { }
            column(OriginalAmtLCY; "Original Amt. (LCY)") { }
            column(PurchaserCode; "Purchaser Code") { }
            column(ReasonCode; "Reason Code") { }
            column(Reversed; Reversed) { }
            column(ReversedByEntryNo; "Reversed by Entry No.") { }
            column(ReversedEntryNo; "Reversed Entry No.") { }
            column(SourceCode; "Source Code") { }
            column(UserID; "User ID") { }

        }
    }
}