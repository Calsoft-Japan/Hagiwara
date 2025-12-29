pageextension 50021 CustomerCardExt extends "Customer Card"
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

        addafter("Name 2")
        {

            field("ORE Customer Name"; Rec."ORE Customer Name")
            {
                ApplicationArea = all;
            }
            field("ORE Address"; Rec."ORE Address")
            {
                ApplicationArea = all;
            }
            field("ORE Address 2"; Rec."ORE Address 2")
            {
                ApplicationArea = all;
            }
            field("Customer Group"; Rec."Customer Group")
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
        addafter("Post Code")
        {

            field("ORE Post Code"; Rec."ORE Post Code")
            {
                ApplicationArea = all;
            }

        }
        addafter(City)
        {

            field("ORE City"; Rec."ORE City")
            {
                ApplicationArea = all;
            }
        }

        addafter(County)
        {

            field("ORE State/Province"; Rec."ORE State/Province")
            {
                ApplicationArea = all;
            }
        }
        addafter("Country/Region Code")
        {

            field("ORE Country"; Rec."ORE Country")
            {
                ApplicationArea = all;
            }
        }

        addafter(ContactName)
        {

            field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    //CS028 Begin
                    IF (Rec."Vendor Cust. Code" <> '') AND (STRLEN(Rec."Vendor Cust. Code") <> 10) THEN ERROR(Text003);
                    //CS028 End
                end;
            }
        }

        addafter("Language Code")
        {

            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = all;
            }
            field("NEC OEM Code"; Rec."NEC OEM Code")
            {
                ApplicationArea = all;
            }
            field("NEC OEM Name"; Rec."NEC OEM Name")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; Rec."Item Supplier Source")
            {
                ApplicationArea = all;
            }
            field("Excluded in ORE Collection"; Rec."Excluded in ORE Collection")
            {
                ApplicationArea = all;
            }
            field("Receiving Location"; Rec."Receiving Location")
            {
                ApplicationArea = all;
            }
        }

        addafter("Registration Number")
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

        addafter("Customer Posting Group")
        {

            field("Import File Ship To"; Rec."Import File Ship To")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }

        addafter("Customized Calendar")
        {

            field("Ship From Name"; Rec."Ship From Name")
            {
                ApplicationArea = all;
            }
            field("Ship From Address"; Rec."Ship From Address")
            {
                ApplicationArea = all;
            }
            field("Default Country/Region of Org"; Rec."Default Country/Region of Org")
            {
                ApplicationArea = all;
            }
            group("Shipping Marks/Remarks")
            {
                field("Shipping Mark1"; Rec."Shipping Mark1")
                {
                    ApplicationArea = all;
                }
                field("Shipping Mark2"; Rec."Shipping Mark2")
                {
                    ApplicationArea = all;
                }
                field("Shipping Mark3"; Rec."Shipping Mark3")
                {
                    ApplicationArea = all;
                }
                field("Shipping Mark4"; Rec."Shipping Mark4")
                {
                    ApplicationArea = all;
                }
                field("Shipping Mark5"; Rec."Shipping Mark5")
                {
                    ApplicationArea = all;
                }
                field(Remarks1; Rec.Remarks1)
                {
                    ApplicationArea = all;
                }
                field(Remarks2; Rec.Remarks2)
                {
                    ApplicationArea = all;
                }
                field(Remarks3; Rec.Remarks3)
                {
                    ApplicationArea = all;
                }
                field(Remarks4; Rec.Remarks4)
                {
                    ApplicationArea = all;
                }
                field(Remarks5; Rec.Remarks5)
                {
                    ApplicationArea = all;
                }
            }
        }

        addafter(Reserve)
        {

            field("Days for Auto Inv. Reservation"; rec."Days for Auto Inv. Reservation")
            {
                ApplicationArea = all;
            }
        }

        addafter("Invoice Disc. Code")
        {
            field("Update SO Price Target Date"; rec."Update SO Price Target Date")
            {
                ApplicationArea = all;
            }
        }

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
        modify(Workflow)
        {
            Visible = false;
        }
        modify(CreateApprovalWorkflow)
        {
            Visible = false;
        }
        modify(ManageApprovalWorkflows)
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
                        if not recApprSetup.Customer then
                            exit;

                        if rec."Approval Status" in [
                            Enum::"Hagiwara Approval Status"::Submitted,
                            Enum::"Hagiwara Approval Status"::"Re-Submitted",
                            Enum::"Hagiwara Approval Status"::"Approved",
                            Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                            Error('This approval request can''t be sent because it''s sent or approved already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::Customer, Rec."No.", UserId);
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
                        if not recApprSetup.Customer then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::Customer, Rec."No.", UserId);
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
                        if not recApprSetup.Customer then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::Customer, Rec."No.", UserId);
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
                        if not recApprSetup.Customer then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::Customer, Rec."No.", UserId);
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
                        if not recApprSetup.Customer then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::Customer);
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }*/
        }
    }

    trigger OnOpenPage()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        /*
        //N005 Begin
        recApprSetup.Get();
        if recApprSetup.Customer then begin
            CurrPage.Editable(false);
        end;
        //N005 End
        */
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin


        //CS028 Begin
        //IF CurrPage.EDITABLE THEN BEGIN  //CS058
        IF Rec."Item Supplier Source" = Rec."Item Supplier Source"::Renesas THEN
            IF Rec."Vendor Cust. Code" = '' THEN ERROR(Text001);
        IF Rec."Vendor Cust. Code" <> '' THEN
            IF Rec."Item Supplier Source" = Rec."Item Supplier Source"::" " THEN ERROR(Text002);
        Rec.TESTFIELD(Rec."Familiar Name");  //CS058
                                             //END;  //CS058
                                             //CS028 End

    end;

    var
        Text001: Label 'Vendor Cust. code must have a value when Item Supplier Source equals to "Renesas".';
        Text002: Label 'Item Supplier Source must equal to "Renesas" when Vendor Cust. Code is not blank.';
        Text003: Label 'Vendor Cust. Code must have 10 digits.';


}