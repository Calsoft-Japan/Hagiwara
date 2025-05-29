tableextension 56651 "Return Shipment Line Ext" extends "Return Shipment Line"
{
    fields
    {
        field(50010; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50011; "Parts No."; Code[30])
        {
            // cleaned
        }
        field(50012; Rank; Code[15])
        {
            Description = '//Siak ask to change it from 10 to 15';
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50015; "Purchaser Code"; Code[10])
        {
            Description = '//20121203';
        }
    }
}
