tableextension 50111 "Sales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(50000;"Order Date";Date)
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50010;"Customer Order No.";Text[35])
        {
            Description = '//30';
        }
        field(50011;"Customer Item No.";Code[20])
        {
            // cleaned
        }
        field(50012;"Parts No.";Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50013;Rank;Code[15])
        {
            // cleaned
        }
        field(50014;Products;Text[20])
        {
            // cleaned
        }
        field(50020;"OEM No.";Code[20])
        {
            // cleaned
        }
        field(50021;"OEM Name";Text[50])
        {
            // cleaned
        }
        field(50500;"Shipment Seq. No.";Integer)
        {
            Editable = false;
        }
        field(50501;"Item Supplier Source";Option)
        {
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;
            
        }
        field(50502;"Post Shipment Collect Flag";Integer)
        {
            // cleaned
        }
        field(50510;"Message Status";Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
            
        }
        field(50511;"Update Date";Date)
        {
            // cleaned
        }
        field(50512;"Update Time";Time)
        {
            // cleaned
        }
        field(50513;"Update By";Code[50])
        {
            Description = '//20';
        }
        field(50516;"Save Posting Date";Date)
        {
            // cleaned
        }
        field(50517;"Serial No.";Integer)
        {
            BlankZero = true;
        }
        field(50518;"Booking No.";Code[20])
        {
            // cleaned
        }
        field(50519;"No. Series";Code[10])
        {
            // cleaned
        }
        field(50527;"Salespersonm Code";Code[10])
        {
            // cleaned
        }
        field(50530;Insertion;Boolean)
        {
            Description = '//20111104 for PSI JA Maintenance';
            
        }
        field(50531;Edition;Boolean)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50532;"Original Quantity";Decimal)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50533;"Edit Count";Integer)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50534;"Prev Quantity";Decimal)
        {
            Description = '//20111104 for PSI JA Maintenance';
        }
        field(50536;"Shipment Collection Date";Date)
        {
            // cleaned
        }
        field(50539;"Salesperson Code";Code[10])
        {
            Description = '//20121203 Enhanceents';
        }
        field(50540;"Original Doc. No.";Code[20])
        {
            // cleaned
        }
        field(50541;Blocked;Boolean)
        {
            // cleaned
        }
        field(50542;"Original Booking No.";Code[20])
        {
            // cleaned
        }
        field(50543;"Original Line No.";Integer)
        {
            // cleaned
        }
        field(50544;"External Document No.";Code[35])
        {
            Description = '//CS077';
        }
    }
}
