tableextension 58623 ConfigPackageExt extends "Config. Package"
{
    // CS092 FDD DE01 9/12/2025 Bobby.ji Upgrade to BC version
    fields
    {
        field(50000; "DTD File Name"; code[50])
        {
            Caption = 'DTD File Name';
        }
        field(50001; "DTD File"; Blob)
        {
            Caption = 'DTD File';
        }
    }
}
