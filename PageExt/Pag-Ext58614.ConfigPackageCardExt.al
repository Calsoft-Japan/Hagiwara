pageextension 58614 ConfigPackageCardExt extends "Config. Package Card"
{
    // CS092 FDD DE01 9/15/2025 Bobby.ji Upgrade to BC version
    layout
    {
        addafter("Exclude Config. Tables")
        {
            field("DTD File Name"; Rec."DTD File Name")
            {
                ApplicationArea = all;
            }
        }
    }
}