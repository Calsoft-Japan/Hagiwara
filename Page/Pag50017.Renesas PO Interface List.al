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
                action("Report Renesas PO Check List")
                {
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Report "Renesas PO Check List";
                    ShortCutKey = 'F5';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Delete Renesas Not Process Rec")
                {
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = codeunit "Delete Renesas PO Int (PF=0)";
                    ShortCutKey = 'F4';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Delete All Renesas Interface Rec")
                {
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = codeunit "Clear Renesas PO Interface Rec";
                    ShortCutKey = 'Shift+F4';

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
                action("Create Renesaa PO")
                {
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = codeunit "Purch Order Interface (Create)";
                    ShortCutKey = 'F3';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Update Renesas PO Line")
                {
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = codeunit "Renesas PO Interface (Update)";
                    ShortCutKey = 'F2';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
            }
        }
        area(reporting)
        {
        }
    }
}

