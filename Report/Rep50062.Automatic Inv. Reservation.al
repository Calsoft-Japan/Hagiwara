report 50062 "Automatic Inv. Reservation"
{
    // CS018 Leon 2021/06/03 - Enhancement of Inventory Availability List

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = SORTING("No.", "Shipment Date", "Document No.")
                                ORDER(Ascending)
                                WHERE("Document Type" = CONST(Order),
                                      Type = CONST(Item),
                                      Reserve = CONST(Always),
                                      "Fully Reserved" = CONST(false));

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                Item: Record Item;
                ItemTrackingCode: Record "Item Tracking Code";
                ReservDays: Text;
                AutoRevDate: Date;
                ReservMgt: Codeunit "Reservation Management";
                ReserveSalesLine: Codeunit "Sales Line-Reserve";
                QtyToReserve: Decimal;
                QtyToReserveBase: Decimal;
                FullAutoReservation: Boolean;
                i: Integer;
                ValueArrayNo: Integer;
                StopReservation: Boolean;
            begin
                Customer.RESET;
                //Customer.SETRANGE("No.", "Sell-to Customer No.");
                Customer.GET("Sell-to Customer No.");
                EVALUATE(ReservDays, FORMAT(Customer."Days for Auto Inv. Reservation"));
                AutoRevDate := CALCDATE('<+' + ReservDays + 'D>', WORKDATE);
                IF ("Sales Line"."Shipment Date" <> 0D) AND ("Sales Line"."Shipment Date" <= AutoRevDate) THEN BEGIN
                    "Sales Line".CALCFIELDS("Reserved Quantity", "Reserved Qty. (Base)");
                    ReserveSalesLine.ReservQuantity("Sales Line", QtyToReserve, QtyToReserveBase);
                    QtyToReserve := "Sales Line"."Outstanding Quantity" - "Sales Line"."Reserved Quantity";
                    QtyToReserveBase := "Sales Line"."Outstanding Qty. (Base)" - "Sales Line"."Reserved Qty. (Base)";

                    IF QtyToReserveBase <> 0 THEN BEGIN

                        /*NAV 2017
                        ReservMgt.SetSalesLine("Sales Line");
                        ReservMgt.SetOnlyItemLedger(TRUE);
                        ReservMgt.AutoReserve(FullAutoReservation, '', "Shipment Date", QtyToReserve, QtyToReserveBase);
                        */

                        ReservMgt.SetReservSource("Sales Line");

                        Item.get("Sales Line"."No.");
                        if Item."Item Tracking Code" <> '' then
                            ItemTrackingCode.Get(Item."Item Tracking Code")
                        else
                            ItemTrackingCode.Init();

                        if (QtyToReserveBase <> 0) and
                           ItemTrackingCode."SN Specific Tracking"
                        then
                            QtyToReserveBase := 1;

                        for i := 1 to SetValueArray() do
                            ReservMgt.AutoReserveOneLine(ValueArray[i], QtyToReserve, QtyToReserveBase, '', "Shipment Date");

                        FullAutoReservation := (QtyToReserveBase = 0);

                        IF NOT FullAutoReservation THEN BEGIN
                            "Sales Line"."Fully Reserved" := FALSE;
                            //COMMIT; //why commit here? change to modify.
                            Modify();
                        END
                        ELSE BEGIN
                            "Sales Line"."Fully Reserved" := TRUE;
                            MODIFY();
                        END;
                    END
                    ELSE BEGIN
                        "Sales Line".VALIDATE("Outstanding Qty. (Base)");
                        "Sales Line"."Fully Reserved" := "Sales Line"."Reserved Quantity" = "Sales Line"."Outstanding Quantity";
                        MODIFY();
                    END;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
    local procedure SetValueArray() ArrayCounter: Integer
    var
        IsHandled: Boolean;
    begin

        ValueArray[1] := Enum::"Reservation Summary Type"::"Item Ledger Entry".AsInteger();
        ArrayCounter := 1;
    end;

    var

        ValueArray: array[30] of Integer;

}

