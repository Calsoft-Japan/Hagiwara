pageextension 50118 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addafter("Check G/L Account Usage")
        {


            field("Unit-Amount Rounding Precision"; rec."Unit-Amount Rounding Precision")
            {

                ApplicationArea = all;
            }
            field("Amount Rounding Precision"; rec."Amount Rounding Precision")
            {

                ApplicationArea = all;
            }
        }

        addafter("Payroll Transaction Import")
        {

            group("PSI System Setting")
            {
                Caption = 'PSI System Setting';
                field("PSI Job Status"; rec."PSI Job Status")
                {
                    ApplicationArea = all;
                }
                field("Daily PSI Data Collection"; rec."Daily PSI Data Collection")
                {
                    ApplicationArea = all;
                }
                field("Monthly PSI Data Collection"; rec."Monthly PSI Data Collection")
                {
                    ApplicationArea = all;
                }
                field("Exclude Zero Balance (JD)"; rec."Exclude Zero Balance (JD)")
                {
                    ApplicationArea = all;
                }
                field("Get Purch. Price (JD)"; rec."Get Purch. Price (JD)")
                {
                    ApplicationArea = all;
                }
            }
            group("DWH Interface Setting")
            {
                Caption = 'DWH Interface Setting';
                field("<Messaging File Path for DWH>"; Rec."Messaging File Path")
                {
                    Caption = 'Messaging File Path';
                    Editable = false;
                }
                field("<Historical Data Period for DWH>"; Rec."Historical Data Period")
                {
                    ApplicationArea = all;
                    Caption = 'Historical Data Period';
                }
                field("Date for Inventory Last Month"; Rec."Date for Inventory Last Month")
                {
                    ApplicationArea = all;
                }
                field("Days for Inventory Last Week"; Rec."Days for Inventory Last Week")
                {
                    ApplicationArea = all;
                }
                field("Day of Week for Inv. Last Week"; Rec."Day of Week for Inv. Last Week")
                {
                    ApplicationArea = all;
                    Caption = 'Day of Week for Inventory Last Week';
                    ToolTip = 'Day number of the week to export Inventory Last Week (1-7, Monday = 1, Blank = Not export)';
                }
            }
            group("ORE Setting")
            {
                Caption = 'ORE Setting';
                field("ORE Messaging File Path"; Rec."ORE Messaging File Path")
                {
                    Caption = 'ORE Messaging File Path';
                }
                field("ORE Country Qualifier"; Rec."ORE Country Qualifier")
                {
                    ApplicationArea = all;
                }
                field("ORE Reverse Routing Address"; Rec."ORE Reverse Routing Address")
                {
                    ApplicationArea = all;
                }
                field("ORE Reverse Routing Address SD"; Rec."ORE Reverse Routing Address SD")
                {
                    ApplicationArea = all;
                }
                field("ORE Rev. Rte. Add.(File Name)"; Rec."ORE Rev. Rte. Add.(File Name)")
                {
                    ApplicationArea = all;
                }
                field("INVRPT End Date (Weekly)"; Rec."INVRPT End Date (Weekly)")
                {
                    ApplicationArea = all;
                }
                field("INVRPT End Date (Monthly)"; Rec."INVRPT End Date (Monthly)")
                {
                    ApplicationArea = all;
                }
                field("Sold-to Code"; Rec."Sold-to Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Address2"; Rec."Ship-to Address2")
                {
                    ApplicationArea = all;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = all;
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = all;
                }
                field("SLSRPT Start Date"; Rec."SLSRPT Start Date")
                {
                    ApplicationArea = all;
                }
                field("SLSRPT End Date"; Rec."SLSRPT End Date")
                {
                    ApplicationArea = all;
                }
                field("DOW to Update Date Filter"; Rec."DOW to Update Date Filter")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

}
