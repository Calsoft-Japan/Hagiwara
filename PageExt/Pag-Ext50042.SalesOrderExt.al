pageextension 50042 SalesOrderExt extends "Sales Order"
{
    layout
    {

        addafter("Sell-to Contact")
        {
            field("OEM No."; rec."OEM No.")
            {
                ApplicationArea = all;
            }
            field("OEM Name"; rec."OEM Name")
            {
                ApplicationArea = all;
            }
            field("Original Doc. No."; rec."Original Doc. No.")
            {
                ApplicationArea = all;
                Caption = 'X-Ref Document No.';
            }

        }

        addafter("External Document No.")
        {

            field("Shipment Tracking Date"; rec."Shipment Tracking Date")
            {
                ApplicationArea = all;
            }
            field("Vendor Cust. Code"; rec."Vendor Cust. Code")
            {
                ApplicationArea = all;
            }
            field("Item Supplier Source"; rec."Item Supplier Source")
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
            field("Approval Cycle No."; rec."Approval Cycle No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {

            field("Message Status(Booking)"; rec."Message Status(Booking)")
            {
                ApplicationArea = all;
            }
            field("Message Collected By(Booking)"; rec."Message Collected By(Booking)")
            {
                ApplicationArea = all;
            }
            field("Message Collected On(Booking)"; rec."Message Collected On(Booking)")
            {
                ApplicationArea = all;
            }
        }

        addafter("Currency Code")
        {

            field("Currency Factor"; rec."Currency Factor")
            {
                ApplicationArea = all;
            }
            field("Revised JA Collection Date"; rec."Revised JA Collection Date")
            {
                ApplicationArea = all;
            }
            field("No. Of Message Revisions"; rec."No. Of Message Revisions")
            {
                ApplicationArea = all;
            }
            field("Message Revised By"; rec."Message Revised By")
            {
                ApplicationArea = all;
            }
            field("Message Revised On"; rec."Message Revised On")
            {
                ApplicationArea = all;
            }
            field("Message Revised at"; rec."Message Revised at")
            {
                ApplicationArea = all;
            }
        }

        addafter("Outbound Whse. Handling Time")
        {

            field("Last Serial No."; rec."Last Serial No.")
            {
                ApplicationArea = all;
            }

            field("Final Customer No."; rec."Final Customer No.")
            {
                ApplicationArea = all;
            }

            field("Final Customer Name"; rec."Final Customer Name")
            {
                ApplicationArea = all;
            }

            field("Message Status(Backlog)"; rec."Message Status(Backlog)")
            {
                ApplicationArea = all;
            }

            field("Message Collected By(Backlog)"; rec."Message Collected By(Backlog)")
            {
                ApplicationArea = all;
            }

            field("Message Collected On(Backlog)"; rec."Message Collected On(Backlog)")
            {
                ApplicationArea = all;
            }

            field("Revised JC Collection Date"; rec."Revised JC Collection Date")
            {
                ApplicationArea = all;
            }

            field("Save Posting Date (Original)"; rec."Save Posting Date (Original)")
            {
                ApplicationArea = all;
            }

        }


        addafter("Ship-to City")
        {

            field(County; rec."Ship-to County")
            {
                ApplicationArea = all;
                Editable = ShipToOptions = ShipToOptions::"Custom Address";
            }
            field(From; rec.From)
            {
                ApplicationArea = all;
            }
            field(To; rec."To")
            {
                ApplicationArea = all;
            }
        }

        addafter(BillToOptions)
        {

            field("Bill-to Customer No."; rec."Bill-to Customer No.")
            {
                ApplicationArea = all;
            }
        }


        modify(ShippingOptions)
        {
            trigger OnAfterValidate()
            begin

                CASE ShipToOptions OF
                    ShipToOptions::"Default (Sell-to Address)":
                        BEGIN
                            Rec."Ship-to Address Type" := Rec."Ship-to Address Type"::"Sell-to"; //CS019
                        END;
                    ShipToOptions::"Alternate Shipping Address":
                        BEGIN
                            Rec."Ship-to Address Type" := Rec."Ship-to Address Type"::"Ship-to"; //CS019
                        END;
                    ShipToOptions::"Custom Address":
                        BEGIN
                            Rec."Ship-to Address Type" := Rec."Ship-to Address Type"::Custom; //CS019
                        END;
                END;
            end;
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


        modify("SendEmailConfirmation")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                //N005 Begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
                //N005 End
            end;
        }

        modify("Print Confirmation")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                //N005 Begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
                //N005 End
            end;
        }

        modify("AttachAsPDF")
        {
            trigger OnBeforeAction()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                //N005 Begin
                recApprSetup.Get();
                if not recApprSetup."Sales Order" then
                    exit;

                if not (Rec."Approval Status" in [enum::"Hagiwara Approval Status"::Approved, enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                    Error('It is not approved yet.');
                end;
                //N005 End
            end;
        }

        addbefore("P&osting")
        {
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
                        if not recApprSetup."Sales Order" then
                            exit;

                        if rec."Approval Status" in [
                            Enum::"Hagiwara Approval Status"::Submitted,
                            Enum::"Hagiwara Approval Status"::"Re-Submitted",
                            Enum::"Hagiwara Approval Status"::"Approved",
                            Enum::"Hagiwara Approval Status"::"Auto Approved"] then
                            Error('This approval request can''t be sent because it''s sent or approved already.');

                        if not Confirm('Do you want to submit an approval request?') then
                            exit;

                        cuApprMgt.Submit(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
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
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be cancelled.');

                        if rec.Requester <> UserId then
                            Error('You are not the Requester of this data.');

                        if not Confirm('Do you want to cancel the approval request?') then
                            exit;

                        cuApprMgt.Cancel(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
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
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be approved.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to approve it?') then
                            exit;

                        cuApprMgt.Approve(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
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
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"]) then
                            Error('This approval request can not be rejected.');

                        if rec."Hagi Approver" <> UserId then
                            Error('You are not the Approver of this data.');

                        if not Confirm('Do you want to reject it?') then
                            exit;

                        cuApprMgt.Reject(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
                    end;
                }
                action("Update")
                {
                    Caption = 'Update';
                    ApplicationArea = all;
                    Image = ResetStatus;

                    trigger OnAction()
                    var
                        recApprSetup: Record "Hagiwara Approval Setup";
                        cuApprMgt: Codeunit "Hagiwara Approval Management";
                    begin

                        recApprSetup.Get();
                        if not recApprSetup."Sales Order" then
                            exit;

                        if not (rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then
                            exit;

                        if not Confirm('Do you want to update it?\\You need to start approval process from the beginning after updated.') then
                            exit;

                        cuApprMgt.Update(enum::"Hagiwara Approval Data"::"Sales Order", Rec."No.", UserId);
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
                        if not recApprSetup."Sales Order" then
                            exit;

                        recApprEntry.SetRange(Data, Enum::"Hagiwara Approval Data"::"Sales Order");
                        recApprEntry.SetRange("No.", Rec."No.");
                        Page.RunModal(Page::"Hagiwara Approval Entries", recApprEntry);
                    end;
                }
            }
        }
    }

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";


    trigger OnOpenPage()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if recApprSetup."Sales Order" then begin
            if Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Submitted, Enum::"Hagiwara Approval Status"::"Re-Submitted"] then begin
                CurrPage.Editable(false);
            end else begin
                CurrPage.Editable(true);
            end;
        end;
        //N005 End

    end;

    procedure ChangeQty()
    var
        myInt: Integer;
    begin

        // YUKA for Hagiwara 20030415
        // Change Qty to Ship to zero
        SalesLine.SETRANGE(SalesLine."Document Type", rec."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", rec."No.");

        IF SalesLine.FIND('-') THEN
            REPEAT
                SalesLine.VALIDATE("Qty. to Ship", 0);
                SalesLine.MODIFY();
            UNTIL SalesLine.NEXT = 0;

    end;

    procedure Update_MessageInfo()
    VAR
        rec_MessageCollection: Record "Message Collection";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        Revise_JA: Label 'Do you want to revise Sales Booking (JA) Message? ';
        rec_MsgControl: Record "Message Control";
        Revise_JC: Label 'Do you want to revise Sales Backlog (JC) Message? ';
    begin

        //>>
        // Revise Booking Data ..
        //shIF "Message Status(Booking)" IN ["Message Status(Booking)"::Collected,"Message Status(Booking)":: Sent] THEN

        //siak Hui 12/05/2011
        IF rec."Message Status(Booking)" IN [rec."Message Status(Booking)"::Collected, rec."Message Status(Booking)"::Sent] THEN
            //IF "Message Status(Booking)" IN ["Message Status(Booking)"::Collected] THEN
            BEGIN
            /*   //18/10/2010 - would like to allow them to Revise even they sent msg
            IF rec."Message Status(Booking)" = rec."Message Status(Booking)"::Sent THEN
                  ERROR('Unable to Revise, Message has been already Sent');
            */
            rec_MessageCollection.RESET;
            rec_MessageCollection.SETRANGE("Source Document No.", rec."No.");
            //shrec_MessageCollection.SETFILTER("Message Status",'<>%1',rec_MessageCollection."Message Status"::Cancelled);
            rec_MessageCollection.SETFILTER("Message Status", '=%1', rec_MessageCollection."Message Status"::Ready);
            rec_MessageCollection.SETFILTER("File ID", '=%1', 'JA');
            rec_MessageCollection.SETFILTER(Quantity, '<>%1', 0);
            //shIF "Message Status(Booking)" = "Message Status(Booking)"::Sent THEN
            rec_MessageCollection.SETFILTER("Collected On", '=%1', TODAY);
            IF rec_MessageCollection.FINDSET THEN BEGIN
                IF CONFIRM(Revise_JA, FALSE) THEN BEGIN
                    ReleaseSalesDoc.PerformManualReopen(Rec);
                    rec."Message Status(Booking)" := rec."Message Status(Booking)"::"Ready to Collect";
                    rec."Message Revised By" := USERID;
                    rec."Message Revised On" := TODAY;
                    rec."Revised JA Collection Date" := 0D;
                    rec."No. Of Message Revisions" := rec."No. Of Message Revisions" + 1;
                    rec.MODIFY;
                    //sh-err  rec_MsgControl.Update_MsgControl('JA',1,rec_MessageCollection.Quantity,rec_MessageCollection."Sales Price");
                    REPEAT
                        rec_MsgControl.Update_MsgControl('JA', 1, rec_MessageCollection.Quantity, rec_MessageCollection."Sales Price");
                        //sh      IF rec_MessageCollection."Message Status" = rec_MessageCollection."Message Status"::Sent THEN
                        //sh         rec_MessageCollection.VALIDATE("Message Status",rec_MessageCollection."Message Status"::"Cancelled(After Sent)")
                        //sh      ELSE
                        rec_MessageCollection.VALIDATE("Message Status", rec_MessageCollection."Message Status"::Cancelled);
                        rec_MessageCollection.VALIDATE("Cancelled By", USERID);
                        rec_MessageCollection.VALIDATE("Cancelled On", TODAY);
                        rec_MessageCollection.MODIFY;
                        //Siak Hui 20110502
                        IF SalesLine.GET
                             (SalesLine."Document Type"::Order, rec_MessageCollection."Source Document No.",
                             rec_MessageCollection."Source Document Line No.") THEN BEGIN
                            IF SalesLine."Message Status" = SalesLine."Message Status"::Collected THEN BEGIN
                                SalesLine.VALIDATE("Message Status", SalesLine."Message Status"::"Ready to Collect");
                                SalesLine."Update Date" := TODAY;
                                SalesLine."Update Time" := TIME;
                                SalesLine."Update By" := USERID;
                                SalesLine.MODIFY;
                            END;
                        END;
                    //Siak Hui 20110502 - END
                    UNTIL rec_MessageCollection.NEXT = 0;
                    //<<
                END;
            END;
        END
        ELSE
            MESSAGE('Sales Booking Data has not collected to Revise');
        //<<

        //>>
        // Revise Backlog Data ..
        //Siak Hui 12/05/2011 .. Do not revised already Sent Message!!
        IF rec."Message Status(Backlog)" IN [rec."Message Status(Backlog)"::Collected, rec."Message Status(Backlog)"::Sent] THEN
          //IF "Message Status(Backlog)" IN ["Message Status(Backlog)"::Collected] THEN
          BEGIN
            rec_MessageCollection.RESET;
            rec_MessageCollection.SETRANGE("Source Document No.", rec."No.");
            rec_MessageCollection.SETFILTER("Message Status", '=%1', rec_MessageCollection."Message Status"::Ready);
            rec_MessageCollection.SETFILTER("File ID", '=%1', 'JC');
            rec_MessageCollection.SETFILTER(Quantity, '<>%1', 0);
            //shIF "Message Status(Booking)" = "Message Status(Backlog)"::Sent THEN
            rec_MessageCollection.SETFILTER("Collected On", '=%1', TODAY);
            IF rec_MessageCollection.FINDSET THEN BEGIN
                IF CONFIRM(Revise_JC, FALSE) THEN BEGIN
                    ReleaseSalesDoc.PerformManualReopen(Rec);
                    rec."Message Status(Backlog)" := rec."Message Status(Backlog)"::"Ready to Collect";
                    rec."Message Revised By" := USERID;
                    rec."Message Revised On" := TODAY;
                    rec."Revised JC Collection Date" := 0D;
                    rec."No. Of Message Revisions" := rec."No. Of Message Revisions" + 1;
                    rec.MODIFY;
                    //sh-err  rec_MsgControl.Update_MsgControl('JC',1,rec_MessageCollection.Quantity,rec_MessageCollection."Sales Price");
                    REPEAT
                        rec_MsgControl.Update_MsgControl('JC', 1, rec_MessageCollection.Quantity, rec_MessageCollection."Sales Price");
                        //        IF rec_MessageCollection."Message Status" = rec_MessageCollection."Message Status"::Sent THEN
                        //           rec_MessageCollection.VALIDATE("Message Status",rec_MessageCollection."Message Status"::"Cancelled(After Sent)")
                        //        ELSE
                        rec_MessageCollection.VALIDATE("Message Status", rec_MessageCollection."Message Status"::Cancelled);
                        rec_MessageCollection.VALIDATE("Cancelled By", USERID);
                        rec_MessageCollection.VALIDATE("Cancelled On", TODAY);
                        rec_MessageCollection.MODIFY;
                        //Siak Hui 20110502
                        IF SalesLine.GET
                           (SalesLine."Document Type"::Order, rec_MessageCollection."Source Document No.",
                           rec_MessageCollection."Source Document Line No.") THEN BEGIN
                            IF SalesLine."Message Status (JC)" = SalesLine."Message Status (JC)"::Collected THEN BEGIN
                                SalesLine.VALIDATE("Message Status", SalesLine."Message Status"::"Ready to Collect");
                                SalesLine."Update Date" := TODAY;
                                SalesLine."Update Time" := TIME;
                                SalesLine."Update By" := USERID;
                                SalesLine.Revised := '1';
                                SalesLine.MODIFY;
                            END;
                        END;
                    //Siak Hui 20110502 - END
                    UNTIL rec_MessageCollection.NEXT = 0;
                    //<<
                END;
            END;
        END
        ELSE
            MESSAGE('SO Backlog Data has not collected to Revise');
        //<<
    END;

}