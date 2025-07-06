table 50062 "Zu löschenden Tabellen"
{
    fields
    {
        field(1; "Tabelle ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
            // cleaned
        }
        field(2; Tabellenname; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object ID" = field("Tabelle ID")));
            // cleaned
        }
    }
}
