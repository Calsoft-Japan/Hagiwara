//CS092 2025/11/25 Channing.Zhou N014 Customer Import Lines
page 50120 "Customer Import Lines"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    Caption = 'Customer Import Lines';
    SourceTable = "Customer Import Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch Name"; Rec."Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = all;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = all;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = all;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = all;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = all;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = all;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = all;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    ApplicationArea = all;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = all;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                }
                field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
                {
                    ApplicationArea = all;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("Collection Method"; Rec."Collection Method")
                {
                    ApplicationArea = all;
                }
                field("Print Statements"; Rec."Print Statements")
                {
                    ApplicationArea = all;
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ApplicationArea = all;
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = all;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = all;
                }
                field("Combine Shipments"; Rec."Combine Shipments")
                {
                    ApplicationArea = all;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field(GLN; Rec.GLN)
                {
                    ApplicationArea = all;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = all;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = all;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = all;
                }
                field("Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = all;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = all;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = all;
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                    ApplicationArea = all;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = all;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = all;
                }
                field("Partner Type"; Rec."Partner Type")
                {
                    ApplicationArea = all;
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ApplicationArea = all;
                }
                field("Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                    ApplicationArea = all;
                }
                field("Primary Contact No."; Rec."Primary Contact No.")
                {
                    ApplicationArea = all;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = all;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    ApplicationArea = all;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = all;
                }
                field("Service Zone Code"; Rec."Service Zone Code")
                {
                    ApplicationArea = all;
                }
                field("Contract Gain/Loss Amount"; Rec."Contract Gain/Loss Amount")
                {
                    ApplicationArea = all;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = all;
                }
                field("Copy Sell-to Addr. to Qte From"; Rec."Copy Sell-to Addr. to Qte From")
                {
                    ApplicationArea = all;
                }
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
                field("Item Supplier Source"; Rec."Item Supplier Source")
                {
                    ApplicationArea = all;
                }
                field("Vendor Cust. Code"; Rec."Vendor Cust. Code")
                {
                    ApplicationArea = all;
                }
                field("Ship From Name"; Rec."Ship From Name")
                {
                    ApplicationArea = all;
                }
                field("Ship From Address"; Rec."Ship From Address")
                {
                    ApplicationArea = all;
                }
                field(HQType; Rec.HQType)
                {
                    ApplicationArea = all;
                }
                field("Default Country/Region of Org"; Rec."Default Country/Region of Org")
                {
                    ApplicationArea = all;
                }
                field("Price Update Target Date"; Rec."Price Update Target Date")
                {
                    ApplicationArea = all;
                }
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
                field("ORE City"; Rec."ORE City")
                {
                    ApplicationArea = all;
                }
                field("ORE State/Province"; Rec."ORE State/Province")
                {
                    ApplicationArea = all;
                }
                field("Excluded in ORE Collection"; Rec."Excluded in ORE Collection")
                {
                    ApplicationArea = all;
                }
                field("ORE Country"; Rec."ORE Country")
                {
                    ApplicationArea = all;
                }
                field("ORE Post Code"; Rec."ORE Post Code")
                {
                    ApplicationArea = all;
                }
                field("Customer Group"; Rec."Customer Group")
                {
                    ApplicationArea = all;
                }
                field("Familiar Name"; Rec."Familiar Name")
                {
                    ApplicationArea = all;
                }
                field("Import File Ship To"; Rec."Import File Ship To")
                {
                    ApplicationArea = all;
                }
                field("Receiving Location"; Rec."Receiving Location")
                {
                    ApplicationArea = all;
                }
                field("Days for Auto Inv. Reservation"; Rec."Days for Auto Inv. Reservation")
                {
                    ApplicationArea = all;
                }
                field("Blocked"; Rec."Blocked")
                {
                    ApplicationArea = all;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                }
                field("Action"; Rec."Action")
                {
                    ApplicationArea = all;
                }


            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Purchase)
            {
                action(Import)
                {
                    Image = Import;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        cduImporter: Codeunit "Customer Import";
                        recApprSetup: Record "Hagiwara Approval Setup";
                        CustomerImportBatch: Record "Customer Import Batch";
                    begin
                        if G_BatchName = '' then
                            Error('Batch Name is blank.');

                        recApprSetup.Get();
                        if recApprSetup."Customer" then begin
                            CustomerImportBatch.get(G_BatchName);

                            if not (CustomerImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t import any records because approval process already initiated.');
                            end;
                        end;

                        cduImporter.SetBatchName(G_BatchName);
                        cduImporter.Run();

                    end;

                }
                action(Validate)
                {
                    Image = ViewCheck;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CustomerImportline: Record "Customer Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                        CustomerImportBatch: Record "Customer Import Batch";
                    begin
                        recApprSetup.Get();
                        if recApprSetup."Customer" then begin
                            CustomerImportBatch.get(G_BatchName);

                            if not (CustomerImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t validate because approval process already initiated.');
                            end;
                        end;

                        /*
                        //FDD removed this check
                        // -------check records existe-------                        
                        CustomerImportline.SetRange("Batch Name", G_BatchName);
                        CustomerImportline.SETFILTER(CustomerImportline.Status, '%1|%2', CustomerImportline.Status::Pending, CustomerImportline.Status::Error);
                        if CustomerImportline.IsEmpty() then begin
                            Error('There is no record to validate.');
                        end;
                        */

                        // -------check record contents-------
                        CustomerImportline.SetRange("Batch Name", G_BatchName);
                        if CustomerImportline.FINDFIRST then
                            REPEAT
                                CheckError(CustomerImportline);
                            UNTIL CustomerImportline.NEXT = 0;

                        Message('Validation finished.');
                    end;
                }
                action("Carry Out")
                {
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CustomerImportBatch: Record "Customer Import Batch";
                        CustomerImportline: Record "Customer Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        // -------check Approval Status -------
                        CustomerImportBatch.GET(G_BatchName);
                        recApprSetup.Get();
                        if recApprSetup."Customer" then begin

                            if not (CustomerImportBatch."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                                Error('You can''t carry out the action. You need to go through approval process first.');
                            end;

                            //Re-validate
                            if Confirm('Re-validation will be performed. Do you want to continue?') then begin

                                // -------check record contents-------
                                CustomerImportline.SetRange("Batch Name", G_BatchName);
                                if CustomerImportline.FINDFIRST then
                                    REPEAT
                                        CheckError(CustomerImportline);
                                    UNTIL CustomerImportline.NEXT = 0;

                            end else begin
                                exit;
                            end;

                            //commit the check error result.
                            Commit();

                            CustomerImportline.SetRange("Batch Name", G_BatchName);
                            CustomerImportline.SetFilter(Status, '%1|%2', CustomerImportline.Status::Pending, CustomerImportline.Status::Error);
                            if not CustomerImportline.IsEmpty then
                                Error('Some of the lines are not validated.');

                            // -------Execute-------
                            CustomerImportline.SetRange("Batch Name", G_BatchName);
                            CustomerImportline.SetFilter(Status, '%1', CustomerImportline.Status::Validated);
                            if CustomerImportline.FINDFIRST then
                                REPEAT
                                    ExecuteProcess(CustomerImportline);
                                UNTIL CustomerImportline.NEXT = 0;

                            /*
                            //FDD removed this process.
                            // delete all
                            CustomerImportline.SetRange("Batch Name", G_BatchName);
                            CustomerImportline.SetFilter(Status, '%1', CustomerImportline.Status::Completed);
                            CustomerImportline.DELETEALL;
                            */

                            Message('Carry out finished.');
                        end;

                    end;
                }
                action("Delete All")
                {
                    ApplicationArea = All;
                    Caption = 'Delete All';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CustomerImportBatch: Record "Customer Import Batch";
                        CustomerImportline: Record "Customer Import Line";
                        recApprSetup: Record "Hagiwara Approval Setup";
                    begin
                        CustomerImportline.SetRange("Batch Name", G_BatchName);

                        recApprSetup.Get();
                        if recApprSetup."Customer" then begin
                            CustomerImportBatch.get(G_BatchName);

                            if not (CustomerImportBatch."Approval Status" in [
                                Enum::"Hagiwara Approval Status"::Required,
                                Enum::"Hagiwara Approval Status"::Cancelled,
                                Enum::"Hagiwara Approval Status"::Rejected
                                ]) then begin
                                Error('You can''t delete any records because approval process already initiated.');
                            end;
                        end;

                        IF NOT CONFIRM('Do you want to delete all the records?') THEN
                            EXIT;

                        CustomerImportline.DELETEALL;
                    end;
                }
            }
        }
    }

    var
        G_BatchName: Code[20];

    procedure SetBatchName(pBatchName: Code[20])
    begin
        G_BatchName := pBatchName;
    end;

    procedure ExecuteProcess(var p_CustomerImportline: Record "Customer Import Line")
    begin

        // -------Create-------
        if p_CustomerImportline.Action = p_CustomerImportline.Action::Create then begin
            //If Customer Import Line. No. is blank, use the default No. Series.
            CreateRecordForCustomer(p_CustomerImportline);

        end;

        // -------Update-------
        if p_CustomerImportline.Action = p_CustomerImportline.Action::Update then begin
            UpdateRecordForCustomer(p_CustomerImportline);

        end;

        //After completed, update the status to Completed. 
        p_CustomerImportline.Validate(p_CustomerImportline.Status, p_CustomerImportline.Status::Completed);
        p_CustomerImportline.Modify(true);

    end;
    //Create new records on the Customer table.
    procedure CreateRecordForCustomer(var p_CustomerImportline: Record "Customer Import Line")
    var
        CustomerRecord: Record "Customer";
        SlaesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
    begin
        CustomerRecord.INIT;

        if p_CustomerImportline."No." = '' then begin
            SlaesSetup.Get();
            SlaesSetup.TestField("Customer Nos.");
            CustomerRecord."No. Series" := SlaesSetup."Customer Nos.";
            if NoSeries.AreRelated(CustomerRecord."No. Series", xRec."No. Series") then
                CustomerRecord."No. Series" := xRec."No. Series";
            CustomerRecord."No." := NoSeries.GetNextNo(CustomerRecord."No. Series");
            CustomerRecord.ReadIsolation(IsolationLevel::ReadUncommitted);
            CustomerRecord.SetLoadFields("No.");
            while CustomerRecord.Get(CustomerRecord."No.") do
                CustomerRecord."No." := NoSeries.GetNextNo(CustomerRecord."No. Series");
        end else begin
            CustomerRecord.Validate("No.", p_CustomerImportline."No.");
        end;

        CustomerRecord.Insert();

        CustomerRecord.Validate("Name", p_CustomerImportline."Name");
        CustomerRecord.Validate("Search Name", p_CustomerImportline."Search Name");
        CustomerRecord.Validate("Name 2", p_CustomerImportline."Name 2");
        CustomerRecord.Validate("Address", p_CustomerImportline."Address");
        CustomerRecord.Validate("Address 2", p_CustomerImportline."Address 2");
        CustomerRecord.Validate("City", p_CustomerImportline."City");
        CustomerRecord.Validate("Contact", p_CustomerImportline."Contact");
        CustomerRecord.Validate("Phone No.", p_CustomerImportline."Phone No.");
        CustomerRecord.Validate("Global Dimension 1 Code", p_CustomerImportline."Global Dimension 1 Code");
        CustomerRecord.Validate("Global Dimension 2 Code", p_CustomerImportline."Global Dimension 2 Code");
        CustomerRecord.Validate("Customer Posting Group", p_CustomerImportline."Customer Posting Group");
        CustomerRecord.Validate("Currency Code", p_CustomerImportline."Currency Code");
        CustomerRecord.Validate("Customer Price Group", p_CustomerImportline."Customer Price Group");
        CustomerRecord.Validate("Language Code", p_CustomerImportline."Language Code");
        CustomerRecord.Validate("Payment Terms Code", p_CustomerImportline."Payment Terms Code");
        CustomerRecord.Validate("Fin. Charge Terms Code", p_CustomerImportline."Fin. Charge Terms Code");
        CustomerRecord.Validate("Salesperson Code", p_CustomerImportline."Salesperson Code");
        CustomerRecord.Validate("Shipment Method Code", p_CustomerImportline."Shipment Method Code");
        CustomerRecord.Validate("Shipping Agent Code", p_CustomerImportline."Shipping Agent Code");
        CustomerRecord.Validate("Invoice Disc. Code", p_CustomerImportline."Invoice Disc. Code");
        CustomerRecord.Validate("Country/Region Code", p_CustomerImportline."Country/Region Code");
        CustomerRecord.Validate("Collection Method", p_CustomerImportline."Collection Method");
        CustomerRecord.Validate("Print Statements", p_CustomerImportline."Print Statements");
        CustomerRecord.Validate("Bill-to Customer No.", p_CustomerImportline."Bill-to Customer No.");
        CustomerRecord.Validate("Payment Method Code", p_CustomerImportline."Payment Method Code");
        CustomerRecord.Validate("Application Method", p_CustomerImportline."Application Method");
        CustomerRecord.Validate("Prices Including VAT", p_CustomerImportline."Prices Including VAT");
        CustomerRecord.Validate("Location Code", p_CustomerImportline."Location Code");
        CustomerRecord.Validate("Fax No.", p_CustomerImportline."Fax No.");
        CustomerRecord.Validate("VAT Registration No.", p_CustomerImportline."VAT Registration No.");
        CustomerRecord.Validate("Gen. Bus. Posting Group", p_CustomerImportline."Gen. Bus. Posting Group");
        CustomerRecord.Validate("GLN", p_CustomerImportline."GLN");
        CustomerRecord.Validate("Post Code", p_CustomerImportline."Post Code");
        CustomerRecord.Validate("County", p_CustomerImportline."County");
        CustomerRecord.Validate("E-Mail", p_CustomerImportline."E-Mail");
        CustomerRecord.Validate("Home Page", p_CustomerImportline."Home Page");
        CustomerRecord.Validate("Reminder Terms Code", p_CustomerImportline."Reminder Terms Code");
        CustomerRecord.Validate("No. Series", p_CustomerImportline."No. Series");
        CustomerRecord.Validate("Tax Area Code", p_CustomerImportline."Tax Area Code");
        CustomerRecord.Validate("Tax Liable", p_CustomerImportline."Tax Liable");
        CustomerRecord.Validate("VAT Bus. Posting Group", p_CustomerImportline."VAT Bus. Posting Group");
        CustomerRecord.Validate("Reserve", p_CustomerImportline."Reserve");
        CustomerRecord.Validate("Block Payment Tolerance", p_CustomerImportline."Block Payment Tolerance");
        CustomerRecord.Validate("IC Partner Code", p_CustomerImportline."IC Partner Code");
        CustomerRecord.Validate("Prepayment %", p_CustomerImportline."Prepayment %");
        CustomerRecord.Validate("Partner Type", p_CustomerImportline."Partner Type");
        CustomerRecord.Validate("Cash Flow Payment Terms Code", p_CustomerImportline."Cash Flow Payment Terms Code");
        CustomerRecord.Validate("Primary Contact No.", p_CustomerImportline."Primary Contact No.");
        CustomerRecord.Validate("Responsibility Center", p_CustomerImportline."Responsibility Center");
        CustomerRecord.Validate("Shipping Advice", p_CustomerImportline."Shipping Advice");
        CustomerRecord.Validate("Shipping Time", p_CustomerImportline."Shipping Time");
        CustomerRecord.Validate("Shipping Agent Service Code", p_CustomerImportline."Shipping Agent Service Code");
        CustomerRecord.Validate("Service Zone Code", p_CustomerImportline."Service Zone Code");
        CustomerRecord.Validate("Contract Gain/Loss Amount", p_CustomerImportline."Contract Gain/Loss Amount");
        CustomerRecord.Validate("Allow Line Disc.", p_CustomerImportline."Allow Line Disc.");
        CustomerRecord.Validate("Copy Sell-to Addr. to Qte From", p_CustomerImportline."Copy Sell-to Addr. to Qte From");
        CustomerRecord.Validate("Customer Type", p_CustomerImportline."Customer Type");
        CustomerRecord.Validate("NEC OEM Code", p_CustomerImportline."NEC OEM Code");
        CustomerRecord.Validate("NEC OEM Name", p_CustomerImportline."NEC OEM Name");
        CustomerRecord.Validate("Shipping Mark1", p_CustomerImportline."Shipping Mark1");
        CustomerRecord.Validate("Shipping Mark2", p_CustomerImportline."Shipping Mark2");
        CustomerRecord.Validate("Shipping Mark3", p_CustomerImportline."Shipping Mark3");
        CustomerRecord.Validate("Shipping Mark4", p_CustomerImportline."Shipping Mark4");
        CustomerRecord.Validate("Shipping Mark5", p_CustomerImportline."Shipping Mark5");
        CustomerRecord.Validate("Remarks1", p_CustomerImportline."Remarks1");
        CustomerRecord.Validate("Remarks2", p_CustomerImportline."Remarks2");
        CustomerRecord.Validate("Remarks3", p_CustomerImportline."Remarks3");
        CustomerRecord.Validate("Remarks4", p_CustomerImportline."Remarks4");
        CustomerRecord.Validate("Remarks5", p_CustomerImportline."Remarks5");
        CustomerRecord.Validate("Item Supplier Source", p_CustomerImportline."Item Supplier Source");
        CustomerRecord.Validate("Vendor Cust. Code", p_CustomerImportline."Vendor Cust. Code");
        CustomerRecord.Validate("Ship From Name", p_CustomerImportline."Ship From Name");
        CustomerRecord.Validate("Ship From Address", p_CustomerImportline."Ship From Address");
        CustomerRecord.Validate("HQType", p_CustomerImportline."HQType");
        CustomerRecord.Validate("Default Country/Region of Org", p_CustomerImportline."Default Country/Region of Org");
        CustomerRecord.Validate("Update SO Price Target Date", p_CustomerImportline."Price Update Target Date");
        CustomerRecord.Validate("ORE Customer Name", p_CustomerImportline."ORE Customer Name");
        CustomerRecord.Validate("ORE Address", p_CustomerImportline."ORE Address");
        CustomerRecord.Validate("ORE Address 2", p_CustomerImportline."ORE Address 2");
        CustomerRecord.Validate("ORE City", p_CustomerImportline."ORE City");
        CustomerRecord.Validate("ORE State/Province", p_CustomerImportline."ORE State/Province");
        CustomerRecord.Validate("Excluded in ORE Collection", p_CustomerImportline."Excluded in ORE Collection");
        CustomerRecord.Validate("ORE Country", p_CustomerImportline."ORE Country");
        CustomerRecord.Validate("ORE Post Code", p_CustomerImportline."ORE Post Code");
        CustomerRecord.Validate("Customer Group", p_CustomerImportline."Customer Group");
        CustomerRecord.Validate("Familiar Name", p_CustomerImportline."Familiar Name");
        CustomerRecord.Validate("Import File Ship To", p_CustomerImportline."Import File Ship To");
        CustomerRecord.Validate("Receiving Location", p_CustomerImportline."Receiving Location");
        CustomerRecord.Validate("Days for Auto Inv. Reservation", p_CustomerImportline."Days for Auto Inv. Reservation");
        CustomerRecord.Validate("Blocked", p_CustomerImportline."Blocked");

        //Create new records on the Customer Bank Account table.
        CreateRecordForCustomerBankAccount(p_CustomerImportline);

        CustomerRecord.Validate("Preferred Bank Account Code", p_CustomerImportline."Preferred Bank Account Code");

        CustomerRecord.Modify();
    end;
    //Create new records on the Customer Bank Account table.
    procedure CreateRecordForCustomerBankAccount(var p_CustomerImportline: Record "Customer Import Line")
    var
        CustomerBankAccountRecord: Record "Customer Bank Account";
    begin
        CustomerBankAccountRecord.INIT;
        CustomerBankAccountRecord.Validate("Customer No.", p_CustomerImportline."No.");
        CustomerBankAccountRecord.Validate("Code", p_CustomerImportline."Preferred Bank Account Code");

        CustomerBankAccountRecord.Insert();
    End;

    procedure UpdateRecordForCustomer(var p_CustomerImportline: Record "Customer Import Line")
    var
        CustomerRecord: Record "Customer";
    begin
        CustomerRecord.SetRange("No.", p_CustomerImportline."No.");
        if CustomerRecord.FindFirst() then begin
            CustomerRecord.Validate("Name", p_CustomerImportline."Name");
            CustomerRecord.Validate("Search Name", p_CustomerImportline."Search Name");
            CustomerRecord.Validate("Name 2", p_CustomerImportline."Name 2");
            CustomerRecord.Validate("Address", p_CustomerImportline."Address");
            CustomerRecord.Validate("Address 2", p_CustomerImportline."Address 2");
            CustomerRecord.Validate("City", p_CustomerImportline."City");
            CustomerRecord.Validate("Contact", p_CustomerImportline."Contact");
            CustomerRecord.Validate("Phone No.", p_CustomerImportline."Phone No.");
            CustomerRecord.Validate("Global Dimension 1 Code", p_CustomerImportline."Global Dimension 1 Code");
            CustomerRecord.Validate("Global Dimension 2 Code", p_CustomerImportline."Global Dimension 2 Code");
            CustomerRecord.Validate("Customer Posting Group", p_CustomerImportline."Customer Posting Group");
            CustomerRecord.Validate("Currency Code", p_CustomerImportline."Currency Code");
            CustomerRecord.Validate("Customer Price Group", p_CustomerImportline."Customer Price Group");
            CustomerRecord.Validate("Language Code", p_CustomerImportline."Language Code");
            CustomerRecord.Validate("Payment Terms Code", p_CustomerImportline."Payment Terms Code");
            CustomerRecord.Validate("Fin. Charge Terms Code", p_CustomerImportline."Fin. Charge Terms Code");
            CustomerRecord.Validate("Salesperson Code", p_CustomerImportline."Salesperson Code");
            CustomerRecord.Validate("Shipment Method Code", p_CustomerImportline."Shipment Method Code");
            CustomerRecord.Validate("Shipping Agent Code", p_CustomerImportline."Shipping Agent Code");
            CustomerRecord.Validate("Invoice Disc. Code", p_CustomerImportline."Invoice Disc. Code");
            CustomerRecord.Validate("Country/Region Code", p_CustomerImportline."Country/Region Code");
            CustomerRecord.Validate("Collection Method", p_CustomerImportline."Collection Method");
            CustomerRecord.Validate("Print Statements", p_CustomerImportline."Print Statements");
            CustomerRecord.Validate("Bill-to Customer No.", p_CustomerImportline."Bill-to Customer No.");
            CustomerRecord.Validate("Payment Method Code", p_CustomerImportline."Payment Method Code");
            CustomerRecord.Validate("Application Method", p_CustomerImportline."Application Method");
            CustomerRecord.Validate("Prices Including VAT", p_CustomerImportline."Prices Including VAT");
            CustomerRecord.Validate("Location Code", p_CustomerImportline."Location Code");
            CustomerRecord.Validate("Fax No.", p_CustomerImportline."Fax No.");
            CustomerRecord.Validate("VAT Registration No.", p_CustomerImportline."VAT Registration No.");
            CustomerRecord.Validate("Gen. Bus. Posting Group", p_CustomerImportline."Gen. Bus. Posting Group");
            CustomerRecord.Validate("GLN", p_CustomerImportline."GLN");
            CustomerRecord.Validate("Post Code", p_CustomerImportline."Post Code");
            CustomerRecord.Validate("County", p_CustomerImportline."County");
            CustomerRecord.Validate("E-Mail", p_CustomerImportline."E-Mail");
            CustomerRecord.Validate("Home Page", p_CustomerImportline."Home Page");
            CustomerRecord.Validate("Reminder Terms Code", p_CustomerImportline."Reminder Terms Code");
            CustomerRecord.Validate("No. Series", p_CustomerImportline."No. Series");
            CustomerRecord.Validate("Tax Area Code", p_CustomerImportline."Tax Area Code");
            CustomerRecord.Validate("Tax Liable", p_CustomerImportline."Tax Liable");
            CustomerRecord.Validate("VAT Bus. Posting Group", p_CustomerImportline."VAT Bus. Posting Group");
            CustomerRecord.Validate("Reserve", p_CustomerImportline."Reserve");
            CustomerRecord.Validate("Block Payment Tolerance", p_CustomerImportline."Block Payment Tolerance");
            CustomerRecord.Validate("IC Partner Code", p_CustomerImportline."IC Partner Code");
            CustomerRecord.Validate("Prepayment %", p_CustomerImportline."Prepayment %");
            CustomerRecord.Validate("Partner Type", p_CustomerImportline."Partner Type");
            CustomerRecord.Validate("Preferred Bank Account Code", p_CustomerImportline."Preferred Bank Account Code");
            CustomerRecord.Validate("Cash Flow Payment Terms Code", p_CustomerImportline."Cash Flow Payment Terms Code");
            CustomerRecord.Validate("Primary Contact No.", p_CustomerImportline."Primary Contact No.");
            CustomerRecord.Validate("Responsibility Center", p_CustomerImportline."Responsibility Center");
            CustomerRecord.Validate("Shipping Advice", p_CustomerImportline."Shipping Advice");
            CustomerRecord.Validate("Shipping Time", p_CustomerImportline."Shipping Time");
            CustomerRecord.Validate("Shipping Agent Service Code", p_CustomerImportline."Shipping Agent Service Code");
            CustomerRecord.Validate("Service Zone Code", p_CustomerImportline."Service Zone Code");
            CustomerRecord.Validate("Contract Gain/Loss Amount", p_CustomerImportline."Contract Gain/Loss Amount");
            CustomerRecord.Validate("Allow Line Disc.", p_CustomerImportline."Allow Line Disc.");
            CustomerRecord.Validate("Copy Sell-to Addr. to Qte From", p_CustomerImportline."Copy Sell-to Addr. to Qte From");
            CustomerRecord.Validate("Customer Type", p_CustomerImportline."Customer Type");
            CustomerRecord.Validate("NEC OEM Code", p_CustomerImportline."NEC OEM Code");
            CustomerRecord.Validate("NEC OEM Name", p_CustomerImportline."NEC OEM Name");
            CustomerRecord.Validate("Shipping Mark1", p_CustomerImportline."Shipping Mark1");
            CustomerRecord.Validate("Shipping Mark2", p_CustomerImportline."Shipping Mark2");
            CustomerRecord.Validate("Shipping Mark3", p_CustomerImportline."Shipping Mark3");
            CustomerRecord.Validate("Shipping Mark4", p_CustomerImportline."Shipping Mark4");
            CustomerRecord.Validate("Shipping Mark5", p_CustomerImportline."Shipping Mark5");
            CustomerRecord.Validate("Remarks1", p_CustomerImportline."Remarks1");
            CustomerRecord.Validate("Remarks2", p_CustomerImportline."Remarks2");
            CustomerRecord.Validate("Remarks3", p_CustomerImportline."Remarks3");
            CustomerRecord.Validate("Remarks4", p_CustomerImportline."Remarks4");
            CustomerRecord.Validate("Remarks5", p_CustomerImportline."Remarks5");
            CustomerRecord.Validate("Item Supplier Source", p_CustomerImportline."Item Supplier Source");
            CustomerRecord.Validate("Vendor Cust. Code", p_CustomerImportline."Vendor Cust. Code");
            CustomerRecord.Validate("Ship From Name", p_CustomerImportline."Ship From Name");
            CustomerRecord.Validate("Ship From Address", p_CustomerImportline."Ship From Address");
            CustomerRecord.Validate("HQType", p_CustomerImportline."HQType");
            CustomerRecord.Validate("Default Country/Region of Org", p_CustomerImportline."Default Country/Region of Org");
            CustomerRecord.Validate("Update SO Price Target Date", p_CustomerImportline."Price Update Target Date");
            CustomerRecord.Validate("ORE Customer Name", p_CustomerImportline."ORE Customer Name");
            CustomerRecord.Validate("ORE Address", p_CustomerImportline."ORE Address");
            CustomerRecord.Validate("ORE Address 2", p_CustomerImportline."ORE Address 2");
            CustomerRecord.Validate("ORE City", p_CustomerImportline."ORE City");
            CustomerRecord.Validate("ORE State/Province", p_CustomerImportline."ORE State/Province");
            CustomerRecord.Validate("Excluded in ORE Collection", p_CustomerImportline."Excluded in ORE Collection");
            CustomerRecord.Validate("ORE Country", p_CustomerImportline."ORE Country");
            CustomerRecord.Validate("ORE Post Code", p_CustomerImportline."ORE Post Code");
            CustomerRecord.Validate("Customer Group", p_CustomerImportline."Customer Group");
            CustomerRecord.Validate("Familiar Name", p_CustomerImportline."Familiar Name");
            CustomerRecord.Validate("Import File Ship To", p_CustomerImportline."Import File Ship To");
            CustomerRecord.Validate("Receiving Location", p_CustomerImportline."Receiving Location");
            CustomerRecord.Validate("Days for Auto Inv. Reservation", p_CustomerImportline."Days for Auto Inv. Reservation");
            CustomerRecord.Validate("Blocked", p_CustomerImportline."Blocked");

            CustomerRecord.Modify(true);
        end;

    end;

    procedure CheckError(var p_CustomerImportline: Record "Customer Import Line")
    var
        ErrDesc: Text[1024];//the total of error message is over of ( [Table – Item Import Line]'[Error Description] length : 250)
        CustomerRecord: Record Customer;
        GlobalDimension1Code: Record "Dimension Value";
        GlobalDimension2Code: Record "Dimension Value";
        CustomerPostingGroup: Record "Customer Posting Group";
        CurrencyCode: Record Currency;
        CustomerPriceGroup: Record "Customer Price Group";
        LanguageCode: Record "Language";
        PaymentTermsCode: Record "Payment Terms";
        FinChargeTermsCode: Record "Finance Charge Terms";
        SalespersonCode: Record "Salesperson/Purchaser";
        ShipmentMethodCode: Record "Shipment Method";
        ShippingAgentCode: Record "Shipping Agent";
        CountryRegionCode: Record "Country/Region";
        BilltoCustomerNo: Record Customer;
        PaymentMethodCode: Record "Payment Method";
        LocationCode: Record Location;
        GenBusPostingGroup: Record "Gen. Business Posting Group";
        NoSeries: Record "No. Series";
        TaxAreaCode: Record "Tax Area";
        VATBusPostingGroup: Record "VAT Business Posting Group";
        ICPartnerCode: Record "IC Partner";
        PreferredBankAccountCode: Record "Customer Bank Account";
        CashFlowPaymentTermsCode: Record "Payment Terms";
        PrimaryContactNo: Record Contact;
        ResponsibilityCenter: Record "Responsibility Center";
        ShippingAgentServiceCode: Record "Shipping Agent Services";
        ServiceZoneCode: Record "Service Zone";
        ReceivingLocation: Record "Location";
    begin
        // -------Existence Check (See table relation info.)-------
        //Global Dimension 1 Code
        if p_CustomerImportline."Global Dimension 1 Code" <> '' then begin
            if not GlobalDimension1Code.get(p_CustomerImportline."Global Dimension 1 Code") then begin
                ErrDesc := 'Global Dimension 1 Code is not found. ';
            end;
        end;
        //Global Dimension 2 Code
        if p_CustomerImportline."Global Dimension 2 Code" <> '' then begin
            if not GlobalDimension2Code.get(p_CustomerImportline."Global Dimension 2 Code") then begin
                ErrDesc := 'Global Dimension 2 Code is not found. ';
            end;
        end;
        //Customer Posting Group
        if p_CustomerImportline."Customer Posting Group" <> '' then begin
            if not CustomerPostingGroup.get(p_CustomerImportline."Customer Posting Group") then begin
                ErrDesc += 'Customer Posting Group is not found. ';
            end;
        end;
        //Currency Code
        if p_CustomerImportline."Currency Code" <> '' then begin
            if not CurrencyCode.get(p_CustomerImportline."Currency Code") then begin
                ErrDesc += 'Currency Code is not found. ';
            end;
        end;
        //Customer Price Group
        if p_CustomerImportline."Customer Price Group" <> '' then begin
            if not CustomerPriceGroup.get(p_CustomerImportline."Customer Price Group") then begin
                ErrDesc += 'Customer Price Group is not found. ';
            end;
        end;
        //Language Code
        if p_CustomerImportline."Language Code" <> '' then begin
            if not LanguageCode.get(p_CustomerImportline."Language Code") then begin
                ErrDesc += 'Language Code is not found. ';
            end;
        end;
        //Payment Terms Code
        if p_CustomerImportline."Payment Terms Code" <> '' then begin
            if not PaymentTermsCode.get(p_CustomerImportline."Payment Terms Code") then begin
                ErrDesc += 'Payment Terms Code is not found. ';
            end;
        end;
        //Fin. Charge Terms Code
        if p_CustomerImportline."Fin. Charge Terms Code" <> '' then begin
            if not FinChargeTermsCode.get(p_CustomerImportline."Fin. Charge Terms Code") then begin
                ErrDesc += 'Fin. Charge Terms Code is not found. ';
            end;
        end;
        //Salesperson Code
        if p_CustomerImportline."Salesperson Code" <> '' then begin
            if not FinChargeTermsCode.get(p_CustomerImportline."Salesperson Code") then begin
                ErrDesc += 'Salesperson Code is not found. ';
            end;
        end;
        //Shipment Method Code
        if p_CustomerImportline."Shipment Method Code" <> '' then begin
            if not ShipmentMethodCode.get(p_CustomerImportline."Shipment Method Code") then begin
                ErrDesc += 'Shipment Method Code is not found. ';
            end;
        end;
        //Shipping Agent Code
        if p_CustomerImportline."Shipping Agent Code" <> '' then begin
            if not ShippingAgentCode.get(p_CustomerImportline."Shipping Agent Code") then begin
                ErrDesc += 'Shipping Agent Code is not found. ';
            end;
        end;
        //Country/Region Code
        if p_CustomerImportline."Country/Region Code" <> '' then begin
            if not CountryRegionCode.get(p_CustomerImportline."Country/Region Code") then begin
                ErrDesc += 'Country/Region Code is not found. ';
            end;
        end;
        //Bill-to Customer No.
        if p_CustomerImportline."Bill-to Customer No." <> '' then begin
            if not BilltoCustomerNo.get(p_CustomerImportline."Bill-to Customer No.") then begin
                ErrDesc += 'Bill-to Customer No. is not found. ';
            end;
        end;
        //Payment Method Code
        if p_CustomerImportline."Payment Method Code" <> '' then begin
            if not PaymentMethodCode.get(p_CustomerImportline."Payment Method Code") then begin
                ErrDesc += 'Payment Method Code is not found. ';
            end;
        end;
        //Location Code
        if p_CustomerImportline."Location Code" <> '' then begin
            if not LocationCode.get(p_CustomerImportline."Location Code") then begin
                ErrDesc += 'Location Code is not found. ';
            end;
        end;
        //Gen. Bus. Posting Group
        if p_CustomerImportline."Gen. Bus. Posting Group" <> '' then begin
            if not GenBusPostingGroup.get(p_CustomerImportline."Gen. Bus. Posting Group") then begin
                ErrDesc += 'Gen. Bus. Posting Group is not found. ';
            end;
        end;
        //No. Series
        if p_CustomerImportline."No. Series" <> '' then begin
            if not NoSeries.get(p_CustomerImportline."No. Series") then begin
                ErrDesc += 'No. Series is not found. ';
            end;
        end;
        //Tax Area Code
        if p_CustomerImportline."Tax Area Code" <> '' then begin
            if not TaxAreaCode.get(p_CustomerImportline."Tax Area Code") then begin
                ErrDesc += 'Tax Area Code is not found. ';
            end;
        end;
        //VAT Bus. Posting Group
        if p_CustomerImportline."VAT Bus. Posting Group" <> '' then begin
            if not VATBusPostingGroup.get(p_CustomerImportline."VAT Bus. Posting Group") then begin
                ErrDesc += 'VAT Bus. Posting Group is not found. ';
            end;
        end;
        //IC Partner Code
        if p_CustomerImportline."IC Partner Code" <> '' then begin
            if not ICPartnerCode.get(p_CustomerImportline."IC Partner Code") then begin
                ErrDesc += 'IC Partner Code is not found. ';
            end;
        end;
        //Preferred Bank Account Code
        if p_CustomerImportline."Preferred Bank Account Code" <> '' then begin
            if not PreferredBankAccountCode.get(p_CustomerImportline."No.", p_CustomerImportline."Preferred Bank Account Code") then begin
                ErrDesc += 'Preferred Bank Account Code is not found. ';
            end;
        end;
        //Cash Flow Payment Terms Code
        if p_CustomerImportline."Cash Flow Payment Terms Code" <> '' then begin
            if not CashFlowPaymentTermsCode.get(p_CustomerImportline."Cash Flow Payment Terms Code") then begin
                ErrDesc += 'Cash Flow Payment Terms Code is not found. ';
            end;
        end;
        //Primary Contact No.
        if p_CustomerImportline."Primary Contact No." <> '' then begin
            if not PrimaryContactNo.get(p_CustomerImportline."Primary Contact No.") then begin
                ErrDesc += 'Primary Contact No. is not found. ';
            end;
        end;
        //Responsibility Center
        if p_CustomerImportline."Responsibility Center" <> '' then begin
            if not ResponsibilityCenter.get(p_CustomerImportline."Responsibility Center") then begin
                ErrDesc += 'Responsibility Center is not found. ';
            end;
        end;
        //Shipping Agent Service Code
        if p_CustomerImportline."Shipping Agent Service Code" <> '' then begin
            if not ShippingAgentServiceCode.get(p_CustomerImportline."Shipping Agent Code", p_CustomerImportline."Shipping Agent Service Code") then begin
                ErrDesc += 'Shipping Agent Service Code is not found. ';
            end;
        end;
        //Service Zone Code
        if p_CustomerImportline."Service Zone Code" <> '' then begin
            if not ServiceZoneCode.get(p_CustomerImportline."Service Zone Code") then begin
                ErrDesc += 'Service Zone Code is not found. ';
            end;
        end;
        //Receiving Location
        if p_CustomerImportline."Receiving Location" <> '' then begin
            if not ReceivingLocation.get(p_CustomerImportline."Receiving Location") then begin
                ErrDesc += 'Receiving Location is not found. ';
            end;
        end;
        // -------Option Value Check-------//TODO 確認必要

        // -------the result of Validation-------
        if (ErrDesc <> '') then begin
            p_CustomerImportline."Error Description" := CopyStr(ErrDesc, 1, 250);
            p_CustomerImportline.Validate(p_CustomerImportline.Status, p_CustomerImportline.Status::Error);
        end else begin
            p_CustomerImportline."Error Description" := '';
            //Create or Update
            p_CustomerImportline.Action := p_CustomerImportline.Action::Update;
            if not CustomerRecord.get(p_CustomerImportline."No.") then begin
                p_CustomerImportline.Action := p_CustomerImportline.Action::Create;
            end;

            p_CustomerImportline.Validate(p_CustomerImportline.Status, p_CustomerImportline.Status::Validated);
        end;
        p_CustomerImportline.Modify(true);

    end;
}
