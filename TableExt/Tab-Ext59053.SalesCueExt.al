tableextension 59053 "Sales Cue Ext" extends "Sales Cue"
{
    fields
    {
        field(50001; "Fully Shipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order),
                                                    Status = FILTER(Released),
                                                    Ship = FILTER(TRUE),
                                                    "Completely Shipped" = FILTER(TRUE),
                                                    "Responsibility Center" = FIELD("Responsibility Center Filter")));
            Caption = 'Partially Shipped';
            Editable = false;
        }
    }
}
