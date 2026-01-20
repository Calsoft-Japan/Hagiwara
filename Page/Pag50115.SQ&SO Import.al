//CS092 2025/10/09 Channing.Zhou N008 SQ&SO Import
page 50115 "SQ&SO Import"
{
    ApplicationArea = All;
    Caption = 'SQ & SO Import';
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    SourceTable = "SQ&SO Import";

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
                field("Grouping Key"; REC."Grouping Key")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Customer Order No."; Rec."Customer Order No.")
                {
                    ApplicationArea = all;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = all;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = all;
                }
                field("Shipment Date"; Rec."Shipment Date")
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
                        CuSQSOImport: Codeunit "SQ&SO Import";
                    begin
                        CuSQSOImport.Run();
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
                        RecSalesLine: Record "Sales Line";
                        RecCustomer: Record Customer;
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
                                    end
                                    else begin
                                        RecSalesLine.Reset();
                                        if Rec."Document Type" = Rec."Document Type"::SO then begin
                                            RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
                                        end
                                        else if Rec."Document Type" = Rec."Document Type"::SQ then begin
                                            RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Quote);
                                        end;
                                        RecSalesLine.SetRange("Document No.", Rec."Document No.");
                                        RecSalesLine.SetRange("Line No.", Rec."Line No.");
                                        if not RecSalesLine.FindFirst() then begin
                                            ErrorDescription += 'Record to update was not found.';
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
                                        Rec."Customer No." := '';
                                        Rec."Order Date" := 0D;
                                        Rec."Item No." := '';
                                        Rec.Status := Rec.Status::Validated;
                                        Rec."Error Description" := '';
                                        Rec.Modify();
                                    end;
                                end
                                else begin //Insert Case
                                    RecCustomer.Reset();
                                    RecCustomer.SetRange("No.", Rec."Customer No.");
                                    if not RecCustomer.FindFirst() then begin
                                        ErrorDescription += 'Customer was not found.';
                                        HasError := true;
                                    end;
                                    if RecCustomer.Blocked <> RecCustomer.Blocked::" " then begin
                                        ErrorDescription += 'Customer is blocked.';
                                        HasError := true;
                                    end;
                                    RecItem.Reset();
                                    RecItem.SetRange("No.", Rec."Item No.");
                                    if not RecItem.FindFirst() then begin
                                        ErrorDescription += 'Item was not found.';
                                        HasError := true;
                                    end;
                                    if RecItem.Blocked then begin
                                        ErrorDescription += 'Item is blocked.';
                                        HasError := true;
                                    end;
                                    /* Just check the Blocked field currently
                                    if RecItem."Sales Blocked" then begin
                                        ErrorDescription += 'Item is blocked.';
                                        HasError := true;
                                    end;*/
                                    if HasError then begin
                                        Rec.Status := Rec.Status::Error;
                                        Rec."Error Description" := ErrorDescription;
                                        Rec.Modify();
                                    end
                                    else begin
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
                        CuSQSOImport: Codeunit "SQ&SO Import";
                        RecSQSOImportCheck: Record "SQ&SO Import";
                        RecTmpSQSOImportInsert: record "SQ&SO Import" temporary;
                        RecSalesHeader: Record "Sales Header";
                        RecSalesLine: Record "Sales Line";
                        RecPriceListHeader: Record "Price List Header";
                        RecCustomer: Record Customer;
                        RecItem: Record Item;
                        LineNo: Integer;
                        salescard: page "Sales Order Subform";
                    begin
                        RecSQSOImportCheck.Reset();
                        RecSQSOImportCheck.SetFilter(Status, '<>%1', RecSQSOImportCheck.Status::Validated);
                        if RecSQSOImportCheck.FindFirst() then begin
                            Message('You can''t carry out the process. The status of all records must be Validated.');
                            exit;
                        end;

                        CuSQSOImport.ProcessAllData();
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

