page 50121 "Hagiwara Approval Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Hagiwara Approval Setup';
    PageType = Card;
    SourceTable = "Hagiwara Approval Setup";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Customer"; Rec."Customer")
                {
                    ApplicationArea = all;
                }
                field("Vendor"; Rec."Vendor")
                {
                    ApplicationArea = all;
                }
                field("Item"; Rec."Item")
                {
                    ApplicationArea = all;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = all;
                }
                field("Price List"; Rec."Price List")
                {
                    ApplicationArea = all;
                }
                field("Sales Order"; Rec."Sales Order")
                {
                    ApplicationArea = all;
                }
                field("Sales Return Order"; Rec."Sales Return Order")
                {
                    ApplicationArea = all;
                }
                field("Sales Credit Memo"; Rec."Sales Credit Memo")
                {
                    ApplicationArea = all;
                }
                field("Purchase Order"; Rec."Purchase Order")
                {
                    ApplicationArea = all;
                }
                field("Purchase Return Order"; Rec."Purchase Return Order")
                {
                    ApplicationArea = all;
                }
                field("Purchase Credit Memo"; Rec."Purchase Credit Memo")
                {
                    ApplicationArea = all;
                }
                field("Item Journal"; Rec."Item Journal")
                {
                    ApplicationArea = all;
                }
                field("Item Reclass Journal"; Rec."Item Reclass Journal")
                {
                    ApplicationArea = all;
                }
                field("Transfer Order"; Rec."Transfer Order")
                {
                    ApplicationArea = all;
                }
                field("Assembly Order"; Rec."Assembly Order")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
