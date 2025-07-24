page 50013 "Message Control List"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Maintenance,Revision';
    SourceTable = "Message Control";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("File ID"; Rec."File ID")
                {
                    ApplicationArea = all;
                }
                field("Detail File ID"; Rec."Detail File ID")
                {
                    ApplicationArea = all;
                }
                field("Record Number"; Rec."Record Number")
                {
                    ApplicationArea = all;
                }
                field("Pos/Neg Class (Quantity)"; Rec."Pos/Neg Class (Quantity)")
                {
                    ApplicationArea = all;
                }
                field("Amount Quantity"; Rec."Amount Quantity")
                {
                    ApplicationArea = all;
                }
                field("Pos/Neg Class (Price)"; Rec."Pos/Neg Class (Price)")
                {
                    ApplicationArea = all;
                }
                field("Amount Price"; Rec."Amount Price")
                {
                    ApplicationArea = all;
                }
                field("Statics Date"; Rec."Statics Date")
                {
                    ApplicationArea = all;
                }
                field("Order Backlog Date"; Rec."Order Backlog Date")
                {
                    ApplicationArea = all;
                }
                field(Preliminaries; Rec.Preliminaries)
                {
                    ApplicationArea = all;
                }
                field("Message Status"; Rec."Message Status")
                {
                    ApplicationArea = all;
                }
                field("Collected By"; Rec."Collected By")
                {
                    ApplicationArea = all;
                }
                field("Collected On"; Rec."Collected On")
                {
                    ApplicationArea = all;
                }
                field("File Sent By"; Rec."File Sent By")
                {
                    ApplicationArea = all;
                }
                field("File Sent On"; Rec."File Sent On")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("PSI Process")
            {
                Caption = 'PSI Process';
                Image = Line;
                action("Initialize PSI")
                {
                    Caption = 'Initialize PSI';
                    Image = CalculateShipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "PSI Initialiaztion";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Collect Message")
                {
                    Caption = 'Collect  Message';
                    Image = UpdateShipment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Collect Message";

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Cancel Message")
                {
                    Caption = 'Cancel Message';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RepCancelMsg: report "Cancel Message";
                    begin
                        if rec."Message Status" <> rec."Message Status"::Ready then begin
                            Error('You cannot cancel the message. Only records in Ready status can be canceled.');
                        end;

                        if Confirm('Do you want to cancel the message?', false) then begin
                            RepCancelMsg.CancelMessage(Rec);
                            CurrPage.UPDATE();
                        end;

                    end;
                }
                /* This will be replaced by API
                action("Send PSI")
                {
                    Caption = 'Send PSI';
                    Image = TransferOrder;
                    Promoted = true;
                    RunObject = Report 50024;
                    ShortCutKey = 'Shift+F3';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }*/
            }

            /* removed when BC.
            group("PSI Maintenance")
            {
                Caption = 'PSI Maintenance';
                Image = Line;
                action("Backup PSI Data")
                {
                    Caption = 'Backup PSI Data';
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Report 50080;
                    ShortCutKey = 'Shift+F8';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Delete Backup PSI")
                {
                    Caption = 'Delete Backup PSI';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Report 50081;
                    ShortCutKey = 'F4';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Delete Control PSI")
                {
                    Caption = 'Delete Control PSI';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Report 50083;
                    ShortCutKey = 'Shift+F4';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
            }
            group("PSI Revision")
            {
                Caption = 'PSI Revision';
                Image = Line;
                action("Collect Revised JC")
                {
                    Caption = 'Collect Revised JC';
                    Image = UpdateShipment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Report 50036;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Collect Revised JA & JC")
                {
                    Caption = 'Collect Revised JA & JC';
                    Image = UpdateShipment;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Report 50037;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
            }*/
        }
        area(reporting)
        {
        }
    }
}

