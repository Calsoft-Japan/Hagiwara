tableextension 50257 "VAT Statement Name Ext" extends "VAT Statement Name"
{
    fields
    {
        field(50001; "File Name"; Text[100])
        {
            Caption = 'File Name';
            Description = 'SKLV6.0';
        }
        field(50002; Attachment; BLOB)
        {
            Caption = 'Attachment';
            Description = 'SKLV6.0';
        }
    }
}
