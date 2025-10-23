tableextension 50038 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50000; "Shipping Terms"; Text[100])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50001; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';

        }
        field(50002; "VAT Category Type Name"; Text[30])
        {
            Caption = 'VAT Category Type Name';
            Description = 'SKLV6.0';
        }
        field(50003; "Non Deductive List"; Option)
        {
            Caption = 'Non Deductive List';
            Description = 'SKLV6.0';
            OptionMembers = D01,D02,D03,D04,D05,D06,D07,D08,D09,D10,D11,D12;
        }
        field(50004; "Other Non Deductive List"; Option)
        {
            Caption = 'Other Non Deductive List';
            Description = 'SKLV6.0';
            OptionMembers = Nothing,Receive,Fiction,Reuse,Inventory,PayBad;
        }
        field(50005; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            Description = 'SKLV6.0';
            OptionCaption = 'Others,Credit Card,Debit Card,Cash,Driver Welfare Card,Company Credit Card';
            OptionMembers = Others,"Credit Card","Debit Card",Cash,"Driver Welfard Card","Company Credit Card";
        }
        field(50006; "Credit Card Code"; Code[10])
        {
            Caption = 'Credit Card Code';
            Description = 'SKLV6.0';

        }
        field(50007; "Credit Card Name"; Text[30])
        {
            Caption = 'Credit Card Name';
            Description = 'SKLV6.0';
        }
        field(50008; "Credit Card No."; Text[30])
        {
            Description = 'SKLV6.0';
        }
        field(50009; "VAT Company Name"; Text[50])
        {
            Caption = 'VAT Company Name';
            Description = 'SKLV6.0';
        }
        field(50010; "Incoterm Code"; Code[20])
        {
            TableRelation = Incoterm;
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50011; "Incoterm Location"; Text[50])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50020; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                recCustomer: Record Customer;
            begin
                IF recCustomer.GET("Customer No.") THEN BEGIN
                    "Customer Name" := recCustomer.Name;
                    "NEC OEM Code" := recCustomer."NEC OEM Code";
                    "NEC OEM Name" := recCustomer."NEC OEM Name";
                    "Vendor Cust. Code" := recCustomer."Vendor Cust. Code";
                END;

            end;
        }
        field(50021; "Customer Name"; Text[50])
        {
            // cleaned
        }
        field(50022; "NEC OEM Code"; Code[20])
        {
            // cleaned
        }
        field(50023; "NEC OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50024; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

            trigger OnValidate()
            var
                InvtSetup: Record "Inventory Setup";
            begin
                IF "Item Supplier Source" <> "Item Supplier Source"::" " THEN BEGIN
                    InvtSetup.GET();
                    InvtSetup.TESTFIELD("Supplier Item Source");
                    TESTFIELD("Buy-from Vendor No.", InvtSetup."Supplier Item Source");
                END;

                //IF Rec."Item Supplier Source" <> xRec."Item Supplier Source" THEN
                //  IF PurchLinesExist THEN ERROR('Purchase Lines has been existed with this Item Supplier Source');
                //<<
            end;
        }
        field(50050; "Message Status(Booking)"; Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051; "Message Collected By(Booking)"; Code[20])
        {
            Editable = false;
        }
        field(50052; "Message Collected On(Booking)"; Date)
        {
            Editable = false;
        }
        field(50053; "Message Revised By"; Code[20])
        {
            Editable = false;
        }
        field(50054; "Message Revised On"; Date)
        {
            Editable = false;
        }
        field(50055; "Message Status(Backlog)"; Option)
        {
            Editable = false;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50056; "Message Collected By(Backlog)"; Code[20])
        {
            Editable = false;
        }
        field(50057; "Message Collected On(Backlog)"; Date)
        {
            Editable = false;
        }
        field(50059; "Vendor Cust. Code"; Code[13])
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50060; "No. Of Message Revisions"; Integer)
        {
            Description = '//20101018';
            Editable = false;
        }
        field(50061; "Save Posting Date (Original)"; Date)
        {
            Editable = false;
        }
        field(50062; "Original Document No."; Code[20])
        {
            Description = '//20131215';
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        // field(50064;"Received Not Invoiced";Boolean)
        // {
        //     AccessByPermission = TableData 120=R;
        //     Caption = 'Received Not Invoiced';
        //     Description = 'HG10.00.08 NJ 29/03/2018';
        //     Editable = false;
        // }
        field(50070; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';

        }
        field(50071; "GST Rate"; Decimal)
        {
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

        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                InvtSetup: Record "Inventory Setup";
                Vend: Record Vendor;
            begin

                //SH 23072012 - Start
                //"Item Supplier Source" := "Item Supplier Source"::" "; //>>

                IF InvtSetup.GET THEN BEGIN
                    IF InvtSetup."Supplier Item Source" = "Buy-from Vendor No." THEN BEGIN
                        "Item Supplier Source" := "Item Supplier Source"::Renesas;
                    END ELSE BEGIN
                        "Item Supplier Source" := "Item Supplier Source"::" ";
                    END;
                END;
                //SH 23072012 - Start

                Vend.get(rec."Buy-from Vendor No.");
                //HG10.00.02 NJ 01/06/2017 -->
                "Shipping Terms" := Vend."Shipping Terms";
                "Incoterm Code" := Vend."Incoterm Code";
                "Incoterm Location" := Vend."Incoterm Location";
                //HG10.00.02 NJ 01/06/2017 <--

            end;
        }


        modify("Expected Receipt Date")
        {
            trigger OnBeforeValidate()
            begin
                // YUKA for Hagiwara 20030228
                IF ("Expected Receipt Date" < WORKDATE) AND ("Expected Receipt Date" <> 0D) THEN
                    ERROR(Text111);
                IF "Expected Receipt Date" > CALCDATE('+6M', WORKDATE) THEN
                    ERROR(Text112);
                // YUKA for Hagiwara 20030228 - END
            end;

        }
    }
    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Purchase Order") and (Rec."Document Type" = Rec."Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                ) then begin
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
        if ((recApprSetup."Purchase Order") and (Rec."Document Type" = Rec."Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                ) then begin
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
        "Goods Arrival Date" := WORKDATE;

        //N005 Begin
        recApprSetup.Get();
        if ((recApprSetup."Purchase Order") and (Rec."Document Type" = Rec."Document Type"::Order)
            or (recApprSetup."Purchase Credit Memo") and (Rec."Document Type" = Rec."Document Type"::"Credit Memo")
            or (recApprSetup."Purchase Return Order") and (Rec."Document Type" = Rec."Document Type"::"Return Order")
                ) then begin
            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
        end;
        //N005 End

        Modify();
    end;

    procedure ResetReleaseNos()
    var
        nextReleaseNo: Integer;
    begin
        //HG10.00.02 NJ 01/06/2017 -->
        PurchSetup.GET;
        IF NOT PurchSetup."Maintain Release No." THEN
            EXIT;

        nextReleaseNo := 10;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        IF PurchLine.FINDSET(TRUE) THEN
            REPEAT
                PurchLine."Description 2" := FORMAT(nextReleaseNo);
                PurchLine.MODIFY;

                nextReleaseNo += 10;
            UNTIL PurchLine.NEXT = 0;
        //HG10.00.02 NJ 01/06/2017 <--
    end;

    var

        Text111: Label 'Expected Receipt Date is before work date';
        Text112: Label 'Expected Receipt Date is more than 6 month later';
}
