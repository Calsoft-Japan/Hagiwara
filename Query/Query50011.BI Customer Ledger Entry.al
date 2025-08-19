query 50011 "BI Customer Ledger Entry"
{
    // FDD
    Caption = 'BI Customer Ledger Entry';
    QueryType = API;
    QueryCategory = 'PowerBI';
    APIPublisher = 'CalsoftJapan';
    APIGroup = 'BI';
    APIVersion = 'v1.0';
    EntityName = 'BI_Customer_Ledger_Entry';
    EntitySetName = 'BICustomerLedgerEntries';
    //DelayedInsert = false;

    elements
    {
        dataitem(CLE; "Cust. Ledger Entry")
        {
            // Fields per FDD
            column(PostingDate; "Posting Date") { }

            column(DocumentType; "Document Type") { }

            column(ExternalDocumentNo; "External Document No.") { }

            column(CustomerNo; "Customer No.") { }

            column(MessageToRecipient; "Message to Recipient") { }

            column(Description; Description) { }

            column(CurrencyCode; "Currency Code") { }

            column(RemainingAmount; "Remaining Amount") { }

            column(RemainingAmt_LCY; "Remaining Amt. (LCY)") { }

            column(DueDate; "Due Date") { }

            column(Pmt_Discount_Date; "Pmt. Discount Date") { }

            column(Pmt_Disc_Tolerance_Date; "Pmt. Disc. Tolerance Date") { }

            column(Original_Pmt_Disc_Possible; "Original Pmt. Disc. Possible") { }

            column(Remaining_Pmt_Disc_Possible; "Remaining Pmt. Disc. Possible") { }

            column(Max_Payment_Tolerance; "Max. Payment Tolerance") { }

            column(PaymentMethodCode; "Payment Method Code") { }

            column(Open; Open) { }

            column(OnHold; "On Hold") { }

            column(EntryNo; "Entry No.") { }

            column(exportedToPaymentFile; "exported to payment file") { }

            column(Amount; Amount) { }

            column(Bal_AccountNo; "Bal. Account No.") { }

            column(Bal_AccountType; "Bal. Account Type") { }

            column(DirectDebitMandateId; "Direct Debit Mandate Id") { }

            column(originalAmt_LCY; "Original Amt. (LCY)") { }

            column(ReasonCode; "Reason Code") { }

            column(Reversed; Reversed) { }

            // Ensure the field "Reversal by Entry No." exists in "Cust. Ledger Entry" table.
            // If not, use a valid field or set Method = Count.
            // Example using Method = Count:
            column(Reversal_by_Entry_No) { Method = Count; }

            column(Reversed_Entry_No; "Reversed Entry No.") { }

            column(SalespersonCode; "Salesperson Code") { }

        }
    }
}