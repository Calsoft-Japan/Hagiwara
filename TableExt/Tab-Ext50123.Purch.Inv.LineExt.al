tableextension 50123 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{
    fields
    {
        field(50010; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50011; "Parts No."; Code[40])
        {
            Description = '//20110427';
        }
        field(50012; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50016; "SO No."; Code[30])
        {
            // cleaned
        }
        field(50063; "Goods Arrival Date"; Date)
        {
            Description = '//20180109 by SS';
        }
        field(50502; "CO No."; Code[6])
        {
            Description = '//20101009';
            Editable = false;
        }
        field(50527; "Purchaser Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanced';
        }
    }
}
