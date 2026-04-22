table 50080 "ORE Rev. Rout. Address Setup"
{
    // CS116 Shawn 2025/12/29 One Renesas EDI V2


    fields
    {
        field(1;"Report Reverse Routing Address";Code[40])
        {
        }
        field(2;"Sold-to Code";Code[35])
        {
        }
        field(3;"Ship&Debit Flag";Boolean)
        {
        }
        field(4;"Renesas Category Code";Code[20])
        {
            TableRelation = "ORE Renesas Category".Code;
        }
        field(5;"Currency Code";Code[10])
        {
        }
        field(6;"Report Sold-to Code";Code[35])
        {
        }
        field(7;"Order Reverse Routing Address";Code[40])
        {
        }
    }

    keys
    {
        key(Key1;"Report Reverse Routing Address","Sold-to Code","Ship&Debit Flag","Renesas Category Code","Currency Code","Report Sold-to Code","Order Reverse Routing Address")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

