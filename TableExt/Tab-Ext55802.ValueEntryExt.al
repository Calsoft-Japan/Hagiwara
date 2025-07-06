tableextension 55802 "Value Entry Ext" extends "Value Entry"
{
    fields
    {
        /* field(50000; "Item Description"; Text[80])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            // cleaned
        } */
        field(50001; "Customer Item No."; Code[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Customer Item No." WHERE("No." = FIELD("Item No.")));
            // cleaned
        }
        field(50002; "Customer No."; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Customer No." WHERE("No." = FIELD("Item No.")));
            Description = 'CS030';
        }
        field(50003; "Vendor No."; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Vendor No." WHERE("No." = FIELD("Item No.")));
            Description = 'CS030';
        }
        field(50004; "Manufacturer Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Manufacturer Code" WHERE("No." = FIELD("Item No.")));
            Description = 'CS030';
        }
        field(50005; "Customer Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Description = 'CS030';
        }
        field(50006; "Vendor Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Description = 'CS030';
        }
        field(50007; "Customer Familiar Name"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer."Familiar Name" WHERE("No." = FIELD("Customer No.")));
            Description = 'CS030';
        }
        field(50008; "Vendor Familiar Name"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor."Familiar Name" WHERE("No." = FIELD("Vendor No.")));
            Description = 'CS030';
        }
    }
}
