page 50017 "Renesas PO Interface List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Validation,Update';
    SourceTable = "Renesas PO Interface";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("OEM No."; Rec."OEM No.")
                {
                    ApplicationArea = all;
                }
                field("Vendor Customer Code"; Rec."Vendor Customer Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field(Product; Rec.Product)
                {
                    ApplicationArea = all;
                }
                field("CO No."; Rec."CO No.")
                {
                    ApplicationArea = all;
                }
                field("Demand Date"; Rec."Demand Date")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
                field(ProcFlag; Rec.ProcFlag)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Validation)
            {
                Caption = 'Validation';
                Image = Alerts;
                action("Import PO File")
                {
                    Caption = 'Import PO File';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = codeunit "Renesas PO Importer";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Report PO Check List")
                {
                    Caption = 'Report PO Check List';
                    Image = CheckList;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Renesas PO Check List";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
            }
            group(Process)
            {
                Caption = 'Process';
                Image = Confirm;
                action("Create PO")
                {
                    Caption = 'Create PO';
                    Image = CreateDocuments;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = codeunit "Purch Order Interface (Create)";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Delete Not Process Record")
                {
                    Caption = 'Delete Not Process Record';
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = codeunit "Delete Renesas PO Int (PF=0)";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Clear All Record")
                {
                    Caption = 'Clear All Record';
                    Image = Delete;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = codeunit "Clear Renesas PO Interface Rec";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Update PO Line")
                {
                    Caption = 'Update PO Line';
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = codeunit "Renesas PO Interface (Update)";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
            }
        }
    }
}

