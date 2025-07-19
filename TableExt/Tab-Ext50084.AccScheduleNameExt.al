tableextension 50084 "Acc. Schedule Name Ext" extends "Acc. Schedule Name"
{
    fields
    {
        field(50000; "Left Start Line Number"; Integer)
        {
            Caption = 'Left Start Line Number';
            Description = 'ACWSH';
            TableRelation = "Acc. Schedule Line"."Line No." WHERE("Schedule Name" = FIELD(Name));
        }
        field(50001; "Left End Line Number"; Integer)
        {
            Caption = 'Left End Line Number';
            Description = 'ACWSH';
            TableRelation = "Acc. Schedule Line"."Line No." WHERE("Schedule Name" = FIELD(Name));
        }
        field(50002; "Right Start Line Number"; Integer)
        {
            Caption = 'Right Start Line Number';
            Description = 'ACWSH';
            TableRelation = "Acc. Schedule Line"."Line No." WHERE("Schedule Name" = FIELD(Name));
        }
        field(50003; "Right End Line Number"; Integer)
        {
            Caption = 'Right End Line Number';
            Description = 'ACWSH';
            TableRelation = "Acc. Schedule Line"."Line No." WHERE("Schedule Name" = FIELD(Name));
        }
        field(50004; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            Description = 'ACWSH';
        }
        field(50005; Remarks; Text[250])
        {
            Caption = 'Remarks';
            Description = 'ACWSH';
        }
    }
}
