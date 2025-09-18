pageextension 58624 ConfigPackageFieldsExt extends "Config. Package Fields"
{
    // CS092 FDD DE01 9/9/2025 Bobby.ji Upgrade to BC version
    layout
    {
        addafter("Mapping Exists")
        {
            field("Export Field Name"; Rec."Export Field Name")
            {
                ApplicationArea = all;
            }
        }
    }
}