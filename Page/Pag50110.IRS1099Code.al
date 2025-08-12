page 50110 "IRS 1099 Code"
{
    PageType = List;
    SourceTable = "IRS 1099 Code";
    ApplicationArea = All;
    UsageCategory = Administration;//
    //Editable = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code") { }
                field("Description"; Rec."Description") { }
            }
        }
    }
}