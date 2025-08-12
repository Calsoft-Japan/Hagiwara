query 50013 "Inv Val Rep with Loc & Date"
{

    elements
    {
        dataitem(ValueEntry; "Value Entry")
        {
            filter(Posting_Date; "Posting Date")
            {
            }
            filter(ItemNo; "Item No.")
            {
            }
            filter(LocationCode; "Location Code")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Sum_Cost_Actual; "Cost Amount (Actual)")
            {
                Method = Sum;
            }
        }
    }
}

