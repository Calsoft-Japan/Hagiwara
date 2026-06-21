page 50161 "PurchRcptLine4DataMigration"
{
    ApplicationArea = All;
    Caption = 'Purch Rcpt Line For Data Migration';
    PageType = List;
    SourceTable = "PurchRcptLine4DataMigration";
    UsageCategory = Lists;
    Permissions = TableData 121 = rimd;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Customer Item No."; Rec."Customer Item No.")
                {
                }
                field("Parts No."; Rec."Parts No.")
                {
                }
                field(Rank; Rec.Rank)
                {
                }
                field(Products; Rec.Products)
                {
                }
                field("SO No."; Rec."SO No.")
                {
                }
                field("Goods Arrival Date"; Rec."Goods Arrival Date")
                {
                }
                field("Receipt Seq. No."; Rec."Receipt Seq. No.")
                {
                }
                field("CO No."; Rec."CO No.")
                {
                }
                field("Item Supplier Source"; Rec."Item Supplier Source")
                {
                }
                field("Message Status"; Rec."Message Status")
                {
                }
                field("Update Date"; Rec."Update Date")
                {
                }
                field("Update Time"; Rec."Update Time")
                {
                }
                field("Update By"; Rec."Update By")
                {
                }
                field("Save Posting Date"; Rec."Save Posting Date")
                {
                }
                field("Next Receipt Seq. No."; Rec."Next Receipt Seq. No.")
                {
                }
                field("Post Shipment Collect Flag"; Rec."Post Shipment Collect Flag")
                {
                }
                field(Insertion; Rec.Insertion)
                {
                }
                field(Edition; Rec.Edition)
                {
                }
                field("Original Quantity"; Rec."Original Quantity")
                {
                }
                field("Prev Quantity"; Rec."Prev Quantity")
                {
                }
                field("Edit Count"; Rec."Edit Count")
                {
                }
                field("Receipt Collection Date"; Rec."Receipt Collection Date")
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UpdatePurchRcptLines)
            {
                ApplicationArea = All;
                Caption = 'Update Purch Rcpt Lines';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecPurchRcptLine: Record "Purch. Rcpt. Line";
                    RecPurchRcptLine4DataMigration: Record PurchRcptLine4DataMigration;
                begin
                    if not Confirm('This action will update all extension fields of Purchase Receipt Lines. \Depending on the amount of data, the process may take a considerable amount of time.\Are you sure you want to continue?') then
                        exit;

                    RecPurchRcptLine4DataMigration.Reset();
                    if RecPurchRcptLine4DataMigration.FindSet() then
                        repeat
                            if RecPurchRcptLine.Get(RecPurchRcptLine4DataMigration."Document No.", RecPurchRcptLine4DataMigration."Line No.") then begin
                                RecPurchRcptLine."Customer Item No." := RecPurchRcptLine4DataMigration."Customer Item No.";
                                RecPurchRcptLine."Parts No." := RecPurchRcptLine4DataMigration."Parts No.";
                                RecPurchRcptLine."Rank" := RecPurchRcptLine4DataMigration."Rank";
                                RecPurchRcptLine."Products" := RecPurchRcptLine4DataMigration."Products";
                                RecPurchRcptLine."SO No." := RecPurchRcptLine4DataMigration."SO No.";
                                RecPurchRcptLine."Goods Arrival Date" := RecPurchRcptLine4DataMigration."Goods Arrival Date";
                                RecPurchRcptLine."Receipt Seq. No." := RecPurchRcptLine4DataMigration."Receipt Seq. No.";
                                RecPurchRcptLine."CO No." := RecPurchRcptLine4DataMigration."CO No.";
                                RecPurchRcptLine."Item Supplier Source" := RecPurchRcptLine4DataMigration."Item Supplier Source";
                                RecPurchRcptLine."Message Status" := RecPurchRcptLine4DataMigration."Message Status";
                                RecPurchRcptLine."Update Date" := RecPurchRcptLine4DataMigration."Update Date";
                                RecPurchRcptLine."Update Time" := RecPurchRcptLine4DataMigration."Update Time";
                                RecPurchRcptLine."Update By" := RecPurchRcptLine4DataMigration."Update By";
                                RecPurchRcptLine."Save Posting Date" := RecPurchRcptLine4DataMigration."Save Posting Date";
                                RecPurchRcptLine."Next Receipt Seq. No." := RecPurchRcptLine4DataMigration."Next Receipt Seq. No.";
                                RecPurchRcptLine."Post Shipment Collect Flag" := RecPurchRcptLine4DataMigration."Post Shipment Collect Flag";
                                RecPurchRcptLine."Insertion" := RecPurchRcptLine4DataMigration."Insertion";
                                RecPurchRcptLine."Edition" := RecPurchRcptLine4DataMigration."Edition";
                                RecPurchRcptLine."Original Quantity" := RecPurchRcptLine4DataMigration."Original Quantity";
                                RecPurchRcptLine."Prev Quantity" := RecPurchRcptLine4DataMigration."Prev Quantity";
                                RecPurchRcptLine."Edit Count" := RecPurchRcptLine4DataMigration."Edit Count";
                                RecPurchRcptLine."Receipt Collection Date" := RecPurchRcptLine4DataMigration."Receipt Collection Date";
                                RecPurchRcptLine."Purchaser Code" := RecPurchRcptLine4DataMigration."Purchaser Code";
                                RecPurchRcptLine."Country/Region of Origin Code" := RecPurchRcptLine4DataMigration."Country/Region of Origin Code";
                                RecPurchRcptLine.Modify();
                            end;
                        until RecPurchRcptLine4DataMigration.Next() = 0;

                    Message('Update Purch. Rcpt. Lines finished.');

                end;
            }
            action("Delete All")
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                Image = Delete;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecPurchRcptLine4DataMigration: Record PurchRcptLine4DataMigration;
                begin
                    IF NOT CONFIRM('Do you want to delete all the records?') THEN
                        EXIT;

                    RecPurchRcptLine4DataMigration.DELETEALL;
                end;
            }
        }
    }
}
