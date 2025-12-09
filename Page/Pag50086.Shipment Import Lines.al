page 50086 "Shipment Import Lines"
{

    Editable = false;
    PageType = List;
    SourceTable = "Shipment Import Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Group Key"; REC."Group Key")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; REC."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Customer Item No."; Rec."Customer Item No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Order No."; REC."Customer Order No.")
                {
                    ApplicationArea = all;
                }
                field("Shipped Quantity"; Rec."Shipped Quantity")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                }
                field("Error Description"; REC."Error Description")
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
            group(Sales)
            {
                action(Import)
                {
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        cduImporter: Codeunit "Import Shipment Data";
                    begin
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
                        Staging: Record "Shipment Import Line";
                    begin
                        Staging.Reset();
                        Staging.SETFILTER(Staging.Status, '%1|%2', Staging.Status::Pending, Staging.Status::Error);
                        if Staging.IsEmpty then
                            Error('There is no record to validate.');

                        CheckDuplicate();

                        Staging.Reset();
                        Staging.SETFILTER(Status, '%1', Staging.Status::Pending);
                        Staging.ModifyAll(Status, Staging.Status::Processed);

                        MESSAGE('Validation & Process Completed.');
                    end;
                }
                action("Create Sales Invoice")
                {
                    Image = CreateDocuments;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "Shipment Import Line";
                    begin
                        Staging.Reset();
                        if Staging.IsEmpty then
                            Error('There is no record to proceed.');

                        Staging.SETFILTER(Status, '%1', Staging.Status::Processed);
                        if Staging.IsEmpty then
                            Error('You cannot proceed if there is a record that the status is not Processed.');

                        Codeunit.Run(Codeunit::"Create Sales Invoice");

                        MESSAGE('Create Sales Invoice Sucessfully.');

                    end;
                }
                action("Delete All")
                {
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "Shipment Import Line";
                    begin
                        IF CONFIRM('Do you want to delete all the data?', false) THEN BEGIN
                            Staging.DELETEALL;
                        END
                    end;
                }
            }
        }
    }

    var

    local procedure CheckDuplicate()
    var

        Staging1: Record "Shipment Import Line";
        Staging2: Record "Shipment Import Line";
        SalesShipLine: Record "Sales Shipment Line";
        GroupKey: Integer;
        CustomerNo: Code[20];
        ItemNo: Code[20];
        CustomerItemNo: Code[20];
        CustOrderNo: Text[35];
        ShipQty: Decimal;
        ErrDesc: Text;
    begin

        Staging1.SETFILTER(Status, '%1|%2', Staging1.Status::Pending, Staging1.Status::Error);
        Staging1.SetCurrentKey("Group Key", "Customer No.", "Item No.", "Customer Item No.", "Customer Order No.", "Shipped Quantity");

        if Staging1.FindSet() then
            repeat
                if (GroupKey <> Staging1."Group Key")
                        or (CustomerNo <> Staging1."Customer No.")
                        or (ItemNo <> Staging1."Item No.")
                        or (CustomerItemNo <> Staging1."Customer Item No.")
                        or (CustOrderNo <> Staging1."Customer Order No.")
                        or (ShipQty <> Staging1."Shipped Quantity") then begin

                    GroupKey := Staging1."Group Key";
                    CustomerNo := Staging1."Customer No.";
                    ItemNo := Staging1."Item No.";
                    CustomerItemNo := Staging1."Customer Item No.";
                    CustOrderNo := Staging1."Customer Order No.";
                    ShipQty := Staging1."Shipped Quantity";

                    ErrDesc := '';

                    Staging2.Reset();
                    Staging2.SETFILTER(Status, '%1|%2', Staging2.Status::Pending, Staging2.Status::Error);
                    Staging2.SetRange("Group Key", GroupKey);
                    Staging2.SetRange("Customer No.", CustomerNo);
                    Staging2.SetRange("Item No.", ItemNo);
                    Staging2.SetRange("Customer Item No.", CustomerItemNo);
                    Staging2.SetRange("Customer Order No.", CustOrderNo);
                    Staging2.SetRange("Shipped Quantity", ShipQty);
                    if Staging2.Count > 1 then begin
                        //check duplicate.
                        Staging2.ModifyAll(Status, Staging2.Status::Error);
                        Staging2.ModifyAll("Error Description", 'The same data exists in "Group Key", "Customer No.", "Item No.", "Customer Item No.", "Customer Order No." and " Shipped Quantity".');
                    end else begin
                        //check sales shipment line exists.
                        if Staging1."Customer Order No." = '' then begin
                            ErrDesc := 'Customer Order No. is blank. ';
                        end else begin
                            SalesShipLine.Reset();
                            SalesShipLine.SetRange("Customer Order No.", Staging1."Customer Order No.");
                            if SalesShipLine.IsEmpty then begin
                                ErrDesc := 'Customer Order No. is not found. ';
                            end else begin
                                SalesShipLine.FindFirst();

                                if (SalesShipLine."Sell-to Customer No." <> Staging1."Customer No.") or (SalesShipLine."Bill-to Customer No." <> Staging1."Customer No.") then
                                    ErrDesc := ErrDesc + 'Customer No. is wrong. ';
                                if SalesShipLine."Customer Item No." <> Staging1."Customer Item No." then
                                    ErrDesc := ErrDesc + 'Customer Item No. is wrong. ';
                                if SalesShipLine."Description" <> Staging1."Item Description" then
                                    ErrDesc := ErrDesc + 'Item Description is wrong. ';
                                if SalesShipLine."Currency Code" <> Staging1."Currency Code" then
                                    ErrDesc := ErrDesc + 'Currency Code is wrong. ';
                                if SalesShipLine."Qty. Shipped Not Invoiced" = 0 then
                                    ErrDesc := ErrDesc + 'Qty. Shipped Not Invoiced is zero. ';
                                if SalesShipLine."Quantity" <> Staging1."Shipped Quantity" then
                                    ErrDesc := ErrDesc + 'Shipped Quantity is wrong. ';
                                if SalesShipLine."Authorized for Credit Card" = true then
                                    ErrDesc := ErrDesc + 'Sales Shipment Line''s Authorized for Credit Card is true. ';
                                if Staging1."Unit Price" <> 0 then begin
                                    if SalesShipLine."Unit Price" <> Staging1."Unit Price" then
                                        ErrDesc := ErrDesc + 'Unit Price is wrong. ';
                                end;
                            end;
                        end;
                        if ErrDesc <> '' then begin
                            Staging1.Status := Staging1.Status::Error;
                            Staging1."Error Description" := PadStr(ErrDesc, StrLen(ErrDesc) - 1);
                            Staging1.Modify();
                        end;

                        /*
                        SalesShipLine.Reset();
                        SalesShipLine.SetRange("Sell-to Customer No.", Staging1."Customer No.");
                        SalesShipLine.SetRange("Bill-to Customer No.", Staging1."Customer No.");
                        SalesShipLine.SetRange("Customer Item No.", Staging1."Customer Item No.");
                        SalesShipLine.SetRange("Customer Order No.", Staging1."Customer Order No.");
                        SalesShipLine.SetRange(Description, Staging1."Item Description");
                        SalesShipLine.SetRange("Currency Code", Staging1."Currency Code");
                        SalesShipLine.SetFilter("Qty. Shipped Not Invoiced", '<>%1', 0);
                        SalesShipLine.SetRange(Quantity, Staging1."Shipped Quantity");
                        SalesShipLine.SetRange("Authorized for Credit Card", false);
                        if Staging1."Unit Price" <> 0 then begin
                            SalesShipLine.SetRange("Unit Price", Staging1."Unit Price");
                        end;

                        if SalesShipLine.IsEmpty then begin
                            Staging1.Status := Staging1.Status::Error;
                            Staging1."Error Description" := 'There is no matched record in Sales Shipment Line.';
                            Staging1.Modify();
                        end;
                        */

                    end;
                end;
            until Staging1.Next() = 0;

    end;

}

