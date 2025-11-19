pageextension 50609 "ICPartnerCardExt" extends "IC Partner Card"
{

    layout
    {
        addafter("Data Exchange Type")
        {
            field("IC Transaction Partner Email"; Rec."IC Transaction Partner Email")
            {
                ApplicationArea = all;
            }

        }
    }
}
