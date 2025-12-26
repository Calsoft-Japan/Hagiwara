pageextension 50018 GLAccountListExt extends "G/L Account List"
{
    layout
    {
        addafter(Name)
        {
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = all;
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = all;
            }
            field("Approval Status"; rec."Approval Status")
            {
                ApplicationArea = all;
            }
            field("Approver"; rec."Hagi Approver")
            {
                ApplicationArea = all;
            }
            field("Requester"; rec."Requester")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnOpenPage()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if recApprSetup."G/L Account" then begin
            if Rec."Approval Status" in
                [Enum::"Hagiwara Approval Status"::Submitted,
                Enum::"Hagiwara Approval Status"::"Re-Submitted",
                Enum::"Hagiwara Approval Status"::Approved,
                Enum::"Hagiwara Approval Status"::"Auto Approved"] then begin

                CurrPage.Editable(false);
            end else begin
                CurrPage.Editable(true);
            end;
        end;
        //N005 End

    end;
}