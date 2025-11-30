tableextension 50083 "Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        field(50001; "CO No."; Code[6])
        {
            Description = '//SiakHui: To Print  CO No. in Posted Purchase Receipt Report (ID:50018)';
        }
        field(50002; Division; Code[20])
        {
            // cleaned
        }
        field(50003; SalesPerson; Code[20])
        {
            // cleaned
        }
        field(50004; SalesPurchaser; Code[10])
        {
            // cleaned
        }
        field(50005; Applyto; Integer)
        {
            // cleaned
        }
        field(50006; "Sales Order No."; Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50007; "Purchase Order No."; Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50091; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(50092; Requester; Code[50])
        {
            Editable = false;
        }
        field(50093; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }
        field(90010; "Customer Item No."; Code[20])
        {
            Editable = false;
        }
        field(90011; Rank; Code[15])
        {
            Editable = false;
        }
        field(90012; "Parts No."; Code[40])
        {
            Editable = false;
        }
    }


    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        case
            "Source Code" of
            'ITEMJNL':
                begin

                    recApprSetup.Get();
                    if (recApprSetup."Item Journal") then begin
                        if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then begin
                            Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
                        end;
                    end;
                end;
            'RECLASSJNL':
                begin

                    recApprSetup.Get();
                    if (recApprSetup."Item Reclass Journal") then begin
                        if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then begin
                            Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
                        end;
                    end;
                end;
            else begin
                //Do nothing.
            end;
        end;
        //N005 End

    end;

    trigger OnAfterModify()
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
        cuApprMgt: Codeunit "Hagiwara Approval Management";
        recLocation: Record Location;
    begin

        //N005 Begin

        recApprSetup.Get();
        case
            "Source Code" of
            'ITEMJNL':
                begin

                    if (recApprSetup."Item Journal") then begin
                        //check if location is approval target.
                        if (xRec."Location Code" <> Rec."Location Code") then begin
                            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
                            Rec.Modify();

                            if (recLocation.Get(Rec."Location Code")) and (not recLocation."Approval Target") then begin
                                cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
                            end;
                        end;
                    end;
                end;
            'RECLASSJNL':
                begin

                    if (recApprSetup."Item Reclass Journal") then begin
                        //check if location is approval target.
                        if (xRec."New Location Code" <> Rec."New Location Code") or (xRec."Location Code" <> Rec."Location Code") then begin
                            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
                            Rec.Modify();

                            if (recLocation.Get(Rec."New Location Code")) and (not recLocation."Approval Target")
                            and (recLocation.Get(Rec."Location Code")) and (not recLocation."Approval Target") then begin
                                cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
                            end;
                        end;
                    end;
                end;
            else begin
                //Do nothing.
            end;
        end;

        //N005 End

    end;


    trigger OnBeforeInsert()
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        case
            "Source Code" of
            'ITEMJNL':
                begin
                    if (recApprSetup."Item Journal") then begin
                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        ItemJourLine.SetFilter("Approval Status", '%1|%2', Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted");
                        if Not ItemJourLine.IsEmpty then begin
                            Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
                        end;

                        Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;

                    end;
                end;
            'RECLASSJNL':
                begin
                    if (recApprSetup."Item Reclass Journal") then begin
                        ItemJourLine.SetRange("Document No.", Rec."Document No.");
                        ItemJourLine.SetFilter("Approval Status", '%1|%2', Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted");
                        if Not ItemJourLine.IsEmpty then begin
                            Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
                        end;

                        Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;

                    end;
                end;
            else begin
                //Do nothing.
            end;
        end;

    end;

    trigger OnAfterInsert()
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
        cuApprMgt: Codeunit "Hagiwara Approval Management";
        recLocation: Record Location;
    begin

        //N005 Begin
        recApprSetup.Get();
        case
            "Source Code" of
            'ITEMJNL':
                begin
                    if (recApprSetup."Item Journal") then begin
                        //check if location is approval target.
                        if (recLocation.Get(Rec."New Location Code")) and (not recLocation."Approval Target")
                        and (recLocation.Get(Rec."Location Code")) and (not recLocation."Approval Target") then begin

                            cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
                        end;
                    end;
                end;
            'RECLASSJNL':
                begin
                    if (recApprSetup."Item Reclass Journal") then begin
                        //check if location is approval target.
                        if (recLocation.Get(Rec."New Location Code")) and (not recLocation."Approval Target")
                        and (recLocation.Get(Rec."Location Code")) and (not recLocation."Approval Target") then begin

                            cuApprMgt.AutoApprove(enum::"Hagiwara Approval Data"::"Item Journal", Rec."Document No.", UserId);
                        end;
                    end;
                end;
            else begin
                //Do nothing.
            end;
        end;

        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        ItemJourLine: Record "Item Journal Line";
        recApprSetup: Record "Hagiwara Approval Setup";
    begin

        //N005 Begin
        recApprSetup.Get();
        case
            "Source Code" of
            'ITEMJNL':
                begin
                    if (recApprSetup."Item Journal") then begin
                        if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then begin
                            Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
                        end;

                        if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                            Error('Can''t edit this data because of it''s approved.');
                        end;
                    end;
                end;
            'RECLASSJNL':
                begin
                    if (recApprSetup."Item Reclass Journal") then begin
                        if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then begin
                            Error('Can''t edit this data because lines of this Document No. are submitted for approval.');
                        end;

                        if (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                            Error('Can''t edit this data because of it''s approved.');
                        end;
                    end;
                end;
            else begin
                //Do nothing.
            end;
        end;

        //N005 End

    end;



}
