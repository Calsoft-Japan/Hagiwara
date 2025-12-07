
page 50107 "Price List Import Lines"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    Caption = 'Price List Import Lines';
    SourceTable = "Price List Import Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Starting Date "; Rec."Starting Date ")
                {
                    ApplicationArea = all;
                }
                field("Ending Date "; Rec."Ending Date ")
                {
                    ApplicationArea = all;
                }
                field("Product Type"; Rec."Product Type")
                {
                    ApplicationArea = all;
                }
                field("Product No."; Rec."Product No.")
                {
                    ApplicationArea = all;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Sales Currency Code"; Rec."Sales Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Margin%"; Rec."Margin%")
                {
                    ApplicationArea = all;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Purchase Currency Code"; Rec."Purchase Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = all;
                }
                field("Defines"; Rec."Defines")
                {
                    ApplicationArea = all;
                }
                field("Renesas Report Unit Price Cur."; Rec."Renesas Report Unit Price Cur.")
                {
                    ApplicationArea = all;
                }
                field("Renesas Report Unit Price"; Rec."Renesas Report Unit Price")
                {
                    ApplicationArea = all;
                }
                field("ORE Debit Cost"; Rec."ORE Debit Cost")
                {
                    ApplicationArea = all;
                }
                field("Ship&Debit Flag"; Rec."Ship&Debit Flag")
                {
                    ApplicationArea = all;
                }
                field("PC. Currency Code"; Rec."PC. Currency Code")
                {
                    ApplicationArea = all;
                }
                field("PC. Direct Unit Cost"; Rec."PC. Direct Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("PC. Update Price"; Rec."PC. Update Price")
                {
                    ApplicationArea = all;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = all;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = all;
                }
                field("Allow Invoice Disc. "; Rec."Allow Invoice Disc. ")
                {
                    ApplicationArea = all;
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = all;
                }
                field("Price Line Status"; Rec."Price Line Status")
                {
                    ApplicationArea = all;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                }
                field("Action"; Rec."Action")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Purchase)
            {
                action(Import)
                {
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        cduImporter: Codeunit "Price List Import";
                        recApprSetup: Record "Hagiwara Approval Setup";
                        PriceListImportBatch: Record "Price List Import Batch";
                    begin

                        if G_BatchName = '' then
                            Error('Batch Name is blank.');

                        recApprSetup.Get();
                        if recApprSetup."Price List" then begin
                            PriceListImportBatch.get(G_BatchName);

                            if not (PriceListImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t import any records because approval process already initiated.');
                            end;
                        end;

                        cduImporter.SetBatchName(G_BatchName);
                        cduImporter.Run();
                    end;

                }
                action(Validate)
                {
                    Image = ViewCheck;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PriceListImportline: Record "Price List Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                        PriceListImportBatch: Record "Price List Import Batch";
                    begin

                        recApprSetup.Get();
                        if recApprSetup."Price List" then begin
                            PriceListImportBatch.get(G_BatchName);

                            if not (PriceListImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t validate because approval process already initiated.');
                            end;
                        end;

                        /*
                        //FDD removed this check
                        // -------check records existe-------                        
                        PriceListImportline.SetRange("Batch Name", G_BatchName);
                        PriceListImportline.SETFILTER(PriceListImportline.Status, '%1|%2', PriceListImportline.Status::Pending, PriceListImportline.Status::Error);
                        if PriceListImportline.IsEmpty() then begin
                            Error('There is no record to validate.');
                        end;
                        */

                        // -------check record contents-------
                        Clear(PriceListNoList);
                        PriceListImportline.SetRange("Batch Name", G_BatchName);
                        if PriceListImportline.FINDFIRST then
                            REPEAT
                                CheckError(PriceListImportline);
                            UNTIL PriceListImportline.NEXT = 0;

                        Message('Validation finished.');
                    end;
                }
                action("Carry Out")
                {
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PriceListImportBatch: Record "Price List Import Batch";
                        PriceListImportline: Record "Price List Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        // -------check Approval Status -------
                        PriceListImportBatch.GET(G_BatchName);
                        recApprSetup.Get();
                        if recApprSetup."Price List" then begin

                            if not (PriceListImportBatch."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                                Error('You can''t carry out the action. You need to go through approval process first.');
                            end;

                            //Re-validate
                            if Confirm('Re-validation will be performed. Do you want to continue?') then begin

                                // -------check record contents-------
                                Clear(PriceListNoList);
                                PriceListImportline.SetRange("Batch Name", G_BatchName);

                                if PriceListImportline.FINDFIRST then
                                    REPEAT
                                        CheckError(PriceListImportline);
                                    UNTIL PriceListImportline.NEXT = 0;

                            end else begin
                                exit;
                            end;

                            //commit the check error result.
                            Commit();

                            PriceListImportline.SetRange("Batch Name", G_BatchName);
                            PriceListImportline.SetFilter(Status, '%1|%2', PriceListImportline.Status::Pending, PriceListImportline.Status::Error);
                            if not PriceListImportline.IsEmpty then
                                Error('Some of the lines are not validated.');

                            // -------Execute-------
                            PriceListImportline.SetRange("Batch Name", G_BatchName);
                            PriceListImportline.SetFilter(Status, '%1', PriceListImportline.Status::Validated);
                            if PriceListImportline.FINDFIRST then
                                REPEAT
                                    ExecuteProcess(PriceListImportline);
                                UNTIL PriceListImportline.NEXT = 0;

                            /*
                            //FDD removed this process.
                            // delete all
                            PriceListImportline.SetRange("Batch Name", G_BatchName);
                            PriceListImportline.SetFilter(Status, '%1', PriceListImportline.Status::Completed);
                            PriceListImportline.DELETEALL;
                            */

                            Message('Carry out finished.');
                        end;
                    end;
                }
                action("Delete All")
                {
                    ApplicationArea = All;
                    Caption = 'Delete All';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PriceListImportBatch: Record "Price List Import Batch";
                        PriceListImportline: Record "Price List Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        PriceListImportline.SetRange("Batch Name", G_BatchName);

                        recApprSetup.Get();
                        if recApprSetup."Price List" then begin
                            PriceListImportBatch.get(G_BatchName);

                            if not (PriceListImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t delete any records because approval process already initiated.');
                            end;
                        end;

                        IF NOT CONFIRM('Do you want to delete all the records?') THEN
                            EXIT;

                        PriceListImportline.DELETEALL;
                    end;
                }
            }
        }
    }

    var
        G_BatchName: Code[20];
        PriceListNoList: List of [Text];

    procedure SetBatchName(pBatchName: Code[20])
    begin
        G_BatchName := pBatchName;
    end;

    procedure ExecuteProcess(var p_PriceListImportline: Record "Price List Import Line")
    begin

        // -------Create-------
        if p_PriceListImportline.Action = p_PriceListImportline.Action::Create then begin
            //If Price List Import Line. No. is blank, use the default No. Series.
            CreateRecordForPriceList(p_PriceListImportline);

        end;

        // -------Update-------
        if p_PriceListImportline.Action = p_PriceListImportline.Action::Update then begin
            UpdateRecordForPriceList(p_PriceListImportline);

        end;

        //After completed, update the status to Completed. 
        p_PriceListImportline.Validate(p_PriceListImportline.Status, p_PriceListImportline.Status::Completed);
        p_PriceListImportline.Modify(true);

    end;

    //Create new records on the PriceList table.
    procedure CreateRecordForPriceList(var p_PriceListImportline: Record "Price List Import Line")
    var
        PriceListRecord: Record "Price List Line";
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        PriceListRecord.INIT;
        //ToDo
        PriceListRecord.Modify();
    end;

    //Update existing records on the PriceList table.
    procedure UpdateRecordForPriceList(var p_PriceListImportline: Record "Price List Import Line")
    var
        PriceListRecord: Record "Price List Line";
    begin
        //Todo
        PriceListRecord.Modify(true);
    end;


    procedure CheckError(var p_PriceListImportline: Record "Price List Import Line")
    var
    begin
        //todo

    end;

}
