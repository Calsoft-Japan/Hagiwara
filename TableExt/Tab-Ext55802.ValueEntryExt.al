tableextension 55802 "Value Entry Ext" extends "Value Entry"
{
    fields
    {
        field(50000; "Item Description"; Text[80])
        {
            // cleaned
        }
        field(50001; "Customer Item No."; Code[50])
        {
            // cleaned
        }
        field(50002; "Customer No."; Code[10])
        {
            Description = 'CS030';
        }
        field(50003; "Vendor No."; Code[10])
        {
            Description = 'CS030';
        }
        field(50004; "Manufacturer Code"; Code[10])
        {
            Description = 'CS030';
        }
        field(50005; "Customer Name"; Text[50])
        {
            Description = 'CS030';
        }
        field(50006; "Vendor Name"; Text[50])
        {
            Description = 'CS030';
        }
        field(50007; "Customer Familiar Name"; Code[20])
        {
            Description = 'CS030';
        }
        field(50008; "Vendor Familiar Name"; Code[20])
        {
            Description = 'CS030';
        }
    }
}
