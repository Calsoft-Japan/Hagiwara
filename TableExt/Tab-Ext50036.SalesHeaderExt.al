tableextension 50036 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50000; "VAT Company Code"; Code[10])
        {
            Caption = 'VAT Company Code';
            Description = 'SKLV6.0';

        }
        field(50001; "VAT Company Name"; Text[50])
        {
            Caption = 'VAT Company Name';
            Description = 'SKLV6.0';
        }
        field(50002; "VAT Category Type Code"; Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';

        }
        field(50003; "VAT Category Type Name"; Text[50])
        {
            Caption = 'VAT Category Type Name';
            Description = 'SKLV6.0';
        }
        field(50004; "Export Document Code"; Code[10])
        {
            Caption = 'Export Doc. Code';
            Description = 'SKLV6.0';

        }
        field(50005; "Export Document Name"; Text[50])
        {
            Caption = 'Export Doc. Name';
            Description = 'SKLV6.0';
        }
        field(50006; "L/C Export No."; Text[30])
        {
            Caption = 'L/C Export No.';
            Description = 'SKLV6.0';
        }
        field(50007; "Export Document Issuer"; Text[30])
        {
            Caption = 'Export Document Issuer';
            Description = 'SKLV6.0';
        }
        field(50008; "Issue Date"; Date)
        {
            Caption = 'Issue Date';
            Description = 'SKLV6.0';
        }
        field(50009; "Shipping Date"; Date)
        {
            Caption = 'Shipping Date';
            Description = 'SKLV6.0';
        }
        field(50010; "OEM No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("Customer Type" = CONST(OEM));
        }
        field(50011; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50012; "Submit Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Submit Amount';
            Description = 'SKLV6.0';
        }
        field(50013; "Submit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Submit Amount (LCY)';
            Description = 'SKLV6.0';
        }
        field(50020; From; Text[30])
        {
            // cleaned
        }
        field(50021; "To"; Text[30])
        {
            // cleaned
        }
        field(50050; "Message Status(Booking)"; Option)
        {
            Editable = true;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50051; "Message Collected By(Booking)"; Code[50])
        {
            Editable = false;
        }
        field(50052; "Message Collected On(Booking)"; Date)
        {
            Editable = true;
        }
        field(50053; "Message Revised By"; Code[50])
        {
            Editable = false;
        }
        field(50054; "Message Revised On"; Date)
        {
            Editable = false;
        }
        field(50055; "Message Status(Backlog)"; Option)
        {
            Editable = true;
            OptionCaption = 'Ready to Collect,Collected,Revise,Sent';
            OptionMembers = "Ready to Collect",Collected,Revise,Sent;
        }
        field(50056; "Message Collected By(Backlog)"; Code[50])
        {
            Editable = false;
        }
        field(50057; "Message Collected On(Backlog)"; Date)
        {
            Editable = false;
        }
        field(50058; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
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
        field(50061; "Message Revised at"; Time)
        {
            // cleaned
        }
        field(50062; "Save Posting Date (Original)"; Date)
        {
            Editable = false;
        }
        field(50063; "Last Serial No."; Integer)
        {
            // cleaned
        }
        field(50064; "Final Customer No."; Code[20])
        {
            TableRelation = "Final Customer" WHERE("Customer No." = FIELD("Sell-to Customer No."));
            Caption = 'No.';
        }
        field(50065; "Final Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(50066; "Revised JA Collection Date"; Date)
        {
            // cleaned
        }
        field(50067; "Revised JC Collection Date"; Date)
        {
            // cleaned
        }
        field(50068; "Original Doc. No."; Code[20])
        {
            Description = '//20131215';
        }
        field(50069; "Qty Invoiced"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Quantity Invoiced" WHERE("Document No." = FIELD("No.")));
            Description = '//20140808 Siak Hui';
        }
        field(50070; "Qty Ordered"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line".Quantity WHERE("Document No." = FIELD("No.")));
            Description = '//20140808 Siak Hui';
        }
        field(50071; "Qty Outstanding (Actual)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Quantity (Actual)" WHERE("Document No." = FIELD("No.")));
            Description = '//20140808 Siak Hui';
        }
        field(50072; "Order Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Line" WHERE("Document No." = FIELD("No."), Type = FILTER(Item)));
            Description = '//20140808 Siak Hui';
        }
        field(50073; "Full Shipped Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Line" WHERE("Document No." = FIELD("No."), Type = FILTER(Item), "Outstanding Quantity (Actual)" = CONST(0)));
            Description = '//20140808 Siak Hui';
        }
        field(50074; "Qty Shipped"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Quantity Shipped" WHERE("Document No." = FIELD("No.")));
            Description = '//20140808 Siak Hui';
        }
        field(50075; "Shipment Tracking Date"; Date)
        {
            Description = '//20180225 by SS';
        }
        field(50076; "Ship-to Address Type"; Option)
        {
            Description = 'CS019';
            OptionCaption = 'Sell-to,Ship-to,Custom';
            OptionMembers = "Sell-to","Ship-to",Custom;
        }
        field(50080; "Request Delivery Time"; Time)
        {
            Caption = 'Request Delivery Time';
        }
        field(50081; Approver; Text[8])
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50082; Receiver; Text[8])
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50083; Cancelled; Boolean)
        {
            Description = 'ACWHKGT01.1,ACWSH';

        }
        field(50084; "Golden Tax"; Boolean)
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50085; Biller; Text[8])
        {
            Description = 'ACWHKGT01.1,ACWSH';
        }
        field(50545; "Requested Delivery Date_1"; Date)
        {

        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                ShipToAddr: Record "Ship-to Address";
            begin
                GetCust("Sell-to Customer No.");
                //Siak
                "Salesperson Code" := Customer."Salesperson Code";
                //
                //Raja
                "Item Supplier Source" := Customer."Item Supplier Source"; //>>
                "Vendor Cust. Code" := Customer."Vendor Cust. Code"; //>>
                //Raja End

                //HG10.00.02 NJ 01/06/2017 -->
                ShipToAddr.RESET;
                ShipToAddr.SETRANGE("Customer No.", "Sell-to Customer No.");
                ShipToAddr.SETRANGE("Sales Order Default", TRUE);
                IF ShipToAddr.FINDFIRST THEN
                    VALIDATE("Ship-to Code", ShipToAddr.Code);
                //HG10.00.02 NJ 01/06/2017 <--

                VALIDATE("Posting Date"); //HG10.00.02 NJ 01/06/2017

            end;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                // SKLV6.0 START
                GetCust("Bill-to Customer No.");
                IF GLSetup."Korea Company" THEN BEGIN
                    GLSetup.GET;
                    GLSetup.TESTFIELD("Default VAT Company Code");
                    VALIDATE("VAT Company Code", GLSetup."Default VAT Company Code");
                    //ToDo need to confirm keep this function or not, because the following fields not found. 
                    //VALIDATE("VAT Category Type Code", Customer."VAT Category Type Code"); 
                END;
                // SKLV6.0 END

            end;
        }


        modify("Posting Date")
        {
            trigger OnAfterValidate()
            var
                PaymentTerms: Record "Payment Terms";
            begin
                //HG10.00.02 NJ 01/06/2017 -->
                IF PaymentTerms.GET("Payment Terms Code") THEN BEGIN
                    IF PaymentTerms."Special Due Date Calc" = 1 THEN BEGIN
                        IF DATE2DMY("Posting Date", 1) > 15 THEN
                            "Due Date" := CALCDATE('CM+15D', "Posting Date")
                        ELSE
                            "Due Date" := CALCDATE('CM', "Posting Date");
                        MODIFY;
                    END;
                END;
                //HG10.00.02 NJ 01/06/2017 <--

                "Shipment Tracking Date" := "Posting Date"; //20180225 by SS
            end;
        }

        modify("Shipment Date")
        {
            trigger OnAfterValidate()
            var
                PaymentTerms: Record "Payment Terms";
                GLSetup: Record "General Ledger Setup";
                Text101: Label 'Shipment Date is before workdate';
                Text102: Label 'Shipment Date is more than 6 month later';
            begin
                // YUKA for Hagiwara 20030228
                IF "Shipment Date" < WORKDATE THEN
                    ERROR(Text101);
                GLsetup.GET;
                IF NOT GLsetup."Korea Company" THEN BEGIN
                    IF "Shipment Date" > CALCDATE('+6M', WORKDATE) THEN
                        ERROR(Text102);
                END;
                // YUKA for Hagiwara 20030228 - END
            end;
        }

        modify("External Document No.")
        {
            trigger OnAfterValidate()
            begin
                // SKHE1209-02 2012.09.17 START
                UpdateSalesLines_Ext(FIELDCAPTION("External Document No."), FALSE);
                // SKHE1209-02 2012.09.17 END
            end;
        }

        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin
                UpdateSalesLines_Ext(FIELDCAPTION("Requested Delivery Date"), FALSE); //sanjeev
            end;
        }

        modify("Promised Delivery Date")
        {
            trigger OnAfterValidate()
            begin
                UpdateSalesLines_Ext(FIELDCAPTION("Promised Delivery Date"), FALSE); //sanjeev
            end;
        }

    }

    local procedure UpdateSalesLines_Ext(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        myInt: Integer;
    begin
        IF NOT SalesLinesExist THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                CASE ChangedFieldName OF
                    FIELDCAPTION("Requested Delivery Date"):

                        IF SalesLine."No." <> '' THEN BEGIN
                            SalesLine.VALIDATE("Requested Delivery Date_1", "Shipment Date");//sanjeev
                        end;
                    FIELDCAPTION("Promised Delivery Date"):

                        IF SalesLine."No." <> '' THEN BEGIN
                            SalesLine.VALIDATE("Promised Delivery Date_1", "Shipment Date");//sanjeev
                        end;
                    //SKHE 2012.09. 17 - Start : Modified Customer Order No. of Line with External Doc. No. of Header
                    FIELDCAPTION("External Document No."):
                        IF ("Document Type" = "Document Type"::Order) AND
                          (SalesLine."Customer Order No." <> "External Document No.") THEN
                            SalesLine."Customer Order No." := "External Document No.";
                //SKHE 2012.09. 17 - ENd

                end;
                SalesLine.MODIFY(TRUE);
            UNTIL SalesLine.NEXT = 0;

    end;

}
