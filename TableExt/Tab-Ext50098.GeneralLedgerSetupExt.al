tableextension 50098 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50001; "Issue on Posting"; Boolean)
        {
            Caption = 'Issue on Posting';
            Description = 'SKLV6.0';
        }
        field(50002; "Default VAT Company Code"; Code[10])
        {
            Caption = 'Dafault VAT Company Code';
            Description = 'SKLV6.0';
        }
        field(50003; "Sales Tax Invoice Nos."; Code[20])
        {
            Caption = 'Sales Tax Invoice Nos.';
            Description = 'SKLV6.0';
        }
        field(50004; "Purchase Tax Invoice Nos."; Code[20])
        {
            Caption = 'Purchase Tax Invoice Nos.';
            Description = 'SKLV6.0';
        }
        field(50005; "Manual Tax Invoice Nos."; Code[20])
        {
            Caption = 'Manual Tax Invoice Nos.';
            Description = 'SKLV6.0';
        }
        field(50006; "Sales VAT G/L Account"; Code[20])
        {
            Caption = 'Sales VAT G/L Account';
            Description = 'SKLV6.0';
        }
        field(50007; "Purchase VAT G/L Account"; Code[20])
        {
            Caption = 'Purchase VAT G/L Account';
            Description = 'SKLV6.0';
        }
        field(50008; "Default Folder"; Text[50])
        {
            Caption = 'Default Folder';
            Description = 'SKLV6.0';

        }
        field(50009; "Use Vendor to Credit Card"; Boolean)
        {
            Description = 'SKLV6.0';
        }
        field(50010; "Format Check Mandatory"; Boolean)
        {
            Caption = 'Format Check Mandatory';
            Description = 'SKLV6.0';
        }
        field(50011; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            Description = 'SKLV6.0';
        }
        field(50012; "ID No."; Text[20])
        {
            Caption = 'ID No.';
            Description = 'SKLV6.0';
        }
        field(50013; "Corp. Registration No."; Text[20])
        {
            Caption = 'Corp. Registration No. ';
            Description = 'SKLV6.0';
        }
        field(50014; "No. of Tax Invoice Lines"; Option)
        {
            Caption = 'No. of Tax Invoice Lines';
            Description = 'SKLV6.0';
            OptionCaption = '1 Line,2 Line,3 Line,4 Line';
            OptionMembers = "1Line","2Line","3Line","4Line";
        }
        field(50015; "VAT credit card Nos."; Code[20])
        {
            Caption = 'VAT credit card Nos.';
            Description = 'SKLV6.0';
        }
        field(50016; "P. Note Default Batch"; Code[10])
        {
            Caption = 'P. Note Default Batch';
            Description = 'SKLN6.0';
        }
        field(50017; "P. Note Default Template"; Code[10])
        {
            Caption = 'P. Note Default Template';
            Description = 'SKLN6.0';
        }
        field(50018; "P. Note Account"; Code[20])
        {
            Caption = 'P. Note Account';
            Description = 'SKLN6.0';
        }
        field(50019; "P. Note Cash Account"; Code[20])
        {
            Caption = 'P. Note Cash Account';
            Description = 'SKLN6.0';
        }
        field(50020; "Note Payable Account"; Code[20])
        {
            Caption = 'Note Payable Account';
            Description = 'SKLN6.0';
        }
        field(50021; "Discount P. Note Account"; Code[20])
        {
            Caption = 'Discount P. Note Account';
            Description = 'SKLN6.0';
        }
        field(50022; "Note Payable Bank Account"; Code[20])
        {
            Caption = 'Note Payable Bank Account';
            Description = 'SKLN6.0';
        }
        field(50023; "Account Range for COGM"; Code[250])
        {
            Description = 'SKLN6.0';
        }
        field(50024; "P. Note as Discount"; Code[29])
        {
            Caption = 'P. Note as Discount';
            Description = 'SKLN6.0';
        }
        field(50025; "P. Note Doc. No."; Code[22])
        {
            Caption = 'P. Note Doc. No.';
            Description = 'SKLN6.0';
        }
        field(50026; "P. Note Batch Doc. No."; Code[20])
        {
            Caption = 'P. Note Batch Doc. No.';
            Description = 'SKLN6.0';
        }
        field(50050; "Messaging File Path"; Text[250])
        {
            // cleaned
        }
        field(50051; "PSI Job Status"; Code[2])
        {
            Description = '//03112012 siakhui - for PSI Job Execution Check Enh.';
        }
        field(50052; "Daily PSI Data Collection"; Code[1])
        {
            Description = '//03112012 siakhui - for PSI Job Execution Check Enh. 0(No) / 1(Yes)';
        }
        field(50053; "Monthly PSI Data Collection"; Code[1])
        {
            Description = '//03112012 siakhui - for PSI Job Execution Check Enh. 0(No) / 1(Yes)';
        }
        field(50054; "PSI Data Deletion"; Code[1])
        {
            Description = '//03112012 siakhui - for PSI Job Execution Check Enh. 0(No) / 1(Yes)';
        }
        field(50055; "Backup Cutoff Date"; Date)
        {
            // cleaned
        }
        field(50056; "Messaging File Name"; Text[50])
        {
            // cleaned
        }
        field(50057; "Historical Data Period"; DateFormula)
        {
            Description = 'CS045';
        }
        field(50058; "Date for Inventory Last Month"; Text[2])
        {
            Description = 'CS064';
        }
        field(50059; "Days for Inventory Last Week"; Text[2])
        {
            Description = 'CS064';
        }
        field(50060; "Day of Week for Inv. Last Week"; Text[1])
        {
            Caption = '<Day of Week for Inventory Last Week>';
            Description = 'CS064';
        }
        field(50061; "ORE Country Qualifier"; Code[10])
        {
            Description = 'CS060';
        }
        field(50062; "ORE Reverse Routing Address"; Code[40])
        {
            Caption = 'ORE Reverse Routing Address (NoneSD)';
            Description = 'CS060,CS103';
        }
        field(50063; "INVRPT End Date (Weekly)"; Date)
        {
            Description = 'CS060';
        }
        field(50064; "INVRPT End Date (Monthly)"; Date)
        {
            Description = 'CS060';
        }
        field(50065; "Sold-to Code"; Code[35])
        {
            Description = 'CS060,CS089';
        }
        field(50066; "Ship-to Code"; Code[35])
        {
            Description = 'CS060,CS089';
        }
        field(50067; "Ship-to Name"; Text[35])
        {
            Description = 'CS060,CS089';
        }
        field(50068; "Ship-to Address"; Text[35])
        {
            Description = 'CS060,CS089';
        }
        field(50069; "Ship-to City"; Text[35])
        {
            Description = 'CS060,CS089';
        }
        field(50070; "Ship-to County"; Text[9])
        {
            Description = 'CS060,CS089';
        }
        field(50071; "Ship-to Post Code"; Code[35])
        {
            Description = 'CS060,CS089';
        }
        field(50072; "Ship-to Country/Region Code"; Code[3])
        {
            Description = 'CS060,CS089';
        }
        field(50073; "SLSRPT Start Date"; Date)
        {
            Description = 'CS060';
        }
        field(50074; "SLSRPT End Date"; Date)
        {
            Description = 'CS060';
        }
        field(50075; "ORE Messaging File Path"; Text[250])
        {
            Description = 'CS060';
        }
        field(50076; "DOW to Update Date Filter"; Option)
        {
            Description = 'CS060';
            OptionMembers = Mon,Tue,Wed,Thu,Fri,Sat,Sun;
        }
        field(50077; "ORE Reverse Routing Address SD"; Code[40])
        {
            Caption = 'ORE Reverse Routing Address (SD)';
            Description = 'CS073,CS103';
        }
        field(50078; "Ship-to Address2"; Text[35])
        {
            Description = 'CS089';
        }
        field(50079; "ORE Rev. Rte. Add.(File Name)"; Text[30])
        {
            Description = 'CS100';
        }
        field(50080; "Exclude Zero Balance (JD)"; Boolean)
        {
            Description = 'CS101';
        }
        field(50081; "Get Purch. Price (JD)"; Boolean)
        {
            Description = 'CS101';
        }
        field(60000; "Korea Company"; Boolean)
        {
            // cleaned
        }
    }
}
