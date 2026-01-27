page 50088 "Sales Invoice Import Lines"
{
    // CS061 Leon 2023/09/08 - SO Post Upload (Salese Shipment/Invoice)

    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    Description = 'Sales Invoice Import Lines';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Invoice Import Line";
    SourceTableView = SORTING("Order No.", "Posting Date", "Line No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
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
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Import)
            {
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cduImporter: Codeunit "Import Sales Invoice Data";
                begin
                    cduImporter.Run();
                end;
            }
            action(Validate)
            {
                ApplicationArea = Basic, Suit;
                Image = CheckDuplicates;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    InvoiceLine.RESET;
                    IF NOT InvoiceLine.FINDFIRST() THEN
                        ERROR('There is no record to validate.');

                    ValidateImportLines;

                    MESSAGE('Validation finished.');
                end;
            }
            action("Post Invoice")
            {
                ApplicationArea = Basic, Suit;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    RptPostInv: Report "SO Post Invoice";
                begin
                    InvoiceLine.RESET;
                    IF NOT InvoiceLine.FINDFIRST() THEN
                        ERROR('There is no record to post.');

                    InvoiceLine.RESET;
                    InvoiceLine.SETRANGE(Status, InvoiceLine.Status::Processed);
                    IF NOT InvoiceLine.FINDFIRST THEN
                        ERROR('There is no validated line to post.');

                    //Re-validate before post
                    ValidateImportLines;

                    InvoiceLine.RESET;
                    InvoiceLine.SETRANGE(Status, InvoiceLine.Status::Error);
                    IF InvoiceLine.FINDFIRST THEN
                        ERROR('You cannot post if there are one or more errors.');

                    IF NOT CONFIRM('Are you sure you want to post invoice?') THEN
                        EXIT;

                    //Run Invoice Post
                    RptPostInv.RUN();

                    InvoiceLine.RESET;
                    InvoiceLine.SETRANGE(Status, InvoiceLine.Status::OK);
                    IF InvoiceLine.FINDSET() THEN InvoiceLine.DELETEALL();

                    CurrPage.UPDATE();
                end;
            }
            action(DelAll)
            {
                ApplicationArea = All;
                Caption = 'Delete All';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to delete all the records?') THEN
                        EXIT;

                    InvoiceLine.RESET;
                    IF InvoiceLine.FINDSET THEN
                        InvoiceLine.DELETEALL();
                end;
            }
        }
    }

    var
        InvoiceLine: Record "Sales Invoice Import Line";

    local procedure ValidateImportLines()
    var
        SOHeader: Record "Sales Header";
        SOLine: Record "Sales Line";
        SOInvLine: Record "Sales Invoice Import Line";
        InvLine2: Record "Sales Invoice Import Line";
        ErrMsg: Text;
        TransType: Option Ship,Invoice;
        ValidateSOLine: Codeunit ValidateSOLine;
        RecRef: RecordRef;
        FNumber: Integer;
        FRef: FieldRef;
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //Run Validate
        SOInvLine.RESET;
        //SOInvLine.SETFILTER(Status, '<2');//<>Processed, PostError, OK
        SOInvLine.SETRANGE(Status, SOInvLine.Status::Pending, SOInvLine.Status::PostError);//Pending, Error, Processed, PostError, OK
        IF SOInvLine.FIND('-') THEN
            REPEAT
                CLEAR(ErrMsg);

                RecRef.GETTABLE(SOInvLine);
                FNumber := 1;

                InvLine2.RESET;
                InvLine2.SETRANGE("Order No.", SOInvLine."Order No.");
                InvLine2.SETRANGE("Line No.", SOInvLine."Line No.");
                InvLine2.SETRANGE("Posting Date", SOInvLine."Posting Date");
                InvLine2.SETRANGE("Qty. to Invoice", SOInvLine."Qty. to Invoice");
                InvLine2.SETRANGE("Shipment Method Code", SOInvLine."Shipment Method Code");
                InvLine2.FINDSET();
                IF InvLine2.COUNT > 1 THEN
                    ErrMsg += 'The same data exists in "Document No", "Line No.", "Qty.to Ship", "Posting Date", and "Shipping Method Code”. ';

                IF NOT SOHeader.GET(SOHeader."Document Type"::Order, SOInvLine."Order No.") THEN
                    ErrMsg += '"Document No." does not exist. ';

                IF NOT SOLine.GET(SOHeader."Document Type"::Order, SOInvLine."Order No.", SOInvLine."Line No.") THEN
                    ErrMsg += 'Combination of "Document No." and "Line No." does not exist. ';

                //BC upgrade N005 Begin
                recApprSetup.Get();
                if recApprSetup."Sales Order" then begin
                    if not (SOHeader."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                        ErrMsg += 'It''s not approved yet. ';
                    end;
                end;
                //BC upgrade N005 End

                COMMIT;
                IF ErrMsg = '' THEN
                    REPEAT
                        CLEARLASTERROR;

                        FRef := RecRef.FIELD(FNumber);
                        ValidateSOLine.SetTransType(TransType::Invoice, RecRef, FRef.NAME);

                        IF NOT ValidateSOLine.RUN() THEN BEGIN
                            ErrMsg += GETLASTERRORTEXT + ' ';
                        END;

                        FNumber += 1;
                    UNTIL FNumber > RecRef.FIELDCOUNT;

                IF ErrMsg <> '' THEN BEGIN
                    SOInvLine."Error Description" := COPYSTR(ErrMsg, 1, 250);
                    SOInvLine.Status := SOInvLine.Status::Error;
                END
                ELSE BEGIN
                    SOInvLine.Status := SOInvLine.Status::Processed;
                    SOInvLine."Error Description" := '';
                END;
                SOInvLine.MODIFY();
                COMMIT;

            UNTIL SOInvLine.NEXT = 0;
    end;
}

