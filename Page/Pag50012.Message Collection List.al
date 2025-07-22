page 50012 "Message Collection List"
{
    // v20201112. Kenya. FDD001 - Add Value Price of PSI Interface.

    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Maintenance,Revision';
    SourceTable = "Message Collection";

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
                field("File ID"; Rec."File ID")
                {
                    ApplicationArea = all;
                }
                field("Department Gr Code"; Rec."Department Gr Code")
                {
                    ApplicationArea = all;
                }
                field("Warehouse Code"; Rec."Warehouse Code")
                {
                    ApplicationArea = all;
                }
                field("SCM Customer Code"; Rec."SCM Customer Code")
                {
                    ApplicationArea = all;
                }
                field("End User Code"; Rec."End User Code")
                {
                    ApplicationArea = all;
                }
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ApplicationArea = all;
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                    ApplicationArea = all;
                }
                field("Parts Number"; Rec."Parts Number")
                {
                    ApplicationArea = all;
                }
                field("Inventory Class"; Rec."Inventory Class")
                {
                    ApplicationArea = all;
                }
                field("CO No"; Rec."CO No")
                {
                    ApplicationArea = all;
                }
                field("Partial Delivery"; Rec."Partial Delivery")
                {
                    ApplicationArea = all;
                }
                field("Order Entry Date"; Rec."Order Entry Date")
                {
                    ApplicationArea = all;
                }
                field("Demand Date"; Rec."Demand Date")
                {
                    ApplicationArea = all;
                }
                field("Sales Day"; Rec."Sales Day")
                {
                    ApplicationArea = all;
                }
                field("Order No"; Rec."Order No")
                {
                    ApplicationArea = all;
                }
                field("Pos/Neg Class"; Rec."Pos/Neg Class")
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
                field("Inventory Price"; Rec."Inventory Price")
                {
                    ApplicationArea = all;
                }
                field("Inventory Amount"; Rec."Inventory Amount")
                {
                    ApplicationArea = all;
                }
                field("Inventory Confirmation Date"; Rec."Inventory Confirmation Date")
                {
                    ApplicationArea = all;
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ApplicationArea = all;
                }
                field("Purchase Amount"; Rec."Purchase Amount")
                {
                    ApplicationArea = all;
                }
                field("Purchase Day"; Rec."Purchase Day")
                {
                    ApplicationArea = all;
                }
                field("Sales Price"; Rec."Sales Price")
                {
                    ApplicationArea = all;
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ApplicationArea = all;
                }
                field("Backlog Collection Day"; Rec."Backlog Collection Day")
                {
                    ApplicationArea = all;
                }
                field("Allocated Inv. Class"; Rec."Allocated Inv. Class")
                {
                    ApplicationArea = all;
                }
                field("SOLDTO Customer"; Rec."SOLDTO Customer")
                {
                    ApplicationArea = all;
                }
                field("SOLDTO Customer2"; Rec."SOLDTO Customer2")
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = all;
                }
                field("Sequence Number"; Rec."Sequence Number")
                {
                    ApplicationArea = all;
                }
                field(Preliminaries; Rec.Preliminaries)
                {
                    ApplicationArea = all;
                }
                field("Message Status"; Rec."Message Status")
                {
                    ApplicationArea = all;
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = all;
                }
                field("Source Document Line No."; Rec."Source Document Line No.")
                {
                    ApplicationArea = all;
                }
                field("Collected By"; Rec."Collected By")
                {
                    ApplicationArea = all;
                }
                field("Collected On"; Rec."Collected On")
                {
                    ApplicationArea = all;
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = all;
                }
                field("Cancelled On"; Rec."Cancelled On")
                {
                    ApplicationArea = all;
                }
                field("File Sent By"; Rec."File Sent By")
                {
                    ApplicationArea = all;
                }
                field("File Sent On"; Rec."File Sent On")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Update Date"; Rec."Update Date")
                {
                    ApplicationArea = all;
                }
                field("Update Time"; Rec."Update Time")
                {
                    ApplicationArea = all;
                }
                field("SO Document Category"; Rec."SO Document Category")
                {
                    ApplicationArea = all;
                }
                field("SCM Process Code"; Rec."SCM Process Code")
                {
                    ApplicationArea = all;
                }
                field("Agent Internal Key"; Rec."Agent Internal Key")
                {
                    ApplicationArea = all;
                }
                field("Shipping Instruction Div"; Rec."Shipping Instruction Div")
                {
                    ApplicationArea = all;
                }
                field("Prefix Seq No."; Rec."Prefix Seq No.")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Expected)"; Rec."Cost Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Cost Posted to G/L"; Rec."Cost Posted to G/L")
                {
                    ApplicationArea = all;
                }
                field("Advance Shipped Qty"; Rec."Advance Shipped Qty")
                {
                    ApplicationArea = all;
                }
                field("Backlog Qty Incl. Adv Shipment"; Rec."Backlog Qty Incl. Adv Shipment")
                {
                    ApplicationArea = all;
                }
                field("Backlog Qty Excl. Adv Shipment"; Rec."Backlog Qty Excl. Adv Shipment")
                {
                    ApplicationArea = all;
                }
                field("Booking No."; Rec."Booking No.")
                {
                    ApplicationArea = all;
                }
                field("Computed Inventory Amount"; Rec."Computed Inventory Amount")
                {
                    ApplicationArea = all;
                }
                field("Advance Receipt Qty"; Rec."Advance Receipt Qty")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field(Backup; Rec.Backup)
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        //v20201112 Added field
                    end;
                }
                field("Markup %"; Rec."Markup %")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        //v20201112 Added field
                    end;
                }
                field("Added Value"; Rec."Added Value")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 4;

                    trigger OnValidate()
                    begin
                        //v20201112 Added field
                    end;
                }
                field("PC. Currency Code"; Rec."PC. Currency Code")
                {
                    ApplicationArea = all;
                }
                field("PC. Unit Cost"; Rec."PC. Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("PC. Inventory Amount"; Rec."PC. Inventory Amount")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}

