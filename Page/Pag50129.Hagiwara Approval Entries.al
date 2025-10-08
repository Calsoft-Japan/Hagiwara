page 50129 "Hagiwara Approval Entries"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Approval Entry";

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
                field(Data; Rec.Data)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = all;
                }
                field("Request Group"; Rec."Request Group")
                {
                    ApplicationArea = all;
                }
                field(Approver; Rec.Approver)
                {
                    ApplicationArea = all;
                }
                field("Approval Group"; Rec."Approval Group")
                {
                    ApplicationArea = all;
                }
                field("Approval Sequence No."; Rec."Approval Sequence No.")
                {
                    ApplicationArea = all;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Comment; CommentText)
                {
                    ApplicationArea = all;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = all;
                }
                field("Close Date"; Rec."Close Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CommentText := Rec.GetComment();
    end;

    var
        CommentText: BigText;
}

