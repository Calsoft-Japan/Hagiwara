page 50072 "Denso Group Sales File Import"
{
    // HG10.00.03 NJ 26/12/2017 - New Page Created
    // CS092 FDD IE021 Channing.Zhou 8/7/2025 - upgrade to BC version

    Caption = 'Denso Group Sales File Import Errors';
    InsertAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Sales File Import Buffer";
    SourceTableView = SORTING("File Name", "Row No.")
                      WHERE("Denso Group" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Date Imported"; Rec."Date Imported")
                {
                }
                field("User ID Imported"; Rec."User ID Imported")
                {
                }
                field("File Name"; Rec."File Name")
                {
                }
                field("Row No."; Rec."Row No.")
                {
                }
                field("Supplier Code"; Rec."Supplier Code")
                {
                }
                field("Buyer Part Number"; Rec."Buyer Part Number")
                {
                }
                field("Buyer Part Description"; Rec."Buyer Part Description")
                {
                }
                field("Supplier Part Number"; Rec."Supplier Part Number")
                {
                }
                field("Supplier Part Description"; Rec."Supplier Part Description")
                {
                }
                field(UOM; Rec.UOM)
                {
                }
                field("Delivery Order"; Rec."Delivery Order")
                {
                }
                field(Urgent; Rec.Urgent)
                {
                }
                field("Purchase Order Number"; Rec."Purchase Order Number")
                {
                }
                field("Ship To"; Rec."Ship To")
                {
                }
                field("Ship Date"; Rec."Ship Date")
                {
                }
                field("Ship Time"; Rec."Ship Time")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Due Time"; Rec."Due Time")
                {
                }
                field("D.A.R Date"; Rec."D.A.R Date")
                {
                }
                field("Qty Due"; Rec."Qty Due")
                {
                }
                field("D.A.R Qty"; Rec."D.A.R Qty")
                {
                }
                field("Change From Last"; Rec."Change From Last")
                {
                }
                field("Qty Shipped to Date"; Rec."Qty Shipped to Date")
                {
                }
                field("Net Due"; Rec."Net Due")
                {
                }
                field("Dock No"; Rec."Dock No")
                {
                }
                field(Warehouse; Rec.Warehouse)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Date Type"; Rec."Date Type")
                {
                }
                field(Route; Rec.Route)
                {
                }
                field("Special Instructions"; Rec."Special Instructions")
                {
                }
                field("Buyer/Planner Name"; Rec."Buyer/Planner Name")
                {
                }
                field("Planner Phone"; Rec."Planner Phone")
                {
                }
                field("Units per Box"; Rec."Units per Box")
                {
                }
                field("Units per Pallet"; Rec."Units per Pallet")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Horizon Start Date"; Rec."Horizon Start Date")
                {
                }
                field("Horizon End Date"; Rec."Horizon End Date")
                {
                }
                field("Range Minimum"; Rec."Range Minimum")
                {
                }
                field("Range Maximum"; Rec."Range Maximum")
                {
                }
                field("A Part"; Rec."A Part")
                {
                }
                field("Tag Slip Remark #1"; Rec."Tag Slip Remark #1")
                {
                }
                field("Tag Slip Remark #2"; Rec."Tag Slip Remark #2")
                {
                }
                field("Tag Slip Remark #3"; Rec."Tag Slip Remark #3")
                {
                }
                field("Schedule Issuer Name"; Rec."Schedule Issuer Name")
                {
                }
                field("Schedule Issuer Address 1"; Rec."Schedule Issuer Address 1")
                {
                }
                field("Schedule Issuer Address 2"; Rec."Schedule Issuer Address 2")
                {
                }
                field("Schedule Issuer Address 3"; Rec."Schedule Issuer Address 3")
                {
                }
                field("Schedule Type"; Rec."Schedule Type")
                {
                }
                field("Error Description"; Rec."Error Description")
                {
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("TRMI Sales Import")
            {
                ApplicationArea = All;
                Caption = 'TRMI Sales Import';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    XmlPortTRMISO: XmlPort "Denso Group Sales File Import";
                    InStr: InStream;
                    FileName: Text;
                begin
                    // Prompt user to pick a CSV
                    if UploadIntoStream('Select a CSV file', '', 'CSV files (*.csv)|*.csv', FileName, InStr) then begin
                        // Pass the file name into the XMLport instance
                        XmlPortTRMISO.Filename(FileName);
                        XmlPortTRMISO.SetSource(InStr);
                        XmlPortTRMISO.Import();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
}

