report 50123 "ORE Send Message Auto V2"
{
    // CS116 Shawn 2025/12/29 - One Renesas EDI V2

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
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
        ORESendMessage."Send Message_ALL"();
        //MESSAGE('Send message all completed');
    end;

    var
        ORESendMessage: Codeunit "ORE Send Message V2";
}

