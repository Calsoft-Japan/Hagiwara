tableextension 50115 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50011; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50012; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50013; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50020; "OEM No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("Customer Type" = CONST(OEM));
            // cleaned
        }
        field(50021; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50539; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            Description = '//20121203 Enhanceents';
        }
    }
}
