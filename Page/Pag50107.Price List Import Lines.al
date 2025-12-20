
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
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Ending Date"; Rec."Ending Date")
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
                field("Sales Price (LCY)"; Rec."Sales Price (LCY)")
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
                field("Purchase Price (LCY)"; Rec."Purchase Price (LCY)")
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
                        recPriceListHeader: Record "Price List Header";
                        recPriceListLine: Record "Price List Line";
                        SalesPriceLineNoStarter: Integer;
                        PurchPriceLineNoStarter: Integer;
                    begin
                        // -------check Approval Status -------
                        PriceListImportBatch.GET(G_BatchName);
                        recApprSetup.Get();
                        if recApprSetup."Price List" then begin

                            if not (PriceListImportBatch."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                                Error('You can''t carry out the action. You need to go through approval process first.');
                            end;
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
                        recPriceListHeader.SetRange("Price Type", Enum::"Price Type"::Purchase);
                        recPriceListHeader.SetRange(Code, G_PurchPriceCode);
                        if recPriceListHeader.IsEmpty() then
                            Error(PriceList_NotFoundMsg, 'Purchase', G_PurchPriceCode);

                        recPriceListHeader.SetRange("Price Type", Enum::"Price Type"::Sale);
                        recPriceListHeader.SetRange(Code, G_SalesPriceCode);
                        if recPriceListHeader.IsEmpty() then
                            Error(PriceList_NotFoundMsg, 'Sales', G_SalesPriceCode);

                        recPriceListLine.SetRange("Price List Code", G_PurchPriceCode);
                        if recPriceListLine.FindLast() then begin
                            PurchPriceLineNoStarter := recPriceListLine."Line No." + 10000;
                        end else begin
                            PurchPriceLineNoStarter := 10000;
                        end;

                        recPriceListLine.SetRange("Price List Code", G_SalesPriceCode);
                        if recPriceListLine.FindLast() then begin
                            SalesPriceLineNoStarter := recPriceListLine."Line No." + 10000;
                        end else begin
                            SalesPriceLineNoStarter := 10000;
                        end;

                        PriceListImportline.SetRange("Batch Name", G_BatchName);
                        PriceListImportline.SetFilter(Status, '%1', PriceListImportline.Status::Validated);
                        if PriceListImportline.FINDFIRST then
                            REPEAT
                                recPriceListLine.Reset();
                                recPriceListLine.SetRange("Price Type", Enum::"Price Type"::Purchase);
                                recPriceListLine.SetRange("Price List Code", G_PurchPriceCode);
                                recPriceListLine.SetRange("Asset Type", PriceListImportline."Product Type");
                                recPriceListLine.SetRange("Product No.", PriceListImportline."Product No.");
                                recPriceListLine.SetRange("Starting Date", PriceListImportline."Starting Date");
                                recPriceListLine.SetRange("Currency Code", PriceListImportline."Purchase Currency Code");
                                if recPriceListLine.IsEmpty() then begin
                                    CreatePurchPriceListLines(PriceListImportline, PurchPriceLineNoStarter);
                                    PurchPriceLineNoStarter += 10000;
                                end else begin
                                    recPriceListLine.FindFirst();
                                    UpdatePurchPriceListLines(PriceListImportline, recPriceListLine);
                                end;

                                recPriceListLine.Reset();
                                recPriceListLine.SetRange("Price Type", Enum::"Price Type"::Sale);
                                recPriceListLine.SetRange("Price List Code", G_SalesPriceCode);
                                recPriceListLine.SetRange("Asset Type", PriceListImportline."Product Type");
                                recPriceListLine.SetRange("Product No.", PriceListImportline."Product No.");
                                recPriceListLine.SetRange("Starting Date", PriceListImportline."Starting Date");
                                recPriceListLine.SetRange("Currency Code", PriceListImportline."Sales Currency Code");
                                if recPriceListLine.IsEmpty() then begin
                                    CreateSalesPriceListLines(PriceListImportline, SalesPriceLineNoStarter);
                                    SalesPriceLineNoStarter += 10000;
                                end else begin
                                    recPriceListLine.FindFirst();
                                    UpdateSalesPriceListLines(PriceListImportline, recPriceListLine);
                                end;

                                PriceListImportline.Validate(Status, PriceListImportline.Status::Completed);
                                PriceListImportline.Modify();

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
        G_SalesPriceCode: Code[20];
        G_PurchPriceCode: Code[20];
        G_ZeroPriceMargin: Decimal;
        PriceListNoList: List of [Text];
        NotFoundMsg: Label '%1 is not found. ';
        PriceList_NotFoundMsg: Label '%1 Price List %2 is not found. ';


    trigger OnInit()
    begin
        G_SalesPriceCode := 'S00001';
        G_PurchPriceCode := 'P00001';
        G_ZeroPriceMargin := -99999;
    end;

    procedure SetBatchName(pBatchName: Code[20])
    begin
        G_BatchName := pBatchName;
    end;


    //Create new records on the PriceList table.
    procedure CreatePurchPriceListLines(var p_PriceListImportline: Record "Price List Import Line"; p_LineNoStarter: Integer)
    var
        recPriceListLine: Record "Price List Line";
    begin
        recPriceListLine.INIT;
        recPriceListLine."Price List Code" := G_PurchPriceCode;
        recPriceListLine."Line No." := p_LineNoStarter;
        recPriceListLine.Validate("Price Type", Enum::"Price Type"::Purchase);
        recPriceListLine.Validate("Amount Type", Enum::"Price Amount Type"::Any); //Defines, Any means "Price & Discount";
        recPriceListLine.Validate("Source Type", Enum::"Price Source Type"::Vendor);
        recPriceListLine.Validate("Source No.", p_PriceListImportline."Vendor No.");
        recPriceListLine.Validate("Asset Type", p_PriceListImportline."Product Type");
        recPriceListLine.Validate("Product No.", p_PriceListImportline."Product No.");
        recPriceListLine.Validate("Description", GetProductDesc(p_PriceListImportline));
        recPriceListLine.Validate("Direct Unit Cost", p_PriceListImportline."Direct Unit Cost");
        recPriceListLine.Validate("Currency Code", p_PriceListImportline."Purchase Currency Code");
        recPriceListLine.Validate("Starting Date", p_PriceListImportline."Starting Date");
        recPriceListLine.Validate("Ending Date", p_PriceListImportline."Ending Date");
        recPriceListLine.Validate("Unit of Measure Code", p_PriceListImportline."Unit of Measure Code");
        recPriceListLine.Validate("Renesas Report Unit Price", p_PriceListImportline."Renesas Report Unit Price");
        recPriceListLine.Validate("ORE Debit Cost", p_PriceListImportline."ORE Debit Cost");
        recPriceListLine.Validate("Ship&Debit Flag", p_PriceListImportline."Ship&Debit Flag");
        recPriceListLine.Validate("PC. Currency Code", p_PriceListImportline."PC. Currency Code");
        recPriceListLine.Validate("PC. Direct Unit Cost", p_PriceListImportline."PC. Direct Unit Cost");
        recPriceListLine.Validate("PC. Update Price", p_PriceListImportline."PC. Update Price");

        recPriceListLine.Insert(true);

        recPriceListLine.Validate("Status", Enum::"Price Status"::Active);
        recPriceListLine.Modify(true);
    end;

    //Create new records on the PriceList table.
    procedure UpdatePurchPriceListLines(var p_PriceListImportline: Record "Price List Import Line"; var recPriceListLine: Record "Price List Line")
    begin

        recPriceListLine.Validate("Ending Date", p_PriceListImportline."Ending Date");
        recPriceListLine.Validate("Direct Unit Cost", p_PriceListImportline."Direct Unit Cost");
        recPriceListLine.Validate("Currency Code", p_PriceListImportline."Purchase Currency Code");
        recPriceListLine.Validate("Unit of Measure Code", p_PriceListImportline."Unit of Measure Code");
        recPriceListLine.Validate("Renesas Report Unit Price", p_PriceListImportline."Renesas Report Unit Price");
        recPriceListLine.Validate("ORE Debit Cost", p_PriceListImportline."ORE Debit Cost");
        recPriceListLine.Validate("Ship&Debit Flag", p_PriceListImportline."Ship&Debit Flag");
        recPriceListLine.Validate("PC. Currency Code", p_PriceListImportline."PC. Currency Code");
        recPriceListLine.Validate("PC. Direct Unit Cost", p_PriceListImportline."PC. Direct Unit Cost");
        recPriceListLine.Validate("PC. Update Price", p_PriceListImportline."PC. Update Price");
        recPriceListLine.Validate("Status", p_PriceListImportline."Price Line Status");
        recPriceListLine.Modify(true);
    end;

    //Create new records on the PriceList table.
    procedure CreateSalesPriceListLines(var p_PriceListImportline: Record "Price List Import Line"; p_LineNoStarter: Integer)
    var
        recPriceListLine: Record "Price List Line";
    begin
        recPriceListLine.INIT;
        recPriceListLine."Price List Code" := G_SalesPriceCode;
        recPriceListLine."Line No." := p_LineNoStarter;
        recPriceListLine.Validate("Price Type", Enum::"Price Type"::Sale);
        recPriceListLine.Validate("Amount Type", Enum::"Price Amount Type"::Any); //Defines, Any means "Price & Discount";
        recPriceListLine.Validate("Source Type", Enum::"Price Source Type"::Customer);
        recPriceListLine.Validate("Source No.", p_PriceListImportline."Customer No.");
        recPriceListLine.Validate("Asset Type", p_PriceListImportline."Product Type");
        recPriceListLine.Validate("Product No.", p_PriceListImportline."Product No.");
        recPriceListLine.Validate("Description", GetProductDesc(p_PriceListImportline));
        recPriceListLine.Validate("Unit Price", p_PriceListImportline."Unit Price");
        recPriceListLine.Validate("Currency Code", p_PriceListImportline."Sales Currency Code");
        recPriceListLine.Validate("Starting Date", p_PriceListImportline."Starting Date");
        recPriceListLine.Validate("Ending Date", p_PriceListImportline."Ending Date");
        recPriceListLine.Validate("Unit of Measure Code", p_PriceListImportline."Unit of Measure Code");
        recPriceListLine.Validate("Renesas Report Unit Price", p_PriceListImportline."Renesas Report Unit Price");
        recPriceListLine.Validate("Renesas Report Unit Price Cur.", p_PriceListImportline."Renesas Report Unit Price Cur.");

        recPriceListLine.Insert(true);

        recPriceListLine.Validate("Status", Enum::"Price Status"::Active);
        recPriceListLine.Modify(true);
    end;

    procedure UpdateSalesPriceListLines(var p_PriceListImportline: Record "Price List Import Line"; var recPriceListLine: Record "Price List Line")
    begin

        recPriceListLine.Validate("Unit Price", p_PriceListImportline."Unit Price");
        recPriceListLine.Validate("Currency Code", p_PriceListImportline."Sales Currency Code");
        recPriceListLine.Validate("Ending Date", p_PriceListImportline."Ending Date");
        recPriceListLine.Validate("Unit of Measure Code", p_PriceListImportline."Unit of Measure Code");
        recPriceListLine.Validate("Renesas Report Unit Price", p_PriceListImportline."Renesas Report Unit Price");
        recPriceListLine.Validate("Renesas Report Unit Price Cur.", p_PriceListImportline."Renesas Report Unit Price Cur.");
        recPriceListLine.Validate("Status", p_PriceListImportline."Price Line Status");
        recPriceListLine.Modify(true);
    end;

    local procedure GetProductDesc(var p_PriceListImportline: Record "Price List Import Line"): Text[100]
    var
        recItem: Record Item;
        recGLAccount: Record "G/L Account";
        recResource: Record Resource;
        recResourceGroup: Record "Resource Group";
        recItemDiscGroup: Record "Item Discount Group";
        Desc: Text[100];
    begin

        case p_PriceListImportline."Product Type" of
            Enum::"Price Asset Type"::Item:
                begin
                    if recItem.Get(p_PriceListImportline."Product No.") then begin
                        Desc := recItem.Description;
                    end;
                end;
            Enum::"Price Asset Type"::"G/L Account":
                begin
                    if not recGLAccount.Get(p_PriceListImportline."Product No.") then begin
                        Desc := recGLAccount.Name;
                    end;
                end;
            Enum::"Price Asset Type"::Resource:
                begin
                    if not recResource.Get(p_PriceListImportline."Product No.") then begin
                        Desc := recResource.Name;
                    end;
                end;
            Enum::"Price Asset Type"::"Resource Group":
                begin
                    if not recResourceGroup.Get(p_PriceListImportline."Product No.") then begin
                        Desc := recResourceGroup.Name;
                    end;
                end;
            Enum::"Price Asset Type"::"Item Discount Group":
                begin
                    if not recItemDiscGroup.Get(p_PriceListImportline."Product No.") then begin
                        Desc := recItemDiscGroup.Description;
                    end;
                end;
        end;

        exit(Desc);
    end;


    procedure CheckError(var p_PriceListImportline: Record "Price List Import Line")
    var
        ErrDesc: Text[1024];//the total of error message is over of ( [Table – Price List Import Line]'[Error Description] length : 250)
        Staging1: Record "Price List Import Line";
        recItem: Record Item;
        recGLAccount: Record "G/L Account";
        recResource: Record Resource;
        recResourceGroup: Record "Resource Group";
        recItemDiscGroup: Record "Item Discount Group";
        recCustomer: Record Customer;
        recVendor: Record Vendor;
        recCurrency: Record Currency;
        recPriceListLine: Record "Price List Line";
        recUOM: Record "Unit of Measure";

    begin

        Staging1.SetRange("Batch Name", G_BatchName);
        Staging1.SetRange("Product No.", p_PriceListImportline."Product No.");
        Staging1.SetRange("Starting Date", p_PriceListImportline."Starting Date");
        Staging1.SetRange("Sales Currency Code", p_PriceListImportline."Sales Currency Code");
        Staging1.SetRange("Purchase Currency Code", p_PriceListImportline."Purchase Currency Code");
        if Staging1.Count > 1 then begin
            Staging1.ModifyAll(Status, Staging1.Status::Error);
            Staging1.ModifyAll("Error Description", 'Same Product No., Starting Date, Currency Code record is in the batch.');
        end else begin
            case p_PriceListImportline."Product Type" of
                Enum::"Price Asset Type"::Item:
                    begin
                        if not recItem.Get(p_PriceListImportline."Product No.") then begin
                            ErrDesc += StrSubstNo(NotFoundMsg, 'Product No.');
                        end;
                    end;
                Enum::"Price Asset Type"::"G/L Account":
                    begin
                        if not recGLAccount.Get(p_PriceListImportline."Product No.") then begin
                            ErrDesc += StrSubstNo(NotFoundMsg, 'Product No.');
                        end;
                    end;
                Enum::"Price Asset Type"::Resource:
                    begin
                        if not recResource.Get(p_PriceListImportline."Product No.") then begin
                            ErrDesc += StrSubstNo(NotFoundMsg, 'Product No.');
                        end;
                    end;
                Enum::"Price Asset Type"::"Resource Group":
                    begin
                        if not recResourceGroup.Get(p_PriceListImportline."Product No.") then begin
                            ErrDesc += StrSubstNo(NotFoundMsg, 'Product No.');
                        end;
                    end;
                Enum::"Price Asset Type"::"Item Discount Group":
                    begin
                        if not recItemDiscGroup.Get(p_PriceListImportline."Product No.") then begin
                            ErrDesc += StrSubstNo(NotFoundMsg, 'Product No.');
                        end;
                    end;
            end;

            if not recCustomer.Get(p_PriceListImportline."Customer No.") then begin
                ErrDesc += StrSubstNo(NotFoundMsg, 'Customer No.');
            end;

            if not recVendor.Get(p_PriceListImportline."Vendor No.") then begin
                ErrDesc += StrSubstNo(NotFoundMsg, 'Vendor No.');
            end;

            if p_PriceListImportline."Sales Currency Code" <> '' then begin
                if not recCurrency.Get(p_PriceListImportline."Sales Currency Code") then begin
                    ErrDesc += StrSubstNo(NotFoundMsg, 'Sales Currency Code');
                end;
            end;

            if p_PriceListImportline."Purchase Currency Code" <> '' then begin
                if not recCurrency.Get(p_PriceListImportline."Purchase Currency Code") then begin
                    ErrDesc += StrSubstNo(NotFoundMsg, 'Purchase Currency Code');
                end;
            end;

            if p_PriceListImportline."Unit of Measure Code" <> '' then begin
                if not recUOM.Get(p_PriceListImportline."Unit of Measure Code") then begin
                    ErrDesc += StrSubstNo(NotFoundMsg, 'Unit of Measure Code');
                end;
            end;

            if p_PriceListImportline."Renesas Report Unit Price Cur." <> '' then begin
                if not recCurrency.Get(p_PriceListImportline."Renesas Report Unit Price Cur.") then begin
                    ErrDesc += StrSubstNo(NotFoundMsg, 'Renesas Report Unit Price Cur.');
                end;
            end;

            if p_PriceListImportline."PC. Currency Code" <> '' then begin
                if not recCurrency.Get(p_PriceListImportline."PC. Currency Code") then begin
                    ErrDesc += StrSubstNo(NotFoundMsg, 'PC. Currency Code');
                end;
            end;

            if (ErrDesc <> '') then begin
                p_PriceListImportline."Error Description" := CopyStr(ErrDesc, 1, 250);
                p_PriceListImportline.Validate(p_PriceListImportline.Status, p_PriceListImportline.Status::Error);
            end else begin
                p_PriceListImportline."Error Description" := '';
                p_PriceListImportline."Sales Price (LCY)" := CalcSalesPriceLCY(p_PriceListImportline);
                p_PriceListImportline."Purchase Price (LCY)" := CalcPurchPriceLCY(p_PriceListImportline);

                if (p_PriceListImportline."Sales Price (LCY)" = 0) or (p_PriceListImportline."Purchase Price (LCY)" = 0) then begin
                    p_PriceListImportline."Margin%" := G_ZeroPriceMargin;
                end else begin
                    p_PriceListImportline."Margin%" := (p_PriceListImportline."Sales Price (LCY)" - p_PriceListImportline."Purchase Price (LCY)") / p_PriceListImportline."Sales Price (LCY)" * 100;
                end;

                //Create or Update
                //Set Create as default, then set to Update if sales / purchase price list line exsits.
                p_PriceListImportline.Action := p_PriceListImportline.Action::Create;

                recPriceListLine.SetRange("Price Type", Enum::"Price Type"::Sale);
                recPriceListLine.SetRange("Price List Code", G_SalesPriceCode);
                recPriceListLine.SetRange("Asset Type", p_PriceListImportline."Product Type");
                recPriceListLine.SetRange("Product No.", p_PriceListImportline."Product No.");
                recPriceListLine.SetRange("Starting Date", p_PriceListImportline."Starting Date");
                recPriceListLine.SetRange("Currency Code", p_PriceListImportline."Sales Currency Code");
                if not recPriceListLine.IsEmpty() then begin
                    p_PriceListImportline.Action := p_PriceListImportline.Action::Update;
                end;

                recPriceListLine.SetRange("Price Type", Enum::"Price Type"::Purchase);
                recPriceListLine.SetRange("Price List Code", G_PurchPriceCode);
                recPriceListLine.SetRange("Asset Type", p_PriceListImportline."Product Type");
                recPriceListLine.SetRange("Product No.", p_PriceListImportline."Product No.");
                recPriceListLine.SetRange("Starting Date", p_PriceListImportline."Starting Date");
                recPriceListLine.SetRange("Currency Code", p_PriceListImportline."Purchase Currency Code");
                if not recPriceListLine.IsEmpty() then begin
                    p_PriceListImportline.Action := p_PriceListImportline.Action::Update;
                end;

                p_PriceListImportline.Validate(p_PriceListImportline.Status, p_PriceListImportline.Status::Validated);
            end;

            p_PriceListImportline.Modify(true);
        end;
    end;

    local procedure CalcSalesPriceLCY(p_PriceListImportline: Record "Price List Import Line"): Decimal
    var
        CurrencyLocal: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RateDate: Date;
        rtnAmountLCY: Decimal;
    begin
        RateDate := WorkDate();

        CurrencyLocal.InitRoundingPrecision();
        if p_PriceListImportline."Sales Currency Code" <> '' then
            rtnAmountLCY :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  RateDate,
                  p_PriceListImportline."Sales Currency Code",
                  p_PriceListImportline."Unit Price",
                  CurrExchRate.ExchangeRate(RateDate, p_PriceListImportline."Sales Currency Code")),
                CurrencyLocal."Amount Rounding Precision")
        else
            rtnAmountLCY :=
              Round(p_PriceListImportline."Unit Price", CurrencyLocal."Amount Rounding Precision");

        exit(rtnAmountLCY);
    end;

    local procedure CalcPurchPriceLCY(p_PriceListImportline: Record "Price List Import Line"): Decimal
    var
        CurrencyLocal: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RateDate: Date;
        CurrFCY: Code[10];
        AmountFCY: Decimal;
        rtnAmountLCY: Decimal;
    begin
        RateDate := WorkDate();
        CurrencyLocal.InitRoundingPrecision();

        if p_PriceListImportline."Ship&Debit Flag" = false then begin
            if p_PriceListImportline."Purchase Currency Code" <> '' then
                rtnAmountLCY :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      RateDate,
                      p_PriceListImportline."Purchase Currency Code",
                      p_PriceListImportline."Direct Unit Cost",
                      CurrExchRate.ExchangeRate(RateDate, p_PriceListImportline."Purchase Currency Code")),
                    CurrencyLocal."Amount Rounding Precision")
            else
                rtnAmountLCY :=
                  Round(p_PriceListImportline."Direct Unit Cost", CurrencyLocal."Amount Rounding Precision");
        end else begin
            if p_PriceListImportline."PC. Direct Unit Cost" <> 0 then begin
                if p_PriceListImportline."Purchase Currency Code" <> '' then
                    rtnAmountLCY :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          RateDate,
                          p_PriceListImportline."Purchase Currency Code",
                          p_PriceListImportline."Direct Unit Cost",
                          CurrExchRate.ExchangeRate(RateDate, p_PriceListImportline."Purchase Currency Code")),
                        CurrencyLocal."Amount Rounding Precision")
                else
                    rtnAmountLCY :=
                      Round(p_PriceListImportline."Direct Unit Cost", CurrencyLocal."Amount Rounding Precision");
            end else begin
                if p_PriceListImportline."Purchase Currency Code" <> '' then
                    rtnAmountLCY :=
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          RateDate,
                          p_PriceListImportline."Purchase Currency Code",
                          p_PriceListImportline."ORE Debit Cost",
                          CurrExchRate.ExchangeRate(RateDate, p_PriceListImportline."Purchase Currency Code")),
                        CurrencyLocal."Amount Rounding Precision")
                else
                    rtnAmountLCY :=
                      Round(p_PriceListImportline."ORE Debit Cost", CurrencyLocal."Amount Rounding Precision");
            end;
        end;

        exit(rtnAmountLCY);

    end;

}
