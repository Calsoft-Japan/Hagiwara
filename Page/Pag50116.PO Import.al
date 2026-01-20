//CS092 2025/10/14 Bobby N009 PO Import
page 50116 "PO Import"
{
    ApplicationArea = All;
    Caption = 'PO Import';
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    SourceTable = "PO Import";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; REC."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Group Key"; REC."Grouping Key")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = all;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("CO No."; Rec."CO No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = all;
                }
                field("Insert Comment Line"; Rec."Insert Comment Line")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
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
        area(Processing)
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
                        CuPOImport: Codeunit "PO Import";
                    begin
                        CuPOImport.Run();
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
                        ErrorDescription: Text;
                        HasError: Boolean;
                        RecPurchaseLine: Record "Purchase Line";
                        RecVendor: Record Vendor;
                        RecItem: Record Item;
                    begin
                        Rec.Reset();
                        if not Rec.IsEmpty then begin
                            Rec.FindSet();
                            repeat
                                ErrorDescription := '';
                                HasError := false;

                                if (Rec."Document No." <> '') then begin //Update Case
                                    if (Rec."Line No." = 0) then begin
                                        ErrorDescription += 'Line No. is empty.';
                                        HasError := true;
                                    end else begin
                                        RecPurchaseLine.Reset();
                                        RecPurchaseLine.SetRange(Type, RecPurchaseLine.Type::Item);
                                        RecPurchaseLine.SetRange("Document No.", Rec."Document No.");
                                        RecPurchaseLine.SetRange("Line No.", Rec."Line No.");
                                        if not RecPurchaseLine.FindFirst() then begin
                                            ErrorDescription := 'Record to update was not found.';
                                            HasError := true;
                                        end;
                                    end;

                                    if HasError then begin
                                        Rec.Status := Rec.Status::Error;
                                        Rec."Error Description" := ErrorDescription;
                                        Rec.Modify();
                                    end
                                    else begin
                                        Rec."Grouping Key" := 0;
                                        Rec."Vendor No." := '';
                                        Rec."Order Date" := 0D;
                                        Rec."Item No." := '';
                                        rec."Insert Comment Line" := false;
                                        Rec.Status := Rec.Status::Validated;
                                        Rec."Error Description" := '';
                                        Rec.Modify();
                                    end;
                                end else begin
                                    RecVendor.Reset();
                                    RecVendor.SetRange("No.", Rec."Vendor No.");
                                    if not RecVendor.FindFirst() then begin
                                        ErrorDescription += 'Vendor is not found.';
                                        HasError := true;
                                    end;

                                    if RecVendor.Blocked <> RecVendor.Blocked::" " then begin
                                        ErrorDescription += 'Vendor is blocked.';
                                        HasError := true;
                                    end;

                                    RecItem.Reset();
                                    RecItem.SetRange("No.", Rec."Item No.");
                                    if not RecItem.FindFirst() then begin
                                        ErrorDescription += 'Item is not found.';
                                        HasError := true;
                                    end;

                                    if RecItem."Blocked" then begin
                                        ErrorDescription += 'Item is blocked.';
                                        HasError := true;
                                    end;

                                    /* Just check the Blocked field currently
                                    if RecItem."Purchasing Blocked" then begin
                                        ErrorDescription += 'Item is blocked.';
                                        HasError := true;
                                    end;*/

                                    if HasError then begin
                                        Rec.Status := Rec.Status::Error;
                                        Rec."Error Description" := ErrorDescription;
                                        Rec.Modify();
                                    end else begin
                                        Rec.Status := Rec.Status::Validated;
                                        Rec."Error Description" := '';
                                        Rec.Modify();
                                    end;
                                end;
                            until Rec.Next() = 0;
                        end;
                    end;
                }
                action("Carry Out")
                {
                    Image = CreateDocuments;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CuPOImport: Codeunit "PO Import";
                        RecPOImportCheck: Record "PO Import";
                    begin
                        RecPOImportCheck.Reset();
                        RecPOImportCheck.SetFilter(Status, '<>%1', RecPOImportCheck.Status::Validated);
                        if RecPOImportCheck.FindFirst() then begin
                            Message('You can not carry out the process. The status of all records must be Validated.');
                            exit;
                        end;

                        CuPOImport.ProcessAllData();
                        CurrPage.Update(false);

                    end;
                }
                action("Delete All")
                {
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you confirm to delete all the data?', false) THEN BEGIN
                            Rec.DeleteAll();
                        END
                    end;
                }
            }
        }
    }

}

