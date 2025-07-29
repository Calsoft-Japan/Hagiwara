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

