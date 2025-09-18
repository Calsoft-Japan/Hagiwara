pageextension 58625 ConfigPackageSubformExt extends "Config. Package Subform"
{
    // CS092 FDD DE01 9/9/2025 Bobby.ji Upgrade to BC version
    layout
    {
        addafter("Delayed Insert")
        {
            field("Export Field Name"; Rec."Export Field Name")
            {
                ApplicationArea = all;
            }
        }
    }
}