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
            group(Purchasing)
            {
                Caption = 'Purchasing';
                Image = Alerts;
                action("Import PO File")
                {
                    Caption = 'Import PO File';
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = codeunit "Renesas PO Importer";
                    ToolTip = 'Import Renesas PO Data from Microsoft Excel Worksheet into Renesas PO Interface table.';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Report PO Check List")
                {
                    Caption = 'Report PO Check List';
                    Image = Report;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = Report "Renesas PO Check List";
                    ToolTip = 'Print and at the same time validate Renesas PO Interface data after the import process is completed.';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Delete Not Process Record")
                {
                    Caption = 'Delete Not Process Record';
                    Image = DeleteRow;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = codeunit "Delete Renesas PO Int (PF=0)";
                    ToolTip = 'Delete interface records that are unprocessed.';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Clear All Record")
                {
                    Caption = 'Clear All Record';
                    Image = ClearLog;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = codeunit "Clear Renesas PO Interface Rec";
                    ToolTip = 'Clear all historical and already processed interface data stored in Renesas PO Interface table.';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Create PO")
                {
                    Caption = 'Create PO';
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = codeunit "Purch Order Interface (Create)";
                    ToolTip = 'Create Renesas PO record from imported Renesas PO Interface data.';

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
                    PromotedCategory = Process;
                    RunObject = codeunit "Renesas PO Interface (Update)";
                    ToolTip = 'Adjust and update Renesas PO quantity in existing Purchase Lines, limited to quantity reduction (negative values only).';

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

