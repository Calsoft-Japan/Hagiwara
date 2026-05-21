page 50118 "Item Import Lines"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    Caption = 'Item Import Lines';
    SourceTable = "Item Import Line";

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
                field("Type"; Rec."Type")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Familiar Name"; Rec."Familiar Name")
                {
                    ApplicationArea = all;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = all;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Sales Unit of Measure"; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Purchase Unit of Measure"; Rec."Purchase Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Price/Profit Calculation"; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = all;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = all;
                }
                field("Tariff No."; Rec."Tariff No.")
                {
                    ApplicationArea = all;
                }
                field("Reserve"; Rec."Reserve")
                {
                    ApplicationArea = all;
                }
                field("Stockout Warning"; Rec."Stockout Warning")
                {
                    ApplicationArea = all;
                }
                field("Prevent Negative Inventory"; Rec."Prevent Negative Inventory")
                {
                    ApplicationArea = all;
                }
                field("Replenishment System"; Rec."Replenishment System")
                {
                    ApplicationArea = all;
                }
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ApplicationArea = all;
                }
                field("Manufacture Code"; Rec."Manufacture Code")
                {
                    ApplicationArea = all;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Original Item No."; Rec."Original Item No.")
                {
                    ApplicationArea = all;
                }
                field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                {
                    ApplicationArea = all;
                }
                field("Country/Region of Org Cd (FE)"; Rec."Country/Region of Org Cd (FE)")
                {
                    ApplicationArea = all;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = all;
                }
                field("Products"; Rec."Products")
                {
                    ApplicationArea = all;
                }
                field("Parts No."; Rec."Parts No.")
                {
                    ApplicationArea = all;
                }
                field("PKG"; Rec."PKG")
                {
                    ApplicationArea = all;
                }
                field("Rank"; Rec."Rank")
                {
                    ApplicationArea = all;
                }
                field("SBU"; Rec."SBU")
                {
                    ApplicationArea = all;
                }
                field("Car Model"; Rec."Car Model")
                {
                    ApplicationArea = all;
                }
                field("SOP"; Rec."SOP")
                {
                    ApplicationArea = all;
                }
                field("MP-Volume(pcs/M)"; Rec."MP-Volume(pcs/M)")
                {
                    ApplicationArea = all;
                }
                field("Apl"; Rec."Apl")
                {
                    ApplicationArea = all;
                }
                field("Service Parts"; Rec."Service Parts")
                {
                    ApplicationArea = all;
                }
                field("Order Deadline Date"; Rec."Order Deadline Date")
                {
                    ApplicationArea = all;
                }
                field("EOL"; Rec."EOL")
                {
                    ApplicationArea = all;
                }
                field("Memo"; Rec."Memo")
                {
                    ApplicationArea = all;
                }
                field("EDI"; Rec."EDI")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Item No."; Rec."Customer Item No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Item No. (Plain)"; Rec."Customer Item No. (Plain)")
                {
                    ApplicationArea = all;
                }
                field("OEM No."; Rec."OEM No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Item Supplier Source"; Rec."Item Supplier Source")
                {
                    ApplicationArea = all;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = all;
                }
                field("Lot Size"; Rec."Lot Size")
                {
                    ApplicationArea = all;
                }
                field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                {
                    ApplicationArea = all;
                }
                field("Order Multiple"; Rec."Order Multiple")
                {
                    ApplicationArea = all;
                }
                field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
                {
                    ApplicationArea = all;
                }
                field("Markup%"; Rec."Markup%")
                {
                    ApplicationArea = all;
                }
                field("Markup%(Sales Price)"; Rec."Markup%(Sales Price)")
                {
                    ApplicationArea = all;
                }
                field("Markup%(Purchase Price)"; Rec."Markup%(Purchase Price)")
                {
                    ApplicationArea = all;
                }
                field("One Renesas EDI"; Rec."One Renesas EDI")
                {
                    ApplicationArea = all;
                }
                field("Excluded in Inventory Report"; Rec."Excluded in Inventory Report")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = all;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Customer Group Code"; Rec."Customer Group Code")
                {
                    ApplicationArea = all;
                }
                field("Base Currency Code"; Rec."Base Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Blocked"; Rec."Blocked")
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
                        cduImporter: Codeunit "Item Import";
                        recApprSetup: Record "Hagiwara Approval Setup";
                        ItemImportBatch: Record "Item Import Batch";
                    begin

                        if G_BatchName = '' then
                            Error('Batch Name is blank.');

                        recApprSetup.Get();
                        if recApprSetup."Item" then begin
                            ItemImportBatch.get(G_BatchName);

                            if not (ItemImportBatch."Approval Status" in [
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
                        ItemImportline: Record "Item Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                        ItemImportBatch: Record "Item Import Batch";
                    begin

                        recApprSetup.Get();
                        if recApprSetup."Item" then begin
                            ItemImportBatch.get(G_BatchName);

                            if not (ItemImportBatch."Approval Status" in [
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
                        ItemImportline.SetRange("Batch Name", G_BatchName);
                        ItemImportline.SETFILTER(ItemImportline.Status, '%1|%2', ItemImportline.Status::Pending, ItemImportline.Status::Error);
                        if ItemImportline.IsEmpty() then begin
                            Error('There is no record to validate.');
                        end;
                        */

                        // -------check record contents-------
                        ItemImportline.SetRange("Batch Name", G_BatchName);
                        if ItemImportline.FINDFIRST then
                            REPEAT
                                CheckError(ItemImportline);
                            UNTIL ItemImportline.NEXT = 0;

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
                        ItemImportBatch: Record "Item Import Batch";
                        ItemImportline: Record "Item Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        // -------check Approval Status -------
                        ItemImportBatch.GET(G_BatchName);
                        recApprSetup.Get();
                        if recApprSetup."Item" then begin

                            if not (ItemImportBatch."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                                Error('You can''t carry out the action. You need to go through approval process first.');
                            end;
                        end;

                        //Re-validate
                        if Confirm('Re-validation will be performed. Do you want to continue?') then begin

                            ItemImportline.SetRange("Batch Name", G_BatchName);
                            if ItemImportline.FINDFIRST then
                                REPEAT
                                    CheckError(ItemImportline);
                                UNTIL ItemImportline.NEXT = 0;

                        end else begin
                            exit;
                        end;

                        //commit the check error result.
                        Commit();

                        ItemImportline.SetRange("Batch Name", G_BatchName);
                        ItemImportline.SetFilter(Status, '%1|%2', ItemImportline.Status::Pending, ItemImportline.Status::Error);
                        if not ItemImportline.IsEmpty then
                            Error('Some of the lines are not validated.');

                        // -------Execute-------
                        recApprSetup."Inprogress Item" := true;
                        recApprSetup.Modify();

                        ItemImportline.SetRange("Batch Name", G_BatchName);
                        ItemImportline.SetFilter(Status, '%1', ItemImportline.Status::Validated);
                        if ItemImportline.FINDFIRST then
                            REPEAT
                                ExecuteProcess(ItemImportline);
                            UNTIL ItemImportline.NEXT = 0;

                        recApprSetup."Inprogress Item" := false;
                        recApprSetup.Modify();
                        /*
                        //FDD removed this process.
                        // delete all
                        ItemImportline.SetRange("Batch Name", G_BatchName);
                        ItemImportline.SetFilter(Status, '%1', ItemImportline.Status::Completed);
                        ItemImportline.DELETEALL;
                        */

                        Message('Carry out finished.');

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
                        ItemImportBatch: Record "Item Import Batch";
                        ItemImportline: Record "Item Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        ItemImportline.SetRange("Batch Name", G_BatchName);

                        recApprSetup.Get();
                        if recApprSetup."Item" then begin
                            ItemImportBatch.get(G_BatchName);

                            if not (ItemImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t delete any records because approval process already initiated.');
                            end;
                        end;

                        IF NOT CONFIRM('Do you want to delete all the records?') THEN
                            EXIT;

                        ItemImportline.DELETEALL;
                    end;
                }
            }
        }
    }

    var
        G_BatchName: Code[20];

    procedure SetBatchName(pBatchName: Code[20])
    begin
        G_BatchName := pBatchName;
    end;

    procedure ExecuteProcess(var p_ItemImportline: Record "Item Import Line")
    begin

        // -------Create-------
        if p_ItemImportline.Action = p_ItemImportline.Action::Create then begin
            //Create new records on the Item table.
            CreateRecordForItem(p_ItemImportline);

            //Create new records on the Item Unit of Measure table with the following mappings.
            //CreateRecordForItemUnitofMeasure(p_ItemImportline); // To create it at the same time as creating an Item by using Validate

            //Create new records on the Item Reference table with the following mappings.
            //  For Customer
            CreateRecordForItemRefCusomer(p_ItemImportline);
            //  For Vendor
            CreateRecordForItemRefVendor(p_ItemImportline);
        end;

        // -------Update-------
        if p_ItemImportline.Action = p_ItemImportline.Action::Update then begin
            //Update existing records on the Item table.
            UpdateRecordForItem(p_ItemImportline);

            //Update existing records on the Item Unit of Measure table.
            //UpdateRecordForItemUnitofMeasure(p_ItemImportline);// To create it at the same time as creating an Item by using Validate

            //Update existing records on the Item Reference table.
            //  For Customer
            UpdateRecordForItemRefCusomer(p_ItemImportline);
            //  For Vendor
            UpdateRecordForItemRefVendor(p_ItemImportline);

        end;

        //After completed, update the status to Completed. 
        p_ItemImportline.Validate(p_ItemImportline.Status, p_ItemImportline.Status::Completed);
        p_ItemImportline.Modify(true);

    end;

    //Create new records on the Item Reference table with the following mappings.
    //  For Customer
    procedure CreateRecordForItemRefCusomer(var p_ItemImportline: Record "Item Import Line")
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.INIT;
        ItemReference.Validate(ItemReference."Reference Type", "Item Reference Type"::Customer);
        ItemReference.Validate(ItemReference."Reference Type No.", p_ItemImportline."Customer No.");
        ItemReference.Validate(ItemReference."Reference No.", p_ItemImportline."Original Item No.");
        ItemReference.Validate(ItemReference."Item No.", p_ItemImportline."Item No.");
        ItemReference.Validate(ItemReference."Unit of Measure", p_ItemImportline."Base Unit of Measure");
        ItemReference.Validate(ItemReference.Description, p_ItemImportline.Description);

        ItemReference.Insert();
    end;

    //Create new records on the Item Reference table with the following mappings.
    //  For Vendor
    procedure CreateRecordForItemRefVendor(var p_ItemImportline: Record "Item Import Line")
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.INIT;
        ItemReference.Validate(ItemReference."Reference Type", "Item Reference Type"::Vendor);
        ItemReference.Validate(ItemReference."Reference Type No.", p_ItemImportline."Vendor No.");
        ItemReference.Validate(ItemReference."Reference No.", p_ItemImportline."Original Item No.");
        ItemReference.Validate(ItemReference."Item No.", p_ItemImportline."Item No.");
        ItemReference.Validate(ItemReference."Unit of Measure", p_ItemImportline."Base Unit of Measure");
        ItemReference.Validate(ItemReference.Description, p_ItemImportline.Description);

        ItemReference.Insert();
    end;

    //Create new records on the Item Unit of Measure table with the following mappings.
    procedure CreateRecordForItemUnitofMeasure(var p_ItemImportline: Record "Item Import Line")
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        ItemUnitofMeasure.INIT;
        ItemUnitofMeasure.Validate("Item No.", p_ItemImportline."Item No.");
        ItemUnitofMeasure.Validate(Code, p_ItemImportline."Base Unit of Measure");
        ItemUnitofMeasure.Validate("Qty. per Unit of Measure", 1);

        ItemUnitofMeasure.Insert();
    end;

    //Create new records on the Item table.
    procedure CreateRecordForItem(var p_ItemImportline: Record "Item Import Line")
    var
        Item: Record "Item";
        InventorySetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Item.INIT;

        if p_ItemImportline."Item No." = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField("Item Nos.");

            Item."No. Series" := InventorySetup."Item Nos.";
            Item.Validate("No.", NoSeries.GetNextNo(Item."No. Series"));
            Item.ReadIsolation(IsolationLevel::ReadUncommitted);
            Item.SetLoadFields("No.");
            while Item.Get(Item."No.") do
                item.Validate("No.", NoSeries.GetNextNo(Item."No. Series"));

            p_ItemImportline."Item No." := Item."No.";
        end else begin
            Item.Validate("No.", p_ItemImportline."Item No.");
        end;

        Item.Insert();

        Item.Validate(Type, "Item Type"::Inventory);
        Item.Validate("Costing Method", "Costing Method"::Average);
        Item.Validate("Familiar Name", p_ItemImportline."Familiar Name");
        Item.Validate(Description, p_ItemImportline."Description");
        Item.Validate("Description 2", p_ItemImportline."Description 2");
        Item.Validate("Base Unit of Measure", p_ItemImportline."Base Unit of Measure");
        Item.Validate("Sales Unit of Measure", p_ItemImportline."Sales Unit of Measure");
        Item.Validate("Purch. Unit of Measure", p_ItemImportline."Purchase Unit of Measure");
        Item.Validate("Price/Profit Calculation", p_ItemImportline."Price/Profit Calculation");
        Item.Validate("Vendor No.", p_ItemImportline."Vendor No.");
        Item.Validate("Lead Time Calculation", p_ItemImportline."Lead Time Calculation");
        Item.Validate("Tariff No.", p_ItemImportline."Tariff No.");
        Item.Validate(Reserve, p_ItemImportline."Reserve");
        Item.Validate("Stockout Warning", p_ItemImportline."Stockout Warning");
        Item.Validate("Prevent Negative Inventory", p_ItemImportline."Prevent Negative Inventory");
        Item.Validate("Replenishment System", p_ItemImportline."Replenishment System");
        Item.Validate("Item Tracking Code", p_ItemImportline."Item Tracking Code");
        Item.Validate("Manufacturer Code", p_ItemImportline."Manufacture Code");
        Item.Validate("Item Category Code", p_ItemImportline."Item Category Code");
        Item.Validate("Original Item No.", p_ItemImportline."Original Item No.");
        Item.Validate("Country/Region of Origin Code", p_ItemImportline."Country/Region of Origin Code");
        Item.Validate("Country/Region of Org Cd (FE)", p_ItemImportline."Country/Region of Org Cd (FE)");
        Item.Validate("Item Group Code", p_ItemImportline."Product Group Code");
        Item.Validate(Products, p_ItemImportline."Products");
        Item.Validate("Parts No.", p_ItemImportline."Parts No.");
        Item.Validate(PKG, p_ItemImportline."PKG");
        Item.Validate(Rank, p_ItemImportline."Rank");
        Item.Validate(SBU, p_ItemImportline."SBU");
        Item.Validate("Car Model", p_ItemImportline."Car Model");
        Item.Validate(SOP, p_ItemImportline."SOP");
        Item.Validate("MP-Volume(pcs/M)", p_ItemImportline."MP-Volume(pcs/M)");
        Item.Validate(Apl, p_ItemImportline."Apl");
        Item.Validate("Service Parts", p_ItemImportline."Service Parts");
        Item.Validate("Order Deadline Date", p_ItemImportline."Order Deadline Date");
        Item.Validate(EOL, p_ItemImportline."EOL");
        Item.Validate(Memo, p_ItemImportline."Memo");
        Item.Validate(EDI, p_ItemImportline."EDI");
        Item.Validate("Customer No.", p_ItemImportline."Customer No.");
        Item.Validate("Customer Item No.", p_ItemImportline."Customer Item No.");
        Item.Validate("Customer Item No.(Plain)", p_ItemImportline."Customer Item No. (Plain)");
        Item.Validate("OEM No.", p_ItemImportline."OEM No.");
        Item.Validate("Item Supplier Source", p_ItemImportline."Item Supplier Source");
        Item.Validate("Vendor Item No.", p_ItemImportline."Vendor Item No.");
        Item.Validate("Lot Size", p_ItemImportline."Lot Size");
        Item.Validate("Minimum Order Quantity", p_ItemImportline."Minimum Order Quantity");
        Item.Validate("Order Multiple", p_ItemImportline."Order Multiple");
        Item.Validate("Maximum Order Quantity", p_ItemImportline."Maximum Order Quantity");
        Item.Validate("Markup%", p_ItemImportline."Markup%");
        Item.Validate("Markup%(Sales Price)", p_ItemImportline."Markup%(Sales Price)");
        Item.Validate("Markup%(Purchase Price)", p_ItemImportline."Markup%(Purchase Price)");
        Item.Validate("One Renesas EDI", p_ItemImportline."One Renesas EDI");
        Item.Validate("Excluded in Inventory Report", p_ItemImportline."Excluded in Inventory Report");
        Item.Validate("Gen. Prod. Posting Group", p_ItemImportline."Gen. Prod. Posting Group");
        Item.Validate("Inventory Posting Group", p_ItemImportline."Inventory Posting Group");
        Item.Validate("VAT Prod. Posting Group", p_ItemImportline."VAT Prod. Posting Group");
        Item.Validate("Global Dimension 1 Code", p_ItemImportline."Customer Group Code");
        Item.Validate("Global Dimension 2 Code", p_ItemImportline."Base Currency Code");
        Item.Validate(Blocked, p_ItemImportline."Blocked");

        Item.Modify(true);

    end;

    //Update existing records on the Item Reference table.
    //  For Customer
    procedure UpdateRecordForItemRefCusomer(var p_ItemImportline: Record "Item Import Line")
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.SetRange("Item No.", p_ItemImportline."Item No.");
        ItemReference.SetRange("Unit of Measure", p_ItemImportline."Base Unit of Measure");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
        ItemReference.SetRange("Reference Type No.", p_ItemImportline."Customer No.");
        if ItemReference.FindFirst() then begin
            // Update
            ItemReference.Validate("Reference No.", p_ItemImportline."Original Item No.");
            ItemReference.Validate(Description, p_ItemImportline.Description);
            ItemReference.Modify(true);
        end else begin
            // Create
            ItemReference.INIT;
            ItemReference.Validate(ItemReference."Reference Type", "Item Reference Type"::Customer);
            ItemReference.Validate(ItemReference."Reference Type No.", p_ItemImportline."Customer No.");
            ItemReference.Validate(ItemReference."Reference No.", p_ItemImportline."Original Item No.");
            ItemReference.Validate(ItemReference."Item No.", p_ItemImportline."Item No.");
            ItemReference.Validate(ItemReference."Unit of Measure", p_ItemImportline."Base Unit of Measure");
            ItemReference.Validate(ItemReference.Description, p_ItemImportline.Description);

            ItemReference.Insert();
        end;

    end;

    //Update existing records on the Item Reference table.
    //  For Vendor
    procedure UpdateRecordForItemRefVendor(var p_ItemImportline: Record "Item Import Line")
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReference.SetRange("Item No.", p_ItemImportline."Item No.");
        ItemReference.SetRange("Unit of Measure", p_ItemImportline."Base Unit of Measure");
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Vendor);
        ItemReference.SetRange("Reference Type No.", p_ItemImportline."Vendor No.");
        if ItemReference.FindFirst() then begin
            // Update
            ItemReference.Validate("Reference No.", p_ItemImportline."Original Item No.");
            ItemReference.Validate(Description, p_ItemImportline.Description);
            ItemReference.Modify(true);
        end else begin
            // Create
            ItemReference.INIT;
            ItemReference.Validate(ItemReference."Reference Type", "Item Reference Type"::Vendor);
            ItemReference.Validate(ItemReference."Reference Type No.", p_ItemImportline."Vendor No.");
            ItemReference.Validate(ItemReference."Reference No.", p_ItemImportline."Original Item No.");
            ItemReference.Validate(ItemReference."Item No.", p_ItemImportline."Item No.");
            ItemReference.Validate(ItemReference."Unit of Measure", p_ItemImportline."Base Unit of Measure");
            ItemReference.Validate(ItemReference.Description, p_ItemImportline.Description);

            ItemReference.Insert();
        end;

    end;

    //Update existing records on the Item Unit of Measure table.
    procedure UpdateRecordForItemUnitofMeasure(var p_ItemImportline: Record "Item Import Line")
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        if ItemUnitofMeasure.GET(p_ItemImportline."Item No.", p_ItemImportline."Base Unit of Measure") then begin
            //Do nothing
        end else begin
            //If Base Unit of Measure Code is different from the existing one, it will be “Create” action. 
            ItemUnitofMeasure.INIT;
            ItemUnitofMeasure.Validate("Item No.", p_ItemImportline."Item No.");
            ItemUnitofMeasure.Validate(Code, p_ItemImportline."Base Unit of Measure");
            ItemUnitofMeasure.Validate("Qty. per Unit of Measure", 1);

            ItemUnitofMeasure.Insert();
        end;
    end;

    //Update existing records on the Item table.
    procedure UpdateRecordForItem(var p_ItemImportline: Record "Item Import Line")
    var
        Item: Record "Item";
    begin
        if Item.GET(p_ItemImportline."Item No.") then begin
            if Item.Type.AsInteger() <> p_ItemImportline.Type then
                item.Validate(Type, p_ItemImportline.Type);
            if Item."Familiar Name" <> p_ItemImportline."Familiar Name" then
                item.Validate("Familiar Name", p_ItemImportline."Familiar Name");
            if Item.Description <> p_ItemImportline."Description" then
                item.Validate(Description, p_ItemImportline."Description");
            if Item."Description 2" <> p_ItemImportline."Description 2" then
                item.Validate("Description 2", p_ItemImportline."Description 2");
            if Item."Base Unit of Measure" <> p_ItemImportline."Base Unit of Measure" then
                item.Validate("Base Unit of Measure", p_ItemImportline."Base Unit of Measure");
            if Item."Sales Unit of Measure" <> p_ItemImportline."Sales Unit of Measure" then
                item.Validate("Sales Unit of Measure", p_ItemImportline."Sales Unit of Measure");
            if Item."Purch. Unit of Measure" <> p_ItemImportline."Purchase Unit of Measure" then
                item.Validate("Purch. Unit of Measure", p_ItemImportline."Purchase Unit of Measure");
            if Item."Price/Profit Calculation" <> p_ItemImportline."Price/Profit Calculation" then
                item.Validate("Price/Profit Calculation", p_ItemImportline."Price/Profit Calculation");
            if Item."Lead Time Calculation" <> p_ItemImportline."Lead Time Calculation" then
                item.Validate("Lead Time Calculation", p_ItemImportline."Lead Time Calculation");
            if Item."Tariff No." <> p_ItemImportline."Tariff No." then
                item.Validate("Tariff No.", p_ItemImportline."Tariff No.");
            if Item.Reserve <> p_ItemImportline."Reserve" then
                item.Validate(Reserve, p_ItemImportline."Reserve");
            if Item."Stockout Warning" <> p_ItemImportline."Stockout Warning" then
                item.Validate("Stockout Warning", p_ItemImportline."Stockout Warning");
            if Item."Prevent Negative Inventory" <> p_ItemImportline."Prevent Negative Inventory" then
                item.Validate("Prevent Negative Inventory", p_ItemImportline."Prevent Negative Inventory");
            if Item."Replenishment System" <> p_ItemImportline."Replenishment System" then
                item.Validate("Replenishment System", p_ItemImportline."Replenishment System");
            if Item."Item Tracking Code" <> p_ItemImportline."Item Tracking Code" then
                item.Validate("Item Tracking Code", p_ItemImportline."Item Tracking Code");
            if Item."Manufacturer Code" <> p_ItemImportline."Manufacture Code" then
                item.Validate("Manufacturer Code", p_ItemImportline."Manufacture Code");
            if Item."Item Category Code" <> p_ItemImportline."Item Category Code" then
                item.Validate("Item Category Code", p_ItemImportline."Item Category Code");
            if Item."Original Item No." <> p_ItemImportline."Original Item No." then
                item.Validate("Original Item No.", p_ItemImportline."Original Item No.");
            if Item."Country/Region of Origin Code" <> p_ItemImportline."Country/Region of Origin Code" then
                item.Validate("Country/Region of Origin Code", p_ItemImportline."Country/Region of Origin Code");
            if Item."Country/Region of Org Cd (FE)" <> p_ItemImportline."Country/Region of Org Cd (FE)" then
                item.Validate("Country/Region of Org Cd (FE)", p_ItemImportline."Country/Region of Org Cd (FE)");
            if Item."Item Group Code" <> p_ItemImportline."Product Group Code" then
                item.Validate("Item Group Code", p_ItemImportline."Product Group Code");
            if Item.Products <> p_ItemImportline."Products" then
                item.Validate(Products, p_ItemImportline."Products");
            if Item."Parts No." <> p_ItemImportline."Parts No." then
                item.Validate("Parts No.", p_ItemImportline."Parts No.");
            if Item.PKG <> p_ItemImportline."PKG" then
                item.Validate(PKG, p_ItemImportline."PKG");
            if Item.Rank <> p_ItemImportline."Rank" then
                item.Validate(Rank, p_ItemImportline."Rank");
            if Item.SBU <> p_ItemImportline."SBU" then
                item.Validate(SBU, p_ItemImportline."SBU");
            if Item."Car Model" <> p_ItemImportline."Car Model" then
                item.Validate("Car Model", p_ItemImportline."Car Model");
            if Item.SOP <> p_ItemImportline."SOP" then
                item.Validate(SOP, p_ItemImportline."SOP");
            if Item."MP-Volume(pcs/M)" <> p_ItemImportline."MP-Volume(pcs/M)" then
                item.Validate("MP-Volume(pcs/M)", p_ItemImportline."MP-Volume(pcs/M)");
            if Item.Apl <> p_ItemImportline."Apl" then
                item.Validate(Apl, p_ItemImportline."Apl");
            if Item."Service Parts" <> p_ItemImportline."Service Parts" then
                item.Validate("Service Parts", p_ItemImportline."Service Parts");
            if Item."Order Deadline Date" <> p_ItemImportline."Order Deadline Date" then
                item.Validate("Order Deadline Date", p_ItemImportline."Order Deadline Date");
            if Item.EOL <> p_ItemImportline."EOL" then
                item.Validate(EOL, p_ItemImportline."EOL");
            if Item.Memo <> p_ItemImportline."Memo" then
                item.Validate(Memo, p_ItemImportline."Memo");
            if Item.EDI <> p_ItemImportline."EDI" then
                item.Validate(EDI, p_ItemImportline."EDI");
            if Item."Customer No." <> p_ItemImportline."Customer No." then
                item.Validate("Customer No.", p_ItemImportline."Customer No.");
            if Item."Customer Item No." <> p_ItemImportline."Customer Item No." then
                item.Validate("Customer Item No.", p_ItemImportline."Customer Item No.");
            if Item."Customer Item No.(Plain)" <> p_ItemImportline."Customer Item No. (Plain)" then
                item.Validate("Customer Item No.(Plain)", p_ItemImportline."Customer Item No. (Plain)");
            if Item."OEM No." <> p_ItemImportline."OEM No." then
                item.Validate("OEM No.", p_ItemImportline."OEM No.");
            if Item."Vendor No." <> p_ItemImportline."Vendor No." then
                item.Validate("Vendor No.", p_ItemImportline."Vendor No.");
            if Item."Item Supplier Source" <> p_ItemImportline."Item Supplier Source" then
                item.Validate("Item Supplier Source", p_ItemImportline."Item Supplier Source");
            if Item."Vendor Item No." <> p_ItemImportline."Vendor Item No." then
                item.Validate("Vendor Item No.", p_ItemImportline."Vendor Item No.");
            if Item."Lot Size" <> p_ItemImportline."Lot Size" then
                item.Validate("Lot Size", p_ItemImportline."Lot Size");
            if Item."Minimum Order Quantity" <> p_ItemImportline."Minimum Order Quantity" then
                item.Validate("Minimum Order Quantity", p_ItemImportline."Minimum Order Quantity");
            if Item."Order Multiple" <> p_ItemImportline."Order Multiple" then
                item.Validate("Order Multiple", p_ItemImportline."Order Multiple");
            if Item."Maximum Order Quantity" <> p_ItemImportline."Maximum Order Quantity" then
                item.Validate("Maximum Order Quantity", p_ItemImportline."Maximum Order Quantity");
            if Item."Markup%" <> p_ItemImportline."Markup%" then
                item.Validate("Markup%", p_ItemImportline."Markup%");
            if Item."Markup%(Sales Price)" <> p_ItemImportline."Markup%(Sales Price)" then
                item.Validate("Markup%(Sales Price)", p_ItemImportline."Markup%(Sales Price)");
            if Item."Markup%(Purchase Price)" <> p_ItemImportline."Markup%(Purchase Price)" then
                item.Validate("Markup%(Purchase Price)", p_ItemImportline."Markup%(Purchase Price)");
            if Item."One Renesas EDI" <> p_ItemImportline."One Renesas EDI" then
                item.Validate("One Renesas EDI", p_ItemImportline."One Renesas EDI");
            if Item."Excluded in Inventory Report" <> p_ItemImportline."Excluded in Inventory Report" then
                item.Validate("Excluded in Inventory Report", p_ItemImportline."Excluded in Inventory Report");
            if Item."Gen. Prod. Posting Group" <> p_ItemImportline."Gen. Prod. Posting Group" then
                item.Validate("Gen. Prod. Posting Group", p_ItemImportline."Gen. Prod. Posting Group");
            if Item."Inventory Posting Group" <> p_ItemImportline."Inventory Posting Group" then
                item.Validate("Inventory Posting Group", p_ItemImportline."Inventory Posting Group");
            if Item."VAT Prod. Posting Group" <> p_ItemImportline."VAT Prod. Posting Group" then
                item.Validate("VAT Prod. Posting Group", p_ItemImportline."VAT Prod. Posting Group");
            if Item."Global Dimension 1 Code" <> p_ItemImportline."Customer Group Code" then
                item.Validate("Global Dimension 1 Code", p_ItemImportline."Customer Group Code");
            if Item."Global Dimension 2 Code" <> p_ItemImportline."Base Currency Code" then
                item.Validate("Global Dimension 2 Code", p_ItemImportline."Base Currency Code");
            if Item.Blocked <> p_ItemImportline."Blocked" then
                item.Validate(Blocked, p_ItemImportline."Blocked");

            Item.Modify(true);
        end;
    end;

    procedure CheckError(var p_ItemImportline: Record "Item Import Line")
    var
        //bIsCreate: Boolean;
        ErrDesc: Text[1024];//the total of error message is over of ( [Table – Item Import Line]'[Error Description] length : 250)
        Item: Record "Item";
        UnitOfMeasure: Record "Unit of Measure";
        Manufacturer: Record "Manufacturer";
        ItemCategory: Record "Item Category";
        ItemTracking: Record "Item Tracking Code";
        CountryRegion: Record "Country/Region";
        ItemGroup: Record "Item Group";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
        VATProdPostingGroup: Record "VAT Product Posting Group";
        GlobalDimension1Code: Record "Dimension Value";
        GlobalDimension2Code: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        // -------Existence Check (See table relation info.)-------
        GLSetup.Get();
        //Base Unit of Measure Code
        if p_ItemImportline."Base Unit of Measure" <> '' then begin
            if not UnitOfMeasure.get(p_ItemImportline."Base Unit of Measure") then begin
                ErrDesc := 'Base Unit of Measure is not found. ';
            end;
        end;
        //Sales Unit of Measure Code
        if p_ItemImportline."Sales Unit of Measure" <> '' then begin
            if not UnitOfMeasure.get(p_ItemImportline."Sales Unit of Measure") then begin
                ErrDesc += 'Sales Unit of Measure is not found. ';
            end;
        end;
        //Purchase Unit of Measure Code
        if p_ItemImportline."Purchase Unit of Measure" <> '' then begin
            if not UnitOfMeasure.get(p_ItemImportline."Purchase Unit of Measure") then begin
                ErrDesc += 'Purchase Unit of Measure is not found. ';
            end;
        end;
        //Manufacturer Code
        if p_ItemImportline."Manufacture Code" <> '' then begin
            if not Manufacturer.get(p_ItemImportline."Manufacture Code") then begin
                ErrDesc += 'Manufacture Code is not found. ';
            end;
        end;
        //Item Tracking Code
        if p_ItemImportline."Item Tracking Code" <> '' then begin
            if not ItemTracking.get(p_ItemImportline."Item Tracking Code") then begin
                ErrDesc += 'Item Tracking Code is not found. ';
            end;
        end;
        //Item Category Code
        if p_ItemImportline."Item Category Code" <> '' then begin
            if not ItemCategory.get(p_ItemImportline."Item Category Code") then begin
                ErrDesc += 'Item Category Code is not found. ';
            end;
        end;
        //Country/Region of Origin Code
        if p_ItemImportline."Country/Region of Origin Code" <> '' then begin
            if not CountryRegion.get(p_ItemImportline."Country/Region of Origin Code") then begin
                ErrDesc += 'Country/Region of Origin Code is not found. ';
            end;
        end;
        //Country/Region of Org Cd (FE)
        if p_ItemImportline."Country/Region of Org Cd (FE)" <> '' then begin
            if not CountryRegion.get(p_ItemImportline."Country/Region of Org Cd (FE)") then begin
                ErrDesc += 'Country/Region of Org Cd (FE) is not found. ';
            end;
        end;
        //Product Group Code
        if p_ItemImportline."Product Group Code" <> '' then begin
            if not ItemGroup.get(p_ItemImportline."Product Group Code") then begin
                ErrDesc += 'Product Group Code is not found. ';
            end;
        end;
        //SBU
        if p_ItemImportline.SBU <> '' then begin
            if not Manufacturer.get(p_ItemImportline.SBU) then begin
                ErrDesc += 'SBU is not found. ';
            end;
        end;
        //Customer No.
        if p_ItemImportline."Customer No." <> '' then begin
            if not Customer.get(p_ItemImportline."Customer No.") then begin
                ErrDesc += 'Customer No. is not found. ';
            end;
        end;
        //OEM No.
        if p_ItemImportline."OEM No." <> '' then begin
            Customer.SetRange(Customer."No.", p_ItemImportline."OEM No.");
            Customer.SetRange(Customer."Customer Type", Customer."Customer Type"::OEM);
            if Customer.IsEmpty() then begin
                ErrDesc += 'OEM No. is not found. ';
            end;
        end;
        //Vendor No.
        if p_ItemImportline."Vendor No." <> '' then begin
            if not Vendor.get(p_ItemImportline."Vendor No.") then begin
                ErrDesc += 'Vendor No. is not found. ';
            end;
        end;
        //Gen. Prod. Posting Group
        if p_ItemImportline."Gen. Prod. Posting Group" <> '' then begin
            if not GenProductPostingGroup.get(p_ItemImportline."Gen. Prod. Posting Group") then begin
                ErrDesc += 'Gen. Prod. Posting Group is not found. ';
            end;
        end;
        //Inventory Posting Group
        if p_ItemImportline."Inventory Posting Group" <> '' then begin
            if not InventoryPostingGroup.get(p_ItemImportline."Inventory Posting Group") then begin
                ErrDesc += 'Inventory Posting Group is not found. ';
            end;
        end;
        //VAT Prod. Posting Group
        if p_ItemImportline."VAT Prod. Posting Group" <> '' then begin
            if not VATProdPostingGroup.get(p_ItemImportline."VAT Prod. Posting Group") then begin
                ErrDesc += 'VAT Prod. Posting Group is not found. ';
            end;
        end;
        //Global Dimension 1 Code
        if p_ItemImportline."Customer Group Code" <> '' then begin
            if not GlobalDimension1Code.get(GLSetup."Global Dimension 1 Code", p_ItemImportline."Customer Group Code") then begin
                ErrDesc += 'Customer Group Code is not found. ';
            end;
        end;
        //Global Dimension 2 Code
        if p_ItemImportline."Base Currency Code" <> '' then begin
            if not GlobalDimension2Code.get(GLSetup."Global Dimension 2 Code", p_ItemImportline."Base Currency Code") then begin
                ErrDesc += 'Base Currency Code is not found. ';
            end;
        end;

        // -------Option Value Check-------

        // -------the result of Validation-------
        if (ErrDesc <> '') then begin
            p_ItemImportline."Error Description" := CopyStr(ErrDesc, 1, 250);
            p_ItemImportline.Validate(p_ItemImportline.Status, p_ItemImportline.Status::Error);
        end else begin
            p_ItemImportline."Error Description" := '';
            //Create or Update
            p_ItemImportline.Action := p_ItemImportline.Action::Update;
            if not Item.get(p_ItemImportline."Item No.") then begin
                p_ItemImportline.Action := p_ItemImportline.Action::Create;
            end;

            p_ItemImportline.Validate(p_ItemImportline.Status, p_ItemImportline.Status::Validated);
        end;
        p_ItemImportline.Modify(true);

    end;

}
