pageextension 50027 VendorListExt extends "Vendor List"
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

        addafter(Name)
        {

            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
            }
            field("Our Account No."; Rec."Our Account No.")
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = all;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field(County; Rec.County)
            {
                ApplicationArea = all;
            }
            field("Home Page"; Rec."Home Page")
            {
                ApplicationArea = all;
            }
            field("Shipping Agent Code"; Rec."Shipping Agent Code")
            {
                ApplicationArea = all;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = all;
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

        addafter("Responsibility Center")
        {

            field("Incoterm Code"; Rec."Incoterm Code")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
        }

        addafter("Location Code")
        {

            field("Incoterm Location"; Rec."Incoterm Location")
            {
                ApplicationArea = all;
                Visible = IncotermVisibility;
            }
            field("Shipping Terms"; Rec."Shipping Terms")
            {
                ApplicationArea = all;
            }
        }

        addafter("Balance Due (LCY)")
        {

            field("Manufacturer Code"; Rec."Manufacturer Code")
            {
                ApplicationArea = all;
            }
        }
        //2025-08-07
        addafter("Payments (LCY)")
        {
            field("IRS 1099 Code"; Rec."IRS 1099 Code")
            {
                ApplicationArea = all;
                Visible = false;
                ToolTip = 'Display the IRS 1099 Code.';
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

        addbefore("Payment Journal")
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
    begin


        IncotermVisibility := HagiwaraFunctions.GetIncotermVisibility; //HG10.00.04 NJ 13/02/2018
    end;

    var
        IncotermVisibility: Boolean;
        HagiwaraFunctions: Codeunit "Hagiwara Functions";
}
