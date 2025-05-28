tableextension 50091 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000;"Show Incoterm Code";Boolean)
        {
            Caption = 'Show Incoterm Code';
            Description = 'HG10.00.04 NJ 13/02/2018';
        }
        field(50010;"Allow ITE Collect";Boolean)
        {
            Description = 'CS082';
        }
        field(50011;"Allow ITE Delete";Boolean)
        {
            Description = 'CS082';
        }
        field(50012;"Allow Reset ITE Collected Flag";Boolean)
        {
            Description = 'CS082';
        }
        field(50013;"Allow ITE Update Price";Boolean)
        {
            Description = 'CS082';
        }
        field(50014;"Sales Order Post";Option)
        {
            Description = 'CS099';
            InitValue = "Ship and Invoice";
            OptionMembers = Ship,Invoice,"Ship and Invoice";
        }
        field(50015;"Sales Return Order Post";Option)
        {
            Description = 'CS099';
            InitValue = "Receive and Invoice";
            OptionMembers = Receive,Invoice,"Receive and Invoice";
        }
        field(50016;"Purchase Order Post";Option)
        {
            Description = 'CS099';
            InitValue = "Receive and Invoice";
            OptionMembers = Receive,Invoice,"Receive and Invoice";
        }
        field(50017;"Purchase Return Order Post";Option)
        {
            Description = 'CS099';
            InitValue = "Ship and Invoice";
            OptionMembers = Ship,Invoice,"Ship and Invoice";
        }
    }
}
