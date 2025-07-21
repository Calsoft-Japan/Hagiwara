page 50013 "Control Master List"
{
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
                }
                field("File ID"; Rec."File ID")
                {
                }
                field("Detail File ID"; Rec."Detail File ID")
                {
                }
                field("Record Number"; Rec."Record Number")
                {
                }
                field("Pos/Neg Class (Quantity)"; Rec."Pos/Neg Class (Quantity)")
                {
                }
                field("Amount Quantity"; Rec."Amount Quantity")
                {
                }
                field("Pos/Neg Class (Price)"; Rec."Pos/Neg Class (Price)")
                {
                }
                field("Amount Price"; Rec."Amount Price")
                {
                }
                field("Statics Date"; Rec."Statics Date")
                {
                }
                field("Order Backlog Date"; Rec."Order Backlog Date")
                {
                }
                field(Preliminaries; Rec.Preliminaries)
                {
                }
                field("Message Status"; Rec."Message Status")
                {
                }
                field("Collected By"; Rec."Collected By")
                {
                }
                field("Collected On"; Rec."Collected On")
                {
                }
                field("File Sent By"; Rec."File Sent By")
                {
                }
                field("File Sent On"; Rec."File Sent On")
                {
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
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    RunObject = Report "PSI Initialiaztion";
                    ShortCutKey = 'F2';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
                    end;
                }
                action("Collect  PSI")
                {
                    Caption = 'Collect  PSI';
                    Image = UpdateShipment;
                    Promoted = true;
                    RunObject = Report "Collect Message";
                    ShortCutKey = 'F3';

                    trigger OnAction()
                    var
                        PageID: Integer;
                    begin
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

