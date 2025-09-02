page 50087 "Sales Ship Import Lines"
{
    // CS061 Leon 2023/09/08 - SO Post Upload (Salese Shipment/Invoice)

    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = false;
    Description = 'Sales Ship Import Lines';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Sales Ship Import Line";
    SourceTableView = SORTING("Order No.", "Posting Date", "Shipment Method Code", "Shipping Agent Code", "Package Tracking No.", "Line No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; REC."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; REC."Document Date")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; REC."Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Customer No."; REC."Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Order No."; REC."Order No.")
                {
                    ApplicationArea = all;
                }
                field("Line No."; REC."Line No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; REC."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Qty. to Ship"; REC."Qty. to Ship")
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                }
                field("Shipment Method Code"; REC."Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Shipping Agent Code"; REC."Shipping Agent Code")
                {
                    ApplicationArea = all;
                }
                field("Package Tracking No."; REC."Package Tracking No.")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Error Description"; REC."Error Description")
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
                    cduImporter: Codeunit "Import Sales Ship Data";
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
                    ShipLine.RESET;
                    IF NOT ShipLine.FINDFIRST() THEN
                        ERROR('There is no record to validate.');

                    ValidateImportLines;
                    MESSAGE('Validation finished.');
                end;
            }
            action(ShipPost)
            {
                ApplicationArea = Basic, Suit;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    RptPostShip: Report "SO Post Ship";
                begin
                    ShipLine.RESET;
                    IF NOT ShipLine.FINDFIRST() THEN
                        ERROR('There is no record to post.');

                    ShipLine.RESET;
                    ShipLine.SETRANGE(Status, ShipLine.Status::Processed);
                    IF NOT ShipLine.FINDFIRST THEN
                        ERROR('There is no validated line to post.');

                    //Re-validate before post
                    ValidateImportLines;

                    ShipLine.RESET;
                    ShipLine.SETRANGE(Status, ShipLine.Status::Error);
                    IF ShipLine.FINDFIRST() THEN
                        ERROR('You cannot post if there are one or more errors.');

                    IF NOT CONFIRM('Are you sure you want to post shipment?') THEN
                        EXIT;

                    //Run Shipment Post
                    RptPostShip.RUN();
                    //REPORT.RUNMODAL(REPORT::"SO Post Ship",FALSE);

                    ShipLine.RESET;
                    ShipLine.SETRANGE(Status, ShipLine.Status::OK);
                    IF ShipLine.FINDSET() THEN ShipLine.DELETEALL();

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

                    ShipLine.RESET;
                    IF ShipLine.FINDSET THEN
                        ShipLine.DELETEALL();
                end;
            }
        }
    }

    var
        ShipLine: Record "Sales Ship Import Line";

    local procedure ValidateImportLines()
    var
        SOHeader: Record "Sales Header";
        SOLine: Record "Sales Line";
        SOShipLine: Record "Sales Ship Import Line";
        ShipLine2: Record "Sales Ship Import Line";
        ErrMsg: Text;
        TransType: Option Ship,Invoice;
        ValidateSOLine: Codeunit ValidateSOLine;
        RecRef: RecordRef;
        FNumber: Integer;
        FRef: FieldRef;
    begin
        //Run Validate
        SOShipLine.RESET;
        //SOShipLine.SETFILTER(Status, '<2');//<>Processed, PostError, OK
        SOShipLine.SETRANGE(Status, SOShipLine.Status::Pending, SOShipLine.Status::PostError);//Pending, Error, Processed, PostError, OK
        IF SOShipLine.FIND('-') THEN
            REPEAT
                CLEAR(ErrMsg);

                RecRef.GETTABLE(SOShipLine);
                FNumber := 1;

                ShipLine2.RESET;
                ShipLine2.SETRANGE("Order No.", SOShipLine."Order No.");
                ShipLine2.SETRANGE("Line No.", SOShipLine."Line No.");
                ShipLine2.SETRANGE("Posting Date", SOShipLine."Posting Date");
                ShipLine2.SETRANGE("Qty. to Ship", SOShipLine."Qty. to Ship");
                ShipLine2.SETRANGE("Shipment Method Code", SOShipLine."Shipment Method Code");
                ShipLine2.FINDSET();
                IF ShipLine2.COUNT > 1 THEN
                    ErrMsg += 'The same data exists in "Document No", "Line No.", "Qty.to Ship", "Posting Date", and "Shipping Method Code”. ';

                IF NOT SOHeader.GET(SOHeader."Document Type"::Order, SOShipLine."Order No.") THEN
                    ErrMsg += '"Document No." does not exist. ';

                IF NOT SOLine.GET(SOHeader."Document Type"::Order, SOShipLine."Order No.", SOShipLine."Line No.") THEN
                    ErrMsg += 'Combination of "Document No." and "Line No." does not exist. ';
                COMMIT;
                IF ErrMsg = '' THEN
                    REPEAT
                        CLEARLASTERROR;

                        FRef := RecRef.FIELD(FNumber);
                        ValidateSOLine.SetTransType(TransType::Ship, RecRef, FRef.NAME);

                        IF NOT ValidateSOLine.RUN() THEN BEGIN
                            ErrMsg += GETLASTERRORTEXT + ' ';
                        END;

                        FNumber += 1;
                    UNTIL FNumber > RecRef.FIELDCOUNT;

                IF ErrMsg <> '' THEN BEGIN
                    SOShipLine."Error Description" := COPYSTR(ErrMsg, 1, 250);
                    SOShipLine.Status := SOShipLine.Status::Error;
                END
                ELSE BEGIN
                    SOShipLine.Status := SOShipLine.Status::Processed;
                    SOShipLine."Error Description" := '';
                END;
                SOShipLine.MODIFY();
                COMMIT;

            UNTIL SOShipLine.NEXT = 0;
    end;
}

