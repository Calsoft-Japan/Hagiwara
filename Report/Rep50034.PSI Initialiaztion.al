report 50034 "PSI Initialiaztion"
{
    // 1. PSI Iniialiaztion Job: To replace Report 50062 & 50061 (Siak Hui- 3 Nov 2012)

    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {

            trigger OnAfterGetRecord()
            begin
                "Outstanding Quantity (Actual)" := "Outstanding Quantity";
                MODIFY;
            end;

            trigger OnPostDataItem()
            begin
                dt_ProcessDate := TODAY;
                dt_EndDate := 20991231D;
                ShptLine.SETRANGE("Posting Date", dt_ProcessDate + 1, dt_EndDate);
                ShptLine.SETFILTER(ShptLine.Quantity, '<>%1', 0);
                ShptLine.SETFILTER(ShptLine.Type, '=%1', ShptLine.Type::Item);
                ShptLine.SETFILTER(ShptLine."Item Supplier Source", '=%1', ShptLine."Item Supplier Source"::Renesas);
                ShptLine.SETFILTER(ShptLine.Correction, '=%1', FALSE);

                g_Count := 0;


                IF ShptLine.FINDSET THEN
                    REPEAT
                        IF ShptLine."Posting Date" > dt_ProcessDate THEN BEGIN
                            IF SalesLine.GET(SalesLine."Document Type"::Order, ShptLine."Order No.", ShptLine."Line No.") THEN BEGIN
                                g_Count := g_Count + 1;
                                IF SalesLine."PSI Process Date" <> dt_ProcessDate THEN BEGIN
                                    SalesLine."Outstanding Quantity (Actual)" := SalesLine."Outstanding Quantity" + ShptLine.Quantity;
                                    SalesLine."PSI Process Date" := dt_ProcessDate;
                                END ELSE BEGIN
                                    SalesLine."Outstanding Quantity (Actual)" := SalesLine."Outstanding Quantity (Actual)" + ShptLine.Quantity;
                                END;
                                SalesLine.MODIFY;
                            END;
                        END;
                    UNTIL ShptLine.NEXT = 0;

                IF g_Count = 0 THEN BEGIN
                    MESSAGE('There is No Advance Shipment Data to Process');
                END;

                IF g_Count > 0 THEN BEGIN
                    MESSAGE(Text002, g_Count);
                END;

                GRec_GLSetup."PSI Job Status" := '1';
                GRec_GLSetup.MODIFY;
            end;

            trigger OnPreDataItem()
            begin
                SETFILTER("Outstanding Quantity (Actual)", '>%1', 0);
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

    trigger OnInitReport()
    begin
        g_Count := 0;
        dt_ProcessDate := TODAY;
        GRec_GLSetup.GET;

        IF GRec_GLSetup."PSI Job Status" = '3' THEN BEGIN
            IF CONFIRM('Do you want to compute actual Sales Order Backlog?', TRUE) THEN BEGIN
                ;
            END ELSE BEGIN
                ERROR('The Job is aborted!');
                EXIT;
            END;
        END;

        IF GRec_GLSetup."PSI Job Status" = '2' THEN BEGIN
            IF GRec_GLSetup."Daily PSI Data Collection" = '0' THEN BEGIN
                ERROR('Daily PSI not collected yet');
            END;
        END;

        IF GRec_GLSetup."PSI Job Status" = '2' THEN BEGIN
            IF GRec_GLSetup."Monthly PSI Data Collection" = '0' THEN BEGIN
                ERROR('Monthly PSI not collected yet');
            END;
        END;

        IF GRec_GLSetup."PSI Job Status" = '2' THEN
            ERROR('PSI Data not sent yet');

        IF GRec_GLSetup."PSI Job Status" = '1' THEN BEGIN
            IF CONFIRM('PSI Initialization already done, you want to run the job again?', TRUE) THEN BEGIN
                ;
            END ELSE BEGIN
                ERROR('The Job is aborted!');
                EXIT;
            END;
        END;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        ShptHdr: Record "Sales Shipment Header";
        g_SerialNo: Integer;
        SalesHdr: Record "Sales Header";
        SalesLine: Record "Sales Line";
        g_Flag: Code[3];
        dt_RefDate: Date;
        dt_EndDate: Date;
        g_Count: Integer;
        dt_ProcessDate: Date;
        GRec_GLSetup: Record "General Ledger Setup";
        Text001: Label 'Do you want to run this job again?';
        Text002: Label 'There are %1 Adance Shipment updated! ';
        g_Repeat: Boolean;
        ShptLine: Record "Sales Shipment Line";
}

