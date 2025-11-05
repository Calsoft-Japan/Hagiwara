pageextension 50609 "ICPartnerCardExt" extends "IC Partner Card"
{

    layout
    {
        addafter("Data Exchange Type")
        {
            field("IC Transaction Partner Contact"; Rec."IC Transaction Partner Contact")
            {
                ApplicationArea = all;
            }

        }
    }
}
