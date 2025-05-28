tableextension 56661 "Return Receipt Line Ext" extends "Return Receipt Line"
{
    fields
    {
        field(50011;"Customer Item No.";Code[20])
        {
            // cleaned
        }
        field(50012;"Parts No.";Code[40])
        {
            // cleaned
        }
        field(50013;Rank;Code[15])
        {
            Description = '//Siak ask to change it from 10 to 15';
        }
        field(50014;Products;Text[20])
        {
            // cleaned
        }
        field(50015;"Salesperson Code";Code[10])
        {
            Description = '//20121203';
        }
    }
}
