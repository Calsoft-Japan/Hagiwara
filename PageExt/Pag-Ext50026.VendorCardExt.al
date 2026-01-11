pageextension 50026 VendorCardExt extends "Vendor Card"
{
    layout
    {
        addafter("No.")
        {

            field("Familiar Name"; Rec."Familiar Name")
            {
                ApplicationArea = all;
            }
        }

        addafter("Responsibility Center")
        {

            field("Shipping Terms"; Rec."Shipping Terms")
            {
                ApplicationArea = all;
            }
            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
            field("ORE Ship-to Code"; Rec."ORE Ship-to Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("ORE Reverse Routing Address"; Rec."ORE Reverse Routing Address")
            {
                ApplicationArea = all;
            }
            field("ORE Reverse Routing Address SD"; Rec."ORE Reverse Routing Address SD")
            {
                ApplicationArea = all;
            }
            field("Excluded in ORE Collection"; Rec."Excluded in ORE Collection")
            {
                ApplicationArea = all;
            }
            field("Hagiwara Group"; Rec."Hagiwara Group")
            {
                ApplicationArea = all;
                TableRelation = "Hagiwara Group".Code;
            }
            /*
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
            */
        }

        addafter("Vendor Posting Group")
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

        addafter("Customized Calendar")
        {

            field("Incoterm Code"; Rec."Incoterm Code")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
            field("Incoterm Location"; Rec."Incoterm Location")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
        }

        addbefore("Invoice Disc. Code")
        {
            field("Update PO Price Target Date"; rec."Update PO Price Target Date")
            {
                ApplicationArea = all;
            }
        }

        //2025-08-07
        addafter("Cash Flow Payment Terms Code")
        {
            field("IRS 1099 Code"; Rec."IRS 1099 Code")
            {
                ApplicationArea = All;
                Caption = 'IRS 1099 Code';
                TableRelation = "IRS 1099 Code"; //Link to source table
                Lookup = true; // Allows 'Select from full list' and dropdown

                trigger OnValidate()
                begin
                    CurrPage.Update(); // Optional: triggers UI updates
                end;
            }
        }
        //end 2025-08-07

    }

    actions
    {
        //hide approve related actions of Base App
        modify("Request Approval")
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
        modify(Flow)
        {
            Visible = false;
        }
        modify(Approval)
        {
            Visible = false;
        }
        modify(Approve)
        {
            Visible = false;
        }
        modify(Reject)
        {
            Visible = false;
        }
        modify(Delegate)
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }

        addbefore("F&unctions")
        {
            /*
            group("Hagiwara Approval")
            {
                action("Submit")
                {

                    ApplicationArea = all;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup.Vendor then
                            exit;

                        if rec."Approval Status" in [
                            Enum::"Hagiwara Approval Status"::"Not Applicable",
                            Enum::"Hagiwara Approval Status"::Submitted,
                            Enum::"Hagiwara Approval Status"::"Re-Submitted",
                            Enum::"Hagiwara Approval Status"::"Approved",
                            Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                            Error('This approval request can''t be sent because it''s sent or approved already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::Vendor, Rec."No.", UserId);
                    end;
                }
                action("Cancel")
                {

                    ApplicationArea = all;
                    Image = CancelApprovalRequest;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin
                        recApprSetup.Get();
                        if not recApprSetup.Vendor then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::Vendor, Rec."No.", UserId);
                    end;
                }
                action("Hagi Approve")
                {
                    Caption = 'Approve';
                    ApplicationArea = all;
                    Image = Approve;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup.Vendor then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::Vendor, Rec."No.", UserId);
                    end;
                }
                action("Hagi Reject")
                {
                    Caption = 'Reject';
                    ApplicationArea = all;
                    Image = Reject;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup.Vendor then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::Vendor, Rec."No.", UserId);
                    end;
                }
                action("Approval Entries")
                {

                    ApplicationArea = all;
                    Image = Entries;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        recApprEntry: Record "Hagiwara Approval Entry";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup.Vendor then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::Vendor);
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
            */
        }
    }

    trigger OnOpenPage()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        IncotermVisibility := HagiwaraFunctions.GetIncotermVisibility; //HG10.00.04 NJ 13/02/2018

        /*
        //N005 Begin
        recApprSetup.Get();
        if recApprSetup.Vendor then begin
            CurrPage.Editable(false);
        end;
        //N005 End
        */
    end;

    var
        IncotermVisibility: Boolean;
        HagiwaraFunctions: Codeunit "Hagiwara Functions";
}