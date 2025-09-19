page 50102 "Update SOPO Price"
{
    ApplicationArea = All;
    Caption = 'Update SO/PO Price';
    PageType = List;
    SourceTable = "Update SOPO Price";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Update Target Date"; Rec."Update Target Date")
                {
                    ApplicationArea = all;
                }
                field("Document Type"; Rec."Document Type")
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
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Old Price"; Rec."Old Price")
                {
                    ApplicationArea = all;
                }
                field("New Price"; NewPrice)
                {
                    ApplicationArea = all;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = all;
                }
                field("Log DateTime"; Rec."Log DateTime")
                {
                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
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
            group(Update)
            {
                Caption = 'Update';
                Image = Alerts;
                action("Apply Update")
                {
                    Caption = 'Apply Update';
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = report "Update SO/PO Price";
                    ToolTip = 'Update the prices to sales and purchase lines based on the defined price list. This action will modify the document lines if price differences are found.';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Image = Report;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    RunObject = report "Update SO/PO Price Test Report";
                    ToolTip = 'Preview the lines that would be updated based on the price list, without applying any changes. Use this report to review potential updates and identify errors.';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
            }
        }
    }

    var
        NewPrice: Text;

    trigger OnAfterGetRecord()
    begin
        if rec."Error Message" = '' then begin
            NewPrice := Format(rec."New Price");
        end else begin
            NewPrice := '***';
        end;
        NewPrice := NewPrice.PadLeft(15);
    end;
}
