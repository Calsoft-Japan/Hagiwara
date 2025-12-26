tableextension 50023 "Vendor Ext" extends "Vendor"
{
    fields
    {
        field(50000; "Shipping Terms"; Text[100])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50001; "Company Address"; Text[100])
        {
            Caption = 'Company Address';
            Description = 'SKLV6.0';
        }
        field(50002; "Company Address 2"; Text[100])
        {
            Caption = 'Company Address 2';
            Description = 'SKLV6.0';
        }
        field(50003; "Business Type"; Text[50])
        {
            Caption = 'Business Type';
            Description = 'SKLV6.0';
        }
        field(50004; "Business Class"; Text[70])
        {
            Caption = 'Business Class';
            Description = 'SKLV6.0';
        }
        field(50005; "Owner Name"; Text[50])
        {
            Caption = 'Owner Name';
            Description = 'SKLV6.0';
        }
        field(50006; "Corp. Registration No."; Text[30])
        {
            Caption = 'Corp. Registration No.';
            Description = 'SKLV6.0';

        }
        field(50007; "ID No. KR"; Text[13])
        {
            Caption = 'ID No.';
            Description = 'SKLV6.0';
        }
        field(50008; "Issue Type"; Option)
        {
            Caption = 'Issue Type';
            Description = 'SKLV6.0';
            OptionCaption = 'By Transaction,By Period';
            OptionMembers = ByTransaction,ByPeriod;
        }
        field(50009; "Business Category"; Option)
        {
            Caption = 'Business Category';
            Description = 'SKLV6.0';
            OptionCaption = 'Corporate,Personal Corporate,Person';
            OptionMembers = Corporate,"Personal Corporate",Person;
        }
        field(50010; "Incoterm Code"; Code[20])
        {
            TableRelation = Incoterm;
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50011; "VAT Category Type Name"; Text[50])
        {
            Caption = 'VAT Category Type Name';
            Description = 'SKLV6.0';
        }
        field(50012; "Credit Card"; Boolean)
        {
            Caption = 'Credit Card';
            Description = 'SKLV6.0';

        }
        field(50013; "Credit Card Code"; Code[10])
        {
            Caption = 'Credit Card Code';
            Description = 'SKLV6.0';
        }
        field(50014; "Credit Card No."; Text[30])
        {
            Caption = 'Credit Card No.';
            Description = 'SKLV6.0';
        }
        field(50020; "Incoterm Location"; Text[50])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
        }
        field(50021; "VAT Category Type Code KR"; Code[10])
        {
            Caption = 'VAT Category Type Code';
            Description = 'SKLV6.0';

        }

        //2025-08-07
        field(50023; "IRS 1099 Code"; Code[10])
        {
            TableRelation = "IRS 1099 Code".Code;
            DataClassification = CustomerContent;
            Caption = 'IRS 1099 Code';
        }
        //end 2025-08-07

        field(50030; "Company Name KR"; Text[50])
        {
            Caption = 'Company Name';
            Description = 'SKLV6.0';
        }
        field(50040; "Manufacturer Code"; Code[10])
        {
            TableRelation = Manufacturer;
            Caption = 'Manufacturer Code';
            Description = 'CS051';
        }
        field(50049; "Update PO Price Target Date"; Option)
        {
            Caption = 'Price Update Target Date';
            OptionMembers = " ","Order Date","Expected Receipt Date";
        }
        field(50050; "ORE Ship-to Code"; Code[50])
        {
            Description = 'CS060';
        }
        field(50051; "ORE Reverse Routing Address"; Code[40])
        {
            Caption = 'ORE Reverse Routing Address (NoneSD)';
            Description = 'CS060,CS103';
        }
        field(50052; "Excluded in ORE Collection"; Boolean)
        {
            Description = 'CS060';
        }
        field(50053; "ORE Reverse Routing Address SD"; Code[40])
        {
            Caption = 'ORE Reverse Routing Address (SD)';
            Description = 'CS073,CS103';
        }
        field(50054; "Hagiwara Group"; Code[10])
        {
            Description = 'CS082';
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
        field(60001; "Familiar Name"; Code[20])
        {
            Caption = 'Familiar Name';
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = true;
        }
        field(60004; "Pay-to Address"; Text[50])
        {
            Caption = 'Pay-to Address';
            Description = 'HG10.00.10 NJ 10/04/2018';

        }
        field(60005; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';
            Description = 'HG10.00.10 NJ 10/04/2018';

        }
        field(60006; "Pay-to City"; Text[30])
        {
            TableRelation = IF ("Pay-to Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
            Caption = 'Pay-to City';
            Description = 'HG10.00.10 NJ 10/04/2018';
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(60007; "Pay-to Post Code"; Code[20])
        {
            TableRelation = IF ("Pay-to Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
            Caption = 'Pay-to Post Code';
            Description = 'HG10.00.10 NJ 10/04/2018';
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(60008; "Pay-to County"; Text[30])
        {
            Caption = 'Pay-to County';
            Description = 'HG10.00.10 NJ 10/04/2018';
        }
        field(60009; "Pay-to Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            Caption = 'Pay-to Country/Region Code';
            Description = 'HG10.00.10 NJ 10/04/2018';
        }
        field(60010; "Exclude Check"; Boolean)
        {
            Description = 'HG10.00.10 NJ 10/04/2018';
        }

        /*
        modify(Blocked)
        {
            trigger OnBeforeValidate()
            var
                recApprSetup: Record "Hagiwara Approval Setup";
            begin
                //N005 Begin
                if xRec.Blocked <> Rec.Blocked then begin
                    recApprSetup.Get();
                    if (recApprSetup.Vendor) then begin
                        if not (Rec."Approval Status" in [Enum::"Hagiwara Approval Status"::Approved, Enum::"Hagiwara Approval Status"::"Auto Approved"]) then begin
                            Error('It is not approved yet.');
                        end;
                    end;
                end;
                //N005 End
            end;
        }
        */

    }


    trigger OnBeforeInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Vendor) then begin
            Error('The Approval setup is active.\The process cannot be completed.');
        end;
        //N005 End

    end;

    trigger OnBeforeModify()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Vendor) then begin
            Error('The Approval setup is active.\The process cannot be completed.');
        end;
        //N005 End

    end;

    trigger OnBeforeDelete()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Vendor) then begin
            Error('The Approval setup is active.\The process cannot be completed.');
        end;
        //N005 End

    end;

    /*
    trigger OnAfterInsert()
    var
        recApprSetup: Record "Hagiwara Approval Setup";
    begin
        //N005 Begin
        recApprSetup.Get();
        if (recApprSetup.Vendor) then begin
            Rec."Approval Status" := Enum::"Hagiwara Approval Status"::Required;
            Rec.Blocked := Rec.Blocked::All;
        end;
        //N005 End

        Modify();
    end;
    */
}
