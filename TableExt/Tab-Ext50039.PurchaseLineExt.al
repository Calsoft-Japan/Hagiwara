tableextension 50039 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50000; Remark; Text[100])
        {
            Description = 'king';
        }
        field(50010; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50011; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50012; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Products WHERE("No." = FIELD("No.")));
            // cleaned
        }
        field(50016; "SO No."; Code[30])
        {
            // cleaned
        }
        field(50050; "Auto No."; Code[30])
        {
            Caption = 'Auto No.';
            Editable = false;
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50100; "ORE Message Status"; Option)
        {
            Description = 'CS060';
            OptionCaption = 'Not Applicable,Ready to Collect,Collected,Sent';
            OptionMembers = "Not Applicable","Ready to Collect",Collected,Sent;
        }
        field(50101; "ORE Change Status"; Option)
        {
            Description = 'CS060';
            InitValue = "Not Applicable";
            OptionCaption = 'Not Applicable,Changed,Collected,Sent';
            OptionMembers = "Not Applicable",Changed,Collected,Sent;
        }
        field(50102; "ORE Line No."; Integer)
        {
            Description = 'CS060';
            Editable = false;
        }
        field(50500; "Receipt Seq. No."; Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(50501; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = false;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
        }
        field(50502; "CO No."; Code[6])
        {
            Description = '//20101009';

        }
        field(50510; "Message Status"; Option)
        {
            Caption = 'Message Status';
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(50511; "Update Date"; Date)
        {
            // cleaned
        }
        field(50512; "Update Time"; Time)
        {
            // cleaned
        }
        field(50513; "Update By"; Code[50])
        {
            Description = '//20';
        }
        field(50514; "Saved Expected Receipt Date"; Date)
        {
            Editable = false;
        }
        field(50515; "Next Receipt Seq. No."; Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(50516; "Save Posting Date"; Date)
        {
            Editable = true;
        }
        field(50517; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
        }
        field(50527; "Purchaser Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanced';
        }
        field(50530; "Previous Document Date"; Date)
        {
            // cleaned
        }
        field(50531; "Original Document No."; Code[20])
        {
            Description = '//20131215';
        }
        field(50532; Blocked; Boolean)
        {
            // cleaned
        }
        field(50533; "Original Line No."; Integer)
        {
            // cleaned
        }
        field(50534; "Requested Receipt Date_1"; Date)
        {

        }
        field(50535; "Reporting Receipt Date"; Date)
        {
            Description = 'CS013';
        }
        field(50536; "Use Expected Receipt Date"; Boolean)
        {
            Description = 'CS013';
        }
        field(50550; "Line Amount to receive"; Decimal)
        {
            Caption = 'Line Amount to receive';
            Description = 'SKHE20121011';
            Editable = true;

        }
    }
}
