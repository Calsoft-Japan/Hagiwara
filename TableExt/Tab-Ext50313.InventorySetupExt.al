tableextension 50313 "Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        field(50000;"Max. PO Quantity Restriction";Boolean)
        {
            // cleaned
        }
        field(50001;"Supplier Item Source";Code[20])
        {
            Description = '//20101009';
        }
        field(50002;"Booking Serial Nos.";Code[10])
        {
            Caption = 'Serial Nos.';
        }
        field(50003;"Sales Backlog Cutoff Date";Date)
        {
            // cleaned
        }
        field(50010;"Enable Inventory Trace";Boolean)
        {
            Description = 'CS082';
        }
        field(50011;"Enable Multicompany Trace";Boolean)
        {
            Description = 'CS082';
        }
        field(50012;"ITE Start Date";Date)
        {
            Description = 'CS082';
        }
        field(50013;"ITE End Date";Date)
        {
            Description = 'CS082';
        }
        field(50014;"ITE Item No. Filter";Text[250])
        {
            Description = 'CS082';
        }
        field(50015;"ITE Manufacturer Code Filter";Text[250])
        {
            Description = 'CS082';
        }
    }
}
