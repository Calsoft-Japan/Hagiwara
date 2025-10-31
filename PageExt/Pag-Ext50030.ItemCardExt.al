pageextension 50030 ItemCardExtextends extends "Item Card"
{
    layout
    {
        //N002: Add fields to Item Card page
        addafter("Costs & Posting")
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                Visible = ShowDim1 or ShowDim2 or ShowDim3 or ShowDim4 or ShowDim5 or ShowDim6 or ShowDim7 or ShowDim8;
                field("Shortcut Dimension 1 Code"; ShortcutDimValue1)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(1);
                    Visible = ShowDim1;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(1, ShortcutDimValue1);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 2 Code"; ShortcutDimValue2)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(2);
                    Visible = ShowDim2;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(2, ShortcutDimValue2);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 3 Code"; ShortcutDimValue3)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(3);
                    Visible = ShowDim3;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(3, ShortcutDimValue3);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 4 Code"; ShortcutDimValue4)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(4);
                    Visible = ShowDim4;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(4, ShortcutDimValue4);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 5 Code"; ShortcutDimValue5)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(5);
                    Visible = ShowDim5;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(5, ShortcutDimValue5);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 6 Code"; ShortcutDimValue6)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(6);
                    Visible = ShowDim6;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(6, ShortcutDimValue6);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 7 Code"; ShortcutDimValue7)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(7);
                    Visible = ShowDim7;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(7, ShortcutDimValue7);
                        exit(true);
                    end;
                }
                field("Shortcut Dimension 8 Code"; ShortcutDimValue8)
                {
                    ApplicationArea = All;
                    CaptionClass = GetDimCaption(8);
                    Visible = ShowDim8;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        HandleDimensionLookup(8, ShortcutDimValue8);
                        exit(true);
                    end;
                }
            }
        }
        // End of N002

        addafter("No.")
        {

            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
        }

        addafter(Description)
        {

            field("Parts No."; Rec."Parts No.")
            {
                ApplicationArea = all;
            }
            field(Rank; Rec.Rank)
            {
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = all;
            }
            field("Customer Item No.(Plain)"; Rec."Customer Item No.(Plain)")
            {
                ApplicationArea = all;
            }
            field("OEM No."; Rec."OEM No.")
            {
                ApplicationArea = all;
            }
            field(Products; Rec.Products)
            {
                ApplicationArea = all;
            }
        }

        addafter("Last Date Modified")
        {
            field("Last Time Modified"; Rec."Last Time Modified")
            {
                ApplicationArea = all;
            }
            field(SBU; Rec.SBU)
            {
                ApplicationArea = all;
            }
            field("Planning Receipt (Qty.)"; Rec."Planning Receipt (Qty.)")
            {
                ApplicationArea = all;
            }
            field("Planned Order Receipt (Qty.)"; Rec."Planned Order Receipt (Qty.)")
            {
                ApplicationArea = all;
            }

        }

        addafter(GTIN)
        {


            field(EOL; Rec.EOL)
            {
                ApplicationArea = all;
            }
            field("Order Deadline Date"; Rec."Order Deadline Date")
            {
                ApplicationArea = all;
            }
            field("Service Parts"; Rec."Service Parts")
            {
                ApplicationArea = all;
            }
            field(Memo; Rec.Memo)
            {
                ApplicationArea = all;
            }
            field(EDI; Rec.EDI)
            {
                ApplicationArea = all;
            }
            field("Manufacturer 2 Code"; Rec."Manufacturer 2 Code")
            {
                ApplicationArea = all;
            }
            field("Car Model"; Rec."Car Model")
            {
                ApplicationArea = all;
            }
            field(SOP; Rec.SOP)
            {
                ApplicationArea = all;
            }
            field("MP-Volume(pcs/M)"; Rec."MP-Volume(pcs/M)")
            {
                ApplicationArea = all;
            }
            field(Apl; Rec.Apl)
            {
                ApplicationArea = all;
            }
        }

        addafter("Item Category Code")
        {

            field("Item Group Code"; Rec."Item Group Code")
            {
                ApplicationArea = all;
            }

            field("Message Collected On"; Rec."Message Collected On")
            {
                ApplicationArea = all;
            }
            field("Scheduled Receipt (Qty.)"; Rec."Scheduled Receipt (Qty.)")
            {
                ApplicationArea = all;
            }
        }

        addafter(Inventory)
        {


            field("Inventory Balance"; Rec.Inventory)
            {
                ApplicationArea = all;
                Caption = 'Inventory Balance';
            }
            field(Hold; Rec.Hold)
            {
                ApplicationArea = all;
            }
            field("FCA In-Transit"; Rec."FCA In-Transit")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Available Inventory Balance"; Rec.Inventory - Rec.Hold - Rec."FCA In-Transit")
            {
                ApplicationArea = all;
                Caption = 'Available Inventory Balance';
                DecimalPlaces = 0 : 5;
                Editable = false;
                Lookup = true;
            }
        }

        addafter("Qty. on Purch. Order")
        {


            field("Qty. on Purch. Quote"; Rec."Qty. on Purch. Quote")
            {
                ApplicationArea = all;
            }
            field("Qty. on P. O. (Req Rec Date)"; Rec."Qty. on P. O. (Req Rec Date)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 0;
            }
            field("Cost Amount (Actual)"; Rec."Cost Amount (Actual)")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Quote"; Rec."Qty. on Sales Quote")
            {
                ApplicationArea = all;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit Price")
        {

            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = all;
            }
        }

        addafter("Overhead Rate")
        {


            field("Inventory Shipped"; Rec."Inventory Shipped")
            {
                ApplicationArea = all;
                Caption = 'Inventory Shipped';
            }
            field("Inventory Neg Adj"; Rec."Inventory Neg Adj")
            {
                ApplicationArea = all;
                Caption = 'Inventory Neg Adj.';
            }
            field("Initial Blocked"; Rec."Initial Blocked")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Original Item No."; Rec."Original Item No.")
            {
                ApplicationArea = all;
            }
            field("Lot Size2"; Rec."Lot Size")
            {
                ApplicationArea = all;
            }
        }

        addafter("Net Invoiced Qty.")
        {

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Vendor No.")
        {


            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
            }
            field("One Renesas EDI"; Rec."One Renesas EDI")
            {
                ApplicationArea = all;
            }
            field("Excluded in Inventory Report"; Rec."Excluded in Inventory Report")
            {
                ApplicationArea = all;
            }
            field("Purch. Order Quantity Limit"; Rec."Purch. Order Quantity Limit")
            {
                ApplicationArea = all;
            }
            field(PKG; Rec.PKG)
            {
                ApplicationArea = all;
            }
            field("Inventory Receipt"; Rec."Inventory Receipt")
            {
                ApplicationArea = all;
                Caption = 'Inventory Receipt';
            }
            field("Inventory Pos Adj"; Rec."Inventory Pos Adj")
            {
                ApplicationArea = all;
                Caption = 'Inventory Pos Adj.';
            }
        }

        addafter("Lot Size")
        {

            field("Update Date"; Rec."Update Date")
            {
                ApplicationArea = all;
                Caption = 'Last Update Date';
            }
            field("Update Time"; Rec."Update Time")
            {
                ApplicationArea = all;
                Caption = 'Last Update Time';
            }
            field("Update By"; Rec."Update By")
            {
                ApplicationArea = all;
                Caption = 'Last Update By';
            }
            field("Update Doc. No."; Rec."Update Doc. No.")
            {
                ApplicationArea = all;
                Caption = 'Last Update Doc. No.';
            }
        }

        addafter("Tariff No.")
        {
            field("Country/Region of Org Cd (FE)"; Rec."Country/Region of Org Cd (FE)")
            {
                ApplicationArea = all;
            }
        }
        addafter("Country/Region of Origin Code")
        {
            field("Markup%"; Rec."Markup%")
            {
                ApplicationArea = all;
            }
            field("Markup%(Sales Price)"; Rec."Markup%(Sales Price)")
            {
                ApplicationArea = all;
            }
            field("Markup%(Purchase Price)"; Rec."Markup%(Purchase Price)")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        modify(CopyItem)
        {
            Visible = false;
        }
        modify(RequestApproval)
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
    }


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        //CS028 Begin
        //IF CurrPage.EDITABLE THEN BEGIN  //CS058
        //CS058 Begin
        //IF "Item Supplier Source" = "Item Supplier Source"::Renesas THEN
        //  IF "OEM No." = '' THEN ERROR(Text001);
        Rec.TESTFIELD("Customer No.");
        Rec.TESTFIELD("OEM No.");
        Rec.TESTFIELD("Manufacturer Code");
        //CS058 End
        //END;  //CS058
        //CS028 End
    end;

    //N002: Load default dimensions for Item Card
    trigger OnOpenPage() //Testing purpose-> need to change to OnAfterGetCurrRecord
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        LoadDimensionData(GLSetup."Shortcut Dimension 1 Code", ShortcutDimValue1);
        LoadDimensionData(GLSetup."Shortcut Dimension 2 Code", ShortcutDimValue2);
        LoadDimensionData(GLSetup."Shortcut Dimension 3 Code", ShortcutDimValue3);
        LoadDimensionData(GLSetup."Shortcut Dimension 4 Code", ShortcutDimValue4);
        LoadDimensionData(GLSetup."Shortcut Dimension 5 Code", ShortcutDimValue5);
        LoadDimensionData(GLSetup."Shortcut Dimension 6 Code", ShortcutDimValue6);
        LoadDimensionData(GLSetup."Shortcut Dimension 7 Code", ShortcutDimValue7);
        LoadDimensionData(GLSetup."Shortcut Dimension 8 Code", ShortcutDimValue8);

        //Set visibility flag based on whether shortcut dimension codes are configured
        ShowDim1 := GLSetup."Shortcut Dimension 1 Code" <> '';
        ShowDim2 := GLSetup."Shortcut Dimension 2 Code" <> '';
        ShowDim3 := GLSetup."Shortcut Dimension 3 Code" <> '';
        ShowDim4 := GLSetup."Shortcut Dimension 4 Code" <> '';
        ShowDim5 := GLSetup."Shortcut Dimension 5 Code" <> '';
        ShowDim6 := GLSetup."Shortcut Dimension 6 Code" <> '';
        ShowDim7 := GLSetup."Shortcut Dimension 7 Code" <> '';
        ShowDim8 := GLSetup."Shortcut Dimension 8 Code" <> '';
    end;

    // N002: Load default dimension data for Item Card
    procedure LoadDimensionData(DimCode: Code[20]; var DimValue: Text[100])
    var
        DefaultDim: Record "Default Dimension";
    begin
        if DefaultDim.Get(Database::Item, Rec."No.", DimCode) then
            DimValue := DefaultDim."Dimension Value Code"
        else
            DimValue := '';
    end;

    local procedure GetDimCaption(DimNo: Integer): Text[100]
    var
        GLSetup: Record "General Ledger Setup";
        Dim: Record Dimension;
        DimCode: Code[20];
    begin
        GLSetup.Get();
        DimCode := GetDimCode(DimNo);
        if Dim.Get(DimCode) then
            exit(Dim.Name)
        else
            exit('');
    end;

    local procedure GetDimCode(DimNo: Integer): Code[20]
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        case DimNo of
            1:
                exit(GLSetup."Shortcut Dimension 1 Code");
            2:
                exit(GLSetup."Shortcut Dimension 2 Code");
            3:
                exit(GLSetup."Shortcut Dimension 3 Code");
            4:
                exit(GLSetup."Shortcut Dimension 4 Code");
            5:
                exit(GLSetup."Shortcut Dimension 5 Code");
            6:
                exit(GLSetup."Shortcut Dimension 6 Code");
            7:
                exit(GLSetup."Shortcut Dimension 7 Code");
            8:
                exit(GLSetup."Shortcut Dimension 8 Code");
            else
                exit('');
        end;
    end;

    local procedure HandleDimensionLookup(DimNo: Integer; var DimValue: Text[100])
    var
        DimValueRec: Record "Dimension Value";
        DimCode: Code[20];
        SelectedCode: Code[20];
        PageID: Integer;
    begin
        DimCode := GetDimCode(DimNo);
        if DimCode = '' then
            exit;

        DimValueRec.SetRange("Dimension Code", DimCode);
        PageID := Page::"Dimension Value List";

        if Page.RunModal(PageID, DimValueRec) = Action::LookupOK then begin
            SelectedCode := DimValueRec.Code;
            DimValue := SelectedCode;
        end;
    end;

    var
        ShortcutDimValue1: Text[100];
        ShortcutDimValue2: Text[100];
        ShortcutDimValue3: Text[100];
        ShortcutDimValue4: Text[100];
        ShortcutDimValue5: Text[100];
        ShortcutDimValue6: Text[100];
        ShortcutDimValue7: Text[100];
        ShortcutDimValue8: Text[100];

        // Visibility flags for dynamic control of Shortcut Dimension fields
        ShowDim1: Boolean;
        ShowDim2: Boolean;
        ShowDim3: Boolean;
        ShowDim4: Boolean;
        ShowDim5: Boolean;
        ShowDim6: Boolean;
        ShowDim7: Boolean;
        ShowDim8: Boolean;
    //End of N002
}

