tableextension 50015 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(50001; "CU Account Category"; Option)
        {
            Caption = 'Account Category';
            OptionCaption = 'Asset,Liability,Coomon,Cost,Benifit,Profit & Loss';
            OptionMembers = Asset,Liability,Coomon,Cost,Benifit,"Profit & Loss";
        }
        field(50002; "Foereign Currency"; Code[10])
        {
            TableRelation = Currency.Code;
            Caption = 'Currency';
        }
        field(50003; "Complementary Acc. Type"; Option)
        {
            Caption = 'complementary account type';
            OptionCaption = ' ,Customer Transaction,Supplier Transacrtion, Division Computimg';
            OptionMembers = " ","Customer Transaction","Supplier Transaction"," Division Computimg";
        }
        field(50004; "Account Format"; Option)
        {
            Caption = 'Account Format';
            OptionCaption = 'Jin Ge Se,Wai Bi Jin Ge Se';
            OptionMembers = "Jin Ge Se","Wai Bi Jin Ge Se";
        }
        field(50005; "L. Name"; Text[50])
        {
            // cleaned
        }
        field(50006; Name2; Text[50])
        {
            Description = 'ACWSH';
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
    }

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."G/L Account") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."G/L Account") then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                Error('Can''t edit this data because of it''s submitted for approval.');
            end;
        end;
        //N005 End

    end;

    trigger OnAfterInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup."G/L Account") then begin
            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
            Rec.Blocked := true;
        end;
        //N005 End

        Modify();
    end;
}
