page 50101 "Receipt Import Lines"
{

    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    SourceTable = "Receipt Import Line";

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
                field("Vendor No."; Rec."Vendor No.")
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
                field("CO No."; REC."CO No.")
                {
                    ApplicationArea = all;
                }
                field("Received Quantity"; Rec."Received Quantity")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; Rec."Unit Cost")
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
                        cduImporter: Codeunit "Import Receipt Data";
                    begin
                        cduImporter.Run();
                    end;
                }
                action("Validate & Process")
                {
                    Image = ViewCheck;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "Receipt Import Line";
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
                action("Create Purchase Invoice")
                {
                    Image = CreateDocuments;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Staging: Record "Receipt Import Line";
                    begin
                        Staging.Reset();
                        if Staging.IsEmpty then
                            Error('There is no record to proceed.');

                        Staging.SETFILTER(Status, '%1', Staging.Status::Processed);
                        if Staging.IsEmpty then
                            Error('You cannot proceed if there is a record that the status is not Processed.');

                        Codeunit.Run(Codeunit::"Create Purchase Invoice");

                        MESSAGE('Create Purchase Invoice Sucessfully.');

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
                        Staging: Record "Receipt Import Line";
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

        Staging1: Record "Receipt Import Line";
        Staging2: Record "Receipt Import Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        GroupKey: Integer;
        VendorNo: Code[20];
        ItemNo: Code[20];
        CustomerItemNo: Code[20];
        CONo: Code[6];
        ReceiveQty: Decimal;
        ErrDesc: Text;
    begin

        Staging1.SETFILTER(Status, '%1|%2', Staging1.Status::Pending, Staging1.Status::Error);
        Staging1.SetCurrentKey("Group Key", "Vendor No.", "Item No.", "Customer Item No.", "CO No.", "Received Quantity");

        if Staging1.FindSet() then
            repeat
                if (GroupKey <> Staging1."Group Key")
                        or (VendorNo <> Staging1."Vendor No.")
                        or (ItemNo <> Staging1."Item No.")
                        or (CustomerItemNo <> Staging1."Customer Item No.")
                        or (CONo <> Staging1."CO No.")
                        or (ReceiveQty <> Staging1."Received Quantity") then begin

                    GroupKey := Staging1."Group Key";
                    VendorNo := Staging1."Vendor No.";
                    ItemNo := Staging1."Item No.";
                    CustomerItemNo := Staging1."Customer Item No.";
                    CONo := Staging1."CO No.";
                    ReceiveQty := Staging1."Received Quantity";

                    ErrDesc := '';

                    Staging2.Reset();
                    Staging2.SETFILTER(Status, '%1|%2', Staging2.Status::Pending, Staging2.Status::Error);
                    Staging2.SetRange("Group Key", GroupKey);
                    Staging2.SetRange("Vendor No.", VendorNo);
                    Staging2.SetRange("Item No.", ItemNo);
                    Staging2.SetRange("Customer Item No.", CustomerItemNo);
                    Staging2.SetRange("CO No.", CONo);
                    Staging2.SetRange("Received Quantity", ReceiveQty);
                    if Staging2.Count > 1 then begin

                        Staging2.ModifyAll(Status, Staging2.Status::Error);
                        Staging2.ModifyAll("Error Description", 'The same data exists in "Group Key", "Vendor No.", "Item No.", "Customer Item No.", "CO No." and " Received Quantity".');
                    end else begin
                        //check purchase receipt line exists.
                        if Staging1."CO No." = '' then begin
                            ErrDesc := 'CO No. is blank. ';
                        end else begin
                            PurchRcptLine.Reset();
                            PurchRcptLine.SetRange("CO No.", Staging1."CO No.");
                            if PurchRcptLine.IsEmpty then begin
                                ErrDesc := 'CO No. is not found. ';
                            end else begin
                                PurchRcptLine.FindFirst();
                                if PurchRcptLine."Buy-from Vendor No." <> Staging1."Vendor No." then
                                    ErrDesc := ErrDesc + 'Vendor No. is not found. ';
                                if PurchRcptLine."Customer Item No." <> Staging1."Customer Item No." then
                                    ErrDesc := ErrDesc + 'Customer Item No. is wrong. ';
                                if PurchRcptLine.Description <> Staging1."Item Description" then
                                    ErrDesc := ErrDesc + 'Item Description is wrong. ';
                                if PurchRcptLine."Currency Code" <> Staging1."Currency Code" then
                                    ErrDesc := ErrDesc + 'Currency Code is wrong. ';
                                if PurchRcptLine."Qty. Rcd. Not Invoiced" = 0 then
                                    ErrDesc := ErrDesc + 'Purchase Receipt Line''s Qty.Rcd. Not Invoiced is zero. ';
                                if PurchRcptLine.Quantity <> Staging1."Received Quantity" then
                                    ErrDesc := ErrDesc + 'Received Quantity is wrong. ';
                                if Staging1."Unit Cost" <> 0 then begin
                                    if PurchRcptLine."Unit Cost" <> Staging1."Unit Cost" then
                                        ErrDesc := ErrDesc + 'Unit Cost is wrong. ';
                                end;
                            end;
                        end;
                        if ErrDesc <> '' then begin
                            Staging1.Status := Staging1.Status::Error;
                            Staging1."Error Description" := PadStr(ErrDesc, StrLen(ErrDesc) - 1);
                            Staging1.Modify();
                        end;

                        /*
                        PurchRcptLine.Reset();
                        PurchRcptLine.SetRange("Buy-from Vendor No.", Staging1."Vendor No.");
                        PurchRcptLine.SetRange("CO No.", Staging1."CO No.");
                        PurchRcptLine.SetRange("Customer Item No.", Staging1."Customer Item No.");
                        PurchRcptLine.SetRange(Description, Staging1."Item Description");
                        PurchRcptLine.SetRange("Currency Code", Staging1."Currency Code");
                        PurchRcptLine.SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
                        PurchRcptLine.SetRange(Quantity, Staging1."Received Quantity");
                        if Staging1."Unit Cost" <> 0 then begin
                            PurchRcptLine.SetRange("Unit Cost", Staging1."Unit Cost");
                        end;
                        if PurchRcptLine.IsEmpty then begin
                            Staging1.Status := Staging1.Status::Error;
                            Staging1."Error Description" := 'There is no matched record in Purchase Receipt Line.';
                            Staging1.Modify();
                        end;
                        */

                    end;
                end;
            until Staging1.Next() = 0;

    end;

}

