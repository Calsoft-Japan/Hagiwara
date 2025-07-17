pageextension 59305 SalesOrderListExt extends "Sales Order List"
{
    layout
    {

        addafter("No.")
        {
            field("Order Date"; rec."Order Date")
            {

                ApplicationArea = all;
            }

        }

        addafter("Sell-to Customer Name")
        {

            field("Item Supplier Source"; rec."Item Supplier Source")
            {

                ApplicationArea = all;
            }
            field("OEM No."; rec."OEM No.")
            {

                ApplicationArea = all;
            }
            field("OEM Name"; rec."OEM Name")
            {

                ApplicationArea = all;
            }
            field(Ship; rec.Ship)
            {

                ApplicationArea = all;
            }
            field("Order Count"; rec."Order Count")
            {

                ApplicationArea = all;
            }
            field("Full Shipped Count"; rec."Full Shipped Count")
            {

                ApplicationArea = all;
            }
            field("Qty Invoiced"; rec."Qty Invoiced")
            {

                ApplicationArea = all;
            }
            field("Qty Ordered"; rec."Qty Ordered")
            {

                ApplicationArea = all;
            }
            field("Qty Shipped"; rec."Qty Shipped")
            {

                ApplicationArea = all;
            }
            field("Qty Outstanding (Actual)"; rec."Qty Outstanding (Actual)")
            {

                ApplicationArea = all;
            }

        }

        addafter("Posting Date")
        {

            field("Amount(LCY)"; Amount_LCY)
            {

                ApplicationArea = all;
            }
            field("Message Status(Booking)"; rec."Message Status(Booking)")
            {

                ApplicationArea = all;
            }
            field("Message Collected On(Booking)"; rec."Message Collected On(Booking)")
            {

                ApplicationArea = all;
            }
        }

        addafter("Package Tracking No.")
        {
            field("Shipment Tracking Date"; rec."Shipment Tracking Date")
            {

                ApplicationArea = all;
            }
        }

    }
    actions
    {
        addafter("AttachAsPDF")
        {
            action("DeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Delivery Order List';
                Image = PrintDocument;
                Scope = Repeater;
                trigger OnAction()
                var
                    DeliveryOrderList: Report "Delivery Order List";

                begin
                    Report.Run(50044, TRUE, FALSE, Rec);
                    //DeliveryOrderList.Run();
                end;
            }
            action("ExportDeliveryOrderList")
            {
                ApplicationArea = all;
                Caption = 'Export Delivery Order List';
                Image = Export;
                Scope = Repeater;

                trigger OnAction()
                var
                    DeliveryOrderList: Report 50044;
                begin

                end;
            }
            action("ProformaInvoice")
            {
                ApplicationArea = all;
                Caption = 'Proforma Invoice ';
                Image = PrintDocument;
                Scope = Repeater;

                trigger OnAction()
                var
                    ProformaInvoice: Report "Proforma Invoice";
                begin
                    //Report.Run(50066, TRUE, FALSE, Rec);
                    ProformaInvoice.Run();
                end;
            }
        }

        addafter("AttachAsPDF_Promoted")
        {
            actionref("DeliveryOrderList_Promoted"; DeliveryOrderList)
            {
            }
            actionref("ExportDeliveryOrderList_Promoted"; ExportDeliveryOrderList)
            {
            }
            actionref("ProformaInvoice_Promoted"; ProformaInvoice)
            {
            }
        }
    }
    var
        Amount_LCY: Decimal;

    trigger OnAfterGetRecord()
    begin

        //SiakHui  20141001 Start
        IF rec."Currency Factor" > 0 THEN BEGIN
            Amount_LCY := ROUND(rec.Amount / rec."Currency Factor");
        END ELSE BEGIN
            Amount_LCY := rec.Amount;
        END;
        //SiakHui  20141001 Start

    end;

}
