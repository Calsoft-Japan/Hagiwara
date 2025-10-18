page 50118 "Item Import Lines"
{
    ApplicationArea = All;
    UsageCategory = Lists;
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
                    //RunObject = codeunit "Renesas PO Importer";//TODO Nie
                    ToolTip = 'Import Data from Microsoft Excel Worksheet into Item Import Lines table.';

                    trigger OnAction()
                    var
                        cduImporter: Codeunit "Item Import";
                    //TransType: Option Receipt,Invoice,ReceiptInvoice;
                    begin
                        //cduImporter.SetTransType(TransType::Receipt);
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
                    begin
                        ItemImportline.SETFILTER(ItemImportline.Status, '%1|%2', ItemImportline.Status::Pending, ItemImportline.Status::Error);

                        if ItemImportline.IsEmpty() then begin
                            Error('There is no record to validate.');
                        end;

                        if ItemImportline.FINDFIRST then
                            REPEAT
                                CheckError(ItemImportline);
                            UNTIL ItemImportline.NEXT = 0;
                    end;
                }
            }
        }

    }
    procedure CheckError(var p_ItemImportline: Record "Item Import Line")
    var
        ErrDesc: Text[250];
        Item: Record "Item";
        UnitOfMeasure: Record "Unit of Measure";
        Manufacturer: Record "Manufacturer";
        ItemCategory: Record "Item Category";
        CountryRegion: Record "Country/Region";
        ItemGroup: Record "Item Group";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        GenProductPostingGroup: Record "Gen. Product Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        // -------Existence Check (See table relation info.)-------
        //Base Unit of Measure Code
        if not UnitOfMeasure.get(p_ItemImportline."Base Unit of Measure") then begin
            ErrDesc := 'Base Unit of Measure is not found. ';
        end;
        //Sales Unit of Measure Code
        if not UnitOfMeasure.get(p_ItemImportline."Sales Unit of Measure") then begin
            ErrDesc += 'Sales Unit of Measure is not found. ';
        end;
        //Purchase Unit of Measure Code
        if not UnitOfMeasure.get(p_ItemImportline."Purchase Unit of Measure") then begin
            ErrDesc += 'Purchase Unit of Measure is not found. ';
        end;
        //Manufacturer Code
        if not Manufacturer.get(p_ItemImportline."Manufacture Code") then begin
            ErrDesc += 'Manufacture Code is not found. ';
        end;
        //Item Category Code
        if not ItemCategory.get(p_ItemImportline."Item Category Code") then begin
            ErrDesc += 'Item Category Code is not found. ';
        end;
        //Country/Region of Origin Code
        if not CountryRegion.get(p_ItemImportline."Country/Region of Origin Code") then begin
            ErrDesc += 'Country/Region of Origin Code is not found. ';
        end;
        //Country/Region of Org Cd (FE)
        if not CountryRegion.get(p_ItemImportline."Country/Region of Org Cd (FE)") then begin
            ErrDesc += 'Country/Region of Org Cd (FE) is not found. ';
        end;
        //Product Group Code
        if not ItemGroup.get(p_ItemImportline."Product Group Code") then begin
            ErrDesc += 'Product Group Code is not found. ';
        end;
        //SBU
        if not Manufacturer.get(p_ItemImportline.SBU) then begin
            ErrDesc += 'SBU is not found. ';
        end;
        //Customer No.
        if not Customer.get(p_ItemImportline."Customer No.") then begin
            ErrDesc += 'Customer No. is not found. ';
        end;
        //OEM No.
        Customer.SetRange(Customer."No.", p_ItemImportline."OEM No.");
        Customer.SetRange(Customer."Customer Type", Customer."Customer Type"::OEM);
        if Customer.IsEmpty() then begin
            ErrDesc += 'OEM No. is not found. ';
        end;
        //Vendor No.
        if not Vendor.get(p_ItemImportline."Vendor No.") then begin
            ErrDesc += 'Vendor No. is not found. ';
        end;
        //Gen. Prod. Posting Group
        if not GenProductPostingGroup.get(p_ItemImportline."Gen. Prod. Posting Group") then begin
            ErrDesc += 'Gen. Prod. Posting Group is not found. ';
        end;
        //Inventory Posting Group
        if not InventoryPostingGroup.get(p_ItemImportline."Inventory Posting Group") then begin
            ErrDesc += 'Inventory Posting Group is not found. ';
        end;

        p_ItemImportline."Error Description" := ErrDesc;
        p_ItemImportline.MODIFY;
    end;

}
